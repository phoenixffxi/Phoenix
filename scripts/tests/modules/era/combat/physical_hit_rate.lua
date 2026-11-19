-----------------------------------
-- Pre-December 2014 melee hit rate: every melee attack caps at 95 percent.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era physical hit rate cap', function()
    local player

    local function expectHitRateCap(attacker, slot)
        local cap = xi.combat.physicalHitRate.getPhysicalHitRateCap(attacker, slot)
        assert(cap == 0.95, string.format('expected a 0.95 cap, got %s', tostring(cap)))
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/combat/physical_hit_rate.lua')
    end)

    it('caps an unarmed player at 95 percent', function()
        expectHitRateCap(player, xi.attackAnimation.RIGHT_ATTACK)
    end)

    describe('every weapon #exhaustive', function()
        it('caps a one-handed main hand weapon at 95 percent', function()
            local swordsman = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
            swordsman:addItem(xi.item.ONION_SWORD)
            swordsman:equipItem(xi.item.ONION_SWORD, nil, xi.slot.MAIN)

            expectHitRateCap(swordsman, xi.attackAnimation.RIGHT_ATTACK)
        end)
    end)
end)
