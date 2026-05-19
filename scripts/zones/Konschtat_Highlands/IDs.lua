-----------------------------------
-- Area: Konschtat_Highlands
-----------------------------------
zones = zones or {}

zones[xi.zone.KONSCHTAT_HIGHLANDS] =
{
    text =
    {
        NOTHING_HAPPENS               = 119,   -- Nothing happens...
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY       = 6407,  -- There is nothing out of the ordinary here.
        FELLOW_MESSAGE_OFFSET         = 6422,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7004,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026,  -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7071,  -- Tallying conquest results...
        ALREADY_OBTAINED_TELE         = 7230,  -- You already possess the gate crystal for this telepoint.
        DIG_THROW_AWAY                = 7247,  -- You dig up <item>, but your inventory is full. You regretfully throw the <item> away.
        FIND_NOTHING                  = 7249,  -- You dig and you dig, but find nothing.
        AMK_DIGGING_OFFSET            = 7315,  -- You spot some familiar footprints. You are convinced that your moogle friend has been digging in the immediate vicinity.
        FOUND_ITEM_WITH_EASE          = 7324,  -- It appears your chocobo found this item with ease.
        SIGNPOST3                     = 7406,  -- North: Valkurm Dunes South: North Gustaberg East: Gusgen Mines, Pashhow Marshlands
        SIGNPOST2                     = 7407,  -- North: Pashhow Marshlands West: Valkurm Dunes, North Gustaberg Southeast: Gusgen Mines
        SIGNPOST_DIALOG_1             = 7408,  -- North: Valkurm Dunes South: To Gustaberg
        SIGNPOST_DIALOG_2             = 7409,  -- You see something stuck behind the signpost.
        SOMETHING_BURIED_HERE         = 7410,  -- Something has been buried here.
        BLACKENED_SPOT_ON_GROUND      = 7459,  -- There is a blackened spot on the ground...
        BLACKENED_SHOULD_PLACE        = 7460,  -- This is the blackened spot you were told about. You should place <item> here.
        PLACE_BLACKENED_SPOT          = 7461,  -- You place <item> on the blackened spot.
        BLACKENED_NOTHING_HAPPENS     = 7462,  -- You place <item> on the blackened spot, but nothing happens.
        BLACKENED_MUST_BE_CLOSER      = 7463,  -- You have to be closer to place anything on the blackened spot.
        NOT_THE_TIME_FOR_THAT         = 7472,  -- This is not the time for that!
        TELEPOINT_HAS_BEEN_SHATTERED  = 7499,  -- The telepoint has been shattered into a thousand pieces...
        TIME_ELAPSED                  = 7555,  -- Time elapsed: <number> [hour/hours] (Vana'diel time) <number> [minute/minutes] and <number> [second/seconds] (Earth time)
        MEMORIES_SEALED_OFF           = 7612,  -- A portion of your memories has been sealed off.
        PLAYER_OBTAINS_ITEM           = 7617,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 7618,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 7619,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 7620,  -- You already possess that temporary item.
        NO_COMBINATION                = 7625,  -- You were unable to enter a combination.
        VOIDWALKER_DESPAWN            = 7656,  -- The monster fades before your eyes, a look of disappointment on its face.
        UNITY_WANTED_BATTLE_INTERACT  = 7687,  -- Those who have accepted % must pay # Unity accolades to participate. The content for this Wanted battle is #. [Ready to begin?/You do not have the appropriate object set, so your rewards will be limited.]
        REGIME_REGISTERED             = 9803,  -- New training regime registered!
        VOIDWALKER_NO_MOB             = 10976, -- The <keyitem> quivers ever so slightly, but emits no light. There seem to be no monsters in the area.
        VOIDWALKER_MOB_TOO_FAR        = 10977, -- The <keyitem> quivers ever so slightly and emits a faint light. There seem to be no monsters in the immediate vicinity.
        VOIDWALKER_MOB_HINT           = 10978, -- The <keyitem> resonates [feebly/softly/solidly/strongly/very strongly/furiously], sending a radiant beam of light lancing towards a spot roughly <number> [yalm/yalms] [east/southeast/south/southwest/west/northwest/north/northeast] of here.
        VOIDWALKER_SPAWN_MOB          = 10979, -- A monster materializes out of nowhere!
        VOIDWALKER_UPGRADE_KI_1       = 10981, -- The <keyitem> takes on a slightly deeper hue and becomes <keyitem>!
        VOIDWALKER_UPGRADE_KI_2       = 10982, -- The <keyitem> takes on a deeper, richer hue and becomes <keyitem>!
        VOIDWALKER_BREAK_KI           = 10983, -- The <keyitem> shatters into tiny fragments.
        VOIDWALKER_OBTAIN_KI          = 10984, -- Obtained key item: <keyitem>!
        LEARNS_SPELL                  = 11920, -- <name> learns <spell>!
        UNCANNY_SENSATION             = 11922, -- You are assaulted by an uncanny sensation.
        COMMON_SENSE_SURVIVAL         = 11929, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
        STRAY_MARY     = GetTableOfIDs('Stray_Mary'), -- 2 NMs
        RAMPAGING_RAM  = GetFirstID('Rampaging_Ram'),
        STEELFLEECE    = GetFirstID('Steelfleece_Baldarich'),
        TREMOR_RAM     = GetTableOfIDs('Tremor_Ram'),
        FORGER         = GetFirstID('Forger'),
        HATY           = GetFirstID('Haty'),
        BENDIGEIT_VRAN = GetFirstID('Bendigeit_Vran'),

        VOIDWALKER =
        {
            [xi.keyItem.CLEAR_ABYSSITE] =
            {
                17220019, -- Prickly Sheep
                17220018, -- Prickly Sheep
                17220017, -- Prickly Sheep
                17220016, -- Prickly Sheep
                17220015,  -- Void Hare
                17220014,  -- Void Hare
                17220013,  -- Void Hare
                17220012,  -- Void Hare
            },

            [xi.keyItem.COLORFUL_ABYSSITE] =
            {
                17220011,  -- Chesma
                17220010, -- Tammuz
            },

            [xi.keyItem.GREY_ABYSSITE] =
            {
                17220009, -- Dawon
            },

            [xi.keyItem.BLACK_ABYSSITE] =
            {
                17220008, -- Yilbegan
            }
        }
    },

    npc =
    {
    },
}

return zones[xi.zone.KONSCHTAT_HIGHLANDS]
