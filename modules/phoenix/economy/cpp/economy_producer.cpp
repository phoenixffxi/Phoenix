#include "economy_producer.h"

#include <concurrentqueue.h>
#include <openssl/rand.h>
#include <openssl/sha.h>
#include <zlib.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <cctype>
#include <charconv>
#include <chrono>
#include <condition_variable>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <filesystem>
#include <limits>
#include <mutex>
#include <string>
#include <thread>
#include <utility>
#include <vector>

#ifdef _WIN32
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <Windows.h>
#else
#include <cerrno>
#include <fcntl.h>
#include <unistd.h>
#endif

namespace phoenix::economy
{
namespace
{

using SteadyClock = std::chrono::steady_clock;

constexpr std::size_t   MaxUncompressedBatchBytes = 1024 * 1024;
constexpr std::uint64_t MinHardCapBytes           = 4096;
constexpr std::uint64_t MinControlReserveBytes    = 1024;
constexpr std::size_t   MaxQueueCapacity          = 1024 * 1024;
constexpr auto          WorkerPollInterval        = std::chrono::milliseconds(10);

#ifdef PHOENIX_ECONOMY_TESTING
thread_local std::uint64_t recordQueueAllocationCalls{};
#endif

struct RecordQueueTraits : moodycamel::ConcurrentQueueDefaultTraits
{
    // Tokenless production is deliberately unavailable. This both enforces the
    // one-map-thread design and avoids an implicit producer's first-use allocation.
    static constexpr std::size_t INITIAL_IMPLICIT_PRODUCER_HASH_SIZE = 0;

    static auto malloc(std::size_t size) -> void*
    {
#ifdef PHOENIX_ECONOMY_TESTING
        ++recordQueueAllocationCalls;
#endif
        return std::malloc(size);
    }

    static void free(void* pointer)
    {
        std::free(pointer);
    }
};

enum class RunState : std::uint8_t
{
    Disabled,
    Running,
    Stopping,
};

enum class ErrorCode : std::uint8_t
{
    None,
    InvalidConfiguration,
    WorkerStartFailed,
    SpoolDirectoryFailure,
    SerializeFailure,
    CompressFailure,
    SpoolCapacity,
    SpoolWriteFailure,
};

enum class GapReason : std::uint8_t
{
    QueueOverflow,
    SpoolCapacity,
    SpoolWriteFailure,
    SequenceDiscontinuity,
};

enum class PersistResult : std::uint8_t
{
    Written,
    Capacity,
    Failed,
};

enum class DurableWriteResult : std::uint8_t
{
    Durable,
    VisibleDirectorySyncUncertain,
    Failed,
};

struct Gap
{
    bool          active{};
    GapReason     reason{};
    std::int64_t  startUnixNanos{};
    std::int64_t  endUnixNanos{};
    std::uint64_t lostEventCount{};
    std::uint64_t ordinal{};
};

enum class RecordType : std::uint8_t
{
    Event,
    AttributionGap,
    ForgoneMint,
};

constexpr auto MaxRecordPayloadSize = sizeof(Event) > sizeof(AttributionGap) ? (sizeof(Event) > sizeof(ForgoneMint) ? sizeof(Event) : sizeof(ForgoneMint)) : (sizeof(AttributionGap) > sizeof(ForgoneMint) ? sizeof(AttributionGap) : sizeof(ForgoneMint));

struct QueuedRecord
{
    RecordType                                  type;
    std::array<std::byte, MaxRecordPayloadSize> payload;

    template <typename T>
    [[nodiscard]] static auto from(RecordType recordType, const T& value) noexcept -> QueuedRecord
    {
        static_assert(std::is_trivially_copyable_v<T>);
        QueuedRecord record;
        record.type = recordType;
        std::memcpy(record.payload.data(), &value, sizeof(T));
        return record;
    }

    template <typename T>
    [[nodiscard]] auto as() const noexcept -> T
    {
        static_assert(std::is_trivially_copyable_v<T>);
        T value;
        std::memcpy(&value, payload.data(), sizeof(T));
        return value;
    }
};

struct BatchCounts
{
    std::size_t events{};
    std::size_t attributionGaps{};
    std::size_t forgoneMints{};

    [[nodiscard]] auto controls() const noexcept -> std::size_t
    {
        return attributionGaps + forgoneMints;
    }

