-----------------------------------
-- Blood Pact: Ward durations as they were before the 2010 doubling and skill-based extension.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/actions/abilities/pets/bloodpact_ward.lua'

-- Stubs the shared skill helpers and returns run(fn, opts), which calls a blood pact's onPetAbility
-- with stand-ins and gives back its log of helper calls and stand-in updates, in order.
-- opts: tp, overCap (summoning skill over the cap). The summoner has 350 skill, so upstream extends.
local function skillRunner()
    local trace   = {}
    local overCap = 0

    local function logged(name, result)
        return function(...)
            table.insert(trace, { name = name, args = { ... } })

            return result
        end
    end

    stub('xi.mobskills.mobBuffMove', logged('mobBuffMove', xi.msg.basic.SKILL_GAIN_EFFECT))
    stub('xi.mobskills.mobHealMove', logged('mobHealMove', 0))
    stub('xi.mobskills.mobStatusEffectMove', logged('mobStatusEffectMove', xi.msg.basic.SKILL_ENFEEB_IS))
    stub('xi.job_utils.summoner.onUseBloodPact', function()
    end)

    stub('xi.summon.getSummoningSkillOverCap', function()
        return overCap
    end)

    return function(fn, opts)
        opts    = opts or {}
        trace   = {}
        overCap = opts.overCap or 10

        local summoner = moduleTest.standIn(trace, 'summoner', { getMainLvl = 75, getSkillLevel = 350, getID = 3 })
        local pet      = moduleTest.standIn(trace, 'pet', { getMainLvl = 75, getHP = 900, getMaxHP = 1000, getID = 2, getMaster = summoner })
        local target   = moduleTest.standIn(trace, 'target', { getMainLvl = 75, getHP = 900, getMaxHP = 1000, getID = 1, hasStatusEffect = false, addStatusEffect = true })
        local petskill = moduleTest.standIn(trace, 'skill', { getTP = opts.tp or 1000, getTotalTargets = 1, getID = 0 })
        local action   = moduleTest.standIn(trace, 'action', { getPrimaryTargetID = 1 })

        xi.test.world:setSeed(1)
        fn(target, pet, petskill, summoner, action)

        return trace
    end
end

-- The effect and duration each ward gives when the summoner is 10 skill over the cap.
local wardDurations =
{
    ['crimson_howl'   ] = { xi.effect.WARCRY,           40 },
    ['dream_shroud'   ] = { xi.effect.MAGIC_ATK_BOOST, 180 },
    ['ecliptic_growl' ] = { xi.effect.STR_BOOST,       180 },
    ['ecliptic_howl'  ] = { xi.effect.ACCURACY_BOOST,  180 },
    ['frost_armor'    ] = { xi.effect.ICE_SPIKES,      120 },
    ['hastega'        ] = { xi.effect.HASTE,           120 },
    ['lightning_armor'] = { xi.effect.SHOCK_SPIKES,    120 },
    ['noctoshield'    ] = { xi.effect.PHALANX,         180 },
    ['shining_ruby'   ] = { xi.effect.SHINING_RUBY,    180 },
}

