-----------------------------------
-- Era weapon skills, as they were before WotG (automaton skills before Abyssea).
-- Every file's overrides are checked, then one weapon skill per damage path.
-- Covers: modules/era/lua/actions/weaponskills/archery.lua
-- Covers: modules/era/lua/actions/weaponskills/automaton.lua
-- Covers: modules/era/lua/actions/weaponskills/axe.lua
-- Covers: modules/era/lua/actions/weaponskills/club.lua
-- Covers: modules/era/lua/actions/weaponskills/dagger.lua
-- Covers: modules/era/lua/actions/weaponskills/great_axe.lua
-- Covers: modules/era/lua/actions/weaponskills/great_katana.lua
-- Covers: modules/era/lua/actions/weaponskills/great_sword.lua
-- Covers: modules/era/lua/actions/weaponskills/hand_to_hand.lua
-- Covers: modules/era/lua/actions/weaponskills/katana.lua
-- Covers: modules/era/lua/actions/weaponskills/marksmanship.lua
-- Covers: modules/era/lua/actions/weaponskills/polearm.lua
-- Covers: modules/era/lua/actions/weaponskills/scythe.lua
-- Covers: modules/era/lua/actions/weaponskills/staff.lua
-- Covers: modules/era/lua/actions/weaponskills/sword.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Stubs the shared mob skill damage functions and returns run(name, automaton, target), which
-- calls the automaton skill's onAutomatonAbility and gives back the params it passed on.
local function automatonRunner()
    local captured

    local function capture(_, _, _, _, params)
        captured = params

        return { damage = 0, attackType = xi.attackType.NONE, damageType = xi.damageType.NONE }
    end

    stub('xi.mobskills.mobPhysicalMove', capture)
    stub('xi.mobskills.mobRangedMove', capture)
    stub('xi.mobskills.mobMagicalMove', capture)
    stub('xi.mobskills.processDamage', function()
        return false
    end)

    return function(name, automaton, target)
        captured = nil
        local ability = xi.actions.abilities.pets.automaton[name]
        assert(ability, string.format('no automaton skill script for %s', name))
        ability.onAutomatonAbility(target, automaton, nil, automaton:getMaster(), nil)

        return captured
    end
end

describe('Era weapon skills', function()
    local player
    local automaton
    local target

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.PUP, level = 75 })
        target = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })

        player:unlockAttachment(xi.item.HARLEQUIN_FRAME)
        player:unlockAttachment(xi.item.HARLEQUIN_HEAD)
        player:spawnPet(xi.petId.AUTOMATON)
        automaton = player:getPet()
        assert(automaton, 'the automaton did not spawn')
    end)

    it('applies the overrides of every weapon type', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('gives Savage Blade its pre-WotG fTP and modifiers', function()
        local params = moduleTest.weaponskillRunner()('savage_blade', player, target, 1000)

        assert(params, 'Savage Blade passed no params')
        assert(params.numHits == 2, string.format('expected 2 hits, got %s', params.numHits))
        assert(params.ftpMod[1] == 1 and params.ftpMod[2] == 1.75 and params.ftpMod[3] == 3.5, 'expected fTP 1.00 / 1.75 / 3.50')
        assert(params.str_wsc == 0.3, string.format('expected STR 30%%, got %s', params.str_wsc))
        assert(params.mnd_wsc == 0.5, string.format('expected MND 50%%, got %s', params.mnd_wsc))
    end)

    it('gives Evisceration fTP on the first hit only', function()
        local params = moduleTest.weaponskillRunner()('evisceration', player, target, 1000)

        assert(params, 'Evisceration passed no params')
        assert(params.numHits == 5, string.format('expected 5 hits, got %s', params.numHits))
        assert(params.critVaries[1] == 0.1 and params.critVaries[2] == 0.24 and params.critVaries[3] == 0.48, 'expected crit rate 10% / 24% / 48%')
        assert(params.multiHitfTP == nil, 'expected fTP on the first hit only')
    end)

    it('gives Red Lotus Blade its pre-WotG fTP and magic damage params', function()
        local params = moduleTest.weaponskillRunner()('red_lotus_blade', player, target, 1000)

        assert(params, 'Red Lotus Blade passed no params')
        assert(params.ftpMod[1] == 1 and params.ftpMod[2] == 2.375 and params.ftpMod[3] == 3, 'expected fTP 1.00 / 2.375 / 3.00')
        assert(params.str_wsc == 0.3, string.format('expected STR 30%%, got %s', params.str_wsc))
        assert(params.int_wsc == 0.2, string.format('expected INT 20%%, got %s', params.int_wsc))
        assert(params.ele == xi.element.FIRE, 'expected fire damage')
    end)

    it('gives Empyreal Arrow its pre-WotG fTP and ranged accuracy', function()
        local params = moduleTest.weaponskillRunner()('empyreal_arrow', player, target, 1000)

        assert(params, 'Empyreal Arrow passed no params')
        assert(params.ftpMod[1] == 1.5 and params.ftpMod[2] == 2 and params.ftpMod[3] == 2.5, 'expected fTP 1.50 / 2.00 / 2.50')
        assert(params.agi_wsc == 0.25, string.format('expected AGI 25%%, got %s', params.agi_wsc))
        assert(params.rangedAccuracyBonus == 100, string.format('expected ranged accuracy +100, got %s', params.rangedAccuracyBonus))
    end)

    it('gives Arcuballista its pre-Abyssea fTP and modifier', function()
        local params = automatonRunner()('arcuballista', automaton, target)

        assert(params, 'Arcuballista passed no params')
        assert(params.fTP[1] == 2.5 and params.fTP[2] == 3 and params.fTP[3] == 4, string.format('expected fTP 2.50 / 3.00 / 4.00, got %s / %s / %s', params.fTP[1], params.fTP[2], params.fTP[3]))
        assert(params.dex_wSC == 0.3, string.format('expected DEX 30%%, got %s', params.dex_wSC))
    end)

    describe('every weapon skill #exhaustive', function()
        it('passes only params the shared code reads, at 1000, 2000 and 3000 TP', function()
            local run   = moduleTest.weaponskillRunner()
            local known = moduleTest.paramKeys('weaponskill')

            for _, path in ipairs(moduleTest.coveredFiles()) do
                for _, override in ipairs(moduleTest.declarations(path)) do
                    local wsName = override:match('^xi%.actions%.weaponskills%.([%w_]+)%.')
                    if wsName then
                        for _, tp in ipairs({ 1000, 2000, 3000 }) do
                            local params = run(wsName, player, target, tp) or {}
                            for key in pairs(params) do
                                assert(known[key], string.format('%s sets params.%s, which the shared code never reads', wsName, key))
                            end
                        end
                    end
                end
            end
        end)

        it('passes only params the shared mob skill code reads from automaton skills', function()
            local run   = automatonRunner()
            local known = moduleTest.paramKeys('mobskill')

            for _, override in ipairs(moduleTest.declarations('modules/era/lua/actions/weaponskills/automaton.lua')) do
                local name   = override:match('^xi%.actions%.abilities%.pets%.automaton%.([%w_]+)%.')
                local params = run(name, automaton, target)
                assert(params, string.format('%s passed no params', name))

                for key in pairs(params) do
                    assert(known[key], string.format('%s sets params.%s, which the shared code never reads', name, key))
                end
            end
        end)
    end)
end)
