-----------------------------------
-- func: dynavars
-- desc: Display all dynamis zone variables for a given zone
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 3,
    parameters = 's'
}

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

local function error(player, msg)
    player:printToPlayer(msg)
    player:printToPlayer('!dynavars [zone name or ID]')
end

commandObj.onTrigger = function(player, zoneName)
    local dynaZoneID = 0
    zoneName = string.upper(zoneName)
    -- Determine zone ID from parameter or use current zone
    if zoneName and zoneName ~= nil and zoneName ~= '' then
        -- Try to get zone from lookup table
        if dynaZones[zoneName] then
            dynaZoneID = dynaZones[zoneName]
        else
            error(player, string.format('Zone \'%s\' not found!', zoneName))
            return
        end
    else
        dynaZoneID = player:getZoneID()
    end

    -- Check if it's a valid dynamis zone
    if not xi.dynamis.isValidDynamisZone(dynaZoneID) then
        error(player, string.format('Zone ID %d is not a valid Dynamis zone.', dynaZoneID))
        return
    end

    local zone = GetZone(dynaZoneID)
    if not zone then
        error(player, string.format('Zone ID %d does not exist or is not loaded.', dynaZoneID))
        return
    end

    local zoneVars = zone:getLocalVars() or {}
    if #zoneVars > 0 then
        player:printToPlayer(string.format('Printing local vars for zone: %s', zone:getName()), xi.msg.channel.SYSTEM_3)
        player:printToPlayer('----------------------------------', xi.msg.channel.SYSTEM_3)
        for _, var in pairs(zoneVars) do
            player:printToPlayer(string.format('"%s" : %u', var['varname'], var['value']), xi.msg.channel.SYSTEM_3)
        end
    else
        player:printToPlayer(string.format('No local vars for zone: %s', zone:getName()), xi.msg.channel.SYSTEM_3)
    end

    local varExpiration      = string.format('[DYNA]ExpirationTime_%s', dynaZoneID)
    -- Calculate time remaining if expiration is set
    local zoneExpiration = GetServerVariable(varExpiration)
    if zoneExpiration and zoneExpiration ~= 0 then
        local timeRemaining = xi.dynamis.getDynaTimeRemaining(zoneExpiration)
        player:printToPlayer('Time Remaining: ' .. timeRemaining .. ' seconds | ' .. math.floor(timeRemaining / 60) .. ' minutes', xi.msg.channel.SYSTEM_3)
    end

    player:printToPlayer('=== End Dynamis Variables ===', xi.msg.channel.SYSTEM_3)
end

return commandObj
