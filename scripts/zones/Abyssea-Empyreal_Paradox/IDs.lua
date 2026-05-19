-----------------------------------
-- Area: Abyssea-Empyreal_Paradox
-----------------------------------
zones = zones or {}

zones[xi.zone.ABYSSEA_EMPYREAL_PARADOX] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385, -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393, -- Obtained: <item>.
        GIL_OBTAINED                  = 6394, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396, -- Obtained key item: <keyitem>.
        CRUOR_TOTAL                   = 6991, -- Obtained <number> cruor. (Total: <number>)
        CARRIED_OVER_POINTS           = 7004, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026, -- Your party is unable to participate because certain members' levels are restricted.
        CRUOR_OBTAINED                = 7417, -- <name> obtained <number> cruor.
        TIME_IN_THE_BATTLEFIELD_IS_UP = 7722, -- Your time in the battlefield is up! Now exiting...
        PARTY_MEMBERS_ARE_ENGAGED     = 7737, -- The battlefield where your party members are engaged in combat is locked. Access is denied.
        MEMBERS_OF_YOUR_PARTY         = 8028, -- Currently, # members of your party (including yourself) have clearance to enter the battlefield.
        MEMBERS_OF_YOUR_ALLIANCE      = 8029, -- Currently, # members of your alliance (including yourself) have clearance to enter the battlefield.
        TIME_LIMIT_FOR_THIS_BATTLE_IS = 8031, -- The time limit for this battle is <number> minutes.
        PARTY_MEMBERS_HAVE_FALLEN     = 8067, -- All party members have fallen in battle. Now leaving the battlefield.
        THE_PARTY_WILL_BE_REMOVED     = 8074, -- If all party members' HP are still zero after # minute[/s], the party will be removed from the battlefield.
        CRIMSON_STONE_DISAPPEARS      = 8082, -- The <keyitem> disappears!
        ENTERING_THE_BATTLEFIELD_FOR  = 8094, -- Entering the battlefield for [The Wyrm God/★The Wyrm God/]!
    },
    mob =
    {
    },
    npc =
    {
    },
}

return zones[xi.zone.ABYSSEA_EMPYREAL_PARADOX]
