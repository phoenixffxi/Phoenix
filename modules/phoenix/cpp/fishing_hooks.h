/************************************************************************
 * Fishing Hooks
 *
 * Lets other modules follow every step of every cast. See fishing_hooks.cpp.
 ************************************************************************/

#pragma once

#include "common/cbasetypes.h"

#include <functional>

class CCharEntity;

namespace fishinghooks
{

enum class FishingEvent : uint8
{
    Cast,    // The line went out
    Hook,    // The fight packet was sent, PChar->hookedFish holds what the client was told
    End,     // The client ended the fight, para is the stamina it reported
    Release, // The client finished reeling in
    Landed,  // PChar->hookedFish went into the inventory
};

// Modules register these at startup to hear every step of every cast
using FishingObserver = std::function<void(const CCharEntity* PChar, FishingEvent event, uint32 para)>;

void AddFishingObserver(FishingObserver observe);

} // namespace fishinghooks
