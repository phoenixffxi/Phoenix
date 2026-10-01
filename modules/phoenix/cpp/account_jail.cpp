/************************************************************************
 * Account Jail
 *
 * Backs modules/phoenix/lua/commands/account_jail.lua: !jailaccount,
 * !pardonaccount, and offline characters for !pardon.
 *
 * Lua:
 * - GetAccountCharacters(charName) - every character on charName's account as { name, played }, oldest first
 * - PardonOffline(charId)          - clears inJail and moves an offline prisoner to their home point, false if never played
 ************************************************************************/

#include "common/database.h"
#include "common/lua.h"
#include "map/utils/charutils.h"
#include "map/utils/moduleutils.h"

namespace
{

// Deleted characters sit on accid 0, so a deleted target must not match all of them
auto getAccountCharacters(const std::string& charName) -> sol::table
{
    auto       characters = ::lua.create_table();
    const auto rset       = db::preparedStmt("SELECT alt.charname, alt.home_zone FROM chars c "
                                             "INNER JOIN chars alt ON alt.accid = c.accid "
                                             "WHERE c.charname = ? AND c.accid <> 0 "
                                             "ORDER BY alt.charid",
                                             charName);

    auto index = 1;
    FOR_DB_MULTIPLE_RESULTS(rset)
    {
        // home_zone stays 0 until the opening cutscene sets the first home point
        characters[index++] = ::lua.create_table_with("name", rset->get<std::string>("charname"), "played", rset->get<uint16>("home_zone") != 0);
    }

    return characters;
}

// Offline counterpart of warp(), which is what !pardon uses on an online prisoner
auto pardonOffline(const uint32 charId) -> bool
{
    const auto rset = db::preparedStmt("SELECT home_zone FROM chars WHERE charid = ? LIMIT 1", charId);
    if (!rset || !rset->next() || rset->get<uint16>("home_zone") == 0)
    {
        return false;
    }

    charutils::PersistCharVar(charId, "inJail", 0);
    db::preparedStmt("UPDATE chars SET pos_zone = home_zone, pos_x = home_x, pos_y = home_y, pos_z = home_z, pos_rot = home_rot, moghouse = 0 "
                     "WHERE charid = ? AND pos_zone = ?",
                     charId,
                     xi::ZoneId::MordionGaol);

    return true;
}

} // namespace

class AccountJailModule : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;

        ::lua.set_function("GetAccountCharacters", getAccountCharacters);
        ::lua.set_function("PardonOffline", pardonOffline);
    }
};

REGISTER_CPP_MODULE(AccountJailModule);
