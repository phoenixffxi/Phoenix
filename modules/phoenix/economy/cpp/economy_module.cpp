#include "economy_correlator.h"
#include "economy_event.h"
#include "economy_producer.h"

#include "common/logging.h"
#include "map/entities/char_entity.h"
#include "map/entities/mob_entity.h"
#include "map/enums/msg_basic.h"
#include "map/enums/packet_c2s.h"
#include "map/enums/packet_s2c.h"
#include "map/item_container.h"
#include "map/items/item.h"
#include "map/lua/lua_base_entity.h"
#include "map/map_session.h"
#include "map/packets/basic.h"
#include "map/packets/c2s/0x033_trade_res.h"
#include "map/packets/c2s/0x04e_auc.h"
#include "map/packets/c2s/0x083_shop_buy.h"
#include "map/packets/c2s/0x085_shop_sell_set.h"
#include "map/packets/c2s/0x106_bazaar_buy.h"
#include "map/packets/s2c/0x022_item_trade_res.h"
#include "map/packets/s2c/0x029_battle_message.h"
#include "map/trade_container.h"
#include "map/universal_container.h"
#include "map/utils/moduleutils.h"
#include "map/zone.h"

#include <algorithm>
#include <array>
#include <charconv>
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <limits>
#include <optional>
#include <string>
#include <string_view>

namespace
{

using namespace phoenix::economy;
using SteadyClock = std::chrono::steady_clock;

constexpr std::size_t      MaxTrackedCharacters    = 2048;
constexpr std::size_t      MaxSemanticContextDepth = 16;
constexpr std::size_t      MaxPendingPerCharacter  = 4;
constexpr auto             NativeDeadline          = std::chrono::seconds(5);
constexpr auto             MobDeadline             = std::chrono::seconds(2);
constexpr auto             ShopDeadline            = std::chrono::seconds(30);
constexpr auto             ExpirySweepInterval     = std::chrono::milliseconds(250);
constexpr std::string_view EvidenceVersionKey      = "phoenix-economy-correlator-v1";

enum class SlotState : std::uint8_t
{
    Empty,
    Occupied,
    Tombstone,
};

enum class NativeOperation : std::uint8_t
{
    ShopBuy,
    ShopSell,
    Bazaar,
    PlayerTrade,
    AuctionListing,
    MobDrop,
};

enum class PairRole : std::uint8_t
{
    First,
    Second,
};

struct SemanticContext
{
    std::optional<Category> mintCategory;
    std::optional<Category> burnCategory;
    SourceType              sourceType{ SourceType::Script };
    SourceContext           source;
    Nullable<std::uint16_t> zoneId;
    Nullable<std::uint16_t> itemId;
    Nullable<std::uint32_t> itemQuantity;
    TransactionId           transactionId;
};

struct ShopContext
{
    bool                    active{};
    SemanticContext         semantic;
    SteadyClock::time_point deadline{};
};

struct PendingOperation
{
    bool                    active{};
    NativeOperation         operation{};
    PairRole                role{ PairRole::First };
    bool                    walletObserved{};
    bool                    resultObserved{};
    bool                    ambiguous{};
    bool                    gapReported{};
    std::uint8_t            walletPacketCount{};
    SteadyClock::time_point deadline{};
    TransactionId           transactionId;
    SemanticContext         semantic;

    std::uint32_t firstCharId{};
    std::uint32_t secondCharId{};
    std::uint64_t firstBefore{};
    std::uint64_t secondBefore{};
    std::uint64_t firstOffer{};
    std::uint64_t secondOffer{};
    std::uint64_t expectedBaseAmount{};

    std::uint64_t beforeGil{};
    std::uint64_t latestGil{};
};

struct CharacterState
{
    SlotState                                            slotState{ SlotState::Empty };
    std::uint32_t                                        charId{};
    std::uint16_t                                        zoneId{};
    bool                                                 walletShadowValid{};
    std::uint64_t                                        walletShadow{};
    std::uint8_t                                         luaMutationDepth{};
    bool                                                 pendingOverflow{};
    ShopContext                                          shop;
    std::array<SemanticContext, MaxSemanticContextDepth> contexts{};
    correlator::ContextDepth                             contextScope;
    std::array<PendingOperation, MaxPendingPerCharacter> pending{};
};

class KeyBuilder
{
public:
    auto append(std::string_view value) noexcept -> bool
    {
        if (!valid_ || size_ + value.size() > bytes_.size())
        {
            valid_ = false;
            return false;
        }

        std::copy(value.begin(), value.end(), bytes_.begin() + size_);
        size_ += value.size();
        return true;
    }

    template <typename T>
    auto appendNumber(T value, int base = 10) noexcept -> bool
    {
        if (!valid_)
        {
            return false;
        }

        const auto result = std::to_chars(bytes_.data() + size_, bytes_.data() + bytes_.size(), value, base);
        if (result.ec != std::errc{})
        {
            valid_ = false;
            return false;
        }

        size_ = static_cast<std::size_t>(result.ptr - bytes_.data());
        return true;
    }

