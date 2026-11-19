-----------------------------------
-- Pre-August 2023 new adventurer icon: removed once the main job reaches level 6.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era new adventurer level limit', function()
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 5 })
        player:setNewPlayer(true)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/globals/new_adventurer_level_limit.lua')
    end)

    it('removes the new adventurer icon at level 6', function()
        player:setLevel(6)
        xi.player.onPlayerLevelUp(player)

        assert(not player:getNewPlayer(), 'still a new adventurer at level 6')
    end)

    describe('level ups #exhaustive', function()
        it('keeps the icon at level 5 and removes it at level 6', function()
            xi.player.onPlayerLevelUp(player)
            assert(player:getNewPlayer(), 'the icon was removed at level 5')

            player:setLevel(6)
            xi.player.onPlayerLevelUp(player)
            assert(not player:getNewPlayer(), 'still a new adventurer at level 6')
        end)

        it('removes the icon when experience levels the player to 6', function()
            player:addExp(500)

            assert(player:getMainLvl() == 6, string.format('expected level 6, got %d', player:getMainLvl()))
            assert(not player:getNewPlayer(), 'still a new adventurer at level 6')
        end)
    end)
end)
