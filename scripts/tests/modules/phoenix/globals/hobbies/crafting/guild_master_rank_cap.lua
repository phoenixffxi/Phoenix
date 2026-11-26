-----------------------------------
-- Phoenix guild masters: Veteran is the top craft rank, so no Expert test item is offered.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix guild master rank cap', function()
    local player
    local guildMaster =
    {
        getName = function()
            return 'Cheupirudaux'
        end,
    }

    setup(function()
        player = xi.test.world:spawnPlayer()
        player:setSkillRank(xi.skill.WOODWORKING, xi.craftRank.VETERAN)
        player:setSkillLevel(xi.skill.WOODWORKING, 1000)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/globals/hobbies/crafting/guild_master_rank_cap.lua')
    end)

    it('shows a Veteran a 110 skill cap and no Expert test item', function()
        local proxy, calls = moduleTest.recordingProxy(player, { startEvent = true })
        xi.crafting.guildMasterOnTrigger(proxy, guildMaster)

        -- startEvent(eventId, testItem, skillLevel, skillCap, ...)
        local params = calls.startEvent[1]
        assert(params, 'the guild master started no event')
        assert(params[4] == 110, string.format('expected a 110 skill cap, got %s', tostring(params[4])))
        assert(params[2] ~= xi.item.VEJOVIS_WAND, 'the guild master offered the Expert test item')
    end)

    describe('trades #exhaustive', function()
        it('caps a Veteran at 110 only while trading to the guild master', function()
            local outside  = xi.crafting.getCraftSkillCap(player, xi.skill.WOODWORKING)
            local skillCap = spy('xi.crafting.getCraftSkillCap')
            xi.crafting.guildMasterOnTrade(player, guildMaster, {})

            assert(outside == 100, string.format('expected 100 outside the guild master, got %s', tostring(outside)))
            skillCap:called(1)
            assert(skillCap.calls[1].returned == 110, string.format('expected 110 at the guild master, got %s', tostring(skillCap.calls[1].returned)))
        end)
    end)
end)