    [[nodiscard]] auto view() const noexcept -> std::string_view
    {
        return valid_ ? std::string_view(bytes_.data(), size_) : std::string_view{};
    }

private:
    std::array<char, 128> bytes_{};
    std::size_t           size_{};
    bool                  valid_{ true };
};

[[nodiscard]] auto walletGil(const CCharEntity* PChar) noexcept -> std::optional<std::uint64_t>
{
    if (!PChar)
    {
        return std::nullopt;
    }

    const auto* inventory = PChar->getStorage(LOC_INVENTORY);
    const auto* gil       = inventory ? inventory->GetItem(0) : nullptr;
    if (!gil || !gil->isType(ITEM_CURRENCY))
    {
        return std::nullopt;
    }

    return gil->getQuantity();
}

[[nodiscard]] auto luaCharacter(CLuaBaseEntity* entity) noexcept -> CCharEntity*
{
    return entity ? dynamic_cast<CCharEntity*>(entity->GetBaseEntity()) : nullptr;
}

[[nodiscard]] auto luaMob(CLuaBaseEntity* entity) noexcept -> CMobEntity*
{
    return entity ? dynamic_cast<CMobEntity*>(entity->GetBaseEntity()) : nullptr;
}

[[nodiscard]] auto categoryFromString(std::string_view value) noexcept -> std::optional<Category>
{
    struct Entry
    {
        std::string_view key;
        Category         category;
    };

    static constexpr std::array entries{
        Entry{ "mob_drop", Category::MobDrop },
        Entry{ "mug", Category::Mug },
        Entry{ "npc_vendor_sale", Category::NpcVendorSale },
        Entry{ "guild_vendor_sale", Category::GuildVendorSale },
        Entry{ "quest_reward", Category::QuestReward },
        Entry{ "mission_reward", Category::MissionReward },
        Entry{ "battlefield_reward", Category::BattlefieldReward },
        Entry{ "regime_reward", Category::RegimeReward },
        Entry{ "starting_gil", Category::StartingGil },
        Entry{ "admin_grant", Category::AdminGrant },
        Entry{ "script_reward", Category::ScriptReward },
        Entry{ "other_mint", Category::OtherMint },
        Entry{ "npc_shop_purchase", Category::NpcShopPurchase },
        Entry{ "guild_shop_purchase", Category::GuildShopPurchase },
        Entry{ "auction_listing_fee", Category::AuctionListingFee },
        Entry{ "bazaar_tax", Category::BazaarTax },
        Entry{ "chocobo_rental", Category::ChocoboRental },
        Entry{ "transport_fee", Category::TransportFee },
        Entry{ "quest_fee", Category::QuestFee },
        Entry{ "service_fee", Category::ServiceFee },
        Entry{ "currency_cap_loss", Category::CurrencyCapLoss },
        Entry{ "admin_remove", Category::AdminRemove },
        Entry{ "other_burn", Category::OtherBurn },
        Entry{ "player_trade", Category::PlayerTrade },
        Entry{ "bazaar_sale", Category::BazaarSale },
        Entry{ "auction_sale", Category::AuctionSale },
        Entry{ "delivery_box", Category::DeliveryBox },
        Entry{ "other_transfer", Category::OtherTransfer },
    };

    for (const auto& entry : entries)
    {
        if (entry.key == value)
        {
            return entry.category;
        }
    }

    return std::nullopt;
}

[[nodiscard]] auto sourceTypeFromString(std::string_view value) noexcept -> std::optional<SourceType>
{
    if (value == "mob")
    {
        return SourceType::Mob;
    }
    if (value == "npc")
    {
        return SourceType::Npc;
    }
    if (value == "quest")
    {
        return SourceType::Quest;
    }
    if (value == "mission")
    {
        return SourceType::Mission;
    }
    if (value == "battlefield")
    {
        return SourceType::Battlefield;
    }
    if (value == "regime")
    {
        return SourceType::Regime;
    }
    if (value == "admin")
    {
        return SourceType::Admin;
    }
    if (value == "script")
    {
        return SourceType::Script;
    }
    if (value == "system")
    {
        return SourceType::System;
    }

    return std::nullopt;
}

template <typename T>
auto readUnsigned(const sol::table& table, const char* key, Nullable<T>& destination) -> bool
{
    const sol::object value = table[key];
    if (!value.valid() || value == sol::lua_nil)
    {
        return true;
    }
    if (!value.is<std::uint64_t>())
    {
        return false;
    }

    const auto number = value.as<std::uint64_t>();
    if (number > std::numeric_limits<T>::max())
    {
        return false;
    }

    destination.set(static_cast<T>(number));
    return true;
}

template <std::size_t Capacity>
auto readToken(const sol::table& table, const char* key, FixedString<Capacity>& destination) -> bool
{
    const sol::object value = table[key];
    if (!value.valid() || value == sol::lua_nil)
    {
        return true;
    }
    if (!value.is<std::string>())
    {
        return false;
    }

    const auto token = value.as<std::string>();
    return isSafeToken(token) && destination.assign(token);
}

[[nodiscard]] auto parseSemanticContext(CCharEntity* PChar, const sol::table& table) -> std::optional<SemanticContext>
{
    if (!PChar)
    {
        return std::nullopt;
    }

    SemanticContext context;
    context.zoneId.set(PChar->getZone());

    const auto parseCategory = [&](const char* key, Kind expectedKind, std::optional<Category>& destination) -> bool
    {
        const sol::object value = table[key];
        if (!value.valid() || value == sol::lua_nil)
        {
            return true;
        }
        if (!value.is<std::string>())
        {
            return false;
        }

        destination = categoryFromString(value.as<std::string>());
        return destination.has_value() && kindForCategory(*destination) == expectedKind;
    };

    if (!parseCategory("mintCategory", Kind::Mint, context.mintCategory) ||
        !parseCategory("burnCategory", Kind::Burn, context.burnCategory))
    {
        return std::nullopt;
    }

    const sol::object sourceType = table["sourceType"];
    if (!sourceType.valid() || sourceType == sol::lua_nil || !sourceType.is<std::string>())
    {
        return std::nullopt;
    }

    const auto parsedSourceType = sourceTypeFromString(sourceType.as<std::string>());
    if (!parsedSourceType)
    {
        return std::nullopt;
    }
    context.sourceType = *parsedSourceType;

    if (!readUnsigned(table, "zoneId", context.zoneId) ||
        !readUnsigned(table, "itemId", context.itemId) ||
        !readUnsigned(table, "itemQuantity", context.itemQuantity) ||
        !readUnsigned(table, "mobSpawnId", context.source.mobSpawnId) ||
        !readUnsigned(table, "mobPoolId", context.source.mobPoolId) ||
        !readUnsigned(table, "npcId", context.source.npcId) ||
        !readUnsigned(table, "shopId", context.source.shopId) ||
        !readUnsigned(table, "guildId", context.source.guildId) ||
        !readUnsigned(table, "questLogId", context.source.questLogId) ||
        !readUnsigned(table, "questId", context.source.questId) ||
        !readUnsigned(table, "missionLogId", context.source.missionLogId) ||
        !readUnsigned(table, "missionId", context.source.missionId) ||
        !readUnsigned(table, "battlefieldId", context.source.battlefieldId) ||
        !readUnsigned(table, "regimeId", context.source.regimeId) ||
        !readUnsigned(table, "actorCharId", context.source.actorCharId) ||
        !readToken(table, "serviceKey", context.source.serviceKey) ||
        !readToken(table, "scriptKey", context.source.scriptKey) ||
        !readToken(table, "systemKey", context.source.systemKey))
    {
        return std::nullopt;
    }

    context.transactionId = globalProducer().nextTransactionId("lua");
    return context;
}

[[nodiscard]] auto systemContext(std::string_view key) -> SemanticContext
{
    SemanticContext context;
    context.sourceType = SourceType::System;
    static_cast<void>(context.source.systemKey.assign(key));
    return context;
}

auto appendSourceKeyPart(KeyBuilder& builder, std::string_view separator, std::uint64_t value) -> bool
{
    return builder.append(separator) && builder.appendNumber(value);
}

auto populateEventSource(Event& event, const SemanticContext& semantic) -> bool
{
    event.sourceType = semantic.sourceType;
    KeyBuilder key;

    switch (semantic.sourceType)
    {
        case SourceType::Mob:
            if (!semantic.source.mobSpawnId.hasValue || !key.append("mob") ||
                !appendSourceKeyPart(key, ":", semantic.source.mobSpawnId.value))
            {
                return false;
            }
            event.context.mobSpawnId = semantic.source.mobSpawnId;
            event.context.mobPoolId  = semantic.source.mobPoolId;
            break;
        case SourceType::Npc:
            if (!semantic.source.npcId.hasValue || !event.zoneId.hasValue || !key.append("npc") ||
                !appendSourceKeyPart(key, ":", event.zoneId.value) ||
                !appendSourceKeyPart(key, ":", semantic.source.npcId.value))
            {
                return false;
            }
            event.context.npcId      = semantic.source.npcId;
            event.context.shopId     = semantic.source.shopId;
            event.context.guildId    = semantic.source.guildId;
            event.context.serviceKey = semantic.source.serviceKey;
            break;
        case SourceType::Quest:
            if (!semantic.source.questLogId.hasValue || !semantic.source.questId.hasValue || !key.append("quest") ||
                !appendSourceKeyPart(key, ":", semantic.source.questLogId.value) ||
                !appendSourceKeyPart(key, ":", semantic.source.questId.value))
            {
                return false;
            }
            event.context.questLogId = semantic.source.questLogId;
            event.context.questId    = semantic.source.questId;
            break;
        case SourceType::Mission:
            if (!semantic.source.missionLogId.hasValue || !semantic.source.missionId.hasValue || !key.append("mission") ||
                !appendSourceKeyPart(key, ":", semantic.source.missionLogId.value) ||
                !appendSourceKeyPart(key, ":", semantic.source.missionId.value))
            {
                return false;
            }
            event.context.missionLogId = semantic.source.missionLogId;
            event.context.missionId    = semantic.source.missionId;
            break;
        case SourceType::Battlefield:
            if (!semantic.source.battlefieldId.hasValue || !key.append("battlefield") ||
                !appendSourceKeyPart(key, ":", semantic.source.battlefieldId.value))
            {
                return false;
            }
            event.context.battlefieldId = semantic.source.battlefieldId;
            break;
        case SourceType::Regime:
            if (!semantic.source.regimeId.hasValue || !key.append("regime") ||
                !appendSourceKeyPart(key, ":", semantic.source.regimeId.value))
            {
                return false;
            }
            event.context.regimeId = semantic.source.regimeId;
            break;
        case SourceType::Admin:
            if (!semantic.source.actorCharId.hasValue || !key.append("admin") ||
                !appendSourceKeyPart(key, ":", semantic.source.actorCharId.value))
            {
                return false;
            }
            event.context.actorCharId = semantic.source.actorCharId;
            break;
        case SourceType::Script:
            if (semantic.source.scriptKey.empty() || !key.append("script:") || !key.append(semantic.source.scriptKey.view()))
            {
                return false;
            }
            event.context.scriptKey = semantic.source.scriptKey;
            break;
        case SourceType::System:
            if (semantic.source.systemKey.empty() || !key.append("system:") || !key.append(semantic.source.systemKey.view()))
            {
                return false;
            }
            event.context.systemKey = semantic.source.systemKey;
            break;
    }

    return event.sourceKey.assign(key.view());
}

void recordEvent(Category                     category,
                 std::uint64_t                amount,
                 const SemanticContext&       semantic,
                 const TransactionId&         transactionId,
                 std::optional<std::uint32_t> fromCharId,
                 std::optional<std::uint32_t> toCharId,
                 AttributionQuality           quality)
{
    auto& producer = globalProducer();
    if (!producer.enabled() || amount == 0 || amount > MaxGilAmount)
    {
        return;
    }

    Event event;
    event.occurredAtUnixNanos = unixNanosNow();
    event.transactionId       = transactionId;
    event.kind                = kindForCategory(category);
    event.category            = category;
    event.amount              = amount;
    event.zoneId              = semantic.zoneId;
    event.itemId              = semantic.itemId;
    event.itemQuantity        = semantic.itemQuantity;
    event.attributionQuality  = quality;
    static_cast<void>(event.evidenceVersion.assign(EvidenceVersionKey));

    if (fromCharId && *fromCharId > 0)
    {
        event.fromCharId.set(*fromCharId);
    }
    if (toCharId && *toCharId > 0)
    {
        event.toCharId.set(*toCharId);
    }

    if (!populateEventSource(event, semantic))
    {
        return;
    }

    static_cast<void>(producer.tryRecord(event));
}

void recordGap(std::uint32_t    charId,
               std::uint16_t    zoneId,
               std::uint64_t    before,
               std::uint64_t    after,
               EvidenceType     evidenceType,
               std::string_view detailCode,
               std::string_view sourceHint = {})
{
    if (charId == 0 || before == after)
    {
        return;
    }

    AttributionGap gap;
    gap.occurredAtUnixNanos = unixNanosNow();
    gap.charId              = charId;
    gap.zoneId.set(zoneId);
    gap.direction    = after > before ? AttributionDirection::Credit : AttributionDirection::Debit;
    gap.appliedDelta = after > before ? after - before : before - after;
    gap.evidenceType = evidenceType;
    static_cast<void>(gap.evidenceVersion.assign(EvidenceVersionKey));
    static_cast<void>(gap.detailCode.assign(detailCode));
    if (!sourceHint.empty() && isSafeToken(sourceHint) && sourceHint.size() <= gap.sourceHint.bytes.size() - 1)
    {
        static_cast<void>(gap.sourceHint.assign(sourceHint));
    }
    static_cast<void>(globalProducer().tryRecord(gap));
}

void recordForgoneMint(Category               category,
                       std::uint64_t          requested,
                       std::uint64_t          applied,
                       std::uint32_t          charId,
                       const SemanticContext& semantic,
                       const TransactionId&   transactionId,
                       AttributionQuality     quality)
{
    if (requested == 0 || requested > std::numeric_limits<std::uint32_t>::max() ||
        applied > MaxGilAmount || applied >= requested)
    {
        return;
    }

    Event sourceEvent;
    sourceEvent.zoneId = semantic.zoneId;
    if (!populateEventSource(sourceEvent, semantic))
    {
        return;
    }

    ForgoneMint diagnostic;
    diagnostic.occurredAtUnixNanos = unixNanosNow();
    diagnostic.charId              = charId;
    diagnostic.zoneId              = semantic.zoneId;
    diagnostic.requestedAmount     = requested;
    diagnostic.appliedAmount       = applied;
    diagnostic.forgoneAmount       = requested - applied;
    diagnostic.category            = category;
    diagnostic.transactionId       = transactionId;
    diagnostic.sourceType          = sourceEvent.sourceType;
    diagnostic.sourceKey           = sourceEvent.sourceKey;
    diagnostic.context             = sourceEvent.context;
    diagnostic.attributionQuality  = quality;
    static_cast<void>(diagnostic.evidenceVersion.assign(EvidenceVersionKey));
    static_cast<void>(globalProducer().tryRecord(diagnostic));
}

[[nodiscard]] auto isSafeTokenCharacter(char character) noexcept -> bool
{
    const auto alphaNumeric = (character >= 'A' && character <= 'Z') ||
                              (character >= 'a' && character <= 'z') ||
                              (character >= '0' && character <= '9');
    return alphaNumeric || character == '.' || character == '_' || character == ':' || character == '+' ||
           character == '/' || character == '-';
}

[[nodiscard]] auto scriptFileFor(const CCharEntity* PChar) noexcept -> std::string_view
{
    if (!PChar)
    {
        return {};
    }
    if (PChar->currentEvent && !PChar->currentEvent->scriptFile.empty())
    {
        return PChar->currentEvent->scriptFile;
    }
    if (PChar->eventPreparation && !PChar->eventPreparation->scriptFile.empty())
    {
        return PChar->eventPreparation->scriptFile;
    }
    return {};
}

[[nodiscard]] auto normalizedScriptKey(std::string_view path) noexcept -> ScriptKey
{
    ScriptKey key;
    while (path.starts_with("./") || path.starts_with(".\\"))
    {
        path.remove_prefix(2);
    }

    constexpr std::string_view ScriptsPrefix = "scripts/";
    if (const auto scripts = path.find(ScriptsPrefix); scripts != std::string_view::npos)
    {
        path.remove_prefix(scripts + ScriptsPrefix.size());
    }
    if (path.ends_with(".lua"))
    {
        path.remove_suffix(4);
    }

    std::array<char, 96> normalized{};
    std::size_t          length{};
    std::uint64_t        hash = 14695981039346656037ULL;
    bool                 truncated{};
    for (const auto rawCharacter : path)
    {
        const auto character = rawCharacter == '\\' ? '/' : (isSafeTokenCharacter(rawCharacter) ? rawCharacter : '-');
        hash ^= static_cast<std::uint8_t>(character);
        hash *= 1099511628211ULL;
        if (length < normalized.size())
        {
            normalized[length++] = character;
        }
        else
        {
            truncated = true;
        }
    }

    if (length == 0)
    {
        static_cast<void>(key.assign("lua-unknown"));
        return key;
    }
    if (!truncated)
    {
        static_cast<void>(key.assign({ normalized.data(), length }));
        return key;
    }

    constexpr std::size_t      PrefixLength = 71;
    constexpr std::string_view Marker       = "-fnv1a64-";
    std::array<char, 96>       hashed{};
    std::copy_n(normalized.begin(), PrefixLength, hashed.begin());
    std::copy(Marker.begin(), Marker.end(), hashed.begin() + PrefixLength);
    auto* const hashBegin = hashed.data() + PrefixLength + Marker.size();
    const auto  result    = std::to_chars(hashBegin, hashed.data() + hashed.size(), hash, 16);
    if (result.ec == std::errc{})
    {
        static_cast<void>(key.assign({ hashed.data(), static_cast<std::size_t>(result.ptr - hashed.data()) }));
    }
    else
    {
        static_cast<void>(key.assign("lua-path-hash-error"));
    }
    return key;
}

[[nodiscard]] auto activeSourceHint(const CCharEntity* PChar) noexcept -> SourceHint
{
    SourceHint hint;
    if (!PChar)
    {
        return hint;
    }

    const CBaseEntity* target = nullptr;
    if (PChar->eventPreparation && PChar->eventPreparation->targetEntity)
    {
        target = PChar->eventPreparation->targetEntity;
    }
    else if (PChar->currentEvent)
    {
        target = PChar->currentEvent->targetEntity;
    }

    KeyBuilder key;
    if (target && target->objtype == TYPE_NPC)
    {
        key.append("npc:");
        key.appendNumber(target->getZone());
        key.append(":");
        key.appendNumber(target->id);
        static_cast<void>(hint.assign(key.view()));
        return hint;
    }
    if (target && target->objtype == TYPE_MOB)
    {
        key.append("mob:");
        key.appendNumber(target->id);
        static_cast<void>(hint.assign(key.view()));
        return hint;
    }

    const auto scriptKey = normalizedScriptKey(scriptFileFor(PChar));
    key.append("script:");
    key.append(scriptKey.view());
    static_cast<void>(hint.assign(key.view()));
    return hint;
}

[[nodiscard]] auto offeredGil(CCharEntity* PChar) -> std::uint64_t
{
    if (!PChar || !PChar->UContainer)
    {
        return 0;
    }

    std::uint64_t amount{};
    for (std::uint8_t slot = 0; slot <= 8; ++slot)
    {
        const auto* item = PChar->UContainer->GetItem(slot);
        if (item && item->isType(ITEM_CURRENCY))
        {
            amount += item->getReserve();
        }
    }
    return amount;
}

void stopProducerAtExit()
{
    globalProducer().stop();
}

} // namespace

