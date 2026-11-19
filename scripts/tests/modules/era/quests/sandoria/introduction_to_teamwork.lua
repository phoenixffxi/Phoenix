-----------------------------------
-- Vilatroire's teamwork quests: each needs six matching party members, not two.
-- Covers: modules/era/lua/quests/sandoria/intermediate_teamwork.lua
-- Covers: modules/era/lua/quests/sandoria/advanced_teamwork.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local teamworkQuests =
{
    {
        name       = 'Introduction to Teamwork',
        modulePath = 'modules/era/lua/quests/sandoria/introduction_to_teamwork.lua',
        questPath  = 'scripts/quests/sandoria/Introduction_to_Teamwork',
        questId    = xi.quest.id.sandoria.INTRODUCTION_TO_TEAMWORK,
    },
    {
        name       = 'Intermediate Teamwork',
        modulePath = 'modules/era/lua/quests/sandoria/intermediate_teamwork.lua',
        questPath  = 'scripts/quests/sandoria/Intermediate_Teamwork',
        questId    = xi.quest.id.sandoria.INTERMEDIATE_TEAMWORK,
    },
    {
        name       = 'Advanced Teamwork',
        modulePath = 'modules/era/lua/quests/sandoria/advanced_teamwork.lua',
        questPath  = 'scripts/quests/sandoria/Advanced_Teamwork',
        questId    = xi.quest.id.sandoria.ADVANCED_TEAMWORK,
    },
}

-- Same nation, race and job, so every quest's matching rule counts each member.
local function spawnMember()
    local member = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, race = xi.race.HUME_M, level = 30 })
    member.entities:moveTo('Vilatroire')

    return member
end

local function joinParty(leader, member)
    leader.actions:inviteToParty(member)
    member.actions:acceptPartyInvite()
end

describe('Era teamwork quests', function()
    local leader

    setup(function()
        leader = spawnMember()
        joinParty(leader, spawnMember())
    end)

    for _, entry in ipairs(teamworkQuests) do
        it(string.format('applies the %s overrides', entry.name), function()
            moduleTest.assertOverridesApplied(entry.modulePath)
        end)

        it(string.format('turns away a matching party of two for %s', entry.name), function()
            local quest = moduleTest.container(entry.questPath)

            quest.sections[2][xi.zone.WEST_RONFAURE].onEventUpdate[129](leader, 129, 0, nil)

            assert(quest:getLocalVar(leader, 'Prog') == 0, 'a party of two counted as a full team')
        end)
    end

    describe('quest flow #exhaustive', function()
        local sixth

        setup(function()
            for _ = 3, 5 do
                joinParty(leader, spawnMember())
            end

            sixth = spawnMember()
        end)

        for _, entry in ipairs(teamworkQuests) do
            it(string.format('completes %s only once the sixth member joins', entry.name), function()
                leader:addQuest(xi.questLog.SANDORIA, entry.questId)

                leader.entities:gotoAndTrigger('Vilatroire', { eventId = 129, updates = { 0 }, finishOption = 0 })
                leader.assert.no:hasCompletedQuest(xi.questLog.SANDORIA, entry.questId)

                joinParty(leader, sixth)
                leader.entities:gotoAndTrigger('Vilatroire', { eventId = 129, updates = { 0 }, finishOption = 0 })
                leader.assert:hasCompletedQuest(xi.questLog.SANDORIA, entry.questId)

                sixth.actions:leaveParty()
            end)
        end
    end)
end)
