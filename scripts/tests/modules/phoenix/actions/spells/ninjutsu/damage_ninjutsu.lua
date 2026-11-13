-----------------------------------
-- Era San ninjutsu merits: each rank past the first adds 5 magic attack and 5 magic accuracy to the cast.
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

describe('Phoenix damage ninjutsu', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS, job = xi.job.NIN, level = 75 })
        player:gotoMogHouse(xi.zone.WINDURST_WOODS)
        if player:isInEvent() then
            player.events:finish()
        end

        player:setMerits(30)
        raiseMerit(player, xi.merit.KATON_SAN, 2)
        assert(player:getMerit(xi.merit.KATON_SAN) == 10, string.format('Katon: San merit is %d, expected 10', player:getMerit(xi.merit.KATON_SAN)))
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/actions/spells/ninjutsu/damage_ninjutsu.lua')
    end)

    it('adds 5 magic attack to Katon: San for two merit ranks', function()
        local san = xi.spells.damage.calculateMagicBonusDiff(player, player, xi.magic.spell.KATON_SAN, xi.skill.NINJUTSU, xi.element.FIRE, 0)
        local ni  = xi.spells.damage.calculateMagicBonusDiff(player, player, xi.magic.spell.KATON_NI, xi.skill.NINJUTSU, xi.element.FIRE, 5)
        assert(san == ni, string.format('expected Katon: San to match Katon: Ni with +5 magic attack (%s), got %s', tostring(ni), tostring(san)))
    end)

    describe('casting #exhaustive', function()
        local target

        setup(function()
            target = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
        end)

        it('adds 5 magic accuracy for the Katon: San cast only', function()
            local before = player:getMod(xi.mod.MACC)
            local during
            stub('xi.spells.damage.calculateBaseDamage', 1)
            stub('xi.combat.magicHitRate.calculateResistRate', function(caster)
                during = caster:getMod(xi.mod.MACC)
                return 1
            end)

            xi.spells.damage.useDamageSpell(player, target, GetSpell(xi.magic.spell.KATON_SAN))
            target:setHP(target:getMaxHP())

            assert(during == before + 5, string.format('expected %d magic accuracy during the cast, got %s', before + 5, tostring(during)))
            assert(player:getMod(xi.mod.MACC) == before, 'the magic accuracy bonus was not removed after the cast')
        end)
    end)
end)
