-----------------------------------
-- Churano-Shurano does not sell the Magicked Astrolabe before Seekers of Adoulin.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Churano-Shurano', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WATERS })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/zones/windurst_waters/npcs/churano-shurano.lua')
    end)

    it('offers no Magicked Astrolabe', function()
        player.entities:gotoAndTrigger('Churano-Shurano', { eventId = 280 })
    end)

    describe('astrolabe sale #exhaustive', function()
        it('quotes no Magicked Astrolabe in an event update', function()
            player:addGil(10000)
            player.packets:clear()

            xi.zones.Windurst_Waters.npcs['Churano-Shurano'].onEventUpdate(player, 1080, 1, nil)
            player:delGil(10000)

            for _, packet in ipairs(player.packets:getIncoming()) do
                assert(packet.type ~= 0x05C, 'Churano-Shurano answered the purchase')
            end
        end)

        it('sells no Magicked Astrolabe when a purchase event finishes', function()
            player:addGil(10000)

            xi.zones.Windurst_Waters.npcs['Churano-Shurano'].onEventFinish(player, 1080, xi.keyItem.MAGICKED_ASTROLABE, nil)
            player:delGil(10000)

            player.assert.no:hasKI(xi.keyItem.MAGICKED_ASTROLABE)
        end)
    end)
end)
