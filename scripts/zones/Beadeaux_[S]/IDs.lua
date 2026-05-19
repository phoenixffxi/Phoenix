-----------------------------------
-- Area: Beadeaux_[S]
-----------------------------------
zones = zones or {}

zones[xi.zone.BEADEAUX_S] =
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
        CAMPAIGN_RESULTS_TALLIED      = 7508, -- Campaign results tallied.
        PARTY_MEMBERS_HAVE_FALLEN     = 7943, -- All party members have fallen in battle. Now leaving the battlefield.
        THE_PARTY_WILL_BE_REMOVED     = 7950, -- If all party members' HP are still zero after # minute[/s], the party will be removed from the battlefield.
    },
    mob =
    {
        BATHO_MERCIFULHEART = GetFirstID('BaTho_Mercifulheart'),
        DA_DHA_HUNDREDMASK  = GetFirstID('DaDha_Hundredmask'),
        EATHO_CRUELHEART    = GetFirstID('EaTho_Cruelheart'),
    },
    npc =
    {
        CAMPAIGN_NPC_OFFSET = GetFirstID('Rouquillot_TK'), -- San, Bas, Win, Flag +4, CA
    },
}

return zones[xi.zone.BEADEAUX_S]
