-----------------------------------
-- Mob skills as they were before the September 2008 update (Final Sting before April 2013).
-- Every file's overrides are checked, then one skill each for poison, damage and readiness.
-- Covers: modules/phoenix/lua/actions/mobskills/final_sting_pre_2013.lua
-- Covers: modules/phoenix/lua/actions/mobskills/leaf_dagger_pre_wotg.lua
-- Covers: modules/phoenix/lua/actions/mobskills/plague_breath_pre_wotg.lua
-- Covers: modules/phoenix/lua/actions/mobskills/poison_breath_crawler_pre_wotg.lua
-- Covers: modules/phoenix/lua/actions/mobskills/queasyshroom_pre_wotg.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Stubs the shared mob skill helpers and math.random (which then returns its upper bound), and
-- returns run(name), which calls the skill with stand-ins and gives back its log, in order.
local function skillRunner()
    local trace = {}

    for _, move in ipairs({ 'mobPhysicalMove', 'mobMagicalMove', 'mobBreathMove', 'mobRangedMove' }) do
        stub('xi.mobskills.' .. move, function(...)
            local params = select(5, ...)
            table.insert(trace, { name = move, args = { ... } })

            return { damage = 0, hybridDamage = 0, hitsLanded = 1, attackType = params.attackType, damageType = params.damageType }
        end)
    end

    stub('xi.mobskills.processDamage', true)
    stub('xi.mobskills.mobStatusEffectMove', function(...)
        table.insert(trace, { name = 'mobStatusEffectMove', args = { ... } })

        return xi.msg.basic.SKILL_ENFEEB_IS
    end)

    stub('math.random', function(_, high)
        return high
    end)

    return function(name)
        trace = {}

        local mob    = moduleTest.standIn(trace, 'mob', { getWeaponDmg = 41, getRangedDmg = 43, getMainLvl = 75, getHP = 900, getMaxHP = 1000, getHPP = 90, getID = 2 })
        local target = moduleTest.standIn(trace, 'target', { getMainLvl = 75, getHP = 900, getMaxHP = 1000, getHPP = 90, getID = 1 })
        local skill  = moduleTest.standIn(trace, 'skill', { getTP = 1000, getTotalTargets = 1, getMobHP = 900, getID = 0 })
        local action = moduleTest.standIn(trace, 'action', { getPrimaryTargetID = 1 })

        xi.actions.mobskills[name].onMobWeaponSkill(mob, target, skill, action)

        return trace
    end
end

-- The arguments of the first logged call with this name.
local function firstCall(trace, name)
    for _, entry in ipairs(trace) do
        if entry.name == name then
            return entry.args
        end
    end
end

describe('Phoenix era mob skills', function()
    it('applies the overrides of every mob skill', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('gives Plague Breath 3 poison a tick for up to 120 seconds', function()
        local effect = firstCall(skillRunner()('plague_breath'), 'mobStatusEffectMove')

        assert(effect, 'Plague Breath applied no status effect')
        assert(effect[3] == xi.effect.POISON, string.format('expected Poison, got %s', effect[3]))
        assert(effect[4] == 3, string.format('expected power 3, got %s', effect[4]))
        assert(effect[5] == 3, string.format('expected a 3 second tick, got %s', effect[5]))
        assert(effect[6] == 120, string.format('expected the longest roll to be 120 seconds, got %s', effect[6]))
    end)

    it('bases Leaf Dagger damage on the weapon, not the ranged slot', function()
        local move = firstCall(skillRunner()('leaf_dagger'), 'mobRangedMove')

        assert(move, 'Leaf Dagger passed no params')
        assert(move[5].baseDamage == 41, string.format('expected weapon damage 41, got %s', move[5].baseDamage))
    end)

    it('readies Final Sting at 33% HP, not before', function()
        local finalSting = xi.actions.mobskills.final_sting

        assert(finalSting.onMobSkillCheck(nil, moduleTest.standIn({}, 'mob', { getHPP = 40 }), nil) == 1, 'expected Final Sting to be unusable at 40% HP')
        assert(finalSting.onMobSkillCheck(nil, moduleTest.standIn({}, 'mob', { getHPP = 33 }), nil) == 0, 'expected Final Sting to be usable at 33% HP')
    end)
end)
