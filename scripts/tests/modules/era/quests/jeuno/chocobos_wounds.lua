-----------------------------------
-- Chocobo's Wounds: the chocobo eats once per Vana'diel day, not every 45 seconds.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Chocobo\'s Wounds', function()
    local quest

    setup(function()
        quest = moduleTest.container('scripts/quests/jeuno/Chocobos_Wounds')
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/jeuno/chocobos_wounds.lua')
    end)

    it('records the Vana\'diel day of the first feed', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.UPPER_JEUNO })

        quest.sections[2][xi.zone.UPPER_JEUNO].onEventFinish[57](player, 57, 0, nil)

        assert(quest:getVar(player, 'Prog') == 2, 'expected the first feed to count')
        assert(quest:getVar(player, 'Timer') == VanadielUniqueDay(), string.format('expected the feed day %d, got %d', VanadielUniqueDay(), quest:getVar(player, 'Timer')))
    end)

    describe('feeding #exhaustive', function()
        it('records the Vana\'diel day of every later feed', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.UPPER_JEUNO })
            local feeds  = { [58] = 3, [99] = 4, [59] = 5, [60] = 6 }

            for csid, progress in pairs(feeds) do
                quest:setVar(player, 'Timer', 0)
                quest.sections[2][xi.zone.UPPER_JEUNO].onEventFinish[csid](player, csid, 0, nil)

                assert(quest:getVar(player, 'Prog') == progress, string.format('event %d did not move the feeding on', csid))
                assert(quest:getVar(player, 'Timer') == VanadielUniqueDay(), string.format('event %d did not record the feed day', csid))
            end
        end)

        it('refuses a second feed on the same Vana\'diel day', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.UPPER_JEUNO })
            player:addQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.CHOCOBOS_WOUNDS)
            player:addItem(xi.item.CLUMP_OF_GAUSEBIT_WILDGRASS)
            quest:setVar(player, 'Prog', 2)
            quest:setVar(player, 'Timer', VanadielUniqueDay())

            player.actions:tradeNpc('Chocobo', { xi.item.CLUMP_OF_GAUSEBIT_WILDGRASS }, { eventId = 73 })

            assert(quest:getVar(player, 'Prog') == 2, 'the chocobo ate twice in one day')
        end)

        it('feeds again on the next Vana\'diel day', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.UPPER_JEUNO })
            player:addQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.CHOCOBOS_WOUNDS)
            player:addItem(xi.item.CLUMP_OF_GAUSEBIT_WILDGRASS)
            quest:setVar(player, 'Prog', 2)
            quest:setVar(player, 'Timer', VanadielUniqueDay() - 1)

            player.actions:tradeNpc('Chocobo', { xi.item.CLUMP_OF_GAUSEBIT_WILDGRASS }, { eventId = 58 })

            assert(quest:getVar(player, 'Prog') == 3, 'expected the second feed to count')
            assert(quest:getVar(player, 'Timer') == VanadielUniqueDay(), 'expected the feed day to be recorded')
        end)
    end)
end)
