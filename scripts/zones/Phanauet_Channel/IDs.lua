-----------------------------------
-- Area: Phanauet_Channel
-----------------------------------
zones = zones or {}

zones[xi.zone.PHANAUET_CHANNEL] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385, -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393, -- Obtained: <item>.
        GIL_OBTAINED                  = 6394, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396, -- Obtained key item: <keyitem>.
        CARRIED_OVER_POINTS           = 7004, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026, -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7071, -- Tallying conquest results...
        TONBERRY_MSG                  = 7239, -- ...
        FISHING_MESSAGE_OFFSET        = 7240, -- You can't fish here.
        TRAVEL_ANY_FASTER             = 7385, -- Cannot this vessel travel any faster? At my age, every minute counts!
        ARE_WE_THERE_YET              = 7386, -- <Sigh> Are we there yet?
        RICHE_DAVOI_WATERFALL         = 7429, -- <item>...Davoi...waterfall...
    },
    mob =
    {
    },
    npc =
    {
        TIMEKEEPER_OFFSET = GetFirstID('Ineuteniace'),
        TONBERRY_OFFSET   = GetFirstID('Riche'),
        RIDER_OFFSET      = GetFirstID('Laiteconce'),
    },
}

return zones[xi.zone.PHANAUET_CHANNEL]
