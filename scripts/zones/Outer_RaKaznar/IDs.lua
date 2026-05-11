-----------------------------------
-- Area: Outer_RaKaznar
-----------------------------------
zones = zones or {}

zones[xi.zone.OUTER_RAKAZNAR] =
{
    text =
    {
        NOTHING_HAPPENS               = 119,  -- Nothing happens...
        ITEM_CANNOT_BE_OBTAINED       = 6385, -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393, -- Obtained: <item>.
        GIL_OBTAINED                  = 6394, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396, -- Obtained key item: <keyitem>.
        CARRIED_OVER_POINTS           = 7004, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        BAYLD_OBTAINED                = 7010, -- You have obtained <number> bayld!
        FAINT_ENERGY_WAFTS            = 7016, -- A faint energy wafts up from the ground.
        YOU_HAVE_LEARNED              = 7018, -- You have learned <keyitem>!
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026, -- Your party is unable to participate because certain members' levels are restricted.
        THIS_BAFFLING_GADGET          = 7753, -- This baffling gadget seems to serve as transport to the [lower/higher] floors.
        HAVE_FOUND_SCALES             = 7919, -- You have found <number> scale[/s].
        SOOTHING_SIGH_FALLS           = 7920, -- A soothing sigh falls upon your ears. Could you have found the final scale?
        DOOR_TIGHTLY_SEALED           = 7921, -- The door is tightly sealed.
        EERIE_GLOW_PENETRATES         = 7922, -- An eerie glow penetrates the darkness.
    },
    mob =
    {
        REIVE_MOB_OFFSET = GetFirstID('Amaranth_Barrier'),
    },
    npc =
    {
        REIVE_COLLISION_OFFSET = GetFirstID('_7m0'),
    },
}

return zones[xi.zone.OUTER_RAKAZNAR]