    [[nodiscard]] auto total() const noexcept -> std::size_t
    {
        return events + controls();
    }
};

static_assert(std::is_trivially_copyable_v<QueuedRecord>);

auto gapReasonName(GapReason reason) noexcept -> std::string_view
{
    switch (reason)
    {
        case GapReason::QueueOverflow:
            return "queue_overflow";
        case GapReason::SpoolCapacity:
            return "spool_capacity";
        case GapReason::SpoolWriteFailure:
            return "spool_write_failure";
        case GapReason::SequenceDiscontinuity:
            return "sequence_discontinuity";
    }
    return "spool_write_failure";
}

auto kindName(Kind kind) noexcept -> std::string_view
{
    switch (kind)
    {
        case Kind::Mint:
            return "mint";
        case Kind::Burn:
            return "burn";
        case Kind::Transfer:
            return "transfer";
    }
    return "mint";
}

auto categoryName(Category category) noexcept -> std::string_view
{
    switch (category)
    {
        case Category::MobDrop:
            return "mob_drop";
        case Category::Mug:
            return "mug";
        case Category::NpcVendorSale:
            return "npc_vendor_sale";
        case Category::GuildVendorSale:
            return "guild_vendor_sale";
        case Category::QuestReward:
            return "quest_reward";
        case Category::MissionReward:
            return "mission_reward";
        case Category::BattlefieldReward:
            return "battlefield_reward";
        case Category::RegimeReward:
            return "regime_reward";
        case Category::StartingGil:
            return "starting_gil";
        case Category::AdminGrant:
            return "admin_grant";
        case Category::ScriptReward:
            return "script_reward";
        case Category::OtherMint:
            return "other_mint";
        case Category::NpcShopPurchase:
            return "npc_shop_purchase";
        case Category::GuildShopPurchase:
            return "guild_shop_purchase";
        case Category::AuctionListingFee:
            return "auction_listing_fee";
        case Category::BazaarTax:
            return "bazaar_tax";
        case Category::ChocoboRental:
            return "chocobo_rental";
        case Category::TransportFee:
            return "transport_fee";
        case Category::QuestFee:
            return "quest_fee";
        case Category::ServiceFee:
            return "service_fee";
        case Category::CurrencyCapLoss:
            return "currency_cap_loss";
        case Category::AdminRemove:
            return "admin_remove";
        case Category::OtherBurn:
            return "other_burn";
        case Category::PlayerTrade:
            return "player_trade";
        case Category::BazaarSale:
            return "bazaar_sale";
        case Category::AuctionSale:
            return "auction_sale";
        case Category::DeliveryBox:
            return "delivery_box";
        case Category::OtherTransfer:
            return "other_transfer";
    }
    return "other_mint";
}

auto sourceTypeName(SourceType sourceType) noexcept -> std::string_view
{
    switch (sourceType)
    {
        case SourceType::Mob:
            return "mob";
        case SourceType::Npc:
            return "npc";
        case SourceType::Quest:
            return "quest";
        case SourceType::Mission:
            return "mission";
        case SourceType::Battlefield:
            return "battlefield";
        case SourceType::Regime:
            return "regime";
        case SourceType::Admin:
            return "admin";
        case SourceType::Script:
            return "script";
        case SourceType::System:
            return "system";
    }
    return "system";
}

auto attributionQualityName(AttributionQuality quality) noexcept -> std::string_view
{
    return quality == AttributionQuality::Semantic ? "semantic" : "correlated";
}

auto attributionDirectionName(AttributionDirection direction) noexcept -> std::string_view
{
    return direction == AttributionDirection::Credit ? "credit" : "debit";
}

auto evidenceTypeName(EvidenceType evidenceType) noexcept -> std::string_view
{
    switch (evidenceType)
    {
        case EvidenceType::LuaWallet:
            return "lua_wallet";
        case EvidenceType::WalletObserver:
            return "wallet_observer";
        case EvidenceType::PacketCorrelator:
            return "packet_correlator";
        case EvidenceType::NativePacket:
            return "native_packet";
        case EvidenceType::TransferReconciliation:
            return "transfer_reconciliation";
    }
    return "wallet_observer";
}

void appendQuoted(std::string& output, std::string_view value)
{
    output.push_back('"');
    output.append(value);
    output.push_back('"');
}

template <typename T>
void appendNumber(std::string& output, T value)
{
    std::array<char, std::numeric_limits<T>::digits10 + 4> buffer{};
    const auto                                             result = std::to_chars(buffer.data(), buffer.data() + buffer.size(), value);
    output.append(buffer.data(), result.ptr);
}

template <typename T>
void appendDecimalString(std::string& output, T value)
{
    output.push_back('"');
    appendNumber(output, value);
    output.push_back('"');
}

template <typename T>
void appendNullableNumber(std::string& output, const Nullable<T>& value)
{
    if (value.hasValue)
    {
        appendNumber(output, value.value);
    }
    else
    {
        output.append("null");
    }
}

auto timestamp(std::int64_t unixNanos) -> std::string
{
    const auto unixMillis = unixNanos / 1000000;
    const auto seconds    = static_cast<std::time_t>(unixMillis / 1000);
    const auto millis     = static_cast<unsigned>(unixMillis % 1000);
    std::tm    utc{};
#ifdef _WIN32
    gmtime_s(&utc, &seconds);
#else
    gmtime_r(&seconds, &utc);
#endif

    std::array<char, 32> buffer{};
    const auto           count = std::snprintf(buffer.data(), buffer.size(), "%04d-%02d-%02dT%02d:%02d:%02d.%03uZ", utc.tm_year + 1900, utc.tm_mon + 1, utc.tm_mday, utc.tm_hour, utc.tm_min, utc.tm_sec, millis);
    return { buffer.data(), static_cast<std::size_t>(count) };
}

void appendContext(std::string& output, SourceType sourceType, const SourceContext& context)
{
    output.push_back('{');
    auto needsComma = false;
    auto numeric    = [&](std::string_view key, const auto& value)
    {
        if (!value.hasValue)
        {
            return;
        }
        if (needsComma)
        {
            output.push_back(',');
        }
        appendQuoted(output, key);
        output.push_back(':');
        appendNumber(output, value.value);
        needsComma = true;
    };
    auto token = [&](std::string_view key, std::string_view value)
    {
        if (value.empty())
        {
            return;
        }
        if (needsComma)
        {
            output.push_back(',');
        }
        appendQuoted(output, key);
        output.push_back(':');
        appendQuoted(output, value);
        needsComma = true;
    };

    // Every per-source key is emitted in lexicographic order.
    switch (sourceType)
    {
        case SourceType::Mob:
            numeric("mobPoolId", context.mobPoolId);
            numeric("mobSpawnId", context.mobSpawnId);
            break;
        case SourceType::Npc:
            numeric("guildId", context.guildId);
            numeric("npcId", context.npcId);
            token("serviceKey", context.serviceKey.view());
            numeric("shopId", context.shopId);
            break;
        case SourceType::Quest:
            numeric("questId", context.questId);
            numeric("questLogId", context.questLogId);
            break;
        case SourceType::Mission:
            numeric("missionId", context.missionId);
            numeric("missionLogId", context.missionLogId);
            break;
        case SourceType::Battlefield:
            numeric("battlefieldId", context.battlefieldId);
            break;
        case SourceType::Regime:
            numeric("regimeId", context.regimeId);
            break;
        case SourceType::Admin:
            numeric("actorCharId", context.actorCharId);
            break;
        case SourceType::Script:
            token("scriptKey", context.scriptKey.view());
            break;
        case SourceType::System:
            token("systemKey", context.systemKey.view());
            break;
    }
    output.push_back('}');
}

void appendEvent(std::string& output, const Event& event)
{
    output.append("{\"amount\":");
    appendDecimalString(output, event.amount);
    output.append(",\"attributionQuality\":");
    appendQuoted(output, attributionQualityName(event.attributionQuality));
    output.append(",\"categoryKey\":");
    appendQuoted(output, categoryName(event.category));
    output.append(",\"contentVersion\":");
    appendQuoted(output, event.contentVersion.view());
    output.append(",\"context\":");
    appendContext(output, event.sourceType, event.context);
    output.append(",\"eventSeq\":");
    appendDecimalString(output, event.eventSeq);
    output.append(",\"evidenceVersion\":");
    appendQuoted(output, event.evidenceVersion.view());
    output.append(",\"fromCharId\":");
    appendNullableNumber(output, event.fromCharId);
    output.append(",\"itemId\":");
    appendNullableNumber(output, event.itemId);
    output.append(",\"itemQuantity\":");
    appendNullableNumber(output, event.itemQuantity);
    output.append(",\"kind\":");
    appendQuoted(output, kindName(event.kind));
    output.append(",\"occurredAt\":");
    appendQuoted(output, timestamp(event.occurredAtUnixNanos));
    output.append(",\"sourceKey\":");
    appendQuoted(output, event.sourceKey.view());
    output.append(",\"sourceType\":");
    appendQuoted(output, sourceTypeName(event.sourceType));
    output.append(",\"toCharId\":");
    appendNullableNumber(output, event.toCharId);
    output.append(",\"transactionId\":");
    appendQuoted(output, event.transactionId.view());
    output.append(",\"zoneId\":");
    appendNullableNumber(output, event.zoneId);
    output.push_back('}');
}

void appendAttributionGap(std::string& output, const AttributionGap& gap)
{
    output.append("{\"appliedDelta\":");
    appendDecimalString(output, gap.appliedDelta);
    output.append(",\"charId\":");
    appendNumber(output, gap.charId);
    output.append(",\"contentVersion\":");
    appendQuoted(output, gap.contentVersion.view());
    output.append(",\"controlSeq\":");
    appendDecimalString(output, gap.controlSeq);
    output.append(",\"detailCode\":");
    appendQuoted(output, gap.detailCode.view());
    output.append(",\"direction\":");
    appendQuoted(output, attributionDirectionName(gap.direction));
    output.append(",\"evidenceType\":");
    appendQuoted(output, evidenceTypeName(gap.evidenceType));
    output.append(",\"evidenceVersion\":");
    appendQuoted(output, gap.evidenceVersion.view());
    output.append(",\"occurredAt\":");
    appendQuoted(output, timestamp(gap.occurredAtUnixNanos));
    output.append(",\"sourceHint\":");
    if (gap.sourceHint.empty())
    {
        output.append("null");
    }
    else
    {
        appendQuoted(output, gap.sourceHint.view());
    }
    output.append(",\"zoneId\":");
    appendNullableNumber(output, gap.zoneId);
    output.push_back('}');
}

void appendForgoneMint(std::string& output, const ForgoneMint& diagnostic)
{
    output.append("{\"appliedAmount\":");
    appendDecimalString(output, diagnostic.appliedAmount);
    output.append(",\"attributionQuality\":");
    appendQuoted(output, attributionQualityName(diagnostic.attributionQuality));
    output.append(",\"categoryKey\":");
    appendQuoted(output, categoryName(diagnostic.category));
    output.append(",\"charId\":");
    appendNumber(output, diagnostic.charId);
    output.append(",\"contentVersion\":");
    appendQuoted(output, diagnostic.contentVersion.view());
    output.append(",\"context\":");
    appendContext(output, diagnostic.sourceType, diagnostic.context);
    output.append(",\"controlSeq\":");
    appendDecimalString(output, diagnostic.controlSeq);
    output.append(",\"evidenceVersion\":");
    appendQuoted(output, diagnostic.evidenceVersion.view());
    output.append(",\"forgoneAmount\":");
    appendDecimalString(output, diagnostic.forgoneAmount);
    output.append(",\"occurredAt\":");
    appendQuoted(output, timestamp(diagnostic.occurredAtUnixNanos));
    output.append(",\"requestedAmount\":");
    appendDecimalString(output, diagnostic.requestedAmount);
    output.append(",\"sourceKey\":");
    appendQuoted(output, diagnostic.sourceKey.view());
    output.append(",\"sourceType\":");
    appendQuoted(output, sourceTypeName(diagnostic.sourceType));
    output.append(",\"transactionId\":");
    appendQuoted(output, diagnostic.transactionId.view());
    output.append(",\"zoneId\":");
    appendNullableNumber(output, diagnostic.zoneId);
    output.push_back('}');
}

auto sha256(std::string_view input) -> std::string
{
    std::array<unsigned char, SHA256_DIGEST_LENGTH> digest{};
    SHA256(reinterpret_cast<const unsigned char*>(input.data()), input.size(), digest.data());

    constexpr std::string_view Hex = "0123456789abcdef";
    std::string                output;
    output.resize(SHA256_DIGEST_LENGTH * 2);
    for (std::size_t index = 0; index < digest.size(); ++index)
    {
        output[index * 2]     = Hex[digest[index] >> 4U];
        output[index * 2 + 1] = Hex[digest[index] & 0x0FU];
    }
    return output;
}

auto compressGzip(std::string_view input, std::vector<unsigned char>& output) -> bool
{
    z_stream stream{};
    if (deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16, 8, Z_DEFAULT_STRATEGY) != Z_OK)
    {
        return false;
    }

