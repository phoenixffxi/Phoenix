-----------------------------------
-- Jug pet skills as they were before Seekers of Adoulin.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/actions/mobskills/era_jugpet_mobskills.lua'

-- Stubs the shared mob skill helpers and returns run(name, opts), which calls the jug pet skill
-- with stand-ins and gives back its log of helper calls and stand-in updates, in order.
-- opts: tp, level, nm.
local function skillRunner()
    local trace = {}

    local function logged(name, result)
        return function(...)
            table.insert(trace, { name = name, args = { ... } })

            return result
        end
    end

    for _, move in ipairs({ 'mobPhysicalMove', 'mobMagicalMove', 'mobBreathMove', 'mobRangedMove' }) do
        stub('xi.mobskills.' .. move, function(...)
            local params = select(5, ...)
            table.insert(trace, { name = move, args = { ... } })

            return { damage = 0, hybridDamage = 0, hitsLanded = 1, attackType = params.attackType, damageType = params.damageType }
        end)
    end

    stub('xi.mobskills.processDamage', true)
    stub('xi.mobskills.mobStatusEffectMove', logged('mobStatusEffectMove', xi.msg.basic.SKILL_ENFEEB_IS))
    stub('xi.mobskills.mobGazeMove', logged('mobGazeMove', xi.msg.basic.SKILL_ENFEEB_IS))
    stub('xi.mobskills.mobBuffMove', logged('mobBuffMove', xi.msg.basic.SKILL_GAIN_EFFECT))
    stub('xi.mobskills.mobDrainMove', logged('mobDrainMove', xi.msg.basic.EFFECT_DRAINED))
    stub('xi.mobskills.mobHealMove', logged('mobHealMove', 0))
    stub('xi.combat.action.executeMobskillStatusEffect', logged('executeMobskillStatusEffect', nil))

    return function(name, opts)
        opts  = opts or {}
        trace = {}

        local mob    = moduleTest.standIn(trace, 'mob', { getWeaponDmg = 41, getRangedDmg = 43, getMainLvl = opts.level or 75, getHP = 900, getMaxHP = 1000, getHPP = 90, getID = 2, isNM = opts.nm or false })
        local target = moduleTest.standIn(trace, 'target', { getWeaponDmg = 41, getMainLvl = 75, getHP = 900, getMaxHP = 1000, getHPP = 90, getID = 1, hasStatusEffect = false, addStatusEffect = true })
        local skill  = moduleTest.standIn(trace, 'skill', { getTP = opts.tp or 1000, getTotalTargets = 1, getMobHP = 900, getID = 0 })
        local action = moduleTest.standIn(trace, 'action', { getPrimaryTargetID = 1 })

        local skillScript = xi.actions.mobskills[name]
        assert(skillScript, string.format('no mob skill script for %s', name))

        xi.test.world:setSeed(1)
        skillScript.onMobWeaponSkill(mob, target, skill, action)

        return trace
    end
end

