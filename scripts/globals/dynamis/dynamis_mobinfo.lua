-----------------------------------
-- Old Dynamis
-- This entire system is using old dat lists from 2008 in order to apply the spawning and mechanics correctly
-- If new DATS are used this system will break and cause crashes
-----------------------------------
require('scripts/globals/battlefield')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}
xi.dynamis.mobType = xi.dynamis.mobType or
{
    NORMAL    = 1,
    STATUE    = 2,
    BOSS      = 3,
    NIGHTMARE = 4,
    MASTER    = 5,
}

-- Debug control
xi.mobinfo = xi.mobinfo or {}
xi.mobinfo.DEBUG = true

local function debugPrint(message)
    if xi.mobinfo.DEBUG then
        print('[DynaDebug] ' .. message)
    end
end

local timerTargetLocalVar = 'dynamisTimerTargetID'

local function setTimerTarget(mob, target)
    local targetID = 0

    if target then
        targetID = target:getID()
    end

    mob:setLocalVar(timerTargetLocalVar, targetID)
end

local function getTimerTarget(mob)
    local targetID = mob:getLocalVar(timerTargetLocalVar)
    if targetID == 0 then
        return nil
    end

    local target = GetPlayerByID(targetID)
    if target then
        if target:getZoneID() == mob:getZoneID() then
            return target
        end

        return nil
    end

    return GetEntityByID(targetID, mob:getInstance(), true)
end

local function isStationaryMob(mob)
    local zoneId         = mob:getZoneID()
    local stationaryMobs = xi.dynamis.stationary and xi.dynamis.stationary[zoneId]
    if not stationaryMobs then
        return false
    end

    local mobId = mob:getID()
    for _, stationaryMobId in pairs(stationaryMobs) do
        if stationaryMobId == mobId then
            return true
        end
    end

    return false
end

-- ---------------------
-- General Info functions
-- ---------------------
-- Must be called in onMobInitialize so that setStatRank runs before CalculateMobStats on first spawn.
xi.dynamis.onSharedInitialize = function(mob)
    mob:setStatRank(xi.stat.STR, xi.statRank.A)
    mob:setStatRank(xi.stat.DEX, xi.statRank.A)
    mob:setStatRank(xi.stat.VIT, xi.statRank.A)
    mob:setStatRank(xi.stat.AGI, xi.statRank.A)
    mob:setStatRank(xi.stat.INT, xi.statRank.A)
    mob:setStatRank(xi.stat.MND, xi.statRank.A)
    mob:setStatRank(xi.stat.CHR, xi.statRank.A)
    mob:setStatRank(xi.stat.DEF, xi.statRank.A)

    mob:addMod(xi.mod.STR, 10)
    mob:addMod(xi.mod.DEX, 10)
    mob:addMod(xi.mod.VIT, 10)
    mob:addMod(xi.mod.AGI, 10)
    mob:addMod(xi.mod.INT, 10)
    mob:addMod(xi.mod.MND, 10)
    mob:addMod(xi.mod.CHR, 10)

    mob:setMobMod(xi.mobMod.GIL_BONUS, -100)
    mob:setMobMod(xi.mobMod.EXP_BONUS, -100)
end

xi.dynamis.generalInfo = function(mob, modelSize)
    mob:setTrueDetection(true)
    mob:setSpawnAnimation(1) -- This is the cool looking spwan animation
    mob:setMobMod(xi.mobMod.CHARMABLE, 0)
    mob:setMobMod(xi.mobMod.CHECK_AS_NM, 1)
    mob:setMobMod(xi.mobMod.NO_DESPAWN, 1)
    mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.NON_EXCLUSIVE)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
    mob:setRoamFlags(xi.roamFlag.SCRIPTED)

    mob:setMobMod(xi.mobMod.DETECTION, bit.bor(xi.detects.SIGHT, xi.detects.HEARING))
    mob:setMobMod(xi.mobMod.SIGHT_RANGE, 12)
    mob:setMobMod(xi.mobMod.SOUND_RANGE, 4)

    mob:setModelSize(modelSize)
end

