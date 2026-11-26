-----------------------------------
-- The Moonlit Path: Leepe-Hoppe's reward menu never offers the Fenrir mount.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era The Moonlit Path', function()
    local quest
    local player

    setup(function()
        quest  = moduleTest.container('scripts/quests/windurst/The_Moonlit_Path')
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WATERS })
        player:addKeyItem(xi.keyItem.WHISPER_OF_THE_MOON)
        player:addKeyItem(xi.keyItem.TRAINERS_WHISTLE)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/windurst/the_moonlit_path.lua')
    end)

    it('hides the mount for a player holding the trainers whistle', function()
        local action = quest.sections[2][xi.zone.WINDURST_WATERS]['Leepe-Hoppe'].onTrigger(player, nil)

        assert(action.id == 846, string.format('expected the reward menu 846, got %s', tostring(action.id)))
        assert(utils.mask.getBit(action.options[5], 7), 'the reward menu still offers the mount')
    end)

    describe('reward menu #exhaustive', function()
        it('hides the mount on the repeat menu too', function()
            quest:setVar(player, 'Repeat', 1)

            local action = quest.sections[2][xi.zone.WINDURST_WATERS]['Leepe-Hoppe'].onTrigger(player, nil)
            quest:setVar(player, 'Repeat', 0)

            assert(action.id == 850, string.format('expected the repeat reward menu 850, got %s', tostring(action.id)))
            assert(utils.mask.getBit(action.options[5], 7), 'the repeat reward menu still offers the mount')
        end)

        it('leaves the other reward options alone', function()
            local action = quest.sections[2][xi.zone.WINDURST_WATERS]['Leepe-Hoppe'].onTrigger(player, nil)

            assert(utils.mask.getBit(action.options[5], 7), 'the reward menu still offers the mount')
            for slot = 0, 4 do
                assert(not utils.mask.getBit(action.options[5], slot), string.format('reward option %d is hidden', slot + 1))
            end
        end)
    end)
end)
