-----------------------------------
-- Sin Hunting: the ??? in Jugner Forest answers only under a full moon.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Sin Hunting', function()
    local quest

    setup(function()
        quest = moduleTest.container('scripts/quests/windurst/RNG_AF1_Sin_Hunting')
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/windurst/sin_hunting.lua')
    end)

    it('answers only under a full moon', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.JUGNER_FOREST })
        local qm2    = quest.sections[2][xi.zone.JUGNER_FOREST]['qm2']
        local moon   = xi.moonCycle.FIRST_QUARTER
        stub('getVanadielMoonCycle', function()
            return moon
        end)

        quest:setVar(player, 'Prog', 3)

        assert(qm2.onTrigger(player, nil) == nil, 'the ??? answered without a full moon')

        moon = xi.moonCycle.FULL_MOON
        local action = qm2.onTrigger(player, nil)
        assert(action and action.id == 13, 'expected event 13 under a full moon')
    end)

    describe('quest flow #exhaustive', function()
        it('advances only when examined under a full moon', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.JUGNER_FOREST })
            local moon   = xi.moonCycle.NEW_MOON
            stub('getVanadielMoonCycle', function()
                return moon
            end)

            player:addQuest(xi.questLog.WINDURST, xi.quest.id.windurst.SIN_HUNTING)
            quest:setVar(player, 'Prog', 3)

            for _, phase in ipairs({ xi.moonCycle.NEW_MOON, xi.moonCycle.GREATER_WAXING_GIBBOUS, xi.moonCycle.GREATER_WANING_GIBBOUS }) do
                moon = phase
                player.entities:gotoAndTrigger('qm2')
                player.events:expectNotInEvent()
            end

            moon = xi.moonCycle.FULL_MOON
            player.entities:gotoAndTrigger('qm2', { eventId = 13, finishOption = 0 })
            assert(quest:getVar(player, 'Prog') == 4, 'expected the glittersand step to advance')
        end)
    end)
end)