-- ---------------------------
-- Shared Event Handlers
-- ---------------------------
xi.dynamis.onSharedEngage = function(mob, target)
    local mobID   = mob:getID()
    local mobName = mob:getName()

    debugPrint('Mob engaged, checking for spawns...')
    debugPrint('Engaged mob ID: ' .. mobID .. ' (' .. mobName .. ') isSpawned: ' .. tostring(mob:isSpawned()))

    -- Stop the spawning if the mob is re-engaged after a wipe
    if mob:getLocalVar('engageCheck') == 1 then
        return
    end

    mob:setLocalVar('engageCheck', 1)
    local zoneId = mob:getZoneID()

    mob:setMobMod(xi.mobMod.MAGIC_DELAY, math.random(5, 15)) -- Random magic delay to make the casts delayed

    local lineSpawnConfig = xi.dynamis.lineSpawns and xi.dynamis.lineSpawns[zoneId] and xi.dynamis.lineSpawns[zoneId][mobID]
    local firstAdd        = GetMobByID(mobID + 1)
    local firstAddSpawn   = firstAdd and firstAdd:getSpawnPos()
    local defaultInside   =
        firstAddSpawn and
        firstAddSpawn.x == 1.000 and
        firstAddSpawn.y == 1.000 and
        firstAddSpawn.z == 1.000

    -- Default inside statues use a short stun; explicit line spawns keep the normal stun.
    if lineSpawnConfig or not defaultInside then
        mob:stun(3000) -- Stun for 3 seconds
    else
        mob:stun(1000) -- Stun for 1 second
    end

    -- Check for mobs on aggro conditions
    xi.dynamis.spawnAggroStatues(mob, target)

    -- If the mob has spawned from the master mob then do not check for more spawns
    if mob:getLocalVar('spawnedFromMaster') == 1 then
        debugPrint('I am an add, not spawning more mobs')
        return
    end

    local zoneSpawnTable = xi.dynamis.spawnTable and xi.dynamis.spawnTable[zoneId]
    local spawnEntry     = zoneSpawnTable and zoneSpawnTable[mobID]
    if not spawnEntry then
        debugPrint('No spawn table entry for engaged mob ID: ' .. mobID .. ' (' .. mobName .. ') in zone ID: ' .. zoneId)
        return
    end

    local count = spawnEntry[1]
    debugPrint('Spawn count from onSharedEngage: ' .. count)
    if count > 0 then
        xi.dynamis.spawnNextMobsOnce(mob, count, target)
    end
end

-- ---------------------
-- Statue functions
-- ---------------------
xi.dynamis.statueOnSpawn = function(mob, modelSize)
    -- Apply the general stats to from dynamis mobs
    xi.dynamis.generalInfo(mob, modelSize)
    mob:setSpawnAnimation(0)
    mob:setMobMod(xi.mobMod.NO_STANDBACK, 1) -- Statues do not stand back

    if mob:getName() == 'Vanguard_Eye' then
        mob:setBaseSpeed(35)
    else
        mob:setBaseSpeed(15)
    end

    local mobId  = mob:getID()
    local zoneId = mob:getZoneID()
    -- If it paths its eyes should be open
    if
        xi.dynamis.paths and
        xi.dynamis.paths[zoneId] and
        xi.dynamis.paths[zoneId][mobId]
    then
        xi.dynamis.checkEyeColor(mob)
    else
        mob:setAnimationSub(0) -- Set statue to closed eye state
    end

    -- Lets check if it has an eye color. If it does we need to set it to not die
    -- Set the eye color before the 1 shot happens
    local eyeColor = xi.dynamis.eyeColor and xi.dynamis.eyeColor[zoneId] and xi.dynamis.eyeColor[zoneId][mobId]
    if eyeColor and eyeColor ~= xi.dynamis.eye.RED then
        mob:setUnkillable(true)
    end

    xi.dynamis.generatePath(mob)
end

xi.dynamis.checkEyeColor = function(mob)
    local zoneId = mob:getZoneID()
    local mobID  = mob:getID()

    -- Check if table values exist to prevent nil errors
    local eyeColor = xi.dynamis.eyeColor and xi.dynamis.eyeColor[zoneId] and xi.dynamis.eyeColor[zoneId][mobID]
    if
        eyeColor == xi.dynamis.eye.BLUE or
        eyeColor == xi.dynamis.eye.GREEN
    then
        mob:setAnimationSub(eyeColor)
    else
        mob:setAnimationSub(xi.dynamis.eye.RED) -- Default to red if none specified
    end
