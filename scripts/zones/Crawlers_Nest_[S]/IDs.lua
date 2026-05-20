-----------------------------------
-- Area: Crawlers_Nest_[S]
-----------------------------------
zones = zones or {}

zones[xi.zone.CRAWLERS_NEST_S] =
{
    text =
    {
        CAMPAIGN_RESULTS_TALLIED      = 437,  -- Campaign results tallied.
        ITEM_CANNOT_BE_OBTAINED       = 6907, -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6915, -- Obtained: <item>.
        GIL_OBTAINED                  = 6916, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6918, -- Obtained key item: <keyitem>.
        CARRIED_OVER_POINTS           = 7526, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7527, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7528, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7548, -- Your party is unable to participate because certain members' levels are restricted.
        ITEM_DELIVERY_DIALOG          = 7699, -- Hello! Any packages to sendy-wend?
        COMMON_SENSE_SURVIVAL         = 8664, -- It appears that you have arrived at a new survival guide provided by the Servicemen's Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        MORILLE_MORTELLE = GetFirstID('Morille_Mortelle'),
    },
    npc =
    {
        CAMPAIGN_NPC_OFFSET = GetFirstID('Chefroucauld_TK') -- San, Bas, Win, Flag +4, CA
    },
}

return zones[xi.zone.CRAWLERS_NEST_S]
