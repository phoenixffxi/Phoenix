-----------------------------------
-- Area: Gusgen Mines (196)
-----------------------------------
zones = zones or {}

zones[xi.zone.GUSGEN_MINES] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY       = 6407,  -- There is nothing out of the ordinary here.
        FELLOW_MESSAGE_OFFSET         = 6422,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7004,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        GEOMAGNETRON_ATTUNED          = 7015,  -- Your <keyitem> has been attuned to a geomagnetic fount in the corresponding locale.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026,  -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7071,  -- Tallying conquest results...
        FISHING_MESSAGE_OFFSET        = 7230,  -- You can't fish here.
        DEVICE_NOT_WORKING            = 7345,  -- The device is not working.
        SYS_OVERLOAD                  = 7354,  -- Warning! Sys...verload! Enterin...fety mode. ID eras...d.
        YOU_LOST_THE                  = 7359,  -- You lost the <item>.
        LOCK_OTHER_DEVICE             = 7362,  -- This entrance's lock is connected to some other device.
        SEE_MONSTER_TRACKS            = 7363,  -- You see monster tracks on the ground.
        FRESH_MONSTER_TRACKS          = 7364,  -- You see fresh monster tracks on the ground.
        NOTHING_SEEMS_HAPPENING       = 7365,  -- Nothing seems to be happening.
        YOU_PUT_ITEM_DOWN             = 7366,  -- You put <item> down.
        MINING_IS_POSSIBLE_HERE       = 7382,  -- Mining is possible here if you have <item>.
        CHEST_UNLOCKED                = 7397,  -- You unlock the chest!
        LETTERS_IS_WRITTEN_HERE       = 7405,  -- Something resembling letters is written here.
        FOUND_LOCATION_SEAL           = 7406,  -- You have found the location of the seal. You place <item> on it.
        IS_ON_THIS_SEAL               = 7407,  -- <item> is on this seal.
        SMALL_OPENING                 = 7408,  -- There is a small opening here.
        YOU_CANNOT_EVEN_DIG           = 7409,  -- You cannot even dig it open with <item>.
        PLAYER_OBTAINS_ITEM           = 8320,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 8321,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 8322,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 8323,  -- You already possess that temporary item.
        NO_COMBINATION                = 8328,  -- You were unable to enter a combination.
        REGIME_REGISTERED             = 10406, -- New training regime registered!
        LEARNS_SPELL                  = 11454, -- <name> learns <spell>!
        UNCANNY_SENSATION             = 11456, -- You are assaulted by an uncanny sensation.
        COMMON_SENSE_SURVIVAL         = 11491, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        BLIND_MOBY          = GetFirstID('Blind_Moby'),
        WANDERING_GHOST     = GetFirstID('Wandering_Ghost'),
        PUDDING_OFFSET      = GetFirstID('Pudding'),
        AROMA_FLY           = GetFirstID('Aroma_Fly'),
        ASPHYXIATED_AMSEL   = GetFirstID('Asphyxiated_Amsel'),
        BURNED_BERGMANN     = GetFirstID('Burned_Bergmann'),
        CRUSHED_KRAUSE      = GetFirstID('Crushed_Krause'),
        PULVERIZED_PFEFFER  = GetFirstID('Pulverized_Pfeffer'),
        SMOTHERED_SCHMIDT   = GetFirstID('Smothered_Schmidt'),
        WOUNDED_WURFEL      = GetFirstID('Wounded_Wurfel'),
        APPARATUS_ELEMENTAL = GetTableOfIDs('Earth_Elemental')[3], -- Last elemental in the list
    },
    npc =
    {
        TREASURE_CHEST = GetFirstID('Treasure_Chest'),
        MINING         = GetTableOfIDs('Mining_Point'),
    },
}

return zones[xi.zone.GUSGEN_MINES]
