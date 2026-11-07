-----------------------------------
-- Phoenix version of systems/chocobo_raising/digging.lua.
-- phoenix/lua/globals/hobbies/chocobo_digging replaces xi.chocoboDig.start with era digging that has
-- no raised chocobo abilities, and keeps the daily dig count in an account var.
-----------------------------------
local ffi = require('ffi')

local zoneId    = xi.zone.EAST_RONFAURE
local foundItem = xi.item.LITTLE_WORM
local greens    = xi.item.BUNCH_OF_GYSAHL_GREENS

describe('Chocobo digging', function()
    ---@type CClientEntityPair
    local player

    local originalTable
    local accuracyRoll

    -- Runs out the cooldowns. A last dig time of 0 would also switch off the same-spot rule; moveOn leaves the spot.
    local function dig(moveOn)
        player:setLocalVar('ZoneInTime', 0)
        player:setLocalVar('[DIG]LastDigTime', 1)
        if moveOn then
            player:setLocalVar('[DIG]LastXPos', 5000)
            player:setLocalVar('[DIG]LastXPosSign', 0)
        end

        local packet = ffi.new('uint8_t[28]')
        local id     = player:getID()
        for byte = 0, 3 do
            packet[4 + byte] = bit.band(bit.rshift(id, byte * 8), 0xFF)
        end

        packet[8]  = bit.band(player:getTargID(), 0xFF)
        packet[9]  = bit.rshift(player:getTargID(), 8)
        packet[10] = 0x11

        player.packets:send(0x01A, packet, assert(ffi.sizeof(packet)))
    end

    before_each(function()
        xi.test.world:setSetting('main.DIG_FATIGUE', 100)

        player = xi.test.world:spawnPlayer({ zone = zoneId, level = 20 })
        player:setGMLevel(0)
        player:addKeyItem(xi.keyItem.CHOCOBO_LICENSE)
        player:addStatusEffect(xi.effect.MOUNTED, { power = xi.mount.CHOCOBO, duration = 1800, origin = player, silent = true })
        player:setWeather(xi.weather.NONE)
        player:addItem(greens, 12)
        xi.chocoboDig.updateFatigue(player, 0)

        -- One row, so any item roll finds it.
        originalTable = xi.chocoboDig.zoneTable[zoneId]
        xi.chocoboDig.zoneTable[zoneId] = { { foundItem, xi.craftRank.AMATEUR, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000 } }

        accuracyRoll = 1
        local originalRandomInt = math.randomInt
        stub('math.randomInt', function(low, high)
            if low == 1 and high == 100 then
                return accuracyRoll
            end

            return originalRandomInt(low, high)
        end)
    end)

    after_each(function()
        xi.chocoboDig.zoneTable[zoneId] = originalTable
    end)

    it('finds an item and counts the dig on the account', function()
        dig(true)

        assert(player:getItemCount(greens) == 11, 'the dig did not run')
        player.assert:hasItem(foundItem)
        assert(player:getAccountVar('[DIG]DigCount') == 1, 'dig not counted in the account var')
        assert(player:getCharVar('[DIG]DigCount') == 0, 'dig also counted on the character')
    end)

    it('finds nothing and counts nothing when the accuracy roll misses', function()
        accuracyRoll = 100
        dig(true)

        assert(player:getItemCount(greens) == 11, 'the dig did not run')
        player.assert.no:hasItem(foundItem)
        assert(xi.chocoboDig.fetchFatigue(player) == 0, 'a missed dig was counted')
    end)

    it('finds nothing in the spot it just dug', function()
        dig(true)
        dig(false)

        assert(player:getItemCount(greens) == 10, 'both digs did not run')
        assert(player:getItemCount(foundItem) == 1, 'found a second item in the same spot')
        assert(xi.chocoboDig.fetchFatigue(player) == 1, 'the empty dig was counted')
    end)

    it('finds nothing at the daily limit', function()
        xi.chocoboDig.updateFatigue(player, xi.settings.main.DIG_FATIGUE)
        dig(true)

        assert(player:getItemCount(greens) == 11, 'the dig did not run')
        player.assert.no:hasItem(foundItem)
    end)
end)
