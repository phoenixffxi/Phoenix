-----------------------------------
-- Area: Behemoths_Dominion
-----------------------------------
zones = zones or {}

zones[xi.zone.BEHEMOTHS_DOMINION] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY       = 6407,  -- There is nothing out of the ordinary here.
        SENSE_OF_FOREBODING           = 6408,  -- You are suddenly overcome with a sense of foreboding...
        IRREPRESSIBLE_MIGHT           = 6411,  -- An aura of irrepressible might threatens to overwhelm you...
        FELLOW_MESSAGE_OFFSET         = 6422,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7004,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026,  -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7071,  -- Tallying conquest results...
        THERE_ARE_SYMBOLS             = 7331,  -- There are some symbols inscribed upon it.
        YOU_HEAR_A_NOISE              = 7333,  -- You hear a noise behind you.
        AIR_AROUND_YOU_CHANGED        = 7337,  -- The air around you has suddenly changed!
        SOMETHING_BETTER              = 7338,  -- Don't you have something better to do right now?
        CANNOT_REMOVE_FRAG            = 7341,  -- It is an oddly shaped stone monument. A shining stone is embedded in it, but cannot be removed...
        ALREADY_OBTAINED_FRAG         = 7342,  -- You have already obtained this monument's <keyitem>. Try searching for another.
        FOUND_ALL_FRAGS               = 7344,  -- You have obtained <keyitem>! You now have all 8 fragments of light!
        ZILART_MONUMENT               = 7345,  -- It is an ancient Zilart monument.
        PLAYER_OBTAINS_ITEM           = 7366,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 7367,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 7368,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 7369,  -- You already possess that temporary item.
        NO_COMBINATION                = 7374,  -- You were unable to enter a combination.
        UNITY_WANTED_BATTLE_INTERACT  = 7436,  -- Those who have accepted % must pay # Unity accolades to participate. The content for this Wanted battle is #. [Ready to begin?/You do not have the appropriate object set, so your rewards will be limited.]
        REGIME_REGISTERED             = 9552,  -- New training regime registered!
        LEARNS_SPELL                  = 11541, -- <name> learns <spell>!
        UNCANNY_SENSATION             = 11543, -- You are assaulted by an uncanny sensation.
        COMMON_SENSE_SURVIVAL         = 11550, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        BEHEMOTH                = GetFirstID('Behemoth'),
        KING_BEHEMOTH           = GetFirstID('King_Behemoth'),
        ANCIENT_WEAPON          = GetFirstID('Ancient_Weapon'),
        LEGENDARY_WEAPON        = GetFirstID('Legendary_Weapon'),
        TALEKEEPERS_GIFT_OFFSET = GetFirstID('Picklix_Longindex'),
    },
    npc =
    {
        BEHEMOTH_QM      = GetFirstID('qm2'),
        CERMET_HEADSTONE = GetFirstID('Cermet_Headstone'),
    },
}

return zones[xi.zone.BEHEMOTHS_DOMINION]
