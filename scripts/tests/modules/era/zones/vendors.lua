-----------------------------------
-- Era shop stock: NPC shops drop post-era items and waystones, and sell at the era prices and ranks.
-- Every file's overrides are checked, then one shop for each kind of change.
-- Covers: modules/era/lua/zones/aht_urhgan_whitegate/npcs/aht_urhgan_whitegate_vendors.lua
-- Covers: modules/era/lua/zones/al_zahbi/npcs/al_zahbi_vendors.lua
-- Covers: modules/era/lua/zones/bastok_markets/npcs/bastok_markets_vendors.lua
-- Covers: modules/era/lua/zones/bastok_mines/npcs/bastok_mines_vendors.lua
-- Covers: modules/era/lua/zones/kazham/npcs/kazham_vendors.lua
-- Covers: modules/era/lua/zones/lower_jeuno/npcs/lower_jeuno_vendors.lua
-- Covers: modules/era/lua/zones/metalworks/npcs/nogga.lua
-- Covers: modules/era/lua/zones/mhaura/npcs/pikini-mikini.lua
-- Covers: modules/era/lua/zones/nashmau/npcs/nashmau_vendors.lua
-- Covers: modules/era/lua/zones/norg/npcs/solby-maholby.lua
-- Covers: modules/era/lua/zones/northern_san_doria/npcs/northern_san_doria_vendors.lua
-- Covers: modules/era/lua/zones/port_bastok/npcs/numa.lua
-- Covers: modules/era/lua/zones/port_jeuno/npcs/gekko.lua
-- Covers: modules/era/lua/zones/port_san_doria/npcs/coullave.lua
-- Covers: modules/era/lua/zones/port_windurst/npcs/port_windurst_vendors.lua
-- Covers: modules/era/lua/zones/rabao/npcs/rabao_vendors.lua
-- Covers: modules/era/lua/zones/selbina/npcs/dohdjuma.lua
-- Covers: modules/era/lua/zones/tavnazian_safehold/npcs/tavnazian_safehold_vendors.lua
-- Covers: modules/era/lua/zones/upper_jeuno/npcs/upper_jeuno_vendors.lua
-- Covers: modules/era/lua/zones/windurst_waters/npcs/orez-ebrez.lua
-- Covers: modules/era/lua/zones/windurst_woods/npcs/windurst_woods_vendors.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era vendors', function()
    it('applies the overrides of every shop', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('takes the Kingdom Waystone out of Pirvidiauce\'s stock', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.NORTHERN_SAN_DORIA })
        local stock  = moduleTest.shopReader()(player, 'Pirvidiauce')

        assert(stock[xi.item.POTION] == 910, 'expected Potions at 910 gil')
        assert(stock[xi.item.KINGDOM_WAYSTONE] == nil, 'the Kingdom Waystone is for sale')
    end)

    it('sells Gavrie\'s Remedies at the era price and no Automaton Oil +3', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
        local stock  = moduleTest.shopReader()(player, 'Gavrie')

        assert(stock[xi.item.REMEDY] == 22400, 'expected Remedies at 22400 gil')
        assert(stock[xi.item.CAN_OF_AUTOMATON_OIL_P3] == nil, 'Automaton Oil +3 is for sale')
    end)

    it('sells Coullave\'s monk gear from rank 1 and no Silver Earring', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.PORT_SAN_DORIA })
        local ranks  = {}
        local sold   = {}

        stub('xi.shop.nation', function(_, stock)
            for _, entry in ipairs(stock) do
                sold[entry[1]]  = true
                ranks[entry[1]] = entry[3]
            end
        end)

        player.entities:gotoAndTrigger('Coullave')

        for _, itemId in ipairs({ xi.item.HACHIMAKI, xi.item.KENPOGI, xi.item.TEKKO, xi.item.SITABAKI, xi.item.KYAHAN }) do
            assert(ranks[itemId] == 1, string.format('expected item %d from rank 1, got %s', itemId, tostring(ranks[itemId])))
        end

        assert(not sold[xi.item.SILVER_EARRING], 'the Silver Earring is for sale')
    end)
end)
