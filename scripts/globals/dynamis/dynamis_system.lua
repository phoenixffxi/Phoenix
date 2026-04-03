-----------------------------------
--    Dynamis 75 Era Module      --
-----------------------------------
-----------------------------------
--    Module Required Scripts    --
-----------------------------------
require('scripts/globals/battlefield')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- Debug control
xi.dynamis.DEBUG     = true
xi.dynamis.tickDebug = false

xi.dynamis.debugPrint = function(message)
    if xi.dynamis.DEBUG then
        print('[DynaDebug] ' .. message)
    end
end

local function debugTickPrint(message)
    if xi.dynamis.tickDebug then
        print('[DynaTickDebug] ' .. message)
    end
end

-----------------------------------
--   Global Dynamis Variables    --
-----------------------------------
-- Come back when I do tav
-- local function getDynamisTavWinParam(player)
--     local zmComplete = player:getCurrentMission(xi.mission.log_id.ZILART) >= xi.mission.id.zilart.AWAKENING
--     local copComplete = player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.DAWN
--     local anComplete = player:hasCompletedQuest(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.APOCALYPSE_NIGH)

--     if anComplete then
--         -- AN requires ZM and CoP
--         return 3
--     elseif zmComplete then
--         if copComplete then
--             -- ZM and CoP
--             return 2
--         end

--         -- ZM only
--         return 1
--     end

--     -- Not ZM complete
--     return 0
-- end

