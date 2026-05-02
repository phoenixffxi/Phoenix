-----------------------------------
-- func: dynadespawn
-- desc: Despawns all mobs in a dynamis zone without resetting variables
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
    player:printToPlayer('!dynadespawn [zone name or ID] - If no zone is specified, the current zone will be used.')
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

    print(string.format('Attempting to despawn all mobs in zone ID %d...', dynaZoneID))
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

    -- Despawn all mobs without resetting zone variables
    xi.dynamis.despawnAll(zone)
    player:printToPlayer(string.format('Despawned all mobs in %s.', zone:getName()))
end

return commandObj
