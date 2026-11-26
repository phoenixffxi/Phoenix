-----------------------------------
-- Pre-SoA skillchain damage: a magic resist roll applies instead of the target's resistance rank.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era skillchain damage', function()
    local player

    -- Liquefaction is fire only, so the element never depends on the target's resistances.
    local function liquefactionDamage(resistRate)
        stub('xi.spells.damage.calculateDayAndWeather', 1)
        stub('xi.combat.magicHitRate.calculateResistRate', resistRate)

        player:addStatusEffect(xi.effect.SKILLCHAIN, { power = xi.skillchainType.LIQUEFACTION, tier = 1, subPower = 1, duration = 10, origin = player })
        local damage = xi.combat.skillchain.calculateSkillchainDamage(player, player, 1000)
        player:delStatusEffect(xi.effect.SKILLCHAIN)
        player:setHP(player:getMaxHP())

        return damage
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/combat/skillchain.lua')
    end)

    it('halves a level 1 skillchain on a half resist', function()
        local damage = liquefactionDamage(0.5)
        assert(damage == 250, string.format('expected 250, got %s', tostring(damage)))
    end)

    describe('resistance #exhaustive', function()
        it('ignores the target\'s fire resistance rank', function()
            player:setMod(xi.mod.FIRE_RES_RANK, 4)
            local damage = liquefactionDamage(1)
            player:setMod(xi.mod.FIRE_RES_RANK, 0)

            assert(damage == 500, string.format('expected 500, got %s', tostring(damage)))
        end)
    end)
end)
