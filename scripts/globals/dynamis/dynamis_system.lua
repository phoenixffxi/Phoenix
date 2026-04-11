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
-- onZoneTick Dynamis Functions  --
-----------------------------------
-- Track active Dynamis zones with their eventsQueues
local dynaTimeVars = {}
-- Process queued events (warnings) for a Dynamis zone
local function onDynamisZoneTick(zone)
    local zoneId = zone:getID()
    if not dynaTimeVars[zoneId] or not dynaTimeVars[zoneId].eventsQueue then
        return
    end

    local currentTime = GetSystemTime()
    for timestamp, event in pairs(dynaTimeVars[zoneId].eventsQueue) do
        if currentTime >= timestamp then
            debugTickPrint(string.format('Executing Dynamis event at %d for zone %d', timestamp, zoneId))
            event()
            dynaTimeVars[zoneId].eventsQueue[timestamp] = nil
        end
    end
end

local function handleNoPlayers(playersInZone, cleanupScript, zoneCooldownEnter, zone, parentZone)
    local zoneId = zone:getID()
    local currentTime = GetSystemTime()

    -- Build variable name strings
    local varNoPlayerTimer = string.format('[DYNA]NoPlayerTimer_%s', zoneId)
    local varExpiration    = string.format('[DYNA]ExpirationTime_%s', zoneId)
    local varZoneCooldown  = string.format('[DYNA]ZoneCooldown_%s', zoneId)

    -- Get current state
    local noPlayerTimer = zone:getLocalVar(varNoPlayerTimer)
    local zoneExpiration = GetServerVariable(varExpiration)
    debugTickPrint(string.format('------------xi.dynamis.handleNoPlayers------------'))

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
        xi.dynamis.updatePlayerHourglassForAll(zone)
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
        debugTickPrint('Cleaning Dynamis -> handleNoPlayers')
        xi.dynamis.cleanupDynamis(zone)
    end

    debugTickPrint('-----------------------------------')
end

xi.dynamis.dynamisTick = function(zone)
    if zone:getLocalVar('debugMode') == 1 then
        return
    end

    local zoneId = zone:getID()

    -- Lets make the vars look pretty so I can see what we are actually setting
    -- Could change it back to what it is with zone:getLocalVar calls but this is easier to read for my eyes
    local varStartTime     = string.format('[DYNA]StartTime_%s', zoneId)
    local varExpiration    = string.format('[DYNA]ExpirationTime_%s', zoneId)
    local varZoneCooldown  = string.format('[DYNA]ZoneCooldown_%s', zoneId)
    local varCleanup       = string.format('[DYNA]CleanupScript_%s', zoneId)

    -- Now that we can see what vars we have lets get everything we need
    -- Start time and expiration
    local zoneStartTime     = GetServerVariable(varStartTime)
    local zoneExpiration    = GetServerVariable(varExpiration)
    debugTickPrint('Fetching server variables for Dynamis zone ' .. zoneId)
    debugTickPrint('Start Time Variable: ' .. zoneStartTime)
    debugTickPrint('Expiration Variable: ' .. zoneExpiration)

    local zoneTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneExpiration)
    debugTickPrint('Zone Time Remaining: ' .. zoneTimeRemaining)

    -- Player counts and timers
    local playersInZone = zone:getPlayers()
    local currentTime   = GetSystemTime()

    local parentZone = GetZone(xi.dynamis.dynaIDLookup[zoneId].entryZone)
    if not parentZone then
        xi.dynamis.debugPrint(' Parent Zone is nil | xi.dynamis.dynamisTick ABORTED')
        return
    end

    local zoneCooldownEnter  = parentZone:getLocalVar(varZoneCooldown)
    local cleanupScript      = parentZone:getLocalVar(varCleanup)

    debugTickPrint('Zone Cooldown Enter: ' .. tostring(zoneCooldownEnter))
    debugTickPrint('Cleanup Script: ' .. tostring(cleanupScript))
    for _, player in pairs(playersInZone) do
        -- LEAVING THIS HERE FOR TESTING ON WHY IT BREAKS THE GAME
        -- if player:getLocalVar('Requires_Initial_Update') == 0 then
        --     -- Need to update every players hourglass
        --     xi.dynamis.updatePlayerHourglass(player)

        --     -- Check for dreamland SJ restriction and apply if necessary
        --     xi.dynamis.applyEntryRestrictions(player, zoneId)

        --     player:setLocalVar('Requires_Initial_Update', 1) -- Don't run again for this player
        -- end

        -- TODO: Move all this logic to
        -- Hourglass validity checks (GMs can stay until expiry)
        -- Check every 10 seconds to prevent excessive checks
        -- Check for valid hourglass to prevent players from just holding onto an old hourglass and re-entering after time expires
        if
            not xi.dynamis.isGM(player) and
            player:getLocalVar('[DYNA]NextHourglassCheck') < currentTime
        then
            xi.dynamis.debugPrint(string.format('Zone Tick - About to call hasHourglass for player %s with zoneStartTime: %s, zoneId: %s, zoneExpiration: %s', player:getName(), zoneStartTime, zoneId, zoneExpiration))
            if xi.dynamis.hasHourglass(player, zoneStartTime, zoneId, zoneExpiration) then
                player:setLocalVar('[DYNA]NextHourglassCheck', currentTime + 10)
            end
        end
    end

    -- Process queued events (warnings, etc)
    onDynamisZoneTick(zone)

    -- Time has finally expired - goodbye players o7
    if zoneTimeRemaining <= 1 then
        debugTickPrint('Ejecting All Players -> Time Expired')
        xi.dynamis.ejectAllPlayers(zone)

        -- After ejecting everyone run the cleanup it it hasnt ran already
        if
            cleanupScript == 0 and
            zoneCooldownEnter == 0
        then
            parentZone:setLocalVar(varZoneCooldown, currentTime + 90)
            debugTickPrint('Cleaning Dynamis -> Time Expired')
            xi.dynamis.cleanupDynamis(zone)
        end
    end

    handleNoPlayers(playersInZone, cleanupScript, zoneCooldownEnter, zone, parentZone)
