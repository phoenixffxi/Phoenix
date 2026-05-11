-----------------------------------
-- Area: Xarcabard
-----------------------------------
zones = zones or {}

zones[xi.zone.XARCABARD] =
{
    text =
    {
        NOTHING_HAPPENS                = 119,   -- Nothing happens...
        ITEM_CANNOT_BE_OBTAINED        = 6398,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                  = 6406,  -- Obtained: <item>.
        GIL_OBTAINED                   = 6407,  -- Obtained <number> gil.
        KEYITEM_OBTAINED               = 6409,  -- Obtained key item: <keyitem>.
        KEYITEM_LOST                   = 6410,  -- Lost key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY        = 6420,  -- There is nothing out of the ordinary here.
        FELLOW_MESSAGE_OFFSET          = 6435,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS            = 7017,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY        = 7018,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                   = 7019,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED  = 7039,  -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                  = 7084,  -- Tallying conquest results...
        BEASTMEN_BANNER                = 7163,  -- There was a curse on the beastmen's banner!
        PRESENCE_IN_CAVE               = 7244,  -- You sense a presence in the cave...
        MONSTER_APPEARS                = 7247,  -- A monster appears from deep within the cave!
        SENSE_EVIL                     = 7373,  -- You can sense an evil force around you.
        DO_NOT_SENSE                   = 7374,  -- You do not sense anything out of the ordinary.
        ALREADY_OBTAINED_TELE          = 7394,  -- You already possess the gate crystal for this telepoint.
        CONQUEST                       = 7407,  -- You've earned conquest points!
        ONLY_SHARDS                    = 7740,  -- Only shards of ice lie upon the ground.
        BLOCKS_OF_ICE                  = 7741,  -- You can hear blocks of ice moving from deep within the cave.
        PERENNIAL_SNOW_DEFAULT         = 7742,  -- How many millennia has this snow been here, hidden from the rays of the sun?
        PERENNIAL_SNOW_WAIT            = 7744,  -- The <keyitem> you buried is not yet purified.
        CAVERN_CONTINUES               = 7799,  -- The cavern continues on for quite a distance.
        NOTHING_MORE                   = 7800,  -- There is nothing more to be done here.
        YOU_CANNOT_ENTER_DYNAMIS       = 7866,  -- You cannot enter Dynamis - [Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia] for <number> [day/days] (Vana'diel time).
        PLAYERS_HAVE_NOT_REACHED_LEVEL = 7868,  -- Players who have not reached level <number> are prohibited from entering Dynamis.
        DYNA_NPC_DEFAULT_MESSAGE       = 7905,  -- There is a symbol carved into the rock here.
        GARRISON_BASE                  = 8060,  -- Hm? What is this? %? How do I know this is not some [San d'Orian/Bastokan/Windurstian] trick?
        PLAYER_OBTAINS_ITEM            = 8183,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM          = 8184,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM       = 8185,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP           = 8186,  -- You already possess that temporary item.
        NO_COMBINATION                 = 8191,  -- You were unable to enter a combination.
        VOIDWALKER_DESPAWN             = 8222,  -- The monster fades before your eyes, a look of disappointment on its face.
        UNITY_WANTED_BATTLE_INTERACT   = 8253,  -- Those who have accepted % must pay # Unity accolades to participate. The content for this Wanted battle is #. [Ready to begin?/You do not have the appropriate object set, so your rewards will be limited.]
        REGIME_REGISTERED              = 10369, -- New training regime registered!
        VOIDWALKER_NO_MOB              = 11488, -- The <keyitem> quivers ever so slightly, but emits no light. There seem to be no monsters in the area.
        VOIDWALKER_MOB_TOO_FAR         = 11489, -- The <keyitem> quivers ever so slightly and emits a faint light. There seem to be no monsters in the immediate vicinity.
        VOIDWALKER_MOB_HINT            = 11490, -- The <keyitem> resonates [feebly/softly/solidly/strongly/very strongly/furiously], sending a radiant beam of light lancing towards a spot roughly <number> [yalm/yalms] [east/southeast/south/southwest/west/northwest/north/northeast] of here.
        VOIDWALKER_SPAWN_MOB           = 11491, -- A monster materializes out of nowhere!
        VOIDWALKER_UPGRADE_KI_1        = 11493, -- The <keyitem> takes on a slightly deeper hue and becomes <keyitem>!
        VOIDWALKER_UPGRADE_KI_2        = 11494, -- The <keyitem> takes on a deeper, richer hue and becomes <keyitem>!
        VOIDWALKER_BREAK_KI            = 11495, -- The <keyitem> shatters into tiny fragments.
        VOIDWALKER_OBTAIN_KI           = 11496, -- Obtained key item: <keyitem>!
        LEARNS_SPELL                   = 11545, -- <name> learns <spell>!
        UNCANNY_SENSATION              = 11547, -- You are assaulted by an uncanny sensation.
        COMMON_SENSE_SURVIVAL          = 11554, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        BARBARIC_WEAPON  = GetFirstID('Barbaric_Weapon'),
        BOREAL_HOUND     = GetFirstID('Boreal_Hound'),
        BOREAL_COEURL    = GetFirstID('Boreal_Coeurl'),
        BOREAL_TIGER     = GetFirstID('Boreal_Tiger'),
        CHAOS_ELEMENTAL  = GetFirstID('Chaos_Elemental'),
        ERESHKIGAL       = GetFirstID('Ereshkigal'),
        KOENIGSTIGER     = GetFirstID('Koenigstiger'),
        SHADOW_EYE       = GetFirstID('Shadow_Eye'),
        TIMEWORN_WARRIOR = GetFirstID('Timeworn_Warrior'),
        VOIDWALKER       =
        {
            [xi.keyItem.CLEAR_ABYSSITE] =
            {
                17236241, -- Gorehound
                17236240, -- Gorehound
                17236239, -- Gorehound
                17236238, -- Gorehound
                17236237, -- Gjenganger
                17236236, -- Gjenganger
                17236235, -- Gjenganger
                17236234, -- Gjenganger
            },
            [xi.keyItem.COLORFUL_ABYSSITE] =
            {
                17236233, -- Erebus
                17236232  -- Feuerunke
            },
            [xi.keyItem.PURPLE_ABYSSITE] =
            {
                17236231  -- Lord Ruthven
            },
            [xi.keyItem.BLACK_ABYSSITE] =
            {
                17236230  -- Yilbegan
            }
        }
    },
    npc =
    {
        OVERSEER_BASE    = GetFirstID('Jeantelas_RK'),
        BOREAL_TIGER_QM  = GetFirstID('qm_boreal_tiger'),
        BOREAL_COEURL_QM = GetFirstID('qm_boreal_coeurl'),
        BOREAL_HOUND_QM  = GetFirstID('qm_boreal_hound'),
        OPTION_ONE       = GetFirstID('Option_One'),
        OPTION_TWO       = GetFirstID('Option_Two'),
        OPTION_THREE     = GetFirstID('Option_Three'),
    },
}

return zones[xi.zone.XARCABARD]
