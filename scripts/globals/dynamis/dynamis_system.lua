-----------------------------------
--    Dynamis 75 Era Module      --
-----------------------------------
-----------------------------------
--    Module Required Scripts    --
-----------------------------------
require('scripts/mixins/job_special')
require('scripts/globals/battlefield')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/pathfind')
require('modules/module_utils')
-----------------------------------
--   Module Affected Scripts     --
-----------------------------------
require('scripts/globals/dynamis')
require('scripts/globals/dynamis/dynamis_mobs_sandy')
require('scripts/globals/dynamis/dynamis_mobs_bastok')
require('scripts/globals/dynamis/dynamis_mobs_windurst')
-----------------------------------
local m = Module:new('dynamis_entry_info')

xi = xi or {}
xi.dynamis = xi.dynamis or {}

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
-- Cleanup Done
-- TODO remove cyclomatic complexity
-- luacheck: ignore 561
xi.dynamis.handleDynamis = function(zone)
    local zoneID = zone:getID()

    -- Lets make the vars look pretty so I can see what we are actually setting
    -- Could change it back to what it is with zone:getLocalVar calls but this is easier to read for my eyes
    local varToken        = string.format('[DYNA]Token_%s', zoneID)
    local varTimepoint    = string.format('[DYNA]Timepoint_%s', zoneID)
    local varWarn10       = string.format('[DYNA]Given10MinuteWarning_%s', zoneID)
    local varWarn3        = string.format('[DYNA]Given3MinuteWarning_%s', zoneID)
    local varWarn1        = string.format('[DYNA]Given1MinuteWarning_%s', zoneID)
    local varNoPlayer     = string.format('[DYNA]NoPlayerTimer_%s', zoneID)
    local varZoneCooldown = string.format('[DYNA]ZoneCooldown_%s', zoneID)
    local varCleanup      = string.format('[DYNA]CleanupScript_%s', zoneID)

    -- Now that we can see what vars we have lets get everything we need
    -- Token and timepoints
    local zoneDynamistoken  = zone:getLocalVar(varToken)
    local zoneTimepoint     = GetServerVariable(varTimepoint)
    local zoneTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)

    -- Warning vars
    local zoneWarn10 = zone:getLocalVar(varWarn10)
    local zoneWarn3  = zone:getLocalVar(varWarn3)
    local zoneWarn1  = zone:getLocalVar(varWarn1)

    -- Player counts and timers
    local playersInZone = zone:getPlayers()
    local noPlayerTimer = zone:getLocalVar(varNoPlayer)
    local currentTime   = GetSystemTime()

    local parentZone = GetZone(xi.dynamis.dynaIDLookup[zoneID].entryZone)
    if not parentZone then
        print('[DEBUG] Parent Zone is nil | xi.dynamis.handleDynamis ABORTED')
        return
    end

    local zoneCooldown  = parentZone:getLocalVar(varZoneCooldown)
    local cleanupScript = parentZone:getLocalVar(varCleanup)

    -- Unfortuntealy I don't know a better way to check for everything once per
    -- player on entry other than looping through here
    -- This should only run ONCE on every player when they enter the zone
    -- Start iterating through the player list
    for _, player in pairs(playersInZone) do
        if player:getLocalVar('Requires_Initial_Update') == 0 then
            -- Need to update every players hourglass
            xi.dynamis.updatePlayerHourglass(player, zoneDynamistoken)

            -- Check for dreamland SJ restriction and apply if necessary
            xi.dynamis.applyEntryRestrictions(player, zoneID)

            player:setLocalVar('Requires_Initial_Update', 1) -- Don't run again for this player
        end

        -- Hourglass validity checks (GMs can stay until expiry)
        if
            not xi.dynamis.isGM(player) and
            player:getLocalVar('[DYNA]NextHourglassCheck') < currentTime
        then
            if xi.dynamis.verifyHoldsValidHourglass(player, zoneDynamistoken, zoneTimepoint) then
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
            xi.dynamis.dynamisTimeWarning(zone, zoneTimepoint)
            zone:setLocalVar(varWarn1, 1) -- Don't give another warning
        elseif
            zoneWarn3 == 0 and
            zoneTimeRemaining < 200
        then
            xi.dynamis.dynamisTimeWarning(zone, zoneTimepoint)
            zone:setLocalVar(varWarn3, 1) -- Don't give another warning
        elseif
            zoneWarn10 == 0 and
            zoneTimeRemaining < 620
        then
            xi.dynamis.dynamisTimeWarning(zone, zoneTimepoint)
            zone:setLocalVar(varWarn10, 1) -- Don't give another warning
        end
    end

    -- Time has finally expired - goodbye players o7
    if zoneTimeRemaining <= 1 then
        xi.dynamis.ejectAllPlayers(zone)

        -- After ejecting everyone run the cleanup it it hasnt ran already
        if
            cleanupScript == 0 and
            zoneCooldown == 0
        then
            parentZone:setLocalVar(varZoneCooldown, currentTime + 90)
            xi.dynamis.cleanupDynamis(zone)
        end
    end

    -- print(#playersInZone .. ' players in zone | NoPlayerTimer: ' .. tostring(noPlayerTimer) .. ' | CleanupScript: ' .. tostring(cleanupScript) .. ' | ZoneCooldown: ' .. tostring(zoneCooldown))

     -- Handle empty zone (start no-player timer if not already started, 5 min timer)
     -- Clear no-player timer if players re-enter
     -- If timer expires and no players, run cleanup
    -- Handle no players in zone, no timers on players present, no cleanup script ran
    if
        #playersInZone == 0 and
        noPlayerTimer == 0 and
        cleanupScript == 0
    then
        -- NOTE: We do 5sec less than 5min to prevent zone idle from happening before cleanup fired
        zone:setLocalVar(varNoPlayer, currentTime + 295)
    elseif
        #playersInZone > 0 and
        noPlayerTimer ~= 0
    then
        zone:setLocalVar(varNoPlayer, 0)
    end

    -- Cleanup after no-player timer expires, cleanup has not run, no cooldown timer set
    if
        noPlayerTimer > 0 and
        noPlayerTimer <= currentTime and
        cleanupScript == 0 and
        zoneCooldown == 0
    then
        parentZone:setLocalVar(varZoneCooldown, currentTime + 90)
        xi.dynamis.cleanupDynamis(zone)
    end
end

-----------------------------------
--   Dynamis Start Functions    --
-----------------------------------
-- Cleanup Done
xi.dynamis.onNewDynamis = function(player)
    local playerZoneID = player:getZoneID()
    local zoneID = xi.dynamis.dynaInfoEra[playerZoneID].dynaZone
    local zone = GetZone(zoneID)

    if not zone then
        print('[DEBUG] Zone is nil | xi.dynamis.onNewDynamis')
        return
    end

    local dynaInfo = xi.dynamis.dynaInfoEra[zoneID]

    -- I need to make sure we need wave vars anymore with having specific IDS
    -- Ensure all Wave Vars are set to 0 before we spawn anything.
    -- for waveNumber, _ in pairs(xi.dynamis.mobList[zoneID].waveDefeatRequirements) do
    --     zone:setLocalVar(string.format('Wave_%i_Spawned', waveNumber), 0)
    -- end

    -- Spawn Wave 1
    xi.dynamis.spawnWave(xi.dynamis.wave[zoneID][1])
    print(string.format('[DYNAMIS] Spawning Wave 1 mobs for zoneID: %d', zoneID))
    -- Check for locations, if you got some lets pick one
    local locations = dynaInfo.sjRestrictionLocation
    if locations then
        local pick = locations[math.random(#locations)]
        local sjNPC = GetNPCByID(dynaInfo.sjRestrictionNPC)
        if sjNPC then
            sjNPC:setPos(pick[1], pick[2], pick[3])
            sjNPC:setStatus(xi.status.NORMAL)
        end
    end

    -- Hide winQM until allowed to spawn
    local winQM = GetNPCByID(dynaInfo.winQM)
    if winQM then
        winQM:setStatus(xi.status.DISAPPEAR)
    end

    -- Might redo all of the tav stuff. For now just leave it here.
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        xi.dynamis.dynamisTavnaziaOnNewDynamis(player, zone)
    end
end

-----------------------------------
--    Dynamis Zone Functions    --
-----------------------------------
-- Cleanup Done
-- Re-wrote the function to be used for everything not just GMs
xi.dynamis.addMinutesToDynamis = function(zone, minutes)
    local zoneID          = zone:getID()
    local varToken        = string.format('[DYNA]Token_%s', zoneID)
    local varTimepoint    = string.format('[DYNA]Timepoint_%s', zoneID)
    local varWarn10       = string.format('[DYNA]Given10MinuteWarning_%s', zoneID)
    local varWarn3        = string.format('[DYNA]Given3MinuteWarning_%s', zoneID)
    local varWarn1        = string.format('[DYNA]Given1MinuteWarning_%s', zoneID)

    -- Now that we can see what vars we have lets get everything we need
    -- Token and timepoints
    local zoneDynamisToken  = zone:getLocalVar(varToken)
    local zoneTimepoint     = GetServerVariable(varTimepoint)-- Determine previous expiration time.
    local zoneTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)
    local newZoneTimepoint  = zoneTimepoint + (60 * minutes) -- Add more time to increase previous expiration point.

    -- Update Time Remaining
    SetServerVariable(string.format('[DYNA]Timepoint_%s', zoneID), newZoneTimepoint)

    -- Player counts and timers
    local playersInZone = zone:getPlayers()

    -- Update Hourglasses for Players
    for _, player in pairs(playersInZone) do
        player:messageSpecial(zones[zoneID].text.DYNAMIS_TIME_EXTEND, minutes)
        xi.dynamis.updatePlayerHourglass(player, zoneDynamisToken)
    end

    -- Handle Time Limit Warnings
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

    -- print(('Dynamis Time Extension Check | ZoneID: %d | MobID: %d'):format(zoneID, mobID))

    local extTable = xi.dynamis.timeExtension[zoneID]
    local minutes  = extTable[mobID]
    -- print('printing minutes ' .. tostring(minutes))

    if minutes then
        print(('TIME EXTENSION FOUND: %d minutes for mobID: %d'):format(minutes, mobID))
        xi.dynamis.addMinutesToDynamis(zone, minutes)
    end

    -- Time extension trigger for the ??? in Dynamis - Tavnazia
    if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
        xi.dynamis.addMinutesToDynamis(zone, 30)
    end
end

-- Cleanup Done
xi.dynamis.getDynaTimeRemaining = function(zoneTimePoint)
    local zoneTimeResult = (zoneTimePoint - GetSystemTime()) -- Returns difference.
    -- print('Dynamis Time Remaining Check | TimePoint: ' .. tostring(zoneTimePoint) .. ' | CurrentTime: ' .. tostring(GetSystemTime()) .. ' | Result: ' .. tostring(zoneTimeResult))
    if zoneTimeResult < 0 then
        return 0
    else
        return zoneTimeResult
    end
end

-- Cleanup Done
xi.dynamis.cleanupDynamis = function(zone)
    local zoneID = zone:getID()
    local parentZone = GetZone(xi.dynamis.dynaIDLookup[zoneID].entryZone)

    if parentZone == nil then
        print('[DEBUG] Parent Zone is nil | xi.dynamis.cleanupDynamis')
        return
    end

    SetServerVariable(string.format('[DYNA]RegisteredPlayers_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]Token_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]Timepoint_%s', zoneID), 0)
    SetServerVariable(string.format('[DYNA]OriginalRegistrant_%s', zoneID), 0)
    parentZone:setLocalVar(string.format('[DYNA]CleanupScript_%s', zoneID), 1)
    zone:resetLocalVars()
    xi.dynamis.ejectAllPlayers(zone) -- Remove Players (This is precautionary but not necessary.)
    xi.dynamis.despawnAll(zone) -- Despawns all mobs / npcs in zone
end

xi.dynamis.despawnAll = function(zone)
    print('[DYNADEBUG] despawnAll zoneID: ' .. tostring(zone:getID()))

    local mobsInZone = zone:getMobs()
    local npcsInZone = zone:getNPCs()
    for _, mobEntity in pairs(mobsInZone) do
        DespawnMob(mobEntity:getID()) -- Despawn
    end

    for _, npcEntity in pairs(npcsInZone) do
        npcEntity:setStatus(xi.status.DISAPPEAR)
        print('[DYNADEBUG] despawnAll DISAPPEAR NPC ID: ' .. tostring(npcEntity:getID()))
    end
end

-- Fine
xi.dynamis.dynamisTimeWarning = function(zone, zoneTimepoint)
    local zoneID        = zone:getID()
    local playersInZone = zone:getPlayers()
    local timeRemaining = math.floor((xi.dynamis.getDynaTimeRemaining(zoneTimepoint) / 60)) -- Get time remaining, convert to minutes, floor value.
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
    local dynaInfo    = xi.dynamis.dynaInfoEra[zoneID]
    local dynaZone    = GetZone(dynaInfo.dynaZone)
    local parentZone  = GetZone(zoneID)
    local currentTime = GetSystemTime()
    -- Validate zones exist
    if not dynaZone then
        print('[DEBUG] dynaZone is nil | xi.dynamis.registerDynamis')
        return
    end

    if not parentZone then
        print('[DEBUG] Parent Zone is nil | xi.dynamis.registerDynamis')
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

    print('DEBUG: registerDynamis - zoneID: ' .. tostring(zoneID))
    print('DEBUG: registerDynamis - dynaZone: ' .. tostring(dynaInfo.dynaZone))
    print('DEBUG: registerDynamis - instanceID from RegisterDynamisInstance: ' .. tostring(instanceID))

    -- Define the vars so we can read what is going on again
    -- As said previously possibly move these to a lua var instead
    local dynazoneID        = dynaInfo.dynaZone
    local varToken          = string.format('[DYNA]Token_%s', dynazoneID)
    local varTimepoint      = string.format('[DYNA]Timepoint_%s', dynazoneID)
    local varRegTimepoint   = string.format('[DYNA]RegTimepoint_%s', dynazoneID)
    local varOrigRegistrant = string.format('[DYNA]OriginalRegistrant_%s', dynazoneID)
    local varInstanceID     = string.format('[DYNA]InstanceID_%s', dynazoneID)
    local varCleanupScript  = string.format('[DYNA]CleanupScript_%s', dynazoneID)
    local varCurrentWave    = string.format('[DYNA]CurrentWave_%s', zoneID)

    -- Set server vars
    SetServerVariable(varToken, dynamisToken)
    SetServerVariable(varTimepoint, expirationTime)
    SetServerVariable(varRegTimepoint, currentTime)
    SetServerVariable(varOrigRegistrant, player:getID())
    SetServerVariable(varInstanceID, instanceID)

    -- Need cleanup script to 0
    parentZone:setLocalVar(varCleanupScript, 0)

    -- Start the zone baby
    xi.dynamis.onNewDynamis(player)

    -- Set zone vars?
    -- I am not sure why we need the same local vars AND server vars???
    -- TODO cleanup this later if possible
    dynaZone:setLocalVar(varToken, dynamisToken)
    dynaZone:setLocalVar(varInstanceID, instanceID)
    dynaZone:setLocalVar(varCurrentWave, 1)

    -- Player stuff
    -- yes dynamisToken is correct - the old script was setting then getting then setting the var? Idk
    local playerZone = player:getZone()
    playerZone:setLocalVar(varToken, dynamisToken)
    playerZone:setLocalVar(varInstanceID, instanceID)
end

-- Cleanup Done
xi.dynamis.registerPlayer = function(player)
    local zoneID     = player:getZoneID()
    local dynaInfo   = xi.dynamis.dynaInfoEra[zoneID]
    local instanceID = GetServerVariable(string.format('[DYNA]InstanceID_%s', dynaInfo.dynaZone))

    print('DEBUG: zoneID: ' .. tostring(zoneID))
    print('DEBUG: dynaZone: ' .. tostring(dynaInfo.dynaZone))
    print('DEBUG: instanceID from server var: ' .. tostring(instanceID))

    local dynamisToken = GetServerVariable(string.format('[DYNA]Token_%s', dynaInfo.dynaZone))
    local regTimepoint = GetServerVariable(string.format('[DYNA]RegTimepoint_%s', dynaInfo.dynaZone))

    local playerRegKey = math.random(1, 100) -- Obfuscate player registration value with dynamis token + player's zone ID info. (Ensures
    player:setCharVar(string.format('[DYNA]PlayerRegisterKey_%s', (dynaInfo.dynaZone)), playerRegKey) -- Obfuscate player registration value with dynamis token + player's zone ID info. (Ensures the player is counted as new registrant if token is different.)
    player:setCharVar(string.format('[DYNA]PlayerRegistered_%s', (dynaInfo.dynaZone)), (dynamisToken + playerRegKey))
    player:setCharVar(string.format('[DYNA]PlayerZoneToken_%s', dynaInfo.dynaZone), dynamisToken) -- Give the player a copy of the token value.
    player:setCharVar(string.format('[DYNA]PlayerRegisterTime_%s', dynaInfo.dynaZone), regTimepoint)

    xi.dynamis.recordLockout(player)

    -- luacheck: ignore 113
    print('DEBUG: Final instanceID: ' .. tostring(instanceID))
    print('DEBUG: playerId: ' .. tostring(player:getID()))
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
                    playerArgTwo:setCharVar(string.format('[DYNA]EjectPlayer_%s', xi.dynamis.dynaInfoEra[zoneID].dynaZone), -1) -- Reset player's eject timer.
                    playerArgTwo:disengage() -- Force disengage.
                    playerArgTwo:timer(2000, function(playerArgThree)
                        playerArgThree:startCutscene(100) -- Wait 2 seconds then play exit CS.
                    end)
                end)
            else
                player:timer(2000, function(playerArgFour)
                    playerArgFour:messageSpecial(xi.dynamis.getZoneMessageID('NO_LONGER_HAVE_CLEARANCE', zoneID), 0, 0)
                    playerArgFour:setCharVar(string.format('[DYNA]EjectPlayer_%s', xi.dynamis.dynaInfoEra[zoneID].dynaZone), -1) -- Reset player's eject timer.
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

xi.dynamis.verifyHoldsValidHourglass = function(player, zoneDynamistoken, zoneTimepoint)
    local zoneID = player:getZoneID()

    -- luacheck: ignore 113
    if player:validateHourglass(zoneDynamistoken) then
        return true
    else
        if xi.dynamis.isGM(player) then
            player:setCharVar(string.format('[DYNA]EjectPlayer_%s', zoneID), zoneTimepoint) -- Player is a GM and can bypass the hourglass requirement.
        elseif player:getCharVar(string.format('[DYNA]PlayerZoneToken_%s', player:getZoneID())) ~= zoneDynamistoken then
            xi.dynamis.ejectPlayer(player, true)
        else
            xi.dynamis.ejectPlayer(player)
        end

        return false
    end
end

-- Dynamis NPC triggers
-- TODO Cleanup
xi.dynamis.sjQMOnTrigger = function(npc)
    local zone = npc:getZone()
    local playersInZone = zone:getPlayers()
    for _, playerEntity in pairs(playersInZone) do
        if  playerEntity:hasStatusEffect(xi.effect.SJ_RESTRICTION) then -- Does player have SJ restriction?
            playerEntity:delStatusEffect(xi.effect.SJ_RESTRICTION) -- Remove SJ restriction
        end
    end

    zone:setLocalVar('SJUnlock', 1)
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

-- TODO Cleanup
xi.dynamis.qmOnTriggerEra = function(player, npc) -- Override standard qmOnTrigger()
    local zoneId = npc:getZoneID()

    -- Win KIs
    if not player:hasKeyItem(xi.dynamis.dynaInfoEra[zoneId].winKI) then
        npcUtil.giveKeyItem(player, xi.dynamis.dynaInfoEra[zoneId].winKI)
    end

    if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
        player:addTitle(xi.dynamis.dynaInfoEra[zoneId].qmTitle)
    end
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
    local zoneID = player:getZoneID()
    local zoneTimepoint = GetServerVariable(string.format('[DYNA]Timepoint_%s', zoneID))
    local info = xi.dynamis.dynaInfoEra[zoneID]
    local ID = zones[zoneID]

    -- usually happens when zoning in with !zone command
    -- If player is in void, move player to entry.
    if
        player:getXPos() == 0 and
        player:getYPos() == 0 and
        player:getZPos() == 0
    then
        player:setPos(info.entryPos[1], info.entryPos[2], info.entryPos[3], info.entryPos[4])
    end

    player:timer(5000, function(playerArg)
        local timepoint = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)
        playerArg:addStatusEffectEx(xi.effect.BATTLEFIELD, 0, 1, 0, 0, true)
        playerArg:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_2, math.floor(utils.clamp(timepoint, 0, timepoint) / 60), 1) -- Send message letting player know how long they have.
    end)

    return -1
end

xi.dynamis.zoneOnZoneOut = function(player)
    if player:hasStatusEffect(xi.effect.BATTLEFIELD) then
        player:delStatusEffectSilent(xi.effect.BATTLEFIELD)
    end
end

return m
