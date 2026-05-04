-----------------------------------
--   Dynamis 75 Era Module       --
-----------------------------------
-----------------------------------
--   Module Required Scripts     --
-----------------------------------
require('scripts/globals/dynamis')
require('scripts/globals/dynamis/dynamis_mobIinfo')
require('scripts/globals/dynamis/zonemechs/buburimu')
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

local mobType = xi.dynamis.mobType

local mobNames =
{
    ['Dynamis-San_dOria'] =
    {
        { 'Overlords_Tombstone',     mobType.BOSS   },
        { 'Serjeant_Tombstone',      mobType.STATUE },
        { 'Warchief_Tombstone',      mobType.STATUE },
        { 'Battlechoir_Gitchfotch',  mobType.NORMAL },
        { 'Reapertongue_Gadgquok',   mobType.NORMAL },
        { 'Soulsender_Fugbrag',      mobType.NORMAL },
        { 'Voidstreaker_Butchnotch', mobType.NORMAL },
        { 'Wyrmgnasher_Bjakdek',     mobType.NORMAL },
        { 'Vanguard_Amputator',      mobType.NORMAL },
        { 'Vanguard_Backstabber',    mobType.NORMAL },
        { 'Vanguard_Bugler',         mobType.NORMAL },
        { 'Vanguard_Dollmaster',     mobType.NORMAL },
        { 'Vanguard_Footsoldier',    mobType.NORMAL },
        { 'Vanguard_Grappler',       mobType.NORMAL },
        { 'Vanguard_Gutslasher',     mobType.NORMAL },
        { 'Vanguard_Hawker',         mobType.NORMAL },
        { 'Vanguard_Impaler',        mobType.NORMAL },
        { 'Vanguard_Mesmerizer',     mobType.NORMAL },
        { 'Vanguard_Neckchopper',    mobType.NORMAL },
        { 'Vanguard_Pillager',       mobType.NORMAL },
        { 'Vanguard_Predator',       mobType.NORMAL },
        { 'Vanguard_Trooper',        mobType.NORMAL },
        { 'Vanguard_Vexer',          mobType.NORMAL },
    },
    ['Dynamis-Bastok'] =
    {
        { 'GuDha_Effigy',         mobType.BOSS   },
        { 'Adamantking_Effigy',   mobType.STATUE },
        { 'GiPha_Manameister',    mobType.NORMAL },
        { 'GuNhi_Noondozer',      mobType.NORMAL },
        { 'KoDho_Cannonball',     mobType.NORMAL },
        { 'ZeVho_Fallsplitter',   mobType.NORMAL },
        { 'Vanguard_Beasttender', mobType.NORMAL },
        { 'Vanguard_Constable',   mobType.NORMAL },
        { 'Vanguard_Defender',    mobType.NORMAL },
        { 'Vanguard_Drakekeeper', mobType.NORMAL },
        { 'Vanguard_Hatamoto',    mobType.NORMAL },
        { 'Vanguard_Kusa',        mobType.NORMAL },
        { 'Vanguard_Mason',       mobType.NORMAL },
        { 'Vanguard_Militant',    mobType.NORMAL },
        { 'Vanguard_Minstrel',    mobType.NORMAL },
        { 'Vanguard_Protector',   mobType.NORMAL },
        { 'Vanguard_Purloiner',   mobType.NORMAL },
        { 'Vanguard_Thaumaturge', mobType.NORMAL },
        { 'Vanguard_Undertaker',  mobType.NORMAL },
        { 'Vanguard_Vigilante',   mobType.NORMAL },
        { 'Vanguard_Vindicator',  mobType.NORMAL },
    },
    ['Dynamis-Windurst'] =
    {
        { 'Tzee_Xicu_Idol',          mobType.BOSS   },
        { 'Avatar_Icon',             mobType.STATUE },
        { 'Avatar_Idol',             mobType.STATUE },
        { 'Manifest_Icon',           mobType.STATUE },
        { 'Haa_Pevi_the_Stentorian', mobType.NORMAL },
        { 'Loo_Hepe_the_Eyepiercer', mobType.NORMAL },
        { 'Maa_Febi_the_Steadfast',  mobType.NORMAL },
        { 'Muu_Febi_the_Steadfast',  mobType.NORMAL },
        { 'Wuu_Qoho_the_Razorclaw',  mobType.NORMAL },
        { 'Xoo_Kaza_the_Solemn',     mobType.NORMAL },
        { 'Vanguard_Assassin',       mobType.NORMAL },
        { 'Vanguard_Chanter',        mobType.NORMAL },
        { 'Vanguard_Exemplar',       mobType.NORMAL },
        { 'Vanguard_Inciter',        mobType.NORMAL },
        { 'Vanguard_Liberator',      mobType.NORMAL },
        { 'Vanguard_Ogresoother',    mobType.NORMAL },
        { 'Vanguard_Oracle',         mobType.NORMAL },
        { 'Vanguard_Partisan',       mobType.NORMAL },
        { 'Vanguard_Persecutor',     mobType.NORMAL },
        { 'Vanguard_Prelate',        mobType.NORMAL },
        { 'Vanguard_Priest',         mobType.NORMAL },
        { 'Vanguard_Salvager',       mobType.NORMAL },
        { 'Vanguard_Sentinel',       mobType.NORMAL },
        { 'Vanguard_Skirmisher',     mobType.NORMAL },
        { 'Vanguard_Visionary',      mobType.NORMAL },
    },
    ['Dynamis-Jeuno'] =
    {
        { 'Goblin_Golem',           mobType.BOSS   },
        { 'Goblin_Replica',         mobType.STATUE },
        { 'Goblin_Statue',          mobType.STATUE },
        { 'Anvilix_Sootwrists',     mobType.NORMAL },
        { 'Bandrix_Rockjaw',        mobType.NORMAL },
        { 'Blazox_Boneybod',        mobType.NORMAL },
        { 'Bootrix_Jaggedelbow',    mobType.NORMAL },
        { 'Buffrix_Eargone',        mobType.NORMAL },
        { 'Cloktix_Longnail',       mobType.NORMAL },
        { 'Distilix_Stickytoes',    mobType.NORMAL },
        { 'Elixmix_Hooknose',       mobType.NORMAL },
        { 'Eremix_Snottynostril',   mobType.NORMAL },
        { 'Gabblox_Magpietongue',   mobType.NORMAL },
        { 'Hermitrix_Toothrot',     mobType.NORMAL },
        { 'Humnox_Drumbelly',       mobType.NORMAL },
        { 'Jabbrox_Grannyguise',    mobType.NORMAL },
        { 'Jabkix_Pigeonpecs',      mobType.NORMAL },
        { 'Karashix_Swollenskull',  mobType.NORMAL },
        { 'Kikklix_Longlegs',       mobType.NORMAL },
        { 'Lurklox_Dhalmelneck',    mobType.NORMAL },
        { 'Mobpix_Mucousmouth',     mobType.NORMAL },
        { 'Morgmox_Moldnoggin',     mobType.NORMAL },
        { 'Mortilox_Wartpaws',      mobType.NORMAL },
        { 'Prowlox_Barrelbelly',    mobType.NORMAL },
        { 'Rutrix_Hamgams',         mobType.NORMAL },
        { 'Scruffix_Shaggychest',   mobType.NORMAL },
        { 'Slystix_Megapeepers',    mobType.NORMAL },
        { 'Smeltix_Thickhide',      mobType.NORMAL },
        { 'Snypestix_Eaglebeak',    mobType.NORMAL },
        { 'Sparkspox_Sweatbrow',    mobType.NORMAL },
        { 'Ticktox_Beadyeyes',      mobType.NORMAL },
        { 'Trailblix_Goatmug',      mobType.NORMAL },
        { 'Tufflix_Loglimbs',       mobType.NORMAL },
        { 'Tymexox_Ninefingers',    mobType.NORMAL },
        { 'Wasabix_Callusdigit',    mobType.NORMAL },
        { 'Wyrmwix_Snakespecs',     mobType.NORMAL },
        { 'Vanguard_Alchemist',     mobType.NORMAL },
        { 'Vanguard_Ambusher',      mobType.NORMAL },
        { 'Vanguard_Armorer',       mobType.NORMAL },
        { 'Vanguard_Dragontamer',   mobType.NORMAL },
        { 'Vanguard_Enchanter',     mobType.NORMAL },
        { 'Vanguard_Hitman',        mobType.NORMAL },
        { 'Vanguard_Maestro',       mobType.NORMAL },
        { 'Vanguard_Necromancer',   mobType.NORMAL },
        { 'Vanguard_Pathfinder',    mobType.NORMAL },
        { 'Vanguard_Pitfighter',    mobType.NORMAL },
        { 'Vanguard_Ronin',         mobType.NORMAL },
        { 'Vanguard_Shaman',        mobType.NORMAL },
        { 'Vanguard_Smithy',        mobType.NORMAL },
        { 'Vanguard_Tinkerer',      mobType.NORMAL },
        { 'Vanguard_Welldigger',    mobType.NORMAL },
    },
    ['Dynamis-Beaucedine'] =
    {
        { 'Angra_Mainyu',            mobType.BOSS   },
        { 'Adamantking_Effigy',      mobType.STATUE },
        { 'Avatar_Icon',             mobType.STATUE },
        { 'Goblin_Replica',          mobType.STATUE },
        { 'Dynamis_Effigy',          mobType.STATUE },
        { 'Dynamis_Icon',            mobType.STATUE },
        { 'Dynamis_Statue',          mobType.STATUE },
        { 'Dynamis_Tombstone',       mobType.STATUE },
        { 'Vanguard_Eye',            mobType.STATUE },
        { 'Serjeant_Tombstone',      mobType.STATUE },
        { 'Ascetox_Ratgums',         mobType.NORMAL },
        { 'BeZhe_Keeprazer',         mobType.NORMAL },
        { 'Bhuu_Wjato_the_Firepool', mobType.NORMAL },
        { 'Bordox_Kittyback',        mobType.NORMAL },
        { 'Brewnix_Bittypupils',     mobType.NORMAL },
        { 'Caa_Xaza_the_Madpiercer', mobType.NORMAL },
        { 'Cobraclaw_Buchzvotch',    mobType.NORMAL },
        { 'Dagourmarche',            mobType.NORMAL },
        { 'Dagourmarches_Avatar',    mobType.NORMAL },
        { 'Dagourmarches_Wyvern',    mobType.NORMAL },
        { 'Deathcaller_Bidfbid',     mobType.NORMAL },
        { 'DeBho_Pyrohand',          mobType.NORMAL },
        { 'Drakefeast_Wubmfub',      mobType.NORMAL },
        { 'Draklix_Scalecrust',      mobType.NORMAL },
        { 'Droprix_Granitepalms',    mobType.NORMAL },
        { 'Elvaanlopper_Grokdok',    mobType.NORMAL },
        { 'Foo_Peku_the_Bloodcloak', mobType.NORMAL },
        { 'GaFho_Venomtouch',        mobType.NORMAL },
        { 'Galkarider_Retzpratz',    mobType.NORMAL },
        { 'Gibberox_Pimplebeak',     mobType.NORMAL },
        { 'GoTyo_Magenapper',        mobType.NORMAL },
        { 'Goublefaupe',             mobType.NORMAL },
        { 'GuKhu_Dukesniper',        mobType.NORMAL },
        { 'GuNha_Wallstormer',       mobType.NORMAL },
        { 'Guu_Waji_the_Preacher',   mobType.NORMAL },
        { 'Heavymail_Djidzbad',      mobType.NORMAL },
        { 'Hee_Mida_the_Meticulous', mobType.NORMAL },
        { 'Humegutter_Adzjbadj',     mobType.NORMAL },
        { 'Jeunoraider_Gepkzip',     mobType.NORMAL },
        { 'JiFhu_Infiltrator',       mobType.NORMAL },
        { 'JiKhu_Towercleaver',      mobType.NORMAL },
        { 'Knii_Hoqo_the_Bisector',  mobType.NORMAL },
        { 'Koo_Saxu_the_Everfast',   mobType.NORMAL },
        { 'Kuu_Xuka_the_Nimble',     mobType.NORMAL },
        { 'Lockbuster_Zapdjipp',     mobType.NORMAL },
        { 'Maa_Zaua_the_Wyrmkeeper', mobType.NORMAL },
        { 'Mildaunegeux',            mobType.NORMAL },
        { 'MiRhe_Whisperblade',      mobType.NORMAL },
        { 'Mithraslaver_Debhabob',   mobType.NORMAL },
        { 'Moltenox_Stubthumbs',     mobType.NORMAL },
        { 'Morblox_Chubbychin',      mobType.NORMAL },
        { 'MuGha_Legionkiller',      mobType.NORMAL },
        { 'NaHya_Floodmaker',        mobType.NORMAL },
        { 'Nee_Huxa_the_Judgmental', mobType.NORMAL },
        { 'NuBhi_Spiraleye',         mobType.NORMAL },
        { 'Puu_Timu_the_Phantasmal', mobType.NORMAL },
        { 'Quiebitiel',              mobType.NORMAL },
        { 'Routsix_Rubbertendon',    mobType.NORMAL },
        { 'Ruffbix_Jumbolobes',      mobType.NORMAL },
        { 'Ryy_Qihi_the_Idolrobber', mobType.NORMAL },
        { 'Shisox_Widebrow',         mobType.NORMAL },
        { 'Skinmask_Ugghfogg',       mobType.NORMAL },
        { 'Slinkix_Trufflesniff',    mobType.NORMAL },
        { 'SoGho_Adderhandler',      mobType.NORMAL },
        { 'Soo_Jopo_the_Fiendking',  mobType.NORMAL },
        { 'SoZho_Metalbender',       mobType.NORMAL },
        { 'Spinalsucker_Galflmall',  mobType.NORMAL },
        { 'Swypestix_Tigershins',    mobType.NORMAL },
        { 'TaHyu_Gallanthunter',     mobType.NORMAL },
        { 'Taruroaster_Biggsjig',    mobType.NORMAL },
        { 'Tocktix_Thinlids',        mobType.NORMAL },
        { 'Ultrasonic_Zeknajak',     mobType.NORMAL },
        { 'Velosareon',              mobType.NORMAL },
        { 'Whistrix_Toadthroat',     mobType.NORMAL },
        { 'Wraithdancer_Gidbnod',    mobType.NORMAL },
        { 'Xaa_Chau_the_Roctalon',   mobType.NORMAL },
        { 'Xhoo_Fuza_the_Sublime',   mobType.NORMAL },
        { 'Fire_Pukis',              mobType.NORMAL },
        { 'Petro_Pukis',             mobType.NORMAL },
        { 'Poison_Pukis',            mobType.NORMAL },
        { 'Wind_Pukis',              mobType.NORMAL },
        { 'Hydra_Bard',              mobType.NORMAL },
        { 'Hydra_Beastmaster',       mobType.NORMAL },
        { 'Hydra_Black_Mage',        mobType.NORMAL },
        { 'Hydra_Dark_Knight',       mobType.NORMAL },
        { 'Hydra_Dragoon',           mobType.NORMAL },
        { 'Hydra_Monk',              mobType.NORMAL },
        { 'Hydra_Ninja',             mobType.NORMAL },
        { 'Hydra_Paladin',           mobType.NORMAL },
        { 'Hydra_Ranger',            mobType.NORMAL },
        { 'Hydra_Red_Mage',          mobType.NORMAL },
        { 'Hydra_Samurai',           mobType.NORMAL },
        { 'Hydra_Summoner',          mobType.NORMAL },
        { 'Hydra_Thief',             mobType.NORMAL },
        { 'Hydra_Warrior',           mobType.NORMAL },
        { 'Hydra_White_Mage',        mobType.NORMAL },
        { 'Hydras_Avatar',           mobType.NORMAL },
        { 'Hydras_Hound',            mobType.NORMAL },
        { 'Hydras_Wyvern',           mobType.NORMAL },
        { 'Vanguard_Alchemist',      mobType.NORMAL },
        { 'Vanguard_Ambusher',       mobType.NORMAL },
        { 'Vanguard_Amputator',      mobType.NORMAL },
        { 'Vanguard_Armorer',        mobType.NORMAL },
        { 'Vanguard_Assassin',       mobType.NORMAL },
        { 'Vanguard_Backstabber',    mobType.NORMAL },
        { 'Vanguard_Beasttender',    mobType.NORMAL },
        { 'Vanguard_Bugler',         mobType.NORMAL },
        { 'Vanguard_Chanter',        mobType.NORMAL },
        { 'Vanguard_Constable',      mobType.NORMAL },
        { 'Vanguard_Defender',       mobType.NORMAL },
        { 'Vanguard_Dollmaster',     mobType.NORMAL },
        { 'Vanguard_Dragontamer',    mobType.NORMAL },
        { 'Vanguard_Drakekeeper',    mobType.NORMAL },
        { 'Vanguard_Enchanter',      mobType.NORMAL },
        { 'Vanguard_Exemplar',       mobType.NORMAL },
        { 'Vanguard_Footsoldier',    mobType.NORMAL },
        { 'Vanguard_Grappler',       mobType.NORMAL },
        { 'Vanguard_Gutslasher',     mobType.NORMAL },
        { 'Vanguard_Hatamoto',       mobType.NORMAL },
        { 'Vanguard_Hawker',         mobType.NORMAL },
        { 'Vanguard_Hitman',         mobType.NORMAL },
        { 'Vanguard_Impaler',        mobType.NORMAL },
        { 'Vanguard_Inciter',        mobType.NORMAL },
        { 'Vanguard_Kusa',           mobType.NORMAL },
        { 'Vanguard_Liberator',      mobType.NORMAL },
        { 'Vanguard_Maestro',        mobType.NORMAL },
        { 'Vanguard_Mason',          mobType.NORMAL },
        { 'Vanguard_Mesmerizer',     mobType.NORMAL },
        { 'Vanguard_Militant',       mobType.NORMAL },
        { 'Vanguard_Minstrel',       mobType.NORMAL },
        { 'Vanguard_Neckchopper',    mobType.NORMAL },
        { 'Vanguard_Necromancer',    mobType.NORMAL },
        { 'Vanguard_Ogresoother',    mobType.NORMAL },
        { 'Vanguard_Oracle',         mobType.NORMAL },
        { 'Vanguard_Partisan',       mobType.NORMAL },
        { 'Vanguard_Pathfinder',     mobType.NORMAL },
        { 'Vanguard_Persecutor',     mobType.NORMAL },
        { 'Vanguard_Pillager',       mobType.NORMAL },
        { 'Vanguard_Pitfighter',     mobType.NORMAL },
        { 'Vanguard_Predator',       mobType.NORMAL },
        { 'Vanguard_Prelate',        mobType.NORMAL },
        { 'Vanguard_Priest',         mobType.NORMAL },
        { 'Vanguard_Protector',      mobType.NORMAL },
        { 'Vanguard_Purloiner',      mobType.NORMAL },
        { 'Vanguard_Ronin',          mobType.NORMAL },
        { 'Vanguard_Salvager',       mobType.NORMAL },
        { 'Vanguard_Sentinel',       mobType.NORMAL },
        { 'Vanguard_Shaman',         mobType.NORMAL },
        { 'Vanguard_Skirmisher',     mobType.NORMAL },
        { 'Vanguard_Smithy',         mobType.NORMAL },
        { 'Vanguard_Thaumaturge',    mobType.NORMAL },
        { 'Vanguard_Tinkerer',       mobType.NORMAL },
        { 'Vanguard_Trooper',        mobType.NORMAL },
        { 'Vanguard_Undertaker',     mobType.NORMAL },
        { 'Vanguard_Vexer',          mobType.NORMAL },
        { 'Vanguard_Vigilante',      mobType.NORMAL },
        { 'Vanguard_Vindicator',     mobType.NORMAL },
        { 'Vanguard_Visionary',      mobType.NORMAL },
        { 'Vanguard_Welldigger',     mobType.NORMAL },
        { 'Vanguards_Wyvern',        mobType.NORMAL },
        { 'Vanguards_Slime',         mobType.NORMAL },
        { 'Vanguards_Scorpion',      mobType.NORMAL },
        { 'Vanguards_Hecteyes',      mobType.NORMAL },
        { 'Vanguards_Crow',          mobType.NORMAL },
        { 'Vanguards_Avatar',        mobType.NORMAL },
    },
    ['Dynamis-Xarcabard'] =
    {
        { 'Dynamis_Lord',          mobType.BOSS   },
        { 'Effigy_Prototype',      mobType.STATUE },
        { 'Icon_Prototype',        mobType.STATUE },
        { 'Animated_Claymore',     mobType.NORMAL },
        { 'Animated_Dagger',       mobType.NORMAL },
        { 'Animated_Great_Axe',    mobType.NORMAL },
        { 'Animated_Gun',          mobType.NORMAL },
        { 'Animated_Hammer',       mobType.NORMAL },
        { 'Animated_Horn',         mobType.NORMAL },
        { 'Animated_Knuckles',     mobType.NORMAL },
        { 'Animated_Kunai',        mobType.NORMAL },
        { 'Animated_Longbow',      mobType.NORMAL },
        { 'Animated_Longsword',    mobType.NORMAL },
        { 'Animated_Scythe',       mobType.NORMAL },
        { 'Animated_Shield',       mobType.NORMAL },
        { 'Animated_Spear',        mobType.NORMAL },
        { 'Animated_Staff',        mobType.NORMAL },
        { 'Animated_Tabar',        mobType.NORMAL },
        { 'Animated_Tachi',        mobType.NORMAL },
        { 'Count_Raum',            mobType.NORMAL },
        { 'Count_Vine',            mobType.NORMAL },
        { 'Count_Zaebos',          mobType.NORMAL },
        { 'Duke_Berith',           mobType.NORMAL },
        { 'Duke_Gomory',           mobType.NORMAL },
        { 'Duke_Scox',             mobType.NORMAL },
        { 'Kindreds_Avatar',       mobType.NORMAL },
        { 'Kindred_Bard',          mobType.NORMAL },
        { 'Kindred_Beastmaster',   mobType.NORMAL },
        { 'Kindred_Black_Mage',    mobType.NORMAL },
        { 'Kindred_Dark_Knight',   mobType.NORMAL },
        { 'Kindred_Dragoon',       mobType.NORMAL },
        { 'Kindred_Monk',          mobType.NORMAL },
        { 'Kindred_Ninja',         mobType.NORMAL },
        { 'Kindred_Paladin',       mobType.NORMAL },
        { 'Kindred_Ranger',        mobType.NORMAL },
        { 'Kindred_Red_Mage',      mobType.NORMAL },
        { 'Kindred_Samurai',       mobType.NORMAL },
        { 'Kindred_Summoner',      mobType.NORMAL },
        { 'Kindred_Thief',         mobType.NORMAL },
        { 'Kindreds_Vouivre',      mobType.NORMAL },
        { 'Kindred_Warrior',       mobType.NORMAL },
        { 'Kindred_White_Mage',    mobType.NORMAL },
        { 'Kindreds_Wyvern',       mobType.NORMAL },
        { 'King_Zagan',            mobType.NORMAL },
        { 'Marquis_Andras',        mobType.NORMAL },
        { 'Andrass_Vouivre',       mobType.NORMAL },
        { 'Marquis_Cimeries',      mobType.NORMAL },
        { 'Marquis_Decarabia',     mobType.NORMAL },
        { 'Marquis_Gamygyn',       mobType.NORMAL },
        { 'Marquis_Nebiros',       mobType.NORMAL },
        { 'Marquis_Orias',         mobType.NORMAL },
        { 'Marquis_Sabnak',        mobType.NORMAL },
        { 'Nebiross_Avatar',       mobType.NORMAL },
        { 'Prince_Seere',          mobType.NORMAL },
        { 'Satellite_Claymores',   mobType.NORMAL },
        { 'Satellite_Daggers',     mobType.NORMAL },
        { 'Satellite_Great_Axes',  mobType.NORMAL },
        { 'Satellite_Guns',        mobType.NORMAL },
        { 'Satellite_Hammers',     mobType.NORMAL },
        { 'Satellite_Horns',       mobType.NORMAL },
        { 'Satellite_Knuckles',    mobType.NORMAL },
        { 'Satellite_Kunai',       mobType.NORMAL },
        { 'Satellite_Longbows',    mobType.NORMAL },
        { 'Satellite_Longswords',  mobType.NORMAL },
        { 'Satellite_Scythes',     mobType.NORMAL },
        { 'Satellite_Shield',      mobType.NORMAL },
        { 'Satellite_Spears',      mobType.NORMAL },
        { 'Satellite_Staves',      mobType.NORMAL },
        { 'Satellite_Tabars',      mobType.NORMAL },
        { 'Satellite_Tachi',       mobType.NORMAL },
        { 'Statue_Prototype',      mobType.STATUE },
        { 'Tombstone_Prototype',   mobType.STATUE },
        { 'Vanguard_Dragon',       mobType.NORMAL },
        { 'Vanguard_Eye',          mobType.STATUE },
        { 'Yang',                  mobType.NORMAL },
        { 'Ying',                  mobType.NORMAL },
        { 'Zagans_Wyvern',         mobType.NORMAL },
    },
    ['Dynamis-Valkurm'] =
    {
        { 'Cirrate_Christelle',     mobType.BOSS      },
        { 'Adamantking_Effigy',     mobType.STATUE    },
        { 'Goblin_Replica',         mobType.STATUE    },
        { 'Manifest_Icon',          mobType.STATUE    },
        { 'Warchief_Tombstone',     mobType.STATUE    },
        { 'Fairy_Ring',             mobType.NORMAL    },
        { 'Nantina',                mobType.NORMAL    },
        { 'Nightmare_Fly',          mobType.NORMAL    },
        { 'Stcemqestcint',          mobType.NORMAL    },
        { 'Nightmare_Hippogryph',   mobType.NIGHTMARE },
        { 'Nightmare_Manticore',    mobType.NIGHTMARE },
        { 'Nightmare_Sabotender',   mobType.NIGHTMARE },
        { 'Nightmare_Sheep',        mobType.NIGHTMARE },
        { 'Vanguard_Alchemist',     mobType.NORMAL    },
        { 'Vanguard_Ambusher',      mobType.NORMAL    },
        { 'Vanguard_Amputator',     mobType.NORMAL    },
        { 'Vanguard_Armorer',       mobType.NORMAL    },
        { 'Vanguard_Assassin',      mobType.NORMAL    },
        { 'Vanguard_Backstabber',   mobType.NORMAL    },
        { 'Vanguard_Beasttender',   mobType.NORMAL    },
        { 'Vanguard_Bugler',        mobType.NORMAL    },
        { 'Vanguard_Chanter',       mobType.NORMAL    },
        { 'Vanguard_Constable',     mobType.NORMAL    },
        { 'Vanguard_Defender',      mobType.NORMAL    },
        { 'Vanguard_Dollmaster',    mobType.NORMAL    },
        { 'Vanguard_Dragontamer',   mobType.NORMAL    },
        { 'Vanguard_Drakekeeper',   mobType.NORMAL    },
        { 'Vanguard_Enchanter',     mobType.NORMAL    },
        { 'Vanguard_Exemplar',      mobType.NORMAL    },
        { 'Vanguard_Footsoldier',   mobType.NORMAL    },
        { 'Vanguard_Grappler',      mobType.NORMAL    },
        { 'Vanguard_Gutslasher',    mobType.NORMAL    },
        { 'Vanguard_Hatamoto',      mobType.NORMAL    },
        { 'Vanguard_Hawker',        mobType.NORMAL    },
        { 'Vanguard_Hitman',        mobType.NORMAL    },
        { 'Vanguard_Impaler',       mobType.NORMAL    },
        { 'Vanguard_Inciter',       mobType.NORMAL    },
        { 'Vanguard_Kusa',          mobType.NORMAL    },
        { 'Vanguard_Liberator',     mobType.NORMAL    },
        { 'Vanguard_Maestro',       mobType.NORMAL    },
        { 'Vanguard_Mason',         mobType.NORMAL    },
        { 'Vanguard_Mesmerizer',    mobType.NORMAL    },
        { 'Vanguard_Militant',      mobType.NORMAL    },
        { 'Vanguard_Minstrel',      mobType.NORMAL    },
        { 'Vanguard_Neckchopper',   mobType.NORMAL    },
        { 'Vanguard_Necromancer',   mobType.NORMAL    },
        { 'Vanguard_Ogresoother',   mobType.NORMAL    },
        { 'Vanguard_Oracle',        mobType.NORMAL    },
        { 'Vanguard_Partisan',      mobType.NORMAL    },
        { 'Vanguard_Pathfinder',    mobType.NORMAL    },
        { 'Vanguard_Persecutor',    mobType.NORMAL    },
        { 'Vanguard_Pillager',      mobType.NORMAL    },
        { 'Vanguard_Pitfighter',    mobType.NORMAL    },
        { 'Vanguard_Predator',      mobType.NORMAL    },
        { 'Vanguard_Prelate',       mobType.NORMAL    },
        { 'Vanguard_Priest',        mobType.NORMAL    },
        { 'Vanguard_Protector',     mobType.NORMAL    },
        { 'Vanguard_Purloiner',     mobType.NORMAL    },
        { 'Vanguard_Ronin',         mobType.NORMAL    },
        { 'Vanguard_Salvager',      mobType.NORMAL    },
        { 'Vanguard_Sentinel',      mobType.NORMAL    },
        { 'Vanguard_Shaman',        mobType.NORMAL    },
        { 'Vanguard_Skirmisher',    mobType.NORMAL    },
        { 'Vanguard_Smithy',        mobType.NORMAL    },
        { 'Vanguard_Thaumaturge',   mobType.NORMAL    },
        { 'Vanguard_Tinkerer',      mobType.NORMAL    },
        { 'Vanguard_Trooper',       mobType.NORMAL    },
        { 'Vanguard_Undertaker',    mobType.NORMAL    },
        { 'Vanguard_Vexer',         mobType.NORMAL    },
        { 'Vanguard_Vigilante',     mobType.NORMAL    },
        { 'Vanguard_Vindicator',    mobType.NORMAL    },
        { 'Vanguard_Visionary',     mobType.NORMAL    },
        { 'Vanguard_Welldigger',    mobType.NORMAL    },
    },
    ['Dynamis-Buburimu'] =
    {
        { 'Apocalyptic_Beast',        mobType.BOSS      },
        { 'Dragons_Wyvern',           mobType.NORMAL    },
        { 'Adamantking_Effigy',       mobType.STATUE    },
        { 'Manifest_Icon',            mobType.STATUE    },
        { 'Warchief_Tombstone',       mobType.STATUE    },
        { 'Goblin_Replica',           mobType.STATUE    },
        { 'Nightmare_Bunny',          mobType.NIGHTMARE },
        { 'Nightmare_Cockatrice',     mobType.NIGHTMARE },
        { 'Nightmare_Crab',           mobType.NIGHTMARE },
        { 'Nightmare_Crawler',        mobType.NIGHTMARE },
        { 'Nightmare_Dhalmel',        mobType.NIGHTMARE },
        { 'Nightmare_Eft',            mobType.NIGHTMARE },
        { 'Nightmare_Mandragora',     mobType.NIGHTMARE },
        { 'Nightmare_Raven',          mobType.NIGHTMARE },
        { 'Nightmare_Scorpion',       mobType.NIGHTMARE },
        { 'Nightmare_Uragnite',       mobType.NIGHTMARE },
        { 'Baa_Dava_the_Bibliophage', mobType.NORMAL    },
        { 'Doo_Peku_the_Fleetfoot',   mobType.NORMAL    },
        { 'Elvaansticker_Bxafraff',   mobType.NORMAL    },
        { 'Flamecaller_Zoeqdoq',      mobType.NORMAL    },
        { 'GiBhe_Fleshfeaster',       mobType.NORMAL    },
        { 'Gosspix_Blabberlips',      mobType.NORMAL    },
        { 'Hamfist_Gukhbuk',          mobType.NORMAL    },
        { 'Koo_Rahi_the_Levinblade',  mobType.NORMAL    },
        { 'Lyncean_Juwgneg',          mobType.NORMAL    },
        { 'QuPho_Bloodspiller',       mobType.NORMAL    },
        { 'Ree_Nata_the_Melomanic',   mobType.NORMAL    },
        { 'Shamblix_Rottenheart',     mobType.NORMAL    },
        { 'TeZha_Ironclad',           mobType.NORMAL    },
        { 'Vanguard_Alchemist',       mobType.NORMAL    },
        { 'Vanguard_Ambusher',        mobType.NORMAL    },
        { 'Vanguard_Amputator',       mobType.NORMAL    },
        { 'Vanguard_Armorer',         mobType.NORMAL    },
        { 'Vanguard_Assassin',        mobType.NORMAL    },
        { 'Vanguards_Avatar',         mobType.NORMAL    },
        { 'Vanguard_Backstabber',     mobType.NORMAL    },
        { 'Vanguard_Beasttender',     mobType.NORMAL    },
        { 'Vanguard_Bugler',          mobType.NORMAL    },
        { 'Vanguard_Chanter',         mobType.NORMAL    },
        { 'Vanguard_Constable',       mobType.NORMAL    },
        { 'Vanguard_Defender',        mobType.NORMAL    },
        { 'Vanguard_Dollmaster',      mobType.NORMAL    },
        { 'Vanguard_Dragontamer',     mobType.NORMAL    },
        { 'Vanguard_Drakekeeper',     mobType.NORMAL    },
        { 'Vanguard_Enchanter',       mobType.NORMAL    },
        { 'Vanguard_Exemplar',        mobType.NORMAL    },
        { 'Vanguard_Footsoldier',     mobType.NORMAL    },
        { 'Vanguard_Grappler',        mobType.NORMAL    },
        { 'Vanguard_Gutslasher',      mobType.NORMAL    },
        { 'Vanguard_Hatamoto',        mobType.NORMAL    },
        { 'Vanguard_Hawker',          mobType.NORMAL    },
        { 'Vanguard_Hitman',          mobType.NORMAL    },
        { 'Vanguard_Impaler',         mobType.NORMAL    },
        { 'Vanguard_Inciter',         mobType.NORMAL    },
        { 'Vanguard_Kusa',            mobType.NORMAL    },
        { 'Vanguard_Liberator',       mobType.NORMAL    },
        { 'Vanguard_Maestro',         mobType.NORMAL    },
        { 'Vanguard_Mason',           mobType.NORMAL    },
        { 'Vanguard_Mesmerizer',      mobType.NORMAL    },
        { 'Vanguard_Militant',        mobType.NORMAL    },
        { 'Vanguard_Minstrel',        mobType.NORMAL    },
        { 'Vanguard_Neckchopper',     mobType.NORMAL    },
        { 'Vanguard_Necromancer',     mobType.NORMAL    },
        { 'Vanguard_Ogresoother',     mobType.NORMAL    },
        { 'Vanguard_Oracle',          mobType.NORMAL    },
        { 'Vanguard_Partisan',        mobType.NORMAL    },
        { 'Vanguard_Pathfinder',      mobType.NORMAL    },
        { 'Vanguard_Persecutor',      mobType.NORMAL    },
        { 'Vanguard_Pillager',        mobType.NORMAL    },
        { 'Vanguard_Pitfighter',      mobType.NORMAL    },
        { 'Vanguard_Predator',        mobType.NORMAL    },
        { 'Vanguard_Prelate',         mobType.NORMAL    },
        { 'Vanguard_Priest',          mobType.NORMAL    },
        { 'Vanguard_Protector',       mobType.NORMAL    },
        { 'Vanguard_Purloiner',       mobType.NORMAL    },
        { 'Vanguard_Ronin',           mobType.NORMAL    },
        { 'Vanguard_Salvager',        mobType.NORMAL    },
        { 'Vanguard_Sentinel',        mobType.NORMAL    },
        { 'Vanguard_Shaman',          mobType.NORMAL    },
        { 'Vanguard_Skirmisher',      mobType.NORMAL    },
        { 'Vanguard_Smithy',          mobType.NORMAL    },
        { 'Vanguard_Thaumaturge',     mobType.NORMAL    },
        { 'Vanguard_Tinkerer',        mobType.NORMAL    },
        { 'Vanguard_Trooper',         mobType.NORMAL    },
        { 'Vanguard_Undertaker',      mobType.NORMAL    },
        { 'Vanguard_Vexer',           mobType.NORMAL    },
        { 'Vanguard_Vigilante',       mobType.NORMAL    },
        { 'Vanguard_Vindicator',      mobType.NORMAL    },
        { 'Vanguard_Visionary',       mobType.NORMAL    },
        { 'Vanguard_Welldigger',      mobType.NORMAL    },
        { 'Vanguards_Wyvern',         mobType.NORMAL    },
        { 'VaRhu_Bodysnatcher',       mobType.NORMAL    },
        { 'Aitvaras',                 mobType.BOSS      },
        { 'Alklha',                   mobType.BOSS      },
        { 'Barong',                   mobType.BOSS      },
        { 'Basilic',                  mobType.BOSS      },
        { 'Koshchei',                 mobType.BOSS      },
        { 'Stihi',                    mobType.BOSS      },
        { 'Stollenwurm',              mobType.BOSS      },
        { 'Tarasca',                  mobType.BOSS      },
        { 'Jurik',                    mobType.BOSS      },
        { 'Vishap',                   mobType.BOSS      },
    },
    ['Dynamis-Tavnazia'] =
    {
        { 'Diabolos_Club',       mobType.NORMAL    },
        { 'Diabolos_Diamond',    mobType.NORMAL    },
        { 'Diabolos_Heart',      mobType.NORMAL    },
        { 'Diabolos_Spade',      mobType.NORMAL    },
        { 'Umbral_Diabolos',     mobType.NORMAL    },
        { 'Diaboloss_Shard',     mobType.NORMAL    },
        { 'Vanguard_Eye',        mobType.STATUE    },
        { 'Hydra_Bard',          mobType.NORMAL    },
        { 'Hydra_Beastmaster',   mobType.NORMAL    },
        { 'Hydra_Black_Mage',    mobType.NORMAL    },
        { 'Hydra_Dark_Knight',   mobType.NORMAL    },
        { 'Hydra_Dragoon',       mobType.NORMAL    },
        { 'Hydra_Monk',          mobType.NORMAL    },
        { 'Hydra_Ninja',         mobType.NORMAL    },
        { 'Hydra_Paladin',       mobType.NORMAL    },
        { 'Hydra_Ranger',        mobType.NORMAL    },
        { 'Hydra_Red_Mage',      mobType.NORMAL    },
        { 'Hydra_Samurai',       mobType.NORMAL    },
        { 'Hydra_Summoner',      mobType.NORMAL    },
        { 'Hydra_Thief',         mobType.NORMAL    },
        { 'Hydra_Warrior',       mobType.NORMAL    },
        { 'Hydra_White_Mage',    mobType.NORMAL    },
        { 'Hydras_Hound',        mobType.NORMAL    },
        { 'Hydras_Avatar',       mobType.NORMAL    },
        { 'Hydras_Wyvern',       mobType.NORMAL    },
        { 'Kindred_Bard',        mobType.NORMAL    },
        { 'Kindred_Beastmaster', mobType.NORMAL    },
        { 'Kindred_Black_Mage',  mobType.NORMAL    },
        { 'Kindred_Dark_Knight', mobType.NORMAL    },
        { 'Kindred_Dragoon',     mobType.NORMAL    },
        { 'Kindred_Monk',        mobType.NORMAL    },
        { 'Kindred_Ninja',       mobType.NORMAL    },
        { 'Kindred_Paladin',     mobType.NORMAL    },
        { 'Kindred_Ranger',      mobType.NORMAL    },
        { 'Kindred_Red_Mage',    mobType.NORMAL    },
        { 'Kindred_Samurai',     mobType.NORMAL    },
        { 'Kindred_Summoner',    mobType.NORMAL    },
        { 'Kindred_Thief',       mobType.NORMAL    },
        { 'Kindred_Warrior',     mobType.NORMAL    },
        { 'Kindred_White_Mage',  mobType.NORMAL    },
        { 'Kindreds_Vouivre',    mobType.NORMAL    },
        { 'Kindreds_Avatar',     mobType.NORMAL    },
        { 'Kindreds_Wyvern',     mobType.NORMAL    },
        { 'Nightmare_Antlion',   mobType.NIGHTMARE },
        { 'Nightmare_Bugard',    mobType.NIGHTMARE },
        { 'Nightmare_Cluster',   mobType.NIGHTMARE },
        { 'Nightmare_Hornet',    mobType.NIGHTMARE },
        { 'Nightmare_Leech',     mobType.NIGHTMARE },
        { 'Nightmare_Makara',    mobType.NIGHTMARE },
        { 'Nightmare_Taurus',    mobType.NIGHTMARE },
        { 'Nightmare_Worm',      mobType.NIGHTMARE },
    }
}