class EconomyTelemetryModule final : public CPPModule
{
public:
    void OnInit() override
    {
        auto&      producer = phoenix::economy::globalProducer();
        const auto result   = producer.startFromEnvironment();
        if (result == phoenix::economy::StartResult::Started)
        {
            std::atexit(&stopProducerAtExit);
            ShowInfo("Phoenix economy telemetry producer started");
        }
        else if (result != phoenix::economy::StartResult::Disabled &&
                 result != phoenix::economy::StartResult::AlreadyStarted)
        {
            ShowWarningFmt("Phoenix economy telemetry producer did not start: {}", producer.lastError());
        }

        auto xiTable      = lua["xi"].get_or_create<sol::table>();
        auto economyTable = xiTable["economy"].get_or_create<sol::table>();
        economyTable.set_function("enabled", []() -> bool
                                  {
                                      return phoenix::economy::globalProducer().enabled();
                                  });

        if (!producer.enabled())
        {
            return;
        }

        economyTable.set_function("beginContext", [this](CLuaBaseEntity* entity, const sol::table& table) -> bool
                                  {
                                      auto* PChar = luaCharacter(entity);
                                      auto* state = ensureState(PChar);
                                      if (!state)
                                      {
                                          return false;
                                      }

                                      if (state->contextScope.suppressionDepth > 0 ||
                                          state->contextScope.depth >= MaxSemanticContextDepth)
                                      {
                                          return correlator::beginContext(
                                                     state->contextScope, MaxSemanticContextDepth, false) !=
                                                 correlator::ContextBegin::Rejected;
                                      }

                                      const auto context = parseSemanticContext(PChar, table);
                                      const auto begin   = correlator::beginContext(
                                          state->contextScope, MaxSemanticContextDepth, context.has_value());
                                      if (begin == correlator::ContextBegin::Rejected)
                                      {
                                          return false;
                                      }
                                      if (begin == correlator::ContextBegin::Pushed)
                                      {
                                          state->contexts[state->contextScope.depth - 1] = *context;
                                      }
                                      return true;
                                  });

        economyTable.set_function("endContext", [this](CLuaBaseEntity* entity)
                                  {
                                      auto* PChar = luaCharacter(entity);
                                      auto* state = PChar ? findState(PChar->id) : nullptr;
                                      if (state && correlator::endContext(state->contextScope) == correlator::ContextEnd::Popped)
                                      {
                                          state->contexts[state->contextScope.depth] = {};
                                      }
                                  });

        economyTable.set_function("beginLuaWallet", [this](CLuaBaseEntity* entity) -> bool
                                  {
                                      auto* state = ensureState(luaCharacter(entity));
                                      if (!state || state->luaMutationDepth == std::numeric_limits<std::uint8_t>::max())
                                      {
                                          return false;
                                      }
                                      ++state->luaMutationDepth;
                                      return true;
                                  });

        economyTable.set_function("endLuaWallet",
                                  [this](CLuaBaseEntity*  entity,
                                         std::uint64_t    before,
                                         std::uint64_t    after,
                                         std::int64_t     requested,
                                         std::string_view operation)
                                  {
                                      auto* PChar = luaCharacter(entity);
                                      auto* state = PChar ? findState(PChar->id) : nullptr;
                                      if (!PChar || !state)
                                      {
                                          return;
                                      }
                                      if (state->luaMutationDepth > 0)
                                      {
                                          --state->luaMutationDepth;
                                      }
                                      recordLuaWallet(*state, PChar, before, after, requested, operation);
                                  });

        economyTable.set_function("captureShop", [this](CLuaBaseEntity* entity)
                                  {
                                      captureShop(luaCharacter(entity));
                                  });

        economyTable.set_function("stageMobDeath", [this](CLuaBaseEntity* player, CLuaBaseEntity* mob)
                                  {
                                      stageMobDeath(luaCharacter(player), luaMob(mob));
                                  });
    }