end

xi.dynamis.spawnAggroStatues = function(mob, target)
    local zoneId   = mob:getZoneID()
    local statueId = mob:getID()
    -- Check special spawns on aggro conditions
    local zoneAggro          = xi.dynamis.aggro[zoneId]
    local nonAggressiveSpawn = zoneAggro.nonAggressive and zoneAggro.nonAggressive[statueId]
    local aggressiveSpawn    = zoneAggro.aggressive and zoneAggro.aggressive[statueId]

    if nonAggressiveSpawn then
        for _, mobId in ipairs(nonAggressiveSpawn) do
            local mobToSpawn = GetMobByID(mobId)
            if mobToSpawn and not mobToSpawn:isSpawned() then
                mobToSpawn:spawn()
            end
        end
    end

    if aggressiveSpawn then
        for _, mobId in ipairs(aggressiveSpawn) do
            local mobToSpawn = GetMobByID(mobId)
            debugPrint('Aggressive Spawn Mob ID: ' .. mobId)
            if mobToSpawn and not mobToSpawn:isSpawned() then
                mobToSpawn:spawn()

                if target then
                    setTimerTarget(mobToSpawn, target)
                    mobToSpawn:timer(500, function(mobArg)
                        if mobArg then
                            local timerTarget = getTimerTarget(mobArg)
                            if timerTarget then
                                mobArg:updateEnmity(timerTarget)
                            end
                        end
                    end)
                end
            end
        end
    end
end

xi.dynamis.onStatueFight = function(mob, target)
    -- If its a normal statue don't try to do the restore effect
    local zoneId = mob:getZoneID()
    local eye    = xi.dynamis.eyeColor and xi.dynamis.eyeColor[zoneId] and xi.dynamis.eyeColor[zoneId][mob:getID()]
    if eye ~= xi.dynamis.eye.BLUE and eye ~= xi.dynamis.eye.GREEN then
        return
    end

    -- Need to check if the var was triggered already otherwise it will trigger the retore more than once
    -- The mob is unkillable so it will never die and trigger the death function, so we have to check the HP directly
    if
        mob:getHP() ~= 1 or
        mob:getLocalVar('hp1check') == 1
    then
        return
    end

    debugPrint('I am at 1 HP')
    -- I can probably just remove RED from everything, including the spawn files and use RED as default

    local zone    = mob:getZone()
    local players = zone:getPlayers()

    for _, playerObj in pairs(players) do
        -- Test is dead player triggers this
        if mob:checkDistance(playerObj) < 30 then
            if eye == xi.dynamis.eye.BLUE then
                debugPrint('Restoring HP to nearby players')
                local missingHP = playerObj:getMaxHP() - playerObj:getHP()
                -- TODO: figure out if this wakes slept players up
                playerObj:restoreHP(missingHP)
                playerObj:messageBasic(xi.msg.basic.RECOVERS_HP, 0, missingHP)
                mob:injectActionPacket(playerObj:getID(), 11, 772, 0, 0, xi.msg.basic.AOE_REGAIN_HP, 0, missingHP)
            else
                local missingMP = playerObj:getMaxMP() - playerObj:getMP()
                playerObj:restoreMP(missingMP)
                playerObj:messageBasic(xi.msg.basic.RECOVERS_MP, 0, missingMP)
                mob:injectActionPacket(playerObj:getID(), 11, 773, 0, 0, xi.msg.basic.AOE_REGAIN_MP, 0, missingMP)
            end
        end
    end

    mob:setLocalVar('hp1check', 1)
    mob:timer(1000, function(mobArg)
        mobArg:setUnkillable(false)
        mobArg:setHP(0)
    end)
end