-- Helper function for dynamis zone overrides in order to provide clear structure (hopefully?)
-- This overrides the zone scripts for dynamis zones to call dynamis functions
-- onInitialize
-- onZoneOut
-- onZoneIn
-- onZoneTick
-- Special cases for SJ zones (7-9) and Tavnazia (10) for NPCs qm0 and qm1
local function registerDynamisZoneOverrides(zoneID, zoneName, zoneNumber)
    m:addOverride(string.format('xi.zones.%s.Zone.onInitialize', zoneName),
    function(zone)
        if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
            xi.dynamis.onZoneInitTav(zone)
        end
    end)

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
local function noMobDespawn()
end

-- Zone and mob specific hooks for special NM behavior
-- The functions you call must bc xi.dynamis.[functionamme] and the parameters must bc the same as the original functions
local specialMobHooks =
{
    ['Dynamis-Buburimu'] =
    {
        -- Example
        -- Aitvaras =
        -- {
        --     onMobSpawn = 'aitvarasSpawn',
        -- },
        -- Alklha =
        -- {
        --     onMobSpawn = 'alklhaSpawn',
        -- },
        Apocalyptic_Beast =
        {
            onMobSpawn = 'apocBeastSpawn',
            onMobRoam  = 'apocBeastRoam',
        },
    },
}

