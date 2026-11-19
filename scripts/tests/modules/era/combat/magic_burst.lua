-----------------------------------
-- Pre-SoA magic burst: 1.25 plus 0.05 per skillchain step, whatever the target resists.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era magic burst', function()
    local player

    local function expectMultiplier(element, steps, expected, target)
        local multiplier = xi.spells.damage.calculateIfMagicBurst(player, target or player, element, steps)
        assert(math.abs(multiplier - expected) < 0.0001, string.format('%d steps: expected %.2f, got %s', steps, expected, multiplier))
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.BLM, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/combat/magic_burst.lua')
    end)

    it('adds 0.05 per skillchain step to a 1.25 base', function()
        expectMultiplier(xi.element.FIRE, 2, 1.35)
    end)

    describe('every case #exhaustive', function()
        it('counts one to five steps and caps there', function()
            expectMultiplier(xi.element.ICE, 1, 1.30)
            expectMultiplier(xi.element.ICE, 5, 1.50)
            expectMultiplier(xi.element.ICE, 7, 1.50)
        end)

        it('ignores the target\'s elemental resistance rank', function()
            local target = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
            target:setMod(xi.mod.FIRE_RES_RANK, 5)
            expectMultiplier(xi.element.FIRE, 3, 1.40, target)
        end)
    end)
end)
