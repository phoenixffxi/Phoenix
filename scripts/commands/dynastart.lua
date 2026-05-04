-----------------------------------
-- func: dynastart
-- desc: Starts a dynamis event for the targeted player in DEBUG mode
-- **GM USE ONLY**
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 3,
    parameters = 'ss'
}

local function printUsage(player)
    player:printToPlayer('Usage: !dynastart mode', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('Usage: !dynastart zoneName mode', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('Mode: 0 = normal, 1 = debug', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('Target must be a player in the Dynamis zone or its attached entry zone.', xi.msg.channel.SYSTEM_3)
end

local function normalizeZoneName(zoneName)
    return string.upper(zoneName):gsub('DYNAMIS', ''):gsub('[^A-Z0-9]', '')
end

local dynaZones =
{
    BASTOK     = xi.zone.DYNAMIS_BASTOK,
    WINDURST   = xi.zone.DYNAMIS_WINDURST,
    SANDORIA   = xi.zone.DYNAMIS_SAN_DORIA,
    JEUNO      = xi.zone.DYNAMIS_JEUNO,
    BEAUCEDINE = xi.zone.DYNAMIS_BEAUCEDINE,
    XARCABARD  = xi.zone.DYNAMIS_XARCABARD,
    VALKURM    = xi.zone.DYNAMIS_VALKURM,
    QUFIM      = xi.zone.DYNAMIS_QUFIM,
    BUBURIMU   = xi.zone.DYNAMIS_BUBURIMU,
    TAVNAZIA   = xi.zone.DYNAMIS_TAVNAZIA
}

local function getDynamisZone(zoneName)
    if not zoneName or zoneName == '' then
        return nil
    end

    return dynaZones[normalizeZoneName(zoneName)]
end

local function isAttachedEntryZone(playerZoneId, dynaZoneId)
    local entryZoneId = xi.dynamis.dynaIDLookup[dynaZoneId] and xi.dynamis.dynaIDLookup[dynaZoneId].entryZone
    return entryZoneId == playerZoneId
end

commandObj.onTrigger = function(player, zoneNameOrMode, modeArg)
    local dynaZoneId
    local mode = tonumber(zoneNameOrMode)

    if mode == nil then
        dynaZoneId = getDynamisZone(zoneNameOrMode)
        mode = tonumber(modeArg)

        if not dynaZoneId then
            player:printToPlayer(string.format('Unknown Dynamis zone: %s', tostring(zoneNameOrMode)), xi.msg.channel.SYSTEM_3)
            printUsage(player)
            return
        end
    end

    if mode == nil then
        printUsage(player)
        player:printToPlayer('Mode: 0 = normal, 1 = debug', xi.msg.channel.SYSTEM_3)
        return
    end

    if mode ~= 0 and mode ~= 1 then
        player:printToPlayer('Mode must be 0 (normal) or 1 (debug)', xi.msg.channel.SYSTEM_3)
        return
    end

    -- Get the player's cursor target
    local target = player:getCursorTarget()

    if not target then
        player:printToPlayer('You must have a target selected.', xi.msg.channel.SYSTEM_3)
        return
    end

    if not target:isPC() then
        player:printToPlayer('Target must be a player.', xi.msg.channel.SYSTEM_3)
        return
    end

    if
        dynaZoneId and
        target:getZoneID() ~= dynaZoneId and
        not isAttachedEntryZone(target:getZoneID(), dynaZoneId)
    then
        player:printToPlayer(string.format('%s must be in the Dynamis zone or its attached entry zone.', target:getName()), xi.msg.channel.SYSTEM_3)
        return
    end

    xi.dynamis.onNewDynamis(target, mode, dynaZoneId)
    local modeStr = mode == 1 and 'debug' or 'normal'
    local zone = dynaZoneId and GetZone(dynaZoneId)
    local zoneText = zone and string.format(' for %s', zone:getName()) or ''
    player:printToPlayer(string.format('Started dynamis%s for %s in %s mode', zoneText, target:getName(), modeStr), xi.msg.channel.SYSTEM_3)
end

return commandObj
