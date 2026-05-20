-----------------------------------
-- Area: Eastern Adoulin (257)
-----------------------------------
zones = zones or {}

zones[xi.zone.EASTERN_ADOULIN] =
{
    text =
    {
        ASSIST_CHANNEL                = 6380,  -- You will be able to use the Assist Channel until #/#/# at #:# (JST).
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        LOST_KEYITEM                  = 6397,  -- Lost key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY       = 6407,  -- There is nothing out of the ordinary here.
        CARRIED_OVER_POINTS           = 7004,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        BAYLD_OBTAINED                = 7010,  -- You have obtained <number> bayld!
        NOT_ENOUGH_BAYLD              = 7012,  -- You do not have enough bayld!
        YOU_CAN_NOW_BECOME            = 7014,  -- You can now become a [geomancer/rune fencer]!
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026,  -- Your party is unable to participate because certain members' levels are restricted.
        YOU_LEARNED_TRUST             = 7028,  -- You learned Trust: <name>!
        MOG_LOCKER_OFFSET             = 7597,  -- Your Mog Locker lease is valid until <timestamp>, kupo.
        WAYPOINT_ATTUNED              = 7798,  -- Your <keyitem> has been attuned to a geomagnetic fount[/ in front of the Peacekeepers' Coalition/ in front of the Scouts' Coalition/ at the Statue of the Goddess/ at the wharf to Yahse Hunting Grounds/ in front of your Rent-a-Room/ in front of the auction house/ on Sverdhried Hillock/ in the Coronal Esplanade/ at the gates of Castle Adoulin]!
        EXPENDED_KINETIC_UNITS        = 7817,  -- You have expended <number> kinetic unit[/s] and will be transported to another locale.
        INSUFFICIENT_UNITS            = 7818,  -- Your stock of kinetic units is insufficient.
        REACHED_KINETIC_UNIT_LIMIT    = 7819,  -- You have reached your limit of kinetic units and cannot charge your artifact any further.
        CANNOT_RECEIVE_KINETIC        = 7820,  -- There is no response. You apparently cannot receive kinetic units from this item.
        ARTIFACT_HAS_BEEN_CHARGED     = 7821,  -- Your artifact has been charged with <number> kinetic unit[/s]. Your current stock of kinetic units totals <number>.
        ARTIFACT_TERMINAL_VOLUME      = 7822,  -- Your artifact has been charged to its terminal volume of kinetic units.
        SURPLUS_LOST_TO_AETHER        = 7823,  -- A surplus of <number> kinetic unit[/s] has been lost to the aether.
        HOMEPOINT_SET                 = 8313,  -- Home point set!
        COMMON_SENSE_SURVIVAL         = 13900, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
    },
    npc =
    {
    },
}

return zones[xi.zone.EASTERN_ADOULIN]
