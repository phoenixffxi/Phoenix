-----------------------------------
-- Completing listed missions and quests, or receiving listed key items, adds Mog Wardrobe slots once per unlock.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local function assertSize(player, bag, expected)
    local size = player:getContainerSize(bag)
    assert(size == expected, string.format('expected container %d to hold %d, got %d', bag, expected, size))
end

describe('Phoenix wardrobe unlocks', function()
    local player

    -- New characters start with full wardrobes, so shrink them to see the unlock land.
    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        for _, bag in ipairs({ xi.inv.WARDROBE, xi.inv.WARDROBE2, xi.inv.WARDROBE3 }) do
            player:changeContainerSize(bag, -20)
        end

        player.packets:clear()
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/custom/wardrobe_unlocks.lua')
    end)

    it('adds 5 slots to Mog Wardrobe 1 for the first nation mission', function()
        npcUtil.completeMission(player, xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.SMASH_THE_ORCISH_SCOUTS)

        assertSize(player, xi.inv.WARDROBE, 65)
        assert(player:getCharVar('[Wardrobe]Nation_Rank_1') == 1, 'the unlock was not recorded')
        moduleTest.assertChatLines(player, { 'Your Mog Wardrobe 1 capacity has been increased by 5!' })
    end)

    describe('every reward source #exhaustive', function()
        it('gives an unlock shared by every nation only once', function()
            npcUtil.completeMission(player, xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.SMASH_THE_ORCISH_SCOUTS)
            npcUtil.completeMission(player, xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_ZERUHN_REPORT)

            assertSize(player, xi.inv.WARDROBE, 65)
            moduleTest.assertChatLines(player, { 'Your Mog Wardrobe 1 capacity has been increased by 5!' })
        end)

        it('adds 10 slots to Mog Wardrobe 2 for Three Paths', function()
            npcUtil.completeMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THREE_PATHS)

            assertSize(player, xi.inv.WARDROBE2, 70)
            moduleTest.assertChatLines(player, { 'Your Mog Wardrobe 2 capacity has been increased by 10!' })
        end)

        it('holds the notice for a mission that warps until the next zone-in', function()
            npcUtil.completeMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_MOTHERCRYSTALS)

            assertSize(player, xi.inv.WARDROBE2, 65)
            moduleTest.assertChatLines(player, {})
            assert(player:getCharVar('[Wardrobe]PendingBag') == xi.inv.WARDROBE2, 'the pending bag was not stored')
            assert(player:getCharVar('[Wardrobe]PendingAmount') == 5, 'the pending amount was not stored')

            player:gotoZone(xi.zone.EAST_RONFAURE)

            local announced = false
            for _, line in ipairs(moduleTest.chatLines(player)) do
                announced = announced or line == 'Your Mog Wardrobe 2 capacity has been increased by 5!'
            end

            assert(announced, 'the held notice was not shown after zoning')
            assert(player:getCharVar('[Wardrobe]PendingBag') == 0, 'the pending bag was not cleared')
            assert(player:getCharVar('[Wardrobe]PendingAmount') == 0, 'the pending amount was not cleared')
        end)

        it('adds 5 slots to Mog Wardrobe 2 for an advanced job quest', function()
            npcUtil.completeQuest(player, xi.questLog.SANDORIA, xi.quest.id.sandoria.A_KNIGHTS_TEST, {})

            assertSize(player, xi.inv.WARDROBE2, 65)
            assert(player:getCharVar('[Wardrobe]Advanced') == 1, 'the unlock was not recorded')
            moduleTest.assertChatLines(player, { 'Your Mog Wardrobe 2 capacity has been increased by 5!' })
        end)

        it('adds slots for the Limit Breaker and Boarding Permit key items', function()
            npcUtil.giveKeyItem(player, xi.keyItem.LIMIT_BREAKER)
            npcUtil.giveKeyItem(player, { xi.keyItem.BOARDING_PERMIT })

            assertSize(player, xi.inv.WARDROBE, 65)
            assertSize(player, xi.inv.WARDROBE3, 65)
            assert(player:getCharVar('[Wardrobe]UnlockMerits') == 1, 'the merit unlock was not recorded')
            assert(player:getCharVar('[Wardrobe]ToAU_Access') == 1, 'the ToAU unlock was not recorded')
        end)
    end)
end)