    void OnCharZoneIn(CCharEntity* PChar) override
    {
        if (!globalProducer().enabled())
        {
            return;
        }
        if (auto* state = ensureState(PChar); state)
        {
            state->zoneId = PChar->getZone();
            if (const auto gil = walletGil(PChar); gil)
            {
                state->walletShadow      = *gil;
                state->walletShadowValid = true;
            }
        }
    }

    void OnCharZoneOut(CCharEntity* PChar) override
    {
        if (!PChar)
        {
            return;
        }
        if (auto* state = findState(PChar->id); state)
        {
            expireAllPending(*state, "zone-out-unconfirmed");
            *state           = {};
            state->slotState = SlotState::Tombstone;
        }
    }

    auto OnIncomingPacket(MapSession* session, CCharEntity* PChar, CBasicPacket& packet) -> bool override
    {
        if (!globalProducer().enabled() || !session || !PChar)
        {
            return false;
        }

        auto* state = ensureState(PChar);
        if (!state)
        {
            return false;
        }
        synchronizeShadow(*state, PChar, "incoming-shadow-desync");

        switch (static_cast<PacketC2S>(packet.getType()))
        {
            case PacketC2S::GP_CLI_COMMAND_SHOP_BUY:
                stageShopBuy(*state, PChar, *packet.as<GP_CLI_COMMAND_SHOP_BUY>());
                break;
            case PacketC2S::GP_CLI_COMMAND_SHOP_SELL_SET:
                stageShopSell(*state, PChar);
                break;
            case PacketC2S::GP_CLI_COMMAND_BAZAAR_BUY:
                stageBazaar(*state, PChar, *packet.as<GP_CLI_COMMAND_BAZAAR_BUY>());
                break;
            case PacketC2S::GP_CLI_COMMAND_TRADE_RES:
                stageTrade(*state, PChar, *packet.as<GP_CLI_COMMAND_TRADE_RES>());
                break;
            case PacketC2S::GP_CLI_COMMAND_AUC:
            {
                const auto& auctionPacket = *packet.as<GP_CLI_COMMAND_AUC>();
                if (auctionPacket.Command == GP_CLI_COMMAND_AUC_COMMAND::LotIn)
                {
                    stageAuctionListing(*state, PChar, auctionPacket);
                }
                break;
            }
            default:
                break;
        }

        // Core and later modules always retain transaction ownership.
        return false;
    }

    void OnPushPacket(CCharEntity* PChar, const std::unique_ptr<CBasicPacket>& packet) override
    {
        if (!globalProducer().enabled() || !PChar || !packet)
        {
            return;
        }

        auto* state = ensureState(PChar);
        if (!state)
        {
            return;
        }

        const auto packetType = static_cast<PacketS2C>(packet->getType());
        if (packetType == PacketS2C::GP_SERV_COMMAND_ITEM_NUM && packet->getSize() >= 12 &&
            packet->ref<std::uint8_t>(8) == LOC_INVENTORY && packet->ref<std::uint8_t>(9) == 0)
        {
            observeWalletPacket(*state, packet->ref<std::uint32_t>(4));
            return;
        }

        switch (packetType)
        {
            case PacketS2C::GP_SERV_COMMAND_SHOP_BUY:
                if (packet->getSize() >= 12)
                {
                    if (auto* pending = uniquePending(*state, NativeOperation::ShopBuy); pending)
                    {
                        pending->semantic.itemQuantity.set(packet->ref<std::uint32_t>(8));
                        pending->resultObserved = true;
                        finalizeSingle(*state, *pending);
                    }
                }
                break;
            case PacketS2C::GP_SERV_COMMAND_ITEM_SAME:
                if (auto* pending = uniquePending(*state, NativeOperation::ShopSell); pending)
                {
                    pending->resultObserved = true;
                    finalizeSingle(*state, *pending);
                }
                break;
            case PacketS2C::GP_SERV_COMMAND_AUC:
                if (packet->getSize() >= 8 &&
                    packet->ref<GP_CLI_COMMAND_AUC_COMMAND>(4) == GP_CLI_COMMAND_AUC_COMMAND::LotIn &&
                    packet->ref<std::uint8_t>(6) == 1)
                {
                    if (auto* pending = uniquePending(*state, NativeOperation::AuctionListing); pending)
                    {
                        pending->resultObserved = true;
                        finalizeSingle(*state, *pending);
                    }
                }
                break;
            case PacketS2C::GP_SERV_COMMAND_BAZAAR_BUY:
                if (packet->getSize() >= 8)
                {
                    auto* pending = uniquePending(*state, NativeOperation::Bazaar);
                    if (packet->ref<std::uint32_t>(4) == 0)
                    {
                        if (pending)
                        {
                            pending->resultObserved = true;
                            finalizeBazaar(*state, *pending);
                        }
                    }
                    else if (pending)
                    {
                        expirePending(*state, *pending, "bazaar-rejected-after-wallet");
                    }
                }
                break;
            case PacketS2C::GP_SERV_COMMAND_ITEM_TRADE_RES:
                if (packet->getSize() >= 12)
                {
                    const auto kind = packet->ref<GP_ITEM_TRADE_RES_KIND>(8);
                    if (auto* pending = uniquePending(*state, NativeOperation::PlayerTrade); pending)
                    {
                        if (kind == GP_ITEM_TRADE_RES_KIND::End)
                        {
                            pending->resultObserved = true;
                            finalizeTrade(*state, *pending);
                        }
                        else if (kind == GP_ITEM_TRADE_RES_KIND::Cancell || kind == GP_ITEM_TRADE_RES_KIND::MakeCancell ||
                                 kind == GP_ITEM_TRADE_RES_KIND::ErrEtc || kind == GP_ITEM_TRADE_RES_KIND::ErrNoSearchYou ||
                                 kind == GP_ITEM_TRADE_RES_KIND::ErrNowReq || kind == GP_ITEM_TRADE_RES_KIND::ErrYouTrade ||
                                 kind == GP_ITEM_TRADE_RES_KIND::ErrLogout)
                        {
                            expirePending(*state, *pending, "trade-cancelled-after-wallet");
                        }
                    }
                }
                break;
            case PacketS2C::GP_SERV_COMMAND_BATTLE_MESSAGE:
                observeMobGilMessage(*state, packet.get());
                break;
            default:
                break;
        }
    }

