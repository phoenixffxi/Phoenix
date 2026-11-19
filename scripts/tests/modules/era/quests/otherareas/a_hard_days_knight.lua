-----------------------------------
-- A Hard Day's Knight: Quelveuiat no longer trades crest keys for the Temple Knight Key.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era A Hard Days Knight', function()
    local quest
    local player

    setup(function()
        quest  = moduleTest.container('scripts/quests/otherAreas/A_Hard_Days_Knight')
        player = xi.test.world:spawnPlayer({ zone = xi.zone.TAVNAZIAN_SAFEHOLD })
        player:completeQuest(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.A_HARD_DAYS_KNIGHT)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/otherareas/a_hard_days_knight.lua')
    end)

    it('has no section for a completed quest', function()
        for idx, section in ipairs(quest.sections) do
            assert(not section.check(player, xi.questStatus.QUEST_COMPLETED, {}), string.format('section %d still answers a completed quest', idx))
        end
    end)

    describe('after completion #exhaustive', function()
        it('ignores both crest keys', function()
            player:addItem(xi.item.SEALION_CREST_KEY)
            player:addItem(xi.item.CORAL_CREST_KEY)

            player.actions:tradeNpc('Quelveuiat', { xi.item.SEALION_CREST_KEY, xi.item.CORAL_CREST_KEY })

            player.events:expectNotInEvent()
            player.assert
                :hasItem(xi.item.SEALION_CREST_KEY)
                :hasItem(xi.item.CORAL_CREST_KEY)
            player.assert.no:hasKI(xi.keyItem.TEMPLE_KNIGHT_KEY)
        end)

        it('gives Quelveuiat his default line', function()
            player.entities:gotoAndTrigger('Quelveuiat', { eventId = 122 })
        end)
    end)
end)
