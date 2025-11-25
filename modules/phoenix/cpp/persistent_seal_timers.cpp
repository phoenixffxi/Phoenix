/*
===========================================================================

  Persistent Seal Timers Module

  Phoenix Server custom change: Beastmen seals and Kindred seals cooldown does not reset on zoning.

  Implementation:
  - Saves active seal LOOT recasts to char_vars on zone-out
  - Restores them on zone-in

===========================================================================
*/

#include "common/timer.h"
#include "map/entities/charentity.h"
#include "map/recast_container.h"
#include "map/utils/moduleutils.h"
#include <ctime>
#include <fmt/format.h>

class PersistentSealTimersModule : public CPPModule
{
public:
    void OnInit() override
    {
    }

    void OnCharZoneOut(CCharEntity* PChar) override
    {
        if (!PChar)
        {
            return;
        }

        SaveSealTimer(PChar);
    }

    void OnCharZoneIn(CCharEntity* PChar) override
    {
        if (!PChar)
        {
            return;
        }

        RestoreSealTimer(PChar);
    }

private:
    static constexpr uint16 RECAST_SEAL = 1;

    void SaveSealTimer(CCharEntity* PChar)
    {
        auto* recast = PChar->PRecastContainer->GetRecast(RECAST_LOOT, RECAST_SEAL);
        if (recast && recast->RecastTime > 0s)
        {
            auto remaining = (recast->TimeStamp + recast->RecastTime) - timer::now();

            if (remaining > 10s)
            {
                auto remainingSeconds = std::chrono::duration_cast<std::chrono::seconds>(remaining).count();
                PChar->setCharVar("SealTimer", static_cast<int32>(remainingSeconds));
                return;
            }
        }
    }

    void RestoreSealTimer(CCharEntity* PChar)
    {
        auto remainingSeconds = PChar->getCharVar("SealTimer");

        if (remainingSeconds > 0)
        {
            // Sanity check: seal timer should never exceed 5 minutes (300 seconds)
            // If it does, it's stale data from before a server restart
            if (remainingSeconds <= 300)
            {
                PChar->PRecastContainer->Add(RECAST_LOOT, RECAST_SEAL, std::chrono::seconds(remainingSeconds));
            }

            PChar->setCharVar("SealTimer", 0);
        }
    }
};

REGISTER_CPP_MODULE(PersistentSealTimersModule);
