-----------------------------------
--   Dynamis 75 Era Module       --
-----------------------------------
-----------------------------------
--   Module Required Scripts     --
-----------------------------------
require('scripts/globals/dynamis')
require('modules/module_utils')
-----------------------------------
--    Module Affected Scripts    --
-----------------------------------
local m = Module:new('dynamis_zones')

local dynamisZones =
{
    { xi.zone.DYNAMIS_SAN_DORIA,  'Dynamis-San_dOria',  1  },
    { xi.zone.DYNAMIS_BASTOK,     'Dynamis-Bastok',     2  },
    { xi.zone.DYNAMIS_WINDURST,   'Dynamis-Windurst',   3  },
    { xi.zone.DYNAMIS_JEUNO,      'Dynamis-Jeuno',      4  },
    { xi.zone.DYNAMIS_BEAUCEDINE, 'Dynamis-Beaucedine', 5  },
    { xi.zone.DYNAMIS_XARCABARD,  'Dynamis-Xarcabard',  6  },
    { xi.zone.DYNAMIS_VALKURM,    'Dynamis-Valkurm',    7  },
    { xi.zone.DYNAMIS_BUBURIMU,   'Dynamis-Buburimu',   8  },
    { xi.zone.DYNAMIS_QUFIM,      'Dynamis-Qufim',      9  },
    { xi.zone.DYNAMIS_TAVNAZIA,   'Dynamis-Tavnazia',   10 },
}

local startingZones =
{
    { 'Southern_San_dOria',   'Trail_Markings' },
    { 'Bastok_Mines',         'Trail_Markings' },
    { 'Windurst_Walls',       'Trail_Markings' },
    { 'RuLude_Gardens',       'Trail_Markings' },
    { 'Beaucedine_Glacier',   'Trail_Markings' },
    { 'Xarcabard',            'Trail_Markings' },
    { 'Valkurm_Dunes',        'Hieroglyphics'  },
    { 'Buburimu_Peninsula',   'Hieroglyphics'  },
    { 'Qufim_Island',         'Hieroglyphics'  },
    { 'Tavnazian_Safehold',   'Hieroglyphics'  },
}