    void OnZoneTick(CZone* PZone) override
    {
        if (!globalProducer().enabled() || !PZone)
        {
            return;
        }

        const auto now = SteadyClock::now();
        if (now < nextExpirySweep_)
        {
            return;
        }
        nextExpirySweep_ = now + ExpirySweepInterval;

        for (auto& state : characters_)
        {
            if (state.slotState != SlotState::Occupied)
            {
                continue;
            }
            if (state.shop.active && state.shop.deadline <= now)
            {
                state.shop = {};
            }

            for (auto& pending : state.pending)
            {
                if (!pending.active || pending.deadline > now)
                {
                    continue;
                }
                if (pending.role == PairRole::Second && findPeerPending(pending))
                {
                    continue;
                }
                expirePending(state, pending, "packet-correlation-expired");
            }
        }
    }

    void OnTimeServerTick() override
    {
        globalProducer().noteGameTick();
    }

private:
    [[nodiscard]] auto findState(std::uint32_t charId) -> CharacterState*
    {
        if (charId == 0)
        {
            return nullptr;
        }

        const auto start = (static_cast<std::size_t>(charId) * 2654435761U) & (MaxTrackedCharacters - 1);
        for (std::size_t probe = 0; probe < MaxTrackedCharacters; ++probe)
        {
            auto& state = characters_[(start + probe) & (MaxTrackedCharacters - 1)];
            if (state.slotState == SlotState::Empty)
            {
                return nullptr;
            }
            if (state.slotState == SlotState::Occupied && state.charId == charId)
            {
                return &state;
            }
        }
        return nullptr;
    }

    [[nodiscard]] auto ensureState(CCharEntity* PChar) -> CharacterState*
    {
        if (!PChar || PChar->id == 0)
        {
            return nullptr;
        }
        if (auto* existing = findState(PChar->id); existing)
        {
            existing->zoneId = PChar->getZone();
            return existing;
        }

        const auto      start     = (static_cast<std::size_t>(PChar->id) * 2654435761U) & (MaxTrackedCharacters - 1);
        CharacterState* tombstone = nullptr;
        for (std::size_t probe = 0; probe < MaxTrackedCharacters; ++probe)
        {
            auto& state = characters_[(start + probe) & (MaxTrackedCharacters - 1)];
            if (state.slotState == SlotState::Tombstone && !tombstone)
            {
                tombstone = &state;
                continue;
            }
            if (state.slotState != SlotState::Empty)
            {
                continue;
            }

            auto* destination      = tombstone ? tombstone : &state;
            *destination           = {};
            destination->slotState = SlotState::Occupied;
            destination->charId    = PChar->id;
            destination->zoneId    = PChar->getZone();
            if (const auto gil = walletGil(PChar); gil)
            {
                destination->walletShadow      = *gil;
                destination->walletShadowValid = true;
            }
            return destination;
        }

        if (tombstone)
        {
            *tombstone           = {};
            tombstone->slotState = SlotState::Occupied;
            tombstone->charId    = PChar->id;
            tombstone->zoneId    = PChar->getZone();
            if (const auto gil = walletGil(PChar); gil)
            {
                tombstone->walletShadow      = *gil;
                tombstone->walletShadowValid = true;
            }
            return tombstone;
        }
        return nullptr;
    }

    void synchronizeShadow(CharacterState& state, CCharEntity* PChar, std::string_view detail)
    {
        const auto current = walletGil(PChar);
        if (!current)
        {
            return;
        }
        if (state.walletShadowValid && state.walletShadow != *current)
        {
            const auto hint = activeSourceHint(PChar);
            recordGap(state.charId, state.zoneId, state.walletShadow, *current, EvidenceType::WalletObserver, detail, hint.view());
        }
        state.walletShadow      = *current;
        state.walletShadowValid = true;
    }

    [[nodiscard]] auto allocatePending(CharacterState& state, NativeOperation operation) -> PendingOperation*
    {
        for (auto& existing : state.pending)
        {
            if (existing.active && existing.operation == operation)
            {
                expirePending(state, existing, "superseded-native-operation");
                break;
            }
        }
        for (auto& pending : state.pending)
        {
            if (!pending.active)
            {
                pending           = {};
                pending.active    = true;
                pending.operation = operation;
                pending.beforeGil = state.walletShadow;
                pending.latestGil = state.walletShadow;
                pending.deadline  = SteadyClock::now() + NativeDeadline;
                return &pending;
            }
        }
        state.pendingOverflow = true;
        return nullptr;
    }

    [[nodiscard]] auto uniquePending(CharacterState& state, NativeOperation operation) -> PendingOperation*
    {
        PendingOperation* result = nullptr;
        for (auto& pending : state.pending)
        {
            if (!pending.active || pending.operation != operation)
            {
                continue;
            }
            if (result)
            {
                result->ambiguous = true;
                pending.ambiguous = true;
                return nullptr;
            }
            result = &pending;
        }
        return result;
    }

    [[nodiscard]] auto findPendingByTransaction(CharacterState& state, const TransactionId& transactionId) -> PendingOperation*
    {
        for (auto& pending : state.pending)
        {
            if (pending.active && pending.transactionId.view() == transactionId.view())
            {
                return &pending;
            }
        }
        return nullptr;
    }

    [[nodiscard]] auto findPeerPending(const PendingOperation& pending) -> PendingOperation*
    {
        const auto peerId    = pending.role == PairRole::First ? pending.secondCharId : pending.firstCharId;
        auto*      peerState = findState(peerId);
        return peerState ? findPendingByTransaction(*peerState, pending.transactionId) : nullptr;
    }

    void clearTransaction(const PendingOperation& pending)
    {
        const auto transactionId = pending.transactionId;
        const auto firstId       = pending.firstCharId;
        const auto secondId      = pending.secondCharId;
        if (auto* first = findState(firstId); first)
        {
            if (auto* local = findPendingByTransaction(*first, transactionId); local)
            {
                *local = {};
            }
        }
        if (secondId != 0)
        {
            if (auto* second = findState(secondId); second)
            {
                if (auto* local = findPendingByTransaction(*second, transactionId); local)
                {
                    *local = {};
                }
            }
        }
    }

    void gapPendingLocal(CharacterState& state, PendingOperation& pending, std::string_view detail)
    {
        if (pending.gapReported ||
            correlator::expiryStatus(pending.walletObserved, pending.beforeGil, pending.latestGil) != correlator::Status::Gap)
        {
            return;
        }
        recordGap(state.charId,
                  state.zoneId,
                  pending.beforeGil,
                  pending.latestGil,
                  EvidenceType::PacketCorrelator,
                  detail,
                  operationHint(pending.operation));
        pending.gapReported = true;
    }

    void expirePending(CharacterState& state, PendingOperation& pending, std::string_view detail)
    {
        if (!pending.active)
        {
            return;
        }
        gapPendingLocal(state, pending, detail);
        if (auto* peer = findPeerPending(pending); peer)
        {
            const auto peerId = pending.role == PairRole::First ? pending.secondCharId : pending.firstCharId;
            if (auto* peerState = findState(peerId); peerState)
            {
                gapPendingLocal(*peerState, *peer, detail);
            }
        }
        clearTransaction(pending);
    }

    void expireAllPending(CharacterState& state, std::string_view detail)
    {
        for (auto& pending : state.pending)
        {
            if (pending.active)
            {
                expirePending(state, pending, detail);
            }
        }
    }

    [[nodiscard]] static auto operationHint(NativeOperation operation) -> std::string_view
    {
        switch (operation)
        {
            case NativeOperation::ShopBuy:
                return "packet:shop-buy";
            case NativeOperation::ShopSell:
                return "packet:shop-sell";
            case NativeOperation::Bazaar:
                return "packet:bazaar";
            case NativeOperation::PlayerTrade:
                return "packet:player-trade";
            case NativeOperation::AuctionListing:
                return "packet:auction-listing";
            case NativeOperation::MobDrop:
                return "packet:mob-drop";
        }
        return "packet:unknown";
    }

