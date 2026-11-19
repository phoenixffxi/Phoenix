-----------------------------------
-- Bio III and Dia III last as long as the caster's merit value (30s per rank).
-- Covers: modules/phoenix/lua/effects/dia.lua
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

describe('Phoenix Bio and Dia merit duration', function()
    local player

    local function expectDuration(effectId, params, expected)
        player:delStatusEffect(effectId)
        player:addStatusEffect(effectId, params)

        local effect = player:getStatusEffect(effectId)
        assert(effect, string.format('effect %d was not applied', effectId))
        assert(effect:getDuration() == expected, string.format('effect %d: expected %d ms, got %d', effectId, expected, effect:getDuration()))
        player:delStatusEffect(effectId)
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS, job = xi.job.RDM, level = 75 })
        player:gotoMogHouse(xi.zone.WINDURST_WOODS)
        if player:isInEvent() then
            player.events:finish()
        end

        player:setMerits(30)
        raiseMerit(player, xi.merit.BIO_III, 1)
        raiseMerit(player, xi.merit.DIA_III, 2)
        assert(player:getMerit(xi.merit.BIO_III) == 30, string.format('Bio III merit is %d, expected 30', player:getMerit(xi.merit.BIO_III)))
        assert(player:getMerit(xi.merit.DIA_III) == 60, string.format('Dia III merit is %d, expected 60', player:getMerit(xi.merit.DIA_III)))
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/effects/bio.lua')
        moduleTest.assertOverridesApplied('modules/phoenix/lua/effects/dia.lua')
    end)

    it('gives Bio III 30 seconds for one merit rank', function()
        expectDuration(xi.effect.BIO, { power = 5, duration = 180, origin = player, tick = 3, subPower = 15, tier = 6 }, 30000)
    end)

    it('gives Dia III 60 seconds for two merit ranks', function()
        expectDuration(xi.effect.DIA, { power = 3, duration = 180, origin = player, tick = 3, subPower = 15, tier = 5 }, 60000)
    end)

    describe('casting #exhaustive', function()
        it('sets the duration of a cast Bio III and Dia III from the merits', function()
            stub('xi.spells.damage.useDamageSpell', 0)

            xi.actions.spells.black.bio_iii.onSpellCast(player, player, GetSpell(xi.magic.spell.BIO_III))
            local bio = player:getStatusEffect(xi.effect.BIO)
            assert(bio, 'Bio III applied no effect')
            assert(bio:getDuration() == 30000, string.format('Bio III: expected 30000 ms, got %d', bio:getDuration()))
            player:delStatusEffect(xi.effect.BIO)

            xi.actions.spells.white.dia_iii.onSpellCast(player, player, GetSpell(xi.magic.spell.DIA_III))
            local dia = player:getStatusEffect(xi.effect.DIA)
            assert(dia, 'Dia III applied no effect')
            assert(dia:getDuration() == 60000, string.format('Dia III: expected 60000 ms, got %d', dia:getDuration()))
            player:delStatusEffect(xi.effect.DIA)
        end)
    end)
end)
