-----------------------------------
-- Blood Pact: Rage damage as it was before the November 2016 update (1.0 fTP after the first hit).
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/actions/abilities/pets/bloodpact_rage.lua'

-- Stubs the shared skill helpers and returns run(fn, tp), which calls a blood pact's onPetAbility
-- with stand-ins and gives back its log of helper calls and stand-in updates, in order.
local function skillRunner()
    local trace = {}

    local function logged(name, result)
        return function(...)
            table.insert(trace, { name = name, args = { ... } })

            return result
        end
    end

    for _, move in ipairs({ 'mobPhysicalMove', 'mobMagicalMove', 'mobRangedMove' }) do
        stub('xi.mobskills.' .. move, function(...)
            local params = select(5, ...)
            table.insert(trace, { name = move, args = { ... } })

            return { damage = 0, hybridDamage = 0, hitsLanded = 1, attackType = params.attackType, damageType = params.damageType }
        end)
    end

    stub('xi.mobskills.processDamage', true)
    stub('xi.mobskills.mobStatusEffectMove', logged('mobStatusEffectMove', xi.msg.basic.SKILL_ENFEEB_IS))
    stub('xi.mobskills.mobBuffMove', logged('mobBuffMove', xi.msg.basic.SKILL_GAIN_EFFECT))
    stub('xi.mobskills.mobHealMove', logged('mobHealMove', 0))
    stub('xi.combat.action.executeMobskillStatusEffect', logged('executeMobskillStatusEffect', nil))
    stub('xi.job_utils.summoner.onUseBloodPact', function()
    end)

    return function(fn, tp)
        trace = {}

        local summoner = moduleTest.standIn(trace, 'summoner', { getMainLvl = 75, getSkillLevel = 350, getID = 3 })
        local pet      = moduleTest.standIn(trace, 'pet', { getWeaponDmg = 41, getRangedDmg = 43, getMainLvl = 75, getHP = 900, getMaxHP = 1000, getHPP = 90, getID = 2, getMaster = summoner })
        local target   = moduleTest.standIn(trace, 'target', { getMainLvl = 75, getHP = 900, getMaxHP = 1000, getHPP = 90, getID = 1, hasStatusEffect = false, addStatusEffect = true })
        local petskill = moduleTest.standIn(trace, 'skill', { getTP = tp, getTotalTargets = 1, getID = 0 })
        local action   = moduleTest.standIn(trace, 'action', { getPrimaryTargetID = 1 })

        xi.test.world:setSeed(1)
        fn(target, pet, petskill, summoner, action)

        return trace
    end
end

-- The params the blood pact passed to its damage move, or nil.
local function damageParams(trace)
    for _, entry in ipairs(trace) do
        if entry.name:find('Move$') then
            return entry.args[5]
        end
    end
end

describe('Era Blood Pact: Rage', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('gives Axe Kick 1.0 fTP after the first hit', function()
        local params = damageParams(skillRunner()(xi.actions.abilities.pets.axe_kick.onPetAbility, 1000))

        assert(params, 'Axe Kick passed no params')
        assert(params.fTP[1] == 2 and params.fTP[2] == 2 and params.fTP[3] == 2, 'expected fTP 2.0 at every TP')
        assert(params.fTPSubsequentHits[1] == 1 and params.fTPSubsequentHits[2] == 1 and params.fTPSubsequentHits[3] == 1, string.format('expected 1.0 fTP after the first hit, got %s / %s / %s', params.fTPSubsequentHits[1], params.fTPSubsequentHits[2], params.fTPSubsequentHits[3]))
    end)

    describe('every Rage blood pact #exhaustive', function()
        it('passes only params the shared code reads', function()
            local run   = skillRunner()
            local known = moduleTest.paramKeys('mobskill')

            for _, override in ipairs(moduleTest.declarations(modulePath)) do
                local name   = override:match('^xi%.actions%.abilities%.pets%.([%w_]+)%.')
                local params = damageParams(run(xi.actions.abilities.pets[name].onPetAbility, 1000))
                assert(params, string.format('%s passed no params', name))

                for key in pairs(params) do
                    assert(known[key], string.format('%s sets params.%s, which the shared code never reads', name, key))
                end
            end
        end)

        it('uses 1.0 fTP after the first hit, except Burning Strike and Camisado', function()
            local run  = skillRunner()
            local kept = set{ 'burning_strike', 'camisado' }

            for _, override in ipairs(moduleTest.declarations(modulePath)) do
                local name = override:match('^xi%.actions%.abilities%.pets%.([%w_]+)%.')
                if not kept[name] then
                    local params = damageParams(run(xi.actions.abilities.pets[name].onPetAbility, 3000))
                    for i = 1, 3 do
                        assert(params.fTPSubsequentHits[i] == 1, string.format('%s: expected 1.0 fTP after the first hit, got %s', name, params.fTPSubsequentHits[i]))
                    end
                end
            end
        end)

        it('acts differently from upstream on every blood pact it changes', function()
            local run       = skillRunner()
            -- These overrides match upstream today.
            local unchanged = set{ 'burning_strike', 'camisado', 'flaming_crush', 'moonlit_charge', 'regal_scratch', 'rock_throw' }

            for _, override in ipairs(moduleTest.declarations(modulePath)) do
                local name = override:match('^xi%.actions%.abilities%.pets%.([%w_]+)%.')
                if not unchanged[name] then
                    local ours, upstream = moduleTest.overrideAndUpstream(override, modulePath)
                    assert(ours, string.format('%s: no override from %s in the chain', name, modulePath))

                    local oursLog     = {}
                    local upstreamLog = {}
                    for _, tp in ipairs({ 1000, 2000, 3000 }) do
                        table.insert(oursLog, moduleTest.render(run(ours, tp)))
                        table.insert(upstreamLog, moduleTest.render(run(upstream, tp)))
                    end

                    assert(table.concat(oursLog) ~= table.concat(upstreamLog), string.format('%s acts the same as upstream', name))
                end
            end
        end)
    end)
end)