local mobNames =
{
    ['Dynamis-San_dOria'] =
    {
        { 'Overlords_Tombstone',     'Boss'   },
        { 'Serjeant_Tombstone',      'Statue' },
        { 'Warchief_Tombstone',      'Statue' },
        { 'Battlechoir_Gitchfotch',  'Normal' },
        { 'Reapertongue_Gadgquok',   'Normal' },
        { 'Soulsender_Fugbrag',      'Normal' },
        { 'Voidstreaker_Butchnotch', 'Normal' },
        { 'Wyrmgnasher_Bjakdek',     'Normal' },
        { 'Vanguard_Amputator',      'Normal' },
        { 'Vanguard_Backstabber',    'Normal' },
        { 'Vanguard_Bugler',         'Normal' },
        { 'Vanguard_Dollmaster',     'Normal' },
        { 'Vanguard_Footsoldier',    'Normal' },
        { 'Vanguard_Grappler',       'Normal' },
        { 'Vanguard_Gutslasher',     'Normal' },
        { 'Vanguard_Hawker',         'Normal' },
        { 'Vanguard_Impaler',        'Normal' },
        { 'Vanguard_Mesmerizer',     'Normal' },
        { 'Vanguard_Neckchopper',    'Normal' },
        { 'Vanguard_Pillager',       'Normal' },
        { 'Vanguard_Predator',       'Normal' },
        { 'Vanguard_Trooper',        'Normal' },
        { 'Vanguard_Vexer',          'Normal' },
    },
    ['Dynamis-Bastok'] =
    {
        { 'GuDha_Effigy',         'Boss'   },
        { 'Adamantking_Effigy',   'Statue' },
        { 'GiPha_Manameister',    'Normal' },
        { 'GuNhi_Noondozer',      'Normal' },
        { 'KoDho_Cannonball',     'Normal' },
        { 'ZeVho_Fallsplitter',   'Normal' },
        { 'Vanguard_Beasttender', 'Normal' },
        { 'Vanguard_Constable',   'Normal' },
        { 'Vanguard_Defender',    'Normal' },
        { 'Vanguard_Drakekeeper', 'Normal' },
        { 'Vanguard_Hatamoto',    'Normal' },
        { 'Vanguard_Kusa',        'Normal' },
        { 'Vanguard_Mason',       'Normal' },
        { 'Vanguard_Militant',    'Normal' },
        { 'Vanguard_Minstrel',    'Normal' },
        { 'Vanguard_Protector',   'Normal' },
        { 'Vanguard_Purloiner',   'Normal' },
        { 'Vanguard_Thaumaturge', 'Normal' },
        { 'Vanguard_Undertaker',  'Normal' },
        { 'Vanguard_Vigilante',   'Normal' },
        { 'Vanguard_Vindicator',  'Normal' },
    },
    ['Dynamis-Windurst'] =
    {
        { 'Tzee_Xicu_Idol',          'Boss'   },
        { 'Avatar_Icon',             'Statue' },
        { 'Avatar_Idol',             'Statue' },
        { 'Manifest_Icon',           'Statue' },
        { 'Haa_Pevi_the_Stentorian', 'Normal' },
        { 'Loo_Hepe_the_Eyepiercer', 'Normal' },
        { 'Maa_Febi_the_Steadfast',  'Normal' },
        { 'Muu_Febi_the_Steadfast',  'Normal' },
        { 'Wuu_Qoho_the_Razorclaw',  'Normal' },
        { 'Xoo_Kaza_the_Solemn',     'Normal' },
        { 'Vanguard_Assassin',       'Normal' },
        { 'Vanguard_Chanter',        'Normal' },
        { 'Vanguard_Exemplar',       'Normal' },
        { 'Vanguard_Inciter',        'Normal' },
        { 'Vanguard_Liberator',      'Normal' },
        { 'Vanguard_Ogresoother',    'Normal' },
        { 'Vanguard_Oracle',         'Normal' },
        { 'Vanguard_Partisan',       'Normal' },
        { 'Vanguard_Persecutor',     'Normal' },
        { 'Vanguard_Prelate',        'Normal' },
        { 'Vanguard_Priest',         'Normal' },
        { 'Vanguard_Salvager',       'Normal' },
        { 'Vanguard_Sentinel',       'Normal' },
        { 'Vanguard_Skirmisher',     'Normal' },
        { 'Vanguard_Visionary',      'Normal' },
    },
    ['Dynamis-Jeuno'] =
    {
        { 'Goblin_Golem',           'Boss'   },
        { 'Goblin_Replica',         'Statue' },
        { 'Goblin_Statue',          'Statue' },
        { 'Anvilix_Sootwrists',     'Normal' },
        { 'Bandrix_Rockjaw',        'Normal' },
        { 'Blazox_Boneybod',        'Normal' },
        { 'Bootrix_Jaggedelbow',    'Normal' },
        { 'Buffrix_Eargone',        'Normal' },
        { 'Cloktix_Longnail',       'Normal' },
        { 'Distilix_Stickytoes',    'Normal' },
        { 'Elixmix_Hooknose',       'Normal' },
        { 'Eremix_Snottynostril',   'Normal' },
        { 'Gabblox_Magpietongue',   'Normal' },
        { 'Hermitrix_Toothrot',     'Normal' },
        { 'Humnox_Drumbelly',       'Normal' },
        { 'Jabbrox_Grannyguise',    'Normal' },
        { 'Jabkix_Pigeonpecs',      'Normal' },
        { 'Karashix_Swollenskull',  'Normal' },
        { 'Kikklix_Longlegs',       'Normal' },
        { 'Lurklox_Dhalmelneck',    'Normal' },
        { 'Mobpix_Mucousmouth',     'Normal' },
        { 'Morgmox_Moldnoggin',     'Normal' },
        { 'Mortilox_Wartpaws',      'Normal' },
        { 'Prowlox_Barrelbelly',    'Normal' },
        { 'Rutrix_Hamgams',         'Normal' },
        { 'Scruffix_Shaggychest',   'Normal' },
        { 'Slystix_Megapeepers',    'Normal' },
        { 'Smeltix_Thickhide',      'Normal' },
        { 'Snypestix_Eaglebeak',    'Normal' },
        { 'Sparkspox_Sweatbrow',    'Normal' },
        { 'Ticktox_Beadyeyes',      'Normal' },
        { 'Trailblix_Goatmug',      'Normal' },
        { 'Tufflix_Loglimbs',       'Normal' },
        { 'Tymexox_Ninefingers',    'Normal' },
        { 'Wasabix_Callusdigit',    'Normal' },
        { 'Wyrmwix_Snakespecs',     'Normal' },
        { 'Vanguard_Alchemist',     'Normal' },
        { 'Vanguard_Ambusher',      'Normal' },
        { 'Vanguard_Armorer',       'Normal' },
        { 'Vanguard_Dragontamer',   'Normal' },
        { 'Vanguard_Enchanter',     'Normal' },
        { 'Vanguard_Hitman',        'Normal' },
        { 'Vanguard_Maestro',       'Normal' },
        { 'Vanguard_Necromancer',   'Normal' },
        { 'Vanguard_Pathfinder',    'Normal' },
        { 'Vanguard_Pitfighter',    'Normal' },
        { 'Vanguard_Ronin',         'Normal' },
        { 'Vanguard_Shaman',        'Normal' },
        { 'Vanguard_Smithy',        'Normal' },
        { 'Vanguard_Tinkerer',      'Normal' },
        { 'Vanguard_Welldigger',    'Normal' },
    },
    ['Dynamis-Beaucedine'] =
    {
        { 'Angra_Mainyu',            'Boss'   },
        { 'Adamantking_Effigy',      'Statue' },
        { 'Avatar_Icon',             'Statue' },
        { 'Goblin_Replica',          'Statue' },
        { 'Dynamis_Effigy',          'Statue' },
        { 'Dynamis_Icon',            'Statue' },
        { 'Dynamis_Statue',          'Statue' },
        { 'Dynamis_Tombstone',       'Statue' },
        { 'Vanguard_Eye',            'Statue' },
        { 'Serjeant_Tombstone',      'Statue' },
        { 'Ascetox_Ratgums',         'Normal' },
        { 'BeZhe_Keeprazer',         'Normal' },
        { 'Bhuu_Wjato_the_Firepool', 'Normal' },
        { 'Bordox_Kittyback',        'Normal' },
        { 'Brewnix_Bittypupils',     'Normal' },
        { 'Caa_Xaza_the_Madpiercer', 'Normal' },
        { 'Cobraclaw_Buchzvotch',    'Normal' },
        { 'Dagourmarche',            'Normal' },
        { 'Dagourmarches_Avatar',    'Normal' },
        { 'Dagourmarches_Wyvern',    'Normal' },
        { 'Deathcaller_Bidfbid',     'Normal' },
        { 'DeBho_Pyrohand',          'Normal' },
        { 'Drakefeast_Wubmfub',      'Normal' },
        { 'Draklix_Scalecrust',      'Normal' },
        { 'Droprix_Granitepalms',    'Normal' },
        { 'Elvaanlopper_Grokdok',    'Normal' },
        { 'Foo_Peku_the_Bloodcloak', 'Normal' },
        { 'GaFho_Venomtouch',        'Normal' },
        { 'Galkarider_Retzpratz',    'Normal' },
        { 'Gibberox_Pimplebeak',     'Normal' },
        { 'GoTyo_Magenapper',        'Normal' },
        { 'Goublefaupe',             'Normal' },
        { 'GuKhu_Dukesniper',        'Normal' },
        { 'GuNha_Wallstormer',       'Normal' },
        { 'Guu_Waji_the_Preacher',   'Normal' },
        { 'Heavymail_Djidzbad',      'Normal' },
        { 'Hee_Mida_the_Meticulous', 'Normal' },
        { 'Humegutter_Adzjbadj',     'Normal' },
        { 'Jeunoraider_Gepkzip',     'Normal' },
        { 'JiFhu_Infiltrator',       'Normal' },
        { 'JiKhu_Towercleaver',      'Normal' },
        { 'Knii_Hoqo_the_Bisector',  'Normal' },
        { 'Koo_Saxu_the_Everfast',   'Normal' },
        { 'Kuu_Xuka_the_Nimble',     'Normal' },
        { 'Lockbuster_Zapdjipp',     'Normal' },
        { 'Maa_Zaua_the_Wyrmkeeper', 'Normal' },
        { 'Mildaunegeux',            'Normal' },
        { 'MiRhe_Whisperblade',      'Normal' },
        { 'Mithraslaver_Debhabob',   'Normal' },
        { 'Moltenox_Stubthumbs',     'Normal' },
        { 'Morblox_Chubbychin',      'Normal' },
        { 'MuGha_Legionkiller',      'Normal' },
        { 'NaHya_Floodmaker',        'Normal' },
        { 'Nee_Huxa_the_Judgmental', 'Normal' },
        { 'NuBhi_Spiraleye',         'Normal' },
        { 'Puu_Timu_the_Phantasmal', 'Normal' },
        { 'Quiebitiel',              'Normal' },
        { 'Routsix_Rubbertendon',    'Normal' },
        { 'Ruffbix_Jumbolobes',      'Normal' },
        { 'Ryy_Qihi_the_Idolrobber', 'Normal' },
        { 'Shisox_Widebrow',         'Normal' },
        { 'Skinmask_Ugghfogg',       'Normal' },
        { 'Slinkix_Trufflesniff',    'Normal' },
        { 'SoGho_Adderhandler',      'Normal' },
        { 'Soo_Jopo_the_Fiendking',  'Normal' },
        { 'SoZho_Metalbender',       'Normal' },
        { 'Spinalsucker_Galflmall',  'Normal' },
        { 'Swypestix_Tigershins',    'Normal' },
        { 'TaHyu_Gallanthunter',     'Normal' },
        { 'Taruroaster_Biggsjig',    'Normal' },
        { 'Tocktix_Thinlids',        'Normal' },
        { 'Ultrasonic_Zeknajak',     'Normal' },
        { 'Velosareon',              'Normal' },
        { 'Whistrix_Toadthroat',     'Normal' },
        { 'Wraithdancer_Gidbnod',    'Normal' },
        { 'Xaa_Chau_the_Roctalon',   'Normal' },
        { 'Xhoo_Fuza_the_Sublime',   'Normal' },
        { 'Fire_Pukis',              'Normal' },
        { 'Petro_Pukis',             'Normal' },
        { 'Poison_Pukis',            'Normal' },
        { 'Wind_Pukis',              'Normal' },
        { 'Hydra_Bard',              'Normal' },
        { 'Hydra_Beastmaster',       'Normal' },
        { 'Hydra_Black_Mage',        'Normal' },
        { 'Hydra_Dark_Knight',       'Normal' },
        { 'Hydra_Dragoon',           'Normal' },
        { 'Hydra_Monk',              'Normal' },
        { 'Hydra_Ninja',             'Normal' },
        { 'Hydra_Paladin',           'Normal' },
        { 'Hydra_Ranger',            'Normal' },
        { 'Hydra_Red_Mage',          'Normal' },
        { 'Hydra_Samurai',           'Normal' },
        { 'Hydra_Summoner',          'Normal' },
        { 'Hydra_Thief',             'Normal' },
        { 'Hydra_Warrior',           'Normal' },
        { 'Hydra_White_Mage',        'Normal' },
        { 'Hydras_Avatar',           'Normal' },
        { 'Hydras_Hound',            'Normal' },
        { 'Hydras_Wyvern',           'Normal' },
        { 'Vanguard_Alchemist',      'Normal' },
        { 'Vanguard_Ambusher',       'Normal' },
        { 'Vanguard_Amputator',      'Normal' },
        { 'Vanguard_Armorer',        'Normal' },
        { 'Vanguard_Assassin',       'Normal' },
        { 'Vanguard_Backstabber',    'Normal' },
        { 'Vanguard_Beasttender',    'Normal' },
        { 'Vanguard_Bugler',         'Normal' },
        { 'Vanguard_Chanter',        'Normal' },
        { 'Vanguard_Constable',      'Normal' },
        { 'Vanguard_Defender',       'Normal' },
        { 'Vanguard_Dollmaster',     'Normal' },
        { 'Vanguard_Dragontamer',    'Normal' },
        { 'Vanguard_Drakekeeper',    'Normal' },
        { 'Vanguard_Enchanter',      'Normal' },
        { 'Vanguard_Exemplar',       'Normal' },
        { 'Vanguard_Footsoldier',    'Normal' },
        { 'Vanguard_Grappler',       'Normal' },
        { 'Vanguard_Gutslasher',     'Normal' },
        { 'Vanguard_Hatamoto',       'Normal' },
        { 'Vanguard_Hawker',         'Normal' },
        { 'Vanguard_Hitman',         'Normal' },
        { 'Vanguard_Impaler',        'Normal' },
        { 'Vanguard_Inciter',        'Normal' },
        { 'Vanguard_Kusa',           'Normal' },
        { 'Vanguard_Liberator',      'Normal' },
        { 'Vanguard_Maestro',        'Normal' },
        { 'Vanguard_Mason',          'Normal' },
        { 'Vanguard_Mesmerizer',     'Normal' },
        { 'Vanguard_Militant',       'Normal' },
        { 'Vanguard_Minstrel',       'Normal' },
        { 'Vanguard_Neckchopper',    'Normal' },
        { 'Vanguard_Necromancer',    'Normal' },
        { 'Vanguard_Ogresoother',    'Normal' },
        { 'Vanguard_Oracle',         'Normal' },
        { 'Vanguard_Partisan',       'Normal' },
        { 'Vanguard_Pathfinder',     'Normal' },
        { 'Vanguard_Persecutor',     'Normal' },
        { 'Vanguard_Pillager',       'Normal' },
        { 'Vanguard_Pitfighter',     'Normal' },
        { 'Vanguard_Predator',       'Normal' },
        { 'Vanguard_Prelate',        'Normal' },
        { 'Vanguard_Priest',         'Normal' },
        { 'Vanguard_Protector',      'Normal' },
        { 'Vanguard_Purloiner',      'Normal' },
        { 'Vanguard_Ronin',          'Normal' },
        { 'Vanguard_Salvager',       'Normal' },
        { 'Vanguard_Sentinel',       'Normal' },
        { 'Vanguard_Shaman',         'Normal' },
        { 'Vanguard_Skirmisher',     'Normal' },
        { 'Vanguard_Smithy',         'Normal' },
        { 'Vanguard_Thaumaturge',    'Normal' },
        { 'Vanguard_Tinkerer',       'Normal' },
        { 'Vanguard_Trooper',        'Normal' },
        { 'Vanguard_Undertaker',     'Normal' },
        { 'Vanguard_Vexer',          'Normal' },
        { 'Vanguard_Vigilante',      'Normal' },
        { 'Vanguard_Vindicator',     'Normal' },
        { 'Vanguard_Visionary',      'Normal' },
        { 'Vanguard_Welldigger',     'Normal' },
        { 'Vanguards_Wyvern',        'Normal' },
        { 'Vanguards_Slime',         'Normal' },
        { 'Vanguards_Scorpion',      'Normal' },
        { 'Vanguards_Hecteyes',      'Normal' },
        { 'Vanguards_Crow',          'Normal' },
        { 'Vanguards_Avatar',        'Normal' },
    },
    ['Dynamis-Xarcabard'] =
    {
        { 'Dynamis_Lord',          'Boss'   },
        { 'Effigy_Prototype',      'Statue' },
        { 'Icon_Prototype',        'Statue' },
        { 'Animated_Claymore',     'Normal' },
        { 'Animated_Dagger',       'Normal' },
        { 'Animated_Great_Axe',    'Normal' },
        { 'Animated_Gun',          'Normal' },
        { 'Animated_Hammer',       'Normal' },
        { 'Animated_Horn',         'Normal' },
        { 'Animated_Knuckles',     'Normal' },
        { 'Animated_Kunai',        'Normal' },
        { 'Animated_Longbow',      'Normal' },
        { 'Animated_Longsword',    'Normal' },
        { 'Animated_Scythe',       'Normal' },
        { 'Animated_Shield',       'Normal' },
        { 'Animated_Spear',        'Normal' },
        { 'Animated_Staff',        'Normal' },
        { 'Animated_Tabar',        'Normal' },
        { 'Animated_Tachi',        'Normal' },
        { 'Count_Raum',            'Normal' },
        { 'Count_Vine',            'Normal' },
        { 'Count_Zaebos',          'Normal' },
        { 'Duke_Berith',           'Normal' },
        { 'Duke_Gomory',           'Normal' },
        { 'Duke_Scox',             'Normal' },
        { 'Kindreds_Avatar',       'Normal' },
        { 'Kindred_Bard',          'Normal' },
        { 'Kindred_Beastmaster',   'Normal' },
        { 'Kindred_Black_Mage',    'Normal' },
        { 'Kindred_Dark_Knight',   'Normal' },
        { 'Kindred_Dragoon',       'Normal' },
        { 'Kindred_Monk',          'Normal' },
        { 'Kindred_Ninja',         'Normal' },
        { 'Kindred_Paladin',       'Normal' },
        { 'Kindred_Ranger',        'Normal' },
        { 'Kindred_Red_Mage',      'Normal' },
        { 'Kindred_Samurai',       'Normal' },
        { 'Kindred_Summoner',      'Normal' },
        { 'Kindred_Thief',         'Normal' },
        { 'Kindreds_Vouivre',      'Normal' },
        { 'Kindred_Warrior',       'Normal' },
        { 'Kindred_White_Mage',    'Normal' },
        { 'Kindreds_Wyvern',       'Normal' },
        { 'King_Zagan',            'Normal' },
        { 'Marquis_Andras',        'Normal' },
        { 'Andrass_Vouivre',       'Normal' },
        { 'Marquis_Cimeries',      'Normal' },
        { 'Marquis_Decarabia',     'Normal' },
        { 'Marquis_Gamygyn',       'Normal' },
        { 'Marquis_Nebiros',       'Normal' },
        { 'Marquis_Orias',         'Normal' },
        { 'Marquis_Sabnak',        'Normal' },
        { 'Nebiross_Avatar',       'Normal' },
        { 'Prince_Seere',          'Normal' },
        { 'Satellite_Claymores',   'Normal' },
        { 'Satellite_Daggers',     'Normal' },
        { 'Satellite_Great_Axes',  'Normal' },
        { 'Satellite_Guns',        'Normal' },
        { 'Satellite_Hammers',     'Normal' },
        { 'Satellite_Horns',       'Normal' },
        { 'Satellite_Knuckles',    'Normal' },
        { 'Satellite_Kunai',       'Normal' },
        { 'Satellite_Longbows',    'Normal' },
        { 'Satellite_Longswords',  'Normal' },
        { 'Satellite_Scythes',     'Normal' },
        { 'Satellite_Shield',      'Normal' },
        { 'Satellite_Spears',      'Normal' },
        { 'Satellite_Staves',      'Normal' },
        { 'Satellite_Tabars',      'Normal' },
        { 'Satellite_Tachi',       'Normal' },
        { 'Statue_Prototype',      'Statue' },
        { 'Tombstone_Prototype',   'Statue' },
        { 'Vanguard_Dragon',       'Normal' },
        { 'Vanguard_Eye',          'Statue' },
        { 'Yang',                  'Normal' },
        { 'Ying',                  'Normal' },
        { 'Zagans_Wyvern',         'Normal' },
    },
    ['Dynamis-Valkurm'] =
    {
        { 'Cirrate_Christelle',     'Boss'      },
        { 'Adamantking_Effigy',     'Statue'    },
        { 'Goblin_Replica',         'Statue'    },
        { 'Manifest_Icon',          'Statue'    },
        { 'Warchief_Tombstone',     'Statue'    },
        { 'Fairy_Ring',             'Normal'    },
        { 'Nantina',                'Normal'    },
        { 'Nightmare_Fly',          'Normal'    },
        { 'Stcemqestcint',          'Normal'    },
        { 'Nightmare_Hippogryph',   'Nightmare' },
        { 'Nightmare_Manticore',    'Nightmare' },
        { 'Nightmare_Sabotender',   'Nightmare' },
        { 'Nightmare_Sheep',        'Nightmare' },
        { 'Vanguard_Alchemist',     'Normal'    },
        { 'Vanguard_Ambusher',      'Normal'    },
        { 'Vanguard_Amputator',     'Normal'    },
        { 'Vanguard_Armorer',       'Normal'    },
        { 'Vanguard_Assassin',      'Normal'    },
        { 'Vanguard_Backstabber',   'Normal'    },
        { 'Vanguard_Beasttender',   'Normal'    },
        { 'Vanguard_Bugler',        'Normal'    },
        { 'Vanguard_Chanter',       'Normal'    },
        { 'Vanguard_Constable',     'Normal'    },
        { 'Vanguard_Defender',      'Normal'    },
        { 'Vanguard_Dollmaster',    'Normal'    },
        { 'Vanguard_Dragontamer',   'Normal'    },
        { 'Vanguard_Drakekeeper',   'Normal'    },
        { 'Vanguard_Enchanter',     'Normal'    },
        { 'Vanguard_Exemplar',      'Normal'    },
        { 'Vanguard_Footsoldier',   'Normal'    },
        { 'Vanguard_Grappler',      'Normal'    },
        { 'Vanguard_Gutslasher',    'Normal'    },
        { 'Vanguard_Hatamoto',      'Normal'    },
        { 'Vanguard_Hawker',        'Normal'    },
        { 'Vanguard_Hitman',        'Normal'    },
        { 'Vanguard_Impaler',       'Normal'    },
        { 'Vanguard_Inciter',       'Normal'    },
        { 'Vanguard_Kusa',          'Normal'    },
        { 'Vanguard_Liberator',     'Normal'    },
        { 'Vanguard_Maestro',       'Normal'    },
        { 'Vanguard_Mason',         'Normal'    },
        { 'Vanguard_Mesmerizer',    'Normal'    },
        { 'Vanguard_Militant',      'Normal'    },
        { 'Vanguard_Minstrel',      'Normal'    },
        { 'Vanguard_Neckchopper',   'Normal'    },
        { 'Vanguard_Necromancer',   'Normal'    },
        { 'Vanguard_Ogresoother',   'Normal'    },
        { 'Vanguard_Oracle',        'Normal'    },
        { 'Vanguard_Partisan',      'Normal'    },
        { 'Vanguard_Pathfinder',    'Normal'    },
        { 'Vanguard_Persecutor',    'Normal'    },
        { 'Vanguard_Pillager',      'Normal'    },
        { 'Vanguard_Pitfighter',    'Normal'    },
        { 'Vanguard_Predator',      'Normal'    },
        { 'Vanguard_Prelate',       'Normal'    },
        { 'Vanguard_Priest',        'Normal'    },
        { 'Vanguard_Protector',     'Normal'    },
        { 'Vanguard_Purloiner',     'Normal'    },
        { 'Vanguard_Ronin',         'Normal'    },
        { 'Vanguard_Salvager',      'Normal'    },
        { 'Vanguard_Sentinel',      'Normal'    },
        { 'Vanguard_Shaman',        'Normal'    },
        { 'Vanguard_Skirmisher',    'Normal'    },
        { 'Vanguard_Smithy',        'Normal'    },
        { 'Vanguard_Thaumaturge',   'Normal'    },
        { 'Vanguard_Tinkerer',      'Normal'    },
        { 'Vanguard_Trooper',       'Normal'    },
        { 'Vanguard_Undertaker',    'Normal'    },
        { 'Vanguard_Vexer',         'Normal'    },
        { 'Vanguard_Vigilante',     'Normal'    },
        { 'Vanguard_Vindicator',    'Normal'    },
        { 'Vanguard_Visionary',     'Normal'    },
        { 'Vanguard_Welldigger',    'Normal'    },
    },
    ['Dynamis-Buburimu'] =
    {
        { 'Apocalyptic_Beast',        'Boss'      },
        { 'Dragons_Wyvern',           'Normal'    },
        { 'Adamantking_Effigy',       'Statue'    },
        { 'Manifest_Icon',            'Statue'    },
        { 'Warchief_Tombstone',       'Statue'    },
        { 'Goblin_Replica',           'Statue'    },
        { 'Nightmare_Bunny',          'Nightmare' },
        { 'Nightmare_Cockatrice',     'Nightmare' },
        { 'Nightmare_Crab',           'Nightmare' },
        { 'Nightmare_Crawler',        'Nightmare' },
        { 'Nightmare_Dhalmel',        'Nightmare' },
        { 'Nightmare_Eft',            'Nightmare' },
        { 'Nightmare_Mandragora',     'Nightmare' },
        { 'Nightmare_Raven',          'Nightmare' },
        { 'Nightmare_Scorpion',       'Nightmare' },
        { 'Nightmare_Uragnite',       'Nightmare' },
        { 'Baa_Dava_the_Bibliophage', 'Normal'    },
        { 'Doo_Peku_the_Fleetfoot',   'Normal'    },
        { 'Elvaansticker_Bxafraff',   'Normal'    },
        { 'Flamecaller_Zoeqdoq',      'Normal'    },
        { 'GiBhe_Fleshfeaster',       'Normal'    },
        { 'Gosspix_Blabberlips',      'Normal'    },
        { 'Hamfist_Gukhbuk',          'Normal'    },
        { 'Koo_Rahi_the_Levinblade',  'Normal'    },
        { 'Lyncean_Juwgneg',          'Normal'    },
        { 'QuPho_Bloodspiller',       'Normal'    },
        { 'Ree_Nata_the_Melomanic',   'Normal'    },
        { 'Shamblix_Rottenheart',     'Normal'    },
        { 'TeZha_Ironclad',           'Normal'    },
        { 'Vanguard_Alchemist',       'Normal'    },
        { 'Vanguard_Ambusher',        'Normal'    },
        { 'Vanguard_Amputator',       'Normal'    },
        { 'Vanguard_Armorer',         'Normal'    },
        { 'Vanguard_Assassin',        'Normal'    },
        { 'Vanguards_Avatar',         'Normal'    },
        { 'Vanguard_Backstabber',     'Normal'    },
        { 'Vanguard_Beasttender',     'Normal'    },
        { 'Vanguard_Bugler',          'Normal'    },
        { 'Vanguard_Chanter',         'Normal'    },
        { 'Vanguard_Constable',       'Normal'    },
        { 'Vanguard_Defender',        'Normal'    },
        { 'Vanguard_Dollmaster',      'Normal'    },
        { 'Vanguard_Dragontamer',     'Normal'    },
        { 'Vanguard_Drakekeeper',     'Normal'    },
        { 'Vanguard_Enchanter',       'Normal'    },
        { 'Vanguard_Exemplar',        'Normal'    },
        { 'Vanguard_Footsoldier',     'Normal'    },
        { 'Vanguard_Grappler',        'Normal'    },
        { 'Vanguard_Gutslasher',      'Normal'    },
        { 'Vanguard_Hatamoto',        'Normal'    },
        { 'Vanguard_Hawker',          'Normal'    },
        { 'Vanguard_Hitman',          'Normal'    },
        { 'Vanguard_Impaler',         'Normal'    },
        { 'Vanguard_Inciter',         'Normal'    },
        { 'Vanguard_Kusa',            'Normal'    },
        { 'Vanguard_Liberator',       'Normal'    },
        { 'Vanguard_Maestro',         'Normal'    },
        { 'Vanguard_Mason',           'Normal'    },
        { 'Vanguard_Mesmerizer',      'Normal'    },
        { 'Vanguard_Militant',        'Normal'    },
        { 'Vanguard_Minstrel',        'Normal'    },
        { 'Vanguard_Neckchopper',     'Normal'    },
        { 'Vanguard_Necromancer',     'Normal'    },
        { 'Vanguard_Ogresoother',     'Normal'    },
        { 'Vanguard_Oracle',          'Normal'    },
        { 'Vanguard_Partisan',        'Normal'    },
        { 'Vanguard_Pathfinder',      'Normal'    },
        { 'Vanguard_Persecutor',      'Normal'    },
        { 'Vanguard_Pillager',        'Normal'    },
        { 'Vanguard_Pitfighter',      'Normal'    },
        { 'Vanguard_Predator',        'Normal'    },
        { 'Vanguard_Prelate',         'Normal'    },
        { 'Vanguard_Priest',          'Normal'    },
        { 'Vanguard_Protector',       'Normal'    },
        { 'Vanguard_Purloiner',       'Normal'    },
        { 'Vanguard_Ronin',           'Normal'    },
        { 'Vanguard_Salvager',        'Normal'    },
        { 'Vanguard_Sentinel',        'Normal'    },
        { 'Vanguard_Shaman',          'Normal'    },
        { 'Vanguard_Skirmisher',      'Normal'    },
        { 'Vanguard_Smithy',          'Normal'    },
        { 'Vanguard_Thaumaturge',     'Normal'    },
        { 'Vanguard_Tinkerer',        'Normal'    },
        { 'Vanguard_Trooper',         'Normal'    },
        { 'Vanguard_Undertaker',      'Normal'    },
        { 'Vanguard_Vexer',           'Normal'    },
        { 'Vanguard_Vigilante',       'Normal'    },
        { 'Vanguard_Vindicator',      'Normal'    },
        { 'Vanguard_Visionary',       'Normal'    },
        { 'Vanguard_Welldigger',      'Normal'    },
        { 'Vanguards_Wyvern',         'Normal'    },
        { 'VaRhu_Bodysnatcher',       'Normal'    },
        { 'Aitvaras',                 'Boss'      },
        { 'Alklha',                   'Boss'      },
        { 'Barong',                   'Boss'      },
        { 'Basilic',                  'Boss'      },
        { 'Koshchei',                 'Boss'      },
        { 'Stihi',                    'Boss'      },
        { 'Stollenwurm',              'Boss'      },
        { 'Tarasca',                  'Boss'      },
        { 'Jurik',                    'Boss'      },
        { 'Vishap',                   'Boss'      },
    },
    ['Dynamis-Tavnazia'] =
    {
        { 'Diabolos_Club',       'Normal'    },
        { 'Diabolos_Diamond',    'Normal'    },
        { 'Diabolos_Heart',      'Normal'    },
        { 'Diabolos_Spade',      'Normal'    },
        { 'Umbral_Diabolos',     'Normal'    },
        { 'Diaboloss_Shard',     'Normal'    },
        { 'Vanguard_Eye',        'Statue'    },
        { 'Hydra_Bard',          'Normal'    },
        { 'Hydra_Beastmaster',   'Normal'    },
        { 'Hydra_Black_Mage',    'Normal'    },
        { 'Hydra_Dark_Knight',   'Normal'    },
        { 'Hydra_Dragoon',       'Normal'    },
        { 'Hydra_Monk',          'Normal'    },
        { 'Hydra_Ninja',         'Normal'    },
        { 'Hydra_Paladin',       'Normal'    },
        { 'Hydra_Ranger',        'Normal'    },
        { 'Hydra_Red_Mage',      'Normal'    },
        { 'Hydra_Samurai',       'Normal'    },
        { 'Hydra_Summoner',      'Normal'    },
        { 'Hydra_Thief',         'Normal'    },
        { 'Hydra_Warrior',       'Normal'    },
        { 'Hydra_White_Mage',    'Normal'    },
        { 'Hydras_Hound',        'Normal'    },
        { 'Hydras_Avatar',       'Normal'    },
        { 'Hydras_Wyvern',       'Normal'    },
        { 'Kindred_Bard',        'Normal'    },
        { 'Kindred_Beastmaster', 'Normal'    },
        { 'Kindred_Black_Mage',  'Normal'    },
        { 'Kindred_Dark_Knight', 'Normal'    },
        { 'Kindred_Dragoon',     'Normal'    },
        { 'Kindred_Monk',        'Normal'    },
        { 'Kindred_Ninja',       'Normal'    },
        { 'Kindred_Paladin',     'Normal'    },
        { 'Kindred_Ranger',      'Normal'    },
        { 'Kindred_Red_Mage',    'Normal'    },
        { 'Kindred_Samurai',     'Normal'    },
        { 'Kindred_Summoner',    'Normal'    },
        { 'Kindred_Thief',       'Normal'    },
        { 'Kindred_Warrior',     'Normal'    },
        { 'Kindred_White_Mage',  'Normal'    },
        { 'Kindreds_Vouivre',    'Normal'    },
        { 'Kindreds_Avatar',     'Normal'    },
        { 'Kindreds_Wyvern',     'Normal'    },
        { 'Nightmare_Antlion',   'Nightmare' },
        { 'Nightmare_Bugard',    'Nightmare' },
        { 'Nightmare_Cluster',   'Nightmare' },
        { 'Nightmare_Hornet',    'Nightmare' },
        { 'Nightmare_Leech',     'Nightmare' },
        { 'Nightmare_Makara',    'Nightmare' },
        { 'Nightmare_Taurus',    'Nightmare' },
        { 'Nightmare_Worm',      'Nightmare' },
    }
}

