-----------------------------------
-- Era enfeebling magic: pre-2015 Blind, Poison and Dokumori potency, variable Blind, Paralyze and
-- Silence durations, 30s Poison, and merit ranks for Slow II, Paralyze II and Blind II.
-----------------------------------
---@diagnostic disable: undefined-field
local ffi        = require('ffi')
local moduleTest = require('scripts.tests.helpers.modules')

-- Raises a merit through the client's merit menu packet, from the player's Mog House.
local function raiseMerit(player, merit, ranks)
    for _ = 1, ranks do
        local packet = ffi.new('uint8_t[12]')
        packet[4] = 3 -- edit mode
        packet[5] = 1 -- raise
        packet[6] = bit.band(bit.rshift(merit, 1), 0xFF)
        packet[7] = bit.rshift(merit, 9)
        player.packets:send(0x0BE, packet, ffi.sizeof(packet))
    end
end

-- Reads go to the real spell; setters are dropped so the shared spell object is left as it was.
local function spellDouble(spellId)
    local spell = GetSpell(spellId)
    assert(spell, string.format('no spell %d', spellId))

    return setmetatable({}, {
        __index = function(_, key)
            if string.find(key, '^set') then
                return function()
                end
            end

            return function(_, ...)
                return spell[key](spell, ...)
            end
        end,
    })
end

