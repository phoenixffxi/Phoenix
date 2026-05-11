-----------------------------------
-- Area: Meriphataud_Mountains
-----------------------------------
zones = zones or {}

zones[xi.zone.MERIPHATAUD_MOUNTAINS] =
{
    text =
    {
        NOTHING_HAPPENS               = 141,   -- Nothing happens...
        ITEM_CANNOT_BE_OBTAINED       = 6407,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6415,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6416,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6418,  -- Obtained key item: <keyitem>.
        KEYITEM_LOST                  = 6419,  -- Lost key item: <keyitem>.
        FELLOW_MESSAGE_OFFSET         = 6444,  -- I'm ready. I suppose.
        CARRIED_OVER_POINTS           = 7026,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7027,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7028,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7048,  -- Your party is unable to participate because certain members' levels are restricted.
        CONQUEST_BASE                 = 7093,  -- Tallying conquest results...
        BEASTMEN_BANNER               = 7174,  -- There is a beastmen's banner.
        FISHING_MESSAGE_OFFSET        = 7252,  -- You can't fish here.
        DIG_THROW_AWAY                = 7265,  -- You dig up <item>, but your inventory is full. You regretfully throw the <item> away.
        FIND_NOTHING                  = 7267,  -- You dig and you dig, but find nothing.
        AMK_DIGGING_OFFSET            = 7333,  -- You spot some familiar footprints. You are convinced that your moogle friend has been digging in the immediate vicinity.
        FOUND_ITEM_WITH_EASE          = 7342,  -- It appears your chocobo found this item with ease.
        NOTHING_FOUND                 = 7511,  -- You find nothing.
        CONQUEST                      = 7923,  -- You've earned conquest points!
        ITEMS_ITEMS_LA_LA             = 8297,  -- You can hear a strange voice... Items, items, la la la la la
        GOBLIN_SLIPPED_AWAY           = 8303,  -- The Goblin slipped away when you were not looking...
        GARRISON_BASE                 = 8313,  -- Hm? What is this? %? How do I know this is not some [San d'Orian/Bastokan/Windurstian] trick?
        PLAYER_OBTAINS_ITEM           = 8360,  -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 8361,  -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 8362,  -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 8363,  -- You already possess that temporary item.
        NO_COMBINATION                = 8368,  -- You were unable to enter a combination.
        VOIDWALKER_DESPAWN            = 8399,  -- The monster fades before your eyes, a look of disappointment on its face.
        UNITY_WANTED_BATTLE_INTERACT  = 8430,  -- Those who have accepted % must pay # Unity accolades to participate. The content for this Wanted battle is #. [Ready to begin?/You do not have the appropriate object set, so your rewards will be limited.]
        TIME_ELAPSED                  = 8508,  -- Time elapsed: <number> [hour/hours] (Vana'diel time) <number> [minute/minutes] and <number> [second/seconds] (Earth time)
        REGIME_REGISTERED             = 10608, -- New training regime registered!
        VOIDWALKER_NO_MOB             = 11727, -- The <keyitem> quivers ever so slightly, but emits no light. There seem to be no monsters in the area.
        VOIDWALKER_MOB_TOO_FAR        = 11728, -- The <keyitem> quivers ever so slightly and emits a faint light. There seem to be no monsters in the immediate vicinity.
        VOIDWALKER_MOB_HINT           = 11729, -- The <keyitem> resonates [feebly/softly/solidly/strongly/very strongly/furiously], sending a radiant beam of light lancing towards a spot roughly <number> [yalm/yalms] [east/southeast/south/southwest/west/northwest/north/northeast] of here.
        VOIDWALKER_SPAWN_MOB          = 11730, -- A monster materializes out of nowhere!
        VOIDWALKER_UPGRADE_KI_1       = 11732, -- The <keyitem> takes on a slightly deeper hue and becomes <keyitem>!
        VOIDWALKER_UPGRADE_KI_2       = 11733, -- The <keyitem> takes on a deeper, richer hue and becomes <keyitem>!
        VOIDWALKER_BREAK_KI           = 11734, -- The <keyitem> shatters into tiny fragments.
        VOIDWALKER_OBTAIN_KI          = 11735, -- Obtained key item: <keyitem>!
        COMMON_SENSE_SURVIVAL         = 12637, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },

    mob =
    {
        NAA_ZEKU_THE_UNWAITING = GetFirstID('Naa_Zeku_the_Unwaiting'),
        PATRIPATAN             = GetFirstID('Patripatan'),
        DAGGERCLAW_DRACOS      = GetFirstID('Daggerclaw_Dracos'),
        WARAXE_BEAK            = GetFirstID('Waraxe_Beak'),
        COO_KEJA_THE_UNSEEN    = GetFirstID('Coo_Keja_the_Unseen'),

        VOIDWALKER =
        {
            [xi.keyItem.CLEAR_ABYSSITE] =
            {
                17265129, -- Raker bee
                17265128, -- Raker bee
                17265127, -- Raker bee
                17265126, -- Raker bee
                17265125, -- Rummager beetle
                17265124, -- Rummager beetle
                17265123, -- Rummager beetle
                17265122, -- Rummager beetle
            },

            [xi.keyItem.COLORFUL_ABYSSITE] =
            {
                17265121, -- Jyeshtha
                17265120, -- Farruca Fly
            },

            [xi.keyItem.BROWN_ABYSSITE] =
            {
                17265119, -- Orcus
            },

            [xi.keyItem.BLACK_ABYSSITE] =
            {
                17265118, -- Yilbegan
            }
        }
    },

    npc =
    {
        OVERSEER_BASE = GetFirstID('Chegourt_RK'),
    },
}

return zones[xi.zone.MERIPHATAUD_MOUNTAINS]