-- NONE    = 0,
-- RED     = 1, -- Default statue eye color
-- BLUE    = 2, -- HP refill
-- GREEN   = 3, -- MP refill
xi.dynamis.onStatueDeath = function(mob, player, optParams)
    if not optParams.isKiller then
        return
    end

    -- Make sure this only runs once FOR all players. Death functions get called for every single player
    if mob:getLocalVar('statueDeathCheck') == 1 then
        return
    end

    -- If the statue gets 1 shotted we need to force spawn the statues for aggro conditions
    if mob:getLocalVar('engageCheck') == 0 then
        xi.dynamis.spawnAggroStatues(mob, nil)
    end

    -- If the mob is one shotted we need to force spawn configured adds.
    local zoneId   = mob:getZoneID()
    local statueId = mob:getID()

    if mob:getLocalVar('engageCheck') == 0 then
        local count    = xi.dynamis.spawnTable[zoneId][statueId][1]
        if count > 0 then
            xi.dynamis.spawnNextMobsOnce(mob, count, nil) -- Spawn the next X amount of IDs from that statue
        end
    end

    mob:setLocalVar('statueDeathCheck', 1)

    -- This will check for TEs and NM deaths
    xi.dynamis.onMobDeath(mob, player, optParams)
end

-- ---------------------
-- Regular Mob functions
-- ---------------------
xi.dynamis.onMobSpawn = function(mob, mobType, modelSize)
    xi.dynamis.generalInfo(mob, modelSize)

    if
        mobType == xi.dynamis.mobType.NIGHTMARE and
        mob:getZoneID() ~= xi.zone.DYNAMIS_TAVNAZIA
    then
        mob:setRoamFlags(xi.roamFlag.NONE)
    end

    if isStationaryMob(mob) then
        mob:setRoamFlags(bit.bor(mob:getRoamFlags(), xi.roamFlag.SCRIPTED))
    end
end

xi.dynamis.onMobDisengage = function(mob)
    local spawnPos = mob:getSpawnPos()
    mob:timer(3000, function(mobArg)
        -- Check if mob is far from spawn position
        if mobArg:checkDistance(spawnPos) > 1 then
        -- Return to original spawn position
            mobArg:pathThrough({ spawnPos }, xi.path.flag.COORDS)
        end
    end)
end

xi.dynamis.onMobRoam = function(mob)
    if mob:getLocalVar('currentPath') == 1 then
        return
    end

    -- Check the rotation after the mob casts a spell on a party member
    local spawnPos = mob:getSpawnPos()
    if mob:checkDistance(spawnPos) < 1 then
        mob:setRotation(spawnPos.rot)
        return
    end
end

xi.dynamis.onMobDeath = function(mob, player, optParams)
    if not optParams.isKiller then
        return
    end

    if mob:getLocalVar('deathCheck') == 1 then
        return
    end

    local zone   = mob:getZone()
    local zoneId = mob:getZoneID()

    -- Check for time extensions
    xi.dynamis.addTimeToDynamis(zone, mob)

    -- Check for NM death actions
    xi.dynamis.onNMDeath(mob, player, optParams)

    -- Zone specific death actions
    if
        zoneId == xi.zone.DYNAMIS_VALKURM and
        mob:getName() == 'Nightmare_Fly'
    then
        xi.dynamis.flyCheck(zone)
    end

    if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
        if
            mob:getName() == 'Nightmare_Worm' or
            mob:getName() == 'Nightmare_Antlion'
        then
            xi.dynamis.sjDeathCheck(zone)
        end

        local vanguardEyes =
        {
            [xi.tav.mobs.VANGUARD_EYE_9]  = true,
            [xi.tav.mobs.VANGUARD_EYE_15] = true,
            [xi.tav.mobs.VANGUARD_EYE_67] = true,
            [xi.tav.mobs.VANGUARD_EYE_75] = true,
        }

        if vanguardEyes[mob:getID()] then
            xi.dynamis.checkQmSpawn(mob, zone, zoneId)
        end
    end

    mob:setLocalVar('deathCheck', 1)
end