local function runSpecialMobHook(zoneName, mobName, eventName, ...)
    local zoneHooks = specialMobHooks[zoneName]
    if not zoneHooks then
        return
    end

    local mobHooks = zoneHooks[mobName]
    if not mobHooks then
        return
    end

    local hook = mobHooks[eventName]
    if not hook then
        return
    end

    if type(hook) == 'string' then
        hook = xi.dynamis[hook]
    end

    if type(hook) == 'function' then
        hook(...)
    end
end

local function hasSpecialMobHook(zoneName, mobName, eventName)
    local zoneHooks = specialMobHooks[zoneName]
    local mobHooks  = zoneHooks and zoneHooks[mobName]

    return mobHooks and mobHooks[eventName] ~= nil
end

local mobOverrideHandlers =
{
    [mobType.STATUE] =
    {
        onMobSpawn = function(mob)
            xi.dynamis.statueOnSpawn(mob)
        end,

        onMobEngage = function(mob, target)
            xi.dynamis.mobOnEngage(mob, target)
            xi.dynamis.checkEyeColor(mob)
        end,

        onMobRoam = function(mob)
            xi.dynamis.onMobRoam(mob)
        end,

        onMobFight = function(mob, target)
            xi.dynamis.onStatueFight(mob, target)
        end,

        onMobDeath = function(mob, player, optParams)
            xi.dynamis.onStatueDeath(mob, player, optParams)
        end,

        onMobDespawn = noMobDespawn,
    },

    [mobType.BOSS] =
    {
        onMobInitialize = function(mob)
            xi.dynamis.onBossInitialize(mob)
        end,

        onMobSpawn = function(mob)
            xi.dynamis.onBossSpawn(mob)
        end,

        onMobEngage = function(mob, target)
            xi.dynamis.mobOnEngage(mob, target)
            xi.dynamis.onBossEngage(mob, target)
        end,

        onMobRoam = function(mob)
            xi.dynamis.onMobRoam(mob)
            xi.dynamis.onBossRoam(mob)
        end,

        onMobDeath = function(mob, player, optParams)
            xi.dynamis.onBossDeath(mob, player, optParams)
        end,

        onMobDespawn = noMobDespawn,
    },

    [mobType.NORMAL] =
    {
        onMobSpawn = function(mob)
            xi.dynamis.onMobSpawn(mob, mobType.NORMAL)
        end,

        onMobRoam = function(mob)
            xi.dynamis.onMobRoam(mob)
        end,

        onMobDeath = function(mob, player, optParams)
            xi.dynamis.onMobDeath(mob, player, optParams)
        end,

        onMobDespawn = noMobDespawn,
    },

    [mobType.NIGHTMARE] =
    {
        onMobSpawn = function(mob)
            xi.dynamis.onMobSpawn(mob, mobType.NIGHTMARE)
        end,

        onMobEngage = function(mob, target)
            xi.dynamis.mobOnEngage(mob, target)
        end,

        onMobRoam = function(mob)
            xi.dynamis.onMobRoam(mob)
        end,

        onMobDeath = function(mob, player, optParams)
            xi.dynamis.onMobDeath(mob, player, optParams)
        end,

        onMobDespawn = noMobDespawn,
    },
}

local mobOverrideOrder =
{
    'onMobInitialize',
    'onMobSpawn',
    'onMobEngage',
    'onMobRoam',
    'onMobFight',
    'onMobDeath',
    'onMobDespawn',
}

local function registerMobOverrides(zoneName, mobName, overrideMobType)
    local mobPath  = string.format('xi.zones.%s.mobs.%s', zoneName, mobName)
    local handlers = mobOverrideHandlers[overrideMobType]
    if not handlers then
        return
    end

    for _, eventName in ipairs(mobOverrideOrder) do
        local handler    = handlers[eventName]
        local hasMobHook = hasSpecialMobHook(zoneName, mobName, eventName)

        if handler or hasMobHook then
            m:addOverride(mobPath .. '.' .. eventName, function(...)
                if handler then
                    handler(...)
                end

                runSpecialMobHook(zoneName, mobName, eventName, ...)
            end)
        end
    end
end

-- Register all mob overrides from the mobNames table
for zoneName, mobs in pairs(mobNames) do
    if mobs then
        for _, mobEntry in ipairs(mobs) do
            local mobName = mobEntry[1]
            local overrideMobType = mobEntry[2]
            registerMobOverrides(zoneName, mobName, overrideMobType)
        end
    end
end

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
