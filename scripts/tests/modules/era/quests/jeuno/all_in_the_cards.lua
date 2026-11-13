-----------------------------------
-- All in the Cards: Chululu never offers the quest, first time or repeat.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era All in the Cards', function()
    local quest
    local player

    setup(function()
        quest  = moduleTest.container('scripts/quests/jeuno/All_in_the_Cards')
        player = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })
        player:completeQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.COLLECT_TARUT_CARDS)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/jeuno/all_in_the_cards.lua')
    end)

    it('is not offered after Collect Tarut Cards', function()
        assert(not quest.sections[1].check(player, xi.questStatus.QUEST_AVAILABLE, {}), 'Chululu offers the quest')
    end)

    describe('repeat offer #exhaustive', function()
        it('is not offered again once completed', function()
            assert(not quest.sections[2].check(player, xi.questStatus.QUEST_COMPLETED, {}), 'Chululu offers the quest again')
        end)
    end)
end)
