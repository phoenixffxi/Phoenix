-----------------------------------
-- Dynamis Hourglass functions
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

xi.dynamis.makeGlass = function(player, zoneId, startTime, endTime)
    -- Set the var here so its the same as the glass. Setting it earlier or later will result in 10-15ms delay.
    SetServerVariable(string.format('[DYNA]StartTime_%s', zoneId), startTime)
    SetServerVariable(string.format('[DYNA]ExpirationTime_%s', zoneId), endTime)

    xi.dynamis.debugPrint(string.format('------------xi.dynamis.makeGlass------------'))
    xi.dynamis.debugPrint(string.format('Making glass for player %s | Start Time %s | End Time %s', player:getName(), startTime, endTime))

    player:addItem({
        id = xi.item.PERPETUAL_HOURGLASS,
        quantity = 1,
        exdata =
        {
            flags     = 0x01,
            startTime = startTime,
            endTime   = endTime,
            zoneId    = zoneId,
        },
    })
end

xi.dynamis.voidGlass = function(player, glassObj)
    glassObj:setExData({ flags = 0, startTime = 0, endTime = 0, zoneId = 0 })
end

-- Reads a given Perpetual Hourglass and returns the start time, end time, zone ID, and token
xi.dynamis.decypherGlass = function(glassObj)
    local exData = glassObj and glassObj:getExData()

    xi.dynamis.debugPrint(string.format('------------xi.dynamis.decypherGlass------------'))
    xi.dynamis.debugPrint(string.format('Decyphering glass with exData: %s', exData))
    xi.dynamis.debugPrint(string.format('exData.flags: %s, exData.startTime: %s, exData.endTime: %s, exData.zoneId: %s', exData.flags, exData.startTime, exData.endTime, exData.zoneId))

    if
        not exData or
        exData.endTime <= GetSystemTime() -- If glass is expired
    then
        return { chamberId = 0, startTime = 0, endTime = 0 }
    end

    return { startTime = exData.startTime, endTime = exData.endTime, zoneId = exData.zoneId }
end

-- Validate hourglass - checks if player has an hourglass with matching startTime and zoneId
local function validatePlayerHourglass(player, expectedStartTime, expectedZoneId)
    local perpetualHourglass = xi.item.PERPETUAL_HOURGLASS
    xi.dynamis.debugPrint(string.format('------------validatePlayerHourglass------------'))

    for _, item in ipairs(player:findItems(perpetualHourglass)) do
        local exdata = item:getExData()
        xi.dynamis.debugPrint(string.format('Validating hourglass for player %s. Expected startTime: %s, expected zoneId: %s. Found hourglass with startTime: %s, zoneId: %s', player:getName(), expectedStartTime, expectedZoneId, exdata.startTime, exdata.zoneId))
        -- Verify this is the correct hourglass by checking startTime and zoneId
        if
            exdata.startTime == expectedStartTime and
            exdata.zoneId == expectedZoneId
        then
            xi.dynamis.debugPrint('Hourglass validated successfully!')
            return true
        else
            xi.dynamis.debugPrint(string.format('Hourglass mismatch. Expected startTime: %s, got: %s. Expected zoneId: %s, got: %s', expectedStartTime, exdata.startTime, expectedZoneId, exdata.zoneId))
        end
    end

    return false
end

