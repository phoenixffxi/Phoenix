-----------------------------------
-- func: rdyna (Reset Dynamis)
-- desc: Resets variables related to Dynamis
-- If single it will just clear a single player's reservation variables.
-- If party or alliance it will clear all player's reservation variables as well as the zone's token.
-- NOTICE: Players need to be in the correct staging zone for their dynamis.
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 3,
    parameters = 'sss'
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

local error = function(player, msg)
    player:printToPlayer(msg)
    player:printToPlayer('!rdyna [single/party/alliance] [target] [dyna zone]')
end

commandObj.onTrigger = function(player, aoe, target, zoneName)
    local targ = nil
    local cursortarget = player:getCursorTarget()

    if aoe == nil then
        error(player, 'You must specify if you want to reset vars for a single player, a party, or an alliance.')
        return
    end

    if target then
        targ = GetPlayerByName(target)
        if not targ then
            error(player, string.format('Player named \'%s\' not found!', target))
            return
        end

    elseif cursortarget and not cursortarget:isNPC() then
        targ = cursortarget
    else
        targ = player
    end

    local playersinparty = targ:getParty()
    local playersinally = targ:getAlliance()
    local dynaZone = dynaZones[string.upper(zoneName)]
    local zone = GetZone(dynaZone)

    if aoe == 'party' then
        for _, playerEntity in pairs(playersinparty) do
            xi.dynamis.resetPlayerVars(playerEntity, dynaZone)
            player:printToPlayer(string.format('%s\'s variables have been reset.', playerEntity:getName()))
        end

        if dynaZone ~= nil then
            player:printToPlayer(string.format('NOTICE: Resetting dynamis zone variables for %s', dynaZone))
            xi.dynamis.cleanupDynamis(zone)
        end

        player:printToPlayer('NOTICE: Players must wait at minimum 5 minutes to re-enter dynamis so it can cleanup.')
    elseif aoe == 'alliance' then
        for _, playerEntity in pairs(playersinally) do
        -- Reset only the player's variables (no zone cleanup)
        xi.dynamis.resetPlayerVars(targ, dynaZone)
            player:printToPlayer(string.format('%s\'s variables have been reset.', playerEntity:getName()))
        end

        if dynaZone ~= nil then
            player:printToPlayer(string.format('NOTICE: Resetting dynamis zone variables for %s', dynaZone))
            xi.dynamis.cleanupDynamis(zone)
        end

        player:printToPlayer('NOTICE: Players must wait at minimum 5 minutes to re-enter dynamis so it can cleanup.')
    else
        -- Reset only the player's variables (no zone cleanup)
        xi.dynamis.resetPlayerVars(targ, dynaZone)
        player:printToPlayer(string.format('%s\'s variables have been reset.', targ:getName()))
    end
end

return commandObj
