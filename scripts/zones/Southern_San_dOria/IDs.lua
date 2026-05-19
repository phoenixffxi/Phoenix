-----------------------------------
-- Area: Southern_San_dOria
-----------------------------------
zones = zones or {}

zones[xi.zone.SOUTHERN_SAN_DORIA] =
{
    text =
    {
        HOMEPOINT_SET                  = 24,    -- Home point set!
        ASSIST_CHANNEL                 = 6424,  -- You will be able to use the Assist Channel until #/#/# at #:# (JST).
        ITEM_CANNOT_BE_OBTAINED        = 6429,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        CANNOT_OBTAIN_THE_ITEM         = 6431,  -- You cannot obtain the item. Come back after sorting your inventory.
        FULL_INVENTORY_AFTER_TRADE     = 6433,  -- You cannot obtain the <item>. Try trading again after sorting your inventory.
        ITEM_OBTAINED                  = 6437,  -- Obtained: <item>.
        GIL_OBTAINED                   = 6438,  -- Obtained <number> gil.
        KEYITEM_OBTAINED               = 6440,  -- Obtained key item: <keyitem>.
        KEYITEM_LOST                   = 6441,  -- Lost key item: <keyitem>.
        NOT_HAVE_ENOUGH_GIL            = 6442,  -- You do not have enough gil.
        YOU_OBTAIN_ITEM                = 6443,  -- You obtain % %!
        NOTHING_OUT_OF_ORDINARY        = 6451,  -- There is nothing out of the ordinary here.
        YOU_MUST_WAIT_ANOTHER_N_DAYS   = 6473,  -- You must wait another <number> [day/days] to perform that action.
        CARRIED_OVER_POINTS            = 6476,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY        = 6477,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                   = 6478,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED  = 6498,  -- Your party is unable to participate because certain members' levels are restricted.
        YOU_LEARNED_TRUST              = 6500,  -- You learned Trust: <name>!
        CALL_MULTIPLE_ALTER_EGO        = 6501,  -- You are now able to call multiple alter egos.
        MOG_LOCKER_OFFSET              = 6700,  -- Your Mog Locker lease is valid until <timestamp>, kupo.
        IMAGE_SUPPORT                  = 6816,  -- Your [fishing/woodworking/smithing/goldsmithing/clothcraft/leatherworking/bonecraft/alchemy/cooking] skills went up [a little/ever so slightly/ever so slightly].
        GUILD_TERMINATE_CONTRACT       = 6830,  -- You have terminated your trading contract with the [Fishermen's/Carpenters'/Blacksmiths'/Goldsmiths'/Weavers'/Tanners'/Boneworkers'/Alchemists'/Culinarians'] Guild and formed a new one with the [Fishermen's/Carpenters'/Blacksmiths'/Goldsmiths'/Weavers'/Tanners'/Boneworkers'/Alchemists'/Culinarians'] Guild.
        GUILD_NEW_CONTRACT             = 6838,  -- You have formed a new trading contract with the [Fishermen's/Carpenters'/Blacksmiths'/Goldsmiths'/Weavers'/Tanners'/Boneworkers'/Alchemists'/Culinarians'] Guild.
        NO_MORE_GP_ELIGIBLE            = 6845,  -- You are not eligible to receive guild points at this time.
        GP_OBTAINED                    = 6850,  -- Obtained: <number> guild points.
        NOT_HAVE_ENOUGH_GP             = 6851,  -- You do not have enough guild points.
        RENOUNCE_CRAFTSMAN             = 6867,  -- You have successfully renounced your status as a [craftsman/artisan/adept] of the [Carpenters'/Blacksmiths'/Goldsmiths'/Weavers'/Tanners'/Boneworkers'/Alchemists'/Culinarians'] Guild.
        CONQUEST_BASE                  = 7073,  -- Tallying conquest results...
        YOU_ACCEPT_THE_MISSION         = 7237,  -- You accept the mission.
        ORIGINAL_MISSION_OFFSET        = 7248,  -- Bring me one of those axes, and your mission will be a success. No running away now; we've a proud country to defend!
        TRICK_OR_TREAT                 = 7396,  -- Trick or treat...
        THANK_YOU_TREAT                = 7397,  -- Thank you... And now for your treat...
        HERE_TAKE_THIS                 = 7398,  -- Here, take this...
        IF_YOU_WEAR_THIS               = 7399,  -- If you put this on and walk around, something...unexpected might happen...
        THANK_YOU                      = 7400,  -- Thank you...
        NOKKHI_BAD_COUNT               = 7418,  -- What kinda smart-alecky baloney is this!? I told you to bring me the same kinda ammunition in complete sets. And don't forget the flowers, neither.
        NOKKHI_GOOD_TRADE              = 7420,  -- And here you go! Come back soon, and bring your friends!
        NOKKHI_BAD_ITEM                = 7421,  -- I'm real sorry, but there's nothing I can do with those.
        EGG_HUNT_OFFSET                = 7427,  -- Egg-cellent! Here's your prize, kupo! Now if only somebody would bring me a super combo... Oh, egg-scuse me! Forget I said that, kupo!
        YOU_CANNOT_ENTER_DYNAMIS       = 7455,  -- You cannot enter Dynamis - [Dummy/San d'Oria/Bastok/Windurst/Jeuno/Beaucedine/Xarcabard/Valkurm/Buburimu/Qufim/Tavnazia] for <number> [day/days] (Vana'diel time).
        PLAYERS_HAVE_NOT_REACHED_LEVEL = 7457,  -- Players who have not reached level <number> are prohibited from entering Dynamis.
        DYNA_NPC_DEFAULT_MESSAGE       = 7467,  -- There is an unusual arrangement of branches here.
        NOBODY_ONE_WANTS_TO_PLAY       = 7783,  -- Ah, nobody wants to play games of chance these days.
        VARCHET_BET_LOST               = 7798,  -- You lose your bet of 5 gil.
        VARCHET_KEEP_PROMISE           = 7807,  -- As promised, I shall go and see about those woodchippers. Maybe we can play another game later.
        ROSEL_GREETINGS                = 7808,  -- Greetings!
        FFR_ROSEL                      = 7827,  -- Hrmm... Now, this is interesting! It pays to keep an eye on the competition. Thanks for letting me know!
        EXOROCHE_START                 = 7843,  -- You've some business with me? Sorry, but I'm busy.
        EXOROCHE_PLEASE_TELL           = 7846,  -- Please tell my son that I'll join him as soon as I'm done, so he's to stay right there.
        GO_TO_KING_RANPERRES           = 7894,  -- Go to King Ranperre's Tomb and bring back <item>. How, you ask? Use your head. Now begone!
        TO_GET_TO_KING_RANPERRES       = 7913,  -- To get to King Ranperre's Tomb, head out the Eastgate into East Ronfaure, then make your way south as far as you can go. You should find it before long.
        YOU_FIND_A_WELL                = 7921,  -- You find a well.
        DONT_NEED_MORE_WATER           = 7923,  -- You don't need any more water.
        I_THANK_YOU_ADVENTURER         = 7925,  -- I thank you, kind adventurer. His Majesty, the late king, thanks you, too.
        TAUMILA_DIALOG                 = 8000,  -- I am Taumila, the owner of this establishment. Talk to the lady behind the counter if you wish to make a purchase.
        LUSIANE_SHOP_DIALOG            = 8001,  -- Hello! Let Taumila's handle all your sundry needs!
        OSTALIE_SHOP_DIALOG            = 8002,  -- Welcome, customer. Please have a look.
        HELBORT_DIALOG                 = 8004,  -- Welcome, welcome! Either of my attendants will be happy to help you!
        HELBORT_ORDERS                 = 8016,  -- It's an urgent order, so go as soon as you can. Remember, give the order to the free trader Alexius in Jugner Forest.
        ASH_THADI_ENE_SHOP_DIALOG      = 8023,  -- Welcome to Helbort's Blades!
        EXOROCHE_DIALOG_OFFSET         = 8025,  -- Oh, the gleam! Such brilliance! Blades wrought by the master here are indeed a cut above. I must have one...
        NOTHING_TO_REPORT              = 8041,  -- Nothing to report!
        TRIAL_IS_DIFFICULT             = 8043,  -- The trial is difficult, but those who pass may become true knights. Good luck to you.
        MAKE_EXCELLENT_KNIGHT          = 8044,  -- I heard you did well. I am sure you'll make an excellent knight.
        DO_NOT_FRET                    = 8046,  -- You may not know what to do, but do not fret. You have all the time you need.
        YOUVE_DONE_WELL                = 8047,  -- You've done well. I knew you would from the moment I saw you.
        UNLOCK_PALADIN                 = 8050,  -- You can now become a paladin!
        AMAURA_DIALOG_COMEBACK         = 8057,  -- Come back when ye've got it all. I'll make a draught to cure the wickedest of colds, I will.
        AMAURA_DIALOG_DELIVER          = 8060,  -- Take that medicine over quick as you can now, dearie. Wouldn't want it to go bad.
        FFR_BLENDARE                   = 8134,  -- Wait! If I had magic, maybe I could keep my brother's hands off my sweets...
        RAMINEL_DELIVERY               = 8138,  -- Here's your delivery!
        RAMINEL_DELIVERIES             = 8140,  -- Sorry, I have deliveries to make!
        SHILAH_SHOP_DIALOG             = 8155,  -- Welcome, weary traveler. Make yourself at home!
        VALERIANO_SHOP_DIALOG          = 8173,  -- Oh, a fellow outsider! We are Troupe Valeriano. I am Valeriano, at your service!
        DAHJAL_NOT_BASTOK_CIT          = 8174,  -- Watch this.
        DAHJAL_BASTOK_CIT              = 8175,  -- I worry for Bastok... Our Hume leaders rely too much on technology.
        MOKOP_NOT_SANDY_CIT            = 8176,  -- To be honest, I'm not fond of San d'Orians. Tall and snooty but misers through and through! May their conquests fall flat!
        MOKOP_SANDY_CIT                = 8177,  -- What a huge city-witty! San d'Oria towers above the other nations! How can they possibly competaru?
        CHEH_WINDY_CIT                 = 8178,  -- The food arrround here's not bad, but our Windurstian chefs could do better. If they could only get hold of the same ingrrredients!
        CHEH_NOT_WINDY_CIT             = 8179,  -- Nobody tops my trrricks. Stand back if you value your ears and moustaches!
        NALTA_SANDY_CIT                = 8180,  -- San d'Oria owes its victories to the Elvaan.
        NALTA_NOT_SANDY_CIT            = 8181,  -- Shhh.
        FERDOULEMIONT_SHOP_DIALOG      = 8189,  -- Hello!
        WEST_GATE                      = 8208,  -- You stand before the Westgate. West Ronfaure lies beyond.
        CLETAE_DIALOG                  = 8241,  -- Why, hello. All our skins are guild-approved.
        KUEH_IGUNAHMORI_DIALOG         = 8242,  -- Good day! We have lots in stock today.
        SOBANE_DIALOG                  = 8261,  -- My name is Sobane, and I'm sharpening my knives.
        PAUNELIE_DIALOG                = 8351,  -- I'm sorry, can I help you?
        ITEM_DELIVERY_DIALOG           = 8451,  -- Parcels delivered to rooms anywhere in Vana'diel!
        PAUNELIE_SHOP_DIALOG           = 8454,  -- Like %?
        MACHIELLE_OPEN_DIALOG          = 8457,  -- Might I interest you in produce from Norvallen?
        CORUA_OPEN_DIALOG              = 8458,  -- Ronfaure produce for sale!
        PHAMELISE_OPEN_DIALOG          = 8459,  -- I've got fresh produce from Zulkheim!
        APAIREMANT_OPEN_DIALOG         = 8460,  -- Might you be interested in produce from Gustaberg
        RAIMBROYS_SHOP_DIALOG          = 8461,  -- Welcome to Raimbroy's Grocery!
        CARAUTIA_SHOP_DIALOG           = 8463,  -- Well, what sort of armor would you like?
        MACHIELLE_CLOSED_DIALOG        = 8464,  -- We want to sell produce from Norvallen, but the entire region is under foreign control!
        CORUA_CLOSED_DIALOG            = 8465,  -- We specialize in Ronfaure produce, but we cannot import from that region without a strong San d'Orian presence there.
        PHAMELISE_CLOSED_DIALOG        = 8466,  -- I'd be making a killing selling produce from Zulkheim, but the region's under foreign control!
        APAIREMANT_CLOSED_DIALOG       = 8467,  -- I'd love to import produce from Gustaberg, but the foreign powers in control there make me feel unsafe!
        POURETTE_OPEN_DIALOG           = 8468,  -- Derfland produce for sale!
        POURETTE_CLOSED_DIALOG         = 8469,  -- Listen, adventurer... I can't import from Derfland until the region knows San d'Orian power!
        CONQUEST                       = 8526,  -- You've earned conquest points!
        FLYER_ACCEPTED                 = 8871,  -- The flyer is accepted.
        FLYER_ALREADY                  = 8872,  -- This person already has a flyer.
        FFR_LOOKS_CURIOUSLY_BASE       = 8873,  -- Blendare looks over curiously for a moment.
        FFR_MAUGIE                     = 8875,  -- A magic shop, eh? Hmm... A little magic could go a long way for making a leisurely retirement! Ho ho ho!
        FFR_ADAUNEL                    = 8877,  -- A magic shop? Maybe I'll check it out one of these days. Could help with my work, even...
        FFR_LEUVERET                   = 8879,  -- A magic shop? That'd be a fine place to peddle my wares. I smell a profit! I'll be up to my gills in gil, I will!
        LUSIANE_THANK                  = 8922,  -- Thank you! My snoring will express gratitude mere words cannot! Here's something for you in return.
        IMPULSE_DRIVE_LEARNED          = 9359,  -- You have learned the weapon skill Impulse Drive!
        CLOUD_BAD_COUNT                = 10147, -- Well, don't just stand there like an idiot! I can't do any bundlin' until you fork over a set of 99 tools and <item>! And I ain't doin' no more than seven sets at one time, so don't even try it!
        CLOUD_GOOD_TRADE               = 10151, -- Here, take 'em and scram. And don't say I ain't never did nothin' for you!
        CLOUD_BAD_ITEM                 = 10152, -- What the hell is this junk!? Why don't you try bringin' what I asked for before I shove one of my sandals up your...nose!
        CAPUCINE_SHOP_DIALOG           = 10353, -- Hello! You seem to be working very hard. I'm really thankful! But you needn't rush around so fast. Take your time! I can wait if it makes the job easier for you!
        CHOCOBO_FEEDING_SLEEP          = 10751, -- Your chocobo is sleeping soundly. You cannot feed it now.
        CHOCOBO_FEEDING_RUN_AWAY       = 10752, -- Your chocobo has run away. You cannot feed it now.
        CHOCOBO_FEEDING_STILL_EGG      = 10753, -- You cannot feed a chocobo that has not hatched yet.
        CHOCOBO_FEEDING_ITEM           = 11845, -- #: %
        TUTORIAL_NPC                   = 13571, -- Greetings and well met! Guardian of the Kingdom, Alaune, at your most humble service.
        YOU_WISH_TO_EXCHANGE_SPARKS    = 15512, -- You wish to exchange your sparks?
        DO_NOT_POSSESS_ENOUGH          = 15541, -- You do not possess enough <item> to complete the transaction.
        NOT_ENOUGH_SPARKS              = 15542, -- You do not possess enough sparks of eminence to complete the transaction.
        MAX_SPARKS_LIMIT_REACHED       = 15543, -- You have reached the maximum number of sparks that you can exchange this week (<number>). Your ability to purchase skill books and equipment will be restricted until next week.
        YOU_NOW_HAVE_AMT_CURRENCY      = 15553, -- You now have <number> [sparks of eminence/conquest points/points of imperial standing/Allied Notes/bayld/Fields of Valor points/assault points (Leujaoam)/assault points (Mamool Ja Training Grounds)/assault points (Lebros Cavern)/assault points (Periqia)/assault points (Ilrusi Atoll)/cruor/kinetic units/obsidian fragments/mweya plasm corpuscles/ballista points/Unity accolades/pinches of Escha silt/resistance credits].
        MAP_MARKER_TUTORIAL            = 15785, -- Selecting Map from the main menu opens the map of the area in which you currently reside. Select Markers and press the right arrow key to see all the markers placed on your map.
        YOU_HAVE_JOINED_UNITY          = 16094, -- You have joined [Pieuje's/Ayame's/Invincible Shield's/Apururu's/Maat's/Aldo's/Jakoh Wahcondalo's/Naja Salaheem's/Flaviria's/Yoran-Oran's/Sylvie's] Unity!
        HAVE_ALREADY_CHANGED_UNITY     = 16170, -- You have already changed Unities. Please wait until the next tabulation period.
        TEAR_IN_FABRIC_OF_SPACE        = 16633, -- There appears to be a tear in the fabric of space...
    },
    mob =
    {
    },
    npc =
    {
        HALLOWEEN_SKINS =
        {
            [17719303] = 47, -- Machielle
            [17719304] = 50, -- Corua
            [17719305] = 48, -- Phamelise
            [17719306] = 46, -- Apairemant
            [17719493] = 49, -- Pourette
        },
        LUSIANE   = GetFirstID('Lusiane'),
        ARPETION  = GetFirstID('Arpetion'),
        CAMEREINE = GetFirstID('Camereine'),
        EMOUSSINE = GetFirstID('Emoussine'),
        MEUNEILLE = GetFirstID('Meuneille'),
    },
}

return zones[xi.zone.SOUTHERN_SAN_DORIA]
