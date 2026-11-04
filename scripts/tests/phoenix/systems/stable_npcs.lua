-----------------------------------
-- Phoenix version of the Ferdoulemiont case in systems/stable_npcs.lua.
-- era/lua/zones/southern_san_doria/npcs/southern_san_doria_vendors.lua replaces his stock to drop
-- Knight's Minne V. Its other prices differ from the captured ones and have no source yet, so only the removal is checked.
-----------------------------------
describe('Stable area NPCs', function()
    it('leaves Knight\'s Minne V out of Ferdoulemiont\'s stock', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })
        local prices = {}

        stub('xi.shop.nation', function(shopPlayer, stock)
            for _, entry in ipairs(stock) do
                prices[entry[1]] = entry[2]
            end
        end)

        player.entities:gotoAndTrigger('Ferdoulemiont')

        assert(prices[xi.item.BUNCH_OF_GYSAHL_GREENS], 'Ferdoulemiont\'s shop did not open')
        assert(not prices[xi.item.SCROLL_OF_KNIGHTS_MINNE_V], 'Knight\'s Minne V is still for sale')
    end)
end)