    output.resize(deflateBound(&stream, static_cast<uLong>(input.size())));
    stream.next_in    = reinterpret_cast<Bytef*>(const_cast<char*>(input.data()));
    stream.avail_in   = static_cast<uInt>(input.size());
    stream.next_out   = output.data();
    stream.avail_out  = static_cast<uInt>(output.size());
    const auto result = deflate(&stream, Z_FINISH);
    if (result != Z_STREAM_END)
    {
        deflateEnd(&stream);
        output.clear();
        return false;
    }

    output.resize(stream.total_out);
    return deflateEnd(&stream) == Z_OK;
}

auto truthy(const char* value) noexcept -> bool
{
    if (value == nullptr)
    {
        return false;
    }

    std::string normalized(value);
    std::transform(normalized.begin(), normalized.end(), normalized.begin(), [](unsigned char character)
                   {
                       return static_cast<char>(std::tolower(character));
                   });
    return normalized == "1" || normalized == "true" || normalized == "yes" || normalized == "on";
}

template <typename T>
auto parseUnsignedEnvironment(const char* name, T fallback) noexcept -> T
{
    const auto* value = std::getenv(name);
    if (value == nullptr || *value == '\0')
    {
        return fallback;
    }

    std::uint64_t parsed{};
    const auto    length = std::strlen(value);
    const auto    result = std::from_chars(value, value + length, parsed);
    if (result.ec != std::errc{} || result.ptr != value + length || parsed > std::numeric_limits<T>::max())
    {
        return fallback;
    }
    return static_cast<T>(parsed);
}

template <std::size_t Capacity>
void assignEnvironment(FixedString<Capacity>& output, const char* name, std::string_view fallback = {}) noexcept
{
    const auto* value = std::getenv(name);
    if (value != nullptr && *value != '\0')
    {
        static_cast<void>(output.assign(value));
    }
    else if (!fallback.empty())
    {
        static_cast<void>(output.assign(fallback));
    }
}

auto generateBootId() noexcept -> FixedString<36>
{
    std::array<unsigned char, 16> random{};
    if (RAND_bytes(random.data(), static_cast<int>(random.size())) != 1)
    {
        auto seed = static_cast<std::uint64_t>(unixNanosNow());
        for (auto& value : random)
        {
            seed ^= seed << 13U;
            seed ^= seed >> 7U;
            seed ^= seed << 17U;
            value = static_cast<unsigned char>(seed & 0xFFU);
        }
    }
    random[6] = static_cast<unsigned char>((random[6] & 0x0FU) | 0x40U);
    random[8] = static_cast<unsigned char>((random[8] & 0x3FU) | 0x80U);

    constexpr std::string_view Hex = "0123456789abcdef";
    std::array<char, 37>       formatted{};
    std::size_t                outputIndex{};
    for (std::size_t index = 0; index < random.size(); ++index)
    {
        if (index == 4 || index == 6 || index == 8 || index == 10)
        {
            formatted[outputIndex++] = '-';
        }
        formatted[outputIndex++] = Hex[random[index] >> 4U];
        formatted[outputIndex++] = Hex[random[index] & 0x0FU];
    }

    FixedString<36> bootId;
    static_cast<void>(bootId.assign({ formatted.data(), 36 }));
    return bootId;
}

auto spoolBytes(const std::filesystem::path& directory) noexcept -> std::uint64_t
{
    std::error_code                           error;
    std::uint64_t                             total{};
    std::filesystem::directory_iterator       iterator(directory, error);
    const std::filesystem::directory_iterator end;
    while (!error && iterator != end)
    {
        const auto status = iterator->symlink_status(error);
        if (!error && std::filesystem::is_regular_file(status))
        {
            const auto size = iterator->file_size(error);
            if (!error && size <= std::numeric_limits<std::uint64_t>::max() - total)
            {
                total += size;
            }
        }
        iterator.increment(error);
    }
    return total;
}

#ifdef _WIN32
auto writeDurableFile(const std::filesystem::path& temporary, const std::filesystem::path& completed, const std::vector<unsigned char>& contents) noexcept -> DurableWriteResult
{
    const auto handle = CreateFileW(temporary.c_str(), GENERIC_WRITE, 0, nullptr, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (handle == INVALID_HANDLE_VALUE)
    {
        return DurableWriteResult::Failed;
    }

    auto        success = true;
    std::size_t offset{};
    while (offset < contents.size())
    {
        const auto remaining = std::min<std::size_t>(contents.size() - offset, std::numeric_limits<DWORD>::max());
        DWORD      written{};
        if (WriteFile(handle, contents.data() + offset, static_cast<DWORD>(remaining), &written, nullptr) == FALSE || written == 0)
        {
            success = false;
            break;
        }
        offset += written;
    }
    if (success && FlushFileBuffers(handle) == FALSE)
    {
        success = false;
    }
    if (CloseHandle(handle) == FALSE)
    {
        success = false;
    }
    if (success && MoveFileExW(temporary.c_str(), completed.c_str(), MOVEFILE_WRITE_THROUGH) == FALSE)
    {
        success = false;
    }
    if (!success)
    {
        std::error_code ignored;
        std::filesystem::remove(temporary, ignored);
    }
    return success ? DurableWriteResult::Durable : DurableWriteResult::Failed;
}
#else
auto writeDurableFile(const std::filesystem::path& temporary, const std::filesystem::path& completed, const std::vector<unsigned char>& contents) noexcept -> DurableWriteResult
{
    const auto descriptor = ::open(temporary.c_str(), O_CREAT | O_EXCL | O_WRONLY | O_CLOEXEC, 0640);
    if (descriptor < 0)
    {
        return DurableWriteResult::Failed;
    }

    auto        success = true;
    std::size_t offset{};
    while (offset < contents.size())
    {
        const auto written = ::write(descriptor, contents.data() + offset, contents.size() - offset);
        if (written < 0 && errno == EINTR)
        {
            continue;
        }
        if (written <= 0)
        {
            success = false;
            break;
        }
        offset += static_cast<std::size_t>(written);
    }
    if (success && ::fsync(descriptor) != 0)
    {
        success = false;
    }
    if (::close(descriptor) != 0)
    {
        success = false;
    }
    if (success)
    {
        std::error_code error;
        std::filesystem::rename(temporary, completed, error);
        success = !error;
    }
    auto directorySynced = false;
    if (success)
    {
        const auto directoryDescriptor = ::open(completed.parent_path().c_str(), O_RDONLY | O_DIRECTORY | O_CLOEXEC);
        if (directoryDescriptor >= 0 && ::fsync(directoryDescriptor) == 0)
        {
            directorySynced = true;
        }
        if (directoryDescriptor >= 0)
        {
            ::close(directoryDescriptor);
        }
    }
    if (!success)
    {
        std::error_code ignored;
        std::filesystem::remove(temporary, ignored);
    }
    if (!success)
    {
        return DurableWriteResult::Failed;
    }
    return directorySynced ? DurableWriteResult::Durable : DurableWriteResult::VisibleDirectorySyncUncertain;
}
#endif

} // namespace

struct Producer::Impl
{
    using RecordQueue = moodycamel::ConcurrentQueue<QueuedRecord, RecordQueueTraits>;