-- local currencyHaggle =
-- {
--     xi.item.ONE_BYNE_BILL,
--     xi.item.ONE_HUNDRED_BYNE_BILL,
--     xi.item.TEN_THOUSAND_BYNE_BILL
-- }

-- local currencyAntiqix =
-- {
--     xi.item.TUKUKU_WHITESHELL,
--     xi.item.LUNGO_NANGO_JADESHELL,
--     xi.item.RIMILALA_STRIPESHELL
-- }

-- local currencyLootblox =
-- {
--     xi.item.ORDELLE_BRONZEPIECE,
--     xi.item.MONTIONT_SILVERPIECE,
--     xi.item.RANPERRE_GOLDPIECE
-- }

-- local shopLootblox =
-- {
--     5,  xi.item.TWINCOON,
--     6,  xi.item.PILE_OF_RELIC_IRON,
--     7,  xi.item.JAR_OF_GOBLIN_GREASE,
--     8,  xi.item.GRIFFON_HIDE,
--     23, xi.item.SQUARE_OF_GRIFFON_LEATHER,
--     25, xi.item.BEHEMOTH_HORN,
--     28, xi.item.MAMMOTH_TUSK,
-- }

-- local shopHaggle =
-- {
--     7,  xi.item.LOCK_OF_SIRENS_HAIR,
--     8,  xi.item.VIAL_OF_SLIME_JUICE,
--     9,  xi.item.CHUNK_OF_WOOTZ_ORE,
--     12, xi.item.BOTTLE_OF_CANTARELLA,
--     20, xi.item.FLASK_OF_MARKSMANS_OIL,
--     25, xi.item.WOOTZ_INGOT,
--     33, xi.item.KOH_I_NOOR,
-- }