-- ---------------------
-- NM Mob functions
-- ---------------------
-- NM Death Actions - define conditional spawns when specific NMs die
xi.dynamis.onNMDeath = function(mob, player, optParams)
    if not optParams.isKiller then
        return
    end

    local zoneId = mob:getZoneID()
    local mobID = mob:getID()
    local zone = mob:getZone()

    -- Get the death var for this mob
    local deathVarByMob = xi.dynamis.deathVarByMob[zoneId]
    if not deathVarByMob or not deathVarByMob[mobID] then
        return
    end

    local deathVar = deathVarByMob[mobID]

    -- We set the var for three reasons:
    -- 1. To track that this NM has been killed for future checks
    -- 2. To prevent double spawns if the NM is revived and killed again
    -- 3. To allow GMs in case of bugs/crashes to reset the var and respawn the NM
    zone:setLocalVar(deathVar, 1)

    -- Check spawnCheck table for any spawn conditions that are now met
    local spawnCheckTable = xi.dynamis.spawnCheck[zoneId]
    if not spawnCheckTable or #spawnCheckTable == 0 then
        return
    end

    for _, spawnCheck in ipairs(spawnCheckTable) do
        -- Only evaluate if it hasn't spawned yet and spawnedVar is valid
        local spawnedVar = spawnCheck.spawnedVar and zone:getLocalVar(spawnCheck.spawnedVar)
        if spawnedVar ~= 1 then
            -- Check if all required vars are met
            local allRequiredVarsMet = true

            for _, requiredVar in ipairs(spawnCheck.requiredVars or {}) do
                if zone:getLocalVar(requiredVar) ~= 1 then
                    allRequiredVarsMet = false
                    break
                end
            end

            -- If all conditions are met, spawn and set the var to prevent respawn
            if allRequiredVarsMet and spawnCheck.spawn and spawnCheck.spawnedVar then
                local spawn = spawnCheck.spawn
                if type(spawn) == 'function' then
                    spawn = spawn()
                end

                xi.dynamis.spawnWave(spawn)
                zone:setLocalVar(spawnCheck.spawnedVar, 1)
            end
        end
    end
end

-- ---------------------
-- Boss functions
-- ---------------------
xi.dynamis.onBossInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.TERROR)
end

xi.dynamis.onBossSpawn = function(mob, modelSize)
    mob:setSpawnAnimation(0)
end

xi.dynamis.onBossEngage = function(mob, target)
    -- TODO: for qufim bosses maybe
end

xi.dynamis.onBossRoam = function(mob)
end

xi.dynamis.onBossDeath = function(mob, player, optParams)
    if not optParams.isKiller then
        return
    end

    -- Death happens once per player - only run once per mob
    if mob:getLocalVar('deathTriggered') == 1 then
        return
    end

    mob:setLocalVar('deathTriggered', 1)

    -- Set position for win QM
    local zoneId = mob:getZoneID()
    local pos    = mob:getPos()
    local winQM  = GetNPCByID(xi.dynamis.dynaInfoEra[zoneId].winQM)

    if winQM then
        winQM:setPos(pos.x, pos.y, pos.z, pos.rot)
        winQM:setStatus(xi.status.NORMAL)
    end

    -- Award Title
    local zone = mob:getZone()
    local playerList = zone:getPlayers()
    for _, players in pairs(playerList) do
        players:addTitle(xi.dynamis.dynaInfoEra[zoneId].winTitle)
    end

    -- Run normal dead function
    xi.dynamis.onMobDeath(mob, player, optParams)
end

-- ---------------------
-- Spawn mechanics
-- ---------------------
local function isValidSpawnNumber(value)
    return type(value) == 'number' and value == value
end

local function getLineSpawnRotation(statuePos)
    local rot     = isValidSpawnNumber(statuePos.rot) and statuePos.rot or 0
    local radians = 2 * math.pi - (rot / 256) * 2 * math.pi
    return math.cos(radians), math.sin(radians)
end

local function isDefaultInsideSpawnPosition(spawnPos)
    return
        spawnPos and
        spawnPos.x == 1.000 and
        spawnPos.y == 1.000 and
        spawnPos.z == 1.000
end

local function setSpawnPosition(mobToSpawn, x, y, z, rot, fallbackPos)
    if
        not isValidSpawnNumber(x) or
        not isValidSpawnNumber(y) or
        not isValidSpawnNumber(z)
    then
        if
            not fallbackPos or
            not isValidSpawnNumber(fallbackPos.x) or
            not isValidSpawnNumber(fallbackPos.y) or
            not isValidSpawnNumber(fallbackPos.z)
        then
            return
        end

        x = fallbackPos.x
        y = fallbackPos.y
        z = fallbackPos.z
    end

    if not isValidSpawnNumber(rot) then
        rot = 0
    end

    mobToSpawn:setSpawn(x, y, z, rot)
