-----------------------------------
-- Area: Lower_Jeuno
-----------------------------------
zones = zones or {}

zones[xi.zone.LOWER_JEUNO] =
{
    text =
    {
        ASSIST_CHANNEL                = 6380,  -- You will be able to use the Assist Channel until #/#/# at #:# (JST).
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        KEYITEM_LOST                  = 6397,  -- Lost key item: <keyitem>.
        NOT_HAVE_ENOUGH_GIL           = 6398,  -- You do not have enough gil.
        YOU_MUST_WAIT_ANOTHER_N_DAYS  = 6429,  -- You must wait another <number> [day/days] to perform that action.
        CARRIED_OVER_POINTS           = 6432,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 6433,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 6434,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 6454,  -- Your party is unable to participate because certain members' levels are restricted.
        HOMEPOINT_SET                 = 6539,  -- Home point set!
        CONQUEST_BASE                 = 6564,  -- Tallying conquest results...
        MOG_LOCKER_OFFSET             = 6833,  -- Your Mog Locker lease is valid until <timestamp>, kupo.
        FISHING_MESSAGE_OFFSET        = 6948,  -- You can't fish here.
        MYTHIC_LEARNED                = 7155,  -- You have learned the weapon skill [Nothing/King's Justice/Ascetic's Fury/Mystic Boon/Vidohunir/Death Blossom/Mandalic Stab/Atonement/Insurgency/Primal Rend/Mordant Rime/Trueflight/Tachi: Rana/Blade: Kamu/Drakesbane/Garland of Bliss/Expiacion/Leaden Salute/Stringing Pummel/Pyrrhic Kleos/Omniscience]!
        JUNK_SHOP_DIALOG              = 7156,  -- Hey, how ya doin'? We got the best junk in town.
        WAAG_DEEG_SHOP_DIALOG         = 7157,  -- Welcome to Waag-Deeg's Magic Shop.
        ORTHONS_GARMENT_SHOP_DIALOG   = 7158,  -- Welcome to Othon's Garments.
        YOSKOLO_SHOP_DIALOG           = 7159,  -- Welcome to the Merry Minstrel's Meadhouse. What'll it be?
        GEMS_BY_KSHAMA_SHOP_DIALOG    = 7160,  -- Here at Gems by Kshama, we aim to please.
        RHIMONNE_SHOP_DIALOG          = 7163,  -- Howdy! Thanks for visiting the Chocobo Shop!
        GUIDE_STONE                   = 7165,  -- Up: Upper Jeuno (facing San d'Oria) Down: Port Jeuno (facing Windurst)
        ALDO_DIALOG                   = 7170,  -- Hi. I'm Aldo, head of Tenshodo. We deal in things you can't buy anywhere else. Take your time and have a look around.
        YOU_RETURN_THE                = 7251,  -- You return the <keyitem>.
        THE_LAMPS_WERE_LIT_BY         = 7269,  -- The lamps were lit by <player> today. If you happen to run across the person who took time out to bring light to our city, don't forget to say a word of thanks.
        VHANA_DEFAULT                 = 7270,  -- Sorry. I'm busy.
        YOU_LIGHT_THE_LAMP            = 7273,  -- You light the lamp.
        LAMP_MSG_OFFSET               = 7274,  -- All the lamps are lit.
        ZAUKO_IS_RECRUITING           = 7282,  -- Zauko is recruiting an adventurer to light the lamps.
        CHOCOBO_DIALOG                = 7344,  -- Hmph.
        LOVE_ROMANCE                  = 7424,  -- Love... Romance... It's all fake! Cursed women are like measles!
        MERTAIRE_MALLIEBELL_LEFT      = 7425,  -- Ugh... Malliebell... This time she's left me forever...
        MERTAIRE_DEFAULT              = 7450,  -- Who are you? Leave me alone!
        COULD_HE_BE                   = 7460,  -- Wait, could he be...? Naw, he couldn't be.
        ITS_LOCKED                    = 7612,  -- It's locked.
        PAWKRIX_SHOP_DIALOG           = 7660,  -- Hey, we're fixin' up some stew. Gobbie food's good food!
        PACKAGE_DELIVERED             = 7698,  -- You have completed your delivery of the <keyitem>.
        DAMANGED_PACKAGE_DELIVERED    = 7699,  -- Due to extensive damage, the <keyitem> are thrown away.
        AMALASANDA_SHOP_DIALOG        = 7708,  -- Welcome to the Tenshodo. You want something, we got it. We got all kinds of special merchandise you won't find anywhere else!
        AKAMAFULA_SHOP_DIALOG         = 7709,  -- We ain't cheap, but you get what you pay for! Take your time, have a look around, see if there's somethin' you like.
        DO_NOT_DISTURB                = 7765,  -- Do Not Disturb
        INVENTORY_INCREASED           = 7807,  -- Your inventory capacity has increased.
        ITEM_DELIVERY_DIALOG          = 7808,  -- Now offering quick and easy delivery of packages to residences everywhere!
        YIN_POCANAKHU_GET_LOST        = 8021,  -- Hey, what are you tryin' to pull? Get lost!
        MERTAIRE_RING                 = 8069,  -- So, what did you do with that ring? Maybe it's valuable. I'd ask a collector if I were you. Of course, he might just say it's worthless...
        CONQUEST                      = 8081,  -- You've earned conquest points!
        PARIKE_PORANKE_DIALOG         = 8979,  -- All these people running back and forth... There have to be a few that have munched down more mithkabobs than they can manage. (And if I don't hand in this report to the Orastery soon... Ulp!)
        PARIKE_PORANKE_1              = 8980,  -- Hey you! Belly bursting? Intestines inflating? Bladder bulging? I can tell by the notch on your belt that you've been overindulging yourself in culinary delights.
        PARIKE_PORANKE_2              = 8983,  -- I mean, this is a new era. If somebody wants to go around with their flabby-flubber hanging out of their cloaks, they should have every right to do so. If someone wants to walk around town with breath reeking of Kazham pines and roasted sleepshrooms, who am I to stop them?
        PARIKE_PORANKE_3              = 8984,  -- What? You want me to tend to your tummy trouble? No problem! And don't worry, this won't hurt at all! I'm only going to be flushing your bowels with thousands of tiny lightning bolts. It's all perfectly safe!
        PARIKE_PORANKE_4              = 8985,  -- Now stand still! You wouldn't want your pelvis to implode, would you? (Let's see... What were those magic words again...?)
        PARIKE_PORANKE_5              = 8986,  -- Ready? No? Well, too bad!
        PARIKE_PORANKE_6              = 8994,  -- <name>'s digestive magic skill rises 0.1 points.
        PARIKE_PORANKE_7              = 8995,  -- <name>'s digestive magic skill rises one level.
        PARIKE_PORANKE_8              = 8996,  -- Heh heh! I think I'm starting to get the hang of this spellcasting.
        PARIKE_PORANKE_9              = 8997,  -- Consider this a petite present from your pal Parike-Poranke!
        PARIKE_PORANKE_10             = 9001,  -- Wait a minute... Don't tell me you came to Parike-Poranke on an empty stomach! This is terrible! The minister will have my head!
        PARIKE_PORANKE_12             = 9003,  -- Phew! That was close... What were you thinking, crazy adventurer!?
        PARIKE_PORANKE_13             = 9006,  -- <name>'s all in the name of science skill rises 0.1 points.
        PARIKE_PORANKE_14             = 9007,  -- <name>'s all in the name of science skill rises one level.
        PARIKE_PORANKE_15             = 9008,  -- You know, I've learned a lot from my mist--er, I mean, less-than-successful attempts at weight-loss consulting.
        PARIKE_PORANKE_16             = 9009,  -- To show you my gratitude, let me try out this new spell I thought up yesterday while I was taking a nap!
        NO_KEY                        = 9931,  -- You do not have a usable key in your possession.
        RETRIEVE_DIALOG_ID            = 10211, -- You retrieve <item> from the porter moogle's care.
        WAYPOINT_EXAMINE              = 10372, -- An enigmatic contrivance hovers in silence...
        EXPENDED_KINETIC_UNITS        = 10375, -- You have expended <number> kinetic unit[/s] and will be transported to another locale.
        INSUFFICIENT_UNITS            = 10376, -- Your stock of kinetic units is insufficient.
        REACHED_KINETIC_UNIT_LIMIT    = 10377, -- You have reached your limit of kinetic units and cannot charge your artifact any further.
        CANNOT_RECEIVE_KINETIC        = 10378, -- There is no response. You apparently cannot receive kinetic units from this item.
        ARTIFACT_HAS_BEEN_CHARGED     = 10379, -- Your artifact has been charged with <number> kinetic unit[/s]. Your current stock of kinetic units totals <number>.
        ARTIFACT_TERMINAL_VOLUME      = 10380, -- Your artifact has been charged to its terminal volume of kinetic units.
        SURPLUS_LOST_TO_AETHER        = 10381, -- A surplus of <number> kinetic unit[/s] has been lost to the aether.
    },
    mob =
    {
    },
    npc =
    {
        VHANA_EHGAKLYWHA  = GetFirstID('Vhana_Ehgaklywha'),
        STREETLAMP_OFFSET = GetFirstID('_l00'),
        ZAUKO             = GetFirstID('Zauko'),
    },
}

return zones[xi.zone.LOWER_JEUNO]
