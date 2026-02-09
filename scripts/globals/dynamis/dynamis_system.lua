-----------------------------------
--    Dynamis 75 Era Module      --
-----------------------------------
-----------------------------------
--    Module Required Scripts    --
-----------------------------------
require('scripts/mixins/job_special')
require('scripts/globals/battlefield')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/pathfind')
require('modules/module_utils')
-----------------------------------
--   Module Affected Scripts     --
-----------------------------------
require('scripts/globals/dynamis')
require('scripts/globals/dynamis_new')
require('scripts/globals/dynamis_sand_mobs')
require('scripts/globals/dynamis_bastok_mobs')
-----------------------------------
local m = Module:new('dynamis_entry_info')

xi = xi or {}
xi.dynamis = xi.dynamis or {}

-----------------------------------
--   Global Dynamis Variables    --
-----------------------------------
local dynamisTimelessHourglass  = xi.item.TIMELESS_HOURGLASS
local dynamisPerpetual          = xi.item.PERPETUAL_HOURGLASS
local dynamisMinLvl             = 65
local dynamisReservationCancel  = 180
local dynamisReentryDays        = 3

-- Keep
local function checkGM(player)
    if player:getVisibleGMLevel() > 4 then
        -- print('[DEBUG] Player is a GM.')
        return true
    end
end

-- What the fuck is this function doing ??
local function getDynamisTavWinParam(player)
    local zmComplete = player:getCurrentMission(xi.mission.log_id.ZILART) >= xi.mission.id.zilart.AWAKENING
    local copComplete = player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.DAWN
    local anComplete = player:hasCompletedQuest(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.APOCALYPSE_NIGH)

    if anComplete then
        -- AN requires ZM and CoP
        return 3
    elseif zmComplete then
        if copComplete then
            -- ZM and CoP
            return 2
        end

        -- ZM only
        return 1
    end

    -- Not ZM complete
    return 0
end

xi.dynamis.dynaIDLookup = -- Used to check for different IDs based on zoneID. Replaces the need to overwrite IDs.lua for each zone.
{
    ---------------------------------------------
    --             Starting Zones             --
    ---------------------------------------------
    -- [zone] = -- zoneID for array lookup
    -- {
    --     text = -- text for table lookup
    --     {
    --         CONNECTING_WITH_THE_SERVER   = , -- Connecting with server. Please wait.≺Possible Special Code: 00≻
    --         UNABLE_TO_CONNECT            = , -- Unable to connect.≺Prompt≻
    --         ANOTHER_GROUP                = , -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
    --         INFORMATION_RECORDED         = , -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
    --     },
    -- },

    [xi.zone.BASTOK_MINES] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            CONNECTING_WITH_THE_SERVER  = zones[xi.zone.BASTOK_MINES].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           = zones[xi.zone.BASTOK_MINES].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               = zones[xi.zone.BASTOK_MINES].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        = zones[xi.zone.BASTOK_MINES].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },

    [xi.zone.BEAUCEDINE_GLACIER] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift
            CONNECTING_WITH_THE_SERVER  = zones[xi.zone.BEAUCEDINE_GLACIER].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           = zones[xi.zone.BEAUCEDINE_GLACIER].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               = zones[xi.zone.BEAUCEDINE_GLACIER].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        = zones[xi.zone.BEAUCEDINE_GLACIER].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },

    [xi.zone.BUBURIMU_PENINSULA] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift
            CONNECTING_WITH_THE_SERVER  =  zones[xi.zone.BUBURIMU_PENINSULA].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           =  zones[xi.zone.BUBURIMU_PENINSULA].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               =  zones[xi.zone.BUBURIMU_PENINSULA].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        =  zones[xi.zone.BUBURIMU_PENINSULA].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },

    [xi.zone.QUFIM_ISLAND] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift
            CONNECTING_WITH_THE_SERVER  = zones[xi.zone.QUFIM_ISLAND].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           = zones[xi.zone.QUFIM_ISLAND].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               = zones[xi.zone.QUFIM_ISLAND].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        = zones[xi.zone.QUFIM_ISLAND].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },

    [xi.zone.RULUDE_GARDENS] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift
            CONNECTING_WITH_THE_SERVER  = zones[xi.zone.RULUDE_GARDENS].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           = zones[xi.zone.RULUDE_GARDENS].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               = zones[xi.zone.RULUDE_GARDENS].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        = zones[xi.zone.RULUDE_GARDENS].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },

    [xi.zone.SOUTHERN_SAN_DORIA] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift
            CONNECTING_WITH_THE_SERVER  = zones[xi.zone.SOUTHERN_SAN_DORIA].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           = zones[xi.zone.SOUTHERN_SAN_DORIA].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               = zones[xi.zone.SOUTHERN_SAN_DORIA].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        = zones[xi.zone.SOUTHERN_SAN_DORIA].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },
    [xi.zone.TAVNAZIAN_SAFEHOLD] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift
            CONNECTING_WITH_THE_SERVER  = zones[xi.zone.TAVNAZIAN_SAFEHOLD].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           = zones[xi.zone.TAVNAZIAN_SAFEHOLD].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               = zones[xi.zone.TAVNAZIAN_SAFEHOLD].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        = zones[xi.zone.TAVNAZIAN_SAFEHOLD].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },
    [xi.zone.VALKURM_DUNES] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift
            CONNECTING_WITH_THE_SERVER  = zones[xi.zone.VALKURM_DUNES].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           = zones[xi.zone.VALKURM_DUNES].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               = zones[xi.zone.VALKURM_DUNES].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        = zones[xi.zone.VALKURM_DUNES].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },
    [xi.zone.WINDURST_WALLS] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift =
            INFORMATION_RECORDED       =  zones[xi.zone.WINDURST_WALLS].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
            ANOTHER_GROUP              =  zones[xi.zone.WINDURST_WALLS].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            UNABLE_TO_CONNECT          =  zones[xi.zone.WINDURST_WALLS].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            CONNECTING_WITH_THE_SERVER =  zones[xi.zone.WINDURST_WALLS].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
        },
    },
    [xi.zone.XARCABARD] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            -- ID Shift
            CONNECTING_WITH_THE_SERVER  = zones[xi.zone.XARCABARD].text.YOU_CANNOT_ENTER_DYNAMIS - 8, -- Connecting with server. Please wait.≺Possible Special Code: 00≻
            UNABLE_TO_CONNECT           = zones[xi.zone.XARCABARD].text.YOU_CANNOT_ENTER_DYNAMIS - 7, -- Unable to connect.≺Prompt≻
            ANOTHER_GROUP               = zones[xi.zone.XARCABARD].text.YOU_CANNOT_ENTER_DYNAMIS - 5, -- Another group of player characters is currently occupying Dynamis - ≺Multiple Choice (Parameter 0)≻[Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia].≺Prompt≻
            INFORMATION_RECORDED        = zones[xi.zone.XARCABARD].text.YOU_CANNOT_ENTER_DYNAMIS - 4, -- The time and destination for your foray into Dynamis has been recorded on your <itemID>.
        },
    },
    ---------------------------------------------
    --              Dynamis Zones             --
    ---------------------------------------------
    -- [zone] = -- zoneID for array lookup
    -- {
    --     },
    --     entryZone = -- for tracking/setting cooldown for cleanup script
    -- },

    [xi.zone.DYNAMIS_BASTOK] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_BASTOK].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.BASTOK_MINES,
    },

    [xi.zone.DYNAMIS_BEAUCEDINE] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_BEAUCEDINE].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.BEAUCEDINE_GLACIER,
    },
    [xi.zone.DYNAMIS_BUBURIMU] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_BUBURIMU].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.BUBURIMU_PENINSULA,
    },
    [xi.zone.DYNAMIS_JEUNO] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_JEUNO].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.RULUDE_GARDENS,
    },
    [xi.zone.DYNAMIS_QUFIM] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_QUFIM].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.QUFIM_ISLAND,
    },
    [xi.zone.DYNAMIS_SAN_DORIA] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_SAN_DORIA].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.SOUTHERN_SAN_DORIA,
    },
    [xi.zone.DYNAMIS_TAVNAZIA] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_TAVNAZIA].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.TAVNAZIAN_SAFEHOLD,
    },
    [xi.zone.DYNAMIS_VALKURM] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_VALKURM].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.VALKURM_DUNES,
    },
    [xi.zone.DYNAMIS_WINDURST] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_WINDURST].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        entryZone = xi.zone.WINDURST_WALLS,
    },
    [xi.zone.DYNAMIS_XARCABARD] = -- zoneID for array lookup
    {
        text = -- text for table lookup
        {
            NO_LONGER_HAVE_CLEARANCE = zones[xi.zone.DYNAMIS_XARCABARD].text.MEMBERS_LEVELS_ARE_RESTRICTED + 48, -- ---== WARNING ==---- You no longer have clearance to remain in Dynamis. You will be transported out in ≺Numeric Parameter 1≻ ≺Singular/Plural Choice (Parameter 1)≻[second/seconds].≺Prompt≻
        },
        vars = -- Global Var Table Cleanup
        {
            xi.dynamis.YING,
            xi.dynamis.YANG,
        },
        entryZone = xi.zone.XARCABARD,
    },
}