-- local shopAntiqix =
-- {
--     7,  xi.item.PIECE_OF_ANGEL_SKIN,
--     8,  xi.item.COLOSSAL_SKULL,
--     9,  xi.item.LANCEWOOD_LOG,
--     23, xi.item.CHRONOS_TOOTH,
--     24, xi.item.CHUNK_OF_RELIC_STEEL,
--     25, xi.item.PIECE_OF_LANCEWOOD_LUMBER,
--     28, xi.item.DAMASCUS_INGOT,
-- }

-- local maps =
-- {
--     [xi.ki.MAP_OF_DYNAMIS_SAN_DORIA]  = 10000,
--     [xi.ki.MAP_OF_DYNAMIS_BASTOK]     = 10000,
--     [xi.ki.MAP_OF_DYNAMIS_WINDURST]   = 10000,
--     [xi.ki.MAP_OF_DYNAMIS_JEUNO]      = 10000,
--     [xi.ki.MAP_OF_DYNAMIS_BEAUCEDINE] = 15000,
--     [xi.ki.MAP_OF_DYNAMIS_XARCABARD]  = 20000,
--     [xi.ki.MAP_OF_DYNAMIS_VALKURM]    = 10000,
--     [xi.ki.MAP_OF_DYNAMIS_BUBURIMU]   = 10000,
--     [xi.ki.MAP_OF_DYNAMIS_QUFIM]      = 10000,
--     [xi.ki.MAP_OF_DYNAMIS_TAVNAZIA]   = 20000,
-- }

