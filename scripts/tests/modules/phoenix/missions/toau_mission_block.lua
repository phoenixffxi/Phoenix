-----------------------------------
-- ToAU stops at Passing Glory: the Shaharat Teahouse cutscene that completes Sweets for the Soul is removed.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix ToAU Mission Block', function()
    local mission

    setup(function()
        mission = moduleTest.container('scripts/missions/toau/19_Sweets_for_the_Soul')
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/missions/toau_mission_block.lua')
    end)

    it('removes the Teahouse cutscene and its mission completion', function()
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        assert(whitegate.onTriggerAreaEnter[5] == nil, 'the Shaharat Teahouse still starts the cutscene')
        assert(whitegate.onEventFinish[3092] == nil, 'the cutscene still completes the mission')
    end)

    describe('mission flow #exhaustive', function()
        it('keeps the player on Sweets for the Soul at the Shaharat Teahouse', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
            player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.SWEETS_FOR_THE_SOUL)

            player:setPos({ x = 80, y = -6, z = -130 })
            xi.test.world:tick(xi.tick.TRIGGER_AREAS)
            assert(player:isPlayerInTriggerArea(5), 'expected the player inside the Shaharat Teahouse area')

            player.events:expectNotInEvent()
            player.assert:hasMission(xi.mission.log_id.TOAU, xi.mission.id.toau.SWEETS_FOR_THE_SOUL)
        end)
    end)
end)