--[[
    [zone] =
    {
        csBit    = the bit in the Dynamis_Status player variable that records whether player has beaten this dynamis
                this bit number is also given to the start Dynamis event and message.
        csVial   = event ID for cutscene where Cornelia gives you the vial of shrouded sand
        csWin    = event ID for cutscene after you have beaten this Dynamis
        csDyna   = event ID for entering Dynamis
        winVar   = variable used to denote players who have beaten this Dynamis, but not yet viewed the cutscene
        winKI    = key item given as reward for this Dynamis
        enterPos = coordinates where player will be placed when entering this Dynamis
        reqs     = function that returns true if player meets requirements for entering this Dynamis
                minimum level and timer are checked separately
    }
--]]

xi.dynamis.entryInfoEra =
{
    [xi.zone.SOUTHERN_SAN_DORIA] =
    {
        csBit           = 1,
        csRegisterGlass = 184,
        csVial          = 686,
        csWin           = 698,
        csDyna          = 685,
        maxCapacity     = 64,
        enabled         = true,
        winVar          = 'DynaSandoria_Win',
        enteredVar      = 'DynaSandoria_entered',
        hasSeenWinCSVar = 'DynaSandoria_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_COMMAND_SCEPTER,
        enterPos        = { 161.838, -2.000, 161.673, 93, 185 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
        },
    },
    [xi.zone.BASTOK_MINES] =
    {
        csBit           = 2,
        csRegisterGlass = 200,
        csVial          = 203,
        csWin           = 215,
        csDyna          = 201,
        maxCapacity     = 64,
        enabled         = true,
        winVar          = 'DynaBastok_Win',
        enteredVar      = 'DynaBastok_entered',
        hasSeenWinCSVar = 'DynaBastok_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_EYEGLASS,
        enterPos        = { 116.482, 0.994, -72.121, 128, 186 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
        },
    },
    [xi.zone.WINDURST_WALLS] =
    {
        csBit           = 3,
        csRegisterGlass = 451,
        csVial          = 455,
        csWin           = 465,
        csDyna          = 452,
        maxCapacity     = 64,
        enabled         = true,
        winVar          = 'DynaWindurst_Win',
        enteredVar      = 'DynaWindurst_entered',
        hasSeenWinCSVar = 'DynaWindurst_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_LANTERN,
        enterPos        = { -221.988, 1.000, -120.184, 0, 187 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
        },
    },
    [xi.zone.RULUDE_GARDENS] =
    {
        csBit           = 4,
        csRegisterGlass = 10011,
        csVial          = 10016,
        csWin           = 10026,
        csDyna          = 10012,
        maxCapacity     = 64,
        enabled         = true,
        winVar          = 'DynaJeuno_Win',
        enteredVar      = 'DynaJeuno_entered',
        hasSeenWinCSVar = 'DynaJeuno_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_TACTICAL_MAP,
        enterPos        = { 48.930, 10.002, -71.032, 195, 188 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
        },
    },
    [xi.zone.BEAUCEDINE_GLACIER] =
    {
        csBit           = 5,
        csRegisterGlass = 118,
        csWin           = 134,
        csDyna          = 119,
        maxCapacity     = 64,
        enabled         = true,
        winVar          = 'DynaBeaucedine_Win',
        enteredVar      = 'DynaBeaucedine_entered',
        hasSeenWinCSVar = 'DynaBeaucedine_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_INSIGNIA,
        enterPos        = { -284.751, -39.923, -422.948, 235, 134 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
            xi.ki.HYDRA_CORPS_COMMAND_SCEPTER,
            xi.ki.HYDRA_CORPS_EYEGLASS,
            xi.ki.HYDRA_CORPS_LANTERN,
            xi.ki.HYDRA_CORPS_TACTICAL_MAP,
        },
    },
    [xi.zone.XARCABARD] =
    {
        csBit           = 6,
        csRegisterGlass = 15,
        csWin           = 32,
        csDyna          = 16,
        maxCapacity     = 64,
        enabled         = true,
        winVar          = 'DynaXarcabard_Win',
        enteredVar      = 'DynaXarcabard_entered',
        hasSeenWinCSVar = 'DynaXarcabard_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_BATTLE_STANDARD,
        enterPos        = { 569.312, -0.098, -270.158, 90, 135 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
            xi.ki.HYDRA_CORPS_INSIGNIA,
        },
    },
    [xi.zone.VALKURM_DUNES] =
    {
        csBit             = 7,
        csRegisterGlass   = 15,
        csFirst           = 33,
        csWin             = 39,
        csDyna            = 58,
        maxCapacity       = 36,
        enabled           = true,
        hasSeenFirstCSVar = 'DynamisCop_First',
        winVar            = 'DynaValkurm_Win',
        enteredVar        = 'DynaValkurm_entered',
        hasSeenWinCSVar   = 'DynaValkurm_HasSeenWinCS',
        winKI             = xi.ki.DYNAMIS_VALKURM_SLIVER,
        enterPos          = { 100, -8, 131, 47, 39 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
        },
    },
    [xi.zone.BUBURIMU_PENINSULA] =
    {
        csBit             = 8,
        csRegisterGlass   = 21,
        csFirst           = 40,
        csWin             = 46,
        csDyna            = 22,
        maxCapacity       = 36,
        enabled           = true,
        hasSeenFirstCSVar = 'DynamisCop_First',
        winVar            = 'DynaBuburimu_Win',
        enteredVar        = 'DynaBuburimu_entered',
        hasSeenWinCSVar   = 'DynaBuburimu_HasSeenWinCS',
        winKI             = xi.ki.DYNAMIS_BUBURIMU_SLIVER,
        enterPos          = { 155, -1, -169, 170, 40 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
        },
    },
    [xi.zone.QUFIM_ISLAND] =
    {
        csBit             = 9,
        csRegisterGlass   = 2,
        csFirst           = 22,
        csWin             = 28,
        csDyna            = 3,
        maxCapacity       = 36,
        enabled           = true,
        hasSeenFirstCSVar = 'DynamisCop_First',
        winVar            = 'DynaQufim_Win',
        enteredVar        = 'DynaQufim_entered',
        hasSeenWinCSVar   = 'DynaQufim_HasSeenWinCS',
        winKI             = xi.ki.DYNAMIS_QUFIM_SLIVER,
        enterPos          = { -19, -17, 104, 253, 41 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
        },
    },
    [xi.zone.TAVNAZIAN_SAFEHOLD] =
    {
        csBit             = 10,
        csRegisterGlass   = 587,
        csFirst           = 614,
        csWin             = 615,
        csDyna            = 588,
        maxCapacity       = 18,
        enabled           = true,
        hasSeenFirstCSVar = 'DynaTavnazia_First',
        winVar            = 'DynaTavnazia_Win',
        enteredVar        = 'DynaTavnazia_entered',
        hasSeenWinCSVar   = 'DynaTavnazia_HasSeenWinCS',
        winKI             = xi.ki.DYNAMIS_TAVNAZIA_SLIVER,
        enterPos          = { 0.1, -7, -21, 190, 42 },
        reqs =
        {
            xi.ki.VIAL_OF_SHROUDED_SAND,
            xi.ki.DYNAMIS_VALKURM_SLIVER,
            xi.ki.DYNAMIS_QUFIM_SLIVER,
            xi.ki.DYNAMIS_BUBURIMU_SLIVER,
        },
    },
}

--[[
    [zone] =
    {
        winVar = Variable for the Win Condition
        enteredVar = Variable for Previous Entry
        hasSeenWinCSVar = Variable for Win CS
        winKI = Key item for win
        winTitle = Title for win
        entryPos = Coordinates in destination zone (Dynamis Zone)
        ejectPos = Coordinates in originating zone (Non-Dynamis Zone)
    }
--]]