-- Verify hourglass trade and determine if NEW or REGISTERED
xi.dynamis.verifyTradeHourglass = function(player, zoneId)
    local dynaZone = xi.dynamis.entryInfoEra[zoneId].dynaZone
    -- Check if the zone is valid for Dynamis
    if not dynaZone then
        return xi.dynamis.hourglassTradeResult.INVALID
    end

    xi.dynamis.debugPrint(string.format('------------xi.dynamis.verifyTradeHourglass------------'))

    local expectedStartTime = GetServerVariable(string.format('[DYNA]StartTime_%s', dynaZone))
    xi.dynamis.debugPrint(string.format('Verifying hourglass trade for player %s in zone %s. Expected startTime: %s', player:getName(), dynaZone, expectedStartTime))

    -- Validate hourglass now with updated exdata
    if not validatePlayerHourglass(player, expectedStartTime, dynaZone) then
        return xi.dynamis.hourglassTradeResult.INVALID
    end

    xi.dynamis.debugPrint('Player has a valid perpetual hourglass for this Dynamis zone')
    xi.dynamis.debugPrint(string.format('Checking if player %s is already registered for this session', player:getName()))

    -- Check if player is already registered in this session
    local instanceId   = GetServerVariable(string.format('[DYNA]InstanceID_%s', dynaZone))
    local participants = xi.dynamis.getParticipants(instanceId)
    if participants[player:getID()] then
        -- Player is already registered
        xi.dynamis.debugPrint(string.format('Player %s is already registered for this session', player:getName()))
        return xi.dynamis.hourglassTradeResult.REGISTERED
    end

    return xi.dynamis.hourglassTradeResult.NEW
end

local function updatePlayerHourglassExdata(player, expectedStartTime, expectedZoneId, zoneExpiration)
    local perpetualHourglass = xi.item.PERPETUAL_HOURGLASS

    xi.dynamis.debugPrint(string.format('------------updatePlayerHourglassExdata------------'))
    xi.dynamis.debugPrint(string.format('updatePlayerHourglassExdata - expectedStartTime: %s, expectedZoneId: %s, zoneExpiration: %s', expectedStartTime, expectedZoneId, zoneExpiration))

    for _, item in ipairs(player:findItems(perpetualHourglass)) do
        local exdata = item:getExData()
        xi.dynamis.debugPrint(string.format('Found hourglass with exdata: startTime=%s, endTime=%s, zoneId=%s', exdata.startTime, exdata.endTime, exdata.zoneId))

        -- Verify this is the correct hourglass by checking startTime and zoneId
        if
            exdata.startTime == expectedStartTime and
            exdata.zoneId == expectedZoneId
        then
            xi.dynamis.debugPrint(string.format('Hourglass validated. Updating exdata endTime from %s to %s', exdata.endTime, zoneExpiration))
            exdata.endTime = zoneExpiration

            item:setExData(exdata)
        else
            xi.dynamis.debugPrint(string.format('Hourglass mismatch. Expected startTime: %s, got: %s. Expected zoneId: %s, got: %s', expectedStartTime, exdata.startTime, expectedZoneId, exdata.zoneId))
        end
    end
end

xi.dynamis.updatePlayerHourglass = function(player)
    if not player:hasItem(xi.item.PERPETUAL_HOURGLASS) then
        xi.dynamis.debugPrint('Player does not have a perpetual hourglass, skipping update')
        return
    end

    local zoneId = player:getZoneID()

    if not player:isInDynamis() then
        zoneId = xi.dynamis.entryInfoEra[zoneId].dynaZone
    end

    -- We could get the exdata from the glass
    local zoneStartTime  = GetServerVariable(string.format('[DYNA]StartTime_%s', zoneId))
    local zoneExpiration = GetServerVariable(string.format('[DYNA]ExpirationTime_%s', zoneId))

    xi.dynamis.debugPrint(string.format('------------xi.dynamis.updatePlayerHourglass------------'))
    xi.dynamis.debugPrint(string.format('Updating player hourglass with StartTime %s | EndTime %s', zoneStartTime, zoneExpiration))
    xi.dynamis.debugPrint(string.format('DEBUG: zoneExpiration retrieved from server variable: %s', zoneExpiration))

    -- Update hourglass exdata with new timepoint
    updatePlayerHourglassExdata(player, zoneStartTime, zoneId, zoneExpiration)
end

