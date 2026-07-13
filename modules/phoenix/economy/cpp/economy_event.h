#pragma once

#include <array>
#include <charconv>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <string_view>
#include <type_traits>

namespace phoenix::economy
{

constexpr std::uint64_t MaxGilAmount = 999999999ULL;

template <std::size_t Capacity>
struct FixedString
{
    static_assert(Capacity > 0);

    std::array<char, Capacity + 1> bytes{};
    std::uint16_t                  length{};

    [[nodiscard]] auto assign(std::string_view value) noexcept -> bool
    {
        if (value.empty() || value.size() > Capacity)
        {
            return false;
        }

        std::memcpy(bytes.data(), value.data(), value.size());
        length        = static_cast<std::uint16_t>(value.size());
        bytes[length] = '\0';
        return true;
    }

    void clear() noexcept
    {
        length   = 0;
        bytes[0] = '\0';
    }

    [[nodiscard]] auto view() const noexcept -> std::string_view
    {
        return { bytes.data(), length };
    }

    [[nodiscard]] auto empty() const noexcept -> bool
    {
        return length == 0;
    }
};

template <typename T>
struct Nullable
{
    T    value{};
    bool hasValue{};

    constexpr void set(T next) noexcept
    {
        value    = next;
        hasValue = true;
    }

    constexpr void reset() noexcept
    {
        value    = {};
        hasValue = false;
    }
};

using TransactionId   = FixedString<128>;
using ContentVersion  = FixedString<64>;
using SourceKey       = FixedString<128>;
using ServiceKey      = FixedString<64>;
using ScriptKey       = FixedString<96>;
using SystemKey       = FixedString<96>;
using EvidenceVersion = FixedString<64>;
using DetailCode      = FixedString<64>;
using SourceHint      = FixedString<128>;

enum class Kind : std::uint8_t
{
    Mint,
    Burn,
    Transfer,
};

enum class Category : std::uint8_t
{
    MobDrop,
    Mug,
    NpcVendorSale,
    GuildVendorSale,
    QuestReward,
    MissionReward,
    BattlefieldReward,
    RegimeReward,
    StartingGil,
    AdminGrant,
    ScriptReward,
    OtherMint,
    NpcShopPurchase,
    GuildShopPurchase,
    AuctionListingFee,
    BazaarTax,
    ChocoboRental,
    TransportFee,
    QuestFee,
    ServiceFee,
    CurrencyCapLoss,
    AdminRemove,
    OtherBurn,
    PlayerTrade,
    BazaarSale,
    AuctionSale,
    DeliveryBox,
    OtherTransfer,
};

enum class SourceType : std::uint8_t
{
    Mob,
    Npc,
    Quest,
    Mission,
    Battlefield,
    Regime,
    Admin,
    Script,
    System,
};

enum class AttributionQuality : std::uint8_t
{
    Semantic,
    Correlated,
};

enum class AttributionDirection : std::uint8_t
{
    Credit,
    Debit,
};

enum class EvidenceType : std::uint8_t
{
    LuaWallet,
    WalletObserver,
    PacketCorrelator,
    NativePacket,
    TransferReconciliation,
};

// V2 source context. Only the fields allowed for Event::sourceType are emitted.
// String keys are canonical SAFE_TOKEN values, never display names.
struct SourceContext
{
    Nullable<std::uint32_t> mobSpawnId;
    Nullable<std::uint32_t> mobPoolId;
    Nullable<std::uint32_t> npcId;
    Nullable<std::uint32_t> shopId;
    Nullable<std::uint16_t> guildId;
    Nullable<std::uint16_t> questLogId;
    Nullable<std::uint16_t> questId;
    Nullable<std::uint16_t> missionLogId;
    Nullable<std::uint16_t> missionId;
    Nullable<std::uint16_t> battlefieldId;
    Nullable<std::uint16_t> regimeId;
    Nullable<std::uint32_t> actorCharId;
    ServiceKey              serviceKey;
    ScriptKey               scriptKey;
    SystemKey               systemKey;
};

// Fixed-size, trivially-copyable payload passed from the game thread to the
// telemetry worker. eventSeq is assigned in dequeue order by the worker.
struct Event
{
    std::uint64_t           eventSeq{};
    std::int64_t            occurredAtUnixNanos{};
    TransactionId           transactionId;
    Kind                    kind{};
    Category                category{};
    std::uint64_t           amount{};
    Nullable<std::uint32_t> fromCharId;
    Nullable<std::uint32_t> toCharId;
    Nullable<std::uint16_t> zoneId;
    Nullable<std::uint16_t> itemId;
    Nullable<std::uint32_t> itemQuantity;
    ContentVersion          contentVersion;
    SourceType              sourceType{};
    SourceKey               sourceKey;
    SourceContext           context;
    AttributionQuality      attributionQuality{ AttributionQuality::Semantic };
    EvidenceVersion         evidenceVersion;
};

// Non-accounting diagnostic for an applied wallet delta whose accounting kind
// or category cannot be proven. It is never included in mint/burn/transfer totals.
struct AttributionGap
{
    std::uint64_t           controlSeq{};
    std::int64_t            occurredAtUnixNanos{};
    std::uint32_t           charId{};
    Nullable<std::uint16_t> zoneId;
    AttributionDirection    direction{};
    std::uint64_t           appliedDelta{};
    EvidenceType            evidenceType{};
    EvidenceVersion         evidenceVersion;
    SourceHint              sourceHint;
    DetailCode              detailCode;
    ContentVersion          contentVersion;
};

// Non-accounting diagnostic for a requested mint clipped by the gil cap.
struct ForgoneMint
{
    std::uint64_t           controlSeq{};
    std::int64_t            occurredAtUnixNanos{};
    std::uint32_t           charId{};
    Nullable<std::uint16_t> zoneId;
    std::uint64_t           requestedAmount{};
    std::uint64_t           appliedAmount{};
    std::uint64_t           forgoneAmount{};
    Category                category{ Category::OtherMint };
    TransactionId           transactionId;
    SourceType              sourceType{};
    SourceKey               sourceKey;
    SourceContext           context;
    AttributionQuality      attributionQuality{ AttributionQuality::Semantic };
    EvidenceVersion         evidenceVersion;
    ContentVersion          contentVersion;
};

[[nodiscard]] constexpr auto kindForCategory(Category category) noexcept -> Kind
{
    if (category <= Category::OtherMint)
    {
        return Kind::Mint;
    }
    if (category <= Category::OtherBurn)
    {
        return Kind::Burn;
    }
    return Kind::Transfer;
}

[[nodiscard]] constexpr auto isPositiveCharacterId(const Nullable<std::uint32_t>& id) noexcept -> bool
{
    return !id.hasValue || id.value > 0;
}

[[nodiscard]] auto isSafeToken(std::string_view value) noexcept -> bool;
[[nodiscard]] auto isValidEvent(const Event& event) noexcept -> bool;
[[nodiscard]] auto isValidAttributionGap(const AttributionGap& gap) noexcept -> bool;
[[nodiscard]] auto isValidForgoneMint(const ForgoneMint& diagnostic) noexcept -> bool;
[[nodiscard]] auto unixNanosNow() noexcept -> std::int64_t;

static_assert(std::is_trivially_copyable_v<FixedString<128>>);
static_assert(std::is_trivially_copyable_v<Event>);
static_assert(std::is_trivially_copyable_v<AttributionGap>);
static_assert(std::is_trivially_copyable_v<ForgoneMint>);
static_assert(sizeof(Event) <= 2048);

} // namespace phoenix::economy