-----------------------------------
-- onZoneTick Dynamis Functions  --
-----------------------------------
xi.dynamis.handleDynamis = function(zone)
    if zone:getLocalVar('debugMode') == 1 then
        return
    end

    local zoneID = zone:getID()

    -- Lets make the vars look pretty so I can see what we are actually setting
    -- Could change it back to what it is with zone:getLocalVar calls but this is easier to read for my eyes
    local varSessionID     = string.format('[DYNA]SessionID_%s', zoneID)
    local varExpiration    = string.format('[DYNA]ExpirationTime_%s', zoneID)
    local varWarn10        = string.format('[DYNA]Given10MinuteWarning_%s', zoneID)
    local varWarn3         = string.format('[DYNA]Given3MinuteWarning_%s', zoneID)
    local varWarn1         = string.format('[DYNA]Given1MinuteWarning_%s', zoneID)
    local varZoneCooldown  = string.format('[DYNA]ZoneCooldown_%s', zoneID)
    local varCleanup       = string.format('[DYNA]CleanupScript_%s', zoneID)

    -- Now that we can see what vars we have lets get everything we need
    -- Token and timepoints
    local zoneSessionID     = zone:getLocalVar(varSessionID)
    local zoneExpiration    = GetServerVariable(varExpiration)
    local zoneTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneExpiration)

    -- Warning vars
    local zoneWarn10 = zone:getLocalVar(varWarn10)
    local zoneWarn3  = zone:getLocalVar(varWarn3)
    local zoneWarn1  = zone:getLocalVar(varWarn1)

    -- Player counts and timers
    local playersInZone = zone:getPlayers()
    local currentTime   = GetSystemTime()

    local parentZone = GetZone(xi.dynamis.dynaIDLookup[zoneID].entryZone)
    if not parentZone then
        xi.dynamis.debugPrint(' Parent Zone is nil | xi.dynamis.handleDynamis ABORTED')
        return
    end

    local zoneCooldownEnter  = parentZone:getLocalVar(varZoneCooldown)
    local cleanupScript      = parentZone:getLocalVar(varCleanup)

    for _, player in pairs(playersInZone) do
        -- LEAVING THIS HERE FOR TESTING ON WHY IT BREAKS THE GAME
        -- if player:getLocalVar('Requires_Initial_Update') == 0 then
        --     -- Need to update every players hourglass
        --     xi.dynamis.updatePlayerHourglass(player, zoneSessionID)

        --     -- Check for dreamland SJ restriction and apply if necessary
        --     xi.dynamis.applyEntryRestrictions(player, zoneID)

        --     player:setLocalVar('Requires_Initial_Update', 1) -- Don't run again for this player
        -- end

        -- Hourglass validity checks (GMs can stay until expiry)
        -- Check every 5 seconds to prevent excessive checks
        -- Check for valid hourglass to prevent players from just holding onto an old hourglass and re-entering after time expires
        if
            not xi.dynamis.isGM(player) and
            player:getLocalVar('[DYNA]NextHourglassCheck') < currentTime
        then
            if xi.dynamis.verifyHasHourglass(player, zoneSessionID, zoneExpiration) then
                player:setLocalVar('[DYNA]NextHourglassCheck', currentTime + 5)
            end
        end
    end

    -- 10, 3 and 1 minute warnings
    if cleanupScript == 0 then
        if
            zoneWarn1 == 0 and
            zoneTimeRemaining < 80
        then
            xi.dynamis.dynamisTimeWarning(zone, zoneExpiration)
            zone:setLocalVar(varWarn1, 1) -- Don't give another warning
        elseif
            zoneWarn3 == 0 and
            zoneTimeRemaining < 200
        then
            xi.dynamis.dynamisTimeWarning(zone, zoneExpiration)
            zone:setLocalVar(varWarn3, 1) -- Don't give another warning
        elseif
            zoneWarn10 == 0 and
            zoneTimeRemaining < 620
        then
            xi.dynamis.dynamisTimeWarning(zone, zoneExpiration)
            zone:setLocalVar(varWarn10, 1) -- Don't give another warning
        end
    end

    -- Time has finally expired - goodbye players o7
    if zoneTimeRemaining <= 1 then
        xi.dynamis.ejectAllPlayers(zone)

        -- After ejecting everyone run the cleanup it it hasnt ran already
        if
            cleanupScript == 0 and
            zoneCooldownEnter == 0
        then
            parentZone:setLocalVar(varZoneCooldown, currentTime + 90)
            xi.dynamis.cleanupDynamis(zone)
        end
    end

    -- xi.dynamis.debugPrint(#playersInZone .. ' players in zone | NoPlayerTimer: ' .. tostring(noPlayerTimer) .. ' | CleanupScript: ' .. tostring(cleanupScript) .. ' | zoneCooldownEnter: ' .. tostring(zoneCooldownEnter))

    xi.dynamis.handleNoPlayers(playersInZone, cleanupScript, zoneCooldownEnter, zone, parentZone, zoneSessionID)
end

xi.dynamis.handleNoPlayers = function(playersInZone, cleanupScript, zoneCooldownEnter, zone, parentZone, zoneSessionID)
    local zoneID = zone:getID()
    local currentTime = GetSystemTime()

    -- Build variable name strings
    local varNoPlayerTimer = string.format('[DYNA]NoPlayerTimer_%s', zoneID)
    local varExpiration    = string.format('[DYNA]ExpirationTime_%s', zoneID)
    local varZoneCooldown  = string.format('[DYNA]ZoneCooldown_%s', zoneID)

    -- Get current state
    local noPlayerTimer = zone:getLocalVar(varNoPlayerTimer)
    local zoneExpiration = GetServerVariable(varExpiration)
    debugTickPrint('Current Players in Zone: ' .. tostring(#playersInZone))
    debugTickPrint('No Player Timer: ' .. tostring(noPlayerTimer))
    debugTickPrint('Zone Expiration: ' .. tostring(zoneExpiration))
    debugTickPrint('Zone Cooldown Enter: ' .. tostring(zoneCooldownEnter))
    debugTickPrint('Time Remaining: ' .. tostring(xi.dynamis.getDynaTimeRemaining(zoneExpiration) / 60))
    -- Start no-player timer if zone is empty
    if
        #playersInZone == 0 and             -- No players in the zone
        noPlayerTimer == 0 and              -- The timer for no players in the zone is not set
        cleanupScript == 0 and              -- Cleanup has not run yet
        zoneExpiration > currentTime + 600  -- Zone has more than 10 minutes left
    then
        -- 5sec less than 10min to prevent zone idle before cleanup fires
        zone:setLocalVar(varNoPlayerTimer, currentTime + 595)
        -- Sync with zone expiration to handle valid hourglass edge cases
        SetServerVariable(varExpiration, currentTime + 595)
        -- We need to update all player hourglasses to match the new 10 min expiration
        -- TODO update the hourglass for the last person to exit zone
        xi.dynamis.updatePlayerHourglassForAll(zone, zoneSessionID)
    -- Clear timer if players return with sufficient time remaining (10+ minutes)
    elseif
        #playersInZone > 0 and
        noPlayerTimer ~= 0 and
        zoneExpiration >= currentTime + 600
    then
        zone:setLocalVar(varNoPlayerTimer, 0)
    end

    -- Run cleanup when no-player timer expires
    if
        noPlayerTimer > 0 and
        noPlayerTimer <= currentTime and
        cleanupScript == 0 and
        zoneCooldownEnter == 0
    then
        parentZone:setLocalVar(varZoneCooldown, currentTime + 90)
        xi.dynamis.cleanupDynamis(zone)
    end

    debugTickPrint('-----------------------------------')
end

-----------------------------------
--   Dynamis Start Functions    --
-----------------------------------
xi.dynamis.onNewDynamis = function(player, mode)
    local playerZoneID = player:getZoneID()
    local zoneID = 0

    if mode == 1 and player:isInDynamis() then
        zoneID = playerZoneID
    else
        zoneID = xi.dynamis.entryInfoEra[playerZoneID].dynaZone
    end

    local zone = GetZone(zoneID)

    if not zone then
        xi.dynamis.debugPrint('Zone is nil | xi.dynamis.onNewDynamis')
        return
    end

    local dynaInfo = xi.dynamis.dynaInfoEra[zoneID]

    -- 1. Spawn initial wave of mobs
    xi.dynamis.spawnWave(xi.dynamis.wave[zoneID][1])
    xi.dynamis.debugPrint(string.format('Spawning Initial wave for zoneID: %d', zoneID))

    -- 2. Hide winQM until allowed to spawn
    local winQM = GetNPCByID(dynaInfo.winQM)
    if winQM then
        winQM:setStatus(xi.status.DISAPPEAR)
    end

    -- 3. Specific functions for certain zones
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        -- xi.dynamis.dynamisTavnaziaOnNewDynamis(player, zone)
    elseif zoneID == xi.zone.DYNAMIS_BUBURIMU or zoneID == xi.zone.DYNAMIS_QUFIM then
        local locations = dynaInfo.sjRestrictionLocation
        if locations and #locations > 0 then
            local pick = locations[math.random(#locations)]
            local sjNPC = GetNPCByID(dynaInfo.sjRestrictionNPC)
            if sjNPC then
                sjNPC:setPos(pick[1], pick[2], pick[3])
                sjNPC:setStatus(xi.status.NORMAL)
                xi.dynamis.debugPrint(string.format('Spawning SJ Restriction NPC for zoneID: %d at coordinates (%.2f, %.2f, %.2f)', zoneID, pick[1], pick[2], pick[3]))
            end
        end
    end

    -- Mode for GMs/Testing
    if mode == 1 then
        zone:setLocalVar('debugMode', 1)
    end
end

-----------------------------------
--    Dynamis Zone Functions    --
-----------------------------------
-- Cleanup Done
-- Re-wrote the function to be used for everything not just GMs
xi.dynamis.addMinutesToDynamis = function(zone, minutes)
    local zoneID          = zone:getID()
    local varSessionID    = string.format('[DYNA]SessionID_%s', zoneID)
    local varExpiration   = string.format('[DYNA]ExpirationTime_%s', zoneID)
    local varWarn10       = string.format('[DYNA]Given10MinuteWarning_%s', zoneID)
    local varWarn3        = string.format('[DYNA]Given3MinuteWarning_%s', zoneID)
    local varWarn1        = string.format('[DYNA]Given1MinuteWarning_%s', zoneID)

    -- Now that we can see what vars we have lets get everything we need
    -- Token and timepoints
    local zoneSessionID     = zone:getLocalVar(varSessionID)
    local zoneExpiration    = GetServerVariable(varExpiration)-- Determine previous expiration time.
    local zoneTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneExpiration)
    local newZoneExpiration = zoneExpiration + (60 * minutes) -- Add more time to increase previous expiration point.

    -- Update Time Remaining
    SetServerVariable(varExpiration, newZoneExpiration)

    -- Player counts and timers
    local playersInZone = zone:getPlayers()

    -- Update Hourglasses for Players
    for _, player in pairs(playersInZone) do
        player:messageSpecial(zones[zoneID].text.DYNAMIS_TIME_EXTEND, minutes)
        xi.dynamis.updatePlayerHourglass(player, zoneSessionID)
    end

    -- Handle Time Limit Warnings in case the message was already given to players
    if zoneTimeRemaining > 620 then -- Checks if time remaining > 11 minutes.
        zone:setLocalVar(varWarn10, 0) -- Resets var if time remaining greater than threshold.
    end

    if zoneTimeRemaining > 200 then -- Checks if time remaining > 4 minutes.
        zone:setLocalVar(varWarn3, 0) -- Resets var if time remaining greater than threshold.
    end

    if zoneTimeRemaining > 80 then -- Checks if time remaining > 2 minutes.
        zone:setLocalVar(varWarn1, 0) -- Resets var if time remaining greater than threshold.
    end
end

-- Cleanup Done
xi.dynamis.addTimeToDynamis = function(zone, mob)
    local zoneID = zone:getID()
    local mobID  = mob:getID()

    -- xi.dynamis.debugPrint(('Dynamis Time Extension Check | ZoneID: %d | MobID: %d'):format(zoneID, mobID))

    local extTable = xi.dynamis.timeExtension[zoneID]
    local minutes  = extTable[mobID]
    -- xi.dynamis.debugPrint('printing minutes ' .. tostring(minutes))

    if minutes then
        xi.dynamis.debugPrint(('TIME EXTENSION FOUND: %d minutes for mobID: %d'):format(minutes, mobID))
        xi.dynamis.addMinutesToDynamis(zone, minutes)
    end

    -- Time extension trigger for the ??? in Dynamis - Tavnazia
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        xi.dynamis.addMinutesToDynamis(zone, 30)
    end
end

-- Cleanup Done
xi.dynamis.getDynaTimeRemaining = function(zoneExpiration)
    local timeRemaining = (zoneExpiration - GetSystemTime()) -- Returns difference.
    -- xi.dynamis.debugPrint('Dynamis Time Remaining Check | Expiration: ' .. tostring(zoneExpiration) .. ' | CurrentTime: ' .. tostring(GetSystemTime()) .. ' | Result: ' .. tostring(timeRemaining))
    if timeRemaining < 0 then
        return 0
    else
        return timeRemaining
    end
end

-- Cleanup Done
xi.dynamis.cleanupDynamis = function(zone)
    local zoneID = zone:getID()
    local parentZone = GetZone(xi.dynamis.dynaIDLookup[zoneID].entryZone)

    if parentZone == nil then
        xi.dynamis.debugPrint('Parent Zone is nil | xi.dynamis.cleanupDynamis')
        return
    end

    SetServerVariable(string.format('[DYNA]#OfRegisteredPlayers_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]SessionID_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]ExpirationTime_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]OriginalRegistrant_%s', zoneID), 0)
    parentZone:setLocalVar(string.format('[DYNA]CleanupScript_%s', zoneID), 1)
    zone:resetLocalVars()
    xi.dynamis.ejectAllPlayers(zone) -- Remove Players (This is precautionary but not necessary.)
    xi.dynamis.despawnAll(zone) -- Despawns all mobs / npcs in zone
end

xi.dynamis.despawnAll = function(zone)
    xi.dynamis.debugPrint('despawnAll zoneID: ' .. tostring(zone:getID()))

    local mobsInZone = zone:getMobs()
    local npcsInZone = zone:getNPCs()
    for _, mobEntity in pairs(mobsInZone) do
        DespawnMob(mobEntity:getID()) -- Despawn
    end

    for _, npcEntity in pairs(npcsInZone) do
        npcEntity:setStatus(xi.status.DISAPPEAR)
        xi.dynamis.debugPrint('despawnAll DISAPPEAR NPC ID: ' .. tostring(npcEntity:getID()))
    end
end

xi.dynamis.dynamisTimeWarning = function(zone, zoneExpiration)
    local zoneID        = zone:getID()
    local playersInZone = zone:getPlayers()
    local timeRemaining = math.floor((xi.dynamis.getDynaTimeRemaining(zoneExpiration) / 60))
    local ID            = zones[zoneID]
    for _, player in pairs(playersInZone) do
        if timeRemaining <= 2 then
            player:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_1, timeRemaining, 1) -- Send 1 minute warning.
        else
            player:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_2, timeRemaining, 1) -- Send [3/10] minutes warning.
        end
    end
end

-----------------------------------
--  Dynamis Player Functions    --
-----------------------------------
-- Cleanup Done
xi.dynamis.registerDynamis = function(player)
    local zoneID      = player:getZoneID()
    local dynaInfo    = xi.dynamis.entryInfoEra[zoneID]
    local dynaZone    = GetZone(dynaInfo.dynaZone)
    local parentZone  = GetZone(zoneID)
    local currentTime = GetSystemTime()
    -- Validate zones exist
    if not dynaZone then
        xi.dynamis.debugPrint('dynaZone is nil | xi.dynamis.registerDynamis')
        return
    end

    if not parentZone then
        xi.dynamis.debugPrint('Parent Zone is nil | xi.dynamis.registerDynamis')
        return
    end

    -- Calculate expiration time (default 60 minutes, 15 minutes for Tavnazia)
    local expirationTime = currentTime + xi.dynamis.settings.DEFAULT_TIME_LIMIT
    if zoneID == xi.zone.TAVNAZIAN_SAFEHOLD then
        expirationTime = currentTime + xi.dynamis.settings.TAVNAZIAN_TIME_LIMIT
    end

    -- Always register first
    -- luacheck: ignore 113
    local instanceID   = RegisterDynamisInstance(zoneID, player:getID())
    local dynamisToken = dynaInfo.dynaZone + expirationTime

    xi.dynamis.debugPrint('registerDynamis - zoneID: ' .. tostring(zoneID))
    xi.dynamis.debugPrint('registerDynamis - dynaZone: ' .. tostring(dynaInfo.dynaZone))
    xi.dynamis.debugPrint('registerDynamis - instanceID from RegisterDynamisInstance: ' .. tostring(instanceID))

    -- Define the vars so we can read what is going on again
    -- As said previously possibly move these to a lua var instead
    local dynazoneID        = dynaInfo.dynaZone
    local varSessionID      = string.format('[DYNA]SessionID_%s', dynazoneID)
    local varExpiration     = string.format('[DYNA]ExpirationTime_%s', dynazoneID)
    local varOrigRegistrant = string.format('[DYNA]OriginalRegistrant_%s', dynazoneID)
    local varInstanceID     = string.format('[DYNA]InstanceID_%s', dynazoneID)
    local varCleanupScript  = string.format('[DYNA]CleanupScript_%s', dynazoneID)

    -- Set server vars
    SetServerVariable(varSessionID, dynamisToken)
    SetServerVariable(varExpiration, expirationTime)
    SetServerVariable(varOrigRegistrant, player:getID())
    SetServerVariable(varInstanceID, instanceID)

    -- Need cleanup script to 0
    parentZone:setLocalVar(varCleanupScript, 0)

    -- Start the zone baby
    xi.dynamis.onNewDynamis(player, 0) -- 0 for normal, 1 for debug gm only

    -- Set zone vars?
    -- I am not sure why we need the same local vars AND server vars???
    -- TODO cleanup this later if possible
    dynaZone:setLocalVar(varSessionID, dynamisToken)
    dynaZone:setLocalVar(varInstanceID, instanceID)

    -- Player stuff
    -- yes dynamisToken is correct - the old script was setting then getting then setting the var? Idk
    local playerZone = player:getZone()
    playerZone:setLocalVar(varSessionID, dynamisToken)
    playerZone:setLocalVar(varInstanceID, instanceID)
end

-- Cleanup Done
xi.dynamis.registerPlayer = function(player)
    local zoneID     = player:getZoneID()
    local dynaInfo   = xi.dynamis.entryInfoEra[zoneID]
    local instanceID = GetServerVariable(string.format('[DYNA]InstanceID_%s', dynaInfo.dynaZone))

    xi.dynamis.debugPrint('zoneID: ' .. tostring(zoneID))
    xi.dynamis.debugPrint('dynaZone: ' .. tostring(dynaInfo.dynaZone))
    xi.dynamis.debugPrint('instanceID from server var: ' .. tostring(instanceID))

    local dynamisToken = GetServerVariable(string.format('[DYNA]SessionID_%s', dynaInfo.dynaZone))

    local playerRegKey = math.random(1, 100) -- Obfuscate player registration value with dynamis token + player's zone ID info. (Ensures
    player:setCharVar(string.format('[DYNA]PlayerRegisterKey_%s', (dynaInfo.dynaZone)), playerRegKey) -- Obfuscate player registration value with dynamis token + player's zone ID info. (Ensures the player is counted as new registrant if token is different.)
    player:setCharVar(string.format('[DYNA]PlayerRegistered_%s', (dynaInfo.dynaZone)), (dynamisToken + playerRegKey))
    player:setCharVar(string.format('[DYNA]PlayerZoneToken_%s', dynaInfo.dynaZone), dynamisToken) -- Give the player a copy of the token value.

    xi.dynamis.recordLockout(player)

    -- luacheck: ignore 113
    xi.dynamis.debugPrint('Final instanceID: ' .. tostring(instanceID))
    xi.dynamis.debugPrint('playerId: ' .. tostring(player:getID()))
    AddDynamisParticipant(instanceID, player:getID())
end

-- TODO Cleanup
xi.dynamis.ejectPlayer = function(player, forceEject)
    local zoneID = player:getZoneID()
    if forceEject == nil then
        forceEject = false
    end

    if player:getCurrentRegion() == xi.region.DYNAMIS then
        if player:getLocalVar('Received_Eject_Warning') ~= 1 then
            player:delStatusEffectSilent(xi.effect.BATTLEFIELD)
            if not forceEject then
                player:timer(2000, function(playerArg)
                    playerArg:messageSpecial(xi.dynamis.getZoneMessageID('NO_LONGER_HAVE_CLEARANCE', zoneID), 0, 30) -- Wait 1 second, send no clearance message.
                end)

                player:setLocalVar('Received_Eject_Warning', 1)
                player:timer(30000, function(playerArgTwo)
                    playerArgTwo:setCharVar(string.format('[DYNA]EjectPlayer_%s', zoneID), -1) -- Reset player's eject timer.
                    playerArgTwo:disengage() -- Force disengage.
                    playerArgTwo:timer(2000, function(playerArgThree)
                        playerArgThree:startCutscene(100) -- Wait 2 seconds then play exit CS.
                    end)
                end)
            else
                player:timer(2000, function(playerArgFour)
                    playerArgFour:messageSpecial(xi.dynamis.getZoneMessageID('NO_LONGER_HAVE_CLEARANCE', zoneID), 0, 0)
                    playerArgFour:setCharVar(string.format('[DYNA]EjectPlayer_%s', zoneID), -1) -- Reset player's eject timer.
                    playerArgFour:disengage() -- Force disengage.
                    playerArgFour:timer(4000, function(playerArgFive)
                        playerArgFive:startCutscene(100) -- Wait 2 seconds then play exit CS.
                    end)
                end) -- Wait 1 second, send no clearance message.
            end
        end
    end
end

xi.dynamis.ejectAllPlayers = function(zone)
    local playersInZone = zone:getPlayers()
    for _, player in pairs(playersInZone) do
        xi.dynamis.ejectPlayer(player) -- Runs the ejectPlayer function per player.
    end
end

-- Reset all player-related dynamis charvars
xi.dynamis.resetPlayerVars = function(playerEntity, dynaZone)
    -- Entry and reservation vars
    playerEntity:setCharVar('DynaReservationStart', 0)

    -- Lockout
    playerEntity:setCharVar('[DYNA]lockout', 0)

    -- Zone-specific registration vars
    if dynaZone and dynaZone ~= nil then
        playerEntity:setCharVar(string.format('[DYNA]PlayerRegistered_%s', dynaZone), 0)
        playerEntity:setCharVar(string.format('[DYNA]PlayerRegisterKey_%s', dynaZone), 0)
    end
end

-- Dynamis NPC triggers
xi.dynamis.sjQMOnTrigger = function(npc)
    local zone          = npc:getZone()
    local playersInZone = zone:getPlayers()
    for _, playerEntity in pairs(playersInZone) do
        if  playerEntity:hasStatusEffect(xi.effect.SJ_RESTRICTION) then -- Does player have SJ restriction?
            playerEntity:delStatusEffect(xi.effect.SJ_RESTRICTION) -- Remove SJ restriction
        end
    end

    zone:setLocalVar('SJUnlocked', 1)
end

-- TODO Cleanup
xi.dynamis.timeExtensionOnTrigger = function(player, npc)
    local zone = player:getZone()
    xi.dynamis.addTimeToDynamis(zone, nil) -- Add Time
    for _, member in pairs(zone:getPlayers()) do
        member:changeMusic(0, 227) -- 0 Background Music (Sunbreeze Music)
        member:changeMusic(1, 227) -- 1 Background Music (Sunbreeze Music)
        member:changeMusic(2, 227) -- 2 Combat Music (Sunbreeze Music)
        member:changeMusic(3, 227) -- 3 Combat Music (Sunbreeze Music)
    end

    local firstFloorQM  = xi.dynamis.dynaInfoEra[xi.zone.DYNAMIS_TAVNAZIA].timeExtensions[1]
    local secondFloorQM = xi.dynamis.dynaInfoEra[xi.zone.DYNAMIS_TAVNAZIA].timeExtensions[2]
    if
        npc:getID() == firstFloorQM and
        zone:getLocalVar('Wave_2_Spawned') == 0 -- Check if the wave has spawned in case DISAPPEAR doesnt work
    then
        zone:setLocalVar('qmOne', 1)
        xi.dynamis.spawnWave(zone, xi.zone.DYNAMIS_TAVNAZIA, 2) -- Spawn the second wave
    elseif
        npc:getID() == secondFloorQM and
        zone:getLocalVar('Wave_3_Spawned') == 0 -- Check if the wave has spawned in case DISAPPEAR doesnt work
    then
        zone:setLocalVar('qmTwo', 1)
        xi.dynamis.spawnWave(zone, xi.zone.DYNAMIS_TAVNAZIA, 3) -- Spawn the third wave
    end

    npc:setStatus(xi.status.DISAPPEAR)
end

-----------------------------------
-- Dynamis Player/Zone Functions --
-----------------------------------
-- TODO Cleanup/Delete
xi.dynamis.zoneOnZoneInitializeEra = function(zone)
    local zoneID = zone:getID()
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        -- xi.dynamis.dynamisTavnaziaOnZoneInitializeEra(zone)
    end
end

-- TODO Cleanup/Delete
xi.dynamis.onTriggerAreaEnter = function(player, triggerArea)
    local zoneID = player:getZoneID()
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        xi.dynamis.dynamisTavnaziaOnTriggerAreaEnter(player, triggerArea)
    end
end

-- TODO Cleanup -- currently being used
xi.dynamis.zoneOnZoneInEra = function(player, prevZone)
    local zoneID         = player:getZoneID()
    local zoneExpiration = GetServerVariable(string.format('[DYNA]ExpirationTime_%s', zoneID))
    local info           = xi.dynamis.dynaInfoEra[zoneID]
    local ID             = zones[zoneID]

    -- usually happens when zoning in with !zone command
    -- If player is in void, move player to entry.
    if
        player:getXPos() == 0 and
        player:getYPos() == 0 and
        player:getZPos() == 0
    then
        player:setPos(unpack(info.entryPos))
    end

    -- Send message letting player know how long they have.
    player:timer(5000, function(playerArg)
        local timepoint = xi.dynamis.getDynaTimeRemaining(zoneExpiration)
        playerArg:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_2, math.floor(utils.clamp(timepoint, 0, timepoint) / 60), 1)
    end)

    -- Update hourglass if player has one
    if player:hasItem(xi.item.PERPETUAL_HOURGLASS) then
        local zoneSessionID = GetServerVariable(string.format('[DYNA]SessionID_%s', zoneID))
        xi.dynamis.updatePlayerHourglass(player, zoneSessionID)
    end

    -- Check for dreamland SJ restriction and apply if necessary
    xi.dynamis.applyEntryRestrictions(player, zoneID)
    return -1
end

-----------------------------------
--   Dynamis Zone Validation     --
-----------------------------------
local dynamisZones =
{
    [xi.zone.DYNAMIS_BASTOK]     = true,
    [xi.zone.DYNAMIS_WINDURST]   = true,
    [xi.zone.DYNAMIS_SAN_DORIA]  = true,
    [xi.zone.DYNAMIS_JEUNO]      = true,
    [xi.zone.DYNAMIS_BEAUCEDINE] = true,
    [xi.zone.DYNAMIS_XARCABARD]  = true,
    [xi.zone.DYNAMIS_VALKURM]    = true,
    [xi.zone.DYNAMIS_QUFIM]      = true,
    [xi.zone.DYNAMIS_BUBURIMU]   = true,
    [xi.zone.DYNAMIS_TAVNAZIA]   = true,
}

xi.dynamis.isValidDynamisZone = function(zoneID)
    return dynamisZones[zoneID] == true
end