    ProducerConfig                             config;
    std::unique_ptr<RecordQueue>               queue;
    std::unique_ptr<moodycamel::ProducerToken> producerToken;
    std::thread::id                            producerThreadId{};
    FixedString<36>                            bootId;

    std::atomic<RunState>   state{ RunState::Disabled };
    std::atomic<bool>       stopRequested{};
    std::thread             worker;
    std::mutex              wakeMutex;
    std::condition_variable wakeCondition;

    std::atomic<std::uint64_t> transactionOrdinal{};
    std::atomic<std::uint64_t> enqueuedEvents{};
    std::atomic<std::uint64_t> droppedEvents{};
    std::atomic<std::uint64_t> queueOverflowEvents{};
    std::atomic<std::uint64_t> producerThreadViolationEvents{};
    std::atomic<std::uint64_t> invalidEvents{};
    std::atomic<std::uint64_t> spoolCapacityEvents{};
    std::atomic<std::uint64_t> spoolWriteFailureEvents{};
    std::atomic<std::uint64_t> batchesWritten{};
    std::atomic<std::uint64_t> reportedSpoolBytes{};

    std::atomic<std::uint64_t> unreportedQueueDrops{};
    std::atomic<std::int64_t>  queueDropStartUnixNanos{};
    std::atomic<std::int64_t>  queueDropEndUnixNanos{};
    std::atomic<std::uint64_t> unreportedProducerThreadDrops{};
    std::atomic<std::int64_t>  producerThreadDropStartUnixNanos{};
    std::atomic<std::int64_t>  producerThreadDropEndUnixNanos{};
    std::atomic<std::uint64_t> gameTickSequence{};
    std::atomic<std::int64_t>  latestGameTickUnixNanos{};
    std::atomic<ErrorCode>     lastError{ ErrorCode::None };

    std::array<Gap, 4>      pendingGaps{};
    std::uint64_t           nextGapOrdinal{ 1 };
    std::uint64_t           nextBatchSequence{ 1 };
    std::uint64_t           nextEventSequence{ 1 };
    std::uint64_t           nextControlSequence{ 1 };
    std::uint64_t           lastDurableGameTickSequence{};
    std::int64_t            lastWatermarkUnixMillis{};
    SteadyClock::time_point lastDurableWrite{};
    SteadyClock::time_point retryPersistenceAfter{};
    PersistResult           lastPersistFailure{ PersistResult::Failed };
    std::int64_t            bootStartedUnixMillis{};

    auto enqueue(QueuedRecord record, std::int64_t lossTime) noexcept -> RecordResult
    {
        if (state.load(std::memory_order_acquire) != RunState::Running)
        {
            return RecordResult::Disabled;
        }
        if (std::this_thread::get_id() != producerThreadId)
        {
            const auto occurredAt = lossTime > 0 ? lossTime : unixNanosNow();
            droppedEvents.fetch_add(1, std::memory_order_relaxed);
            invalidEvents.fetch_add(1, std::memory_order_relaxed);
            producerThreadViolationEvents.fetch_add(1, std::memory_order_relaxed);
            unreportedProducerThreadDrops.fetch_add(1, std::memory_order_relaxed);
            auto noStart = std::int64_t{};
            producerThreadDropStartUnixNanos.compare_exchange_strong(
                noStart, occurredAt, std::memory_order_relaxed);
            producerThreadDropEndUnixNanos.store(occurredAt, std::memory_order_release);
            return RecordResult::InvalidEvent;
        }
        if (!queue->try_enqueue(*producerToken, record))
        {
            droppedEvents.fetch_add(1, std::memory_order_relaxed);
            queueOverflowEvents.fetch_add(1, std::memory_order_relaxed);
            unreportedQueueDrops.fetch_add(1, std::memory_order_relaxed);
            auto noStart = std::int64_t{};
            queueDropStartUnixNanos.compare_exchange_strong(noStart, lossTime, std::memory_order_relaxed);
            queueDropEndUnixNanos.store(lossTime, std::memory_order_release);
            return RecordResult::QueueFull;
        }
        enqueuedEvents.fetch_add(1, std::memory_order_relaxed);
        return RecordResult::Enqueued;
    }

    void mergeGap(GapReason reason, std::int64_t start, std::int64_t end, std::uint64_t count) noexcept
    {
        constexpr auto MaxFutureSkewNanos = 5LL * 60LL * 1000000000LL;
        const auto     now                = unixNanosNow();
        if (start <= 0 || start > now + MaxFutureSkewNanos)
        {
            start = now;
        }
        if (end <= 0 || end > now + MaxFutureSkewNanos)
        {
            end = now;
        }
        if (end < start)
        {
            end = start;
        }

        auto& gap = pendingGaps[static_cast<std::size_t>(reason)];
        if (!gap.active)
        {
            gap.active         = true;
            gap.reason         = reason;
            gap.startUnixNanos = start;
            gap.endUnixNanos   = end;
            gap.ordinal        = nextGapOrdinal++;
        }
        else
        {
            gap.startUnixNanos = std::min(gap.startUnixNanos, start);
            gap.endUnixNanos   = std::max(gap.endUnixNanos, end);
        }
        gap.lostEventCount += count;
    }

    void collectQueueGap() noexcept
    {
        const auto start = queueDropStartUnixNanos.exchange(0, std::memory_order_acq_rel);
        const auto count = unreportedQueueDrops.exchange(0, std::memory_order_acq_rel);
        const auto end   = queueDropEndUnixNanos.load(std::memory_order_acquire);
        if (count > 0)
        {
            const auto fallback = unixNanosNow();
            mergeGap(GapReason::QueueOverflow, start > 0 ? start : fallback, end > 0 ? end : fallback, count);
        }
    }

    void collectProducerThreadGap() noexcept
    {
        const auto start = producerThreadDropStartUnixNanos.exchange(0, std::memory_order_acq_rel);
        const auto count = unreportedProducerThreadDrops.exchange(0, std::memory_order_acq_rel);
        const auto end   = producerThreadDropEndUnixNanos.load(std::memory_order_acquire);
        if (count > 0)
        {
            const auto fallback = unixNanosNow();
            mergeGap(GapReason::SequenceDiscontinuity,
                     start > 0 ? start : fallback,
                     end > 0 ? end : fallback,
                     count);
        }
    }

    auto hasPendingGaps() const noexcept -> bool
    {
        return std::any_of(pendingGaps.begin(), pendingGaps.end(), [](const Gap& gap)
                           {
                               return gap.active;
                           });
    }

