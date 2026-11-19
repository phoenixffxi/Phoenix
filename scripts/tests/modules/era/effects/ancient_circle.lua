-----------------------------------
-- Pre-WotG circles: only the killer effect, without the 2009 damage dealt and taken modifiers.
-- Every circle's overrides are checked, then Ancient Circle stands in for the four.
-- Covers: modules/era/lua/effects/ancient_circle.lua
-- Covers: modules/era/lua/effects/arcane_circle.lua
-- Covers: modules/era/lua/effects/holy_circle.lua
-- Covers: modules/era/lua/effects/warding_circle.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era circle effects', function()
    it('applies the overrides of every circle', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('gives Ancient Circle only Dragon Killer', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.PLD, level = 75 })
        local killer = player:getMod(xi.mod.DRAGON_KILLER)
        local dealt  = player:getMod(xi.mod.DRAGON_DMG_MULTIPLIER)
        local taken  = player:getMod(xi.mod.DRAGON_RES_MULTIPLIER)

        player:addStatusEffect(xi.effect.ANCIENT_CIRCLE, { power = 15, duration = 60, origin = player })
        player.assert:hasEffect(xi.effect.ANCIENT_CIRCLE)

        local killerGain = player:getMod(xi.mod.DRAGON_KILLER) - killer
        local dealtGain  = player:getMod(xi.mod.DRAGON_DMG_MULTIPLIER) - dealt
        local takenGain  = player:getMod(xi.mod.DRAGON_RES_MULTIPLIER) - taken
        player:delStatusEffect(xi.effect.ANCIENT_CIRCLE)

        assert(killerGain == 15, string.format('expected +15 killer, got %+d', killerGain))
        assert(dealtGain == 0, string.format('expected no damage dealt modifier, got %+d', dealtGain))
        assert(takenGain == 0, string.format('expected no damage taken modifier, got %+d', takenGain))
    end)
end)
