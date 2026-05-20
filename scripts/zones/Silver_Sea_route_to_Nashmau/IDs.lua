-----------------------------------
-- Area: Silver_Sea_route_to_Nashmau
-----------------------------------
zones = zones or {}

zones[xi.zone.SILVER_SEA_ROUTE_TO_NASHMAU] =
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
        FISHING_MESSAGE_OFFSET        = 7067, -- You can't fish here.
        ON_WAY_TO_NASHMAU             = 7327, -- We are on our way to Nashmau. We should arrive in [less than an hour/about 1 hour/about 2 hours/about 3 hours/about 4 hours/about 5 hours/about 6 hours/about 7 hours] (# [minute/minutes] in Earth time).
        DOCKING_IN_NASHMAU            = 7328, -- We are now docking in Nashmau.
        NEARING_NASHMAU               = 7329, -- We are nearing Nashmau.
        JIDWAHN_SHOP_DIALOG           = 7331, -- Would you care for some items to use on your travels?
        ARRIVING_SOON_NASHMAU         = 7332, -- We are on our way to Nashmau. We will be arriving soon.
    },
    mob =
    {
        PROTEUS = GetFirstID('Proteus'),
    },
    npc =
    {
    },
}

return zones[xi.zone.SILVER_SEA_ROUTE_TO_NASHMAU]