describe('Era jug pet mob skills', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('gives Mandibular Bite its pre-SoA fTP and critical hits', function()
        local moves = moduleTest.callsTo(skillRunner()('mandibular_bite_jugpet'), 'mobPhysicalMove')
        assert(#moves == 1, string.format('expected one physical move, got %d', #moves))

        local params = moves[1][5]
        assert(params.fTP[1] == 1.5 and params.fTP[2] == 1.5 and params.fTP[3] == 1.5, string.format('expected fTP 1.5 at every TP, got %s / %s / %s', params.fTP[1], params.fTP[2], params.fTP[3]))
        assert(params.canCrit == true, 'expected Mandibular Bite to crit')
        assert(params.criticalChance[1] == 0.10 and params.criticalChance[2] == 0.20 and params.criticalChance[3] == 0.25, 'expected crit chance 10% / 20% / 25%')
    end)

    describe('every jug pet skill #exhaustive', function()
        it('runs every override and passes only params the shared code reads', function()
            local run   = skillRunner()
            local known = moduleTest.paramKeys('mobskill')

            for _, override in ipairs(moduleTest.declarations(modulePath)) do
                local name = override:match('^xi%.actions%.mobskills%.([%w_%-]+)%.')
                for _, tp in ipairs({ 1000, 3000 }) do
                    local ok, trace = pcall(run, name, { tp = tp })
                    assert(ok, string.format('%s failed at %d TP: %s', name, tp, tostring(trace)))

                    for _, entry in ipairs(trace) do
                        if
                            entry.name:find('Move$') and
                            type(entry.args[5]) == 'table'
                        then
                            for key in pairs(entry.args[5]) do
                                assert(known[key], string.format('%s sets params.%s, which the shared code never reads', name, key))
                            end
                        end
                    end
                end
            end
        end)

        it('lowers Infrasonics and Hi-Freq Field to 25% Evasion Down', function()
            local run = skillRunner()
            for _, name in ipairs({ 'infrasonics_jugpet', 'hi-freq_field_jugpet' }) do
                local effects = moduleTest.callsTo(run(name), 'mobStatusEffectMove')
                assert(#effects == 1, string.format('%s: expected one status effect, got %d', name, #effects))

                local args = effects[1]
                assert(args[3] == xi.effect.EVASION_DOWN, string.format('%s: expected Evasion Down, got %s', name, args[3]))
                assert(args[4] == 25, string.format('%s: expected power 25, got %s', name, args[4]))
                assert(args[6] == 180, string.format('%s: expected 180 seconds, got %s', name, args[6]))
                assert(args[7] == 1, string.format('%s: expected sub type 1, got %s', name, args[7]))
            end
        end)

        it('gives Random Needles a flat 1000 damage that skips fSTR, parry, guard and block', function()
            local moves = moduleTest.callsTo(skillRunner()('random_needles_jugpet'), 'mobPhysicalMove')
            assert(#moves == 1, string.format('expected one physical move, got %d', #moves))

            local params = moves[1][5]
            assert(params.baseDamage == 1000, string.format('expected 1000 base damage, got %s', params.baseDamage))
            assert(params.skipFSTR == true, 'expected Random Needles to skip fSTR')
            assert(params.skipParry == true, 'expected Random Needles to skip parry')
            assert(params.skipGuard == true, 'expected Random Needles to skip guard')
            assert(params.skipBlock == true, 'expected Random Needles to skip block')
        end)

        it('leaves the mushroom skills final animation alone', function()
            local run = skillRunner()
            for _, name in ipairs({ 'queasyshroom_jugpet', 'numbshroom_jugpet', 'shakeshroom_jugpet' }) do
                local animations = moduleTest.callsTo(run(name), 'skill:setFinalAnimationSub')
                assert(#animations == 0, string.format('%s: expected no final animation change, got %d', name, #animations))
            end
        end)

        it('gives Rhino Guard its Evasion Boost without a sub type', function()
            local buffs = moduleTest.callsTo(skillRunner()('rhino_guard_jugpet'), 'mobBuffMove')
            assert(#buffs == 1, string.format('expected one buff, got %d', #buffs))
            assert(buffs[1][2] == xi.effect.EVASION_BOOST, string.format('expected Evasion Boost, got %s', buffs[1][2]))
            assert(buffs[1][6] == nil, string.format('expected no sub type, got %s', buffs[1][6]))
        end)

        it('keeps Harden Shell at 33 Defense Boost on a notorious monster', function()
            local buffs = moduleTest.callsTo(skillRunner()('harden_shell_jugpet', { nm = true }), 'mobBuffMove')
            assert(#buffs == 1, string.format('expected one buff, got %d', #buffs))
            assert(buffs[1][2] == xi.effect.DEFENSE_BOOST, string.format('expected Defense Boost, got %s', buffs[1][2]))
            assert(buffs[1][3] == 33, string.format('expected power 33, got %s', buffs[1][3]))
        end)

        it('leaves enmity alone after Hoof Volley', function()
            local resets = moduleTest.callsTo(skillRunner()('hoof_volley_jugpet'), 'mob:resetEnmity')
            assert(#resets == 0, string.format('expected no enmity reset, got %d', #resets))
        end)
    end)
end)
