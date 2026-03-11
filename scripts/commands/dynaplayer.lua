-----------------------------------
-- func: dynaplayer
-- desc: Reset a single player's dynamis variables only (without zone cleanup)
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 3,
    parameters = 'ss'
}

local dynamisZones =
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
    player:printToPlayer('!dynaplayer [player name] [dyna zone]')
end

commandObj.onTrigger = function(player, targetName, zoneName)
    local targ = nil

    if targetName and targetName ~= nil and targetName ~= '' then
        targ = GetPlayerByName(targetName)
        if not targ then
            error(player, string.format('Player \'%s\' not found!', targetName))
            return
        end
    else
        -- Use cursor target or self
        local cursortarget = player:getCursorTarget()
        if cursortarget and not cursortarget:isNPC() then
            targ = cursortarget
        else
            targ = player
        end
    end

    -- Get the dynamis zone from the dynamisZones table
    if not zoneName or zoneName == '' then
        error(player, 'Zone name required!')
        return
    end

    local dynaZone = dynamisZones[string.upper(zoneName)]
    if not dynaZone then
        error(player, string.format('Unknown zone: %s', zoneName))
        return
    end

    -- Reset only the player's variables (no zone cleanup)
    xi.dynamis.resetPlayerVars(targ, dynaZone)

    player:printToPlayer(string.format('Reset %s\'s dynamis variables only (zone not affected).', targ:getName()))
end

return commandObj
