-----------------------------------
-- Khimaira (Caedarva Mire) draws a target past z 384 back into its original spawn bowl.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix Khimaira bowl draw-in', function()
    ---@type CClientEntityPair
    local player
    local khimaira

    setup(function()
        player   = xi.test.world:spawnPlayer({ zone = xi.zone.CAEDARVA_MIRE })
        khimaira = player.entities:get('Khimaira')
    end)

    before_each(function()
        player:setLocalVar('[Draw-In]WaitTime', 0)
    end)

    after_each(function()
        khimaira:setMobMod(xi.mobMod.NO_MOVE, 0)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/custom/pxi_nm_spawn_points.lua')
    end)

    it('draws a target past z 384 into the original bowl', function()
        player:setPos(840, 0, 400)
        xi.zones.Caedarva_Mire.mobs.Khimaira.onMobFight(khimaira, player)
        assert(khimaira:getMobMod(xi.mobMod.NO_MOVE) == 1, 'Khimaira is free to move')

        -- Past the 3 second wait the target lands on one of the bowl's draw-in points.
        player:setLocalVar('[Draw-In]WaitTime', GetSystemTime() - 1)
        xi.zones.Caedarva_Mire.mobs.Khimaira.onMobFight(khimaira, player)

        local pos = player:getPos()
        assert(
            pos.x > 830 and
            pos.x < 850 and
            pos.z > 350 and
            pos.z < 368,
            string.format('target landed at (%.1f, %.1f), outside the bowl', pos.x, pos.z)
        )
    end)

    describe('fence line #exhaustive', function()
        it('leaves a target south of z 384 alone', function()
            player:setPos(840, 0, 370)
            xi.zones.Caedarva_Mire.mobs.Khimaira.onMobFight(khimaira, player)

            assert(khimaira:getMobMod(xi.mobMod.NO_MOVE) == 0, 'Khimaira is rooted for a target inside the fence')
            assert(player:getLocalVar('[Draw-In]WaitTime') == 0, 'a draw-in is pending inside the fence')
        end)
    end)
end)