end

-----------------------------------
--   Dynamis Start Functions    --
-----------------------------------
xi.dynamis.onNewDynamis = function(player, mode)
    local playerZoneID = player:getZoneID()
    local zoneId = 0

    if mode == 1 or player:isInDynamis() then
        zoneId = playerZoneID
    else
        zoneId = xi.dynamis.entryInfoEra[playerZoneID].dynaZone
    end

    local zone = GetZone(zoneId)

    if not zone then
        xi.dynamis.debugPrint('Zone is nil | xi.dynamis.onNewDynamis')
        return
    end

    local dynaInfo = xi.dynamis.dynaInfoEra[zoneId]

    -- 1. Spawn initial wave of mobs
    xi.dynamis.spawnWave(xi.dynamis.wave[zoneId][1])
    xi.dynamis.debugPrint(string.format('-----------------xi.dynamis.onNewDynamis-----------------'))
    xi.dynamis.debugPrint(string.format('Spawning Initial wave for zoneId: %d', zoneId))

    -- 2. Hide winQM until allowed to spawn
    local winQM = GetNPCByID(dynaInfo.winQM)
    if winQM then
        winQM:setStatus(xi.status.DISAPPEAR)
    end

    -- 3. Specific functions for certain zones
    if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
        -- Setting random spawn for nightmare worm and antlion
        xi.dynamis.onNewDynamisTav(player, zone)
    elseif zoneId == xi.zone.DYNAMIS_BUBURIMU or zoneId == xi.zone.DYNAMIS_QUFIM then
        local locations = dynaInfo.sjRestrictionLocation
        if locations and #locations > 0 then
            local pick = locations[math.random(#locations)]
            local sjNPC = GetNPCByID(dynaInfo.sjRestrictionNPC)
            if sjNPC then
                sjNPC:setPos(pick[1], pick[2], pick[3])
                sjNPC:setStatus(xi.status.NORMAL)
                xi.dynamis.debugPrint(string.format('Spawning SJ Restriction NPC for zoneId: %d at coordinates (%.2f, %.2f, %.2f)', zoneId, pick[1], pick[2], pick[3]))
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
xi.dynamis.addMinutesToDynamis = function(zone, minutes)
    local zoneId          = zone:getID()
    local varExpiration   = string.format('[DYNA]ExpirationTime_%s', zoneId)

    -- Now that we can see what vars we have lets get everything we need
    -- Expiration times
    local zoneExpiration    = GetServerVariable(varExpiration)
    local newZoneExpiration = zoneExpiration + (60 * minutes) -- Add more time to increase previous expiration point.

    -- Update Time Remaining
    SetServerVariable(varExpiration, newZoneExpiration)

    -- Player counts and timers
    local playersInZone = zone:getPlayers()

    -- Update Hourglasses for Players
    for _, player in pairs(playersInZone) do
        player:messageSpecial(zones[zoneId].text.DYNAMIS_TIME_EXTEND, minutes)
        xi.dynamis.updatePlayerHourglass(player)
    end

    -- Recalculate and re-queue warning events with new expiration time
    if dynaTimeVars[zoneId] then
        -- Clear old event queue
        dynaTimeVars[zoneId].eventsQueue =
        {
            [newZoneExpiration - 620] = function()  -- 10 minute warning
                xi.dynamis.dynamisTimeWarning(zone, newZoneExpiration)
            end,

            [newZoneExpiration - 200] = function()  -- 3 minute warning
                xi.dynamis.dynamisTimeWarning(zone, newZoneExpiration)
            end,

            [newZoneExpiration - 80] = function()   -- 1 minute warning
                xi.dynamis.dynamisTimeWarning(zone, newZoneExpiration)
            end,
        }
        debugTickPrint(string.format('Recalculated warnings for zone %d with new expiration: %d', zoneId, newZoneExpiration))
    end
end

xi.dynamis.addTimeToDynamis = function(zone, mob)
    local zoneId = zone:getID()
    local mobID  = mob:getID()

    -- xi.dynamis.debugPrint(('Dynamis Time Extension Check | ZoneID: %d | MobID: %d'):format(zoneId, mobID))

    local extTable = xi.dynamis.timeExtension[zoneId]
    local minutes  = extTable[mobID]
    -- xi.dynamis.debugPrint('printing minutes ' .. tostring(minutes))

    if minutes then
        xi.dynamis.debugPrint('----------xi.dynamis.addTimeToDynamis---------')
        xi.dynamis.debugPrint(('TIME EXTENSION FOUND: %d minutes for mobID: %d'):format(minutes, mobID))
        xi.dynamis.addMinutesToDynamis(zone, minutes)
    end
end

xi.dynamis.getDynaTimeRemaining = function(zoneExpiration)
    local timeRemaining = (zoneExpiration - GetSystemTime()) -- Returns difference.
    -- xi.dynamis.debugPrint('Dynamis Time Remaining Check | Expiration: ' .. tostring(zoneExpiration) .. ' | CurrentTime: ' .. tostring(GetSystemTime()) .. ' | Result: ' .. tostring(timeRemaining))
    if timeRemaining < 0 then
        return 0
    else
        return timeRemaining
    end
end

xi.dynamis.cleanupDynamis = function(zone)
    local zoneId = zone:getID()
    local parentZone = GetZone(xi.dynamis.dynaIDLookup[zoneId].entryZone)

    xi.dynamis.debugPrint('----------Cleaning up Dynamis zone: ' .. tostring(zone:getID()))
    xi.dynamis.debugPrint('Cleaning up Dynamis zone: ' .. tostring(zoneId))

    if parentZone == nil then
        xi.dynamis.debugPrint('Parent Zone is nil | xi.dynamis.cleanupDynamis')
        return
    end

    -- Reset server vars
    SetServerVariable(string.format('[DYNA]#OfRegisteredPlayers_%s', zoneId), 0)
    SetServerVariable(string.format('[DYNA]StartTime_%s', zoneId), 0)
    SetServerVariable(string.format('[DYNA]ExpirationTime_%s', zoneId), 0)
    SetServerVariable(string.format('[DYNA]OriginalRegistrant_%s', zoneId), 0)

    -- Reset local vars
    zone:resetLocalVars()
    parentZone:setLocalVar(string.format('[DYNA]CleanupScript_%s', zoneId), 1)

    -- Reset associated player vars
    local instanceId = GetServerVariable(string.format('[DYNA]InstanceID_%s', zoneId))
    xi.dynamis.clearParticipants(instanceId) -- Clear participants for this instance

    -- Clean up dynaTimeVars for this zone
    dynaTimeVars[zoneId] = nil

    xi.dynamis.ejectAllPlayers(zone) -- Remove Players (This is precautionary but not necessary.)
    xi.dynamis.despawnAll(zone) -- Despawns all mobs / npcs in zone
end

xi.dynamis.despawnAll = function(zone)
    xi.dynamis.debugPrint('despawnAll zoneId: ' .. tostring(zone:getID()))

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
    local zoneId        = zone:getID()
    local playersInZone = zone:getPlayers()
    local timeRemaining = math.floor((xi.dynamis.getDynaTimeRemaining(zoneExpiration) / 60))
    local ID            = zones[zoneId]
    for _, player in pairs(playersInZone) do
        if timeRemaining <= 2 then
            player:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_1, timeRemaining, 1) -- Send 1 minute warning.
        else
            player:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_2, timeRemaining, 1) -- Send [3/10] minutes warning.
        end
    end
