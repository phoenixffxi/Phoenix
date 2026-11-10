-----------------------------------
-- The Gustaberg and Kuftal tours need a full party of six, not two.
-- Both overrides are checked, then the Gustaberg tour turns a small party away.
-- Covers: modules/era/lua/quests/bastok/the_gustaberg_tour.lua
-- Covers: modules/era/lua/quests/outlands/the_kuftal_tour.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era tour quests', function()
    it('applies the overrides of both tours', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('turns a party of two away from Hunting Bear', function()
        local quest  = moduleTest.container('scripts/quests/bastok/The_Gustaberg_Tour')
        local leader = xi.test.world:spawnPlayer({ zone = xi.zone.NORTH_GUSTABERG, level = 5 })
        local member = xi.test.world:spawnPlayer({ zone = xi.zone.NORTH_GUSTABERG, level = 5 })
        leader.actions:inviteToParty(member)
        member.actions:acceptPartyInvite()

        local action = quest.sections[2][xi.zone.NORTH_GUSTABERG]['Hunting_Bear'].onTrigger(leader, nil)

        assert(action.id == 21, string.format('expected the refusal event 21, got %s', tostring(action.id)))
    end)
end)
