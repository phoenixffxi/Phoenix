-----------------------------------
-- Area: Cape_Teriggan
-----------------------------------
zones = zones or {}

zones[xi.zone.CAPE_TERIGGAN] =
{
    text =
    {
        NOTHING_HAPPENS               = 119,   -- Nothing happens...
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        FULL_INVENTORY_AFTER_TRADE    = 6389,  -- You cannot obtain the <item>. Try trading again after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        KEYITEM_LOST                  = 6397,  -- Lost key item: <keyitem>.
        ITEMS_OBTAINED                = 6402,  -- You obtain <number> <item>!
        NOTHING_OUT_OF_ORDINARY       = 6407,  -- There is nothing out of the ordinary here.
        FELLOW_MESSAGE_OFFSET         = 6422,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7004,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026,  -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7071,  -- Tallying conquest results...
        BEASTMEN_BANNER               = 7152,  -- There is a beastmen's banner.
        CONQUEST                      = 7239,  -- You've earned conquest points!
        FISHING_MESSAGE_OFFSET        = 7572,  -- You can't fish here.
        SOMETHING_BETTER              = 7685,  -- Don't you have something better to do right now?
        CANNOT_REMOVE_FRAG            = 7688,  -- It is an oddly shaped stone monument. A shining stone is embedded in it, but cannot be removed...
        ALREADY_OBTAINED_FRAG         = 7689,  -- You have already obtained this monument's <keyitem>. Try searching for another.
        FOUND_ALL_FRAGS               = 7690,  -- You have obtained all of the fragments. You must hurry to the ruins of the ancient shrine!
        ZILART_MONUMENT               = 7692,  -- It is an ancient Zilart monument.
        MUST_BE_A_WAY_TO_SOOTHE       = 7700,  -- There must be a way to soothe the weary soul who once guarded this monument...
        COLD_WIND_CHILLS_YOU          = 7707,  -- A cold wind chills you to the bone.
        SENSE_OMINOUS_PRESENCE        = 7709,  -- You sense an ominous presence...
        GARRISON_BASE                 = 7896,  -- Hm? What is this? %? How do I know this is not some [San d'Orian/Bastokan/Windurstian] trick?
        PLAYER_OBTAINS_ITEM           = 7943,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 7944,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 7945,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 7946,  -- You already possess that temporary item.
        NO_COMBINATION                = 7951,  -- You were unable to enter a combination.
        UNITY_WANTED_BATTLE_INTERACT  = 8013,  -- Those who have accepted % must pay # Unity accolades to participate. The content for this Wanted battle is #. [Ready to begin?/You do not have the appropriate object set, so your rewards will be limited.]
        REGIME_REGISTERED             = 10129, -- New training regime registered!
        COMMON_SENSE_SURVIVAL         = 11248, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
        HOMEPOINT_SET                 = 11276, -- Home point set!
    },
    mob =
    {
        FROSTMANE              = GetFirstID('Frostmane'),
        KILLER_JONNY           = GetFirstID('Killer_Jonny'),
        KREUTZET               = GetFirstID('Kreutzet'),
        AXESARION_THE_WANDERER = GetFirstID('Axesarion_the_Wanderer'),
        STOLAS                 = GetFirstID('Stolas'),
        ZMEY_GORYNYCH          = GetFirstID('Zmey_Gorynych')
    },
    npc =
    {
        OVERSEER_BASE    = GetFirstID('Salimardi_RK'),
        CERMET_HEADSTONE = 17240498,
    },
}

return zones[xi.zone.CAPE_TERIGGAN]