end

xi.dynamis.zoneOnZoneInEra = function(player, prevZone)
    local zoneId         = player:getZoneID()
    local zoneExpiration = GetServerVariable(string.format('[DYNA]ExpirationTime_%s', zoneId))
    local info           = xi.dynamis.dynaInfoEra[zoneId]
    local ID             = zones[zoneId]

    xi.dynamis.debugPrint(string.format('------------xi.dynamis.zoneOnZoneInEra------------'))
    -- usually happens when zoning in with !zone command
    -- If player is in void, move player to entry.
    if
        player:getXPos() == 0 and
        player:getYPos() == 0 and
        player:getZPos() == 0
    then
        player:setPos(unpack(info.entryPos))
    end

    local expirationTime = xi.dynamis.getDynaTimeRemaining(zoneExpiration)
    xi.dynamis.debugPrint(string.format('expirationTime calculation: %s | zoneExpiration: %s | currentTime: %s', tostring(expirationTime), tostring(zoneExpiration), tostring(GetSystemTime())))
    -- Send message letting player know how long they have.
    player:timer(5000, function(playerArg)
        playerArg:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_2, math.floor(utils.clamp(expirationTime, 0, expirationTime) / 60), 1)
    end)

    -- Update hourglass if player has one - will only update endTime if it was extended (zoneExpiration > current endTime)
    xi.dynamis.debugPrint(string.format('Updating hourglass for player'))
    xi.dynamis.updatePlayerHourglass(player)

    -- Check for dreamland SJ restriction and apply if necessary
    xi.dynamis.applyEntryRestrictions(player, zoneId)
    return -1
