-----------------------------------
-- The Gobbiebag quests need their pre-2014 Jeuno fame, and Bluffnix explains when fame is short.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local parts =
{
    { file = 'The_Gobbiebag_Part_I',    questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_I,    inventory = 30, fame = 3 },
    { file = 'The_Gobbiebag_Part_II',   questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_II,   inventory = 35, fame = 4 },
    { file = 'The_Gobbiebag_Part_III',  questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_III,  inventory = 40, fame = 5 },
    { file = 'The_Gobbiebag_Part_IV',   questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_IV,   inventory = 45, fame = 5 },
    { file = 'The_Gobbiebag_Part_V',    questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_V,    inventory = 50, fame = 6 },
    { file = 'The_Gobbiebag_Part_VI',   questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_VI,   inventory = 55, fame = 6 },
    { file = 'The_Gobbiebag_Part_VII',  questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_VII,  inventory = 60, fame = 7 },
    { file = 'The_Gobbiebag_Part_VIII', questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_VIII, inventory = 65, fame = 7 },
    { file = 'The_Gobbiebag_Part_IX',   questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_IX,   inventory = 70, fame = 8 },
    { file = 'The_Gobbiebag_Part_X',    questId = xi.quest.id.jeuno.THE_GOBBIEBAG_PART_X,    inventory = 75, fame = 9 },
}

-- Jeuno fame is half the sum of the three nations' fame.
local function setJeunoFame(player, level)
    local nationFame = math.ceil(2 * xi.data.fame.rankPoints[level] / 3)

    player:setFame(xi.fameArea.SANDORIA, nationFame)
    player:setFame(xi.fameArea.BASTOK, nationFame)
    player:setFame(xi.fameArea.WINDURST, nationFame)
    assert(player:getFameLevel(xi.fameArea.JEUNO) == level, string.format('could not set Jeuno fame %d', level))
end

describe('Era The Gobbiebag Part I to X', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/jeuno/the_gobbiebag_part_1_to_10.lua')
    end)

    it('needs Jeuno fame 3 for Part I', function()
        local quest  = moduleTest.container('scripts/quests/jeuno/The_Gobbiebag_Part_I')
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })
        player:changeContainerSize(xi.inv.INVENTORY, 30 - player:getContainerSize(xi.inv.INVENTORY))

        setJeunoFame(player, 2)
        assert(not quest.sections[1].check(player, xi.questStatus.QUEST_AVAILABLE, {}), 'Part I is offered at Jeuno fame 2')

        setJeunoFame(player, 3)
        assert(quest.sections[1].check(player, xi.questStatus.QUEST_AVAILABLE, {}), 'Part I is not offered at Jeuno fame 3')
    end)

    describe('fame requirements #exhaustive', function()
        it('needs the era Jeuno fame for every part', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })

            for index, part in ipairs(parts) do
                local quest = moduleTest.container('scripts/quests/jeuno/' .. part.file)
                player:changeContainerSize(xi.inv.INVENTORY, part.inventory - player:getContainerSize(xi.inv.INVENTORY))
                if index > 1 then
                    player:completeQuest(xi.questLog.JEUNO, parts[index - 1].questId)
                end

                setJeunoFame(player, part.fame - 1)
                assert(not quest.sections[1].check(player, xi.questStatus.QUEST_AVAILABLE, {}), string.format('%s is offered below Jeuno fame %d', part.file, part.fame))
                assert(quest.sections[3].check(player, xi.questStatus.QUEST_AVAILABLE, {}), string.format('%s has no fame explanation below Jeuno fame %d', part.file, part.fame))

                setJeunoFame(player, part.fame)
                assert(quest.sections[1].check(player, xi.questStatus.QUEST_AVAILABLE, {}), string.format('%s is not offered at Jeuno fame %d', part.file, part.fame))
                assert(not quest.sections[3].check(player, xi.questStatus.QUEST_AVAILABLE, {}), string.format('%s still explains fame at Jeuno fame %d', part.file, part.fame))
            end
        end)

        it('has Bluffnix explain that fame is too low', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })
            player:changeContainerSize(xi.inv.INVENTORY, 30 - player:getContainerSize(xi.inv.INVENTORY))
            setJeunoFame(player, 2)

            player.entities:gotoAndTrigger('Bluffnix', { eventId = 42 })

            player.assert.no:hasQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_I)
        end)
    end)
end)
