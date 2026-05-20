-----------------------------------
-- Area: Spire_of_Holla
-----------------------------------
zones = zones or {}

zones[xi.zone.SPIRE_OF_HOLLA] =
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
        TIME_IN_THE_BATTLEFIELD_IS_UP = 7076, -- Your time in the battlefield is up! Now exiting...
        PARTY_MEMBERS_ARE_ENGAGED     = 7091, -- The battlefield where your party members are engaged in combat is locked. Access is denied.
        NO_BATTLEFIELD_ENTRY          = 7103, -- You can hear a faint scraping sound from within, but the way is barred by some strange membrane...
        MEMBERS_OF_YOUR_PARTY         = 7382, -- Currently, # members of your party (including yourself) have clearance to enter the battlefield.
        MEMBERS_OF_YOUR_ALLIANCE      = 7383, -- Currently, # members of your alliance (including yourself) have clearance to enter the battlefield.
        TIME_LIMIT_FOR_THIS_BATTLE_IS = 7385, -- The time limit for this battle is <number> minutes.
        ORB_IS_CRACKED                = 7386, -- There is a crack in the %. It no longer contains a monster.
        A_CRACK_HAS_FORMED            = 7387, -- A crack has formed on the <item>, and the beast inside has been unleashed!
        PARTY_MEMBERS_HAVE_FALLEN     = 7421, -- All party members have fallen in battle. Now leaving the battlefield.
        THE_PARTY_WILL_BE_REMOVED     = 7428, -- If all party members' HP are still zero after # minute[/s], the party will be removed from the battlefield.
        FADES_INTO_NOTHINGNESS        = 7436, -- The % fades into nothingness...
        ENTERING_THE_BATTLEFIELD_FOR  = 7627, -- Entering the battlefield for [Ancient Flames Beckon/Simulant/Empty Hopes]!
        CANT_REMEMBER                 = 7657, -- You cannot remember when exactly, but you have obtained <item>!
    },
    mob =
    {
        WREAKER   = GetFirstID('Wreaker'),
        COGITATOR = GetFirstID('Cogitator'),
    },
    npc =
    {
    },
}

return zones[xi.zone.SPIRE_OF_HOLLA]