xi.dynamis.dynaInfoEra =
{
    [xi.zone.DYNAMIS_SAN_DORIA] =
    {
        winVar          = 'DynaSandoria_Win',
        enteredVar      = 'DynaSandoria_entered',
        hasSeenWinCSVar = 'DynaSandoria_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_COMMAND_SCEPTER,
        winTitle        = xi.title.DYNAMIS_SAN_DORIA_INTERLOPER,
        winQM           = 17535224, -- ID Shift
        entryPos        = { 161.838, -2.000, 161.673, 93, xi.zone.DYNAMIS_SAN_DORIA },
        ejectPos        = { 161.000, -2.000, 161.000, 94, xi.zone.SOUTHERN_SAN_DORIA },
    },
    [xi.zone.SOUTHERN_SAN_DORIA] =
    {
        dynaZone             = xi.zone.DYNAMIS_SAN_DORIA,
        dynaZoneMessageParam = 1,
    },
    [xi.zone.DYNAMIS_BASTOK] =
    {
        winVar          = 'DynaBastok_Win',
        enteredVar      = 'DynaBastok_entered',
        hasSeenWinCSVar = 'DynaBastok_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_EYEGLASS,
        winTitle        = xi.title.DYNAMIS_BASTOK_INTERLOPER,
        winQM           = 17539323, -- ID Shift
        entryPos        = { 116.482, 0.994, -72.121, 128, xi.zone.DYNAMIS_BASTOK },
        ejectPos        = { 112.000, 0.994, -72.000, 127, xi.zone.BASTOK_MINES },
    },
    [xi.zone.BASTOK_MINES] =
    {
        dynaZone             = xi.zone.DYNAMIS_BASTOK,
        dynaZoneMessageParam = 2,
    },
    [xi.zone.DYNAMIS_WINDURST] =
    {
        winVar          = 'DynaWindurst_Win',
        enteredVar      = 'DynaWindurst_entered',
        hasSeenWinCSVar = 'DynaWindurst_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_LANTERN,
        winTitle        = xi.title.DYNAMIS_WINDURST_INTERLOPER,
        winQM           = 17543480, -- ID Shift
        entryPos        = { -221.988, 1.000, -120.184, 0 , xi.zone.DYNAMIS_WINDURST },
        ejectPos        = { -217.000, 1.000, -119.000, 94, xi.zone.WINDURST_WALLS },
    },
    [xi.zone.WINDURST_WALLS] =
    {
        dynaZone             = xi.zone.DYNAMIS_WINDURST,
        dynaZoneMessageParam = 3,
    },
    [xi.zone.DYNAMIS_JEUNO] =
    {
        winVar          = 'DynaJeuno_Win',
        enteredVar      = 'DynaJeuno_entered',
        hasSeenWinCSVar = 'DynaJeuno_HasSeenWinCS',
        winKI           = xi.ki.HYDRA_CORPS_TACTICAL_MAP,
        winTitle        = xi.title.DYNAMIS_JEUNO_INTERLOPER,
        winQM           = 17547510, -- ID Shift
        entryPos        = { 48.930, 10.002, -71.032, 195, xi.zone.DYNAMIS_JEUNO },
        ejectPos        = { 48.930, 10.002, -71.032, 195, xi.zone.RULUDE_GARDENS },
    },
    [xi.zone.RULUDE_GARDENS] =
    {
        dynaZone             = xi.zone.DYNAMIS_JEUNO,
        dynaZoneMessageParam = 4,
    },
    [xi.zone.DYNAMIS_BEAUCEDINE] =
    {
        winVar            = 'DynaBeaucedine_Win',
        enteredVar        = 'DynaBeaucedine_entered',
        hasSeenWinCSVar   = 'DynaBeaucedine_HasSeenWinCS',
        winKI             = xi.ki.HYDRA_CORPS_INSIGNIA,
        winTitle          = xi.title.DYNAMIS_BEAUCEDINE_INTERLOPER,
        winQM             = 17326801, -- ID Shift
        entryPos          = { -284.751, -39.923, -422.948, 235, xi.zone.DYNAMIS_BEAUCEDINE },
        ejectPos          = { -284.751, -39.923, -422.948, 235, xi.zone.BEAUCEDINE_GLACIER },
    },
    [xi.zone.BEAUCEDINE_GLACIER] =
    {
        dynaZone             = xi.zone.DYNAMIS_BEAUCEDINE,
        dynaZoneMessageParam = 5,
    },
    [xi.zone.DYNAMIS_XARCABARD] =
    {
        winVar            = 'DynaXarcabard_Win',
        enteredVar        = 'DynaXarcabard_entered',
        hasSeenWinCSVar   = 'DynaXarcabard_HasSeenWinCS',
        winKI             = xi.ki.HYDRA_CORPS_BATTLE_STANDARD,
        winTitle          = xi.title.DYNAMIS_XARCABARD_INTERLOPER,
        winQM             = 17330781, -- ID Shift
        entryPos          = { 569.312, -0.098, -270.158, 90, xi.zone.DYNAMIS_XARCABARD },
        ejectPos          = { 569.312, -0.098, -270.158, 90, xi.zone.XARCABARD },
    },
    [xi.zone.XARCABARD] =
    {
        dynaZone             = xi.zone.DYNAMIS_XARCABARD,
        dynaZoneMessageParam = 6,
    },
    [xi.zone.DYNAMIS_VALKURM] =
    {
        winVar            = 'DynaValkurm_Win',
        enteredVar        = 'DynaValkurm_entered',
        hasSeenWinCSVar   = 'DynaValkurm_HasSeenWinCS',
        winKI             = xi.ki.DYNAMIS_VALKURM_SLIVER,
        winTitle          = xi.title.DYNAMIS_VALKURM_INTERLOPER,
        winQM             = 16937587, -- ID Shift
        -- sjRestrictionNPC  = 16937585, -- ID Shift (Valk does not use a SJ NPC)
        entryPos          = { 100, -8, 131, 47, xi.zone.DYNAMIS_VALKURM },
        ejectPos          = { 119, -9, 131, 52, xi.zone.VALKURM_DUNES },
    },
    [xi.zone.VALKURM_DUNES] =
    {
        dynaZone             = xi.zone.DYNAMIS_VALKURM,
        dynaZoneMessageParam = 7,
    },
    [xi.zone.DYNAMIS_BUBURIMU] =
    {
        winVar                 = 'DynaBuburimu_Win',
        enteredVar             = 'DynaBuburimu_entered',
        hasSeenWinCSVar        = 'DynaBuburimu_HasSeenWinCS',
        winKI                  = xi.ki.DYNAMIS_BUBURIMU_SLIVER,
        winTitle               = xi.title.DYNAMIS_BUBURIMU_INTERLOPER,
        winQM                  = 16941678, -- ID Shift
        entryPos               = { 155, -1, -169, 170, xi.zone.DYNAMIS_BUBURIMU },
        ejectPos               = { 154, -1, -170, 190, xi.zone.BUBURIMU_PENINSULA },
        sjRestrictionNPC       = 16941677, -- ID Shift
        sjRestrictionLocation  =
        {
            [1] = { -214.161, 15.360, -269.202, 54  },
            [2] = {  620.425,  7.306, -266.427, 71  },
            [3] = {  427.460, -0.308,  189.224, 50  },
            [4] = {  320.489, -0.642,  366.648, 101 },
        }
    },
    [xi.zone.BUBURIMU_PENINSULA] =
    {
        dynaZone             = xi.zone.DYNAMIS_BUBURIMU,
        dynaZoneMessageParam = 8,
    },
    [xi.zone.DYNAMIS_QUFIM] =
    {
        winVar                 = 'DynaQufim_Win',
        enteredVar             = 'DynaQufim_entered',
        hasSeenWinCSVar        = 'DynaQufim_HasSeenWinCS',
        winKI                  = xi.ki.DYNAMIS_QUFIM_SLIVER,
        winTitle               = xi.title.DYNAMIS_QUFIM_INTERLOPER,
        winQM                  = 16945640, -- ID Shift
        entryPos               = { -19, -17, 104, 253, xi.zone.DYNAMIS_QUFIM },
        ejectPos               = { 18, -19, 162, 240, xi.zone.QUFIM_ISLAND },
        sjRestrictionNPC       = 16945639, -- ID Shift
        sjRestrictionLocation  =
        {
            [1]  = { -264.498, -19.255, 401.465, 54  },
            [2]  = { -264.655, -19.268, 240.580, 71  },
            [3]  = {  -77.771, -19.068, 258.666, 50  },
            [4]  = { -137.127, -19.976, 228.789, 101 },
            [5]  = {  -61.647, -19.868, 152.935, 35  },
            [6]  = {   27.973, -20.270, 191.907, 195 },
            [7]  = {  107.445, -20.368, 149.587, 64  },
            [8]  = {   99.884, -19.557,  51.518, 27  },
            [9]  = {  -29.895, -21.095, -57.154, 209 },
            [10] = {   88.474, -20.621, -49.333, 4   },
            [11] = { -192.540, -20.477, -11.055, 151 },
            [12] = { -340.976, -20.421,  31.154, 66  },
        }
    },
    [xi.zone.QUFIM_ISLAND] =
    {
        dynaZone             = xi.zone.DYNAMIS_QUFIM,
        dynaZoneMessageParam = 9,
    },
    [xi.zone.DYNAMIS_TAVNAZIA] =
    {
        winVar            = 'DynaTavnazia_Win',
        enteredVar        = 'DynaTavnazia_entered',
        hasSeenWinCSVar   = 'DynaTavnazia_HasSeenWinCS',
        winKI             = xi.ki.DYNAMIS_TAVNAZIA_SLIVER,
        qmTitle           = xi.title.DYNAMIS_TAVNAZIA_INTERLOPER,
        winTitle          = xi.title.NIGHTMARE_AWAKENER,
        csTitle           = xi.title.CONFRONTER_OF_NIGHTMARES,
        winQM             = 16949400, -- ID Shift
        entryPos          = { 0.1, -7, -21, 190, xi.zone.DYNAMIS_TAVNAZIA },
        ejectPos          = { 0  , -7, -23, 195, xi.zone.TAVNAZIAN_SAFEHOLD },
        timeExtensions    = { 16949398, 16949399 }, -- ID Shift
    },
    [xi.zone.TAVNAZIAN_SAFEHOLD] =
    {
        dynaZone             = xi.zone.DYNAMIS_TAVNAZIA,
        dynaZoneMessageParam = 10,
    },

}