    void observeWalletPacket(CharacterState& state, std::uint64_t newGil)
    {
        if (state.luaMutationDepth > 0)
        {
            return;
        }
        if (!state.walletShadowValid)
        {
            state.walletShadow      = newGil;
            state.walletShadowValid = true;
            return;
        }

        const auto before  = state.walletShadow;
        state.walletShadow = newGil;

        std::array<PendingOperation*, MaxPendingPerCharacter> candidates{};
        std::size_t                                           candidateCount{};
        for (auto& pending : state.pending)
        {
            if (pending.active)
            {
                candidates[candidateCount++] = &pending;
            }
        }

        if (state.pendingOverflow)
        {
            if (before != newGil)
            {
                recordGap(state.charId,
                          state.zoneId,
                          before,
                          newGil,
                          EvidenceType::WalletObserver,
                          "pending-context-overflow",
                          "packet:overflow");
            }
            state.pendingOverflow = false;
            for (std::size_t index = 0; index < candidateCount; ++index)
            {
                candidates[index]->ambiguous = true;
            }
            return;
        }

        if (candidateCount == 0)
        {
            if (before != newGil)
            {
                recordGap(state.charId,
                          state.zoneId,
                          before,
                          newGil,
                          EvidenceType::WalletObserver,
                          "unmatched-wallet-packet",
                          "packet:item-num");
            }
            return;
        }

        if (candidateCount > 1)
        {
            if (before != newGil)
            {
                recordGap(state.charId,
                          state.zoneId,
                          before,
                          newGil,
                          EvidenceType::PacketCorrelator,
                          "ambiguous-wallet-packet",
                          "packet:item-num");
            }
            for (std::size_t index = 0; index < candidateCount; ++index)
            {
                auto* pending           = candidates[index];
                pending->ambiguous      = true;
                pending->walletObserved = true;
                pending->latestGil      = newGil;
                pending->gapReported    = before != newGil;
            }
            return;
        }

        auto& pending          = *candidates[0];
        pending.walletObserved = true;
        pending.latestGil      = newGil;
        ++pending.walletPacketCount;
        if (pending.resultObserved)
        {
            if (pending.operation == NativeOperation::ShopBuy || pending.operation == NativeOperation::ShopSell ||
                pending.operation == NativeOperation::AuctionListing)
            {
                finalizeSingle(state, pending);
            }
            else if (pending.operation == NativeOperation::Bazaar)
            {
                finalizeBazaar(state, pending);
            }
            else if (pending.operation == NativeOperation::PlayerTrade)
            {
                finalizeTrade(state, pending);
            }
        }
    }

    void finalizeSingle(CharacterState& state, PendingOperation& pending)
    {
        if (!pending.active || !pending.resultObserved || !pending.walletObserved)
        {
            return;
        }
        if (pending.ambiguous)
        {
            expirePending(state, pending, "ambiguous-single-operation");
            return;
        }

        const auto            before = pending.beforeGil;
        const auto            after  = pending.latestGil;
        Category              category{};
        correlator::Direction expectedDirection{};
        switch (pending.operation)
        {
            case NativeOperation::ShopBuy:
                category          = Category::NpcShopPurchase;
                expectedDirection = correlator::Direction::Debit;
                break;
            case NativeOperation::ShopSell:
                category          = Category::NpcVendorSale;
                expectedDirection = correlator::Direction::Credit;
                break;
            case NativeOperation::AuctionListing:
                category          = Category::AuctionListingFee;
                expectedDirection = correlator::Direction::Debit;
                break;
            default:
                expirePending(state, pending, "invalid-single-operation");
                return;
        }

        const auto reconciliation = correlator::reconcileSingle(before, after, expectedDirection);
        if (reconciliation.status == correlator::Status::NoChange)
        {
            if (pending.operation == NativeOperation::ShopSell && pending.expectedBaseAmount > 0)
            {
                recordForgoneMint(Category::NpcVendorSale,
                                  pending.expectedBaseAmount,
                                  0,
                                  state.charId,
                                  pending.semantic,
                                  pending.transactionId,
                                  AttributionQuality::Correlated);
            }
            pending = {};
            return;
        }

        if (reconciliation.status != correlator::Status::Complete)
        {
            expirePending(state, pending, "single-operation-direction-mismatch");
            return;
        }

        const auto amount = reconciliation.amount;
        if (pending.operation == NativeOperation::ShopSell && pending.expectedBaseAmount > 0 &&
            amount > pending.expectedBaseAmount)
        {
            expirePending(state, pending, "shop-sell-amount-mismatch");
            return;
        }
        if (kindForCategory(category) == Kind::Mint)
        {
            recordEvent(category,
                        amount,
                        pending.semantic,
                        pending.transactionId,
                        std::nullopt,
                        state.charId,
                        AttributionQuality::Correlated);
        }
        else
        {
            recordEvent(category,
                        amount,
                        pending.semantic,
                        pending.transactionId,
                        state.charId,
                        std::nullopt,
                        AttributionQuality::Correlated);
        }
        if (pending.operation == NativeOperation::ShopSell && pending.expectedBaseAmount > amount)
        {
            recordForgoneMint(Category::NpcVendorSale,
                              pending.expectedBaseAmount,
                              amount,
                              state.charId,
                              pending.semantic,
                              pending.transactionId,
                              AttributionQuality::Correlated);
        }
        pending = {};
    }

    void finalizeBazaar(CharacterState& state, PendingOperation& pending)
    {
        if (!pending.active || pending.role != PairRole::First || !pending.resultObserved)
        {
            return;
        }
        auto* peerState = findState(pending.secondCharId);
        auto* peer      = peerState ? findPendingByTransaction(*peerState, pending.transactionId) : nullptr;
        if (!peer || !pending.walletObserved || !peer->walletObserved)
        {
            return;
        }
        if (pending.ambiguous || peer->ambiguous)
        {
            expirePending(state, pending, "ambiguous-bazaar-reconciliation");
            return;
        }

        const auto buyerBefore    = pending.beforeGil;
        const auto buyerAfter     = pending.latestGil;
        const auto sellerBefore   = peer->beforeGil;
        const auto sellerAfter    = peer->latestGil;
        const auto reconciliation = correlator::reconcileBazaar(
            buyerBefore, buyerAfter, sellerBefore, sellerAfter, pending.expectedBaseAmount);
        if (reconciliation.status != correlator::Status::Complete)
        {
            expirePending(state, pending, "bazaar-leg-mismatch");
            return;
        }

        if (reconciliation.transfer > 0)
        {
            recordEvent(Category::BazaarSale,
                        reconciliation.transfer,
                        pending.semantic,
                        pending.transactionId,
                        pending.firstCharId,
                        pending.secondCharId,
                        AttributionQuality::Correlated);
        }
        if (reconciliation.tax > 0)
        {
            recordEvent(Category::BazaarTax,
                        reconciliation.tax,
                        pending.semantic,
                        pending.transactionId,
                        pending.firstCharId,
                        std::nullopt,
                        AttributionQuality::Correlated);
        }
        if (reconciliation.capLoss > 0)
        {
            recordEvent(Category::CurrencyCapLoss,
                        reconciliation.capLoss,
                        pending.semantic,
                        pending.transactionId,
                        pending.firstCharId,
                        std::nullopt,
                        AttributionQuality::Correlated);
        }
        clearTransaction(pending);
    }

    void finalizeTrade(CharacterState& state, PendingOperation& pending)
    {
        auto* peerState = findState(pending.role == PairRole::First ? pending.secondCharId : pending.firstCharId);
        auto* peer      = peerState ? findPendingByTransaction(*peerState, pending.transactionId) : nullptr;
        if (!peer || !pending.resultObserved || !peer->resultObserved)
        {
            return;
        }

        auto* firstState  = findState(pending.firstCharId);
        auto* secondState = findState(pending.secondCharId);
        auto* first       = firstState ? findPendingByTransaction(*firstState, pending.transactionId) : nullptr;
        auto* second      = secondState ? findPendingByTransaction(*secondState, pending.transactionId) : nullptr;
        if (!firstState || !secondState || !first || !second)
        {
            expirePending(state, pending, "trade-counterpart-missing");
            return;
        }
        if ((pending.firstOffer > 0 || pending.secondOffer > 0) && (!first->walletObserved || !second->walletObserved))
        {
            return;
        }
        if (first->ambiguous || second->ambiguous)
        {
            expirePending(*firstState, *first, "ambiguous-trade-reconciliation");
            return;
        }
        if (pending.firstOffer == 0 && pending.secondOffer == 0)
        {
            clearTransaction(*first);
            return;
        }

        const auto reconciliation = correlator::reconcileTrade(pending.firstBefore,
                                                               first->latestGil,
                                                               pending.secondBefore,
                                                               second->latestGil,
                                                               pending.firstOffer,
                                                               pending.secondOffer);
        if (reconciliation.status != correlator::Status::Complete)
        {
            expirePending(*firstState, *first, "trade-leg-mismatch");
            return;
        }

        if (reconciliation.firstToSecond > 0)
        {
            recordEvent(Category::PlayerTrade,
                        reconciliation.firstToSecond,
                        pending.semantic,
                        pending.transactionId,
                        pending.firstCharId,
                        pending.secondCharId,
                        AttributionQuality::Correlated);
        }
        if (reconciliation.firstCapLoss > 0)
        {
            recordEvent(Category::CurrencyCapLoss,
                        reconciliation.firstCapLoss,
                        pending.semantic,
                        pending.transactionId,
                        pending.firstCharId,
                        std::nullopt,
                        AttributionQuality::Correlated);
        }
        if (reconciliation.secondToFirst > 0)
        {
            recordEvent(Category::PlayerTrade,
                        reconciliation.secondToFirst,
                        pending.semantic,
                        pending.transactionId,
                        pending.secondCharId,
                        pending.firstCharId,
                        AttributionQuality::Correlated);
        }
        if (reconciliation.secondCapLoss > 0)
        {
            recordEvent(Category::CurrencyCapLoss,
                        reconciliation.secondCapLoss,
                        pending.semantic,
                        pending.transactionId,
                        pending.secondCharId,
                        std::nullopt,
                        AttributionQuality::Correlated);
        }
        clearTransaction(*first);
    }

