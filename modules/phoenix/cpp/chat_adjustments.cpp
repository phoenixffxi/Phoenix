/************************************************************************
 * Chat Adjustments Module
 *
 * Phoenix chat rules, applied by catching the standard chat packet
 * before the base handler. Each section below is one rule.
 ************************************************************************/
#include "common/earth_time.h"
#include "common/ipc_structs.h"
#include "common/logging.h"
#include "map/entities/char_entity.h"
#include "map/enums/chat_message_type.h"
#include "map/enums/msg_std.h"
#include "map/ipc_client.h"
#include "map/packets/basic.h"
#include "map/packets/c2s/0x0b5_chat_std.h"
#include "map/packets/s2c/0x009_message.h"
#include "map/packets/s2c/0x017_chat_std.h"
#include "map/utils/charutils.h"
#include "map/utils/moduleutils.h"
#include "map/zone.h"

#include <fmt/chrono.h>
#include <fmt/format.h>

#include <algorithm>
#include <format>
#include <string>
#include <string_view>

namespace
{

//-----------------------------------
// Section: GM system messages.
//-----------------------------------
// A GM message starting with ### broadcasts the text after it to the whole
// server. # and ## are refused with a hint, so a mistyped message cannot
// broadcast. Players are not affected.

constexpr std::string_view systemMessagePrefix = "###";

const std::string systemMessageHint = "System messages start with ###.";

// The base handler broadcasts any GM # message before it looks at the chat
// kind. Every GM # message must be consumed here.
auto handleSystemMessage(CCharEntity* PChar, const std::string& message) -> bool
{
    const auto body = message.starts_with(systemMessagePrefix) ? message.substr(systemMessagePrefix.size()) : std::string();

    if (body.empty())
    {
        PChar->pushPacket<GP_SERV_COMMAND_CHAT_STD>(PChar, MESSAGE_SYSTEM_1, systemMessageHint);

        return true;
    }

    message::send(ipc::ChatMessageServerMessage{
        .senderId   = PChar->id,
        .senderName = PChar->getName(),
        .message    = body,
        .zoneId     = PChar->getZone(),
        .gmLevel    = PChar->m_GMlevel,
    });

    return true;
}

//-----------------------------------
// Section: Yell restrictions.
//-----------------------------------
// Yell requires level 10 on some job. The cooldown is 5 minutes instead of
// the base 30 seconds. Which zones allow yell at all is still the Yell flag
// in zone_settings.misc. A muted player is told how long the mute has left.

constexpr uint8 minYellLevel = 10;

// The base handler's own 30 second cooldown expires inside this one.
constexpr uint32 yellCooldown = 300;

// Separate from the base handler's [YELL]Cooldown so the two do not fight.
// Self-expires and persists through zoning.
const std::string yellCooldownVar = "[YELL]CooldownPhx";

// Set by !yell ban. Expiry 0 is an indefinite mute.
const std::string yellMuteVar = "[YELL]Banned";

auto yellMuteNotice(uint32 expiry) -> std::string
{
    if (expiry == 0)
    {
        return "You are muted from /yell indefinitely.";
    }

    const auto now          = earth_time::timestamp();
    const auto remaining    = std::max<uint32>(expiry, now) - now;
    const auto totalMinutes = std::max<uint32>((remaining + 59) / 60, 1);

    const std::pair<uint32, std::string_view> parts[] = {
        { totalMinutes / 1440, "day" },
        { totalMinutes % 1440 / 60, "hour" },
        { totalMinutes % 60, "minute" },
    };

    std::string duration;
    for (const auto& [count, unit] : parts)
    {
        if (count == 0)
        {
            continue;
        }

        if (!duration.empty())
        {
            duration += ", ";
        }

        duration += fmt::format("{} {}", count, unit);

        if (count > 1)
        {
            duration += 's';
        }
    }

    const auto endTime = earth_time::to_utc_tm(earth_time::time_point(std::chrono::seconds(expiry)));

    return fmt::format("You are muted from /yell for another {}. The mute ends {:%Y-%m-%d %H:%M} UTC.", duration, endTime);
}

auto handleYell(CCharEntity* PChar) -> bool
{
    // GMs are exempt. That also keeps their ! commands working through this
    // channel. A zone without the Yell flag keeps the base handler's own
    // refusal and does not burn the cooldown.
    //
    // Everyone else is caught before the base handler sees the message.
    // An unresolved ! command from a non-GM falls through to the yell path there.
    if (PChar->m_GMlevel > 0 ||
        !PChar->loc.zone->CanUseMisc(xi::ZoneMisc::Yell))
    {
        return false;
    }

    // Send a notice to the player of the duration of their yell mute.
    if (const auto [muted, expiry] = charutils::FetchCharVar(PChar->id, yellMuteVar); muted == 1)
    {
        PChar->pushPacket<GP_SERV_COMMAND_CHAT_STD>(PChar, MESSAGE_SYSTEM_3, yellMuteNotice(expiry));

        return true;
    }

    // Level 10 on any job is enough. A level sync or a job change does not take yell away.
    if (PChar->getHighestJobLevel() < minYellLevel)
    {
        PChar->pushPacket<GP_SERV_COMMAND_CHAT_STD>(PChar, MESSAGE_SYSTEM_1, std::format("You must reach level {} before you can use /yell.", minYellLevel));

        return true;
    }

    if (PChar->getCharVar(yellCooldownVar) == 1)
    {
        PChar->pushPacket<GP_SERV_COMMAND_MESSAGE>(PChar, 0, MsgStd::WaitLonger);

        return true;
    }

    // CharVar will self-expire and set to zero after the cooldown period.
    // A ! command that resolves in yell mode burns this without a yell going
    // out. The module cannot see whether the command resolved. Skipping !
    // messages would let unresolved ones yell past the cooldown.
    PChar->setCharVar(yellCooldownVar, 1, earth_time::timestamp() + yellCooldown);

    return false;
}

} // namespace

class ChatAdjustments : public CPPModule
{
    void OnInit() override
    {
    }

    auto OnIncomingPacket(MapSession* PSession, CCharEntity* PChar, CBasicPacket& data) -> bool override
    {
        // Return if the packet isn't standard chat
        if (data.getType() != static_cast<uint16>(GP_CLI_COMMAND_CHAT_STD::packetId))
        {
            return false;
        }

        const auto* packet = data.as<GP_CLI_COMMAND_CHAT_STD>();

        // Same length math as the base handler. The message may not be NULL-terminated.
        const auto messageLength = std::min<std::size_t>((packet->header.size * 4) - 0x6, sizeof(packet->Str));
        const auto rawMessage    = asStringFromUntrustedSource(packet->Str, messageLength);

        if (PChar->m_GMlevel > 0 && !rawMessage.empty() && rawMessage[0] == '#')
        {
            return handleSystemMessage(PChar, rawMessage);
        }

        if (static_cast<GP_CLI_COMMAND_CHAT_STD_KIND>(packet->Kind) == GP_CLI_COMMAND_CHAT_STD_KIND::Yell)
        {
            return handleYell(PChar);
        }

        return false;
    }
};

REGISTER_CPP_MODULE(ChatAdjustments);