local hourglassTradeResult =
{
    NEW        = 1,
    REGISTERED = 2,
    INVALID    = 3,
}

-- Cleanup Done
local function checkEntryReqs(player, zoneId)
    local entryInfo = xi.dynamis.entryInfoEra[zoneId]
    print('[DEBUG] Checking player charvar ' .. entryInfo.enteredVar .. ' for previous Dynamis entry.')
    -- Let GMs in or if the player has entered yet
    if
        checkGM(player) or
        player:getCharVar(entryInfo.enteredVar) ~= 0
    then
        print('[DEBUG] GM or has previously entered Dynamis, skipping entry requirements.')
        return true
    end

    -- Check the players levels
    if player:getMainLvl() < dynamisMinLvl then
        player:printToPlayer('Your current level is not high enough to enter dynamis.', xi.msg.channel.NS_SAY)
        return false
    end

    -- CoP requirement for Dreamlands Dynamis (csBit >= 7)
    if
        entryInfo.csBit >= 7 and
        not player:hasCompletedMission(xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED)
    then
        print('[DEBUG] Missing CoP mission requirement to enter Dynamis.')
        return false
    end

    -- Must have all required key items to enter
    -- Early return if it misses a single one
    for _, ki in ipairs(entryInfo.reqs) do
        print('[DEBUG] Checking for required key item to enter Dynamis: ', ki)
        if not player:hasKeyItem(ki) then
            print('[DEBUG] Missing required key item to enter Dynamis: ', ki)
            return false
        end
    end

    print('[DEBUG] Player meets all entry requirements for Dynamis.')
    return true
end

-----------------------------------
-- onZoneTick Dynamis Functions  --
-----------------------------------
local dreamlandsSet =
{
    [xi.zone.DYNAMIS_BUBURIMU]  = true,
    [xi.zone.DYNAMIS_QUFIM]     = true,
    [xi.zone.DYNAMIS_VALKURM]   = true,
    [xi.zone.DYNAMIS_TAVNAZIA]  = true,
}

-- Lets set all the save effects to true so we can check if we need to remove them
local savedStatusEffects =
{
    [xi.effect.RERAISE]        = true,
    [xi.effect.SIGIL]          = true,
    [xi.effect.SIGNET]         = true,
    [xi.effect.SANCTION]       = true,
    [xi.effect.SJ_RESTRICTION] = true,
    [xi.effect.FOOD]           = true,
    [xi.effect.BATTLEFIELD]    = true,
    [xi.effect.DEDICATION]     = true,
}

-- Cleanup Done
-- TODO remove cyclomatic complexity
-- luacheck: ignore 561
xi.dynamis.handleDynamis = function(zone)
    local zoneID = zone:getID()

    -- Lets make the vars look pretty so I can see what we are actually setting
    -- Could change it back to what it is with zone:getLocalVar calls but this is easier to read for my eyes
    local varToken        = string.format('[DYNA]Token_%s', zoneID)
    local varTimepoint    = string.format('[DYNA]Timepoint_%s', zoneID)
    local varWarn10       = string.format('[DYNA]Given10MinuteWarning_%s', zoneID)
    local varWarn3        = string.format('[DYNA]Given3MinuteWarning_%s', zoneID)
    local varWarn1        = string.format('[DYNA]Given1MinuteWarning_%s', zoneID)
    local varNoPlayer     = string.format('[DYNA]NoPlayerTimer_%s', zoneID)
    local varZoneCooldown = string.format('[DYNA]ZoneCooldown_%s', zoneID)
    local varCleanup      = string.format('[DYNA]CleanupScript_%s', zoneID)

    -- Now that we can see what vars we have lets get everything we need
    -- Token and timepoints
    local zoneDynamistoken  = zone:getLocalVar(varToken)
    local zoneTimepoint     = GetServerVariable(varTimepoint)
    local zoneTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)

    -- Warning vars
    local zoneWarn10 = zone:getLocalVar(varWarn10)
    local zoneWarn3  = zone:getLocalVar(varWarn3)
    local zoneWarn1  = zone:getLocalVar(varWarn1)

    -- Player counts and timers
    local playersInZone = zone:getPlayers()
    local noPlayerTimer = zone:getLocalVar(varNoPlayer)
    local currentTime   = GetSystemTime()

    local parentZone = GetZone(xi.dynamis.dynaIDLookup[zoneID].entryZone)
    if not parentZone then
        print('[DEBUG] Parent Zone is nil | xi.dynamis.handleDynamis ABORTED')
        return
    end

    local zoneCooldown  = parentZone:getLocalVar(varZoneCooldown)
    local cleanupScript = parentZone:getLocalVar(varCleanup)

    -- Unfortuntealy I don't know a better way to check for everything once per
    -- player on entry other than looping through here
    -- This should only run ONCE on every player when they enter the zone
    -- Start iterating through the player list
    for _, player in pairs(playersInZone) do
        if player:getLocalVar('Requires_Initial_Update') == 0 then
            -- Need to update every players hourglass
            xi.dynamis.updatePlayerHourglass(player, zoneDynamistoken)

            -- Dreamlands SJ check
            if
                dreamlandsSet[zoneID] and
                zone:getLocalVar('SJUnlock') ~= 1
            then
                if player:getGMLevel() < 2 then
                    for _, effect in pairs(player:getStatusEffects()) do
                        local effectID = effect:getEffectType()
                        if not savedStatusEffects[effectID] then
                            player:delStatusEffectSilent(effectID)
                        end
                    end
                end

                player:addStatusEffect(xi.effect.SJ_RESTRICTION, 0, 0, 18000)
            end

            player:setLocalVar('Requires_Initial_Update', 1) -- Don't run again for this player
        end

        -- Hourglass validity checks (GMs can stay until expiry)
        if
            not checkGM(player) and
            player:getLocalVar('[DYNA]NextHourglassCheck') < currentTime
        then
            if xi.dynamis.verifyHoldsValidHourglass(player, zoneDynamistoken, zoneTimepoint) then
                player:setLocalVar('[DYNA]NextHourglassCheck', currentTime + 5)
            end
        end
    end

    -- 10, 3 and 1 minute warnings
    if cleanupScript == 0 then
        if
            zoneWarn1 == 0 and
            zoneTimeRemaining < 80
        then
            xi.dynamis.dynamisTimeWarning(zone, zoneTimepoint)
            zone:setLocalVar(varWarn1, 1) -- Don't give another warning
        elseif
            zoneWarn3 == 0 and
            zoneTimeRemaining < 200
        then
            xi.dynamis.dynamisTimeWarning(zone, zoneTimepoint)
            zone:setLocalVar(varWarn3, 1) -- Don't give another warning
        elseif
            zoneWarn10 == 0 and
            zoneTimeRemaining < 620
        then
            xi.dynamis.dynamisTimeWarning(zone, zoneTimepoint)
            zone:setLocalVar(varWarn10, 1) -- Don't give another warning
        end
    end

    -- Time has finally expired - goodbye players o7
    if zoneTimeRemaining <= 1 then
        xi.dynamis.ejectAllPlayers(zone)

        -- After ejecting everyone run the cleanup it it hasnt ran already
        if
            cleanupScript == 0 and
            zoneCooldown == 0
        then
            parentZone:setLocalVar(varZoneCooldown, currentTime + 90)
            xi.dynamis.cleanupDynamis(zone)
        end
    end

    -- Handle no players in zone, no timers on players present, no cleanup script ran
    if
        #playersInZone == 0 and
        noPlayerTimer == 0 and
        cleanupScript == 0
    then
        -- NOTE: We do 5sec less than 5min to prevent zone idle from happening before cleanup fired
        zone:setLocalVar(varNoPlayer, currentTime + 295)
    elseif
        #playersInZone > 0 and
        noPlayerTimer ~= 0
    then
        zone:setLocalVar(varNoPlayer, 0)
    end

    -- Cleanup after no-player timer expires, cleanup has not run, no cooldown timer set
    if
        noPlayerTimer > 0 and
        noPlayerTimer <= currentTime and
        cleanupScript == 0 and
        zoneCooldown == 0
    then
        parentZone:setLocalVar(varZoneCooldown, currentTime + 90)
        xi.dynamis.cleanupDynamis(zone)
    end
