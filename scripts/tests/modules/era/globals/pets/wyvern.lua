-----------------------------------
-- Wyverns before 2011: no innate damage taken cut, no wyvern experience, the old status breath
-- table, and a readying animation for the 3 second breath.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/globals/pets/wyvern.lua'

describe('Era wyverns', function()
    local player
    local wyvern

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.DRG, level = 75 })
        player:spawnPet(xi.petId.WYVERN)
        wyvern = player:getPet()
        assert(wyvern, 'the wyvern did not spawn')
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('has no innate damage taken cut and shows its breath readying', function()
        assert(wyvern:getMod(xi.mod.DMG) == 0, string.format('expected no damage taken modifier, got %d', wyvern:getMod(xi.mod.DMG)))
        assert(wyvern:getMod(xi.mod.WYVERN_SHOW_READYING) == 1, string.format('expected the readying flag, got %d', wyvern:getMod(xi.mod.WYVERN_SHOW_READYING)))
    end)

    describe('spawn and level loss #exhaustive', function()
        it('gives its master no wyvern experience listener', function()
            assert(not player:hasListener('EXPERIENCE_POINTS'), 'expected no experience listener on the master')
        end)

        it('removes paralysis, blindness and poison, but not curse, with a healer support job', function()
            local trace   = {}
            local afflict = xi.effect.CURSE_I
            local breath  = moduleTest.standIn(trace, 'wyvern', { getMainLvl = 75, checkDistance = 0 })
            local master  = moduleTest.standIn(trace, 'master', {
                getMod          = 0,
                getSubJob       = xi.job.WHM,
                getSubLvl       = 37,
                getParty        = {},
                getPet          = breath,
                hasStatusEffect = function(effectId)
                    return effectId == afflict
                end,
            })

            xi.pets.wyvern.onMobSpawn(moduleTest.standIn(trace, 'mob', { getMaster = master }))

            local listener
            for _, args in ipairs(moduleTest.callsTo(trace, 'master:addListener')) do
                if args[1] == 'WEAPONSKILL_USE' then
                    listener = args[3]
                end
            end

            assert(listener, 'no weapon skill listener on the master')

            listener(master, master, 0)
            assert(#moduleTest.callsTo(trace, 'wyvern:usePetAbility') == 0, 'expected no breath for curse')

            afflict = xi.effect.POISON
            listener(master, master, 0)

            local breaths = moduleTest.callsTo(trace, 'wyvern:usePetAbility')
            assert(#breaths == 1, string.format('expected one breath for poison, got %d', #breaths))
            assert(breaths[1][1] == xi.jobAbility.REMOVE_POISON, string.format('expected Remove Poison, got %s', breaths[1][1]))
        end)

        it('keeps all-hits weapon skill damage when wyvern levels are removed', function()
            local trace  = {}
            local master = moduleTest.standIn(trace, 'master', { getJobPointLevel = 0, getMod = 0 })

            xi.pets.wyvern.removeWyvernLevels(moduleTest.standIn(trace, 'mob', { getMaster = master, getLocalVar = 2 }))

            local removed = moduleTest.callsTo(trace, 'master:delMod')
            assert(#removed > 0, 'expected the level bonuses to be removed')

            for _, args in ipairs(removed) do
                assert(args[1] ~= xi.mod.ALL_WSDMG_ALL_HITS, 'expected all-hits weapon skill damage to stay')
            end
        end)
    end)
end)