    void appendGap(std::string& output, const Gap& gap) const
    {
        output.append("{\"gapEnd\":");
        appendQuoted(output, timestamp(gap.endUnixNanos));
        output.append(",\"gapId\":");
        std::string gapId;
        gapId.reserve(80);
        gapId.append(bootId.view());
        gapId.push_back(':');
        gapId.append(gapReasonName(gap.reason));
        gapId.push_back(':');
        appendNumber(gapId, gap.ordinal);
        appendQuoted(output, gapId);
        output.append(",\"gapStart\":");
        appendQuoted(output, timestamp(gap.startUnixNanos));
        output.append(",\"lostEventCount\":");
        appendDecimalString(output, gap.lostEventCount);
        output.append(",\"reason\":");
        appendQuoted(output, gapReasonName(gap.reason));
        output.push_back('}');
    }

    auto serializeBatch(const QueuedRecord* records, const BatchCounts& counts, bool finalWatermark, std::uint64_t currentSpoolBytes, std::uint64_t droppedEventSnapshot, std::int64_t watermarkMillis, std::string_view checksum) -> std::string
    {
        std::uint64_t firstEventSequence{};
        std::uint64_t lastEventSequence{};
        std::uint64_t firstControlSequence{};
        std::uint64_t lastControlSequence{};
        for (std::size_t index = 0; index < counts.total(); ++index)
        {
            switch (records[index].type)
            {
                case RecordType::Event:
                {
                    const auto event = records[index].as<Event>();
                    if (firstEventSequence == 0)
                    {
                        firstEventSequence = event.eventSeq;
                    }
                    lastEventSequence = event.eventSeq;
                    break;
                }
                case RecordType::AttributionGap:
                {
                    const auto gap = records[index].as<AttributionGap>();
                    if (firstControlSequence == 0)
                    {
                        firstControlSequence = gap.controlSeq;
                    }
                    lastControlSequence = gap.controlSeq;
                    break;
                }
                case RecordType::ForgoneMint:
                {
                    const auto diagnostic = records[index].as<ForgoneMint>();
                    if (firstControlSequence == 0)
                    {
                        firstControlSequence = diagnostic.controlSeq;
                    }
                    lastControlSequence = diagnostic.controlSeq;
                    break;
                }
            }
        }

        std::string output;
        output.reserve(1024 + counts.total() * 512);
        output.append("{\"attributionGaps\":[");
        auto attributionWritten = false;
        for (std::size_t index = 0; index < counts.total(); ++index)
        {
            if (records[index].type != RecordType::AttributionGap)
            {
                continue;
            }
            if (attributionWritten)
            {
                output.push_back(',');
            }
            appendAttributionGap(output, records[index].as<AttributionGap>());
            attributionWritten = true;
        }
        output.append("],\"batchSeq\":");
        appendDecimalString(output, nextBatchSequence);
        output.append(",\"bootId\":");
        appendQuoted(output, bootId.view());
        if (!checksum.empty())
        {
            output.append(",\"checksum\":");
            appendQuoted(output, checksum);
        }
        output.append(",\"controlCount\":");
        appendNumber(output, counts.controls());
        output.append(",\"droppedEvents\":");
        appendDecimalString(output, droppedEventSnapshot);
        output.append(",\"eventCount\":");
        appendNumber(output, counts.events);
        output.append(",\"events\":[");
        auto eventWritten = false;
        for (std::size_t index = 0; index < counts.total(); ++index)
        {
            if (records[index].type != RecordType::Event)
            {
                continue;
            }
            if (eventWritten)
            {
                output.push_back(',');
            }
            appendEvent(output, records[index].as<Event>());
            eventWritten = true;
        }
        output.append("],\"finalWatermark\":");
        output.append(finalWatermark ? "true" : "false");
        output.append(",\"firstControlSeq\":");
        if (firstControlSequence > 0)
        {
            appendDecimalString(output, firstControlSequence);
        }
        else
        {
            output.append("null");
        }
        output.append(",\"firstEventSeq\":");
        if (firstEventSequence > 0)
        {
            appendDecimalString(output, firstEventSequence);
        }
        else
        {
            output.append("null");
        }
        output.append(",\"forgoneMints\":[");
        auto forgoneWritten = false;
        for (std::size_t index = 0; index < counts.total(); ++index)
        {
            if (records[index].type != RecordType::ForgoneMint)
            {
                continue;
            }
            if (forgoneWritten)
            {
                output.push_back(',');
            }
            appendForgoneMint(output, records[index].as<ForgoneMint>());
            forgoneWritten = true;
        }
        output.append("],\"gaps\":[");
        auto gapWritten = false;
        for (const auto& gap : pendingGaps)
        {
            if (!gap.active)
            {
                continue;
            }
            if (gapWritten)
            {
                output.push_back(',');
            }
            appendGap(output, gap);
            gapWritten = true;
        }
        output.append("],\"lastControlSeq\":");
        if (lastControlSequence > 0)
        {
            appendDecimalString(output, lastControlSequence);
        }
        else
        {
            output.append("null");
        }
        output.append(",\"lastEventSeq\":");
        if (lastEventSequence > 0)
        {
            appendDecimalString(output, lastEventSequence);
        }
        else
        {
            output.append("null");
        }
        output.append(",\"producerId\":");
        appendQuoted(output, config.producerId.view());
        output.append(",\"producerVersion\":");
        appendQuoted(output, config.producerVersion.view());
        output.append(",\"reportedSpoolBytes\":");
        appendDecimalString(output, currentSpoolBytes);
        output.append(",\"schemaVersion\":2,\"watermarkThrough\":");
        appendQuoted(output, timestamp(watermarkMillis * 1000000));
        output.push_back('}');
        return output;
    }