-- local hourglassVendors =
-- {
--     { 'Davoi', 'Lootblox', currencyLootblox, shopLootblox, 130 },
--     { 'Castle_Oztroja', 'Antiqix', currencyAntiqix, shopAntiqix, 50 },
--     { 'Beadeaux', 'Haggleblix', currencyHaggle, shopHaggle, 130 }
-- }

-- Helper function for dynamis zone overrides in order to provide clear structure (hopefully?)
-- This overrides the zone scripts for dynamis zones to call dynamis functions
-- onInitialize
-- onZoneOut
-- onZoneIn
-- onZoneTick
-- Special cases for SJ zones (7-9) and Tavnazia (10) for NPCs qm0 and qm1

local function registerDynamisZoneOverrides(zoneID, zoneName, zoneNumber)
    m:addOverride(string.format('xi.zones.%s.Zone.onZoneIn', zoneName),
    function(player, prevZone)
        xi.dynamis.zoneOnZoneInEra(player, prevZone)
    end)

    m:addOverride(string.format('xi.zones.%s.Zone.onZoneTick', zoneName),
    function(zone)
        xi.dynamis.dynamisTick(zone)
    end)

    -- Special case for SJ zones (7-9)
    -- Dynamis - Buburimu (8), Dynamis - Qufim (9)
    if zoneID == xi.zone.DYNAMIS_BUBURIMU or zoneID == xi.zone.DYNAMIS_QUFIM then
        m:addOverride(string.format('xi.zones.%s.npcs.qm1.onTrigger', zoneName),
        function(player, npc)
            xi.dynamis.sjQMOnTrigger(player, npc)
        end)
    end

    -- Special case for Tavnazia (10)
    if zoneNumber == 10 then
        -- Time extension QMs
        m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.npcs.qm1.onTrigger', zoneName),
        function(player, npc)
            xi.dynamis.teOnTrigger(player, npc)
        end)

        m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.npcs.qm1.onTrade', zoneName),
        function(player, npc)
        end)

        m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.npcs.qm2.onTrigger', zoneName),
        function(player, npc)
            xi.dynamis.teOnTrigger(player, npc)
        end)

        m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.npcs.qm2.onTrade', zoneName),
        function(player, npc)
        end)
        -- Trigger areas
        m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.Zone.onTriggerAreaEnter', zoneName),
        function(player, triggerArea)
            xi.dynamis.onTriggerAreaEnterTav(player, triggerArea)
        end)

        m:addOverride(string.format('xi.zones.%s.Zone.onInitialize', zoneName),
        function(zone)
            xi.dynamis.onZoneInitTav(zone)
        end)
    end
