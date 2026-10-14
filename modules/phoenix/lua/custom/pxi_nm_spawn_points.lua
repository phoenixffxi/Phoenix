-----------------------------------
-- This module keeps Khimaira's draw in matched to his original spawn bowl.
-- The original NM spawn positions themselves live in the yaml regions under modules/phoenix/data/zones.
-- Most of these NMs were moved in the May 10, 2011 version update: https://forum.square-enix.com/ffxi/threads/7267
-- Khimaira was moved in the October 10, 2023 version update: https://forum.square-enix.com/ffxi/threads/61169
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('pxi_nm_spawn_points')

-----------------------------------
-- Khimaira (Caedarva Mire)
-----------------------------------
m:addOverride('xi.zones.Caedarva_Mire.mobs.Khimaira.onMobFight', function(mob, target)
    local targetPos = target:getPos()
    local drawInPositions =
    {
        { 840.1741,  0.2318, 354.0881, targetPos.rot },
        { 833.1459, -0.3641, 358.4796, targetPos.rot },
        { 847.2755, -0.4074, 355.4048, targetPos.rot },
        { 847.4933, -0.5209, 364.5592, targetPos.rot },
        { 841.9098, -0.1811, 365.3915, targetPos.rot },
    }
    -- This draws a fence around z 384-393. If you cross the line, you get drawn in. This corresponds with the bowl he spawns in.
    local drawInTable =
    {
        conditions =
        {
            target:getZPos() > 384,
        },
        position = utils.randomEntry(drawInPositions),
        wait = 3,
    }
    for _, condition in ipairs(drawInTable.conditions) do
        if condition then
            mob:setMobMod(xi.mobMod.NO_MOVE, 1)
            utils.drawIn(target, drawInTable)
            break
        else
            mob:setMobMod(xi.mobMod.NO_MOVE, 0)
        end
    end
end)
