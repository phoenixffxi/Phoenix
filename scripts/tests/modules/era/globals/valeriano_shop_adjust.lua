-----------------------------------
-- The Valeriano troupe sells no Carol II or Mage's Ballad III scrolls before WotG.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Opens the troupe's shop as if its host nation led the conquest and returns { [itemId] = price }.
-- The shop is called directly because the troupe NPC stays hidden while the nations are tied.
local function troupeStock(player)
    local offered

    stub('GetNationRank', 1)
    stub('xi.shop.general', function(_, stock)
        offered = {}
        for _, entry in ipairs(stock) do
            offered[entry[1]] = entry[2]
        end
    end)

    xi.shop.handleValerianoShop(player, player.entities:get('Valeriano'))
    assert(offered, 'Valeriano opened no shop')

    return offered
end

describe('Era Valeriano shop', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/globals/valeriano_shop_adjust.lua')
    end)

    it('sells the Hymnus scroll but no Carol II scrolls', function()
        local stock = troupeStock(xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS }))

        assert(stock[xi.item.SCROLL_OF_GODDESSS_HYMNUS] == 104000, 'expected the Hymnus scroll at 104000 gil')
        assert(stock[xi.item.SCROLL_OF_FIRE_CAROL_II] == nil, 'Fire Carol II is for sale')
    end)

    describe('troupe stock in each nation #exhaustive', function()
        local eraStock =
        {
            { xi.item.GINGER_COOKIE,                 12 },
            { xi.item.FLUTE,                         49 },
            { xi.item.PICCOLO,                     1144 },
            { xi.item.SCROLL_OF_SCOPS_OPERETTA,     677 },
            { xi.item.SCROLL_OF_PUPPETS_OPERETTA, 19552 },
            { xi.item.SCROLL_OF_FOWL_AUBADE,       3369 },
            { xi.item.SCROLL_OF_ADVANCING_MARCH,   2379 },
            { xi.item.SCROLL_OF_GODDESSS_HYMNUS, 104000 },
        }

        local hosts =
        {
            { 'Southern San dOria', xi.zone.SOUTHERN_SAN_DORIA },
            { 'Port Bastok',        xi.zone.PORT_BASTOK        },
            { 'Windurst Woods',     xi.zone.WINDURST_WOODS     },
        }

        for _, host in ipairs(hosts) do
            it(string.format('sells only the era stock in %s', host[1]), function()
                local stock = troupeStock(xi.test.world:spawnPlayer({ zone = host[2] }))

                local count = 0
                for _ in pairs(stock) do
                    count = count + 1
                end

                for _, entry in ipairs(eraStock) do
                    assert(stock[entry[1]] == entry[2], string.format('expected item %d at %d gil, got %s', entry[1], entry[2], tostring(stock[entry[1]])))
                end

                assert(count == #eraStock, string.format('Valeriano sells %d items, expected %d', count, #eraStock))
            end)
        end
    end)
end)
