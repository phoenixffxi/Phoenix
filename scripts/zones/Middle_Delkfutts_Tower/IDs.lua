-----------------------------------
-- Area: Middle_Delkfutts_Tower
-----------------------------------
zones = zones or {}

zones[xi.zone.MIDDLE_DELKFUTTS_TOWER] =
{
    text =
    {
        CONQUEST_BASE                 = 4,    -- Tallying conquest results...
        ITEM_CANNOT_BE_OBTAINED       = 6548, -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6556, -- Obtained: <item>.
        GIL_OBTAINED                  = 6557, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6559, -- Obtained key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY       = 6570, -- There is nothing out of the ordinary here.
        SENSE_OF_FOREBODING           = 6571, -- You are suddenly overcome with a sense of foreboding...
        FELLOW_MESSAGE_OFFSET         = 6585, -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7167, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7168, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7169, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7189, -- Your party is unable to participate because certain members' levels are restricted.
        FISHING_MESSAGE_OFFSET        = 7234, -- You can't fish here.
        CHEST_UNLOCKED                = 7343, -- You unlock the chest!
        SENSE_A_FOUL_PRESENCE         = 7352, -- You sense a foul presence.
        PLAYER_OBTAINS_ITEM           = 7391, -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 7392, -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 7393, -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 7394, -- You already possess that temporary item.
        NO_COMBINATION                = 7399, -- You were unable to enter a combination.
        REGIME_REGISTERED             = 9477, -- New training regime registered!
    },
    mob =
    {
        BLADE_OF_EVIL_OFFSET     = GetFirstID('Gerwitzs_Scythe'),
        EURYTOS                  = GetFirstID('Eurytos'),
        OGYGOS                   = GetFirstID('Ogygos'),
        OPHION                   = GetFirstID('Ophion'),
        POLYBOTES                = GetFirstID('Polybotes'),
        RHOIKOS                  = GetFirstID('Rhoikos'),
        RHOITOS                  = GetFirstID('Rhoitos'),
    },
    npc =
    {
        TREASURE_CHEST = GetFirstID('Treasure_Chest'),
    },
}

return zones[xi.zone.MIDDLE_DELKFUTTS_TOWER]