end

-----------------------------------
--   Dynamis Start Functions    --
-----------------------------------
-- Cleanup Done
xi.dynamis.onNewDynamis = function(player)
    local playerZoneID = player:getZoneID()
    local zoneID = xi.dynamis.dynaInfoEra[playerZoneID].dynaZone
    local zone = GetZone(zoneID)

    if not zone then
        print('[DEBUG] Zone is nil | xi.dynamis.onNewDynamis')
        return
    end

    local dynaInfo = xi.dynamis.dynaInfoEra[zoneID]

    -- I need to make sure we need wave vars anymore with having specific IDS
    -- Ensure all Wave Vars are set to 0 before we spawn anything.
    -- for waveNumber, _ in pairs(xi.dynamis.mobList[zoneID].waveDefeatRequirements) do
    --     zone:setLocalVar(string.format('Wave_%i_Spawned', waveNumber), 0)
    -- end

    -- Spawn Wave 1
    xi.dynamis.spawnWave(xi.dynamis.wave[zoneID][1])
    print(string.format('[DYNAMIS] Spawning Wave 1 mobs for zoneID: %d', zoneID))
    -- Check for locations, if you got some lets pick one
    local locations = dynaInfo.sjRestrictionLocation
    if locations then
        local pick = locations[math.random(#locations)]
        local sjNPC = GetNPCByID(dynaInfo.sjRestrictionNPC)
        if sjNPC then
            sjNPC:setPos(pick[1], pick[2], pick[3])
            sjNPC:setStatus(xi.status.NORMAL)
        end
    end

    -- Hide winQM until allowed to spawn
    local winQM = GetNPCByID(dynaInfo.winQM)
    if winQM then
        winQM:setStatus(xi.status.DISAPPEAR)
    end

    -- Might redo all of the tav stuff. For now just leave it here.
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        xi.dynamis.dynamisTavnaziaOnNewDynamis(player, zone)
    end
end

-----------------------------------
--    Dynamis Zone Functions    --
-----------------------------------
-- Cleanup Done
-- Re-wrote the function to be used for everything not just GMs
xi.dynamis.addMinutesToDynamis = function(zone, minutes)
    local zoneID          = zone:getID()
    local varToken        = string.format('[DYNA]Token_%s', zoneID)
    local varTimepoint    = string.format('[DYNA]Timepoint_%s', zoneID)
    local varWarn10       = string.format('[DYNA]Given10MinuteWarning_%s', zoneID)
    local varWarn3        = string.format('[DYNA]Given3MinuteWarning_%s', zoneID)
    local varWarn1        = string.format('[DYNA]Given1MinuteWarning_%s', zoneID)

    -- Now that we can see what vars we have lets get everything we need
    -- Token and timepoints
    local zoneDynamisToken  = zone:getLocalVar(varToken)
    local zoneTimepoint     = GetServerVariable(varTimepoint)-- Determine previous expiration time.
    local zoneTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)
    local newZoneTimepoint  = zoneTimepoint + (60 * minutes) -- Add more time to increase previous expiration point.

    -- Update Time Remaining
    SetServerVariable(string.format('[DYNA]Timepoint_%s', zoneID), newZoneTimepoint)

    -- Player counts and timers
    local playersInZone = zone:getPlayers()

    -- Update Hourglasses for Players
    for _, player in pairs(playersInZone) do
        player:messageSpecial(zones[zoneID].text.DYNAMIS_TIME_EXTEND, minutes)
        xi.dynamis.updatePlayerHourglass(player, zoneDynamisToken)
    end

    -- Handle Time Limit Warnings
    if zoneTimeRemaining > 620 then -- Checks if time remaining > 11 minutes.
        zone:setLocalVar(varWarn10, 0) -- Resets var if time remaining greater than threshold.
    end

    if zoneTimeRemaining > 200 then -- Checks if time remaining > 4 minutes.
        zone:setLocalVar(varWarn3, 0) -- Resets var if time remaining greater than threshold.
    end

    if zoneTimeRemaining > 80 then -- Checks if time remaining > 2 minutes.
        zone:setLocalVar(varWarn1, 0) -- Resets var if time remaining greater than threshold.
    end
end

-- Cleanup Done
xi.dynamis.addTimeToDynamis = function(zone, mob)
    local zoneID = zone:getID()
    local mobID  = mob:getID()

    -- print(('Dynamis Time Extension Check | ZoneID: %d | MobID: %d'):format(zoneID, mobID))

    local extTable = xi.dynamis.timeExtension[zoneID]
    local minutes  = extTable[mobID]
    -- print('printing minutes ' .. tostring(minutes))

    if minutes then
        print(('TIME EXTENSION FOUND: %d minutes for mobID: %d'):format(minutes, mobID))
        xi.dynamis.addMinutesToDynamis(zone, minutes)
    end

    -- Time extension trigger for the ??? in Dynamis - Tavnazia
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        xi.dynamis.addMinutesToDynamis(zone, 30)
    end
end

-- Cleanup Done
xi.dynamis.getDynaTimeRemaining = function(zoneTimePoint)
    local zoneTimeResult = (zoneTimePoint - GetSystemTime()) -- Returns difference.
    if zoneTimeResult < 0 then
        return 0
    else
        return zoneTimeResult
    end
end

-- Cleanup Done
xi.dynamis.cleanupDynamis = function(zone)
    local zoneID = zone:getID()
    local parentZone = GetZone(xi.dynamis.dynaIDLookup[zoneID].entryZone)

    if parentZone == nil then
        print('[DEBUG] Parent Zone is nil | xi.dynamis.cleanupDynamis')
        return
    end

    SetServerVariable(string.format('[DYNA]RegisteredPlayers_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]Token_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]Timepoint_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]OriginalRegistrant_%s', zoneID), 0)
    parentZone:setLocalVar(string.format('[DYNA]CleanupScript_%s', zoneID), 1)
    zone:resetLocalVars()
    xi.dynamis.ejectAllPlayers(zone) -- Remove Players (This is precautionary but not necessary.)
    xi.dynamis.despawnAll(zone) -- Despawns all mobs / npcs in zone
end

xi.dynamis.despawnAll = function(zone)
    print('[DYNADEBUG] despawnAll zoneID: ' .. tostring(zone:getID()))

    local mobsInZone = zone:getMobs()
    local npcsInZone = zone:getNPCs()
    for _, mobEntity in pairs(mobsInZone) do
        DespawnMob(mobEntity:getID()) -- Despawn
    end

    for _, npcEntity in pairs(npcsInZone) do
        npcEntity:setStatus(xi.status.DISAPPEAR)
        print('[DYNADEBUG] despawnAll DISAPPEAR NPC ID: ' .. tostring(npcEntity:getID()))
    end
end

-- Fine
xi.dynamis.dynamisTimeWarning = function(zone, zoneTimepoint)
    local zoneID        = zone:getID()
    local playersInZone = zone:getPlayers()
    local timeRemaining = math.floor((xi.dynamis.getDynaTimeRemaining(zoneTimepoint) / 60)) -- Get time remaining, convert to minutes, floor value.
    local ID            = zones[zoneID]
    for _, player in pairs(playersInZone) do
        if timeRemaining <= 2 then
            player:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_1, timeRemaining, 1) -- Send 1 minute warning.
        else
            player:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_2, timeRemaining, 1) -- Send [3/10] minutes warning.
        end
    end
