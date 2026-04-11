
-----------------------------------
--   Dynamis Eject Functions
-----------------------------------
local ejectWarningTimer = 2000

-- Send eject warning message with delay
xi.dynamis.sendEjectWarning = function(player, zoneId, delayMs, isForceEject)
    player:timer(delayMs, function(playerArg)
        local param = (isForceEject) and 0 or 30
        playerArg:messageSpecial(xi.dynamis.getZoneMessageID('NO_LONGER_HAVE_CLEARANCE', zoneId), 0, param)
    end)
end

-- Eject actions (charvar reset, disengage, cutscene)
xi.dynamis.performEjectActions = function(player, zoneId, cutsceneDelayMs)
    player:setCharVar(string.format('[DYNA]EjectPlayer_%s', zoneId), -1)
    player:disengage()
    player:timer(cutsceneDelayMs, function(playerArg)
        playerArg:startCutscene(100)
    end)
end

-- Execute non-force eject with grace period
xi.dynamis.executeGracePeriodEject = function(player, zoneId)
    local ejectGracePeriodMs = 30000 -- 30 seconds
    xi.dynamis.sendEjectWarning(player, zoneId, ejectWarningTimer, false)
    player:setLocalVar('Received_Eject_Warning', 1)
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

    if player:getCurrentRegion() ~= xi.region.DYNAMIS then
        return
    end

    if player:getLocalVar('Received_Eject_Warning') == 1 then
        return
    end

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
    print('Ejecting all players from Dynamis zone: ' .. tostring(zone:getID()))
    local playersInZone = zone:getPlayers()
    for _, player in pairs(playersInZone) do
        xi.dynamis.ejectPlayer(player) -- Runs the ejectPlayer function per player.
    end
end
