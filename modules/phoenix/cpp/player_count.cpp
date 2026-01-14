/************************************************************************
 *
 * Phoenix Population-Based Level Sync Penalty Module
 *
 * This module provides a C++ function to query online player count
 * and exposes it to Lua for use in the penalty calculation system.
 *
 ************************************************************************/

#include "common/database.h"
#include "map/utils/moduleutils.h"

extern sol::state lua;

class PopulationSyncPenaltyModule : public CPPModule
{
public:
    void OnInit() override
    {
        lua.set_function("GetOnlinePlayerCount", []() -> int16
                         {
                             auto rset = db::preparedStmt("SELECT COUNT(*) as count FROM accounts_sessions");
                             if (rset && rset->next())
                             {
                                 return rset->get<int16>("count");
                             }

                             return 0;
                         });
    }
};

REGISTER_CPP_MODULE(PopulationSyncPenaltyModule);