end

-----------------------------------
--  Dynamis Player Functions    --
-----------------------------------
-- Cleanup Done
xi.dynamis.registerDynamis = function(player)
    local zoneID      = player:getZoneID()
    local dynaInfo    = xi.dynamis.dynaInfoEra[zoneID]
    local dynaZone    = GetZone(dynaInfo.dynaZone)
    local parentZone  = GetZone(zoneID)
    local currentTime = GetSystemTime()
    -- Validate zones exist
    if not dynaZone then
        print('[DEBUG] dynaZone is nil | xi.dynamis.registerDynamis')
        return
    end

    if not parentZone then
        print('[DEBUG] Parent Zone is nil | xi.dynamis.registerDynamis')
        return
    end

    -- Calculate expiration time (default 60 minutes, 15 minutes for Tavnazia)
    local expirationTime = currentTime + 60 * 60
    if zoneID == xi.zone.TAVNAZIAN_SAFEHOLD then
        expirationTime = currentTime + 60 * 15
    end

    -- Always register first
    local instanceID   = RegisterDynamisInstance(zoneID, player:getID())
    local dynamisToken = dynaInfo.dynaZone + expirationTime

    print('DEBUG: registerDynamis - zoneID: ' .. tostring(zoneID))
    print('DEBUG: registerDynamis - dynaZone: ' .. tostring(dynaInfo.dynaZone))
    print('DEBUG: registerDynamis - instanceID from RegisterDynamisInstance: ' .. tostring(instanceID))

    -- Define the vars so we can read what is going on again
    -- As said previously possibly move these to a lua var instead
    local dynazoneID        = dynaInfo.dynaZone
    local varToken          = string.format('[DYNA]Token_%s', dynazoneID)
    local varTimepoint      = string.format('[DYNA]Timepoint_%s', dynazoneID)
    local varRegTimepoint   = string.format('[DYNA]RegTimepoint_%s', dynazoneID)
    local varOrigRegistrant = string.format('[DYNA]OriginalRegistrant_%s', dynazoneID)
    local varInstanceID     = string.format('[DYNA]InstanceID_%s', dynazoneID)
    local varCleanupScript  = string.format('[DYNA]CleanupScript_%s', dynazoneID)
    local varCurrentWave    = string.format('[DYNA]CurrentWave_%s', zoneID)

    -- Set server vars
    SetServerVariable(varToken, dynamisToken)
    SetServerVariable(varTimepoint, expirationTime)
    SetServerVariable(varRegTimepoint, currentTime)
    SetServerVariable(varOrigRegistrant, player:getID())
    SetServerVariable(varInstanceID, instanceID)

    -- Need cleanup script to 0
    parentZone:setLocalVar(varCleanupScript, 0)

    -- Start the zone baby
    xi.dynamis.onNewDynamis(player)

    -- Set zone vars?
    -- I am not sure why we need the same local vars AND server vars???
    -- TODO cleanup this later if possible
    dynaZone:setLocalVar(varToken, dynamisToken)
    dynaZone:setLocalVar(varInstanceID, instanceID)
    dynaZone:setLocalVar(varCurrentWave, 1)

    -- Player stuff
    -- yes dynamisToken is correct - the old script was setting then getting then setting the var? Idk
    local playerZone = player:getZone()
    playerZone:setLocalVar(varToken, dynamisToken)
    playerZone:setLocalVar(varInstanceID, instanceID)
end

-- Cleanup Done
xi.dynamis.registerPlayer = function(player)
    local zoneID     = player:getZoneID()
    local dynaInfo   = xi.dynamis.dynaInfoEra[zoneID]
    local instanceID = GetServerVariable(string.format('[DYNA]InstanceID_%s', dynaInfo.dynaZone))

    print('DEBUG: zoneID: ' .. tostring(zoneID))
    print('DEBUG: dynaZone: ' .. tostring(dynaInfo.dynaZone))
    print('DEBUG: instanceID from server var: ' .. tostring(instanceID))

    player:setCharVar(string.format('[DYNA]PlayerRegisterKey_%s', (dynaInfo.dynaZone)), math.random(1, 100)) -- Obfuscate player registration value with dynamis token + player's zone ID info. (Ensures the player is counted as new registrant if token is different.)
    player:setCharVar(string.format('[DYNA]PlayerRegistered_%s', (dynaInfo.dynaZone)), (GetServerVariable(string.format('[DYNA]Token_%s', dynaInfo.dynaZone)) + player:getCharVar(string.format('[DYNA]PlayerRegisterKey_%s', (dynaInfo.dynaZone)))))
    player:setCharVar(string.format('[DYNA]PlayerZoneToken_%s', dynaInfo.dynaZone), GetServerVariable(string.format('[DYNA]Token_%s', dynaInfo.dynaZone))) -- Give the player a copy of the token value.
    player:setCharVar(string.format('[DYNA]PlayerRegisterTime_%s', dynaInfo.dynaZone), GetServerVariable(string.format('[DYNA]RegTimepoint_%s', dynaInfo.dynaZone)))

    xi.dynamis.recordLockout(player)

    -- luacheck: ignore 113
    print('DEBUG: Final instanceID: ' .. tostring(instanceID))
    print('DEBUG: playerId: ' .. tostring(player:getID()))
    AddDynamisParticipant(instanceID, player:getID())
end

-- TODO Cleanup
xi.dynamis.ejectPlayer = function(player, forceEject)
    local zoneID = player:getZoneID()
    if forceEject == nil then
        forceEject = false
    end

    if player:getCurrentRegion() == xi.region.DYNAMIS then
        if player:getLocalVar('Received_Eject_Warning') ~= 1 then
            player:delStatusEffectSilent(xi.effect.BATTLEFIELD)
            if not forceEject then
                player:timer(2000, function(playerArg)
                    playerArg:messageSpecial(xi.dynamis.dynaIDLookup[zoneID].text.NO_LONGER_HAVE_CLEARANCE, 0, 30) -- Wait 1 second, send no clearance message.
                end)

                player:setLocalVar('Received_Eject_Warning', 1)
                player:timer(30000, function(playerArgTwo)
                    playerArgTwo:setCharVar(string.format('[DYNA]EjectPlayer_%s', xi.dynamis.dynaInfoEra[zoneID].dynaZone), -1) -- Reset player's eject timer.
                    playerArgTwo:disengage() -- Force disengage.
                    playerArgTwo:timer(2000, function(playerArgThree)
                        playerArgThree:startCutscene(100) -- Wait 2 seconds then play exit CS.
                    end)
                end)
            else
                player:timer(2000, function(playerArgFour)
                    playerArgFour:messageSpecial(xi.dynamis.dynaIDLookup[zoneID].text.NO_LONGER_HAVE_CLEARANCE, 0, 0)
                    playerArgFour:setCharVar(string.format('[DYNA]EjectPlayer_%s', xi.dynamis.dynaInfoEra[zoneID].dynaZone), -1) -- Reset player's eject timer.
                    playerArgFour:disengage() -- Force disengage.
                    playerArgFour:timer(4000, function(playerArgFive)
                        playerArgFive:startCutscene(100) -- Wait 2 seconds then play exit CS.
                    end)
                end) -- Wait 1 second, send no clearance message.
            end
        end
    end
end

xi.dynamis.ejectAllPlayers = function(zone)
    local playersInZone = zone:getPlayers()
    for _, player in pairs(playersInZone) do
        xi.dynamis.ejectPlayer(player) -- Runs the ejectPlayer function per player.
    end
end

xi.dynamis.verifyHoldsValidHourglass = function(player, zoneDynamistoken, zoneTimepoint)
    local zoneID = player:getZoneID()

    if player:validateHourglass(zoneDynamistoken) then
        return true
    else
        if checkGM(player) then
            player:setCharVar(string.format('[DYNA]EjectPlayer_%s', zoneID), zoneTimepoint) -- Player is a GM and can bypass the hourglass requirement.
        elseif player:getCharVar(string.format('[DYNA]PlayerZoneToken_%s', player:getZoneID())) ~= zoneDynamistoken then
            xi.dynamis.ejectPlayer(player, true)
        else
            xi.dynamis.ejectPlayer(player)
        end

        return false
    end
end