    auto persist(QueuedRecord* records, const BatchCounts& counts, bool finalWatermark, bool bypassRetryBackoff = false) noexcept -> PersistResult
    {
        if (!bypassRetryBackoff && SteadyClock::now() < retryPersistenceAfter)
        {
            return lastPersistFailure;
        }
        const auto gameTickSequenceSnapshot = gameTickSequence.load(std::memory_order_acquire);
        const auto gameTickNanosSnapshot    = latestGameTickUnixNanos.load(std::memory_order_relaxed);
        const auto noteControlFailure       = [this, &counts](GapReason reason)
        {
            if (counts.total() == 0)
            {
                const auto now = unixNanosNow();
                mergeGap(reason, now, now, 0);
            }
        };
        try
        {
            const auto      directory = std::filesystem::path(config.spoolDirectory.view());
            std::error_code error;
            std::filesystem::create_directories(directory, error);
            if (error)
            {
                lastError.store(ErrorCode::SpoolDirectoryFailure, std::memory_order_relaxed);
                noteControlFailure(GapReason::SpoolWriteFailure);
                lastPersistFailure    = PersistResult::Failed;
                retryPersistenceAfter = SteadyClock::now() + std::chrono::seconds(1);
                return PersistResult::Failed;
            }

            const auto currentBytes = spoolBytes(directory);
            reportedSpoolBytes.store(currentBytes, std::memory_order_relaxed);

            for (std::size_t index = 0; index < counts.total(); ++index)
            {
                std::int64_t occurredAt{};
                switch (records[index].type)
                {
                    case RecordType::Event:
                        occurredAt = records[index].as<Event>().occurredAtUnixNanos;
                        break;
                    case RecordType::AttributionGap:
                        occurredAt = records[index].as<AttributionGap>().occurredAtUnixNanos;
                        break;
                    case RecordType::ForgoneMint:
                        occurredAt = records[index].as<ForgoneMint>().occurredAtUnixNanos;
                        break;
                }
                const auto normalizedNanos = std::max(lastWatermarkUnixMillis + 1, occurredAt / 1000000) * 1000000;
                switch (records[index].type)
                {
                    case RecordType::Event:
                    {
                        auto event                = records[index].as<Event>();
                        event.occurredAtUnixNanos = normalizedNanos;
                        records[index]            = QueuedRecord::from(RecordType::Event, event);
                        break;
                    }
                    case RecordType::AttributionGap:
                    {
                        auto gap                = records[index].as<AttributionGap>();
                        gap.occurredAtUnixNanos = normalizedNanos;
                        records[index]          = QueuedRecord::from(RecordType::AttributionGap, gap);
                        break;
                    }
                    case RecordType::ForgoneMint:
                    {
                        auto diagnostic                = records[index].as<ForgoneMint>();
                        diagnostic.occurredAtUnixNanos = normalizedNanos;
                        records[index]                 = QueuedRecord::from(RecordType::ForgoneMint, diagnostic);
                        break;
                    }
                }
            }

            auto latestCoveredNanos =
                std::max(lastWatermarkUnixMillis * 1000000, gameTickNanosSnapshot);
            for (std::size_t index = 0; index < counts.total(); ++index)
            {
                switch (records[index].type)
                {
                    case RecordType::Event:
                        latestCoveredNanos = std::max(latestCoveredNanos, records[index].as<Event>().occurredAtUnixNanos);
                        break;
                    case RecordType::AttributionGap:
                        latestCoveredNanos =
                            std::max(latestCoveredNanos, records[index].as<AttributionGap>().occurredAtUnixNanos);
                        break;
                    case RecordType::ForgoneMint:
                        latestCoveredNanos =
                            std::max(latestCoveredNanos, records[index].as<ForgoneMint>().occurredAtUnixNanos);
                        break;
                }
            }
            for (const auto& gap : pendingGaps)
            {
                if (gap.active)
                {
                    latestCoveredNanos = std::max(latestCoveredNanos, gap.endUnixNanos);
                }
            }
            const auto watermarkMillis = std::max(lastWatermarkUnixMillis, latestCoveredNanos / 1000000);
            const auto droppedSnapshot = droppedEvents.load(std::memory_order_relaxed);
            const auto canonicalWithoutChecksum =
                serializeBatch(records, counts, finalWatermark, currentBytes, droppedSnapshot, watermarkMillis, {});
            if (canonicalWithoutChecksum.size() > MaxUncompressedBatchBytes)
            {
                lastError.store(ErrorCode::SerializeFailure, std::memory_order_relaxed);
                noteControlFailure(GapReason::SpoolWriteFailure);
                lastPersistFailure    = PersistResult::Failed;
                retryPersistenceAfter = SteadyClock::now() + std::chrono::seconds(1);
                return PersistResult::Failed;
            }
            const auto checksum = sha256(canonicalWithoutChecksum);
            const auto completedJson =
                serializeBatch(records, counts, finalWatermark, currentBytes, droppedSnapshot, watermarkMillis, checksum);
            if (completedJson.size() > MaxUncompressedBatchBytes)
            {
                lastError.store(ErrorCode::SerializeFailure, std::memory_order_relaxed);
                noteControlFailure(GapReason::SpoolWriteFailure);
                lastPersistFailure    = PersistResult::Failed;
                retryPersistenceAfter = SteadyClock::now() + std::chrono::seconds(1);
                return PersistResult::Failed;
            }

            std::vector<unsigned char> compressed;
            if (!compressGzip(completedJson, compressed))
            {
                lastError.store(ErrorCode::CompressFailure, std::memory_order_relaxed);
                noteControlFailure(GapReason::SpoolWriteFailure);
                lastPersistFailure    = PersistResult::Failed;
                retryPersistenceAfter = SteadyClock::now() + std::chrono::seconds(1);
                return PersistResult::Failed;
            }

            const auto usesControlReserve = counts.events == 0 && (counts.controls() > 0 || hasPendingGaps() || finalWatermark);
            const auto limit              = usesControlReserve ? config.spoolHardCapBytes : config.spoolHardCapBytes - config.spoolControlReserveBytes;
            if (currentBytes > limit || compressed.size() > limit - currentBytes)
            {
                lastError.store(ErrorCode::SpoolCapacity, std::memory_order_relaxed);
                noteControlFailure(GapReason::SpoolCapacity);
                lastPersistFailure    = PersistResult::Capacity;
                retryPersistenceAfter = SteadyClock::now() + std::chrono::seconds(1);
                return PersistResult::Capacity;
            }

            std::array<char, 96> filename{};
            const auto           nameLength = std::snprintf(filename.data(), filename.size(), "economy-%013lld-%.*s-%020llu.json.gz", static_cast<long long>(bootStartedUnixMillis), static_cast<int>(bootId.length), bootId.bytes.data(), static_cast<unsigned long long>(nextBatchSequence));
            if (nameLength <= 0 || static_cast<std::size_t>(nameLength) >= filename.size())
            {
                lastError.store(ErrorCode::SerializeFailure, std::memory_order_relaxed);
                noteControlFailure(GapReason::SpoolWriteFailure);
                lastPersistFailure    = PersistResult::Failed;
                retryPersistenceAfter = SteadyClock::now() + std::chrono::seconds(1);
                return PersistResult::Failed;
            }
            const auto completed   = directory / std::string(filename.data(), static_cast<std::size_t>(nameLength));
            const auto temporary   = directory / (std::string(".") + filename.data() + ".tmp");
            const auto writeResult = writeDurableFile(temporary, completed, compressed);
            if (writeResult == DurableWriteResult::Failed)
            {
                lastError.store(ErrorCode::SpoolWriteFailure, std::memory_order_relaxed);
                noteControlFailure(GapReason::SpoolWriteFailure);
                lastPersistFailure    = PersistResult::Failed;
                retryPersistenceAfter = SteadyClock::now() + std::chrono::seconds(1);
                return PersistResult::Failed;
            }

            lastWatermarkUnixMillis = watermarkMillis;
            lastDurableGameTickSequence =
                std::max(lastDurableGameTickSequence, gameTickSequenceSnapshot);
            ++nextBatchSequence;
            batchesWritten.fetch_add(1, std::memory_order_relaxed);
            reportedSpoolBytes.store(currentBytes + compressed.size(), std::memory_order_relaxed);
            lastDurableWrite = SteadyClock::now();
            for (auto& gap : pendingGaps)
            {
                gap = {};
            }
            retryPersistenceAfter = {};
            if (writeResult == DurableWriteResult::VisibleDirectorySyncUncertain)
            {
                const auto now = unixNanosNow();
                mergeGap(GapReason::SpoolWriteFailure, now, now, 0);
                lastError.store(ErrorCode::SpoolWriteFailure, std::memory_order_relaxed);
            }
            else
            {
                lastError.store(ErrorCode::None, std::memory_order_relaxed);
            }
            return PersistResult::Written;
        }
        catch (...)
        {
            lastError.store(ErrorCode::SpoolWriteFailure, std::memory_order_relaxed);
            noteControlFailure(GapReason::SpoolWriteFailure);
            lastPersistFailure    = PersistResult::Failed;
            retryPersistenceAfter = SteadyClock::now() + std::chrono::seconds(1);
            return PersistResult::Failed;
        }
    }

    [[nodiscard]] auto recordTime(const QueuedRecord& record) const noexcept -> std::int64_t
    {
        switch (record.type)
        {
            case RecordType::Event:
                return record.as<Event>().occurredAtUnixNanos;
            case RecordType::AttributionGap:
                return record.as<AttributionGap>().occurredAtUnixNanos;
            case RecordType::ForgoneMint:
                return record.as<ForgoneMint>().occurredAtUnixNanos;
        }
        return 0;
    }

    auto prepareRecord(QueuedRecord& record, BatchCounts& counts) noexcept -> bool
    {
        switch (record.type)
        {
            case RecordType::Event:
            {
                auto event = record.as<Event>();
                if (!isValidEvent(event))
                {
                    return false;
                }
                event.eventSeq = nextEventSequence++;
                record         = QueuedRecord::from(RecordType::Event, event);
                ++counts.events;
                return true;
            }
            case RecordType::AttributionGap:
            {
                auto gap = record.as<AttributionGap>();
                if (!isValidAttributionGap(gap))
                {
                    return false;
                }
                gap.controlSeq = nextControlSequence++;
                record         = QueuedRecord::from(RecordType::AttributionGap, gap);
                ++counts.attributionGaps;
                return true;
            }
            case RecordType::ForgoneMint:
            {
                auto diagnostic = record.as<ForgoneMint>();
                if (!isValidForgoneMint(diagnostic))
                {
                    return false;
                }
                diagnostic.controlSeq = nextControlSequence++;
                record                = QueuedRecord::from(RecordType::ForgoneMint, diagnostic);
                ++counts.forgoneMints;
                return true;
            }
        }
        return false;
    }

