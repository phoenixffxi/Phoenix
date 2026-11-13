-----------------------------------
-- Era ancient magic II: no built-in magic accuracy bonus, and each merit rank past the first adds
-- 5 magic accuracy and 3% magic burst damage for the cast.
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

describe('Phoenix damage spells', function()
    local caster
    local target
    local seen

    -- Keeps base damage at one point and records what the resist roll sees.
    local function watchResistRoll()
        stub('xi.spells.damage.calculateBaseDamage', 1)
        stub('xi.combat.magicHitRate.calculateResistRate', function(actor, _, params)
            seen =
            {
                bonusMacc  = params.bonusMacc,
                macc       = actor:getMod(xi.mod.MACC),
                burstBonus = actor:getMod(xi.mod.MAGIC_BURST_BONUS_CAPPED),
            }

            return 1
        end)
    end

    local function cast(spellId)
        seen = nil
        xi.spells.damage.useDamageSpell(caster, target, GetSpell(spellId))
        target:setHP(target:getMaxHP())
        assert(seen, string.format('spell %d never reached the resist roll', spellId))
    end

    setup(function()
        caster = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS, job = xi.job.BLM, level = 75 })
        target = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/globals/spells/damage_spell.lua')
    end)

    it('gives Flare II no magic accuracy bonus', function()
        watchResistRoll()
        cast(xi.magic.spell.FLARE_II)
        assert(seen.bonusMacc == 0, string.format('expected no bonus magic accuracy, got %s', tostring(seen.bonusMacc)))
    end)

    describe('every ancient magic II spell #exhaustive', function()
        it('gives Freeze II, Tornado II, Quake II, Burst II and Flood II no magic accuracy bonus', function()
            local spells =
            {
                xi.magic.spell.FREEZE_II,
                xi.magic.spell.TORNADO_II,
                xi.magic.spell.QUAKE_II,
                xi.magic.spell.BURST_II,
                xi.magic.spell.FLOOD_II,
            }

            watchResistRoll()
            for _, spellId in ipairs(spells) do
                cast(spellId)
                assert(seen.bonusMacc == 0, string.format('spell %d: expected no bonus magic accuracy, got %s', spellId, tostring(seen.bonusMacc)))
            end
        end)

        it('adds 10 magic accuracy and 6% burst damage for three Flare II ranks, for the cast only', function()
            caster:gotoMogHouse(xi.zone.WINDURST_WOODS)
            if caster:isInEvent() then
                caster.events:finish()
            end

            caster:setMerits(30)
            raiseMerit(caster, xi.merit.FLARE_II, 3)
            assert(caster:getMerit(xi.merit.FLARE_II) == 3, string.format('Flare II merit is %d, expected 3', caster:getMerit(xi.merit.FLARE_II)))

            local macc  = caster:getMod(xi.mod.MACC)
            local burst = caster:getMod(xi.mod.MAGIC_BURST_BONUS_CAPPED)
            watchResistRoll()
            cast(xi.magic.spell.FLARE_II)

            assert(seen.macc == macc + 10, string.format('expected %d magic accuracy during the cast, got %s', macc + 10, tostring(seen.macc)))
            assert(seen.burstBonus == burst + 6, string.format('expected %d burst bonus during the cast, got %s', burst + 6, tostring(seen.burstBonus)))
            assert(
                caster:getMod(xi.mod.MACC) == macc and
                caster:getMod(xi.mod.MAGIC_BURST_BONUS_CAPPED) == burst,
                'the merit bonuses were not removed after the cast'
            )
        end)
    end)
end)
