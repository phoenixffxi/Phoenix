-----------------------------------
-- Mog House moogle quests: each is offered at the conquest tally after the bed is placed,
-- and the moogle keeps the reward until JST midnight.
-- Covers: modules/era/lua/quests/otherareas/moogles_in_the_wild.lua
-- Covers: modules/era/lua/quests/otherareas/the_moogles_picnic.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local moogleQuests =
{
    {
        name       = 'Give a Moogle a Break',
        modulePath = 'modules/era/lua/quests/otherareas/give_a_moogle_a_break.lua',
        questPath  = 'scripts/quests/otherAreas/Give_a_Moogle_a_Break',
        tradeEvent = 30007,
    },
    {
        name       = 'The Moogle Picnic',
        modulePath = 'modules/era/lua/quests/otherareas/the_moogles_picnic.lua',
        questPath  = 'scripts/quests/otherAreas/The_Moogles_Picnic',
        tradeEvent = 30011,
    },
    {
        name       = 'Moogles in the Wild',
        modulePath = 'modules/era/lua/quests/otherareas/moogles_in_the_wild.lua',
        questPath  = 'scripts/quests/otherAreas/Moogles_in_the_Wild',
        tradeEvent = 30015,
    },
}

describe('Era Mog House moogle quests', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })
        player:addFame(player:getNation(), xi.data.fame.rankPoints[9])
        player:completeQuest(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.GIVE_A_MOOGLE_A_BREAK)
        player:completeQuest(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.THE_MOOGLE_PICNIC)
    end)

    for _, entry in ipairs(moogleQuests) do
        it(string.format('applies the %s overrides', entry.name), function()
            moduleTest.assertOverridesApplied(entry.modulePath)
        end)

        it(string.format('offers %s only after the next conquest tally', entry.name), function()
            local quest = moduleTest.container(entry.questPath)
            stub('xi.moghouse.inMogHouseInHomeNation', true)

            quest:setVar(player, 'bedPlacedTime', GetSystemTime() - 120)
            assert(not quest.sections[1].check(player, xi.questStatus.QUEST_AVAILABLE, {}), 'offered two minutes after the bed was placed')

            quest:setVar(player, 'bedPlacedTime', NextConquestTally() - utils.days(7) - 1)
            assert(quest.sections[1].check(player, xi.questStatus.QUEST_AVAILABLE, {}), 'not offered once the conquest tally had passed')

            quest:setVar(player, 'bedPlacedTime', 0)
        end)

        it(string.format('keeps the %s reward until JST midnight', entry.name), function()
            local quest = moduleTest.container(entry.questPath)

            quest.sections[2][xi.zone.SOUTHERN_SAN_DORIA].onEventFinish[entry.tradeEvent](player, entry.tradeEvent, 0, nil)

            assert(quest:getVar(player, 'Timer') == JstMidnight(), 'expected the reward to wait for JST midnight')
        end)
    end

    describe('every Mog House zone #exhaustive', function()
        for _, entry in ipairs(moogleQuests) do
            it(string.format('keeps the %s reward until JST midnight', entry.name), function()
                local quest = moduleTest.container(entry.questPath)

                for _, zoneId in ipairs(xi.moghouse.moghouseZones) do
                    quest:setVar(player, 'Timer', 0)
                    quest.sections[2][zoneId].onEventFinish[entry.tradeEvent](player, entry.tradeEvent, 0, nil)
                    assert(quest:getVar(player, 'Timer') == JstMidnight(), string.format('zone %d does not wait for JST midnight', zoneId))
                end
            end)
        end
    end)
end)
