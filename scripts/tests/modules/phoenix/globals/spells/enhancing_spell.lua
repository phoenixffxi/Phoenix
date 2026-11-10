-----------------------------------
-- Era enhancing magic: pre-2019 Protect/Shell base power, random 30-300s Sneak, Invisible and
-- Deodorize, skill scaled bar-element duration, and merit ranks for Protectra V, Shellra V, Phalanx II.
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

-- A player of the given job at level 75, in their Mog House with the given merit ranks.
local function spawnWithMerits(job, merits)
    local player = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS, job = job, level = 75 })
    player:gotoMogHouse(xi.zone.WINDURST_WOODS)
    if player:isInEvent() then
        player.events:finish()
    end

    player:setMerits(30)
    for _, entry in ipairs(merits) do
        raiseMerit(player, entry[1], entry[2])
        assert(player:getMerit(entry[1]) == entry[3], string.format('merit %d is %d, expected %d', entry[1], player:getMerit(entry[1]), entry[3]))
    end

    return player
end

describe('Phoenix enhancing spells', function()
    local player

    local function expectBasePower(spellId, effectId, expected)
        local power = xi.spells.enhancing.calculateEnhancingBasePower(player, player, GetSpell(spellId), spellId, effectId)
        assert(power == expected, string.format('spell %d: expected base power %d, got %s', spellId, expected, tostring(power)))
    end

    local function expectDuration(caster, spellId, effectId, expected)
        local seconds = xi.spells.enhancing.calculateEnhancingDuration(caster, caster, GetSpell(spellId), spellId, xi.magic.spellGroup.WHITE, effectId)
        assert(seconds == expected, string.format('spell %d: expected %d s, got %s', spellId, expected, tostring(seconds)))
    end

    local function setEnhancingSkill(caster, skill)
        caster:setMod(xi.mod.ENHANCE, skill)
        caster:setSkillLevel(xi.skill.ENHANCING_MAGIC, 0)
        assert(caster:getSkillLevel(xi.skill.ENHANCING_MAGIC) == skill, string.format('enhancing skill is %d, expected %d', caster:getSkillLevel(xi.skill.ENHANCING_MAGIC), skill))
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WHM, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/globals/spells/enhancing_spell.lua')
    end)

    it('gives Protect a base of 10 defense', function()
        expectBasePower(xi.magic.spell.PROTECT, xi.effect.PROTECT, 10)
    end)

    it('gives Sneak a random 30-300s base duration', function()
        local seconds = xi.spells.enhancing.calculateEnhancingDuration(player, player, GetSpell(xi.magic.spell.SNEAK), xi.magic.spell.SNEAK, xi.magic.spellGroup.WHITE, xi.effect.SNEAK)
        assert(
            seconds >= 30 and
            seconds <= 300,
            string.format('expected 30-300 s, got %s', tostring(seconds))
        )
    end)

    describe('every adjustment #exhaustive', function()
        it('reverts every Protect and Shell base power', function()
            local eraBasePower =
            {
                { xi.magic.spell.PROTECT,       xi.effect.PROTECT,   10 },
                { xi.magic.spell.PROTECT_II,    xi.effect.PROTECT,   25 },
                { xi.magic.spell.PROTECT_III,   xi.effect.PROTECT,   40 },
                { xi.magic.spell.PROTECT_IV,    xi.effect.PROTECT,   55 },
                { xi.magic.spell.PROTECT_V,     xi.effect.PROTECT,   60 },
                { xi.magic.spell.PROTECTRA,     xi.effect.PROTECT,   10 },
                { xi.magic.spell.PROTECTRA_II,  xi.effect.PROTECT,   25 },
                { xi.magic.spell.PROTECTRA_III, xi.effect.PROTECT,   40 },
                { xi.magic.spell.PROTECTRA_IV,  xi.effect.PROTECT,   55 },
                { xi.magic.spell.PROTECTRA_V,   xi.effect.PROTECT,   60 },
                { xi.magic.spell.SHELL,         xi.effect.SHELL,    937 },
                { xi.magic.spell.SHELL_II,      xi.effect.SHELL,   1406 },
                { xi.magic.spell.SHELL_III,     xi.effect.SHELL,   1875 },
                { xi.magic.spell.SHELL_IV,      xi.effect.SHELL,   2187 },
                { xi.magic.spell.SHELL_V,       xi.effect.SHELL,   2421 },
                { xi.magic.spell.SHELLRA,       xi.effect.SHELL,    937 },
                { xi.magic.spell.SHELLRA_II,    xi.effect.SHELL,   1406 },
                { xi.magic.spell.SHELLRA_III,   xi.effect.SHELL,   1875 },
                { xi.magic.spell.SHELLRA_IV,    xi.effect.SHELL,   2187 },
                { xi.magic.spell.SHELLRA_V,     xi.effect.SHELL,   2421 },
            }

            for _, entry in ipairs(eraBasePower) do
                expectBasePower(entry[1], entry[2], entry[3])
            end
        end)

        it('casts Protect for 10 defense', function()
            player:delStatusEffect(xi.effect.PROTECT)
            player:addSpell(xi.magic.spell.PROTECT)
            player:setMP(player:getMaxMP())
            player.actions:useSpell(player, xi.magic.spell.PROTECT)
            xi.test.world:tickEntity(player)
            xi.test.world:skipTime(5)

            local protect = player:getStatusEffect(xi.effect.PROTECT)
            assert(protect, 'Protect was not applied')
            assert(protect:getPower() == 10, string.format('expected 10 defense, got %d', protect:getPower()))
            player:delStatusEffect(xi.effect.PROTECT)
        end)

        it('draws Sneak, Invisible and Deodorize from 30-300s before gear and Composure', function()
            local low = stub('math.randomInt', function(min)
                return min
            end)

            expectDuration(player, xi.magic.spell.SNEAK, xi.effect.SNEAK, 30)
            expectDuration(player, xi.magic.spell.DEODORIZE, xi.effect.DEODORIZE, 30)

            player:addMod(xi.mod.INVISIBLE_DURATION, 15)
            expectDuration(player, xi.magic.spell.INVISIBLE, xi.effect.INVISIBLE, 45)
            player:delMod(xi.mod.INVISIBLE_DURATION, 15)

            low:called()
        end)

        it('triples a self-cast Sneak under Composure and cuts it for a lower level target', function()
            stub('math.randomInt', function(_, max)
                return max
            end)

            player:addStatusEffect(xi.effect.COMPOSURE, { power = 1, duration = 7200, origin = player })
            expectDuration(player, xi.magic.spell.SNEAK, xi.effect.SNEAK, 900)
            player:delStatusEffect(xi.effect.COMPOSURE)

            player:setLevel(10)
            expectDuration(player, xi.magic.spell.SNEAK, xi.effect.SNEAK, 150)
            player:setLevel(75)
        end)

        it('scales bar-element duration with enhancing skill', function()
            setEnhancingSkill(player, 100)
            expectDuration(player, xi.magic.spell.BARFIRE, xi.effect.BARFIRE, 150)

            setEnhancingSkill(player, 280)
            expectDuration(player, xi.magic.spell.BARFIRE, xi.effect.BARFIRE, 230)
            expectDuration(player, xi.magic.spell.BARFIRA, xi.effect.BARFIRE, 230)
            setEnhancingSkill(player, 0)
        end)

        it('takes the five core Phalanx II merit ranks off a caster without merits', function()
            local rdm   = xi.test.world:spawnPlayer({ job = xi.job.RDM, level = 75 })
            local spell = GetSpell(xi.magic.spell.PHALANX_II)
            local base  = xi.spells.enhancing.calculateEnhancingBasePower(rdm, rdm, spell, xi.magic.spell.PHALANX_II, xi.effect.PHALANX)
            local final = xi.spells.enhancing.calculateEnhancingFinalPower(rdm, rdm, spell, base, xi.magic.spellGroup.WHITE, 2, xi.effect.PHALANX)

            assert(final - base == -12, string.format('expected -12 power, got %+d', final - base))
            expectDuration(rdm, xi.magic.spell.PHALANX_II, xi.effect.PHALANX, 120)
        end)

        it('adds merit ranks to Protectra V and Shellra V', function()
            local whm = spawnWithMerits(xi.job.WHM, { { xi.merit.PROTECTRA_V, 3, 15 }, { xi.merit.SHELLRA_V, 3, 6 } })

            for _, entry in ipairs({ { xi.magic.spell.PROTECTRA_V, xi.effect.PROTECT, 4 }, { xi.magic.spell.SHELLRA_V, xi.effect.SHELL, 156 } }) do
                local spell = GetSpell(entry[1])
                local base  = xi.spells.enhancing.calculateEnhancingBasePower(whm, whm, spell, entry[1], entry[2])
                local final = xi.spells.enhancing.calculateEnhancingFinalPower(whm, whm, spell, base, xi.magic.spellGroup.WHITE, 5, entry[2])
                assert(final - base == entry[3], string.format('spell %d: expected %+d for three ranks, got %+d', entry[1], entry[3], final - base))
            end
        end)

        it('gives Phalanx II three merit ranks of power and duration over the core five', function()
            local rdm   = spawnWithMerits(xi.job.RDM, { { xi.merit.PHALANX_II, 3, 9 } })
            local spell = GetSpell(xi.magic.spell.PHALANX_II)
            local base  = xi.spells.enhancing.calculateEnhancingBasePower(rdm, rdm, spell, xi.magic.spell.PHALANX_II, xi.effect.PHALANX)
            local final = xi.spells.enhancing.calculateEnhancingFinalPower(rdm, rdm, spell, base, xi.magic.spellGroup.WHITE, 2, xi.effect.PHALANX)

            assert(final - base == -6, string.format('expected -6 power, got %+d', final - base))
            expectDuration(rdm, xi.magic.spell.PHALANX_II, xi.effect.PHALANX, 180)
        end)
    end)
end)
