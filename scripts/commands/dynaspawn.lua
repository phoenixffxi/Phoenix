-----------------------------------
-- func: dynaspawn
-- desc: Spawns a statue by enedin ID in a dynamis zone
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 3,
    parameters = 'si'
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
    player:printToPlayer('!dynaspawn [zone name] [enedin id]')
end

commandObj.onTrigger = function(player, zoneName, enedinID)
    local dynaZoneID = 0

    -- Determine zone ID from parameter or use current zone
    if zoneName and zoneName ~= nil and zoneName ~= '' then
        dynaZoneID = tonumber(zoneName)
        if not dynaZoneID then
            -- Try to get zone from lookup table
            zoneName = string.upper(zoneName)
            if dynaZones[zoneName] then
                dynaZoneID = dynaZones[zoneName]
            else
                error(player, string.format('Zone \'%s\' not found!', zoneName))
                return
            end
        end
    else
        dynaZoneID = player:getZoneID()
    end

    -- Check if it's a valid dynamis zone
    if not xi.dynamis.isValidDynamisZone(dynaZoneID) then
        error(player, string.format('Zone ID %d is not a valid Dynamis zone.', dynaZoneID))
        return
    end

    -- Look up the actual mob ID from the enedin table
    if not xi.dynamis.enedinTable[dynaZoneID] then
        error(player, string.format('No enedin table for zone ID %d.', dynaZoneID))
        return
    end

    local mobID = xi.dynamis.enedinTable[dynaZoneID][enedinID]
    if not mobID then
        error(player, string.format('Enedin ID %d not found in this zone.', enedinID))
        return
    end

    local zone = GetZone(dynaZoneID)
    if not zone then
        error(player, string.format('Zone ID %d does not exist or is not loaded.', dynaZoneID))
        return
    end

    -- Try to spawn the mob

    if GetMobByID(mobID) == nil then
        error(player, string.format('Invalid mob ID %d in this zone.', mobID))
        return
    end

    if GetMobByID(mobID):isSpawned() then
        error(player, string.format('Mob %d is already spawned in this zone.', mobID))
        return
    end

    SpawnMob(mobID)
    player:printToPlayer(string.format('Spawned %s (ID: %d) in %s.', GetMobByID(mobID):getName(), mobID, zone:getName()))
end

return commandObj
