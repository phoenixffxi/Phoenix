-----------------------------------
-- Dynamis Hourglass functions
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

xi.dynamis.makeGlass = function(player, starTime, expirationTime, dynaZoneID, dynamisToken)
    local playerId  = player:getID()
    local startTime = GetSystemTime()
    local endTime   = startTime + expirationTime

    -- TODO: Make use of new table format after PR is merged
    player:addItem({
        id = xi.item.PERPETUAL_HOURGLASS,
        quantity = 1,
        exdata = {
            [0x02] = 0x01,                                          -- flags
            [0x04] = bit.band(playerId, 0xFF),                      -- player ID (byte 0)
            [0x05] = bit.band(bit.rshift(playerId, 8), 0xFF),
            [0x06] = bit.band(bit.rshift(playerId, 16), 0xFF),
            [0x07] = bit.band(bit.rshift(playerId, 24), 0xFF),
            [0x08] = bit.band(endTime, 0xFF),                       -- end time (byte 0)
            [0x09] = bit.band(bit.rshift(endTime, 8), 0xFF),
            [0x0A] = bit.band(bit.rshift(endTime, 16), 0xFF),
            [0x0B] = bit.band(bit.rshift(endTime, 24), 0xFF),
            [0x0C] = bit.band(startTime, 0xFF),                     -- start time (byte 0)
            [0x0D] = bit.band(bit.rshift(startTime, 8), 0xFF),
            [0x0E] = bit.band(bit.rshift(startTime, 16), 0xFF),
            [0x0F] = bit.band(bit.rshift(startTime, 24), 0xFF),
            [0x10] = bit.band(dynaZoneID, 0xFF),                    -- zone ID
            [0x14] = bit.band(dynamisToken, 0xFF),                  -- token (byte 0)
            [0x15] = bit.band(bit.rshift(dynamisToken, 8), 0xFF),
            [0x16] = bit.band(bit.rshift(dynamisToken, 16), 0xFF),
            [0x17] = bit.band(bit.rshift(dynamisToken, 24), 0xFF),
        }
    })
end

-- Reads a given Perpetual Hourglass and returns the player ID, start time, end time, zone ID, and token
xi.dynamis.glassData = function(glassObj)
    local exData = glassObj and glassObj:getExData()
    if
        not exData or
        #exData < 24
    then
        return { playerId = 0, startTime = 0, endTime = 0, zoneId = 0, token = 0 }
    end

    local playerId = bit.bor(
        exData[4] or 0,
        bit.lshift(exData[5] or 0, 8),
        bit.lshift(exData[6] or 0, 16),
        bit.lshift(exData[7] or 0, 24)
    )

    local endTime = bit.bor(
        exData[8] or 0,
        bit.lshift(exData[9] or 0, 8),
        bit.lshift(exData[10] or 0, 16),
        bit.lshift(exData[11] or 0, 24)
    )

    local startTime = bit.bor(
        exData[12] or 0,
        bit.lshift(exData[13] or 0, 8),
        bit.lshift(exData[14] or 0, 16),
        bit.lshift(exData[15] or 0, 24)
    )

    local zoneId = exData[16] or 0

    local token = bit.bor(
        exData[20] or 0,
        bit.lshift(exData[21] or 0, 8),
        bit.lshift(exData[22] or 0, 16),
        bit.lshift(exData[23] or 0, 24)
    )

    return { playerId = playerId, startTime = startTime, endTime = endTime, zoneId = zoneId, token = token }
end

-- Validate hourglass - checks if player has an hourglass with the matching token in inventory
xi.dynamis.validatePlayerHourglass = function(player, zoneSessionID)
    local perpetualHourglass = xi.item.PERPETUAL_HOURGLASS

    -- Get all items from player inventory
    local items = player:getItems(xi.inv.INVENTORY)
    if not items then
        return false
    end

    for slotIndex, item in pairs(items) do
        if item and item:getID() == perpetualHourglass then
            local exdata = item:getExData()

            -- Check if token matches (stored at exdata offset 0x14 as uint32)
            local storedToken = 0
            storedToken = exdata[0x14] + (exdata[0x15] * 256) + (exdata[0x16] * 65536) + (exdata[0x17] * 16777216)
            xi.dynamis.debugPrint(string.format('Validating hourglass. Stored token: %s, Zone session ID: %s', storedToken, zoneSessionID))
            if storedToken == zoneSessionID then
                xi.dynamis.debugPrint('Hourglass token validated successfully!')
                return true
            end
        end
    end

    return false
end