end

-----------------------------------
--  Dynamis Player Functions    --
-----------------------------------
xi.dynamis.registerDynamis = function(player, startTime, endTime)
    local zoneId      = player:getZoneID()
    local dynaInfo    = xi.dynamis.entryInfoEra[zoneId]
    local dynaZone    = GetZone(dynaInfo.dynaZone)
    local parentZone  = GetZone(zoneId)
    -- Validate zones exist
    if not dynaZone then
        xi.dynamis.debugPrint('dynaZone is nil | xi.dynamis.registerDynamis')
        return
    end

    if not parentZone then
        xi.dynamis.debugPrint('Parent Zone is nil | xi.dynamis.registerDynamis')
        return
    end

    -- Always register first
    local instanceID = xi.dynamis.registerDynamisInstance(dynaInfo.dynaZone, player:getID(), player:getName())

    xi.dynamis.debugPrint(string.format('------------xi.dynamis.registerDynamis------------'))
    xi.dynamis.debugPrint('StartTime: ' .. tostring(startTime) .. '| EndTime: ' .. tostring(endTime))

    -- Define the vars so we can read what is going on again
    -- As said previously possibly move these to a lua var instead
    local dynazoneID        = dynaInfo.dynaZone
    local varOrigRegistrant = string.format('[DYNA]OriginalRegistrant_%s', dynazoneID)
    local varInstanceID     = string.format('[DYNA]InstanceID_%s', dynazoneID)
    local varCleanupScript  = string.format('[DYNA]CleanupScript_%s', dynazoneID)

    -- Set server vars
    SetServerVariable(varOrigRegistrant, player:getID())
    SetServerVariable(varInstanceID, instanceID)

    -- Need cleanup script to 0
    parentZone:setLocalVar(varCleanupScript, 0)

    -- Initialize dynaTimeVars for this zone with eventsQueue
    dynaTimeVars[dynazoneID] = {
        eventsQueue = {
            [endTime - 620] = function()  -- 10 minute warning
                xi.dynamis.dynamisTimeWarning(dynaZone, endTime)
            end,

            [endTime - 200] = function()  -- 3 minute warning
                xi.dynamis.dynamisTimeWarning(dynaZone, endTime)
            end,

            [endTime - 80] = function()   -- 1 minute warning
                xi.dynamis.dynamisTimeWarning(dynaZone, endTime)
            end,
        }
    }

    -- Start the zone baby
    xi.dynamis.onNewDynamis(player, 0) -- 0 for normal, 1 for debug gm only

    -- Set zone vars
    dynaZone:setLocalVar(varInstanceID, instanceID)

    -- Player stuff
    local playerZone = player:getZone()
    playerZone:setLocalVar(varInstanceID, instanceID)
end

xi.dynamis.registerPlayer = function(player)
    local zoneId     = player:getZoneID()
    local dynaInfo   = xi.dynamis.entryInfoEra[zoneId]
    local instanceId = GetServerVariable(string.format('[DYNA]InstanceID_%s', dynaInfo.dynaZone))

    xi.dynamis.debugPrint(string.format('------------xi.dynamis.registerPlayer------------'))
    xi.dynamis.debugPrint('zoneId: ' .. tostring(zoneId) .. ' | dynaZone: ' .. tostring(dynaInfo.dynaZone) .. ' | instanceID from server var: ' .. tostring(instanceId))

    -- Mark player as registered in this dynamis session
    xi.dynamis.addParticipant(instanceId, player:getID(), player:getName())

    -- Set lockout
    xi.dynamis.recordLockout(player)
end

-- Reset all player-related dynamis charvars
-- GM Command Only
xi.dynamis.resetPlayerVars = function(playerEntity, dynaZone)
    -- Reset player lockout
    playerEntity:setCharVar('[DYNA]lockout', 0)

    -- Remove player from participants list for this instance
    xi.dynamis.removeParticipant(playerEntity:getID())
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

xi.dynamis.isValidDynamisZone = function(zoneId)
    return dynamisZones[zoneId] == true
end
