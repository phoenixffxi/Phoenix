/*************************************
 *  Used for the 75 Cap Dynamis
 *  Used to handle hourglass functions.
 *************************************/
#include "map/utils/moduleutils.h"
#include <algorithm>

#include "common/database.h"
#include "common/logging.h"
#include "map/entities/mobentity.h"
#include "map/item_container.h"
#include "map/items/item_furnishing.h"
#include "map/lua/lua_item.h"
#include "map/lua/luautils.h"
#include "map/packets/s2c/0x01d_item_same.h"
#include "map/packets/s2c/0x020_item_attr.h"
#include "map/utils/charutils.h"
#include "map/utils/itemutils.h"

namespace
{
constexpr uint16 HOURGLASS_ID = 4237;

uint32 currentEpoch()
{
    return static_cast<uint32>(time(nullptr));
}
}; // namespace

class DynaFuncModule : public CPPModule
{
    void OnInit() override
    {
        lua["CBaseEntity"]["getDynaInstance"] = [this](CLuaBaseEntity* PLuaBaseEntity)
        {
            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            auto         PChar   = dynamic_cast<CCharEntity*>(PEntity);

            if (PChar && PChar != nullptr)
            {
                const auto rset = db::preparedStmt("SELECT COALESCE(MAX(instanceid), 0) AS maxInstanceId FROM dynamis_participants WHERE charid = ?", PChar->id);

                if (rset && rset->rowsCount() && rset->next())
                {
                    return rset->get<uint32>("maxInstanceId");
                }
            }

            return (uint32)-1;
        };

        // Register Dynamis Instance
        lua["RegisterDynamisInstance"] = [this](uint32 zoneid, uint32 charid)
        {
            uint32     instID = 0;
            const auto rset   = db::preparedStmt("SELECT COALESCE(MAX(instanceid), 0) AS maxInstanceId FROM dynamis_instances");

            if (rset && rset->next())
            {
                instID = rset->get<uint32>("maxInstanceId") + 1;
            }
            else
            {
                instID = 1;
            }

            const auto rset2 = db::preparedStmt("INSERT INTO dynamis_instances VALUES (?, ?, ?)", instID, zoneid, charid);
            if (!rset2)
            {
                instID = -1;
            }

            return instID;
        };

        // Add Dynamis Participant
        lua["AddDynamisParticipant"] = [this](uint32 instanceId, uint32 playerId)
        {
            const auto rset = db::preparedStmt("INSERT INTO dynamis_participants VALUES (?, ?)", instanceId, playerId);
            return (rset && rset->rowsAffected());
        };

        // Reset All Dynamis Participants
        lua["ResetDynamisInstance"] = [this](uint32 instanceId)
        {
            db::preparedStmt("UPDATE char_vars SET value = 73 WHERE charid IN "
                             "(SELECT charid FROM dynamis_participants WHERE instanceid = ?) "
                             "AND varname = ?",
                             instanceId,
                             "DynaReservationStart");
        };
    }
};

REGISTER_CPP_MODULE(DynaFuncModule);
