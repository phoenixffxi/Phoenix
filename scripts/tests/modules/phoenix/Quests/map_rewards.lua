-----------------------------------
-- Map quests reward only their map: the 2013 gil, EXP and fame are removed, as is the
-- compensation for a player who already holds the map.
-- Every file's overrides are checked, then one of each kind of change.
-- Covers: modules/phoenix/lua/Quests/A_Foremans_Best_Friend.lua
-- Covers: modules/phoenix/lua/Quests/A_Smudge_on_Ones_Record.lua
-- Covers: modules/phoenix/lua/Quests/Exit_the_Gambler.lua
-- Covers: modules/phoenix/lua/Quests/Glyph_Hanger.lua
-- Covers: modules/phoenix/lua/Quests/Go_Go_Gobmuffin.lua
-- Covers: modules/phoenix/lua/Quests/Lost_in_Translocation.lua
-- Covers: modules/phoenix/lua/Quests/One_Good_Deed.lua
-- Covers: modules/phoenix/lua/Quests/Paradise_Salvation_and_Maps.lua
-- Covers: modules/phoenix/lua/Quests/RQ4_His_Name_is_Valgeir.lua
-- Covers: modules/phoenix/lua/Quests/Rock_Bottom.lua
-- Covers: modules/phoenix/lua/Quests/The_Antique_Collector.lua
-- Covers: modules/phoenix/lua/Quests/The_Bare_Bones.lua
-- Covers: modules/phoenix/lua/Quests/The_Flipside_of_Things.lua
-- Covers: modules/phoenix/lua/Quests/The_Rescue.lua
-- Covers: modules/phoenix/lua/Quests/The_Sand_Charm.lua
-- Covers: modules/phoenix/lua/Quests/The_Weekly_Adventurer.lua
-- Covers: modules/phoenix/lua/Quests/Unforgiven.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix map quest rewards', function()
    it('applies the overrides of every quest', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('gives only the map for Glyph Hanger, without EXP or fame', function()
        local quest  = moduleTest.container('scripts/quests/windurst/Glyph_Hanger')
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WATERS, level = 1 })
        local fame   = player:getFame(xi.fameArea.WINDURST)

        quest:begin(player)
        quest:complete(player)

        player.assert
            :hasCompletedQuest(xi.questLog.WINDURST, xi.quest.id.windurst.GLYPH_HANGER)
            :hasKI(xi.keyItem.MAP_OF_THE_HORUTOTO_RUINS)
        assert(player:getMainLvl() == 1, 'the EXP reward levelled the player up')
        assert(player:getFame(xi.fameArea.WINDURST) == fame, string.format('Windurst fame changed by %+d', player:getFame(xi.fameArea.WINDURST) - fame))
    end)

    it('gives no Rock Bottom gil to a player who already holds the map', function()
        local quest  = moduleTest.container('scripts/quests/ahtUrhgan/Rock_Bottom')
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.MOUNT_ZHAYOLM })
        local gil    = player:getGil()
        player:addKeyItem(xi.keyItem.MAP_OF_MOUNT_ZHAYOLM)
        quest:begin(player)

        quest.sections[2][xi.zone.MOUNT_ZHAYOLM].onEventFinish[9](player, 9, 0, nil)

        player.assert:hasCompletedQuest(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.ROCK_BOTTOM)
        assert(player:getGil() == gil, string.format('gil changed by %+d', player:getGil() - gil))
    end)
end)