describe('Era Blood Pact: Ward', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('gives Hastega a 90 second base plus 3 seconds per skill over the cap', function()
        local effects = moduleTest.callsTo(skillRunner()(xi.actions.abilities.pets.hastega.onPetAbility), 'target:addStatusEffect')
        assert(#effects == 1, string.format('expected one effect, got %d', #effects))

        local effectId, effect = effects[1][1], effects[1][2]
        assert(effectId == xi.effect.HASTE, string.format('expected Haste, got %s', effectId))
        assert(effect.duration == 120, string.format('expected 120 seconds, got %s', effect.duration))
        assert(effect.power == 1494, string.format('expected power 1494, got %s', effect.power))
        assert(effect.tier == 1, string.format('expected tier 1, got %s', effect.tier))
    end)

    describe('every Ward blood pact #exhaustive', function()
        it('gives each ward its era duration', function()
            local run = skillRunner()
            for name, expected in pairs(wardDurations) do
                local found = false
                for _, args in ipairs(moduleTest.callsTo(run(xi.actions.abilities.pets[name].onPetAbility), 'target:addStatusEffect')) do
                    if args[1] == expected[1] then
                        found = true
                        assert(args[2].duration == expected[2], string.format('%s: expected %d seconds, got %s', name, expected[2], args[2].duration))
                    end
                end

                assert(found, string.format('%s: did not apply effect %d', name, expected[1]))
            end
        end)

        it('gives Glittering Ruby and Rolling Thunder their era durations', function()
            local run    = skillRunner()
            local effects = moduleTest.callsTo(run(xi.actions.abilities.pets.glittering_ruby.onPetAbility), 'target:addStatusEffect')
            assert(#effects == 1, string.format('Glittering Ruby: expected one effect, got %d', #effects))
            assert(effects[1][2].duration == 120, string.format('Glittering Ruby: expected 120 seconds, got %s', effects[1][2].duration))

            local buffs = moduleTest.callsTo(run(xi.actions.abilities.pets.rolling_thunder.onPetAbility), 'mobBuffMove')
            assert(#buffs == 1, string.format('Rolling Thunder: expected one buff, got %d', #buffs))
            assert(buffs[1][2] == xi.effect.ENTHUNDER, string.format('Rolling Thunder: expected Enthunder, got %s', buffs[1][2]))
            assert(buffs[1][5] == 80, string.format('Rolling Thunder: expected 80 seconds, got %s', buffs[1][5]))
        end)

        it('caps Hastega at 180 seconds', function()
            local effects = moduleTest.callsTo(skillRunner()(xi.actions.abilities.pets.hastega.onPetAbility, { overCap = 40 }), 'target:addStatusEffect')
            assert(#effects == 1, string.format('expected one effect, got %d', #effects))
            assert(effects[1][2].duration == 180, string.format('expected 180 seconds, got %s', effects[1][2].duration))
        end)

        it('heals with the era Spring Water and Whispering Wind formulas', function()
            local run    = skillRunner()
            local spring = moduleTest.callsTo(run(xi.actions.abilities.pets.spring_water.onPetAbility), 'mobHealMove')
            assert(#spring == 1, string.format('Spring Water: expected one heal, got %d', #spring))
            assert(spring[1][5].baseHeal == 225, string.format('Spring Water: expected base heal 225, got %s', spring[1][5].baseHeal))
            assert(spring[1][5].additiveHeal == 47, string.format('Spring Water: expected 47 added, got %s', spring[1][5].additiveHeal))

            local wind = moduleTest.callsTo(run(xi.actions.abilities.pets.whispering_wind.onPetAbility), 'mobHealMove')
            assert(#wind == 1, string.format('Whispering Wind: expected one heal, got %d', #wind))
            assert(wind[1][5].baseHeal == 187.5, string.format('Whispering Wind: expected base heal 187.5, got %s', wind[1][5].baseHeal))
            assert(wind[1][5].additiveHeal == 16, string.format('Whispering Wind: expected 16 added, got %s', wind[1][5].additiveHeal))
        end)

        it('acts differently from upstream on every ward it changes', function()
            local run       = skillRunner()
            -- These overrides match upstream today.
            local unchanged = set{ 'healing_ruby', 'healing_ruby_ii' }

            for _, override in ipairs(moduleTest.declarations(modulePath)) do
                local name = override:match('^xi%.actions%.abilities%.pets%.([%w_]+)%.')
                if not unchanged[name] then
                    local ours, upstream = moduleTest.overrideAndUpstream(override, modulePath)
                    assert(ours, string.format('%s: no override from %s in the chain', name, modulePath))
                    assert(moduleTest.render(run(ours)) ~= moduleTest.render(run(upstream)), string.format('%s acts the same as upstream', name))
                end
            end
        end)
    end)
end)
