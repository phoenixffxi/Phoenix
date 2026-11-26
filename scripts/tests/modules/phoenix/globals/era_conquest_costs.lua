-----------------------------------
-- Conquest overseers charge the era prices for the instant scrolls and stop selling post-era items.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix era conquest costs', function()
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.BASTOK_MINES })
        player:setNation(xi.nation.BASTOK)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/globals/era_conquest_costs.lua')
    end)

    it('charges 500 conquest points for a Scroll of Instant Reraise', function()
        player:addCP(1000)

        xi.conquest.overseerOnEventUpdate(player, 32761, 32928, xi.nation.BASTOK)
        xi.conquest.overseerOnEventFinish(player, 32761, 32928, xi.nation.BASTOK, xi.conquest.guard.CITY)

        assert(player:hasItem(xi.item.SCROLL_OF_INSTANT_RERAISE), 'no Scroll of Instant Reraise')
        assert(player:getCP() == 500, string.format('expected 500 conquest points left, got %d', player:getCP()))
    end)

    describe('every adjusted item #exhaustive', function()
        it('charges 750 conquest points for a Scroll of Instant Warp', function()
            player:addCP(1000)

            xi.conquest.overseerOnEventUpdate(player, 32761, 32929, xi.nation.BASTOK)
            xi.conquest.overseerOnEventFinish(player, 32761, 32929, xi.nation.BASTOK, xi.conquest.guard.CITY)

            assert(player:hasItem(xi.item.SCROLL_OF_INSTANT_WARP), 'no Scroll of Instant Warp')
            assert(player:getCP() == 250, string.format('expected 250 conquest points left, got %d', player:getCP()))
        end)

        it('sells no Scroll of Instant Reraise below 500 conquest points', function()
            player:addCP(499)

            xi.conquest.overseerOnEventUpdate(player, 32761, 32928, xi.nation.BASTOK)
            xi.conquest.overseerOnEventFinish(player, 32761, 32928, xi.nation.BASTOK, xi.conquest.guard.CITY)

            assert(not player:hasItem(xi.item.SCROLL_OF_INSTANT_RERAISE), 'sold a Scroll of Instant Reraise for 499 conquest points')
            assert(player:getCP() == 499, string.format('expected 499 conquest points left, got %d', player:getCP()))
        end)

        local removed =
        {
            { 32935, xi.item.EMPEROR_BAND,                'the Emperor Band'       },
            { 32936, xi.item.WARP_RING,                   'the Warp Ring'          },
            { 32937, xi.item.CIPHER_OF_TENZENS_ALTER_EGO, 'Cipher: Tenzen'         },
            { 32938, xi.item.CIPHER_OF_RAHALS_ALTER_EGO,  'Cipher: Rahal'          },
            { 32939, xi.item.CIPHER_OF_KUKKIS_ALTER_EGO,  'Cipher: Kukki-Chebukki' },
            { 32942, xi.item.CIPHER_OF_MAKKIS_ALTER_EGO,  'Cipher: Makki-Chebukki' },
        }

        for _, entry in ipairs(removed) do
            it(string.format('does not sell %s', entry[3]), function()
                player:addCP(10000)

                xi.conquest.overseerOnEventUpdate(player, 32761, entry[1], xi.nation.BASTOK)
                assert(player:getLocalVar('boughtItemCP') == 0, 'the menu cleared the item for purchase')

                -- A crafted finish for the option must not hand the item out either.
                xi.conquest.overseerOnEventFinish(player, 32761, entry[1], xi.nation.BASTOK, xi.conquest.guard.CITY)
                assert(not player:hasItem(entry[2]), string.format('%s was handed out', entry[3]))
                assert(player:getCP() == 10000, string.format('expected 10000 conquest points left, got %d', player:getCP()))
            end)
        end
    end)
end)
