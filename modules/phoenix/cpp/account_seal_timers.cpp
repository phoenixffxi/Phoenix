/************************************************************************
 * Module: Account Wide Seal Timer
 *
 * PERSIST_SEAL_TIMERS server setting upstream adds a block to seal reset on zoning/logout.
 * This module extends that functionality to persist the seal timer across all characters on the account.
 ************************************************************************/

#include "common/database.h"
#include "common/earth_time.h"
#include "common/settings.h"
#include "common/timer.h"

#include "map/entities/char_entity.h"
#include "map/enums/loot_recast.h"
#include "map/recast_container.h"
#include "map/utils/moduleutils.h"

#include <string>

namespace
{

const std::string SealTimerVarName = "SealTimerExpiry";

class AccountSealTimersModule : public CPPModule
{
    void OnInit() override
    {
    }

    void OnCharZoneIn(CCharEntity* PChar) override
    {
        if (!settings::get<bool>("main.PERSIST_SEAL_TIMERS"))
        {
            return;
        }

        const auto rset = db::preparedStmt(
            "SELECT value FROM account_vars WHERE accountid = ? AND varname = ? LIMIT 1",
            PChar->accid,
            SealTimerVarName);

        if (!rset || !rset->rowsCount() || !rset->next())
        {
            return;
        }

        const auto expirationTimestamp = rset->get<uint32>(0);
        const auto currentTimestamp    = earth_time::timestamp();

        if (expirationTimestamp <= currentTimestamp)
        {
            db::preparedStmt("DELETE FROM account_vars WHERE accountid = ? AND varname = ?", PChar->accid, SealTimerVarName);
            return;
        }

        const auto remaining = std::chrono::seconds(expirationTimestamp - currentTimestamp);

        if (remaining > 5min)
        {
            return;
        }

        const auto* recast = PChar->PRecastContainer->GetLootRecast(LootRecastID::Seal);
        if (recast != nullptr && (recast->TimeStamp + recast->RecastTime) - timer::now() >= remaining)
        {
            return;
        }

        PChar->PRecastContainer->AddLootRecast(LootRecastID::Seal, remaining);
    }

    void OnCharZoneOut(CCharEntity* PChar) override
    {
        if (!settings::get<bool>("main.PERSIST_SEAL_TIMERS"))
        {
            return;
        }

        const auto* recast = PChar->PRecastContainer->GetLootRecast(LootRecastID::Seal);
        if (recast == nullptr || recast->RecastTime <= 0s)
        {
            return;
        }

        const auto remaining = (recast->TimeStamp + recast->RecastTime) - timer::now();

        // Don't save if it will expire during the zoning process
        if (remaining <= 10s)
        {
            return;
        }

        const auto remainingSeconds    = std::chrono::duration_cast<std::chrono::seconds>(remaining).count();
        const auto expirationTimestamp = static_cast<int32>(earth_time::timestamp() + static_cast<uint32>(remainingSeconds));

        // Mirror the value into expiry so the row cleans itself up
        db::preparedStmt(
            "INSERT INTO account_vars SET accountid = ?, varname = ?, value = ?, expiry = ? "
            "ON DUPLICATE KEY UPDATE value = VALUES(value), expiry = VALUES(expiry)",
            PChar->accid,
            SealTimerVarName,
            expirationTimestamp,
            expirationTimestamp);
    }
};

} // namespace

REGISTER_CPP_MODULE(AccountSealTimersModule);
