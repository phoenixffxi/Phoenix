-----------------------------------
-- Pre-SoA Gravity: Weight also lowers evasion by 10.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Weight', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/effects/weight.lua')
    end)

    it('lowers evasion by 10 and restores it when it wears', function()
        local before = player:getMod(xi.mod.EVA)
        player:addStatusEffect(xi.effect.WEIGHT, { power = 50, duration = 60, origin = player })
        player.assert:hasEffect(xi.effect.WEIGHT)

        local loss = player:getMod(xi.mod.EVA) - before
        player:delStatusEffect(xi.effect.WEIGHT)

        assert(loss == -10, string.format('expected -10 evasion, got %+d', loss))
        assert(player:getMod(xi.mod.EVA) == before, 'evasion was not restored when Weight wore')
    end)
end)
