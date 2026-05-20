-----------------------------------
-- Area: Eastern_Altepa_Desert
-----------------------------------
zones = zones or {}

zones[xi.zone.EASTERN_ALTEPA_DESERT] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        KEYITEM_LOST                  = 6397,  -- Lost key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY       = 6407,  -- There is nothing out of the ordinary here.
        SENSE_OF_FOREBODING           = 6408,  -- You are suddenly overcome with a sense of foreboding...
        FELLOW_MESSAGE_OFFSET         = 6422,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7004,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026,  -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7071,  -- Tallying conquest results...
        BEASTMEN_BANNER               = 7152,  -- There is a beastmen's banner.
        CONQUEST                      = 7239,  -- You've earned conquest points!
        FISHING_MESSAGE_OFFSET        = 7572,  -- You can't fish here.
        DIG_THROW_AWAY                = 7585,  -- You dig up <item>, but your inventory is full. You regretfully throw the <item> away.
        FIND_NOTHING                  = 7587,  -- You dig and you dig, but find nothing.
        AMK_DIGGING_OFFSET            = 7653,  -- You spot some familiar footprints. You are convinced that your moogle friend has been digging in the immediate vicinity.
        FOUND_ITEM_WITH_EASE          = 7662,  -- It appears your chocobo found this item with ease.
        ALREADY_OBTAINED_TELE         = 7682,  -- You already possess the gate crystal for this telepoint.
        REMNANTS_OF_A_PAST_AGE        = 7686,  -- These are remnants of a past age, made from a rare kind of stone.
        FEEL_A_HOSTILE_GAZE           = 7687,  -- You feel a hostile gaze upon you!
        GARRISON_BASE                 = 7709,  -- Hm? What is this? %? How do I know this is not some [San d'Orian/Bastokan/Windurstian] trick?
        PLAYER_OBTAINS_ITEM           = 7782,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 7783,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 7784,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 7785,  -- You already possess that temporary item.
        NO_COMBINATION                = 7790,  -- You were unable to enter a combination.
        UNITY_WANTED_BATTLE_INTERACT  = 7852,  -- Those who have accepted % must pay # Unity accolades to participate. The content for this Wanted battle is #. [Ready to begin?/You do not have the appropriate object set, so your rewards will be limited.]
        REGIME_REGISTERED             = 9968,  -- New training regime registered!
        COMMON_SENSE_SURVIVAL         = 11104, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        DUNE_WIDOW        = GetFirstID('Dune_Widow'),
        DONNERGUGI        = GetFirstID('Donnergugi'),
        CENTURIO_XII_I    = GetFirstID('Centurio_XII-I'),
        NANDI             = GetFirstID('Nandi'),
        DECURIO_I_III     = GetFirstID('Decurio_I-III'),
        TSUCHIGUMO_OFFSET = GetFirstID('Tsuchigumo'),
        CACTROT_RAPIDO    = GetFirstID('Cactrot_Rapido'),
    },
    npc =
    {
        OVERSEER_BASE = GetFirstID('Eaulevisat_RK'),
    },
}

return zones[xi.zone.EASTERN_ALTEPA_DESERT]
