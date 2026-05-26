-----------------------------------
-- func: dynareset
-- desc: Full reset of a dynamis zone (despawn all mobs and reset all zone variables)
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
    BEAUC      = xi.zone.DYNAMIS_BEAUCEDINE,
    XARCABARD  = xi.zone.DYNAMIS_XARCABARD,
    VALKURM    = xi.zone.DYNAMIS_VALKURM,
    QUFIM      = xi.zone.DYNAMIS_QUFIM,
    BUBURIMU   = xi.zone.DYNAMIS_BUBURIMU,
    TAVNAZIA   = xi.zone.DYNAMIS_TAVNAZIA
}

local function error(player, msg)
    player:printToPlayer(msg)
    player:printToPlayer('!dynareset [zone name or ID]')
end

commandObj.onTrigger = function(player, zoneName)
    local dynaZoneID = 0 --[[@as integer]]
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
        player:printToPlayer('No zone specified, please specify a zone name or ID.')
        return
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

    -- Full cleanup: despawn all mobs and reset all zone variables
    xi.dynamis.cleanupDynamis(zone)

    player:printToPlayer(string.format('Full reset performed on %s - all mobs despawned and variables cleared.', zone:getName()))
end

return commandObj