end

-- Helper function for entry NPC overrides
local function registerEntryNpcOverrides(zoneName, npcName)
    m:addOverride(string.format('xi.zones.%s.npcs.%s.onTrade', zoneName, npcName),
    function(player, npc, trade)
        xi.dynamis.debugPrint('1. Trail markings on trade working')
        xi.dynamis.entryNpcOnTrade(player, npc, trade)
    end)

    m:addOverride(string.format('xi.zones.%s.npcs.%s.onEventUpdate', zoneName, npcName),
    function(player, csid, option, npc)
        xi.dynamis.entryNpcOnEventUpdate(player, csid, option, npc)
        xi.dynamis.debugPrint('2. Trail markings on event update working')
    end)

    m:addOverride(string.format('xi.zones.%s.npcs.%s.onEventFinish', zoneName, npcName),
    function(player, csid, option, npc)
        xi.dynamis.entryNpcOnEventFinish(player, csid, option, npc)
        xi.dynamis.debugPrint('Trail markings on event finish working')
    end)
end

-- Register all overrides with a simple loop instead of repeating code
for _, zone in pairs(dynamisZones) do
    registerDynamisZoneOverrides(zone[1], zone[2], zone[3])
end

for _, zone in pairs(startingZones) do
    registerEntryNpcOverrides(zone[1], zone[2])
