-----------------------------------
-- Collect Tarut Cards: Chululu hands out no further batches of cards during the quest.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Collect Tarut Cards', function()
    local quest

    setup(function()
        quest = moduleTest.container('scripts/quests/jeuno/Collect_Tarut_Cards')
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/jeuno/collect_tarut_cards.lua')
    end)

    it('only reminds the player once the daily timer has passed', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })
        quest:setVar(player, 'Date', GetSystemTime() - 1)

        local action = quest.sections[2][xi.zone.LOWER_JEUNO]['Chululu'].onTrigger(player, nil)

        assert(action.id == 27, string.format('expected the reminder event 27, got %s', tostring(action.id)))
    end)

    describe('quest flow #exhaustive', function()
        it('gives no new cards when Chululu is spoken to', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })
            player:addQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.COLLECT_TARUT_CARDS)

            player.entities:gotoAndTrigger('Chululu', { eventId = 27 })

            player.assert.no:hasItem(xi.item.TARUT_CARD_THE_FOOL)
            player.assert.no:hasItem(xi.item.TARUT_CARD_DEATH)
            player.assert.no:hasItem(xi.item.TARUT_CARD_THE_HERMIT)
            player.assert.no:hasItem(xi.item.TARUT_CARD_THE_KING)
        end)
    end)
end)