    void dropRecords(QueuedRecord* records, const BatchCounts& counts, GapReason reason) noexcept
    {
        if (counts.total() == 0)
        {
            return;
        }
        auto start = recordTime(records[0]);
        auto end   = start;
        for (std::size_t index = 1; index < counts.total(); ++index)
        {
            start = std::min(start, recordTime(records[index]));
            end   = std::max(end, recordTime(records[index]));
        }
        mergeGap(reason, start, end, counts.total());
        droppedEvents.fetch_add(counts.total(), std::memory_order_relaxed);
        if (reason == GapReason::SpoolCapacity)
        {
            spoolCapacityEvents.fetch_add(counts.total(), std::memory_order_relaxed);
        }
        else if (reason == GapReason::SpoolWriteFailure)
        {
            spoolWriteFailureEvents.fetch_add(counts.total(), std::memory_order_relaxed);
        }
    }

    void flushRecords(std::array<QueuedRecord, MaxEventsPerBatch>& buffer, BatchCounts& counts, bool bypassRetryBackoff = false) noexcept
    {
        if (counts.total() == 0)
        {
            return;
        }
        const auto result = persist(buffer.data(), counts, false, bypassRetryBackoff);
        if (result == PersistResult::Capacity)
        {
            dropRecords(buffer.data(), counts, GapReason::SpoolCapacity);
        }
        else if (result == PersistResult::Failed)
        {
            dropRecords(buffer.data(), counts, GapReason::SpoolWriteFailure);
        }
        counts = {};
    }

