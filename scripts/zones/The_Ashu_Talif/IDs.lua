-----------------------------------
-- Area: The_Ashu_Talif (60)
-----------------------------------
zones = zones or {}

zones[xi.zone.THE_ASHU_TALIF] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385, -- You cannot obtain the <item>. Come back after sorting your inventory.
        FULL_INVENTORY_AFTER_TRADE    = 6389, -- You cannot obtain the <item>. Try trading again after sorting your inventory.
        ITEM_OBTAINED                 = 6393, -- Obtained: <item>.
        GIL_OBTAINED                  = 6394, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396, -- Obtained key item: <keyitem>.
        KEYITEM_LOST                  = 6397, -- Lost key item: <keyitem>.
        NOT_HAVE_ENOUGH_GIL           = 6398, -- You do not have enough gil.
        ITEMS_OBTAINED                = 6402, -- You obtain <number> <item>!
        CARRIED_OVER_POINTS           = 7004, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026, -- Your party is unable to participate because certain members' levels are restricted.
        TIME_TO_COMPLETE              = 7422, -- You have <number> [minute/minutes] (Earth time) to complete this mission.
        MISSION_FAILED                = 7423, -- The mission has failed. Leaving area.
        TIME_REMAINING_MINUTES        = 7427, -- Time remaining: <number> [minute/minutes] (Earth time).
        TIME_REMAINING_SECONDS        = 7428, -- Time remaining: <number> [second/seconds] (Earth time).
        FADES_INTO_NOTHINGNESS        = 7429, -- The <item> fades into nothingness...
        PARTY_FALLEN                  = 7430, -- All party members have fallen in battle. Mission failure in <number> [minute/minutes].
        GOWAM_DEATH                   = 7577, -- Ugh...
        YAZQUHL_CORSAIR_COULD         = 7578, -- Did you really think a corsair could defeat me? Ludicrous.
        YAZQUHL_ENGAGE                = 7579, -- No need for worry, corsairs... You will be a fitting sacrifice for the Empire!
        YAZQUHL_DEATH                 = 7580, -- Defeated...by a corsair...?
        TAKE_THIS                     = 7581, -- Take this!
        REST_BENEATH                  = 7582, -- Time for you to rest beneath the waves!
        STOP_US                       = 7583, -- There's nothing you can do to stop us!
        YOU_WILL_REGRET               = 7584, -- You will regret for eternity the day you turned against the Empire!
        BATTLE_HIGH_SEAS              = 7585, -- A battle on the high seas? My warrior's spirit soars in anticipation!
        TIME_IS_NEAR                  = 7586, -- My time is near...
        SO_I_FALL                     = 7587, -- And so I fall...
        SWIFT_AS_LIGHTNING            = 7588, -- Swift as lightning...!
        HARNESS_THE_WHIRLWIND         = 7589, -- Harness the whirlwind...!
        STING_OF_MY_BLADE             = 7590, -- Feel the sting of my blade!
        UNNATURAL_CURS                = 7591, -- Unnatural curs!
        OVERPOWERED_CREW              = 7592, -- You have overpowered my crew...
        TEST_YOUR_BLADES              = 7593, -- I will test your blades. Prepare to join your ancestors...
        FOR_THE_BLACK_COFFIN          = 7594, -- For the Black Coffin!
        FOR_EPHRAMAD                  = 7595, -- For Ephramad!
        TROUBLESOME_SQUABS            = 7596, -- Troublesome squabs...
    },

    mob =
    {
        GESSHO              = GetFirstID('Gessho'),
        ASHU_CREW_OFFSET    = GetFirstID('Ashu_Talif_Crew_mnk'),
        ASHU_CAPTAIN_OFFSET = GetFirstID('Ashu_Talif_Captain'),
        GOWAM               = GetFirstID('Gowam'),
        YAZQUHL             = GetFirstID('Yazquhl'),
    },

    npc =
    {
    },
}

return zones[xi.zone.THE_ASHU_TALIF]
