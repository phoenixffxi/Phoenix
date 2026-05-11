-----------------------------------
-- Area: Navukgo_Execution_Chamber
-----------------------------------
zones = zones or {}

zones[xi.zone.NAVUKGO_EXECUTION_CHAMBER] =
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
        TIME_IN_THE_BATTLEFIELD_IS_UP = 7235, -- Your time in the battlefield is up! Now exiting...
        PARTY_MEMBERS_ARE_ENGAGED     = 7250, -- The battlefield where your party members are engaged in combat is locked. Access is denied.
        NO_BATTLEFIELD_ENTRY          = 7275, -- The door is locked.
        TESTIMONY_IS_TORN             = 7293, -- Your <item> is torn...
        TESTIMONY_WEARS               = 7294, -- Your <item> [/rips into shreds!/is on the verge of tearing apart.../is showing signs of wear...] (# [use remains/uses remain].)
        MEMBERS_OF_YOUR_PARTY         = 7541, -- Currently, # members of your party (including yourself) have clearance to enter the battlefield.
        MEMBERS_OF_YOUR_ALLIANCE      = 7542, -- Currently, # members of your alliance (including yourself) have clearance to enter the battlefield.
        TIME_LIMIT_FOR_THIS_BATTLE_IS = 7544, -- The time limit for this battle is <number> minutes.
        ORB_IS_CRACKED                = 7545, -- There is a crack in the %. It no longer contains a monster.
        A_CRACK_HAS_FORMED            = 7546, -- A crack has formed on the <item>, and the beast inside has been unleashed!
        PARTY_MEMBERS_HAVE_FALLEN     = 7580, -- All party members have fallen in battle. Now leaving the battlefield.
        THE_PARTY_WILL_BE_REMOVED     = 7587, -- If all party members' HP are still zero after # minute[/s], the party will be removed from the battlefield.
        IMPERIAL_ORDER_BREAKS         = 7595, -- The <item> breaks!
        ENTERING_THE_BATTLEFIELD_FOR  = 7608, -- Entering the battlefield for [Tough Nut to Crack/Happy Caster/Omens/Achieving True Power/Shield of Diplomacy/An Imperial Heist]!
        SHAMARHAAN_LET_US_BEGIN       = 7638, -- Let us begin.
        SHAMARHAAN_AUTOMATON_POWER    = 7639, -- Do not underestimate my automaton's power!
        SHAMARHAAN_NOT_READY          = 7640, -- Unfortunately, it looks like you are still not ready yet...
        SHAMARHAAN_MAGNIFICENT        = 7641, -- Magnificent work...
        SHAMARHAAN_GOT_TRICKS         = 7642, -- I've got a few tricks up my own sleeve!
        SHAMARHAAN_LETS_TRY           = 7643, -- Hmm... Let's try this one...
        SHAMARHAAN_FULL_STEAM         = 7644, -- Full steam ahead!
        SHAMARHAAN_ENOUGH             = 7645, -- Enough. I have no desire to watch this foolishness all day.
        SHAMARHAAN_UNDERESTIMATED     = 7646, -- It looks like I underestimated you!
        YOUR_LEVEL_LIMIT_IS_NOW_75    = 7648, -- Your level limit is now 75.
        KARABABA_ENOUGH               = 7653, -- That's quite enough...
        KARABABA_ROUGH                = 7654, -- Time for me to start playing rough!
        KARABARA_FIRE                 = 7655, -- Fuel for the fire! It doesn't pay to invoke my ire!
        KARABARA_ICE                  = 7656, -- Well, if you won't play nice, I'll put your sorry hide on ice!
        KARABARA_WIND                 = 7657, -- This battle is growing stale. How about we have a refreshing gale!
        KARABARA_EARTH                = 7658, -- Sometimes it comes as quite a shock, how much damage you can deal with simple rock!
        KARABARA_LIGHTNING            = 7659, -- How I love to rip things asunder! Witness the power of lightning and thunder!
        KARABARA_WATER                = 7660, -- Water is more dangerous than most expect. Never fear, I'll teach you respect!
        KARABABA_QUIT                 = 7668, -- What a completely useless shield. It's time for me to quit the field.
    },
    mob =
    {
        KHIMAIRA_13   = GetFirstID('Khimaira_13'),
        IMMORTAL_FLAN = GetFirstID('Immortal_Flan'),
        SHAMARHAAN    = GetFirstID('Shamarhaan'),
    },
    npc =
    {
    },
}

return zones[xi.zone.NAVUKGO_EXECUTION_CHAMBER]