xi.dynamis.updatePlayerHourglassForAll = function(zone)
    local zoneId        = zone:getID()
    local parentZone    = GetZone(xi.dynamis.dynaIDLookup[zoneId].entryZone)
    local playersInZone = parentZone:getPlayers()

    for _, player in pairs(playersInZone) do
        xi.dynamis.updatePlayerHourglass(player)
    end
end

xi.dynamis.hasHourglass = function(player, expectedStartTime, expectedZoneId, zoneExpiration)
    xi.dynamis.debugPrint(string.format('------------xi.dynamis.hasHourglass------------'))
    local zoneId = player:getZoneID()

    if validatePlayerHourglass(player, expectedStartTime, expectedZoneId) then
        return true
    else
        if xi.dynamis.isGM(player) then
            player:setCharVar(string.format('[DYNA]EjectPlayer_%s', zoneId), zoneExpiration) -- Player is a GM and can bypass the hourglass requirement.
        else
            xi.dynamis.debugPrint(string.format('Ejecting player: %s', player:getName()))
            xi.dynamis.ejectPlayer(player)
        end

        return false
    end
end

xi.dynamis.getMatchingGlasses = function(player, zoneId, startTime)
    local matchingGlasses = { }

    for _, item in ipairs(player:findItems(xi.item.PERPETUAL_HOURGLASS)) do
        local glassData = xi.dynamis.decypherGlass(item)
        if
            glassData.zoneId == zoneId and
            glassData.startTime == startTime
        then
            table.insert(matchingGlasses, item)
        end
    end

    return matchingGlasses
end

xi.dynamis.isGlassExpired = function(glassObj)
    local glassData = xi.dynamis.decypherGlass(glassObj)
    xi.dynamis.debugPrint(glassData)

    if glassData.endTime > GetSystemTime() then
        return false
    end

    xi.dynamis.debugPrint(string.format('Glass is expired. Current time: %s, glass expiration time: %s', GetSystemTime(), glassData.endTime))
    return true
end

xi.dynamis.onGlassCheck = function(player, glassObj)
    xi.dynamis.debugPrint('onGlassCheck called')
    if not glassObj then
        return xi.msg.basic.ITEM_UNABLE_TO_USE
    end

    xi.dynamis.debugPrint('Glass object found, checking validity')
    if xi.dynamis.isGlassExpired(glassObj) then
        xi.dynamis.voidGlass(player, glassObj)
        return xi.msg.basic.ITEM_UNABLE_TO_USE
    end

    xi.dynamis.debugPrint('Glass is valid, allowing use')
    if player:getFreeSlotsCount() <= 1 then -- <= 1 is not a typo -- see onGlassUse
        return xi.msg.basic.ITEM_NO_USE_INVENTORY
    end

    xi.dynamis.debugPrint('Player has enough inventory space, allowing use')
    return 0
end

xi.dynamis.onGlassUse = function(player, glassObj)
    xi.dynamis.debugPrint('onGlassUse called')
    if not glassObj then
        return
    end

    local glassData = xi.dynamis.decypherGlass(glassObj)
    if
        not glassData or
        glassData.endTime < GetSystemTime()
    then
        xi.dynamis.voidGlass(player, glassObj)
        return
    end

    -- Using the glass consumes it, so we need to make two new ones
    for _ = 1, 2 do
        xi.dynamis.makeGlass(player, glassData.zoneId, glassData.startTime, glassData.endTime)
    end
end

xi.dynamis.onGlassDrop = function(player, glassObj)
    -- If the player is not in dynamis return
    if not xi.dynamis.isValidDynamisZone(player:getZoneID()) then
        return
    end

    -- If they are in dynamis and dont have another glass they need to be ejected
    local glassData = xi.dynamis.decypherGlass(glassObj)
    if #xi.dynamis.getMatchingGlasses(player, glassData.zoneId, glassData.startTime) == 0 then
        xi.dynamis.debugPrint('------------onGlassDrop------------')
        xi.dynamis.debugPrint('Ejecting Player: ' .. player:getName())
        xi.dynamis.ejectPlayer(player, true)
    end
end
