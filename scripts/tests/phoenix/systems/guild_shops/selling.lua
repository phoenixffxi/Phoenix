-----------------------------------
-- Phoenix version of the systems/guild_shops/selling.lua cases that need stacked Tin Ore.
-- Phoenix ores do not stack (phoenix/sql/pxi_item_basic.sql), so these sell Steel Ingots.
-----------------------------------
describe('Guild shop selling', function()
    ---@type CClientEntityPair
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.MHAURA })
        xi.test.world:setVanaTime(8, 0)
        player.entities:gotoAndTrigger('Kamilah')
    end)

    local offered = xi.item.STEEL_INGOT -- initial 80 => offered and sellable, stacks to 12

    -- trade: amount sold; 0xFF (-1) partial fill
    local function sell(itemId, quantity)
        player.packets:clear()
        player.actions:guildSell(itemId, quantity)
        for _, pkt in pairs(player.packets:getIncoming()) do
            if pkt.type == 0x084 then
                return { itemNo = pkt.data[4] + pkt.data[5] * 256, stock = pkt.data[6], trade = pkt.data[7] }
            end
        end
    end

    it('clamps a sale to the shop max stock', function()
        local maxStock
        for _, cfg in ipairs(xi.data.guildShops['Kamilah'].stock) do
            if cfg.id == offered then
                maxStock = cfg.maxStock
            end
        end

        -- no packet sets shop stock; seed one below max so the 5-sale only has room for 1
        xi.guildShops.state['Kamilah'].items[offered].stock = maxStock - 1
        player:addItem(offered, 5)
        local held = player:getItemCount(offered)

        local reply = sell(offered, 5)

        assert(player.actions:guildSellList()[offered].count == maxStock, 'stock not clamped to max')
        assert(player:getItemCount(offered) == held - 1, 'took more than the room left')
        assert(reply.trade == 0xFF, 'partial fill not flagged: trade ' .. tostring(reply.trade))
    end)

    it('sells across multiple inventory stacks', function()
        -- two stacks of 3 + 12, so a 12-sale has to span both
        player:addItem(offered, 12)
        player:addItem(offered, 12)
        player:delItem(offered, 9) -- drains the front stack: 12 -> 3
        assert(player:getItemCount(offered) == 15, 'setup: expected 3 + 12 = 15')

        local before = player.actions:guildSellList()[offered]
        local gil    = player:getGil()

        local reply = sell(offered, 12)

        assert(reply.trade == 12, 'full sale not reported as 12: ' .. tostring(reply.trade))
        assert(player:getItemCount(offered) == 3, 'inventory not 3')
        assert(player:getGil() == gil + before.price * 12, 'gil off for 12 sold')
        assert(player.actions:guildSellList()[offered].count == before.count + 12, 'stock not +12')
    end)
end)
