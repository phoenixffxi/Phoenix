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
    -- 'name', mobtype, modelsize
    ['Dynamis-San_dOria'] =
    {
        { 'Overlords_Tombstone',     mobType.BOSS  , 3 },
        { 'Serjeant_Tombstone',      mobType.STATUE, 1 },
        { 'Warchief_Tombstone',      mobType.STATUE, 1 },
        { 'Battlechoir_Gitchfotch',  mobType.NORMAL, 3 },
        { 'Reapertongue_Gadgquok',   mobType.NORMAL, 3 },
        { 'Soulsender_Fugbrag',      mobType.NORMAL, 3 },
        { 'Voidstreaker_Butchnotch', mobType.NORMAL, 3 },
        { 'Wyrmgnasher_Bjakdek',     mobType.NORMAL, 3 },
        { 'Vanguard_Amputator',      mobType.NORMAL, 2 },
        { 'Vanguard_Backstabber',    mobType.NORMAL, 2 },
        { 'Vanguard_Bugler',         mobType.NORMAL, 2 },
        { 'Vanguard_Dollmaster',     mobType.NORMAL, 2 },
        { 'Vanguard_Footsoldier',    mobType.NORMAL, 2 },
        { 'Vanguard_Grappler',       mobType.NORMAL, 2 },
        { 'Vanguard_Gutslasher',     mobType.NORMAL, 2 },
        { 'Vanguard_Hawker',         mobType.NORMAL, 2 },
        { 'Vanguard_Impaler',        mobType.NORMAL, 2 },
        { 'Vanguard_Mesmerizer',     mobType.NORMAL, 2 },
        { 'Vanguard_Neckchopper',    mobType.NORMAL, 2 },
        { 'Vanguard_Pillager',       mobType.NORMAL, 2 },
        { 'Vanguard_Predator',       mobType.NORMAL, 2 },
        { 'Vanguard_Trooper',        mobType.NORMAL, 2 },
        { 'Vanguard_Vexer',          mobType.NORMAL, 2 },
        { 'Vanguards_Avatar',        mobType.NORMAL, 2 },
        { 'Vanguards_Hecteyes',      mobType.NORMAL, 2 },
        { 'Vanguards_Wyvern',        mobType.NORMAL, 2 },
    },
    ['Dynamis-Bastok'] =
    {
        { 'GuDha_Effigy',         mobType.BOSS  , 3 },
        { 'Adamantking_Effigy',   mobType.STATUE, 1 },
        { 'AaNyu_Dismantler',     mobType.NORMAL, 3 },
        { 'BeEbo_Tortoisedriver', mobType.NORMAL, 3 },
        { 'Effigy_Shield',        mobType.NORMAL, 3 },
        { 'GiPha_Manameister',    mobType.NORMAL, 3 },
        { 'GuNhi_Noondozer',      mobType.NORMAL, 3 },
        { 'KoDho_Cannonball',     mobType.NORMAL, 3 },
        { 'ZeVho_Fallsplitter',   mobType.NORMAL, 3 },
        { 'Vanguard_Beasttender', mobType.NORMAL, 2 },
        { 'Vanguard_Constable',   mobType.NORMAL, 2 },
        { 'Vanguard_Defender',    mobType.NORMAL, 2 },
        { 'Vanguard_Drakekeeper', mobType.NORMAL, 2 },
        { 'Vanguard_Hatamoto',    mobType.NORMAL, 2 },
        { 'Vanguard_Kusa',        mobType.NORMAL, 2 },
        { 'Vanguard_Mason',       mobType.NORMAL, 2 },
        { 'Vanguard_Militant',    mobType.NORMAL, 2 },
        { 'Vanguard_Minstrel',    mobType.NORMAL, 2 },
        { 'Vanguard_Protector',   mobType.NORMAL, 2 },
        { 'Vanguard_Purloiner',   mobType.NORMAL, 2 },
        { 'Vanguard_Thaumaturge', mobType.NORMAL, 2 },
        { 'Vanguard_Undertaker',  mobType.NORMAL, 2 },
        { 'Vanguard_Vigilante',   mobType.NORMAL, 2 },
        { 'Vanguard_Vindicator',  mobType.NORMAL, 2 },
        { 'Vanguards_Avatar',     mobType.NORMAL, 2 },
        { 'Vanguards_Scorpion',   mobType.NORMAL, 2 },
        { 'Vanguards_Wyvern',     mobType.NORMAL, 2 },
    },
    ['Dynamis-Windurst'] =
    {
        { 'Tzee_Xicu_Idol',          mobType.BOSS  , 3 },
        { 'Avatar_Icon',             mobType.STATUE, 1 },
        { 'Avatar_Idol',             mobType.STATUE, 1 },
        { 'Manifest_Icon',           mobType.STATUE, 1 },
        { 'Haa_Pevi_the_Stentorian', mobType.NORMAL, 3 },
        { 'Loo_Hepe_the_Eyepiercer', mobType.NORMAL, 3 },
        { 'Maa_Febi_the_Steadfast',  mobType.NORMAL, 3 },
        { 'Muu_Febi_the_Steadfast',  mobType.NORMAL, 3 },
        { 'Wuu_Qoho_the_Razorclaw',  mobType.NORMAL, 3 },
        { 'Xoo_Kaza_the_Solemn',     mobType.NORMAL, 3 },
        { 'Vanguard_Assassin',       mobType.NORMAL, 2 },
        { 'Vanguard_Chanter',        mobType.NORMAL, 2 },
        { 'Vanguard_Exemplar',       mobType.NORMAL, 2 },
        { 'Vanguard_Inciter',        mobType.NORMAL, 2 },
        { 'Vanguard_Liberator',      mobType.NORMAL, 2 },
        { 'Vanguard_Ogresoother',    mobType.NORMAL, 2 },
        { 'Vanguard_Oracle',         mobType.NORMAL, 2 },
        { 'Vanguard_Partisan',       mobType.NORMAL, 2 },
        { 'Vanguard_Persecutor',     mobType.NORMAL, 2 },
        { 'Vanguard_Prelate',        mobType.NORMAL, 2 },
        { 'Vanguard_Priest',         mobType.NORMAL, 2 },
        { 'Vanguard_Salvager',       mobType.NORMAL, 2 },
        { 'Vanguard_Sentinel',       mobType.NORMAL, 2 },
        { 'Vanguard_Skirmisher',     mobType.NORMAL, 2 },
        { 'Vanguard_Visionary',      mobType.NORMAL, 2 },
        { 'Vanguards_Avatar',        mobType.NORMAL, 2 },
        { 'Vanguards_Crow',          mobType.NORMAL, 2 },
        { 'Vanguards_Wyvern',        mobType.NORMAL, 2 },
    },
    ['Dynamis-Jeuno'] =
    {
        { 'Goblin_Golem',           mobType.BOSS  , 3 },
        { 'Goblin_Replica',         mobType.STATUE, 1 },
        { 'Goblin_Statue',          mobType.STATUE, 1 },
        { 'Anvilix_Sootwrists',     mobType.NORMAL, 3 },
        { 'Bandrix_Rockjaw',        mobType.NORMAL, 3 },
        { 'Blazox_Boneybod',        mobType.NORMAL, 3 },
        { 'Bootrix_Jaggedelbow',    mobType.NORMAL, 3 },
        { 'Buffrix_Eargone',        mobType.NORMAL, 3 },
        { 'Cloktix_Longnail',       mobType.NORMAL, 3 },
        { 'Distilix_Stickytoes',    mobType.NORMAL, 3 },
        { 'Elixmix_Hooknose',       mobType.NORMAL, 3 },
        { 'Eremix_Snottynostril',   mobType.NORMAL, 3 },
        { 'Gabblox_Magpietongue',   mobType.NORMAL, 3 },
        { 'Hermitrix_Toothrot',     mobType.NORMAL, 3 },
        { 'Humnox_Drumbelly',       mobType.NORMAL, 3 },
        { 'Jabbrox_Grannyguise',    mobType.NORMAL, 3 },
        { 'Jabkix_Pigeonpecs',      mobType.NORMAL, 3 },
        { 'Karashix_Swollenskull',  mobType.NORMAL, 3 },
        { 'Kikklix_Longlegs',       mobType.NORMAL, 3 },
        { 'Lurklox_Dhalmelneck',    mobType.NORMAL, 3 },
        { 'Mobpix_Mucousmouth',     mobType.NORMAL, 3 },
        { 'Morgmox_Moldnoggin',     mobType.NORMAL, 3 },
        { 'Mortilox_Wartpaws',      mobType.NORMAL, 3 },
        { 'Prowlox_Barrelbelly',    mobType.NORMAL, 3 },
        { 'Rutrix_Hamgams',         mobType.NORMAL, 3 },
        { 'Scruffix_Shaggychest',   mobType.NORMAL, 3 },
        { 'Slystix_Megapeepers',    mobType.NORMAL, 3 },
        { 'Smeltix_Thickhide',      mobType.NORMAL, 3 },
        { 'Snypestix_Eaglebeak',    mobType.NORMAL, 3 },
        { 'Sparkspox_Sweatbrow',    mobType.NORMAL, 3 },
        { 'Ticktox_Beadyeyes',      mobType.NORMAL, 3 },
        { 'Trailblix_Goatmug',      mobType.NORMAL, 3 },
        { 'Tufflix_Loglimbs',       mobType.NORMAL, 3 },
        { 'Tymexox_Ninefingers',    mobType.NORMAL, 3 },
        { 'Wasabix_Callusdigit',    mobType.NORMAL, 3 },
        { 'Wyrmwix_Snakespecs',     mobType.NORMAL, 3 },
        { 'Vanguard_Alchemist',     mobType.NORMAL, 2 },
        { 'Vanguard_Ambusher',      mobType.NORMAL, 2 },
        { 'Vanguard_Armorer',       mobType.NORMAL, 2 },
        { 'Vanguard_Dragontamer',   mobType.NORMAL, 2 },
        { 'Vanguard_Enchanter',     mobType.NORMAL, 2 },
        { 'Vanguard_Hitman',        mobType.NORMAL, 2 },
        { 'Vanguard_Maestro',       mobType.NORMAL, 2 },
        { 'Vanguard_Necromancer',   mobType.NORMAL, 2 },
        { 'Vanguard_Pathfinder',    mobType.NORMAL, 2 },
        { 'Vanguard_Pitfighter',    mobType.NORMAL, 2 },
        { 'Vanguard_Ronin',         mobType.NORMAL, 2 },
        { 'Vanguard_Shaman',        mobType.NORMAL, 2 },
        { 'Vanguard_Smithy',        mobType.NORMAL, 2 },
        { 'Vanguard_Tinkerer',      mobType.NORMAL, 2 },
        { 'Vanguard_Welldigger',    mobType.NORMAL, 2 },
        { 'Vanguards_Avatar',       mobType.NORMAL, 2 },
        { 'Vanguards_Slime',        mobType.NORMAL, 2 },
        { 'Vanguards_Wyvern',       mobType.NORMAL, 2 },
    },
    ['Dynamis-Beaucedine'] =
    {
        { 'Angra_Mainyu',            mobType.BOSS  , 1 },
        { 'Adamantking_Effigy',      mobType.STATUE, 1 },
        { 'Avatar_Icon',             mobType.STATUE, 1 },
        { 'Goblin_Replica',          mobType.STATUE, 1 },
        { 'Dynamis_Effigy',          mobType.STATUE, 1 },
        { 'Dynamis_Icon',            mobType.STATUE, 1 },
        { 'Dynamis_Statue',          mobType.STATUE, 1 },
        { 'Dynamis_Tombstone',       mobType.STATUE, 1 },
        { 'Vanguard_Eye',            mobType.STATUE, 1 },
        { 'Serjeant_Tombstone',      mobType.STATUE, 1 },
        { 'Ascetox_Ratgums',         mobType.NORMAL, 1 },
        { 'BeZhe_Keeprazer',         mobType.NORMAL, 1 },
        { 'Bhuu_Wjato_the_Firepool', mobType.NORMAL, 1 },
        { 'Bordox_Kittyback',        mobType.NORMAL, 1 },
        { 'Brewnix_Bittypupils',     mobType.NORMAL, 1 },
        { 'Caa_Xaza_the_Madpiercer', mobType.NORMAL, 1 },
        { 'Cobraclaw_Buchzvotch',    mobType.NORMAL, 1 },
        { 'Dagourmarche',            mobType.NORMAL, 1 },
        { 'Dagourmarches_Avatar',    mobType.NORMAL, 1 },
        { 'Dagourmarches_Wyvern',    mobType.NORMAL, 1 },
        { 'Deathcaller_Bidfbid',     mobType.NORMAL, 1 },
        { 'DeBho_Pyrohand',          mobType.NORMAL, 1 },
        { 'Drakefeast_Wubmfub',      mobType.NORMAL, 1 },
        { 'Draklix_Scalecrust',      mobType.NORMAL, 1 },
        { 'Droprix_Granitepalms',    mobType.NORMAL, 1 },
        { 'Elvaanlopper_Grokdok',    mobType.NORMAL, 1 },
        { 'Foo_Peku_the_Bloodcloak', mobType.NORMAL, 1 },
        { 'GaFho_Venomtouch',        mobType.NORMAL, 1 },
        { 'Galkarider_Retzpratz',    mobType.NORMAL, 1 },
        { 'Gibberox_Pimplebeak',     mobType.NORMAL, 1 },
        { 'GoTyo_Magenapper',        mobType.NORMAL, 1 },
        { 'Goublefaupe',             mobType.NORMAL, 1 },
        { 'GuKhu_Dukesniper',        mobType.NORMAL, 1 },
        { 'GuNha_Wallstormer',       mobType.NORMAL, 1 },
        { 'Guu_Waji_the_Preacher',   mobType.NORMAL, 1 },
        { 'Heavymail_Djidzbad',      mobType.NORMAL, 1 },
        { 'Hee_Mida_the_Meticulous', mobType.NORMAL, 1 },
        { 'Humegutter_Adzjbadj',     mobType.NORMAL, 1 },
        { 'Jeunoraider_Gepkzip',     mobType.NORMAL, 1 },
        { 'JiFhu_Infiltrator',       mobType.NORMAL, 1 },
        { 'JiKhu_Towercleaver',      mobType.NORMAL, 1 },
        { 'Knii_Hoqo_the_Bisector',  mobType.NORMAL, 1 },
        { 'Koo_Saxu_the_Everfast',   mobType.NORMAL, 1 },
        { 'Kuu_Xuka_the_Nimble',     mobType.NORMAL, 1 },
        { 'Lockbuster_Zapdjipp',     mobType.NORMAL, 1 },
        { 'Maa_Zaua_the_Wyrmkeeper', mobType.NORMAL, 1 },
        { 'Mildaunegeux',            mobType.NORMAL, 1 },
        { 'MiRhe_Whisperblade',      mobType.NORMAL, 1 },
        { 'Mithraslaver_Debhabob',   mobType.NORMAL, 1 },
        { 'Moltenox_Stubthumbs',     mobType.NORMAL, 1 },
        { 'Morblox_Chubbychin',      mobType.NORMAL, 1 },
        { 'MuGha_Legionkiller',      mobType.NORMAL, 1 },
        { 'NaHya_Floodmaker',        mobType.NORMAL, 1 },
        { 'Nee_Huxa_the_Judgmental', mobType.NORMAL, 1 },
        { 'NuBhi_Spiraleye',         mobType.NORMAL, 1 },
        { 'Puu_Timu_the_Phantasmal', mobType.NORMAL, 1 },
        { 'Quiebitiel',              mobType.NORMAL, 1 },
        { 'Routsix_Rubbertendon',    mobType.NORMAL, 1 },
        { 'Ruffbix_Jumbolobes',      mobType.NORMAL, 1 },
        { 'Ryy_Qihi_the_Idolrobber', mobType.NORMAL, 1 },
        { 'Shisox_Widebrow',         mobType.NORMAL, 1 },
        { 'Skinmask_Ugghfogg',       mobType.NORMAL, 1 },
        { 'Slinkix_Trufflesniff',    mobType.NORMAL, 1 },
        { 'SoGho_Adderhandler',      mobType.NORMAL, 1 },
        { 'Soo_Jopo_the_Fiendking',  mobType.NORMAL, 1 },
        { 'SoZho_Metalbender',       mobType.NORMAL, 1 },
        { 'Spinalsucker_Galflmall',  mobType.NORMAL, 1 },
        { 'Swypestix_Tigershins',    mobType.NORMAL, 1 },
        { 'TaHyu_Gallanthunter',     mobType.NORMAL, 1 },
        { 'Taruroaster_Biggsjig',    mobType.NORMAL, 1 },
        { 'Tocktix_Thinlids',        mobType.NORMAL, 1 },
        { 'Ultrasonic_Zeknajak',     mobType.NORMAL, 1 },
        { 'Velosareon',              mobType.NORMAL, 1 },
        { 'Whistrix_Toadthroat',     mobType.NORMAL, 1 },
        { 'Wraithdancer_Gidbnod',    mobType.NORMAL, 1 },
        { 'Xaa_Chau_the_Roctalon',   mobType.NORMAL, 1 },
        { 'Xhoo_Fuza_the_Sublime',   mobType.NORMAL, 1 },
        { 'Fire_Pukis',              mobType.NORMAL, 1 },
        { 'Petro_Pukis',             mobType.NORMAL, 1 },
        { 'Poison_Pukis',            mobType.NORMAL, 1 },
        { 'Wind_Pukis',              mobType.NORMAL, 1 },
        { 'Hydra_Bard',              mobType.NORMAL, 1 },
        { 'Hydra_Beastmaster',       mobType.NORMAL, 1 },
        { 'Hydra_Black_Mage',        mobType.NORMAL, 1 },
        { 'Hydra_Dark_Knight',       mobType.NORMAL, 1 },
        { 'Hydra_Dragoon',           mobType.NORMAL, 1 },
        { 'Hydra_Monk',              mobType.NORMAL, 1 },
        { 'Hydra_Ninja',             mobType.NORMAL, 1 },
        { 'Hydra_Paladin',           mobType.NORMAL, 1 },
        { 'Hydra_Ranger',            mobType.NORMAL, 1 },
        { 'Hydra_Red_Mage',          mobType.NORMAL, 1 },
        { 'Hydra_Samurai',           mobType.NORMAL, 1 },
        { 'Hydra_Summoner',          mobType.NORMAL, 1 },
        { 'Hydra_Thief',             mobType.NORMAL, 1 },
        { 'Hydra_Warrior',           mobType.NORMAL, 1 },
        { 'Hydra_White_Mage',        mobType.NORMAL, 1 },
        { 'Hydras_Avatar',           mobType.NORMAL, 1 },
        { 'Hydras_Hound',            mobType.NORMAL, 1 },
        { 'Hydras_Wyvern',           mobType.NORMAL, 1 },
        { 'Vanguard_Alchemist',      mobType.NORMAL, 1 },
        { 'Vanguard_Ambusher',       mobType.NORMAL, 1 },
        { 'Vanguard_Amputator',      mobType.NORMAL, 1 },
        { 'Vanguard_Armorer',        mobType.NORMAL, 1 },
        { 'Vanguard_Assassin',       mobType.NORMAL, 1 },
        { 'Vanguard_Backstabber',    mobType.NORMAL, 1 },
        { 'Vanguard_Beasttender',    mobType.NORMAL, 1 },
        { 'Vanguard_Bugler',         mobType.NORMAL, 1 },
        { 'Vanguard_Chanter',        mobType.NORMAL, 1 },
        { 'Vanguard_Constable',      mobType.NORMAL, 1 },
        { 'Vanguard_Defender',       mobType.NORMAL, 1 },
        { 'Vanguard_Dollmaster',     mobType.NORMAL, 1 },
        { 'Vanguard_Dragontamer',    mobType.NORMAL, 1 },
        { 'Vanguard_Drakekeeper',    mobType.NORMAL, 1 },
        { 'Vanguard_Enchanter',      mobType.NORMAL, 1 },
        { 'Vanguard_Exemplar',       mobType.NORMAL, 1 },
        { 'Vanguard_Footsoldier',    mobType.NORMAL, 1 },
        { 'Vanguard_Grappler',       mobType.NORMAL, 1 },
        { 'Vanguard_Gutslasher',     mobType.NORMAL, 1 },
        { 'Vanguard_Hatamoto',       mobType.NORMAL, 1 },
        { 'Vanguard_Hawker',         mobType.NORMAL, 1 },
        { 'Vanguard_Hitman',         mobType.NORMAL, 1 },
        { 'Vanguard_Impaler',        mobType.NORMAL, 1 },
        { 'Vanguard_Inciter',        mobType.NORMAL, 1 },
        { 'Vanguard_Kusa',           mobType.NORMAL, 1 },
        { 'Vanguard_Liberator',      mobType.NORMAL, 1 },
        { 'Vanguard_Maestro',        mobType.NORMAL, 1 },
        { 'Vanguard_Mason',          mobType.NORMAL, 1 },
        { 'Vanguard_Mesmerizer',     mobType.NORMAL, 1 },
        { 'Vanguard_Militant',       mobType.NORMAL, 1 },
        { 'Vanguard_Minstrel',       mobType.NORMAL, 1 },
        { 'Vanguard_Neckchopper',    mobType.NORMAL, 1 },
        { 'Vanguard_Necromancer',    mobType.NORMAL, 1 },
        { 'Vanguard_Ogresoother',    mobType.NORMAL, 1 },
        { 'Vanguard_Oracle',         mobType.NORMAL, 1 },
        { 'Vanguard_Partisan',       mobType.NORMAL, 1 },
        { 'Vanguard_Pathfinder',     mobType.NORMAL, 1 },
        { 'Vanguard_Persecutor',     mobType.NORMAL, 1 },
        { 'Vanguard_Pillager',       mobType.NORMAL, 1 },
        { 'Vanguard_Pitfighter',     mobType.NORMAL, 1 },
        { 'Vanguard_Predator',       mobType.NORMAL, 1 },
        { 'Vanguard_Prelate',        mobType.NORMAL, 1 },
        { 'Vanguard_Priest',         mobType.NORMAL, 1 },
        { 'Vanguard_Protector',      mobType.NORMAL, 1 },
        { 'Vanguard_Purloiner',      mobType.NORMAL, 1 },
        { 'Vanguard_Ronin',          mobType.NORMAL, 1 },
        { 'Vanguard_Salvager',       mobType.NORMAL, 1 },
        { 'Vanguard_Sentinel',       mobType.NORMAL, 1 },
        { 'Vanguard_Shaman',         mobType.NORMAL, 1 },
        { 'Vanguard_Skirmisher',     mobType.NORMAL, 1 },
        { 'Vanguard_Smithy',         mobType.NORMAL, 1 },
        { 'Vanguard_Thaumaturge',    mobType.NORMAL, 1 },
        { 'Vanguard_Tinkerer',       mobType.NORMAL, 1 },
        { 'Vanguard_Trooper',        mobType.NORMAL, 1 },
        { 'Vanguard_Undertaker',     mobType.NORMAL, 1 },
        { 'Vanguard_Vexer',          mobType.NORMAL, 1 },
        { 'Vanguard_Vigilante',      mobType.NORMAL, 1 },
        { 'Vanguard_Vindicator',     mobType.NORMAL, 1 },
        { 'Vanguard_Visionary',      mobType.NORMAL, 1 },
        { 'Vanguard_Welldigger',     mobType.NORMAL, 1 },
        { 'Vanguards_Wyvern',        mobType.NORMAL, 1 },
        { 'Vanguards_Slime',         mobType.NORMAL, 1 },
        { 'Vanguards_Scorpion',      mobType.NORMAL, 1 },
        { 'Vanguards_Hecteyes',      mobType.NORMAL, 1 },
        { 'Vanguards_Crow',          mobType.NORMAL, 1 },
        { 'Vanguards_Avatar',        mobType.NORMAL, 1 },
    },
    ['Dynamis-Xarcabard'] =
    {
        { 'Dynamis_Lord',          mobType.BOSS  , 1 },
        { 'Effigy_Prototype',      mobType.STATUE, 1 },
        { 'Icon_Prototype',        mobType.STATUE, 1 },
        { 'Statue_Prototype',      mobType.STATUE, 1 },
        { 'Tombstone_Prototype',   mobType.STATUE, 1 },
        { 'Vanguard_Eye',          mobType.STATUE, 1 },
        { 'Animated_Claymore',     mobType.NORMAL, 1 },
        { 'Animated_Dagger',       mobType.NORMAL, 1 },
        { 'Animated_Great_Axe',    mobType.NORMAL, 1 },
        { 'Animated_Gun',          mobType.NORMAL, 1 },
        { 'Animated_Hammer',       mobType.NORMAL, 1 },
        { 'Animated_Horn',         mobType.NORMAL, 1 },
        { 'Animated_Knuckles',     mobType.NORMAL, 1 },
        { 'Animated_Kunai',        mobType.NORMAL, 1 },
        { 'Animated_Longbow',      mobType.NORMAL, 1 },
        { 'Animated_Longsword',    mobType.NORMAL, 1 },
        { 'Animated_Scythe',       mobType.NORMAL, 1 },
        { 'Animated_Shield',       mobType.NORMAL, 1 },
        { 'Animated_Spear',        mobType.NORMAL, 1 },
        { 'Animated_Staff',        mobType.NORMAL, 1 },
        { 'Animated_Tabar',        mobType.NORMAL, 1 },
        { 'Animated_Tachi',        mobType.NORMAL, 1 },
        { 'Count_Raum',            mobType.NORMAL, 1 },
        { 'Count_Vine',            mobType.NORMAL, 1 },
        { 'Count_Zaebos',          mobType.NORMAL, 1 },
        { 'Duke_Berith',           mobType.NORMAL, 1 },
        { 'Duke_Gomory',           mobType.NORMAL, 1 },
        { 'Duke_Scox',             mobType.NORMAL, 1 },
        { 'Kindreds_Avatar',       mobType.NORMAL, 1 },
        { 'Kindred_Bard',          mobType.NORMAL, 1 },
        { 'Kindred_Beastmaster',   mobType.NORMAL, 1 },
        { 'Kindred_Black_Mage',    mobType.NORMAL, 1 },
        { 'Kindred_Dark_Knight',   mobType.NORMAL, 1 },
        { 'Kindred_Dragoon',       mobType.NORMAL, 1 },
        { 'Kindred_Monk',          mobType.NORMAL, 1 },
        { 'Kindred_Ninja',         mobType.NORMAL, 1 },
        { 'Kindred_Paladin',       mobType.NORMAL, 1 },
        { 'Kindred_Ranger',        mobType.NORMAL, 1 },
        { 'Kindred_Red_Mage',      mobType.NORMAL, 1 },
        { 'Kindred_Samurai',       mobType.NORMAL, 1 },
        { 'Kindred_Summoner',      mobType.NORMAL, 1 },
        { 'Kindred_Thief',         mobType.NORMAL, 1 },
        { 'Kindreds_Vouivre',      mobType.NORMAL, 1 },
        { 'Kindred_Warrior',       mobType.NORMAL, 1 },
        { 'Kindred_White_Mage',    mobType.NORMAL, 1 },
        { 'Kindreds_Wyvern',       mobType.NORMAL, 1 },
        { 'King_Zagan',            mobType.NORMAL, 1 },
        { 'Marquis_Andras',        mobType.NORMAL, 1 },
        { 'Andrass_Vouivre',       mobType.NORMAL, 1 },
        { 'Marquis_Cimeries',      mobType.NORMAL, 1 },
        { 'Marquis_Decarabia',     mobType.NORMAL, 1 },
        { 'Marquis_Gamygyn',       mobType.NORMAL, 1 },
        { 'Marquis_Nebiros',       mobType.NORMAL, 1 },
        { 'Marquis_Orias',         mobType.NORMAL, 1 },
        { 'Marquis_Sabnak',        mobType.NORMAL, 1 },
        { 'Nebiross_Avatar',       mobType.NORMAL, 1 },
        { 'Prince_Seere',          mobType.NORMAL, 1 },
        { 'Satellite_Claymores',   mobType.NORMAL, 1 },
        { 'Satellite_Daggers',     mobType.NORMAL, 1 },
        { 'Satellite_Great_Axes',  mobType.NORMAL, 1 },
        { 'Satellite_Guns',        mobType.NORMAL, 1 },
        { 'Satellite_Hammers',     mobType.NORMAL, 1 },
        { 'Satellite_Horns',       mobType.NORMAL, 1 },
        { 'Satellite_Knuckles',    mobType.NORMAL, 1 },
        { 'Satellite_Kunai',       mobType.NORMAL, 1 },
        { 'Satellite_Longbows',    mobType.NORMAL, 1 },
        { 'Satellite_Longswords',  mobType.NORMAL, 1 },
        { 'Satellite_Scythes',     mobType.NORMAL, 1 },
        { 'Satellite_Shield',      mobType.NORMAL, 1 },
        { 'Satellite_Spears',      mobType.NORMAL, 1 },
        { 'Satellite_Staves',      mobType.NORMAL, 1 },
        { 'Satellite_Tabars',      mobType.NORMAL, 1 },
        { 'Satellite_Tachi',       mobType.NORMAL, 1 },
        { 'Vanguard_Dragon',       mobType.NORMAL, 1 },
        { 'Yang',                  mobType.NORMAL, 1 },
        { 'Ying',                  mobType.NORMAL, 1 },
        { 'Zagans_Wyvern',         mobType.NORMAL, 1 },
    },
    ['Dynamis-Valkurm'] =
    {
        { 'Cirrate_Christelle',     mobType.BOSS     , 1 },
        { 'Adamantking_Effigy',     mobType.STATUE   , 1 },
        { 'Goblin_Replica',         mobType.STATUE   , 1 },
        { 'Manifest_Icon',          mobType.STATUE   , 1 },
        { 'Warchief_Tombstone',     mobType.STATUE   , 1 },
        { 'Fairy_Ring',             mobType.NORMAL   , 1 },
        { 'Nantina',                mobType.NORMAL   , 1 },
        { 'Stcemqestcint',          mobType.NORMAL   , 1 },
        { 'Nightmare_Fly',          mobType.NORMAL   , 1 },
        { 'Nightmare_Morbol',       mobType.NIGHTMARE, 1 },
        { 'Nightmare_Hippogryph',   mobType.NIGHTMARE, 1 },
        { 'Nightmare_Manticore',    mobType.NIGHTMARE, 1 },
        { 'Nightmare_Sabotender',   mobType.NIGHTMARE, 1 },
        { 'Nightmare_Sheep',        mobType.NIGHTMARE, 1 },
        { 'Dragontrap',             mobType.NIGHTMARE, 1 },
        { 'Vanguard_Alchemist',     mobType.NORMAL   , 1 },
        { 'Vanguard_Ambusher',      mobType.NORMAL   , 1 },
        { 'Vanguard_Amputator',     mobType.NORMAL   , 1 },
        { 'Vanguard_Armorer',       mobType.NORMAL   , 1 },
        { 'Vanguard_Assassin',      mobType.NORMAL   , 1 },
        { 'Vanguard_Backstabber',   mobType.NORMAL   , 1 },
        { 'Vanguard_Beasttender',   mobType.NORMAL   , 1 },
        { 'Vanguard_Bugler',        mobType.NORMAL   , 1 },
        { 'Vanguard_Chanter',       mobType.NORMAL   , 1 },
        { 'Vanguard_Constable',     mobType.NORMAL   , 1 },
        { 'Vanguard_Defender',      mobType.NORMAL   , 1 },
        { 'Vanguard_Dollmaster',    mobType.NORMAL   , 1 },
        { 'Vanguard_Dragontamer',   mobType.NORMAL   , 1 },
        { 'Vanguard_Drakekeeper',   mobType.NORMAL   , 1 },
        { 'Vanguard_Enchanter',     mobType.NORMAL   , 1 },
        { 'Vanguard_Exemplar',      mobType.NORMAL   , 1 },
        { 'Vanguard_Footsoldier',   mobType.NORMAL   , 1 },
        { 'Vanguard_Grappler',      mobType.NORMAL   , 1 },
        { 'Vanguard_Gutslasher',    mobType.NORMAL   , 1 },
        { 'Vanguard_Hatamoto',      mobType.NORMAL   , 1 },
        { 'Vanguard_Hawker',        mobType.NORMAL   , 1 },
        { 'Vanguard_Hitman',        mobType.NORMAL   , 1 },
        { 'Vanguard_Impaler',       mobType.NORMAL   , 1 },
        { 'Vanguard_Inciter',       mobType.NORMAL   , 1 },
        { 'Vanguard_Kusa',          mobType.NORMAL   , 1 },
        { 'Vanguard_Liberator',     mobType.NORMAL   , 1 },
        { 'Vanguard_Maestro',       mobType.NORMAL   , 1 },
        { 'Vanguard_Mason',         mobType.NORMAL   , 1 },
        { 'Vanguard_Mesmerizer',    mobType.NORMAL   , 1 },
        { 'Vanguard_Militant',      mobType.NORMAL   , 1 },
        { 'Vanguard_Minstrel',      mobType.NORMAL   , 1 },
        { 'Vanguard_Neckchopper',   mobType.NORMAL   , 1 },
        { 'Vanguard_Necromancer',   mobType.NORMAL   , 1 },
        { 'Vanguard_Ogresoother',   mobType.NORMAL   , 1 },
        { 'Vanguard_Oracle',        mobType.NORMAL   , 1 },
        { 'Vanguard_Partisan',      mobType.NORMAL   , 1 },
        { 'Vanguard_Pathfinder',    mobType.NORMAL   , 1 },
        { 'Vanguard_Persecutor',    mobType.NORMAL   , 1 },
        { 'Vanguard_Pillager',      mobType.NORMAL   , 1 },
        { 'Vanguard_Pitfighter',    mobType.NORMAL   , 1 },
        { 'Vanguard_Predator',      mobType.NORMAL   , 1 },
        { 'Vanguard_Prelate',       mobType.NORMAL   , 1 },
        { 'Vanguard_Priest',        mobType.NORMAL   , 1 },
        { 'Vanguard_Protector',     mobType.NORMAL   , 1 },
        { 'Vanguard_Purloiner',     mobType.NORMAL   , 1 },
        { 'Vanguard_Ronin',         mobType.NORMAL   , 1 },
        { 'Vanguard_Salvager',      mobType.NORMAL   , 1 },
        { 'Vanguard_Sentinel',      mobType.NORMAL   , 1 },
        { 'Vanguard_Shaman',        mobType.NORMAL   , 1 },
        { 'Vanguard_Skirmisher',    mobType.NORMAL   , 1 },
        { 'Vanguard_Smithy',        mobType.NORMAL   , 1 },
        { 'Vanguard_Thaumaturge',   mobType.NORMAL   , 1 },
        { 'Vanguard_Tinkerer',      mobType.NORMAL   , 1 },
        { 'Vanguard_Trooper',       mobType.NORMAL   , 1 },
        { 'Vanguard_Undertaker',    mobType.NORMAL   , 1 },
        { 'Vanguard_Vexer',         mobType.NORMAL   , 1 },
        { 'Vanguard_Vigilante',     mobType.NORMAL   , 1 },
        { 'Vanguard_Vindicator',    mobType.NORMAL   , 1 },
        { 'Vanguard_Visionary',     mobType.NORMAL   , 1 },
        { 'Vanguard_Welldigger',    mobType.NORMAL   , 1 },
        { 'Vanguards_Avatar',       mobType.NORMAL   , 1 },
        { 'Vanguards_Crow',         mobType.NORMAL   , 1 },
        { 'Vanguards_Hecteyes',     mobType.NORMAL   , 1 },
        { 'Vanguards_Scorpion',     mobType.NORMAL   , 1 },
        { 'Vanguards_Slime',        mobType.NORMAL   , 1 },
        { 'Vanguards_Wyvern',       mobType.NORMAL   , 1 },
    },
    ['Dynamis-Buburimu'] =
    {
        { 'Apocalyptic_Beast',        mobType.BOSS     , 3 },
        { 'Dragons_Avatar',           mobType.NORMAL   , 1 },
        { 'Dragons_Wyvern',           mobType.NORMAL   , 1 },
        { 'Adamantking_Effigy',       mobType.STATUE   , 2 },
        { 'Manifest_Icon',            mobType.STATUE   , 2 },
        { 'Warchief_Tombstone',       mobType.STATUE   , 2 },
        { 'Goblin_Replica',           mobType.STATUE   , 2 },
        { 'Nightmare_Bunny',          mobType.NIGHTMARE, 2 },
        { 'Nightmare_Cockatrice',     mobType.NIGHTMARE, 2 },
        { 'Nightmare_Crab',           mobType.NIGHTMARE, 2 },
        { 'Nightmare_Crawler',        mobType.NIGHTMARE, 2 },
        { 'Nightmare_Dhalmel',        mobType.NIGHTMARE, 2 },
        { 'Nightmare_Eft',            mobType.NIGHTMARE, 2 },
        { 'Nightmare_Mandragora',     mobType.NIGHTMARE, 2 },
        { 'Nightmare_Raven',          mobType.NIGHTMARE, 2 },
        { 'Nightmare_Scorpion',       mobType.NIGHTMARE, 2 },
        { 'Nightmare_Uragnite',       mobType.NIGHTMARE, 2 },
        { 'Baa_Dava_the_Bibliophage', mobType.NORMAL   , 2 },
        { 'Baas_Avatar',              mobType.NORMAL   , 2 },
        { 'Doo_Peku_the_Fleetfoot',   mobType.NORMAL   , 2 },
        { 'Elvaansticker_Bxafraff',   mobType.NORMAL   , 2 },
        { 'Bxafraffs_Wyvern',         mobType.NORMAL   , 2 },
        { 'Flamecaller_Zoeqdoq',      mobType.NORMAL   , 2 },
        { 'GiBhe_Fleshfeaster',       mobType.NORMAL   , 2 },
        { 'Gosspix_Blabberlips',      mobType.NORMAL   , 2 },
        { 'Hamfist_Gukhbuk',          mobType.NORMAL   , 2 },
        { 'Koo_Rahi_the_Levinblade',  mobType.NORMAL   , 2 },
        { 'Lyncean_Juwgneg',          mobType.NORMAL   , 2 },
        { 'QuPho_Bloodspiller',       mobType.NORMAL   , 2 },
        { 'Ree_Nata_the_Melomanic',   mobType.NORMAL   , 2 },
        { 'Shamblix_Rottenheart',     mobType.NORMAL   , 2 },
        { 'TeZha_Ironclad',           mobType.NORMAL   , 2 },
        { 'Vanguard_Alchemist',       mobType.NORMAL   , 2 },
        { 'Vanguard_Ambusher',        mobType.NORMAL   , 2 },
        { 'Vanguard_Amputator',       mobType.NORMAL   , 2 },
        { 'Vanguard_Armorer',         mobType.NORMAL   , 2 },
        { 'Vanguard_Assassin',        mobType.NORMAL   , 2 },
        { 'Vanguards_Avatar',         mobType.NORMAL   , 2 },
        { 'Vanguard_Backstabber',     mobType.NORMAL   , 2 },
        { 'Vanguard_Beasttender',     mobType.NORMAL   , 2 },
        { 'Vanguard_Bugler',          mobType.NORMAL   , 2 },
        { 'Vanguard_Chanter',         mobType.NORMAL   , 2 },
        { 'Vanguard_Constable',       mobType.NORMAL   , 2 },
        { 'Vanguard_Defender',        mobType.NORMAL   , 2 },
        { 'Vanguard_Dollmaster',      mobType.NORMAL   , 2 },
        { 'Vanguard_Dragontamer',     mobType.NORMAL   , 2 },
        { 'Vanguard_Drakekeeper',     mobType.NORMAL   , 2 },
        { 'Vanguard_Enchanter',       mobType.NORMAL   , 2 },
        { 'Vanguard_Exemplar',        mobType.NORMAL   , 2 },
        { 'Vanguard_Footsoldier',     mobType.NORMAL   , 2 },
        { 'Vanguard_Grappler',        mobType.NORMAL   , 2 },
        { 'Vanguard_Gutslasher',      mobType.NORMAL   , 2 },
        { 'Vanguard_Hatamoto',        mobType.NORMAL   , 2 },
        { 'Vanguard_Hawker',          mobType.NORMAL   , 2 },
        { 'Vanguard_Hitman',          mobType.NORMAL   , 2 },
        { 'Vanguard_Impaler',         mobType.NORMAL   , 2 },
        { 'Vanguard_Inciter',         mobType.NORMAL   , 2 },
        { 'Vanguard_Kusa',            mobType.NORMAL   , 2 },
        { 'Vanguard_Liberator',       mobType.NORMAL   , 2 },
        { 'Vanguard_Maestro',         mobType.NORMAL   , 2 },
        { 'Vanguard_Mason',           mobType.NORMAL   , 2 },
        { 'Vanguard_Mesmerizer',      mobType.NORMAL   , 2 },
        { 'Vanguard_Militant',        mobType.NORMAL   , 2 },
        { 'Vanguard_Minstrel',        mobType.NORMAL   , 2 },
        { 'Vanguard_Neckchopper',     mobType.NORMAL   , 2 },
        { 'Vanguard_Necromancer',     mobType.NORMAL   , 2 },
        { 'Vanguard_Ogresoother',     mobType.NORMAL   , 2 },
        { 'Vanguard_Oracle',          mobType.NORMAL   , 2 },
        { 'Vanguard_Partisan',        mobType.NORMAL   , 2 },
        { 'Vanguard_Pathfinder',      mobType.NORMAL   , 2 },
        { 'Vanguard_Persecutor',      mobType.NORMAL   , 2 },
        { 'Vanguard_Pillager',        mobType.NORMAL   , 2 },
        { 'Vanguard_Pitfighter',      mobType.NORMAL   , 2 },
        { 'Vanguard_Predator',        mobType.NORMAL   , 2 },
        { 'Vanguard_Prelate',         mobType.NORMAL   , 2 },
        { 'Vanguard_Priest',          mobType.NORMAL   , 2 },
        { 'Vanguard_Protector',       mobType.NORMAL   , 2 },
        { 'Vanguard_Purloiner',       mobType.NORMAL   , 2 },
        { 'Vanguard_Ronin',           mobType.NORMAL   , 2 },
        { 'Vanguard_Salvager',        mobType.NORMAL   , 2 },
        { 'Vanguard_Sentinel',        mobType.NORMAL   , 2 },
        { 'Vanguard_Shaman',          mobType.NORMAL   , 2 },
        { 'Vanguard_Skirmisher',      mobType.NORMAL   , 2 },
        { 'Vanguard_Smithy',          mobType.NORMAL   , 2 },
        { 'Vanguard_Thaumaturge',     mobType.NORMAL   , 2 },
        { 'Vanguard_Tinkerer',        mobType.NORMAL   , 2 },
        { 'Vanguard_Trooper',         mobType.NORMAL   , 2 },
        { 'Vanguard_Undertaker',      mobType.NORMAL   , 2 },
        { 'Vanguard_Vexer',           mobType.NORMAL   , 2 },
        { 'Vanguard_Vigilante',       mobType.NORMAL   , 2 },
        { 'Vanguard_Vindicator',      mobType.NORMAL   , 2 },
        { 'Vanguard_Visionary',       mobType.NORMAL   , 2 },
        { 'Vanguard_Welldigger',      mobType.NORMAL   , 2 },
        { 'Vanguards_Crow',           mobType.NORMAL   , 2 },
        { 'Vanguards_Hecteyes',       mobType.NORMAL   , 2 },
        { 'Vanguards_Scorpion',       mobType.NORMAL   , 2 },
        { 'Vanguards_Slime',          mobType.NORMAL   , 2 },
        { 'Vanguards_Wyvern',         mobType.NORMAL   , 2 },
        { 'VaRhu_Bodysnatcher',       mobType.NORMAL   , 2 },
        { 'Woodnix_Shrillwhistle',    mobType.NORMAL   , 2 },
        { 'Woodnixs_Slime',           mobType.NORMAL   , 2 },
        { 'Aitvaras',                 mobType.BOSS     , 3 },
        { 'Alklha',                   mobType.BOSS     , 3 },
        { 'Barong',                   mobType.BOSS     , 3 },
        { 'Basilic',                  mobType.BOSS     , 3 },
        { 'Koshchei',                 mobType.BOSS     , 3 },
        { 'Stihi',                    mobType.BOSS     , 3 },
        { 'Stollenwurm',              mobType.BOSS     , 3 },
        { 'Tarasca',                  mobType.BOSS     , 3 },
        { 'Jurik',                    mobType.BOSS     , 3 },
        { 'Vishap',                   mobType.BOSS     , 3 },
    },
    ['Dynamis-Qufim'] =
    {
        { 'Antaeus',                  mobType.BOSS     , 1 },
        { 'Scolopendra',              mobType.BOSS     , 1 },
        { 'Suttung',                  mobType.BOSS     , 1 },
        { 'Stringes',                 mobType.BOSS     , 1 },
        { 'Warchief_Tombstone',       mobType.STATUE   , 1 },
        { 'Manifest_Icon',            mobType.STATUE   , 1 },
        { 'Adamantking_Effigy',       mobType.STATUE   , 1 },
        { 'Goblin_Replica',           mobType.STATUE   , 1 },
        { 'Vanguard_Grappler',        mobType.NORMAL   , 1 },
        { 'Vanguard_Amputator',       mobType.NORMAL   , 1 },
        { 'Vanguard_Backstabber',     mobType.NORMAL   , 1 },
        { 'Vanguard_Trooper',         mobType.NORMAL   , 1 },
        { 'Vanguard_Bugler',          mobType.NORMAL   , 1 },
        { 'Vanguard_Impaler',         mobType.NORMAL   , 1 },
        { 'Vanguards_Wyvern',         mobType.NORMAL   , 1 },
        { 'Vanguard_Neckchopper',     mobType.NORMAL   , 1 },
        { 'Vanguard_Vexer',           mobType.NORMAL   , 1 },
        { 'Vanguard_Mesmerizer',      mobType.NORMAL   , 1 },
        { 'Vanguard_Pillager',        mobType.NORMAL   , 1 },
        { 'Vanguard_Dollmaster',      mobType.NORMAL   , 1 },
        { 'Vanguards_Avatar',         mobType.NORMAL   , 1 },
        { 'Vanguard_Footsoldier',     mobType.NORMAL   , 1 },
        { 'Vanguard_Gutslasher',      mobType.NORMAL   , 1 },
        { 'Vanguard_Predator',        mobType.NORMAL   , 1 },
        { 'Vanguard_Hawker',          mobType.NORMAL   , 1 },
        { 'Vanguards_Hecteyes',       mobType.NORMAL   , 1 },
        { 'Vanguard_Partisan',        mobType.NORMAL   , 1 },
        { 'Vanguard_Exemplar',        mobType.NORMAL   , 1 },
        { 'Vanguard_Prelate',         mobType.NORMAL   , 1 },
        { 'Vanguard_Persecutor',      mobType.NORMAL   , 1 },
        { 'Vanguard_Sentinel',        mobType.NORMAL   , 1 },
        { 'Vanguard_Liberator',       mobType.NORMAL   , 1 },
        { 'Vanguard_Priest',          mobType.NORMAL   , 1 },
        { 'Vanguard_Assassin',        mobType.NORMAL   , 1 },
        { 'Vanguard_Ogresoother',     mobType.NORMAL   , 1 },
        { 'Vanguards_Crow',           mobType.NORMAL   , 1 },
        { 'Vanguard_Oracle',          mobType.NORMAL   , 1 },
        { 'Vanguard_Skirmisher',      mobType.NORMAL   , 1 },
        { 'Vanguard_Visionary',       mobType.NORMAL   , 1 },
        { 'Vanguard_Chanter',         mobType.NORMAL   , 1 },
        { 'Vanguard_Salvager',        mobType.NORMAL   , 1 },
        { 'Vanguard_Inciter',         mobType.NORMAL   , 1 },
        { 'Vanguard_Vindicator',      mobType.NORMAL   , 1 },
        { 'Vanguard_Protector',       mobType.NORMAL   , 1 },
        { 'Vanguard_Kusa',            mobType.NORMAL   , 1 },
        { 'Vanguard_Militant',        mobType.NORMAL   , 1 },
        { 'Vanguard_Thaumaturge',     mobType.NORMAL   , 1 },
        { 'Vanguard_Purloiner',       mobType.NORMAL   , 1 },
        { 'Vanguard_Defender',        mobType.NORMAL   , 1 },
        { 'Vanguard_Hatamoto',        mobType.NORMAL   , 1 },
        { 'Vanguard_Constable',       mobType.NORMAL   , 1 },
        { 'Vanguard_Beasttender',     mobType.NORMAL   , 1 },
        { 'Vanguards_Scorpion',       mobType.NORMAL   , 1 },
        { 'Vanguard_Mason',           mobType.NORMAL   , 1 },
        { 'Vanguard_Vigilante',       mobType.NORMAL   , 1 },
        { 'Vanguard_Drakekeeper',     mobType.NORMAL   , 1 },
        { 'Vanguard_Minstrel',        mobType.NORMAL   , 1 },
        { 'Vanguard_Undertaker',      mobType.NORMAL   , 1 },
        { 'Vanguard_Pathfinder',      mobType.NORMAL   , 1 },
        { 'Vanguards_Slime',          mobType.NORMAL   , 1 },
        { 'Vanguard_Welldigger',      mobType.NORMAL   , 1 },
        { 'Vanguard_Necromancer',     mobType.NORMAL   , 1 },
        { 'Vanguard_Maestro',         mobType.NORMAL   , 1 },
        { 'Vanguard_Pitfighter',      mobType.NORMAL   , 1 },
        { 'Vanguard_Dragontamer',     mobType.NORMAL   , 1 },
        { 'Vanguard_Hitman',          mobType.NORMAL   , 1 },
        { 'Vanguard_Smithy',          mobType.NORMAL   , 1 },
        { 'Vanguard_Armorer',         mobType.NORMAL   , 1 },
        { 'Vanguard_Enchanter',       mobType.NORMAL   , 1 },
        { 'Vanguard_Shaman',          mobType.NORMAL   , 1 },
        { 'Vanguard_Ronin',           mobType.NORMAL   , 1 },
        { 'Vanguard_Tinkerer',        mobType.NORMAL   , 1 },
        { 'Vanguard_Ambusher',        mobType.NORMAL   , 1 },
        { 'Vanguard_Alchemist',       mobType.NORMAL   , 1 },
        { 'Fire_Elemental',           mobType.NORMAL   , 1 },
        { 'Ice_Elemental',            mobType.NORMAL   , 1 },
        { 'Air_Elemental',            mobType.NORMAL   , 1 },
        { 'Earth_Elemental',          mobType.NORMAL   , 1 },
        { 'Thunder_Elemental',        mobType.NORMAL   , 1 },
        { 'Water_Elemental',          mobType.NORMAL   , 1 },
        { 'Light_Elemental',          mobType.NORMAL   , 1 },
        { 'Dark_Elemental',           mobType.NORMAL   , 1 },
        { 'Nightmare_Snoll',          mobType.NIGHTMARE, 1 },
        { 'Nightmare_Roc',            mobType.NIGHTMARE, 1 },
        { 'Nightmare_Stirge',         mobType.NIGHTMARE, 1 },
        { 'Nightmare_Diremite',       mobType.NIGHTMARE, 1 },
        { 'Nightmare_Kraken',         mobType.NIGHTMARE, 1 },
        { 'Nightmare_Gaylas',         mobType.NIGHTMARE, 1 },
        { 'Nightmare_Raptor',         mobType.NIGHTMARE, 1 },
        { 'Nightmare_Tiger',          mobType.NIGHTMARE, 1 },
        { 'Nightmare_Weapon',         mobType.NIGHTMARE, 1 },
    },
    ['Dynamis-Tavnazia'] =
    {
        { 'Diabolos_Club',       mobType.NORMAL   , 1 },
        { 'Diabolos_Diamond',    mobType.NORMAL   , 1 },
        { 'Diabolos_Heart',      mobType.NORMAL   , 1 },
        { 'Diabolos_Spade',      mobType.NORMAL   , 1 },
        { 'Umbral_Diabolos',     mobType.NORMAL   , 1 },
        { 'Diaboloss_Shard',     mobType.NORMAL   , 1 },
        { 'Vanguard_Eye',        mobType.STATUE   , 1 },
        { 'Hydra_Bard',          mobType.NORMAL   , 2 },
        { 'Hydra_Beastmaster',   mobType.NORMAL   , 2 },
        { 'Hydra_Black_Mage',    mobType.NORMAL   , 2 },
        { 'Hydra_Dark_Knight',   mobType.NORMAL   , 2 },
        { 'Hydra_Dragoon',       mobType.NORMAL   , 2 },
        { 'Hydra_Monk',          mobType.NORMAL   , 2 },
        { 'Hydra_Ninja',         mobType.NORMAL   , 2 },
        { 'Hydra_Paladin',       mobType.NORMAL   , 2 },
        { 'Hydra_Ranger',        mobType.NORMAL   , 2 },
        { 'Hydra_Red_Mage',      mobType.NORMAL   , 2 },
        { 'Hydra_Samurai',       mobType.NORMAL   , 2 },
        { 'Hydra_Summoner',      mobType.NORMAL   , 2 },
        { 'Hydra_Thief',         mobType.NORMAL   , 2 },
        { 'Hydra_Warrior',       mobType.NORMAL   , 2 },
        { 'Hydra_White_Mage',    mobType.NORMAL   , 2 },
        { 'Hydras_Hound',        mobType.NORMAL   , 2 },
        { 'Hydras_Avatar',       mobType.NORMAL   , 2 },
        { 'Hydras_Wyvern',       mobType.NORMAL   , 2 },
        { 'Kindred_Bard',        mobType.NORMAL   , 2 },
        { 'Kindred_Beastmaster', mobType.NORMAL   , 2 },
        { 'Kindred_Black_Mage',  mobType.NORMAL   , 2 },
        { 'Kindred_Dark_Knight', mobType.NORMAL   , 2 },
        { 'Kindred_Dragoon',     mobType.NORMAL   , 2 },
        { 'Kindred_Monk',        mobType.NORMAL   , 2 },
        { 'Kindred_Ninja',       mobType.NORMAL   , 2 },
        { 'Kindred_Paladin',     mobType.NORMAL   , 2 },
        { 'Kindred_Ranger',      mobType.NORMAL   , 2 },
        { 'Kindred_Red_Mage',    mobType.NORMAL   , 2 },
        { 'Kindred_Samurai',     mobType.NORMAL   , 2 },
        { 'Kindred_Summoner',    mobType.NORMAL   , 2 },
        { 'Kindred_Thief',       mobType.NORMAL   , 2 },
        { 'Kindred_Warrior',     mobType.NORMAL   , 2 },
        { 'Kindred_White_Mage',  mobType.NORMAL   , 2 },
        { 'Kindreds_Vouivre',    mobType.NORMAL   , 2 },
        { 'Kindreds_Avatar',     mobType.NORMAL   , 2 },
        { 'Kindreds_Wyvern',     mobType.NORMAL   , 2 },
        { 'Nightmare_Antlion',   mobType.NIGHTMARE, 2 },
        { 'Nightmare_Bugard',    mobType.NIGHTMARE, 2 },
        { 'Nightmare_Cluster',   mobType.NIGHTMARE, 2 },
        { 'Nightmare_Hornet',    mobType.NIGHTMARE, 2 },
        { 'Nightmare_Leech',     mobType.NIGHTMARE, 2 },
        { 'Nightmare_Makara',    mobType.NIGHTMARE, 2 },
        { 'Nightmare_Taurus',    mobType.NIGHTMARE, 2 },
        { 'Nightmare_Worm',      mobType.NIGHTMARE, 2 },
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
            onMobSpawn          = 'onApocSpawn',
            onMobEngage         = 'onApocEngage',
            onMobFight          = 'onApocFight',
            onMobSpellChoose    = 'onApocSpellChoose',
            onMobMobskillChoose = 'onApocMobskillChoose',
            onMobRoam           = 'onApocRoam',
        },
        Aitvaras =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Alklha =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Barong =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Basilic =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Koshchei =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Stihi =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Stollenwurm =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Tarasca =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Jurik =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
        },
        Vishap =
        {
            onMobSpawn = 'onSpawnBubuDragon',
            onMobFight = 'onFightDragon',
            onMobRoam  = 'onRoamDragon',
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
        onMobEngage = function(mob, target)
            xi.dynamis.onSharedEngage(mob, target)
            xi.dynamis.checkEyeColor(mob)
        end,

        onMobRoam = function(mob)
            xi.dynamis.onMobRoam(mob)
        end,

        onMobDisengage = function(mob)
            xi.dynamis.onMobDisengage(mob)
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

        onMobEngage = function(mob, target)
            xi.dynamis.onSharedEngage(mob, target)
            xi.dynamis.onBossEngage(mob, target)
        end,

        onMobDisengage = function(mob)
            xi.dynamis.onMobDisengage(mob)
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
        onMobRoam = function(mob)
            xi.dynamis.onMobRoam(mob)
        end,

        onMobDisengage = function(mob)
            xi.dynamis.onMobDisengage(mob)
        end,

        onMobDeath = function(mob, player, optParams)
            xi.dynamis.onMobDeath(mob, player, optParams)
        end,

        onMobDespawn = noMobDespawn,
    },

    [mobType.NIGHTMARE] =
    {
        onMobEngage = function(mob, target)
            xi.dynamis.onSharedEngage(mob, target)
        end,

        onMobDisengage = function(mob)
            xi.dynamis.onMobDisengage(mob)
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
    'onMobDisengage',
    'onMobRoam',
    'onMobFight',
    'onMobDeath',
    'onMobDespawn',
}

local function registerMobOverrides(zoneName, mobName, overrideMobType, modelSize)
    local mobPath  = string.format('xi.zones.%s.mobs.%s', zoneName, mobName)
    local handlers = mobOverrideHandlers[overrideMobType]
    if not handlers then
        return
    end

    for _, eventName in ipairs(mobOverrideOrder) do
        local handler    = handlers[eventName]
        local hasMobHook = hasSpecialMobHook(zoneName, mobName, eventName)

        -- onMobSpawn needs modelSize injected via closure
        if eventName == 'onMobSpawn' then
            if overrideMobType == mobType.STATUE then
                handler = function(mob)
                    xi.dynamis.statueOnSpawn(mob, modelSize)
                end
            elseif overrideMobType == mobType.BOSS then
                handler = function(mob)
                    xi.dynamis.onBossSpawn(mob, modelSize)
                end
            else
                handler = function(mob)
                    xi.dynamis.onMobSpawn(mob, overrideMobType, modelSize)
                end
            end
        end

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
            local mobName         = mobEntry[1]
            local overrideMobType = mobEntry[2]
            local modelSize       = mobEntry[3]
            registerMobOverrides(zoneName, mobName, overrideMobType, modelSize)
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