end

-- Disable Base LSB Additional Functions
m:addOverride('xi.dynamis.entryNpcOnTrigger', function(player, npc)
    xi.dynamis.entryNpcOnTriggerEra(player, npc)
end)

m:addOverride('xi.dynamis.entryNpcOnEventFinish', function(player, csid, option)
    xi.dynamis.entryNpcOnEventFinishEra(player, csid, option)
end)

m:addOverride('xi.dynamis.qmOnTrigger', function(player, npc) -- Override standard qmOnTrigger()
    xi.dynamis.qmOnTriggerEra(player, npc)
end)

m:addOverride('xi.dynamis.qmOnTrade', function(player, npc, trade)
    -- No trade functions for era dynamis
end)

m:addOverride('xi.dynamis.procMonster', function(player)
    -- Removes proc system
end)

-----------------------------------
-- Mob Type Overrides
-----------------------------------
-- Helper function to create mob overrides based on mob type
local function registerMobOverrides(zoneName, mobName, mobType)
    local mobPath = string.format('xi.zones.%s.mobs.%s', zoneName, mobName)

    if mobType == 'Statue' then
        m:addOverride(mobPath .. '.onMobSpawn', function(mob)
            xi.dynamis.statueOnSpawn(mob)
        end)

        m:addOverride(mobPath .. '.onMobEngage', function(mob, target)
            xi.dynamis.mobOnEngage(mob, target)
            xi.dynamis.checkEyeColor(mob)
        end)

        m:addOverride(mobPath .. '.onMobRoam', function(mob)
            xi.dynamis.onMobRoam(mob)
        end)

        m:addOverride(mobPath .. '.onMobFight', function(mob, target)
            xi.dynamis.onStatueFight(mob, target)
        end)

        m:addOverride(mobPath .. '.onMobDeath', function(mob, player, optParams)
            xi.dynamis.onStatueDeath(mob, player, optParams)
        end)

        m:addOverride(mobPath .. '.onMobDespawn', function(mob, player, optParams)
        end)

    elseif mobType == 'Boss' then
        m:addOverride(mobPath .. '.onMobInitialize', function(mob)
            xi.dynamis.onBossInitialize(mob)
        end)

        m:addOverride(mobPath .. '.onMobSpawn', function(mob)
            xi.dynamis.onBossSpawn(mob)
        end)

        m:addOverride(mobPath .. '.onMobEngage', function(mob, target)
            xi.dynamis.mobOnEngage(mob, target) -- This is for spawning statues on boss aggro
            xi.dynamis.onBossEngage(mob, target) -- TODO: for qufim maybe
        end)

        m:addOverride(mobPath .. '.onMobRoam', function(mob)
            xi.dynamis.onMobRoam(mob)
            xi.dynamis.onBossRoam(mob)
        end)

        m:addOverride(mobPath .. '.onMobDeath', function(mob, player, optParams)
            xi.dynamis.onBossDeath(mob, player, optParams)
        end)

        m:addOverride(mobPath .. '.onMobDespawn', function(mob, player, optParams)
        end)

    elseif mobType == 'Normal' then
        m:addOverride(mobPath .. '.onMobSpawn', function(mob)
            xi.dynamis.onMobSpawn(mob, mobType)
        end)

        m:addOverride(mobPath .. '.onMobRoam', function(mob)
            xi.dynamis.onMobRoam(mob)
        end)

        m:addOverride(mobPath .. '.onMobDeath', function(mob, player, optParams)
            xi.dynamis.onMobDeath(mob, player, optParams)
        end)

        m:addOverride(mobPath .. '.onMobDespawn', function(mob, player, optParams)
        end)
    elseif mobType == 'Nightmare' then
        m:addOverride(mobPath .. '.onMobSpawn', function(mob)
            xi.dynamis.onMobSpawn(mob, mobType)
        end)

        m:addOverride(mobPath .. '.onMobEngage', function(mob, target)
            xi.dynamis.mobOnEngage(mob, target)
        end)

        m:addOverride(mobPath .. '.onMobRoam', function(mob)
            xi.dynamis.onMobRoam(mob)
        end)

        m:addOverride(mobPath .. '.onMobDeath', function(mob, player, optParams)
            xi.dynamis.onMobDeath(mob, player, optParams)
        end)

        m:addOverride(mobPath .. '.onMobDespawn', function(mob, player, optParams)
        end)
    end
end

-- Register all mob overrides from the mobNames table
for zoneName, mobs in pairs(mobNames) do
    if mobs then
        for _, mobEntry in ipairs(mobs) do
            local mobName = mobEntry[1]
            local mobType = mobEntry[2]
            registerMobOverrides(zoneName, mobName, mobType)
        end
    end
end

