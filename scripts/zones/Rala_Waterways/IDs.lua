-----------------------------------
-- Area: Rala_Waterways (258)
-----------------------------------
zones = zones or {}

zones[xi.zone.RALA_WATERWAYS] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385, -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393, -- Obtained: <item>.
        GIL_OBTAINED                  = 6394, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396, -- Obtained key item: <keyitem>.
        KEYITEM_LOST                  = 6397, -- Lost key item: <keyitem>.
        CARRIED_OVER_POINTS           = 7004, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        BAYLD_OBTAINED                = 7010, -- You have obtained <number> bayld!
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026, -- Your party is unable to participate because certain members' levels are restricted.
        NOTHING_HAPPENS               = 8087, -- Nothing happens.
        PERHAPS_THE_WISEST            = 8088, -- Perhaps the wisest approach would be to search for <keyitem> with which to open the decrepit sluice gate.
        A_QUICK_GLANCE_REVEALS        = 8710, -- A quick glance reveals spoiled water trickling from upstream, likely caused by effluvium from the recent destruction.
        THREE_BLOOD_SIGILS_PULSE      = 8934, -- The three blood sigils begin to pulse a violent crimson!
    },
    mob =
    {
    },
    npc =
    {
    },
}

return zones[xi.zone.RALA_WATERWAYS]
