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

commandObj.onTrigger = function(player, zoneName, mode)
    -- Validate parameters
    if not zoneName or zoneName == '' then
        player:printToPlayer('Usage: !dynastart zonename mode', xi.msg.channel.SYSTEM)
        player:printToPlayer('Mode: 0 = normal, 1 = debug', xi.msg.channel.SYSTEM)
        return
    end
    print(mode)
    if not mode or (mode ~= 0 and mode ~= 1) then
        player:printToPlayer('Mode must be 0 (normal) or 1 (debug)', xi.msg.channel.SYSTEM)
        return
    end

    mode = tonumber(mode)

    local dynaZoneID = tonumber(zoneName)
    if not dynaZoneID then
        -- Try to get zone from lookup table
        zoneName = string.upper(zoneName)
        if dynaZones[zoneName] then
            dynaZoneID = dynaZones[zoneName]
        else
            player:printToPlayer(string.format('Zone \'%s\' not found!', zoneName), xi.msg.channel.SYSTEM)
            return
        end
    end

    -- Get the player's cursor target
    local target = player:getCursorTarget()

    if not target then
        player:printToPlayer('You must have a target selected.', xi.msg.channel.SYSTEM)
        return
    end

    -- Verify target is a player
    if target:isPC() then
        xi.dynamis.onNewDynamis(target, mode)
        local modeStr = mode == 1 and 'debug' or 'normal'
        player:printToPlayer(string.format('Started dynamis for %s in %s mode', target:getName(), modeStr), xi.msg.channel.SYSTEM)
    else
        player:printToPlayer('Target must be a player.', xi.msg.channel.SYSTEM)
    end
end

return commandObj
