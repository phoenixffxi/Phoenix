-----------------------------------
-- Area: King Ranperres Tomb (190)
-----------------------------------
zones = zones or {}

zones[xi.zone.KING_RANPERRES_TOMB] =
{
    text =
    {
        CONQUEST_BASE                 = 0,     -- Tallying conquest results...
        ITEM_CANNOT_BE_OBTAINED       = 6544,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6552,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6553,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6555,  -- Obtained key item: <keyitem>.
        FELLOW_MESSAGE_OFFSET         = 6581,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7163,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7164,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7165,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        GEOMAGNETRON_ATTUNED          = 7174,  -- Your <keyitem> has been attuned to a geomagnetic fount in the corresponding locale.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7185,  -- Your party is unable to participate because certain members' levels are restricted.
        HERE_LIES_KING_RANPERRE       = 7268,  -- Here lies King Ranperre. May he rest in peace.
        NOTHING_HAPPENS               = 7270,  -- Nothing happens.
        CHANGE_WATER                  = 7271,  -- You change the water.
        WATER_ALREADY_CHANGED         = 7272,  -- The water has already been changed.
        ALREADY_WATER_HERE            = 7273,  -- There is already water here.
        WATERSKIN_LYING_HERE          = 7274,  -- A waterskin is lying here.
        CHEST_UNLOCKED                = 7301,  -- You unlock the chest!
        SENSE_SOMETHING_EVIL          = 7328,  -- You sense something evil.
        HEAVY_DOOR                    = 7329,  -- It is a solid stone door.
        FINAL_RESTING_PLACE           = 7333,  -- It appears to be the true resting place of King Ranperre.
        PLAYER_OBTAINS_ITEM           = 8267,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 8268,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 8269,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 8270,  -- You already possess that temporary item.
        NO_COMBINATION                = 8275,  -- You were unable to enter a combination.
        REGIME_REGISTERED             = 10353, -- New training regime registered!
        COMMON_SENSE_SURVIVAL         = 11440, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        GWYLLGI               = GetFirstID('Gwyllgi'),
        CRYPT_GHOST           = GetFirstID('Crypt_Ghost'),
        BARBASTELLE           = GetFirstID('Barbastelle'),
        CHERRY_SAPLING_OFFSET = GetFirstID('Cherry_Sapling'),
        VRTRA                 = GetFirstID('Vrtra'),
        CORRUPTED_YORGOS      = GetFirstID('Corrupted_Yorgos'),
        CORRUPTED_SOFFEIL     = GetFirstID('Corrupted_Soffeil'),
        CORRUPTED_ULBRIG      = GetFirstID('Corrupted_Ulbrig'),
        ANKOU                 = GetFirstID('Ankou'),
    },
    npc =
    {
        TREASURE_CHEST = GetFirstID('Treasure_Chest'),
    },
}

return zones[xi.zone.KING_RANPERRES_TOMB]
