
-----------------------------------
--   Dynamis Eject Functions
-----------------------------------
local ejectWarningTimer      = 2000
local ejectWarningVar        = 'Received_Eject_Warning'
local ejectCutsceneQueuedVar = '[DYNA]EjectCutsceneQueued'

xi.dynamis.resetEjectState = function(player)
    player:setLocalVar(ejectWarningVar, 0)
    player:setLocalVar(ejectCutsceneQueuedVar, 0)
end

-- Send eject warning message with delay
xi.dynamis.sendEjectWarning = function(player, zoneId, delayMs, isForceEject)
    player:timer(delayMs, function(playerArg)
        local param = (isForceEject) and 0 or 30
        playerArg:messageSpecial(xi.dynamis.getZoneMessageID('NO_LONGER_HAVE_CLEARANCE', zoneId), 0, param)
    end)
end

-- Eject actions (charvar reset, disengage, cutscene)
xi.dynamis.performEjectActions = function(player, zoneId, cutsceneDelayMs)
    if player:getLocalVar(ejectCutsceneQueuedVar) == 1 then
        return
    end

    player:setLocalVar(ejectCutsceneQueuedVar, 1)
    player:setCharVar(string.format('[DYNA]EjectPlayer_%s', zoneId), -1)
    player:disengage()
    player:timer(cutsceneDelayMs, function(playerArg)
        if playerArg:getCurrentRegion() == xi.region.DYNAMIS then
            playerArg:startCutscene(100)
        end
    end)
end

-- Execute non-force eject with grace period
xi.dynamis.executeGracePeriodEject = function(player, zoneId)
    local ejectGracePeriodMs = 30000 -- 30 seconds
    xi.dynamis.sendEjectWarning(player, zoneId, ejectWarningTimer, false)
    player:timer(ejectGracePeriodMs, function(playerArgTwo)
        xi.dynamis.performEjectActions(playerArgTwo, zoneId, ejectWarningTimer)
    end)
end

-- Eject a player from Dynamis with optional force eject
xi.dynamis.ejectPlayer = function(player, forceEject)
    xi.dynamis.debugPrint('Ejecting player: ' .. tostring(player:getName()) .. ' | forceEject: ' .. tostring(forceEject))
    local zoneId = player:getZoneID()
    if forceEject == nil then
        forceEject = false
    end

    -- Only run in dynamis please
    if player:getCurrentRegion() ~= xi.region.DYNAMIS then
        return
    end

    -- Do not run this twice if they already got the warning
    if player:getLocalVar(ejectWarningVar) == 1 then
        return
    end

    player:setLocalVar(ejectWarningVar, 1)

    if forceEject then
        xi.dynamis.sendEjectWarning(player, zoneId, ejectWarningTimer, true)
        player:timer(ejectWarningTimer, function(playerArg)
            xi.dynamis.performEjectActions(playerArg, zoneId, 4000) -- 4 Second delay for force eject
        end)
    else
        xi.dynamis.executeGracePeriodEject(player, zoneId)
    end
end

xi.dynamis.ejectAllPlayers = function(zone)
    xi.dynamis.debugPrint('Ejecting all players from Dynamis zone: ' .. tostring(zone:getID()))
    local playersInZone = zone:getPlayers()
    for _, player in pairs(playersInZone) do
        xi.dynamis.ejectPlayer(player) -- Runs the ejectPlayer function per player.
    end
end
