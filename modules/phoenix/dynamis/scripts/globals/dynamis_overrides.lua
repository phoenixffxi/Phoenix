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
        { 'Battlechoir_Gitchfotch',  'NM'     },
        { 'Overlords_Tombstone',     'BOSS'   },
        { 'Reapertongue_Gadgquok',   'NM'     },
        { 'Serjeant_Tombstone',      'STATUE' },
        { 'Soulsender_Fugbrag',      'NM'     },
        { 'Vanguard_Amputator',      'NORMAL' },
        { 'Vanguard_Backstabber',    'NORMAL' },
        { 'Vanguard_Bugler',         'NORMAL' },
        { 'Vanguard_Dollmaster',     'NORMAL' },
        { 'Vanguard_Footsoldier',    'NORMAL' },
        { 'Vanguard_Grappler',       'NORMAL' },
        { 'Vanguard_Gutslasher',     'NORMAL' },
        { 'Vanguard_Hawker',         'NORMAL' },
        { 'Vanguard_Impaler',        'NORMAL' },
        { 'Vanguard_Mesmerizer',     'NORMAL' },
        { 'Vanguard_Neckchopper',    'NORMAL' },
        { 'Vanguard_Pillager',       'NORMAL' },
        { 'Vanguard_Predator',       'NORMAL' },
        { 'Vanguard_Trooper',        'NORMAL' },
        { 'Vanguard_Vexer',          'NORMAL' },
        { 'Voidstreaker_Butchnotch', 'NM'     },
        { 'Warchief_Tombstone',      'STATUE' },
        { 'Wyrmgnasher_Bjakdek',     'NM '    },
    },
    ['Dynamis-Bastok'] =
    {
        { 'Adamantking_Effigy',   'STATUE' },
        { 'GiPha_Manameister',    'NM'     },
        { 'GuDha_Effigy',         'BOSS'   },
        { 'GuNhi_Noondozer',      'NM'     },
        { 'KoDho_Cannonball',     'NM'     },
        { 'Vanguard_Beasttender', 'NORMAL' },
        { 'Vanguard_Constable',   'NORMAL' },
        { 'Vanguard_Defender',    'NORMAL' },
        { 'Vanguard_Drakekeeper', 'NORMAL' },
        { 'Vanguard_Hatamoto',    'NORMAL' },
        { 'Vanguard_Kusa',        'NORMAL' },
        { 'Vanguard_Mason',       'NORMAL' },
        { 'Vanguard_Militant',    'NORMAL' },
        { 'Vanguard_Minstrel',    'NORMAL' },
        { 'Vanguard_Protector',   'NORMAL' },
        { 'Vanguard_Purloiner',   'NORMAL' },
        { 'Vanguard_Thaumaturge', 'NORMAL' },
        { 'Vanguard_Undertaker',  'NORMAL' },
        { 'Vanguard_Vigilante',   'NORMAL' },
        { 'Vanguard_Vindicator',  'NORMAL' },
        { 'ZeVho_Fallsplitter',   'NM'     },
    },
    ['Dynamis-Windurst'] =
    {
        { 'Avatar_Icon',             'STATUE' },
        { 'Avatar_Idol',             'STATUE' },
        { 'Manifest_Icon',           'STATUE' },
        { 'Haa_Pevi_the_Stentorian', 'NM'     },
        { 'Loo_Hepe_the_Eyepiercer', 'NM'     },
        { 'Maa_Febi_the_Steadfast',  'NM'     },
        { 'Muu_Febi_the_Steadfast',  'NM'     },
        { 'Tzee_Xicu_Idol',          'BOSS'   },
        { 'Vanguard_Assassin',       'NORMAL' },
        { 'Vanguard_Chanter',        'NORMAL' },
        { 'Vanguard_Exemplar',       'NORMAL' },
        { 'Vanguard_Inciter',        'NORMAL' },
        { 'Vanguard_Liberator',      'NORMAL' },
        { 'Vanguard_Ogresoother',    'NORMAL' },
        { 'Vanguard_Oracle',         'NORMAL' },
        { 'Vanguard_Partisan',       'NORMAL' },
        { 'Vanguard_Persecutor',     'NORMAL' },
        { 'Vanguard_Prelate',        'NORMAL' },
        { 'Vanguard_Priest',         'NORMAL' },
        { 'Vanguard_Salvager',       'NORMAL' },
        { 'Vanguard_Sentinel',       'NORMAL' },
        { 'Vanguard_Skirmisher',     'NORMAL' },
        { 'Vanguard_Visionary',      'NORMAL' },
        { 'Wuu_Qoho_the_Razorclaw',  'NM'     },
        { 'Xoo_Kaza_the_Solemn',     'NM'     },
    },
    ['Dynamis-Jeuno'] =
    {
        { 'Anvilix_Sootwrists',     'NM'     },
        { 'Bandrix_Rockjaw',        'NM'     },
        { 'Blazox_Boneybod',        'NM'     },
        { 'Bootrix_Jaggedelbow',    'NM'     },
        { 'Buffrix_Eargone',        'NM'     },
        { 'Cloktix_Longnail',       'NM'     },
        { 'Distilix_Stickytoes',    'NM'     },
        { 'Elixmix_Hooknose',       'NM'     },
        { 'Eremix_Snottynostril',   'NM'     },
        { 'Gabblox_Magpietongue',   'NM'     },
        { 'Goblin_Golem',           'BOSS'   },
        { 'Goblin_Replica',         'STATUE' },
        { 'Goblin_Statue',          'STATUE' },
        { 'Hermitrix_Toothrot',     'NM'     },
        { 'Humnox_Drumbelly',       'NM'     },
        { 'Jabbrox_Grannyguise',    'NM'     },
        { 'Jabkix_Pigeonpecs',      'NM'     },
        { 'Karashix_Swollenskull',  'NM'     },
        { 'Kikklix_Longlegs',       'NM'     },
        { 'Lurklox_Dhalmelneck',    'NM'     },
        { 'Mobpix_Mucousmouth',     'NM'     },
        { 'Morgmox_Moldnoggin',     'NM'     },
        { 'Mortilox_Wartpaws',      'NM'     },
        { 'Prowlox_Barrelbelly',    'NM'     },
        { 'Rutrix_Hamgams',         'NM'     },
        { 'Scruffix_Shaggychest',   'NM'     },
        { 'Slystix_Megapeepers',    'NM'     },
        { 'Smeltix_Thickhide',      'NM'     },
        { 'Snypestix_Eaglebeak',    'NM'     },
        { 'Sparkspox_Sweatbrow',    'NM'     },
        { 'Ticktox_Beadyeyes',      'NM'     },
        { 'Trailblix_Goatmug',      'NM'     },
        { 'Tufflix_Loglimbs',       'NM'     },
        { 'Tymexox_Ninefingers',    'NM'     },
        { 'Vanguard_Alchemist',     'NORMAL' },
        { 'Vanguard_Ambusher',      'NORMAL' },
        { 'Vanguard_Armorer',       'NORMAL' },
        { 'Vanguard_Dragontamer',   'NORMAL' },
        { 'Vanguard_Enchanter',     'NORMAL' },
        { 'Vanguard_Hitman',        'NORMAL' },
        { 'Vanguard_Maestro',       'NORMAL' },
        { 'Vanguard_Necromancer',   'NORMAL' },
        { 'Vanguard_Pathfinder',    'NORMAL' },
        { 'Vanguard_Pitfighter',    'NORMAL' },
        { 'Vanguard_Ronin',         'NORMAL' },
        { 'Vanguard_Shaman',        'NORMAL' },
        { 'Vanguard_Smithy',        'NORMAL' },
        { 'Vanguard_Tinkerer',      'NORMAL' },
        { 'Vanguard_Welldigger',    'NORMAL' },
        { 'Wasabix_Callusdigit',    'NM'     },
        { 'Wyrmwix_Snakespecs',     'NM'     },
    },
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
    m:addOverride(string.format('xi.zones.%s.Zone.onInitialize', zoneName),
    function(zone)
        xi.dynamis.zoneOnZoneInitializeEra(zone)
    end)

    m:addOverride(string.format('xi.zones.%s.Zone.onZoneIn', zoneName),
    function(player, prevZone)
        xi.dynamis.zoneOnZoneInEra(player, prevZone)
    end)

    m:addOverride(string.format('xi.zones.%s.Zone.onZoneTick', zoneName),
    function(zone)
        xi.dynamis.handleDynamis(zone)
    end)

    -- Special case for SJ zones (7-9)
    -- Dynamis - Valkurm (7), Dynamis - Buburimu (8), Dynamis - Qufim (9)
    if zoneNumber > 7 and zoneNumber < 10 then
        m:addOverride(string.format('xi.zones.%s.npcs.qm0.onTrigger', zoneName),
        function(player, npc)
            xi.dynamis.sjQMOnTrigger(npc)
        end)
    end

    -- Special case for Tavnazia (10)
    -- Still need to audit this later
    -- if zoneNumber == 10 then
    --     m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.npcs.qm0.onTrigger', zoneName),
    --     function(player, npc)
    --         xi.dynamis.timeExtensionOnTrigger(player, npc)
    --     end)

    --     m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.npcs.qm1.onTrigger', zoneName),
    --     function(player, npc)
    --         xi.dynamis.timeExtensionOnTrigger(player, npc)
    --     end)

    --     m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.npcs.qm1.onTrade', zoneName),
    --     function(player, npc)
    --         xi.dynamis.timeExtensionOnTrigger(player, npc)
    --     end)

    --     m:addOverride(string.format('xi.zones.Dynamis-Tavnazia.Zone.onTriggerAreaEnter', zoneName),
    --     function(player, triggerArea)
    --         xi.dynamis.onTriggerAreaEnter(player, triggerArea)
    --     end)
    -- end