xi.dynamis.verifyTradeHourglass = function(player, trade)
    local zoneID   = player:getZoneID()
    local dynaZone = xi.dynamis.dynaInfoEra[zoneID].dynaZone

    local dynamisToken = GetServerVariable(string.format('[DYNA]Token_%s', dynaZone))

    -- Validate hourglass first
    if not player:validateHourglass(dynamisToken) then
        return hourglassTradeResult.INVALID
    end

    local registered = player:getCharVar(string.format('[DYNA]PlayerRegistered_%s', dynaZone))
    local regKey     = player:getCharVar(string.format('[DYNA]PlayerRegisterKey_%s', dynaZone))

    -- If remainder matches key, player already registered
    if (registered - dynamisToken) == regKey then
        return hourglassTradeResult.REGISTERED
    end

    return hourglassTradeResult.NEW
end

xi.dynamis.updatePlayerHourglass = function(player, zoneDynamisToken)
    local zoneID = player:getZoneID()
    print('ZoneID in updatePlayerHourglass:', zoneID)
    local zoneTimepoint = GetServerVariable(string.format('[DYNA]Timepoint_%s', zoneID))

    player:updateHourglass(zoneDynamisToken, zoneTimepoint)
end

-----------------------------------
--   Dynamis NPC Functions      --
-----------------------------------
-- Cleanup Done
xi.dynamis.entryNpcOnTrade = function(player, npc, trade)
    local zoneID    = npc:getZoneID()
    local zone      = GetZone(zoneID)
    local entryInfo = xi.dynamis.entryInfoEra[zoneID]

    -- Validate zone exists
    if not zone then
        print('[DEBUG] Zone is nil | xi.dynamis.entryNpcOnTrade')
        return
    end

    -- Check if zone is enabled
    if not entryInfo.enabled then
        print('[DEBUG] entryNpcOnTrade - zone not enabled')
        return
    end

    local dynaZoneID = xi.dynamis.dynaInfoEra[zoneID].dynaZone
    local sysTime    = GetSystemTime()

    -- Vars again for readability
    local lockout = xi.dynamis.isPlayerLockedOut(player)
    -- TODO remove these possibly later
    local varZoneCooldown       = string.format('[DYNA]ZoneCooldown_%s', dynaZoneID)
    local varCleanupScript      = string.format('[DYNA]CleanupScript_%s', zoneID)
    local varRegisteredPlayers  = string.format('[DYNA]RegisteredPlayers_%s', dynaZoneID)
    local varTimepoint          = string.format('[DYNA]Timepoint_%s', dynaZoneID)

    -- Zone stuff
    local zoneTimepoint         = GetServerVariable(varTimepoint)
    local dynamisTimeRemaining  = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)
    local zoneCooldown          = zone:getLocalVar(varZoneCooldown)
    local cleanupScript         = zone:getLocalVar(varCleanupScript)

    -- Player stuff
    local playerEntered = player:getCharVar(entryInfo.enteredVar) or 0

    -- Reduce the logic because we were checking level again and everything inside checkEntryReqs already
    -- TODO CHECK IF MESSEGING ALL WORKS AS INTENDED
    if player:getLocalVar(entryInfo.enteredVar) == 0 then
        if not checkEntryReqs(player, zoneID) then
            print('DEBUG: entryNpcOnTrade - entry requirements not met')
            return
        end
    end

    if playerEntered == nil then
        playerEntered = 0
    end

    -- Timeless hourglass trade (start new Dynamis instance)
    -- I have a feeling we are missing a first cutscene check here
    -- Need to test that still
    -- TODO
    if npcUtil.tradeHasExactly(trade, { dynamisTimelessHourglass }) then
        print('DEBUG: entryNpcOnTrade - timeless hourglass trade detected')

        -- Check if another group is currently in Dynamis
        if dynamisTimeRemaining > 0 then
            player:messageSpecial(xi.dynamis.dynaIDLookup[zoneID].text.ANOTHER_GROUP, entryInfo.csBit)
            return
        end

        -- Let the GMs all go in because they are cool like that
        if checkGM(player) then
            zone:setLocalVar(varZoneCooldown, 0)
            player:startEvent(entryInfo.csRegisterGlass, entryInfo.csBit, playerEntered == 1 and 0 or 1, dynamisReservationCancel, dynamisReentryDays, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- 3. Player must not be locked out
        if lockout ~= 0 then
            player:messageSpecial(zones[zoneID].text.YOU_CANNOT_ENTER_DYNAMIS, lockout, entryInfo.csBit)
            return false
        end

        -- Zone cooldown check + cleanup script check
        -- TODO look into combining the check up top, returns same thing
        if zoneCooldown > sysTime and cleanupScript ~= 1 then
            player:messageSpecial(xi.dynamis.dynaIDLookup[zoneID].text.ANOTHER_GROUP, entryInfo.csBit)
            return
        end

        -- Reset cooldown and start Dynamis
        zone:setLocalVar(varZoneCooldown, 0)
        player:startEvent(entryInfo.csRegisterGlass, entryInfo.csBit, playerEntered == 1 and 0 or 1, dynamisReservationCancel, dynamisReentryDays, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)

    -- Handle perpetual hourglass trade, this means an instance that is already running
    elseif npcUtil.tradeHasExactly(trade, { dynamisPerpetual }) then
        print('DEBUG: entryNpcOnTrade - perpetual hourglass trade detected')

        local glassValid   = xi.dynamis.verifyTradeHourglass(player, trade)
        local dynaCapacity = GetServerVariable(varRegisteredPlayers)

        -- Let the GMs all go in again because they are cool like that
        -- Idk if we need to register them again but whatever - TODO for later
        if checkGM(player) then
            xi.dynamis.registerPlayer(player)
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, dynamisReservationCancel, dynamisReentryDays, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- 3. Player must not be locked out
        if lockout ~= 0 then
            player:messageSpecial(zones[zoneID].text.YOU_CANNOT_ENTER_DYNAMIS, lockout, entryInfo.csBit)
            return false
        end

        -- Check if the player is registered first - THEN check for lockout since the lockout changes after they register
        if glassValid == hourglassTradeResult.REGISTERED then
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, dynamisReservationCancel, dynamisReentryDays, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- All your new friends want to help
        if glassValid == hourglassTradeResult.NEW then
            if dynaCapacity < entryInfo.maxCapacity then
                xi.dynamis.registerPlayer(player)
                player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, dynamisReservationCancel, dynamisReentryDays, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
                SetServerVariable(varRegisteredPlayers, dynaCapacity + 1)
            else
                player:printToPlayer('The Dynamis instance has reached its maximum capacity of ' .. entryInfo.maxCapacity .. ' registrants.', 29)
            end

            return
        end

        -- I think we are missing a re-entry check unless I am going crazy
        if dynamisTimeRemaining > 0 then
            player:messageSpecial(xi.dynamis.dynaIDLookup[zoneID].text.ANOTHER_GROUP, entryInfo.csBit)
        else
            player:printToPlayer('The Perpetual Hourglass\'s time has run out.', 29)
        end
    end
end

-- This function is on every NPC that handles Dynamis entry.
-- Cleanup Done
xi.dynamis.entryNpcOnTriggerEra = function(player, npc)
    local zoneID     = player:getZoneID()
    local entryInfo  = xi.dynamis.entryInfoEra[zoneID]
    local defaultMsg = zones[zoneID].text.DYNA_NPC_DEFAULT_MESSAGE
    local status     = player:getCharVar('Dynamis_Status')

    -- Bail out if zone is not enabled
    if not entryInfo.enabled then
        player:messageSpecial(defaultMsg)
        return
    end

    -- If player does not have sand, start CS to give sand.
    if
        entryInfo.csVial ~= nil and
        status == 1 and
        not player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND)
    then
        player:startEvent(entryInfo.csVial)
        return
    end

    -- If player has not seen first CS play that shit
    if
        entryInfo.csFirst ~= nil and
        checkEntryReqs(player, zoneID) and
        player:getCharVar(entryInfo.hasSeenFirstCSVar) == 0
    then
        player:startEvent(entryInfo.csFirst)
        return
    end

    -- If player has not seen win CS play win CS (assuming they have the KI)
    if
        entryInfo.csWin ~= nil and
        player:hasKeyItem(entryInfo.winKI) and
        player:getCharVar(entryInfo.hasSeenWinCSVar) == 0
    then
        if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
            player:startEvent(entryInfo.csWin, 0, getDynamisTavWinParam(player))
        else
            player:startEvent(entryInfo.csWin)
        end

        return
    end

    player:messageSpecial(defaultMsg) -- default message for everything else
end