describe('Phoenix enfeebling spells', function()
    local player

    -- Potency of a spell the caster casts on themself, so stat differences are their own stats.
    local function expectPotency(caster, spellId, effectId, skillType, statUsed, expected)
        local potency = xi.spells.enfeebling.calculatePotency(caster, caster, spellId, effectId, skillType, statUsed)
        assert(potency == expected, string.format('spell %d: expected potency %d, got %s', spellId, expected, tostring(potency)))
    end

    local function expectDuration(spellId, effectId, expected)
        local seconds = xi.spells.enfeebling.calculateDuration(player, player, spellId, effectId, xi.skill.ENFEEBLING_MAGIC)
        assert(seconds == expected, string.format('spell %d: expected %d s, got %s', spellId, expected, tostring(seconds)))
    end

    local function setEnfeeblingSkill(caster, skill)
        caster:setMod(xi.mod.ENFEEBLE, skill)
        caster:setSkillLevel(xi.skill.ENFEEBLING_MAGIC, 0)
        assert(caster:getSkillLevel(xi.skill.ENFEEBLING_MAGIC) == skill, string.format('enfeebling skill is %d, expected %d', caster:getSkillLevel(xi.skill.ENFEEBLING_MAGIC), skill))
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.BLM, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/globals/spells/enfeebling_spell.lua')
    end)

    it('gives Blind (dINT - MND + 60) / 4 potency', function()
        local expected = math.floor((player:getStat(xi.mod.INT) - player:getStat(xi.mod.MND) + 60) / 4)
        expectPotency(player, xi.magic.spell.BLIND, xi.effect.BLINDNESS, xi.skill.ENFEEBLING_MAGIC, xi.mod.INT, expected)
    end)

    it('gives Poison a 30s base duration', function()
        expectDuration(xi.magic.spell.POISON, xi.effect.POISON, 30)
    end)

    it('takes the five core Slow II merit ranks off a caster without merits', function()
        expectPotency(player, xi.magic.spell.SLOW_II, xi.effect.SLOW, xi.skill.ENFEEBLING_MAGIC, xi.mod.MND, 2380)
    end)

    describe('every adjustment #exhaustive', function()
        it('gives Blind II (dINT - MND + 100) / 4 potency', function()
            local expected = math.floor((player:getStat(xi.mod.INT) - player:getStat(xi.mod.MND) + 100) / 4)
            expectPotency(player, xi.magic.spell.BLIND_II, xi.effect.BLINDNESS, xi.skill.ENFEEBLING_MAGIC, xi.mod.INT, expected)
        end)

        it('steps Poison, Poisonga and Poison II potency by enfeebling skill', function()
            local steps =
            {
                { xi.magic.spell.POISON,     79,  1 },
                { xi.magic.spell.POISON,     80,  2 },
                { xi.magic.spell.POISON,    159,  2 },
                { xi.magic.spell.POISON,    240,  4 },
                { xi.magic.spell.POISONGA,  160,  3 },
                { xi.magic.spell.POISON_II, 124,  4 },
                { xi.magic.spell.POISON_II, 125,  5 },
                { xi.magic.spell.POISON_II, 199,  7 },
                { xi.magic.spell.POISON_II, 250, 10 },
            }

            local caster = xi.test.world:spawnPlayer({ job = xi.job.BLM, level = 75 })
            for _, entry in ipairs(steps) do
                setEnfeeblingSkill(caster, entry[2])
                expectPotency(caster, entry[1], xi.effect.POISON, xi.skill.ENFEEBLING_MAGIC, xi.mod.INT, entry[3])
            end
        end)

        it('gives Dokumori: Ichi 2 HP a tick', function()
            expectPotency(player, xi.magic.spell.DOKUMORI_ICHI, xi.effect.POISON, xi.skill.NINJUTSU, xi.mod.INT, 2)
        end)

        it('draws Blind, Paralyze and Silence durations from their ranges', function()
            stub('math.randomInt', function(min)
                return min
            end)

            expectDuration(xi.magic.spell.BLIND, xi.effect.BLINDNESS, 80)
            expectDuration(xi.magic.spell.BLIND_II, xi.effect.BLINDNESS, 80)
            expectDuration(xi.magic.spell.PARALYZE, xi.effect.PARALYSIS, 30)
            expectDuration(xi.magic.spell.PARALYZE_II, xi.effect.PARALYSIS, 30)
            expectDuration(xi.magic.spell.SILENCE, xi.effect.SILENCE, 30)
            expectDuration(xi.magic.spell.POISONGA, xi.effect.POISON, 30)
        end)

        it('caps Blind at 300s and Paralyze and Silence at 120s', function()
            stub('math.randomInt', function(_, max)
                return max
            end)

            expectDuration(xi.magic.spell.BLIND, xi.effect.BLINDNESS, 300)
            expectDuration(xi.magic.spell.PARALYZE, xi.effect.PARALYSIS, 120)
            expectDuration(xi.magic.spell.SILENCE, xi.effect.SILENCE, 120)
        end)

        describe('with merits', function()
            local rdm

            setup(function()
                rdm = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS, job = xi.job.RDM, level = 75 })
                rdm:gotoMogHouse(xi.zone.WINDURST_WOODS)
                if rdm:isInEvent() then
                    rdm.events:finish()
                end

                rdm:setMerits(30)
                raiseMerit(rdm, xi.merit.SLOW_II, 3)
                raiseMerit(rdm, xi.merit.PARALYZE_II, 3)
                assert(rdm:getMerit(xi.merit.SLOW_II) == 3, string.format('Slow II merit is %d, expected 3', rdm:getMerit(xi.merit.SLOW_II)))
                assert(rdm:getMerit(xi.merit.PARALYZE_II) == 3, string.format('Paralyze II merit is %d, expected 3', rdm:getMerit(xi.merit.PARALYZE_II)))
            end)

            it('counts three Slow II and Paralyze II ranks against the core five', function()
                expectPotency(rdm, xi.magic.spell.SLOW_II, xi.effect.SLOW, xi.skill.ENFEEBLING_MAGIC, xi.mod.MND, 2580)
                expectPotency(rdm, xi.magic.spell.PARALYZE_II, xi.effect.PARALYSIS, xi.skill.ENFEEBLING_MAGIC, xi.mod.MND, 22)
            end)

            it('adds 2 magic accuracy a rank past the first for the Slow II cast only', function()
                local before = rdm:getMod(xi.mod.MACC)
                local during
                stub('xi.combat.magicHitRate.calculateResistRate', function(caster)
                    during = caster:getMod(xi.mod.MACC)
                    return 1
                end)

                rdm:delStatusEffect(xi.effect.SLOW)
                xi.spells.enfeebling.useEnfeeblingSpell(rdm, rdm, spellDouble(xi.magic.spell.SLOW_II))
                rdm:delStatusEffect(xi.effect.SLOW)

                assert(during == before + 4, string.format('expected %d magic accuracy during the cast, got %s', before + 4, tostring(during)))
                assert(rdm:getMod(xi.mod.MACC) == before, 'the magic accuracy bonus was not removed after the cast')
            end)
        end)
    end)
end)
