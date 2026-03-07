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
    parameters = 'ss'
}

local error = function(player, msg)
    player:printToPlayer(msg)
    player:printToPlayer('!rdyna <single/party/alliance> <target>')
end

-- Reset all player-related dynamis charvars
local resetPlayerVars = function(playerEntity, dynaZone)
    -- Entry and reservation vars
    playerEntity:setCharVar('DynaEnterCount', math.max(0, playerEntity:getCharVar('DynaEnterCount') - 1))
    playerEntity:setCharVar('DynaReservationStart', 0)
    
    -- Lockout
    playerEntity:setCharVar('[DYNA]lockout', 0)
    
    -- Zone-specific registration vars
    if dynaZone and dynaZone ~= nil then
        playerEntity:setCharVar(string.format('[DYNA]PlayerRegistered_%s', dynaZone), 0)
        playerEntity:setCharVar(string.format('[DYNA]PlayerRegisterKey_%s', dynaZone), 0)
    end
end

-- Reset all zone-related dynamis variables
local resetZoneVars = function(dynaZone)
    if not dynaZone or dynaZone == nil then
        return
    end
    
    SetServerVariable(string.format('[DYNA]Token_%s', dynaZone), 0)
    SetServerVariable(string.format('[DYNA]Timepoint_%s', dynaZone), 0)
    SetServerVariable(string.format('[DYNA]Given10MinuteWarning_%s', dynaZone), 0)
    SetServerVariable(string.format('[DYNA]Given3MinuteWarning_%s', dynaZone), 0)
    SetServerVariable(string.format('[DYNA]Given1MinuteWarning_%s', dynaZone), 0)
    SetServerVariable(string.format('[DYNA]NoPlayerTimer_%s', dynaZone), 0)
    SetServerVariable(string.format('[DYNA]ZoneCooldown_%s', dynaZone), 0)
    SetServerVariable(string.format('[DYNA]CleanupScript_%s', dynaZone), 0)
end

commandObj.onTrigger = function(player, aoe, target)
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
    local dynaZone = xi.dynamis.dynaInfoEra[targ:getZoneID()].dynaZone
    local zone = GetZone(dynaZone)

    if aoe == 'party' then
        for _, playerEntity in pairs(playersinparty) do
            resetPlayerVars(playerEntity, dynaZone)
            player:printToPlayer(string.format('%s\'s variables have been reset.', playerEntity:getName()))
        end

        if dynaZone ~= nil then
            resetZoneVars(dynaZone)
            player:printToPlayer(string.format('NOTICE: Resetting dynamis zone variables for %s', dynaZone))
            xi.dynamis.cleanupDynamis(zone)
        end

        player:printToPlayer('NOTICE: Players must wait at minimum 5 minutes to re-enter dynamis so it can cleanup.')
    elseif aoe == 'alliance' then
        for _, playerEntity in pairs(playersinally) do
            resetPlayerVars(playerEntity, dynaZone)
            player:printToPlayer(string.format('%s\'s variables have been reset.', playerEntity:getName()))
        end

        if dynaZone ~= nil then
            resetZoneVars(dynaZone)
            player:printToPlayer(string.format('NOTICE: Resetting dynamis zone variables for %s', dynaZone))
            xi.dynamis.cleanupDynamis(zone)
        end

        player:printToPlayer('NOTICE: Players must wait at minimum 5 minutes to re-enter dynamis so it can cleanup.')
    else
        resetPlayerVars(targ, dynaZone)
        player:printToPlayer(string.format('%s\'s variables have been reset.', targ:getName()))
    end
end

return commandObj
