-----------------------------------
-- Eco-Warrior: each nation's ointment restricts the player to level 20, not 25.
-- Every nation's overrides are checked, then the Bastok quest is played through.
-- Covers: modules/era/lua/quests/bastok/eco_warrior.lua
-- Covers: modules/era/lua/quests/sandoria/eco_warrior.lua
-- Covers: modules/era/lua/quests/windurst/eco_warrior.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Eco-Warrior', function()
    it('applies the overrides of every nation', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('restricts the player to level 20 when Degga applies the ointment', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.GUSGEN_MINES, level = 30 })
        player:addQuest(xi.questLog.BASTOK, xi.quest.id.bastok.ECO_WARRIOR)

        player.entities:gotoAndTrigger('Degga', { eventId = 13, finishOption = 1 })

        local effect = player:getStatusEffect(xi.effect.LEVEL_RESTRICTION)
        assert(effect, 'expected the ointment to restrict the level')
        assert(effect:getPower() == 20, string.format('expected a level 20 restriction, got %d', effect:getPower()))
    end)
end)
