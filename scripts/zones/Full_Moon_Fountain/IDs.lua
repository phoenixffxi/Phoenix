-----------------------------------
-- Area: Full_Moon_Fountain
-----------------------------------
zones = zones or {}

zones[xi.zone.FULL_MOON_FOUNTAIN] =
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
        TIME_IN_THE_BATTLEFIELD_IS_UP = 7331, -- Your time in the battlefield is up! Now exiting...
        PARTY_MEMBERS_ARE_ENGAGED     = 7346, -- The battlefield where your party members are engaged in combat is locked. Access is denied.
        NO_BATTLEFIELD_ENTRY          = 7353, -- A strong magical force is whirling up from the platform.
        UNABLE_TO_PROTECT             = 7388, -- You were unable to protect Ajido-Marujido. Now leaving the battlefield.
        MEMBERS_OF_YOUR_PARTY         = 7637, -- Currently, # members of your party (including yourself) have clearance to enter the battlefield.
        MEMBERS_OF_YOUR_ALLIANCE      = 7638, -- Currently, # members of your alliance (including yourself) have clearance to enter the battlefield.
        TIME_LIMIT_FOR_THIS_BATTLE_IS = 7640, -- The time limit for this battle is <number> minutes.
        PARTY_MEMBERS_HAVE_FALLEN     = 7676, -- All party members have fallen in battle. Now leaving the battlefield.
        THE_PARTY_WILL_BE_REMOVED     = 7683, -- If all party members' HP are still zero after # minute[/s], the party will be removed from the battlefield.
        ENTERING_THE_BATTLEFIELD_FOR  = 7774, -- Entering the battlefield for [The Moonlit Path/Moon Reading/Waking the Beast/Battaru Royale/★The Moonlit Path/★Waking the Beast]!
        PLAY_TIME_IS_OVER             = 7776, -- Play time is over! Powers of dark mana, answer my call!
        YOU_SHOULD_BE_THANKFUL        = 7777, -- You should be thankful. I'll give you a shortaru trip back to the hell you came from!
        DONT_GIVE_UP                  = 7778, -- Don't give up, adventurer! You are Windurst's guiding star, our beacon of hope!
        LEAVE_THE_AFFAIRS_OF_GODS_TO  = 7836, -- Leave the affairs of gods to gods, mortal. If you choose to stay, then be prepared to face our wrath!
        FALSE_GODS                    = 7837, -- False gods... They are the ones...who have...betrayed you...
        WARPED_LOGIC                  = 7838, -- Warped logic... This is what...has truly...divided you...
        TAINTED_JUSTICE               = 7839, -- Tainted justice... This is what...has truly...destroyed you...
        BASELESS_TIES                 = 7840, -- Baseless ties... These are what...have truly...cursed you...
        CORRUPTED_POWER               = 7841, -- Corrupted power... This is what...has truly misled you...
        DECEPTIVE_APPEARANCES         = 7842, -- Deceptive appearances... These are what...have truly been...your downfall...
    },
    mob =
    {
        FENRIR_PRIME    = GetFirstID('Fenrir_Prime'),
        CARBUNCLE_PRIME = GetFirstID('Carbuncle_Prime'),
        ACE_OF_CUPS     = GetFirstID('Ace_of_Cups'),
    },
    npc =
    {
    },
}

return zones[xi.zone.FULL_MOON_FOUNTAIN]
