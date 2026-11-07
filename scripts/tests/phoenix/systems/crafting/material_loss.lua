-----------------------------------
-- Phoenix version of the zero rate case in systems/crafting/material_loss.lua.
-- era/sql/rov/rov_synth_recipes.sql puts the Lu Shang's repair back at Wood 80, and a synth more than
-- 15 levels over the crafter is cancelled, so the crafter here is 69: 11 under, which always breaks.
-----------------------------------
describe('Material loss', function()
    it('zero rate material always survives a break', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })

        -- Recipe 3049: Light Crystal + Broken Lu Shang's -> Lu Shang's. The broken rod is listed at 0.
        local lightCrystal = xi.item.LIGHT_CRYSTAL
        local brokenRod    = xi.item.BROKEN_LU_SHANGS_FISHING_ROD
        local luShangs     = xi.item.LU_SHANGS_FISHING_ROD

        player:setSkillLevel(xi.skill.WOODWORKING, 690)
        player:setMod(xi.mod.SYNTH_SPEED_WOODWORKING, 17000)

        for _ = 1, 20 do
            player:addItem(lightCrystal)
            player:addItem(brokenRod)

            player.actions:craft(lightCrystal, { brokenRod })
            xi.test.world:skipTime(15)

            player.assert.no:hasItem(lightCrystal)
            player.assert.no:hasItem(luShangs)
            player.assert:hasItem(brokenRod)

            player:delContainerItems(xi.inv.INVENTORY)
        end
    end)
end)
