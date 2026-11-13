-----------------------------------
-- Northward rewards only its map and title: the 2013 gil and EXP are removed.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Northward', function()
    local quest

    setup(function()
        quest = moduleTest.container('scripts/quests/jeuno/Northward')
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/jeuno/northward.lua')
    end)

    it('rewards the Castle Zvahl map and title without gil or EXP', function()
        assert(quest.reward.keyItem == xi.keyItem.MAP_OF_CASTLE_ZVAHL, 'expected the map as the reward')
        assert(quest.reward.title == xi.title.ENVOY_TO_THE_NORTH, 'expected the title as the reward')
        assert(quest.reward.gil == nil, 'the reward still gives gil')
        assert(quest.reward.exp == nil, 'the reward still gives EXP')
    end)

    describe('completion #exhaustive', function()
        it('gives the map without gil', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.RULUDE_GARDENS })
            local gil    = player:getGil()

            quest:begin(player)
            quest:complete(player)

            player.assert
                :hasCompletedQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.NORTHWARD)
                :hasKI(xi.keyItem.MAP_OF_CASTLE_ZVAHL)
            assert(player:getGil() == gil, string.format('gil changed by %+d', player:getGil() - gil))
        end)
    end)
end)
