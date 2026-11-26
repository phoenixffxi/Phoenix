-----------------------------------
-- Imperial standing NPCs charge the era prices for the instant scrolls and stop selling post-era items.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix era imperial standing shop', function()
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
        player:addKeyItem(xi.keyItem.PSC_WILDCAT_BADGE)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/globals/era_imperial_standing_shop.lua')
    end)

    it('charges 500 imperial standing for a Scroll of Instant Reraise', function()
        player:setCurrency('imperial_standing', 1000)

        xi.besieged.onEventFinish(player, 0, 1)

        assert(player:hasItem(xi.item.SCROLL_OF_INSTANT_RERAISE), 'no Scroll of Instant Reraise')
        assert(player:getCurrency('imperial_standing') == 500, string.format('expected 500 imperial standing left, got %d', player:getCurrency('imperial_standing')))
    end)

    it('offers no Cipher: Mihli during the Summer and New Year campaign', function()
        stub('xi.extravaganza.campaignActive', xi.extravaganza.campaign.SUMMER_NY)

        assert(xi.besieged.cipherValue() == 0, 'the menu flags Cipher: Mihli for sale')
    end)

    describe('every adjusted item #exhaustive', function()
        it('charges 750 imperial standing for a Scroll of Instant Warp', function()
            player:setCurrency('imperial_standing', 1000)

            xi.besieged.onEventFinish(player, 0, 4097)

            assert(player:hasItem(xi.item.SCROLL_OF_INSTANT_WARP), 'no Scroll of Instant Warp')
            assert(player:getCurrency('imperial_standing') == 250, string.format('expected 250 imperial standing left, got %d', player:getCurrency('imperial_standing')))
        end)

        it('sells no Scroll of Instant Reraise below 500 imperial standing', function()
            player:setCurrency('imperial_standing', 499)

            xi.besieged.onEventFinish(player, 0, 1)

            assert(not player:hasItem(xi.item.SCROLL_OF_INSTANT_RERAISE), 'sold a Scroll of Instant Reraise for 499 imperial standing')
            assert(player:getCurrency('imperial_standing') == 499, string.format('expected 499 imperial standing left, got %d', player:getCurrency('imperial_standing')))
        end)

        local removed =
        {
            { 36865, xi.item.HEAT_CAPACITOR,             'the Heat Capacitor'     },
            { 40961, xi.item.POWER_COOLER,               'the Power Cooler'       },
            { 45057, xi.item.BARRAGE_TURBINE,            'the Barrage Turbine'    },
            { 53249, xi.item.GALVANIZER,                 'the Galvanizer'         },
            { 57345, xi.item.EPHRAMADIAN_THRONE,         'the Ephramadian Throne' },
            { 69633, xi.item.CIPHER_OF_MIHLIS_ALTER_EGO, 'Cipher: Mihli'          },
        }

        for _, entry in ipairs(removed) do
            it(string.format('does not sell %s', entry[3]), function()
                player:setCurrency('imperial_standing', 100000)

                xi.besieged.onEventFinish(player, 0, entry[1])

                assert(not player:hasItem(entry[2]), string.format('%s was sold', entry[3]))
                assert(player:getCurrency('imperial_standing') == 100000, string.format('expected 100000 imperial standing left, got %d', player:getCurrency('imperial_standing')))
            end)
        end
    end)
end)
