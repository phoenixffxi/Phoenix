#include "economy_event.h"

#include <algorithm>
#include <chrono>
#include <limits>

namespace phoenix::economy
{
namespace
{

template <std::size_t Capacity>
auto appendToken(FixedString<Capacity>& output, std::string_view token) noexcept -> bool
{
    if (output.length + token.size() > Capacity)
    {
        return false;
    }

    std::memcpy(output.bytes.data() + output.length, token.data(), token.size());
    output.length               = static_cast<std::uint16_t>(output.length + token.size());
    output.bytes[output.length] = '\0';
    return true;
}

template <std::size_t Capacity, typename T>
auto appendNumber(FixedString<Capacity>& output, T value) noexcept -> bool
{
    auto* const begin  = output.bytes.data() + output.length;
    auto* const end    = output.bytes.data() + Capacity;
    const auto  result = std::to_chars(begin, end, value);
    if (result.ec != std::errc{})
    {
        return false;
    }

    output.length               = static_cast<std::uint16_t>(result.ptr - output.bytes.data());
    output.bytes[output.length] = '\0';
    return true;
}

auto canonicalSourceKey(const Event& event, SourceKey& output) noexcept -> bool
{
    output.clear();
    const auto colon = [&output]()
    {
        return appendToken(output, ":");
    };

    switch (event.sourceType)
    {
        case SourceType::Mob:
            return appendToken(output, "mob") && colon() && appendNumber(output, event.context.mobSpawnId.value);
        case SourceType::Npc:
            return appendToken(output, "npc") && colon() && appendNumber(output, event.zoneId.value) && colon() &&
                   appendNumber(output, event.context.npcId.value);
        case SourceType::Quest:
            return appendToken(output, "quest") && colon() && appendNumber(output, event.context.questLogId.value) && colon() &&
                   appendNumber(output, event.context.questId.value);
        case SourceType::Mission:
            return appendToken(output, "mission") && colon() && appendNumber(output, event.context.missionLogId.value) && colon() &&
                   appendNumber(output, event.context.missionId.value);
        case SourceType::Battlefield:
            return appendToken(output, "battlefield") && colon() && appendNumber(output, event.context.battlefieldId.value);
        case SourceType::Regime:
            return appendToken(output, "regime") && colon() && appendNumber(output, event.context.regimeId.value);
        case SourceType::Admin:
            return appendToken(output, "admin") && colon() && appendNumber(output, event.context.actorCharId.value);
        case SourceType::Script:
            return appendToken(output, "script") && colon() && appendToken(output, event.context.scriptKey.view());
        case SourceType::System:
            return appendToken(output, "system") && colon() && appendToken(output, event.context.systemKey.view());
    }

    return false;
}

auto categoryAcceptsSource(Category category, SourceType sourceType) noexcept -> bool
{
    switch (category)
    {
        case Category::MobDrop:
        case Category::Mug:
            return sourceType == SourceType::Mob;
        case Category::NpcVendorSale:
        case Category::GuildVendorSale:
        case Category::NpcShopPurchase:
        case Category::GuildShopPurchase:
            return sourceType == SourceType::Npc;
        case Category::QuestReward:
            return sourceType == SourceType::Quest;
        case Category::MissionReward:
            return sourceType == SourceType::Mission;
        case Category::BattlefieldReward:
            return sourceType == SourceType::Battlefield;
        case Category::RegimeReward:
            return sourceType == SourceType::Regime;
        case Category::StartingGil:
            return sourceType == SourceType::System;
        case Category::AdminGrant:
        case Category::AdminRemove:
            return sourceType == SourceType::Admin;
        case Category::ScriptReward:
            return sourceType == SourceType::Script || sourceType == SourceType::Npc || sourceType == SourceType::System;
        case Category::OtherMint:
        case Category::OtherBurn:
            return sourceType == SourceType::Script || sourceType == SourceType::System || sourceType == SourceType::Npc;
        case Category::ChocoboRental:
        case Category::TransportFee:
        case Category::ServiceFee:
            return sourceType == SourceType::Npc || sourceType == SourceType::System;
        case Category::QuestFee:
            return sourceType == SourceType::Quest || sourceType == SourceType::Mission || sourceType == SourceType::Npc ||
                   sourceType == SourceType::System;
        case Category::AuctionListingFee:
        case Category::BazaarTax:
        case Category::CurrencyCapLoss:
        case Category::PlayerTrade:
        case Category::BazaarSale:
        case Category::AuctionSale:
        case Category::DeliveryBox:
        case Category::OtherTransfer:
            return sourceType == SourceType::System;
    }
    return false;
}

auto hasOnlyMobContext(const SourceContext& context) noexcept -> bool
{
    return !context.npcId.hasValue && !context.shopId.hasValue && !context.guildId.hasValue &&
           !context.questLogId.hasValue && !context.questId.hasValue && !context.missionLogId.hasValue &&
           !context.missionId.hasValue && !context.battlefieldId.hasValue && !context.regimeId.hasValue &&
           !context.actorCharId.hasValue && context.serviceKey.empty() && context.scriptKey.empty() && context.systemKey.empty();
}

auto hasOnlyNpcContext(const SourceContext& context) noexcept -> bool
{
    return !context.mobSpawnId.hasValue && !context.mobPoolId.hasValue && !context.questLogId.hasValue &&
           !context.questId.hasValue && !context.missionLogId.hasValue && !context.missionId.hasValue &&
           !context.battlefieldId.hasValue && !context.regimeId.hasValue && !context.actorCharId.hasValue &&
           context.scriptKey.empty() && context.systemKey.empty();
}

auto hasOnlyQuestContext(const SourceContext& context) noexcept -> bool
{
    return !context.mobSpawnId.hasValue && !context.mobPoolId.hasValue && !context.npcId.hasValue &&
           !context.shopId.hasValue && !context.guildId.hasValue && !context.missionLogId.hasValue &&
           !context.missionId.hasValue && !context.battlefieldId.hasValue && !context.regimeId.hasValue &&
           !context.actorCharId.hasValue && context.serviceKey.empty() && context.scriptKey.empty() && context.systemKey.empty();
}

auto hasOnlyMissionContext(const SourceContext& context) noexcept -> bool
{
    return !context.mobSpawnId.hasValue && !context.mobPoolId.hasValue && !context.npcId.hasValue &&
           !context.shopId.hasValue && !context.guildId.hasValue && !context.questLogId.hasValue &&
           !context.questId.hasValue && !context.battlefieldId.hasValue && !context.regimeId.hasValue &&
           !context.actorCharId.hasValue && context.serviceKey.empty() && context.scriptKey.empty() && context.systemKey.empty();
}

auto hasOnlySingleNumericContext(const SourceContext& context, SourceType sourceType) noexcept -> bool
{
    const auto battlefieldAllowed = sourceType == SourceType::Battlefield;
    const auto regimeAllowed      = sourceType == SourceType::Regime;
    const auto adminAllowed       = sourceType == SourceType::Admin;
    return !context.mobSpawnId.hasValue && !context.mobPoolId.hasValue && !context.npcId.hasValue &&
           !context.shopId.hasValue && !context.guildId.hasValue && !context.questLogId.hasValue &&
           !context.questId.hasValue && !context.missionLogId.hasValue && !context.missionId.hasValue &&
           (battlefieldAllowed || !context.battlefieldId.hasValue) && (regimeAllowed || !context.regimeId.hasValue) &&
           (adminAllowed || !context.actorCharId.hasValue) && context.serviceKey.empty() && context.scriptKey.empty() &&
           context.systemKey.empty();
}

auto hasOnlyScriptContext(const SourceContext& context) noexcept -> bool
{
    return !context.mobSpawnId.hasValue && !context.mobPoolId.hasValue && !context.npcId.hasValue &&
           !context.shopId.hasValue && !context.guildId.hasValue && !context.questLogId.hasValue &&
           !context.questId.hasValue && !context.missionLogId.hasValue && !context.missionId.hasValue &&
           !context.battlefieldId.hasValue && !context.regimeId.hasValue && !context.actorCharId.hasValue &&
           context.serviceKey.empty() && context.systemKey.empty();
}

auto hasOnlySystemContext(const SourceContext& context) noexcept -> bool
{
    return !context.mobSpawnId.hasValue && !context.mobPoolId.hasValue && !context.npcId.hasValue &&
           !context.shopId.hasValue && !context.guildId.hasValue && !context.questLogId.hasValue &&
           !context.questId.hasValue && !context.missionLogId.hasValue && !context.missionId.hasValue &&
           !context.battlefieldId.hasValue && !context.regimeId.hasValue && !context.actorCharId.hasValue &&
           context.serviceKey.empty() && context.scriptKey.empty();
}

} // namespace

auto isSafeToken(std::string_view value) noexcept -> bool
{
    if (value.empty())
    {
        return false;
    }

    for (const auto character : value)
    {
        const auto alphaNumeric = (character >= 'A' && character <= 'Z') || (character >= 'a' && character <= 'z') ||
                                  (character >= '0' && character <= '9');
        if (!alphaNumeric && character != '.' && character != '_' && character != ':' && character != '+' &&
            character != '/' && character != '-')
        {
            return false;
        }
    }

    return true;
}

auto isValidEvent(const Event& event) noexcept -> bool
{
    constexpr auto MaxFutureSkewNanos = 5LL * 60LL * 1000000000LL;
    if (event.occurredAtUnixNanos <= 0 || event.amount == 0 || event.amount > MaxGilAmount ||
        event.occurredAtUnixNanos > unixNanosNow() + MaxFutureSkewNanos ||
        event.kind != kindForCategory(event.category) || !isSafeToken(event.transactionId.view()) ||
        !categoryAcceptsSource(event.category, event.sourceType) ||
        !isSafeToken(event.contentVersion.view()) || !isSafeToken(event.sourceKey.view()) ||
        !isSafeToken(event.evidenceVersion.view()) ||
        event.attributionQuality > AttributionQuality::Correlated ||
        !isPositiveCharacterId(event.fromCharId) || !isPositiveCharacterId(event.toCharId) ||
        (event.itemQuantity.hasValue && event.itemQuantity.value == 0))
    {
        return false;
    }

    switch (event.kind)
    {
        case Kind::Mint:
            if (event.fromCharId.hasValue || !event.toCharId.hasValue)
            {
                return false;
            }
            break;
        case Kind::Burn:
            if (!event.fromCharId.hasValue || event.toCharId.hasValue)
            {
                return false;
            }
            break;
        case Kind::Transfer:
            if (!event.fromCharId.hasValue || !event.toCharId.hasValue || event.fromCharId.value == event.toCharId.value)
            {
                return false;
            }
            break;
    }

    auto contextValid = false;
    switch (event.sourceType)
    {
        case SourceType::Mob:
            contextValid = event.context.mobSpawnId.hasValue && event.context.mobSpawnId.value > 0 &&
                           (!event.context.mobPoolId.hasValue || event.context.mobPoolId.value > 0) && hasOnlyMobContext(event.context);
            break;
        case SourceType::Npc:
            contextValid = event.zoneId.hasValue && event.context.npcId.hasValue && event.context.npcId.value > 0 &&
                           (event.context.serviceKey.empty() || isSafeToken(event.context.serviceKey.view())) &&
                           hasOnlyNpcContext(event.context);
            break;
        case SourceType::Quest:
            contextValid = event.context.questLogId.hasValue && event.context.questId.hasValue && hasOnlyQuestContext(event.context);
            break;
        case SourceType::Mission:
            contextValid = event.context.missionLogId.hasValue && event.context.missionId.hasValue && hasOnlyMissionContext(event.context);
            break;
        case SourceType::Battlefield:
            contextValid = event.context.battlefieldId.hasValue && hasOnlySingleNumericContext(event.context, event.sourceType);
            break;
        case SourceType::Regime:
            contextValid = event.context.regimeId.hasValue && hasOnlySingleNumericContext(event.context, event.sourceType);
            break;
        case SourceType::Admin:
            contextValid = event.context.actorCharId.hasValue && event.context.actorCharId.value > 0 &&
                           hasOnlySingleNumericContext(event.context, event.sourceType);
            break;
        case SourceType::Script:
            contextValid = isSafeToken(event.context.scriptKey.view()) && hasOnlyScriptContext(event.context);
            break;
        case SourceType::System:
            contextValid = isSafeToken(event.context.systemKey.view()) && hasOnlySystemContext(event.context);
            break;
    }

    SourceKey expectedSourceKey;
    return contextValid && canonicalSourceKey(event, expectedSourceKey) && expectedSourceKey.view() == event.sourceKey.view();
}

auto isValidAttributionGap(const AttributionGap& gap) noexcept -> bool
{
    constexpr auto MaxFutureSkewNanos = 5LL * 60LL * 1000000000LL;
    return gap.occurredAtUnixNanos > 0 && gap.occurredAtUnixNanos <= unixNanosNow() + MaxFutureSkewNanos &&
           gap.charId > 0 && gap.appliedDelta > 0 && gap.appliedDelta <= MaxGilAmount &&
           gap.direction <= AttributionDirection::Debit && gap.evidenceType <= EvidenceType::TransferReconciliation &&
           isSafeToken(gap.evidenceVersion.view()) && isSafeToken(gap.detailCode.view()) &&
           isSafeToken(gap.contentVersion.view()) && (gap.sourceHint.empty() || isSafeToken(gap.sourceHint.view()));
}

auto isValidForgoneMint(const ForgoneMint& diagnostic) noexcept -> bool
{
    if (diagnostic.requestedAmount == 0 || diagnostic.requestedAmount > std::numeric_limits<std::uint32_t>::max() ||
        diagnostic.appliedAmount > MaxGilAmount || diagnostic.forgoneAmount == 0 ||
        diagnostic.forgoneAmount > std::numeric_limits<std::uint32_t>::max() ||
        diagnostic.appliedAmount >= diagnostic.requestedAmount ||
        diagnostic.requestedAmount - diagnostic.appliedAmount != diagnostic.forgoneAmount ||
        kindForCategory(diagnostic.category) != Kind::Mint)
    {
        return false;
    }

    Event sourceValidation;
    sourceValidation.occurredAtUnixNanos = diagnostic.occurredAtUnixNanos;
    sourceValidation.transactionId       = diagnostic.transactionId;
    sourceValidation.kind                = Kind::Mint;
    sourceValidation.category            = diagnostic.category;
    // isValidEvent is reused only for category/source/context validation here;
    // accounting events are wallet-capped, while forgone diagnostics may span uint32.
    sourceValidation.amount = std::min(diagnostic.forgoneAmount, MaxGilAmount);
    sourceValidation.toCharId.set(diagnostic.charId);
    sourceValidation.zoneId             = diagnostic.zoneId;
    sourceValidation.contentVersion     = diagnostic.contentVersion;
    sourceValidation.sourceType         = diagnostic.sourceType;
    sourceValidation.sourceKey          = diagnostic.sourceKey;
    sourceValidation.context            = diagnostic.context;
    sourceValidation.attributionQuality = diagnostic.attributionQuality;
    sourceValidation.evidenceVersion    = diagnostic.evidenceVersion;
    return isValidEvent(sourceValidation);
}

auto unixNanosNow() noexcept -> std::int64_t
{
    return std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
}

} // namespace phoenix::economy
