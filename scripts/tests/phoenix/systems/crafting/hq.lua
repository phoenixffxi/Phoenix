-----------------------------------
-- Phoenix version of the T2 case in systems/crafting/hq.lua.
-- Phoenix Damascene Cloth does not stack (phoenix/sql/pxi_item_basic.sql), and craft takes each
-- ingredient from one slot, so this uses Gold Obi: also Clothcraft 70, made from stacking Gold Thread.
-----------------------------------
describe('HQ', function()
    it('T2 HQ rate', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })
        local tries  = 1000
        local thread = xi.item.SPOOL_OF_GOLD_THREAD
        local hqObi  = 13233 -- Gold Obi +1 has no xi.item entry

        -- 40 over the recipe is tier 2.
        player:setSkillLevel(xi.skill.CLOTHCRAFT, 1100)
        player:setMod(xi.mod.SYNTH_SPEED_CLOTHCRAFT, 17000)
        player:changeContainerSize(xi.inventoryLocation.INVENTORY, 80)

        local nqTotal = 0
        local hqTotal = 0
        for _ = 1, tries do
            player:addItem(xi.item.EARTH_CRYSTAL)
            player:addItem(thread, 3)

            local nqBefore = player:getItemCount(xi.item.GOLD_OBI)
            local hqBefore = player:getItemCount(hqObi)

            player.actions:craft(xi.item.EARTH_CRYSTAL, { thread, thread, thread })
            xi.test.world:skipTime(15)

            nqTotal = nqTotal + player:getItemCount(xi.item.GOLD_OBI) - nqBefore
            hqTotal = hqTotal + player:getItemCount(hqObi) - hqBefore

            player:delContainerItems(xi.inv.INVENTORY)
        end

        local total = nqTotal + hqTotal
        assert(total > 0, 'no synths succeeded')

        -- Same 4 sigma band as hq.lua, around the 25% tier 2 rate.
        local expected = total * 0.25
        local sigma    = math.sqrt(total * 0.25 * 0.75)
        assert(math.abs(hqTotal - expected) <= 4 * sigma, string.format(
            'HQ count %d outside 4 sigma of %.1f (%d synths)', hqTotal, expected, total))
    end)
end)
