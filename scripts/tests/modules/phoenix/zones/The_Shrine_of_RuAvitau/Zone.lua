-----------------------------------
-- The pad to Kirin (trigger area 4) misfires on a quarter of uses and sends the player to L' (event 10).
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix Kirin teleporter misfire', function()
    ---@type CClientEntityPair
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.THE_SHRINE_OF_RUAVITAU })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/zones/The_Shrine_of_RuAvitau/Zone.lua')
    end)

    it('sends the player to the wrong pad on a misfire', function()
        stub('math.randomInt', 25)

        -- Trigger area 4, the pad that leads to Kirin.
        player:setPos(-140, -17, -19)
        xi.test.world:tick(xi.tick.TRIGGER_AREAS)

        player.events:expect({ eventId = 10 })
    end)

    describe('misfire rule #exhaustive', function()
        it('misfires on rolls of 25 or less only', function()
            local roll = 26
            stub('math.randomInt', function()
                return roll
            end)

            player:setPos(-140, -17, -19)
            xi.test.world:tick(xi.tick.TRIGGER_AREAS)
            player.events:expect({ eventId = 5 })

            -- Step off the pad and back on with a misfire roll.
            player:setPos(-3.38, 46.326, 60)
            xi.test.world:tick(xi.tick.TRIGGER_AREAS)

            roll = 25
            player:setPos(-140, -17, -19)
            xi.test.world:tick(xi.tick.TRIGGER_AREAS)
            player.events:expect({ eventId = 10 })
        end)

        it('never misfires on the other pad to Kirin', function()
            stub('math.randomInt', 1)

            -- Trigger area 3 also leads to Kirin.
            player:setPos(-86, -17, 86)
            xi.test.world:tick(xi.tick.TRIGGER_AREAS)
            player.events:expect({ eventId = 5 })

            player:setPos(-140, -17, -19)
            xi.test.world:tick(xi.tick.TRIGGER_AREAS)
            player.events:expect({ eventId = 10 })
        end)
    end)
end)