-- Cleanup Done
xi.dynamis.entryNpcOnEventUpdate = function(player, csid, option, npc)
    local zoneID = player:getZoneID()
    local entryInfo = xi.dynamis.entryInfoEra[zoneID]

     -- If not enabled return
    if not entryInfo.enabled then
        return
    end

    -- If the event is finishing that means the glass is registering
    if csid ~= entryInfo.csRegisterGlass then
        return
    end

    print('DEBUG: entryNpcOnEventUpdate - csRegisterGlass cutscene')

    if npc == nil then
        print('[DEBUG] npc is nil | xi.dynamis.entryNpcOnEventUpdate - csRegisterGlass')
        return
    else
        -- Delete this later???
        print('[DEBUG] npc is valid - ID: ' .. tostring(npc:getID()) .. ' | Name: ' .. tostring(npc:getName()))
    end

    local dynaZoneID           = xi.dynamis.dynaInfoEra[zoneID].dynaZone
    local zoneTimepoint        = GetServerVariable(string.format('[DYNA]Timepoint_%s', dynaZoneID))
    local dynamisTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)

    -- Proceed if cutscene completed successfully
    if option == 0 and dynamisTimeRemaining <= 0 then
        print('DEBUG: entryNpcOnEventUpdate - calling registerDynamis')

        xi.dynamis.registerDynamis(player) -- Trigger the generation of a token, timepoint, and start spawning wave 1.
        player:tradeComplete()

        local dynaZone = GetZone(dynaZoneID)
        if dynaZone == nil then
            print('[DEBUG] dynaZone is nil | xi.dynamis.entryNpcOnEventUpdate')
            return
        end

        local dynamisToken = dynaZone:getLocalVar(string.format('[DYNA]Token_%s', dynaZoneID))
        player:createHourglass(dynaZoneID, dynamisToken, player:getID()) -- Create initial perpetual.
        player:messageSpecial(xi.dynamis.dynaIDLookup[zoneID].text.INFORMATION_RECORDED, dynamisPerpetual) -- Send player the recorded message.
        player:messageSpecial(zones[zoneID].text.ITEM_OBTAINED, dynamisPerpetual) -- Give player a message stating the perpetual has been obtained.

        player:instanceEntry(npc, 4) -- Successful completion of CS.
        return
    end

    -- Failed to complete CS.
    player:instanceEntry(npc, 3)
    player:messageSpecial(xi.dynamis.dynaIDLookup[zoneID].text.UNABLE_TO_CONNECT)
end

-- Cleanup Done
xi.dynamis.entryNpcOnEventFinishEra = function(player, csid, option)
    local zoneID    = player:getZoneID()
    local entryInfo = xi.dynamis.entryInfoEra[zoneID]

    -- If not enabled return
    if not entryInfo.enabled then
        return
    end

    -- Lets enter dynamis
    if csid == entryInfo.csDyna then
        if option ~= 0 then
            return
        end

        local entryPos = entryInfo.enterPos
        if not entryPos then
            return
        end

        -- Does this message even happen?
        -- TODO Check
        player:messageSpecial(xi.dynamis.dynaIDLookup[zoneID].text.CONNECTING_WITH_THE_SERVER)
        player:setCharVar(entryInfo.enteredVar, 1) -- Mark the player as having entered at least once.
        player:setPos(entryPos[1], entryPos[2], entryPos[3], entryPos[4], entryPos[5])
        return
    end

    -- Give Shrouded Sand KI
    if csid == entryInfo.csVial then
        npcUtil.giveKeyItem(player, xi.ki.VIAL_OF_SHROUDED_SAND)
        return
    end

    -- First CS seen
    if csid == entryInfo.csFirst then
        player:setCharVar(entryInfo.hasSeenFirstCSVar, 1)
        return
    end

    -- Win CS seen
    if csid == entryInfo.csWin then
        player:setCharVar(entryInfo.hasSeenWinCSVar, 1)

        if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
            player:addTitle(xi.dynamis.dynaInfoEra[zoneID].csTitle)
        end

        return
    end
end

-- Dynamis NPC triggers
-- TODO Cleanup
xi.dynamis.sjQMOnTrigger = function(npc)
    local zone = npc:getZone()
    local playersInZone = zone:getPlayers()
    for _, playerEntity in pairs(playersInZone) do
        if  playerEntity:hasStatusEffect(xi.effect.SJ_RESTRICTION) then -- Does player have SJ restriction?
            playerEntity:delStatusEffect(xi.effect.SJ_RESTRICTION) -- Remove SJ restriction
        end
    end

    zone:setLocalVar('SJUnlock', 1)
end

-- TODO Cleanup
xi.dynamis.timeExtensionOnTrigger = function(player, npc)
    local zone = player:getZone()
    xi.dynamis.addTimeToDynamis(zone, nil) -- Add Time
    for _, member in pairs(zone:getPlayers()) do
        member:changeMusic(0, 227) -- 0 Background Music (Sunbreeze Music)
        member:changeMusic(1, 227) -- 1 Background Music (Sunbreeze Music)
        member:changeMusic(2, 227) -- 2 Combat Music (Sunbreeze Music)
        member:changeMusic(3, 227) -- 3 Combat Music (Sunbreeze Music)
    end

    local firstFloorQM  = xi.dynamis.dynaInfoEra[xi.zone.DYNAMIS_TAVNAZIA].timeExtensions[1]
    local secondFloorQM = xi.dynamis.dynaInfoEra[xi.zone.DYNAMIS_TAVNAZIA].timeExtensions[2]
    if
        npc:getID() == firstFloorQM and
        zone:getLocalVar('Wave_2_Spawned') == 0 -- Check if the wave has spawned in case DISAPPEAR doesnt work
    then
        zone:setLocalVar('qmOne', 1)
        xi.dynamis.spawnWave(zone, xi.zone.DYNAMIS_TAVNAZIA, 2) -- Spawn the second wave
    elseif
        npc:getID() == secondFloorQM and
        zone:getLocalVar('Wave_3_Spawned') == 0 -- Check if the wave has spawned in case DISAPPEAR doesnt work
    then
        zone:setLocalVar('qmTwo', 1)
        xi.dynamis.spawnWave(zone, xi.zone.DYNAMIS_TAVNAZIA, 3) -- Spawn the third wave
    end

    npc:setStatus(xi.status.DISAPPEAR)
end

-- TODO Cleanup
xi.dynamis.qmOnTriggerEra = function(player, npc) -- Override standard qmOnTrigger()
    local zoneId = npc:getZoneID()

    -- Win KIs
    if not player:hasKeyItem(xi.dynamis.dynaInfoEra[zoneId].winKI) then
        npcUtil.giveKeyItem(player, xi.dynamis.dynaInfoEra[zoneId].winKI)
    end

    if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
        player:addTitle(xi.dynamis.dynaInfoEra[zoneId].qmTitle)
    end
end

-----------------------------------
-- Dynamis Player/Zone Functions --
-----------------------------------
-- TODO Cleanup/Delete
xi.dynamis.zoneOnZoneInitializeEra = function(zone)
    local zoneID = zone:getID()
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        -- xi.dynamis.dynamisTavnaziaOnZoneInitializeEra(zone)
    end
end

-- TODO Cleanup/Delete
xi.dynamis.onTriggerAreaEnter = function(player, triggerArea)
    local zoneID = player:getZoneID()
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        xi.dynamis.dynamisTavnaziaOnTriggerAreaEnter(player, triggerArea)
    end
end

-- TODO Cleanup -- currently being used
xi.dynamis.zoneOnZoneInEra = function(player, prevZone)
    local zoneID = player:getZoneID()
    local zoneTimepoint = GetServerVariable(string.format('[DYNA]Timepoint_%s', zoneID))
    local info = xi.dynamis.dynaInfoEra[zoneID]
    local ID = zones[zoneID]

    -- usually happens when zoning in with !zone command
    -- If player is in void, move player to entry.
    if
        player:getXPos() == 0 and
        player:getYPos() == 0 and
        player:getZPos() == 0
    then
        player:setPos(info.entryPos[1], info.entryPos[2], info.entryPos[3], info.entryPos[4])
    end

    player:timer(5000, function(playerArg)
        local timepoint = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)
        playerArg:addStatusEffectEx(xi.effect.BATTLEFIELD, 0, 1, 0, 0, true)
        playerArg:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_2, math.floor(utils.clamp(timepoint, 0, timepoint) / 60), 1) -- Send message letting player know how long they have.
    end)

    return -1
end

xi.dynamis.zoneOnZoneOut = function(player)
    if player:hasStatusEffect(xi.effect.BATTLEFIELD) then
        player:delStatusEffectSilent(xi.effect.BATTLEFIELD)
    end
end

return m
