/************************************************************************
 * Fishing Hooks
 *
 * Runs the fishing packets itself, once they have passed validation, so it
 * can read the character on both sides of each step. Modules later in the
 * chain never see a fishing action or a 0x110 packet.
 *
 * Keeps the fishing meters on the account: the core reads and charges them as
 * char vars, so they are loaded from account_vars before a packet that can use
 * them and saved back after one that can charge them. The limits then cover
 * every character on the account.
 ************************************************************************/

#include "fishing_hooks.h"

#include "account_vars.h"

#include "map/entities/char_entity.h"
#include "map/enums/packet_s2c.h"
#include "map/lua/luautils.h"
#include "map/packets/basic.h"
#include "map/packets/c2s/0x01a_action.h"
#include "map/packets/c2s/0x110_fishing_2.h"
#include "map/packets/s2c/0x027_talknumwork2.h"
#include "map/utils/fishingutils.h"
#include "map/utils/moduleutils.h"

#include <array>
#include <string>
#include <utility>
#include <vector>

namespace
{

using fishinghooks::FishingEvent;

const auto fishingMeters = std::array<std::string, 2>{ "[Fish]DailyPoints", "[Fish]Fatigue" };

std::vector<fishinghooks::FishingObserver> observers;

auto reelingCharId = uint32{ 0 };
auto reelLanded    = false;

void notify(const CCharEntity* PChar, const FishingEvent event, const uint32 para = 0)
{
    for (const auto& observe : observers)
    {
        observe(PChar, event, para);
    }
}

void loadFishingMeters(CCharEntity* PChar)
{
    for (const auto& meter : fishingMeters)
    {
        PChar->updateCharVarCache(meter, accountvars::fetchAccountVar(PChar->accid, meter), luautils::JstMidnight());
    }
}

void saveFishingMeters(const CCharEntity* PChar)
{
    for (const auto& meter : fishingMeters)
    {
        accountvars::persistAccountVar(PChar->accid, meter, PChar->getCharVar(meter), luautils::JstMidnight());
    }
}

void processFishAction(const GP_CLI_COMMAND_ACTION* packet, MapSession* PSession, CCharEntity* PChar)
{
    packet->process(PSession, PChar);

    // A cast that was refused leaves the animation alone, and validation already stopped one sent mid-cast
    if (PChar->animation == xi::Animation::NewFishingStart)
    {
        notify(PChar, FishingEvent::Cast);
    }
}

void processCheckHook(const GP_CLI_COMMAND_FISHING_2* packet, MapSession* PSession, CCharEntity* PChar)
{
    const auto alreadyHooked = PChar->animation == xi::Animation::NewFishingFish;

    loadFishingMeters(PChar);
    packet->process(PSession, PChar);

    if (!alreadyHooked && PChar->animation == xi::Animation::NewFishingFish)
    {
        notify(PChar, FishingEvent::Hook);
    }
}

void processEndMiniGame(const GP_CLI_COMMAND_FISHING_2* packet, MapSession* PSession, CCharEntity* PChar)
{
    if (PChar->fishingToken == 0)
    {
        packet->process(PSession, PChar);
        return;
    }

    notify(PChar, FishingEvent::End, static_cast<uint32>(packet->para));

    loadFishingMeters(PChar);

    reelingCharId = PChar->id;
    reelLanded    = false;
    packet->process(PSession, PChar);
    reelingCharId = 0;

    saveFishingMeters(PChar);

    if (reelLanded && PChar->hookedFish != nullptr)
    {
        notify(PChar, FishingEvent::Landed);
    }
}

void processRelease(const GP_CLI_COMMAND_FISHING_2* packet, MapSession* PSession, CCharEntity* PChar)
{
    if (PChar->isFishing())
    {
        notify(PChar, FishingEvent::Release);
    }

    packet->process(PSession, PChar);
}

void processFishingPacket(const GP_CLI_COMMAND_FISHING_2* packet, MapSession* PSession, CCharEntity* PChar)
{
    switch (static_cast<GP_CLI_COMMAND_FISHING_2_MODE>(packet->mode))
    {
        case GP_CLI_COMMAND_FISHING_2_MODE::RequestCheckHook:
            processCheckHook(packet, PSession, PChar);
            break;
        case GP_CLI_COMMAND_FISHING_2_MODE::RequestEndMiniGame:
            processEndMiniGame(packet, PSession, PChar);
            break;
        case GP_CLI_COMMAND_FISHING_2_MODE::RequestRelease:
            processRelease(packet, PSession, PChar);
            break;
        case GP_CLI_COMMAND_FISHING_2_MODE::RequestPotentialTimeout:
            packet->process(PSession, PChar);
            break;
    }
}

// CatchFish and CatchItem only send these once the catch is in the inventory
auto isCatchMessage(const uint16 message, const uint16 messageOffset) -> bool
{
    return message == messageOffset + FISHMESSAGEOFFSET_CATCH ||
           message == messageOffset + FISHMESSAGEOFFSET_CATCH_MULTI ||
           message == messageOffset + FISHMESSAGEOFFSET_CATCH_GIL;
}

} // namespace

namespace fishinghooks
{

void AddFishingObserver(FishingObserver observe)
{
    observers.push_back(std::move(observe));
}

} // namespace fishinghooks

namespace
{

class FishingHooksModule : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;
    }

    auto OnIncomingPacket(MapSession* PSession, CCharEntity* PChar, CBasicPacket& data) -> bool override
    {
        if (data.getType() == static_cast<uint16>(GP_CLI_COMMAND_FISHING_2::packetId))
        {
            processFishingPacket(data.as<GP_CLI_COMMAND_FISHING_2>(), PSession, PChar);
            return true;
        }

        if (data.getType() != static_cast<uint16>(GP_CLI_COMMAND_ACTION::packetId))
        {
            return false;
        }

        const auto* packet = data.as<GP_CLI_COMMAND_ACTION>();
        if (packet->ActionID != GP_CLI_COMMAND_ACTION_ACTIONID::Fish)
        {
            return false;
        }

        processFishAction(packet, PSession, PChar);
        return true;
    }

    void OnPushPacket(CCharEntity* PChar, const std::unique_ptr<CBasicPacket>& packet) override
    {
        if (PChar->id != reelingCharId || packet->getType() != static_cast<uint16>(PacketS2C::GP_SERV_COMMAND_TALKNUMWORK2))
        {
            return;
        }

        const auto& data = packet->ref<GP_SERV_COMMAND_TALKNUMWORK2::PacketData>(sizeof(GP_SERV_HEADER));
        if (isCatchMessage(data.MesNum & 0x7FFF, fishingutils::GetMessageOffset(PChar->getZone()))) // The top bit only hides the sender
        {
            reelLanded = true;
        }
    }
};

} // namespace

REGISTER_CPP_MODULE(FishingHooksModule);
