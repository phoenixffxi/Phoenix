-----------------------------------
-- Automatons before 2010-2015: lower frame HP, slower magic, no frame damage taken cuts,
-- one-rank head skill bonuses and a flat 60 second maneuver duration.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/globals/pets/automaton.lua'

describe('Era automaton pets', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('gives the Harlequin frame its pre-2015 HP', function()
        local frameStats = xi.pets.automaton.frameStats[xi.automaton.frame.HARLEQUIN]

        assert(frameStats[1].maxHP == 36, string.format('expected 36 HP at level 1, got %d', frameStats[1].maxHP))
        assert(frameStats[75].maxHP == 1310, string.format('expected 1310 HP at level 75, got %d', frameStats[75].maxHP))
    end)

    describe('frames, heads and spawn #exhaustive', function()
        it('cuts every frame to its pre-2015 HP', function()
            local expected =
            {
                [xi.automaton.frame.VALOREDGE ] = 1663,
                [xi.automaton.frame.SHARPSHOT ] = 1028,
                [xi.automaton.frame.STORMWAKER] =  863,
            }

            for frame, maxHP in pairs(expected) do
                local level75 = xi.pets.automaton.frameStats[frame][75]
                assert(level75.maxHP == maxHP, string.format('frame %d: expected %d HP at level 75, got %d', frame, maxHP, level75.maxHP))
            end
        end)

        it('uses the era magic cooldowns', function()
            local cooldowns = xi.pets.automaton.magicCooldowns

            assert(cooldowns[xi.automaton.head.HARLEQUIN].global == 30, string.format('Harlequin: expected 30 second global cooldown, got %s', cooldowns[xi.automaton.head.HARLEQUIN].global))
            assert(cooldowns[xi.automaton.head.STORMWAKER].elemental == 30, string.format('Stormwaker: expected 30 second elemental cooldown, got %s', cooldowns[xi.automaton.head.STORMWAKER].elemental))
            assert(cooldowns[xi.automaton.head.SOULSOOTHER].enhancing == nil, 'Soulsoother: expected no enhancing cooldown')
        end)

        it('drops frame damage taken cuts and the Valoredge shield', function()
            local frameMods = xi.pets.automaton.frameMods

            for frame, mods in pairs(frameMods) do
                for _, mod in ipairs(mods.mods or {}) do
                    assert(mod[1] ~= xi.mod.DMG, string.format('frame %d: expected no damage taken modifier', frame))
                    assert(mod[1] ~= xi.mod.DMGMAGIC, string.format('frame %d: expected no magic damage taken modifier', frame))
                end
            end

            assert(frameMods[xi.automaton.frame.VALOREDGE].mobMods == nil, 'Valoredge: expected no shield block')
            assert(next(frameMods[xi.automaton.frame.STORMWAKER]) == nil, 'Stormwaker: expected no frame modifiers')
        end)

        it('gives the Valoredge, Sharpshot and Stormwaker heads a one-rank skill bonus', function()
            local heads = xi.pets.automaton.skillCaps.heads

            assert(heads[xi.automaton.head.VALOREDGE][xi.skill.AUTOMATON_MELEE] == -1, 'Valoredge: expected a one-rank melee bonus')
            assert(heads[xi.automaton.head.SHARPSHOT][xi.skill.AUTOMATON_RANGED] == -1, 'Sharpshot: expected a one-rank ranged bonus')
            assert(heads[xi.automaton.head.STORMWAKER][xi.skill.AUTOMATON_MAGIC] == -1, 'Stormwaker: expected a one-rank magic bonus')
        end)

        it('spawns without the in-combat maneuver duration growth', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.PUP, level = 75 })
            player:unlockAttachment(xi.item.HARLEQUIN_FRAME)
            player:unlockAttachment(xi.item.HARLEQUIN_HEAD)
            player:spawnPet(xi.petId.AUTOMATON)

            local automaton = player:getPet()
            assert(automaton, 'the automaton did not spawn')
            assert(not automaton:hasListener('EFFECTS_TICK'), 'expected no maneuver duration listener')
        end)
    end)
end)