end

local function calculateBehindLineSpawnPosition(statuePos, behindDistance, sideDistance)
    local cosRot, sinRot = getLineSpawnRotation(statuePos)

    return
        statuePos.x + cosRot * -behindDistance - sinRot * sideDistance,
        statuePos.y,
        statuePos.z + sinRot * -behindDistance + cosRot * sideDistance,
        true,
        false
end

local function calculateBehindSpawnPosition(statuePos, distance)
    local cosRot, sinRot = getLineSpawnRotation(statuePos)

    return
        statuePos.x + cosRot * -distance,
        statuePos.y,
        statuePos.z + sinRot * -distance,
        true,
        false
end

local function calculateSideSpawnPosition(statuePos, distance)
    local cosRot, sinRot = getLineSpawnRotation(statuePos)

    return
        statuePos.x + sinRot * distance,
        statuePos.y,
        statuePos.z + cosRot * distance,
        true,
        false
end

local function calculateLineSpawnPosition(statuePos, lineSpawnConfig, spawnedCount, addSpawnPos)
    local spawnIndex = spawnedCount + 1

    if lineSpawnConfig then
        local behindLine = lineSpawnConfig.behindLine
        if behindLine then
            local rawBehind      = behindLine.behind
            local behindDistance = type(rawBehind) == 'table' and (rawBehind[spawnIndex] or 0) or (rawBehind or 0)
            local sideDistance   = behindLine.side and behindLine.side[spawnIndex] or 0

            return calculateBehindLineSpawnPosition(statuePos, behindDistance, sideDistance)
        end

        local behindDistance = lineSpawnConfig.behind and lineSpawnConfig.behind[spawnIndex]
        if behindDistance then
            return calculateBehindSpawnPosition(statuePos, behindDistance)
        end

        local sideDistance = lineSpawnConfig.side and lineSpawnConfig.side[spawnIndex]
        if sideDistance then
            return calculateSideSpawnPosition(statuePos, sideDistance)
        end

        local offset = lineSpawnConfig[spawnIndex]
        if offset then
            return statuePos.x + offset[1], statuePos.y + offset[2], statuePos.z + offset[3], true, false
        end
    end

    if isDefaultInsideSpawnPosition(addSpawnPos) then
        return statuePos.x, statuePos.y, statuePos.z, true, true
    end

    return statuePos.x, statuePos.y, statuePos.z, false, false
end

