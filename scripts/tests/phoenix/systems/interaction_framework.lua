-----------------------------------
-- Phoenix version of the Shady Business case in systems/interaction_framework.lua.
-- Phoenix ores do not stack (phoenix/sql/pxi_item_basic.sql), so the four Zinc Ore are traded
-- from four slots, and tradeNpc can only take each item from one slot.
-----------------------------------
local ffi = require('ffi')

local function writeUint32(packet, offset, value)
    for byte = 0, 3 do
        packet[offset + byte] = bit.band(bit.rshift(value, byte * 8), 0xFF)
    end
end

-- Sends an NPC trade (0x036) that takes one item from each inventory slot listed.
local function tradeSlots(player, npc, slots)
    local packet = ffi.new('uint8_t[64]')
    writeUint32(packet, 4, npc:getID())
    for index, slot in ipairs(slots) do
        writeUint32(packet, 8 + (index - 1) * 4, 1)
        packet[47 + index] = slot
    end

    packet[58] = bit.band(npc:getTargID(), 0xFF)
    packet[59] = bit.rshift(npc:getTargID(), 8)
    packet[60] = #slots

    player.packets:send(0x036, packet, assert(ffi.sizeof(packet)))
end

describe('Interaction Framework', function()
    it('completes Shady Business quest with zinc ore trade', function()
        ---@type CClientEntityPair
        local player = xi.test.world:spawnPlayer()

        player:addQuest(xi.questLog.BASTOK, xi.quest.id.bastok.BEAUTY_AND_THE_GALKA)
        player:completeQuest(xi.questLog.BASTOK, xi.quest.id.bastok.BEAUTY_AND_THE_GALKA)

        player:gotoZone(xi.zone.PORT_BASTOK)
        player.entities:gotoAndTrigger('Talib', { eventId = 90 })
        player.assert:hasQuest(xi.questLog.BASTOK, xi.quest.id.bastok.SHADY_BUSINESS)

        local slots = {}
        for _ = 1, 4 do
            player:addItem(xi.item.CHUNK_OF_ZINC_ORE)
        end

        for slot = 0, player:getContainerSize(xi.inv.INVENTORY) do
            local item = player:getStorageItem(xi.inv.INVENTORY, slot, 255)
            if item and item:getID() == xi.item.CHUNK_OF_ZINC_ORE then
                table.insert(slots, slot)
            end
        end

        assert(#slots == 4, 'expected four single Zinc Ore, found ' .. tostring(#slots) .. ' slots')

        tradeSlots(player, player.entities:get('Talib'), slots)
        player.events:expect({ eventId = 91 })

        player.assert
            :hasCompletedQuest(xi.questLog.BASTOK, xi.quest.id.bastok.SHADY_BUSINESS)
            :hasGil(350)

        player.assert.no:hasItem(xi.item.CHUNK_OF_ZINC_ORE)
    end)
end)