    void observeMobGilMessage(CharacterState& state, CBasicPacket* packet)
    {
        const auto* message = dynamic_cast<const GP_SERV_COMMAND_BATTLE_MESSAGE*>(packet);
        if (!message || message->getMessageId() != MsgBasic::Obtains || packet->getSize() < 16)
        {
            return;
        }

        auto* pending = uniquePending(state, NativeOperation::MobDrop);
        if (!pending || !pending->walletObserved)
        {
            return;
        }
        const auto requested = packet->ref<std::uint32_t>(12);
        if (pending->ambiguous || pending->latestGil < pending->beforeGil)
        {
            expirePending(state, *pending, "ambiguous-mob-gil-correlation");
            return;
        }

        const auto applied = pending->latestGil - pending->beforeGil;
        if (applied > requested)
        {
            expirePending(state, *pending, "mob-gil-message-mismatch");
            return;
        }
        if (applied > 0)
        {
            recordEvent(Category::MobDrop,
                        applied,
                        pending->semantic,
                        pending->transactionId,
                        std::nullopt,
                        state.charId,
                        AttributionQuality::Correlated);
        }
        if (requested > applied)
        {
            recordForgoneMint(Category::MobDrop,
                              requested,
                              applied,
                              state.charId,
                              pending->semantic,
                              pending->transactionId,
                              AttributionQuality::Correlated);
        }
        *pending = {};
    }

    void recordLuaWallet(CharacterState&  state,
                         CCharEntity*     PChar,
                         std::uint64_t    before,
                         std::uint64_t    after,
                         std::int64_t     requested,
                         std::string_view operation)
    {
        if (state.walletShadowValid && state.walletShadow != before)
        {
            const auto hint = activeSourceHint(PChar);
            recordGap(state.charId,
                      state.zoneId,
                      state.walletShadow,
                      before,
                      EvidenceType::WalletObserver,
                      "lua-shadow-desync",
                      hint.view());
        }
        state.walletShadow      = after;
        state.walletShadowValid = true;

        if (before != after)
        {
            for (auto& pending : state.pending)
            {
                if (pending.active)
                {
                    pending.ambiguous = true;
                }
            }
        }

        const auto* semantic = correlator::semanticContextUsable(state.contextScope) ? &state.contexts[state.contextScope.depth - 1] : nullptr;
        if (before == after)
        {
            if (semantic && semantic->mintCategory && requested > 0)
            {
                std::uint64_t intended{};
                if (operation == "add")
                {
                    intended = static_cast<std::uint64_t>(requested);
                }
                else if (operation == "set" && static_cast<std::uint64_t>(requested) > before)
                {
                    intended = static_cast<std::uint64_t>(requested) - before;
                }
                recordForgoneMint(*semantic->mintCategory,
                                  intended,
                                  0,
                                  state.charId,
                                  *semantic,
                                  semantic->transactionId,
                                  AttributionQuality::Semantic);
            }
            return;
        }

        if (!semantic)
        {
            const auto hint = activeSourceHint(PChar);
            recordGap(state.charId,
                      state.zoneId,
                      before,
                      after,
                      EvidenceType::LuaWallet,
                      state.contextScope.suppressionDepth > 0 ? "lua-context-rejected" : (after > before ? "lua-unattributed-credit" : "lua-unattributed-debit"),
                      hint.view());
            return;
        }

        if (after > before)
        {
            if (!semantic->mintCategory)
            {
                recordGap(state.charId,
                          state.zoneId,
                          before,
                          after,
                          EvidenceType::LuaWallet,
                          "lua-credit-missing-category");
                return;
            }
            const auto applied = after - before;
            recordEvent(*semantic->mintCategory,
                        applied,
                        *semantic,
                        semantic->transactionId,
                        std::nullopt,
                        state.charId,
                        AttributionQuality::Semantic);

            std::uint64_t intended{};
            if (operation == "add" && requested > 0)
            {
                intended = static_cast<std::uint64_t>(requested);
            }
            else if (operation == "set" && requested > 0 && static_cast<std::uint64_t>(requested) > before)
            {
                intended = static_cast<std::uint64_t>(requested) - before;
            }
            if (intended > applied)
            {
                recordForgoneMint(*semantic->mintCategory,
                                  intended,
                                  applied,
                                  state.charId,
                                  *semantic,
                                  semantic->transactionId,
                                  AttributionQuality::Semantic);
            }
        }
        else
        {
            if (!semantic->burnCategory)
            {
                recordGap(state.charId,
                          state.zoneId,
                          before,
                          after,
                          EvidenceType::LuaWallet,
                          "lua-debit-missing-category");
                return;
            }
            recordEvent(*semantic->burnCategory,
                        before - after,
                        *semantic,
                        semantic->transactionId,
                        state.charId,
                        std::nullopt,
                        AttributionQuality::Semantic);
        }
    }

    void captureShop(CCharEntity* PChar)
    {
        auto* state = ensureState(PChar);
        if (!state || !PChar)
        {
            return;
        }

        CBaseEntity* target = nullptr;
        if (PChar->eventPreparation && PChar->eventPreparation->targetEntity)
        {
            target = PChar->eventPreparation->targetEntity;
        }
        else if (PChar->currentEvent)
        {
            target = PChar->currentEvent->targetEntity;
        }

        state->shop = {};
        if (!target || target->objtype != TYPE_NPC)
        {
            return;
        }

        state->shop.active              = true;
        state->shop.deadline            = SteadyClock::now() + ShopDeadline;
        state->shop.semantic.sourceType = SourceType::Npc;
        state->shop.semantic.zoneId.set(target->getZone());
        state->shop.semantic.source.npcId.set(target->id);
    }

    void stageMobDeath(CCharEntity* PChar, CMobEntity* PMob)
    {
        if (!PChar || !PMob)
        {
            return;
        }
        auto* state = ensureState(PChar);
        if (!state)
        {
            return;
        }
        synchronizeShadow(*state, PChar, "mob-stage-shadow-desync");
        if (auto* prior = uniquePending(*state, NativeOperation::MobDrop); prior)
        {
            expirePending(*state, *prior, "mob-context-superseded");
        }

        auto* pending = allocatePending(*state, NativeOperation::MobDrop);
        if (!pending)
        {
            return;
        }
        pending->deadline            = SteadyClock::now() + MobDeadline;
        pending->transactionId       = globalProducer().nextTransactionId("mob");
        pending->firstCharId         = PChar->id;
        pending->firstBefore         = state->walletShadow;
        pending->semantic.sourceType = SourceType::Mob;
        pending->semantic.zoneId.set(PMob->getZone());
        pending->semantic.source.mobSpawnId.set(PMob->id);
        if (PMob->m_Pool > 0)
        {
            pending->semantic.source.mobPoolId.set(PMob->m_Pool);
        }
    }

    void stageShopBuy(CharacterState& state, CCharEntity* PChar, const GP_CLI_COMMAND_SHOP_BUY& packet)
    {
        const auto now = SteadyClock::now();
        if (!state.shop.active || state.shop.deadline <= now || !PChar->Container ||
            packet.ShopItemIndex >= PChar->Container->getExSize())
        {
            state.shop = {};
            return;
        }

        auto* pending = allocatePending(state, NativeOperation::ShopBuy);
        if (!pending)
        {
            return;
        }
        pending->transactionId = globalProducer().nextTransactionId("shop-buy");
        pending->firstCharId   = state.charId;
        pending->firstBefore   = state.walletShadow;
        pending->semantic      = state.shop.semantic;
        pending->semantic.source.shopId.set(packet.ShopNo);
        std::uint16_t itemId = 0;
        if (packet.ShopItemIndex <= std::numeric_limits<uint8>::max())
        {
            itemId = PChar->Container->getItemID(static_cast<uint8>(packet.ShopItemIndex));
        }
        if (itemId > 0)
        {
            pending->semantic.itemId.set(itemId);
        }
    }

