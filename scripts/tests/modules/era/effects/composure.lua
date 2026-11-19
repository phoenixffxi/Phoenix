-----------------------------------
-- Pre-RoV Composure: accuracy is main job level / 5.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Composure', function()
    local player

    local function expectAccuracy(expected)
        local before = player:getMod(xi.mod.ACC)
        player:addStatusEffect(xi.effect.COMPOSURE, { power = 1, duration = 7200, origin = player })
        player.assert:hasEffect(xi.effect.COMPOSURE)

        local gain = player:getMod(xi.mod.ACC) - before
        player:delStatusEffect(xi.effect.COMPOSURE)

        assert(gain == expected, string.format('expected %+d accuracy, got %+d', expected, gain))
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.RDM, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/effects/composure.lua')
    end)

    it('gives a level 75 Red Mage +15 accuracy', function()
        expectAccuracy(15)
    end)

    describe('levels #exhaustive', function()
        it('gives a level 52 Red Mage +10 accuracy', function()
            player:setLevel(52)
            expectAccuracy(10)
            player:setLevel(75)
        end)
    end)
end)