end

-- Helper function for entry NPC overrides
local function registerEntryNpcOverrides(zoneName, npcName)
    m:addOverride(string.format('xi.zones.%s.npcs.%s.onTrade', zoneName, npcName),
    function(player, npc, trade)
        xi.dynamis.entryNpcOnTrade(player, npc, trade)
        print('trail markings on trade working')
    end)

    m:addOverride(string.format('xi.zones.%s.npcs.%s.onEventUpdate', zoneName, npcName),
    function(player, csid, option, npc)
        xi.dynamis.entryNpcOnEventUpdate(player, csid, option, npc)
        print('trail markings on event update working')
    end)

    m:addOverride(string.format('xi.zones.%s.npcs.%s.onEventFinish', zoneName, npcName),
    function(player, csid, option, npc)
        xi.dynamis.entryNpcOnEventFinish(player, csid, option, npc)
        print('trail markings on event finish working')
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

-- TODO Cleanup/Delete
m:addOverride('xi.dynamis.somnialThresholdOnTrigger', function(player, npc)
end)

m:addOverride('xi.dynamis.somnialThresholdOnEventFinish', function(player, npc)
end)

m:addOverride('xi.dynamis.timeExtensionOnDeath', function(mob, player, optParams)
end)

m:addOverride('xi.dynamis.refillStatueOnSpawn', function(mob)
end)

m:addOverride('xi.dynamis.refillStatueOnSDeath', function(mob, player, optParams)
end)

m:addOverride('xi.dynamis.qmOnTrade', function(player, npc, trade)
end) -- Not used...  Era Dynamis does not have QM pops.

m:addOverride('xi.dynamis.getExtensions', function(player)
end)

-----------------------------------
-- Mob Type Overrides
-----------------------------------

-- Helper function to create mob overrides based on mob type
local function registerMobOverrides(zoneName, mobName, mobType)
    local mobPath = string.format('xi.zones.%s.mobs.%s', zoneName, mobName)

    if mobType == 'STATUE' then
        m:addOverride(mobPath .. '.onMobSpawn', function(mob)
            xi.dynamis.statueOnSpawn(mob)
        end)

        m:addOverride(mobPath .. '.onMobEngage', function(mob, target)
            xi.dynamis.statueOnEngaged(mob, target)
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

    elseif mobType == 'BOSS' then
        m:addOverride(mobPath .. '.onMobSpawn', function(mob)
            xi.dynamis.statueOnSpawn(mob)
            xi.dynamis.onBossInitialize(mob)
        end)

        m:addOverride(mobPath .. '.onMobEngage', function(mob, target)
            xi.dynamis.statueOnEngaged(mob, target)
        end)

        m:addOverride(mobPath .. '.onMobRoam', function(mob)
            xi.dynamis.onMobRoam(mob)
        end)

        m:addOverride(mobPath .. '.onMobDeath', function(mob, player, optParams)
            xi.dynamis.onMobDeath(mob, player, optParams)
        end)

    elseif mobType == 'NM' then
        m:addOverride(mobPath .. '.onMobSpawn', function(mob)
            xi.dynamis.onMobSpawn(mob)
        end)

        m:addOverride(mobPath .. '.onMobRoam', function(mob)
            xi.dynamis.onMobRoam(mob)
        end)

        m:addOverride(mobPath .. '.onMobDeath', function(mob, player, optParams)
            xi.dynamis.onMobDeath(mob, player, optParams)
        end)

    elseif mobType == 'NORMAL' then
        m:addOverride(mobPath .. '.onMobSpawn', function(mob)
            xi.dynamis.onMobSpawn(mob)
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