    void stageShopSell(CharacterState& state, CCharEntity* PChar)
    {
        const auto now = SteadyClock::now();
        if (!state.shop.active || state.shop.deadline <= now || !PChar->Container)
        {
            state.shop = {};
            return;
        }

        auto* pending = allocatePending(state, NativeOperation::ShopSell);
        if (!pending)
        {
            return;
        }
        pending->transactionId = globalProducer().nextTransactionId("shop-sell");
        pending->firstCharId   = state.charId;
        pending->firstBefore   = state.walletShadow;
        pending->semantic      = state.shop.semantic;
        const auto index       = PChar->Container->getExSize();
        const auto itemId      = PChar->Container->getItemID(index);
        const auto quantity    = PChar->Container->getQuantity(index);
        if (itemId > 0 && quantity > 0)
        {
            pending->semantic.itemId.set(itemId);
            pending->semantic.itemQuantity.set(quantity);
            const auto slotId = PChar->Container->getInvSlotID(index);
            if (const auto* inventory = PChar->getStorage(LOC_INVENTORY))
            {
                if (const auto* item = inventory->GetItem(slotId); item && item->getID() == itemId)
                {
                    pending->expectedBaseAmount = static_cast<std::uint32_t>(quantity * item->getBasePrice());
                }
            }
        }
    }

    void stageAuctionListing(CharacterState& state, CCharEntity* PChar, const GP_CLI_COMMAND_AUC& packet)
    {
        auto* pending = allocatePending(state, NativeOperation::AuctionListing);
        if (!pending)
        {
            return;
        }
        pending->transactionId = globalProducer().nextTransactionId("ah-list");
        pending->firstCharId   = state.charId;
        pending->firstBefore   = state.walletShadow;
        pending->semantic      = systemContext("auction-house");
        pending->semantic.zoneId.set(PChar->getZone());

        if (const auto* inventory = PChar->getStorage(LOC_INVENTORY);
            inventory && packet.Param.LotIn.ItemWorkIndex <= std::numeric_limits<uint8>::max())
        {
            if (const auto* item = inventory->GetItem(static_cast<uint8>(packet.Param.LotIn.ItemWorkIndex)); item)
            {
                pending->semantic.itemId.set(item->getID());
                pending->semantic.itemQuantity.set(packet.Param.LotIn.ItemStacks == 0 ? item->getStackSize() : 1);
            }
        }
    }

    void stageBazaar(CharacterState& buyerState, CCharEntity* PBuyer, const GP_CLI_COMMAND_BAZAAR_BUY& packet)
    {
        auto* PSeller = static_cast<CCharEntity*>(PBuyer->GetEntity(PBuyer->BazaarID.targid, TYPE_PC));
        if (!PSeller || PSeller->id != PBuyer->BazaarID.id)
        {
            return;
        }
        auto* sellerState = ensureState(PSeller);
        if (!sellerState)
        {
            return;
        }
        synchronizeShadow(*sellerState, PSeller, "bazaar-peer-shadow-desync");

        std::uint16_t itemId{};
        std::uint64_t baseAmount{};
        if (const auto* inventory = PSeller->getStorage(LOC_INVENTORY))
        {
            if (const auto* item = inventory->GetItem(packet.BazaarItemIndex); item)
            {
                itemId     = item->getID();
                baseAmount = static_cast<std::uint64_t>(item->getCharPrice()) * packet.BuyNum;
            }
        }
        if (baseAmount == 0)
        {
            return;
        }

        auto* buyerPending  = allocatePending(buyerState, NativeOperation::Bazaar);
        auto* sellerPending = allocatePending(*sellerState, NativeOperation::Bazaar);
        if (!buyerPending || !sellerPending)
        {
            if (buyerPending)
            {
                *buyerPending = {};
            }
            if (sellerPending)
            {
                *sellerPending = {};
            }
            buyerState.pendingOverflow   = true;
            sellerState->pendingOverflow = true;
            return;
        }

        const auto transactionId = globalProducer().nextTransactionId("bazaar");
        const auto deadline      = SteadyClock::now() + NativeDeadline;
        auto       semantic      = systemContext("bazaar");
        semantic.zoneId.set(PBuyer->getZone());
        if (itemId > 0)
        {
            semantic.itemId.set(itemId);
            semantic.itemQuantity.set(packet.BuyNum);
        }

        *buyerPending                     = makePairPending(NativeOperation::Bazaar,
                                                            PairRole::First,
                                                            transactionId,
                                                            deadline,
                                                            semantic,
                                                            PBuyer->id,
                                                            PSeller->id,
                                                            buyerState.walletShadow,
                                                            sellerState->walletShadow);
        *sellerPending                    = *buyerPending;
        sellerPending->role               = PairRole::Second;
        sellerPending->beforeGil          = sellerState->walletShadow;
        sellerPending->latestGil          = sellerState->walletShadow;
        buyerPending->expectedBaseAmount  = baseAmount;
        sellerPending->expectedBaseAmount = baseAmount;
    }

    void stageTrade(CharacterState& firstState, CCharEntity* PFirst, const GP_CLI_COMMAND_TRADE_RES& packet)
    {
        if (static_cast<GP_CLI_COMMAND_TRADE_RES_KIND>(packet.Kind) != GP_CLI_COMMAND_TRADE_RES_KIND::Make)
        {
            return;
        }
        auto* PSecond = static_cast<CCharEntity*>(PFirst->GetEntity(PFirst->TradePending.targid, TYPE_PC));
        if (!PSecond || !PSecond->UContainer || !PSecond->UContainer->IsLocked() ||
            PFirst->TradePending.id != PSecond->id || PSecond->TradePending.id != PFirst->id)
        {
            return;
        }
        auto* secondState = ensureState(PSecond);
        if (!secondState)
        {
            return;
        }
        synchronizeShadow(*secondState, PSecond, "trade-peer-shadow-desync");

        auto* firstPending  = allocatePending(firstState, NativeOperation::PlayerTrade);
        auto* secondPending = allocatePending(*secondState, NativeOperation::PlayerTrade);
        if (!firstPending || !secondPending)
        {
            if (firstPending)
            {
                *firstPending = {};
            }
            if (secondPending)
            {
                *secondPending = {};
            }
            firstState.pendingOverflow   = true;
            secondState->pendingOverflow = true;
            return;
        }

        const auto transactionId = globalProducer().nextTransactionId("trade");
        const auto deadline      = SteadyClock::now() + NativeDeadline;
        auto       semantic      = systemContext("player-trade");
        semantic.zoneId.set(PFirst->getZone());
        *firstPending             = makePairPending(NativeOperation::PlayerTrade,
                                                    PairRole::First,
                                                    transactionId,
                                                    deadline,
                                                    semantic,
                                                    PFirst->id,
                                                    PSecond->id,
                                                    firstState.walletShadow,
                                                    secondState->walletShadow);
        firstPending->firstOffer  = offeredGil(PFirst);
        firstPending->secondOffer = offeredGil(PSecond);
        *secondPending            = *firstPending;
        secondPending->role       = PairRole::Second;
        secondPending->beforeGil  = secondState->walletShadow;
        secondPending->latestGil  = secondState->walletShadow;
    }

    [[nodiscard]] static auto makePairPending(NativeOperation         operation,
                                              PairRole                role,
                                              const TransactionId&    transactionId,
                                              SteadyClock::time_point deadline,
                                              const SemanticContext&  semantic,
                                              std::uint32_t           firstId,
                                              std::uint32_t           secondId,
                                              std::uint64_t           firstBefore,
                                              std::uint64_t           secondBefore) -> PendingOperation
    {
        PendingOperation pending;
        pending.active        = true;
        pending.operation     = operation;
        pending.role          = role;
        pending.transactionId = transactionId;
        pending.deadline      = deadline;
        pending.semantic      = semantic;
        pending.firstCharId   = firstId;
        pending.secondCharId  = secondId;
        pending.firstBefore   = firstBefore;
        pending.secondBefore  = secondBefore;
        pending.beforeGil     = role == PairRole::First ? firstBefore : secondBefore;
        pending.latestGil     = pending.beforeGil;
        return pending;
    }

    std::array<CharacterState, MaxTrackedCharacters> characters_{};
    SteadyClock::time_point                          nextExpirySweep_{};
};

REGISTER_CPP_MODULE(EconomyTelemetryModule);
