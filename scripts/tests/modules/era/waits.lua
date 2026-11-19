-----------------------------------
-- Era waits: quest steps, follow-up quests and NPC crafting finish at JST midnight (or after
-- a set time) instead of after a minute.
-- Every file's overrides are checked, then one quest step, one follow-up quest and one NPC.
-- Covers: modules/era/lua/quests/ahturhgan/beginnings.lua
-- Covers: modules/era/lua/quests/ahturhgan/delivering_the_goods.lua
-- Covers: modules/era/lua/quests/ahturhgan/got_it_all.lua
-- Covers: modules/era/lua/quests/ahturhgan/navigating_the_unfriendly_seas.lua
-- Covers: modules/era/lua/quests/ahturhgan/olduum.lua
-- Covers: modules/era/lua/quests/ahturhgan/omens.lua
-- Covers: modules/era/lua/quests/ahturhgan/transformations.lua
-- Covers: modules/era/lua/quests/ahturhgan/vanishing_act.lua
-- Covers: modules/era/lua/quests/hiddenquests/crafted_corsair_artifact.lua
-- Covers: modules/era/lua/quests/hiddenquests/crafted_magus_artifact.lua
-- Covers: modules/era/lua/quests/hiddenquests/crafted_puppetry_artifact.lua
-- Covers: modules/era/lua/quests/jeuno/apocalypse_nigh.lua
-- Covers: modules/era/lua/quests/jeuno/shadows_of_the_departed.lua
-- Covers: modules/era/lua/quests/jeuno/storms_of_fate.lua
-- Covers: modules/era/lua/quests/jeuno/the_circle_of_time.lua
-- Covers: modules/era/lua/quests/jeuno/your_crystal_ball.lua
-- Covers: modules/era/lua/quests/otherareas/better_the_demon_you_know.lua
-- Covers: modules/era/lua/quests/otherareas/its_raining_mannequins.lua
-- Covers: modules/era/lua/quests/outlands/a_thief_in_norg.lua
-- Covers: modules/era/lua/quests/outlands/the_missing_piece.lua
-- Covers: modules/era/lua/quests/outlands/the_sacred_katana.lua
-- Covers: modules/era/lua/quests/outlands/yomi_okuri.lua
-- Covers: modules/era/lua/quests/sandoria/chasing_quotas.lua
-- Covers: modules/era/lua/quests/sandoria/enveloped_in_darkness.lua
-- Covers: modules/era/lua/quests/windurst/a_greeting_cardian.lua
-- Covers: modules/era/lua/quests/windurst/blue_ribbon_blues.lua
-- Covers: modules/era/lua/zones/castle_zvahl_baileys/npcs/switchstix.lua
-- Covers: modules/era/lua/zones/northern_san_doria/npcs/mulaujeant.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era waits', function()
    it('applies the overrides of every quest and NPC', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('holds The Missing Piece until JST midnight after the tablet is handed over', function()
        local quest  = moduleTest.container('scripts/quests/outlands/The_Missing_Piece')
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.NORTHERN_SAN_DORIA })
        player:addQuest(xi.questLog.OUTLANDS, xi.quest.id.outlands.THE_MISSING_PIECE)
        quest:setVar(player, 'Prog', 2)

        player.entities:gotoAndTrigger('Charlaimagnat', { eventId = 703 })
        assert(quest:getVar(player, 'Wait') == JstMidnight(), 'expected the wait to end at JST midnight')
        player.entities:gotoAndTrigger('Charlaimagnat', { eventId = 704 })

        quest:setVar(player, 'Wait', GetSystemTime() - 1)
        player.entities:gotoAndTrigger('Charlaimagnat', { eventId = 705 })
        player.assert:hasCompletedQuest(xi.questLog.OUTLANDS, xi.quest.id.outlands.THE_MISSING_PIECE)
    end)

    it('opens Omens at JST midnight after Beginnings', function()
        local quest  = moduleTest.container('scripts/quests/ahtUrhgan/BLU_AF1_Beginnings')
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE, job = xi.job.BLU, level = 75 })
        player:addQuest(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.BEGINNINGS)

        quest.sections[2][xi.zone.AHT_URHGAN_WHITEGATE].onEventFinish[707](player, 707, 0, nil)

        local timer = xi.quest.getVar(player, xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.OMENS, 'Timer')
        player.assert:hasCompletedQuest(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.BEGINNINGS)
        assert(timer == JstMidnight(), string.format('Omens opens %+d s from JST midnight', timer - JstMidnight()))
        assert(xi.quest.getMustZone(player, xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.OMENS), 'expected a zone change before Omens')
    end)

    it('has Switchstix finish a first stage relic weapon at JST midnight', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.CASTLE_ZVAHL_BAILEYS })
        player:setCharVar('RELIC_IN_PROGRESS', xi.item.RELIC_KNUCKLES)
        player:addItem(xi.item.ONE_HUNDRED_BYNE_BILL, 4)

        player.actions:tradeNpc('Switchstix', { { itemId = xi.item.ONE_HUNDRED_BYNE_BILL, quantity = 4 } }, { eventId = 13 })

        local dueAt = player:getCharVar('RELIC_DUE_AT')
        assert(dueAt == JstMidnight(), string.format('expected %d, got %d', JstMidnight(), dueAt))
    end)
end)