xi.dynamis.spawnNextMobsOnce = function(statue, count, target)
    debugPrint('Spawning next mobs once...')
    if
        count <= 0 or
        statue:getLocalVar('spawnedAdds') == 1
    then
        return
    end

    statue:setLocalVar('spawnedAdds', 1)

    local statueId        = statue:getID()
    local statuePos       = statue:getPos()
    local randomStunTime  = math.random(4000, 8000)
    local zoneId          = statue:getZoneID()
    local zoneSpawnTable  = xi.dynamis.spawnTable and xi.dynamis.spawnTable[zoneId]
    local lineSpawnConfig = xi.dynamis.lineSpawns and xi.dynamis.lineSpawns[zoneId] and xi.dynamis.lineSpawns[zoneId][statueId]
    local isAnimatedMob   = statue:getName():find('^Animated') ~= nil
    local spawnedCount    = 0
    local i               = 1

    while spawnedCount < count do
        local mobId = statueId + i

        if zoneSpawnTable and zoneSpawnTable[mobId] then
            debugPrint('Stopping add scan for statue ' .. statueId .. ' at next configured statue ' .. mobId)
            break
        end

        local mobToSpawn = GetMobByID(mobId)

        -- If the mob you are trying to spawn is a pet, skip it and keep walking IDs.
        if
            mobToSpawn == nil or
            mobToSpawn:getMaster() ~= nil or
            mobToSpawn:isSpawned()
        then
            i = i + 1
        else
            -- mobToSpawn:setMobMod(xi.mobMod.SUPERLINK, statue:getTargID())
            mobToSpawn:setRoamFlags(xi.roamFlag.SCRIPTED)

            local spawnX, spawnY, spawnZ, shouldSetSpawn, spawnOnTop
            if isAnimatedMob then
                local angle = (spawnedCount / count) * 2 * math.pi
                local radius = 3

                spawnX         = statuePos.x + math.cos(angle) * radius
                spawnY         = statuePos.y
                spawnZ         = statuePos.z + math.sin(angle) * radius
                shouldSetSpawn = true
                spawnOnTop     = false
            else
                spawnX, spawnY, spawnZ, shouldSetSpawn, spawnOnTop = calculateLineSpawnPosition(statuePos, lineSpawnConfig, spawnedCount, mobToSpawn:getSpawnPos())
            end

            if spawnOnTop then
                setSpawnPosition(mobToSpawn, statuePos.x, statuePos.y, statuePos.z, statuePos.rot)
            elseif shouldSetSpawn then
                setSpawnPosition(mobToSpawn, spawnX, spawnY, spawnZ, statuePos.rot, statuePos)
            end

            -- Sets the "pet" model sizes to one below its master
            local mainSize = statue:getModelSize()
            if string.find(mobToSpawn:getName(), 'Nightmare') then
                if mainSize > 1 then
                    mobToSpawn:setModelSize(mainSize - 1)
                end
            end

            if spawnOnTop then
                -- Start after 2 seconds, then spawn 2 seconds apart at the statue's position.
                local capturedMob    = mobToSpawn
                local capturedDelay  = (spawnedCount + 1) * 2000
                local capturedTarget = target
                statue:timer(capturedDelay, function(_statueArg)
                    if not capturedMob or capturedMob:isSpawned() then
                        return
                    end

                    capturedMob:spawn()

                    capturedMob:setLocalVar('spawnedFromMaster', 1)
                    setTimerTarget(capturedMob, capturedTarget)
                    local timerTarget = getTimerTarget(capturedMob)
                    if timerTarget then
                        capturedMob:updateEnmity(timerTarget)
                    end
                end)
            else
                mobToSpawn:spawn()
                mobToSpawn:setLocalVar('spawnedFromMaster', 1)
                setTimerTarget(mobToSpawn, target)

                -- One-shot force spawns call this without a target, so only normal engage pulls adds in.
                if target then
                    mobToSpawn:updateEnmity(target)
                end

                mobToSpawn:setAutoAttackEnabled(false)
                mobToSpawn:setMagicCastingEnabled(false)
                mobToSpawn:setMobAbilityEnabled(false)

                mobToSpawn:stun(randomStunTime)
                mobToSpawn:timer(3000, function(mobArg)
                    if not mobArg then
                        return
                    end

                    local timerTarget = getTimerTarget(mobArg)
                    if timerTarget then
                        mobArg:lookAt(timerTarget:getPos())
                    end

                    mobArg:setAutoAttackEnabled(true)
                    mobArg:setMagicCastingEnabled(true)
                    mobArg:setMobAbilityEnabled(true)
                end)
            end

            spawnedCount = spawnedCount + 1
            i = i + 1
        end
    end
end

xi.dynamis.spawnWave = function(wave)
    if not wave then
        return
    end

    for _, mobId in ipairs(wave) do
        local mob = GetMobByID(mobId)
        if mob and not mob:isSpawned() then
            mob:spawn()
        end
    end
end

-----------------------------------
--    Dynamis Mob Pathing/Roam   --
-----------------------------------
xi.dynamis.generatePath = function(mob)
    local zoneId = mob:getZoneID()
    local mobId  = mob:getID()

    if
        xi.dynamis.paths and
        xi.dynamis.paths[zoneId] and
        xi.dynamis.paths[zoneId][mobId] ~= nil
    then
        local pathData = xi.dynamis.paths[zoneId][mobId]
        local first = pathData[1]
        local second = pathData[2]
        local pathNodes =
        {
            { x = first[1],  y = first[2],  z = first[3],  wait = 1000 },
            { x = second[1], y = second[2], z = second[3], wait = 1000 }
        }
        mob:pathThrough(pathNodes, xi.path.flag.PATROL)
        mob:setLocalVar('currentPath', 1)
    end
end
