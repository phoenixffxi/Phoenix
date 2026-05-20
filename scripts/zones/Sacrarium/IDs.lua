-----------------------------------
-- Area: Sacrarium
-----------------------------------
zones = zones or {}

zones[xi.zone.SACRARIUM] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385, -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393, -- Obtained: <item>.
        GIL_OBTAINED                  = 6394, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396, -- Obtained key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY       = 6407, -- There is nothing out of the ordinary here.
        CARRIED_OVER_POINTS           = 7004, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026, -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7071, -- Tallying conquest results...
        CANNOT_BE_OPENED              = 7234, -- The door cannot be opened...
        LARGE_KEYHOLE_DESCRIPTION     = 7237, -- The gate is securely closed with two locks. This keyhole is engraved with a sealion insignia.
        SMALL_KEYHOLE_DESCRIPTION     = 7238, -- The gate is securely closed with two locks. This keyhole is engraved with a coral insignia.
        KEYHOLE_DAMAGED               = 7239, -- The keyhole is damaged. The gate cannot be opened from this side.
        CANNOT_OPEN_SIDE              = 7240, -- The gate cannot be opened from this side.
        CANNOT_TRADE_NOW              = 7241, -- You cannot trade right now.
        STURDY_GATE                   = 7242, -- A sturdy iron gate. It is secured with two locks--a main lock and a sublock.
        CORAL_KEY_BREAKS              = 7246, -- The <item> breaks!
        EVIL_PRESENCE                 = 7280, -- You sense an evil presence!
        DRAWER_OPEN                   = 7281, -- You open the drawer.
        DRAWER_EMPTY                  = 7282, -- There is nothing inside.
        DRAWER_SHUT                   = 7283, -- The drawer is jammed shut.
        CHEST_UNLOCKED                = 7372, -- You unlock the chest!
        MUSTY_OLD_MANUSCRIPTS         = 7380, -- There is nothing here but a handful of musty old manuscripts.
        START_GET_GOOSEBUMPS          = 7382, -- You start to get goosebumps.
        HEART_RACING                  = 7383, -- Your heart is racing.
        LEAVE_QUICKLY_AS_POSSIBLE     = 7384, -- Your common sense tells you to leave as quickly as possible.
        NOTHING_HAPPENS               = 7387, -- Nothing happens.
        COMMON_SENSE_SURVIVAL         = 7391, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        ELEL                    = GetFirstID('Elel'),
        FOMOR_BARD              = GetTableOfIDs('Fomor_Bard'),
        FOMOR_BLACK_MAGE        = GetTableOfIDs('Fomor_Black_Mage'),
        FOMOR_DARK_KNIGHT       = GetTableOfIDs('Fomor_Dark_Knight'),
        FOMOR_DRAGOON           = GetTableOfIDs('Fomor_Dragoon'),
        FOMOR_MONK              = GetTableOfIDs('Fomor_Monk'),
        FOMOR_NINJA             = GetTableOfIDs('Fomor_Ninja'),
        FOMOR_RANGER            = GetTableOfIDs('Fomor_Ranger'),
        FOMOR_RED_MAGE          = GetTableOfIDs('Fomor_Red_Mage'),
        FOMOR_SAMURAI           = GetTableOfIDs('Fomor_Samurai'),
        FOMOR_WARRIOR           = GetTableOfIDs('Fomor_Warrior'),
        OLD_PROFESSOR_MARISELLE = GetFirstID('Old_Professor_Mariselle'),
        SWIFT_BELT_NM_OFFSET    = GetFirstID('Balor'),
    },
    npc =
    {
        LABYRINTH_OFFSET      = GetFirstID('_0sb'),
        QM_MARISELLE_OFFSET   = GetFirstID('qm_prof_0'),
        QM_TAVNAZIAN_COOKBOOK = GetFirstID('qm_tavnazian_cookbook'),
        SMALL_KEYHOLE         = GetFirstID('Small_Keyhole'),
        STALE_DRAFT_OFFSET    = GetFirstID('Stale_Draft'),
        TREASURE_CHEST        = GetFirstID('Treasure_Chest'),
    },
}

return zones[xi.zone.SACRARIUM]