-- Overrides for Dynamis Hourglass Vendors (Not sure if we need this anymore)
-- TODO AUDIT THE VENDORS
-- for _, npcEntry in pairs(hourglassVendors) do
--     m:addOverride(string.format('xi.zones.%s.npcs.%s.onTrade', npcEntry[1], npcEntry[2]), function(player, npc, trade)
--         local gil = trade:getGil()
--         local count = trade:getItemCount()
--         local eventId = npcEntry[5]
--         if player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) then
--             -- buy timeless hourglass
--             if
--                 gil == xi.settings.main.TIMELESS_HOURGLASS_COST and
--                 count == 1 and
--                 not player:hasItem(xi.item.TIMELESS_HOURGLASS)
--             then
--                 player:startEvent(eventId + 4)
--             -- currency exchanges
--             elseif
--                 count == xi.settings.main.CURRENCY_EXCHANGE_RATE and
--                 trade:hasItemQty(npcEntry[3][1], xi.settings.main.CURRENCY_EXCHANGE_RATE)
--             then
--                 player:startEvent(eventId + 5, xi.settings.main.CURRENCY_EXCHANGE_RATE)
--             elseif
--                 count == xi.settings.main.CURRENCY_EXCHANGE_RATE and
--                 trade:hasItemQty(npcEntry[3][2], xi.settings.main.CURRENCY_EXCHANGE_RATE)
--             then
--                 player:startEvent(eventId + 6, xi.settings.main.CURRENCY_EXCHANGE_RATE)
--             elseif count == 1 and trade:hasItemQty(npcEntry[3][3], 1) then
--                 player:startEvent(eventId + 8, npcEntry[3][3], npcEntry[3][2], xi.settings.main.CURRENCY_EXCHANGE_RATE)
--             -- shop
--             else
--                 local item
--                 local price
--                 for i = 1, 13, 2 do
--                     price = npcEntry[4][i]
--                     item = npcEntry[4][i + 1]
--                     if
--                         count == price and
--                         trade:hasItemQty(npcEntry[3][2], price)
--                     then
--                         player:setLocalVar('hundoItemBought', item)
--                         player:startEvent(eventId + 7, npcEntry[3][2], price, item)

--                         break
--                     end
--                 end
--             end
--         end
--     end)

--     m:addOverride(string.format('xi.zones.%s.npcs.%s.onTrigger', npcEntry[1], npcEntry[2]), function(player, npc)
--         local eventId = npcEntry[5]
--         if player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) then
--             player:startEvent(eventId + 3, npcEntry[3][1], xi.settings.main.CURRENCY_EXCHANGE_RATE, npcEntry[3][2], xi.settings.main.CURRENCY_EXCHANGE_RATE, npcEntry[3][3], xi.settings.main.TIMELESS_HOURGLASS_COST, xi.item.TIMELESS_HOURGLASS, xi.settings.main.TIMELESS_HOURGLASS_COST)
--         else
--             player:startEvent(eventId)
--         end
--     end)

--     m:addOverride(string.format('xi.zones.%s.npcs.%s.onEventUpdate', npcEntry[1], npcEntry[2]), function(player, csid, option)
--         local eventId = npcEntry[5]
--         if csid == eventId + 3 then
--             if option == 1 then
--                 player:release()
--             elseif option == 2 then -- Shop
--                 player:updateEvent(unpack(npcEntry[4], 1, 8))
--             elseif option == 3 then -- Shop
--                 player:updateEvent(unpack(npcEntry[4], 9, 14))
--             elseif option == 10 then -- Offer to trade down for 10k
--                 player:updateEvent(npcEntry[3][3], npcEntry[3][2], xi.settings.main.CURRENCY_EXCHANGE_RATE)
--             elseif option == 11 then -- main menu (param1 = dynamis map bitmask, param2 = gil)
--                 player:updateEvent(xi.dynamis.getDynamisMapList(player), player:getGil())
--             elseif maps[option] ~= nil then
--                 local price = maps[option]
--                 if price > player:getGil() then
--                     player:messageSpecial(zones[player:getZoneID()].text.NOT_ENOUGH_GIL)
--                 else
--                     player:delGil(price)
--                     player:addKeyItem(option)
--                     player:messageSpecial(zones[player:getZoneID()].text.KEYITEM_OBTAINED, option)
--                 end

--                 player:updateEvent(xi.dynamis.getDynamisMapList(player), player:getGil())
--             end
--         end
--     end)

--     m:addOverride(string.format('xi.zones.%s.npcs.%s.onEventFinish', npcEntry[1], npcEntry[2]), function(player, csid, option)
--         local eventId = npcEntry[5]
--         if csid == eventId + 4 then -- Bought hourglass
--             if player:getFreeSlotsCount() == 0 then
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_CANNOT_BE_OBTAINED, xi.item.TIMELESS_HOURGLASS)
--             else
--                 player:tradeComplete()
--                 player:addItem(xi.item.TIMELESS_HOURGLASS)
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_OBTAINED, xi.item.TIMELESS_HOURGLASS)
--             end
--         elseif csid == eventId + 5 then -- Currency conversion to Singles
--             if player:getFreeSlotsCount() == 0 then
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_CANNOT_BE_OBTAINED, npcEntry[3][2])
--             else
--                 player:tradeComplete()
--                 player:addItem(npcEntry[3][2])
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_OBTAINED, npcEntry[3][2])
--             end
--         elseif csid == eventId + 6 then -- Currency Conversion to 10k
--             if player:getFreeSlotsCount() == 0 then
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_CANNOT_BE_OBTAINED, npcEntry[3][3])
--             else
--                 player:tradeComplete()
--                 player:addItem(npcEntry[3][3])
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_OBTAINED, npcEntry[3][3])
--             end
--         elseif csid == eventId + 8 then -- Currency Conversion to 10k
--             local slotsReq = math.ceil(xi.settings.main.CURRENCY_EXCHANGE_RATE / 99)
--             if player:getFreeSlotsCount() < slotsReq then
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_CANNOT_BE_OBTAINED, npcEntry[3][2])
--             else
--                 player:tradeComplete()
--                 for i = 1, slotsReq do
--                     if i < slotsReq or (xi.settings.main.CURRENCY_EXCHANGE_RATE % 99) == 0 then
--                         player:addItem(npcEntry[3][2], xi.settings.main.CURRENCY_EXCHANGE_RATE)
--                     else
--                         player:addItem(npcEntry[3][2], xi.settings.main.CURRENCY_EXCHANGE_RATE % 99)
--                     end
--                 end

--                 player:messageSpecial(zones[player:getZoneID()].text.ITEMS_OBTAINED, npcEntry[3][2], xi.settings.main.CURRENCY_EXCHANGE_RATE)
--             end
--         -- bought item from shop
--         elseif csid == eventId + 7 then
--             local item = player:getLocalVar('hundoItemBought')
--             if player:getFreeSlotsCount() == 0 then
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_CANNOT_BE_OBTAINED, item)
--             else
--                 player:tradeComplete()
--                 player:addItem(item)
--                 player:messageSpecial(zones[player:getZoneID()].text.ITEM_OBTAINED, item)
--             end

--             player:setLocalVar('hundoItemBought', 0)
--         end
--     end)
-- end

return m