xi.dynamis.verifyHasHourglass = function(player, zoneSessionID, zoneExpiration)
    local zoneID = player:getZoneID()

    if xi.dynamis.validatePlayerHourglass(player, zoneSessionID) then
        return true
    else
        if xi.dynamis.isGM(player) then
            player:setCharVar(string.format('[DYNA]EjectPlayer_%s', zoneID), zoneExpiration) -- Player is a GM and can bypass the hourglass requirement.
        elseif player:getCharVar(string.format('[DYNA]PlayerZoneToken_%s', player:getZoneID())) ~= zoneSessionID then
            xi.dynamis.ejectPlayer(player, true)
        else
            xi.dynamis.ejectPlayer(player)
        end

        return false
    end
end

-- Verify hourglass trade and determine if NEW or REGISTERED
xi.dynamis.verifyTradeHourglass = function(player, zoneID)
    local dynaZone = xi.dynamis.entryInfoEra[zoneID].dynaZone
    -- Check if the zone is valid for Dynamis
    if not dynaZone then
        return xi.dynamis.hourglassTradeResult.INVALID
    end

    local zoneSessionID = GetServerVariable(string.format('[DYNA]SessionID_%s', dynaZone))

    -- Validate hourglass first
    if not xi.dynamis.validatePlayerHourglass(player, zoneSessionID) then
        return xi.dynamis.hourglassTradeResult.INVALID
    end

    -- Check if player is already registered in this session
    local playerRegistered = player:getCharVar(string.format('[DYNA]PlayerRegistered_%s', dynaZone))
    local playerRegKey     = player:getCharVar(string.format('[DYNA]PlayerRegisterKey_%s', dynaZone))

    -- If remainder matches key, player already registered
    if (playerRegistered - zoneSessionID) == playerRegKey then
        return xi.dynamis.hourglassTradeResult.REGISTERED
    end

    return xi.dynamis.hourglassTradeResult.NEW
end

local function updatePlayerHourglassExdata(player, dynamisToken, timepoint)
    local perpetualHourglass = xi.item.PERPETUAL_HOURGLASS

    -- Grab the players inventory first
    -- If it fails we have a problem
    local items = player:getItems(xi.inv.INVENTORY)
    if not items then
        xi.dynamis.debugPrint('No items found in inventory')
        return
    end

    for slotIndex, item in pairs(items) do
        if item and item:getID() == perpetualHourglass then
            local exdata = item:getExData()

            -- Check if token matches (stored at exdata offset 0x14 as uint32)
            local storedToken = 0
            storedToken = exdata[0x14] + (exdata[0x15] * 256) + (exdata[0x16] * 65536) + (exdata[0x17] * 16777216)

            if storedToken == dynamisToken then
                xi.dynamis.debugPrint('Token matched! Updating exdata.')
                exdata[0x08] = bit.band(timepoint, 0xFF)
                exdata[0x09] = bit.band(bit.rshift(timepoint, 8), 0xFF)
                exdata[0x0A] = bit.band(bit.rshift(timepoint, 16), 0xFF)
                exdata[0x0B] = bit.band(bit.rshift(timepoint, 24), 0xFF)

                -- Delete the old item and re-add it with updated exdata
                -- This ensures the client gets notified with the proper packets
                local slotID = item:getSlotID()
                player:delItemAt(perpetualHourglass, 1, xi.inv.INVENTORY, slotID)
                player:addItem({
                    id = perpetualHourglass,
                    quantity = 1,
                    exdata = exdata
                })
            else
                xi.dynamis.debugPrint('Token mismatch, skipping update')
            end
        end
    end
end

xi.dynamis.updatePlayerHourglass = function(player, zoneSessionID)
    if not player:hasItem(xi.item.PERPETUAL_HOURGLASS) then
        xi.dynamis.debugPrint('Player does not have a perpetual hourglass, skipping update')
        return
    end

    local zoneID = player:getZoneID()

    if not player:isInDynamis() then
        zoneID = xi.dynamis.entryInfoEra[zoneID].dynaZone
    end

    local zoneExpiration = GetServerVariable(string.format('[DYNA]ExpirationTime_%s', zoneID))
    xi.dynamis.debugPrint(string.format('Updating player hourglass with token %s and timepoint %s', zoneSessionID, zoneExpiration))
    -- Update hourglass exdata with new timepoint
    updatePlayerHourglassExdata(player, zoneSessionID, zoneExpiration)
end

xi.dynamis.updatePlayerHourglassForAll = function(zone, zoneSessionID)
    local zoneID        = zone:getID()
    local parentZone    = GetZone(xi.dynamis.dynaIDLookup[zoneID].entryZone)
    local playersInZone = parentZone:getPlayers()

    for _, player in pairs(playersInZone) do
        xi.dynamis.updatePlayerHourglass(player, zoneSessionID)
    end
end