    void run() noexcept
    {
        lastDurableWrite = SteadyClock::now();
        std::array<QueuedRecord, MaxEventsPerBatch> buffer;
        BatchCounts                                 counts;
        auto                                        firstBufferedAt = SteadyClock::time_point{};

        while (!stopRequested.load(std::memory_order_acquire))
        {
            collectQueueGap();
            collectProducerThreadGap();
            while (counts.total() < buffer.size() && counts.attributionGaps < 100 && counts.forgoneMints < 100)
            {
                QueuedRecord record;
                if (!queue->try_dequeue(record))
                {
                    break;
                }
                const auto eventTime = recordTime(record);
                if (!prepareRecord(record, counts))
                {
                    const auto fallbackTime = eventTime > 0 ? eventTime : unixNanosNow();
                    mergeGap(GapReason::SequenceDiscontinuity, fallbackTime, fallbackTime, 1);
                    droppedEvents.fetch_add(1, std::memory_order_relaxed);
                    invalidEvents.fetch_add(1, std::memory_order_relaxed);
                    continue;
                }
                buffer[counts.total() - 1] = record;
                if (counts.total() == 1)
                {
                    firstBufferedAt = SteadyClock::now();
                }
            }

            const auto now                = SteadyClock::now();
            const auto recordLimitReached = counts.total() == buffer.size() || counts.attributionGaps == 100 ||
                                            counts.forgoneMints == 100;
            if (recordLimitReached ||
                (counts.total() > 0 && now - firstBufferedAt >= std::chrono::milliseconds(config.flushIntervalMilliseconds)))
            {
                flushRecords(buffer, counts);
                if (hasPendingGaps())
                {
                    persist(nullptr, {}, false);
                }
                continue;
            }
            if (counts.total() == 0 && hasPendingGaps())
            {
                persist(nullptr, {}, false);
            }
            else if (counts.total() == 0 &&
                     now - lastDurableWrite >= std::chrono::milliseconds(config.heartbeatIntervalMilliseconds) &&
                     gameTickSequence.load(std::memory_order_acquire) > lastDurableGameTickSequence)
            {
                persist(nullptr, {}, false);
            }

            std::unique_lock lock(wakeMutex);
            wakeCondition.wait_for(lock, WorkerPollInterval, [this]
                                   {
                                       return stopRequested.load(std::memory_order_acquire);
                                   });
        }

        for (;;)
        {
            while (counts.total() < buffer.size() && counts.attributionGaps < 100 && counts.forgoneMints < 100)
            {
                QueuedRecord record;
                if (!queue->try_dequeue(record))
                {
                    break;
                }
                const auto eventTime = recordTime(record);
                if (!prepareRecord(record, counts))
                {
                    const auto fallbackTime = eventTime > 0 ? eventTime : unixNanosNow();
                    mergeGap(GapReason::SequenceDiscontinuity, fallbackTime, fallbackTime, 1);
                    droppedEvents.fetch_add(1, std::memory_order_relaxed);
                    invalidEvents.fetch_add(1, std::memory_order_relaxed);
                    continue;
                }
                buffer[counts.total() - 1] = record;
            }
            if (counts.total() == 0)
            {
                break;
            }
            flushRecords(buffer, counts, true);
        }
        collectQueueGap();
        collectProducerThreadGap();
        persist(nullptr, {}, true, true);
    }
};

Producer::Producer()
: impl_(std::make_unique<Impl>())
{
}

Producer::~Producer()
{
    stop();
}

auto Producer::start(const ProducerConfig& config) noexcept -> StartResult
{
    if (!config.enabled)
    {
        return StartResult::Disabled;
    }
    if (impl_->state.load(std::memory_order_acquire) != RunState::Disabled || impl_->worker.joinable())
    {
        return StartResult::AlreadyStarted;
    }
    if (!isSafeToken(config.producerId.view()) || !isSafeToken(config.contentVersion.view()) ||
        !isSafeToken(config.producerVersion.view()) || config.spoolDirectory.empty() || config.queueCapacity < 2 ||
        config.queueCapacity > MaxQueueCapacity || config.spoolHardCapBytes < MinHardCapBytes ||
        config.spoolControlReserveBytes < MinControlReserveBytes ||
        config.spoolControlReserveBytes >= config.spoolHardCapBytes || config.flushIntervalMilliseconds < 10 ||
        config.flushIntervalMilliseconds > 5000 || config.heartbeatIntervalMilliseconds < config.flushIntervalMilliseconds ||
        config.heartbeatIntervalMilliseconds > 30000)
    {
        impl_->lastError.store(ErrorCode::InvalidConfiguration, std::memory_order_relaxed);
        return StartResult::InvalidConfiguration;
    }

    try
    {
        impl_->config                = config;
        impl_->bootId                = generateBootId();
        impl_->bootStartedUnixMillis = unixNanosNow() / 1000000;
        impl_->producerToken.reset();
        impl_->queue            = std::make_unique<Producer::Impl::RecordQueue>(config.queueCapacity, 1, 0);
        impl_->producerToken    = std::make_unique<moodycamel::ProducerToken>(*impl_->queue);
        impl_->producerThreadId = std::this_thread::get_id();
        impl_->latestGameTickUnixNanos.store(unixNanosNow(), std::memory_order_relaxed);
        impl_->gameTickSequence.store(1, std::memory_order_relaxed);
        impl_->lastDurableGameTickSequence = 0;
        impl_->stopRequested               = false;
        impl_->state.store(RunState::Running, std::memory_order_release);
        impl_->worker = std::thread([implementation = impl_.get()]
                                    {
                                        implementation->run();
                                    });
        return StartResult::Started;
    }
    catch (...)
    {
        impl_->state.store(RunState::Disabled, std::memory_order_release);
        impl_->producerToken.reset();
        impl_->queue.reset();
        impl_->producerThreadId = {};
        impl_->lastError.store(ErrorCode::WorkerStartFailed, std::memory_order_relaxed);
        return StartResult::WorkerStartFailed;
    }
}

auto Producer::startFromEnvironment() noexcept -> StartResult
{
    return start(producerConfigFromEnvironment());
}

void Producer::stop() noexcept
{
    auto expected = RunState::Running;
    if (!impl_->state.compare_exchange_strong(expected, RunState::Stopping, std::memory_order_acq_rel))
    {
        if (expected == RunState::Stopping && impl_->worker.joinable())
        {
            impl_->worker.join();
            impl_->producerToken.reset();
            impl_->queue.reset();
            impl_->producerThreadId = {};
            impl_->state.store(RunState::Disabled, std::memory_order_release);
        }
        return;
    }

    impl_->stopRequested.store(true, std::memory_order_release);
    impl_->wakeCondition.notify_all();
    if (impl_->worker.joinable())
    {
        impl_->worker.join();
    }
    impl_->producerToken.reset();
    impl_->queue.reset();
    impl_->producerThreadId = {};
    impl_->state.store(RunState::Disabled, std::memory_order_release);
}

void Producer::noteGameTick() noexcept
{
    if (impl_->state.load(std::memory_order_acquire) != RunState::Running ||
        std::this_thread::get_id() != impl_->producerThreadId)
    {
        return;
    }

    impl_->latestGameTickUnixNanos.store(unixNanosNow(), std::memory_order_relaxed);
    impl_->gameTickSequence.fetch_add(1, std::memory_order_release);
}

auto Producer::tryRecord(Event event) noexcept -> RecordResult
{
    if (!enabled())
    {
        return RecordResult::Disabled;
    }
    if (event.contentVersion.empty())
    {
        event.contentVersion = impl_->config.contentVersion;
    }
    if (event.evidenceVersion.empty())
    {
        event.evidenceVersion = impl_->config.producerVersion;
    }
    return impl_->enqueue(QueuedRecord::from(RecordType::Event, event), event.occurredAtUnixNanos);
}

auto Producer::tryRecord(AttributionGap gap) noexcept -> RecordResult
{
    if (!enabled())
    {
        return RecordResult::Disabled;
    }
    if (gap.contentVersion.empty())
    {
        gap.contentVersion = impl_->config.contentVersion;
    }
    if (gap.evidenceVersion.empty())
    {
        gap.evidenceVersion = impl_->config.producerVersion;
    }
    return impl_->enqueue(QueuedRecord::from(RecordType::AttributionGap, gap), gap.occurredAtUnixNanos);
}

auto Producer::tryRecord(ForgoneMint diagnostic) noexcept -> RecordResult
{
    if (!enabled())
    {
        return RecordResult::Disabled;
    }
    if (diagnostic.contentVersion.empty())
    {
        diagnostic.contentVersion = impl_->config.contentVersion;
    }
    if (diagnostic.evidenceVersion.empty())
    {
        diagnostic.evidenceVersion = impl_->config.producerVersion;
    }
    return impl_->enqueue(QueuedRecord::from(RecordType::ForgoneMint, diagnostic), diagnostic.occurredAtUnixNanos);
}

auto Producer::nextTransactionId(std::string_view prefix) noexcept -> TransactionId
{
    TransactionId transaction;
    if (impl_->state.load(std::memory_order_acquire) != RunState::Running || !isSafeToken(prefix))
    {
        return transaction;
    }

    const auto            ordinal = impl_->transactionOrdinal.fetch_add(1, std::memory_order_relaxed) + 1;
    std::array<char, 128> value{};
    const auto            result = std::snprintf(value.data(), value.size(), "%.*s:%.*s:%llu", static_cast<int>(impl_->bootId.length), impl_->bootId.bytes.data(), static_cast<int>(prefix.size()), prefix.data(), static_cast<unsigned long long>(ordinal));
    if (result <= 0 || static_cast<std::size_t>(result) >= value.size())
    {
        return transaction;
    }
    static_cast<void>(transaction.assign({ value.data(), static_cast<std::size_t>(result) }));
    return transaction;
}

auto Producer::enabled() const noexcept -> bool
{
    return impl_->state.load(std::memory_order_acquire) == RunState::Running;
}

auto Producer::metrics() const noexcept -> MetricsSnapshot
{
    return {
        .enqueuedEvents      = impl_->enqueuedEvents.load(std::memory_order_relaxed),
        .droppedEvents       = impl_->droppedEvents.load(std::memory_order_relaxed),
        .queueOverflowEvents = impl_->queueOverflowEvents.load(std::memory_order_relaxed),
        .producerThreadViolationEvents =
            impl_->producerThreadViolationEvents.load(std::memory_order_relaxed),
        .invalidEvents           = impl_->invalidEvents.load(std::memory_order_relaxed),
        .spoolCapacityEvents     = impl_->spoolCapacityEvents.load(std::memory_order_relaxed),
        .spoolWriteFailureEvents = impl_->spoolWriteFailureEvents.load(std::memory_order_relaxed),
        .batchesWritten          = impl_->batchesWritten.load(std::memory_order_relaxed),
        .reportedSpoolBytes      = impl_->reportedSpoolBytes.load(std::memory_order_relaxed),
    };
}

auto Producer::lastError() const noexcept -> const char*
{
    switch (impl_->lastError.load(std::memory_order_relaxed))
    {
        case ErrorCode::None:
            return "none";
        case ErrorCode::InvalidConfiguration:
            return "invalid configuration";
        case ErrorCode::WorkerStartFailed:
            return "worker start failed";
        case ErrorCode::SpoolDirectoryFailure:
            return "spool directory unavailable";
        case ErrorCode::SerializeFailure:
            return "batch serialization failed";
        case ErrorCode::CompressFailure:
            return "batch compression failed";
        case ErrorCode::SpoolCapacity:
            return "spool capacity reached";
        case ErrorCode::SpoolWriteFailure:
            return "durable spool write failed";
    }
    return "unknown";
}

auto globalProducer() noexcept -> Producer&
{
    static Producer producer;
    return producer;
}

auto producerConfigFromEnvironment() noexcept -> ProducerConfig
{
    ProducerConfig config;
    config.enabled = truthy(std::getenv("PHOENIX_ECONOMY_TELEMETRY_ENABLED"));
    assignEnvironment(config.producerId, "PHOENIX_ECONOMY_PRODUCER_ID");
    assignEnvironment(config.contentVersion, "PHOENIX_ECONOMY_CONTENT_VERSION");
    assignEnvironment(config.producerVersion, "PHOENIX_ECONOMY_PRODUCER_VERSION", "phoenix-economy-module-0.1.0");
    assignEnvironment(config.spoolDirectory, "PHOENIX_ECONOMY_SPOOL_DIRECTORY");
    config.queueCapacity = parseUnsignedEnvironment<std::size_t>("PHOENIX_ECONOMY_QUEUE_CAPACITY", config.queueCapacity);
    config.spoolHardCapBytes =
        parseUnsignedEnvironment<std::uint64_t>("PHOENIX_ECONOMY_SPOOL_HARD_CAP_BYTES", config.spoolHardCapBytes);
    config.spoolControlReserveBytes = parseUnsignedEnvironment<std::uint64_t>(
        "PHOENIX_ECONOMY_SPOOL_CONTROL_RESERVE_BYTES", config.spoolControlReserveBytes);
    config.flushIntervalMilliseconds = parseUnsignedEnvironment<std::uint32_t>(
        "PHOENIX_ECONOMY_FLUSH_INTERVAL_MS", config.flushIntervalMilliseconds);
    config.heartbeatIntervalMilliseconds = parseUnsignedEnvironment<std::uint32_t>(
        "PHOENIX_ECONOMY_HEARTBEAT_INTERVAL_MS", config.heartbeatIntervalMilliseconds);
    return config;
}

#ifdef PHOENIX_ECONOMY_TESTING
auto recordQueueAllocationCallsForCurrentThread() noexcept -> std::uint64_t
{
    return recordQueueAllocationCalls;
}
#endif

} // namespace phoenix::economy
