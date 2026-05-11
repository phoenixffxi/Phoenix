-----------------------------------
-- Area: Valley_of_Sorrows
-----------------------------------
zones = zones or {}

zones[xi.zone.VALLEY_OF_SORROWS] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        FULL_INVENTORY_AFTER_TRADE    = 6389,  -- You cannot obtain the <item>. Try trading again after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        ITEMS_OBTAINED                = 6402,  -- You obtain <number> <item>!
        NOTHING_OUT_OF_ORDINARY       = 6407,  -- There is nothing out of the ordinary here.
        AURA_THREATENS                = 6411,  -- An aura of irrepressible might threatens to overwhelm you...
        FELLOW_MESSAGE_OFFSET         = 6422,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7004,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026,  -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7071,  -- Tallying conquest results...
        SOMETHING_BURRIED             = 7331,  -- It looks like something was buried here.
        PLAYER_OBTAINS_ITEM           = 7521,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 7522,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 7523,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 7524,  -- You already possess that temporary item.
        NO_COMBINATION                = 7529,  -- You were unable to enter a combination.
        UNITY_WANTED_BATTLE_INTERACT  = 7591,  -- Those who have accepted % must pay # Unity accolades to participate. The content for this Wanted battle is #. [Ready to begin?/You do not have the appropriate object set, so your rewards will be limited.]
        REGIME_REGISTERED             = 9707,  -- New training regime registered!
        COMMON_SENSE_SURVIVAL         = 10826, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        ADAMANTOISE   = GetFirstID('Adamantoise'),
        ASPIDOCHELONE = GetFirstID('Aspidochelone'),
    },
    npc =
    {
        ADAMANTOISE_QM = GetFirstID('qm1'),
    },
}

return zones[xi.zone.VALLEY_OF_SORROWS]
