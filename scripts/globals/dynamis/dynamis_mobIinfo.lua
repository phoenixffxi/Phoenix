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

-- Debug control
xi.mobinfo = xi.mobinfo or {}
xi.mobinfo.DEBUG = false

local function debugPrint(message)
    if xi.mobinfo.DEBUG then
        print('[DynaDebug] ' .. message)
    end
end

-- ---------------------
-- General Info functions
-- ---------------------
xi.dynamis.generalInfo = function(mob)
    mob:setTrueDetection(true)
    mob:setSpawnAnimation(1) -- This is the cool looking spwan animation
    mob:setMobMod(xi.mobMod.CHARMABLE, 0)
    mob:setMobMod(xi.mobMod.CHECK_AS_NM, 1)
    mob:setMobMod(xi.mobMod.NO_DESPAWN, 1)
    mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.NON_EXCLUSIVE)
    mob:setMobMod(xi.mobMod.GIL_BONUS, -100)
    mob:setMobMod(xi.mobMod.EXP_BONUS, -100)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
    mob:setRoamFlags(xi.roamFlag.SCRIPTED)

    mob:setModelSize(3)

    -- TODO: figure out DRG wyvern calls later
    local job = mob:getMainJob()
    if
        job == xi.job.BST or
        job == xi.job.SMN
    then
        xi.mob.callPets(mob, mob:getID() + 1)
    end
end

-- ---------------------
-- Statue functions
-- ---------------------
xi.dynamis.statueOnSpawn = function(mob)
    -- Apply the general stats to from dynamis mobs
    xi.dynamis.generalInfo(mob)
    mob:setSpawnAnimation(0)

    mob:setAnimationSub(0) -- Set statue to closed eye state

    -- Lets check if it has an eye color. If it does we need to set it to not die
    -- Set the eye color before the 1 shot happens
    local zoneId   = mob:getZoneID()
    local statueId = mob:getID()
    -- debugPrint('Statue spawned - ID: ' .. statueId .. ' Zone: ' .. zoneId .. ' isSpawned: ' .. tostring(mob:isSpawned()) .. ' HP: ' .. mob:getHP())

    -- Check if table value exists to prevent nil errors
    local eyeColor = xi.dynamis.eyeColor[zoneId] and xi.dynamis.eyeColor[zoneId][statueId]
    if eyeColor and eyeColor ~= xi.dynamis.eye.RED then
        mob:setUnkillable(true)
    end

    xi.dynamis.generatePath(mob)
end

xi.dynamis.mobOnEngage = function(mob, target)
    debugPrint('Statue engaged, checking for spawns...')
    debugPrint('Engaged mob ID: ' .. mob:getID() .. ' isSpawned: ' .. tostring(mob:isSpawned()) .. ' Distance to spawn: ' .. mob:checkDistance(mob:getSpawnPos()))

    -- Stop the spawning if the statue is re-engaged after a wipe
    if mob:getLocalVar('engageCheck') == 1 then
        return
    end

    mob:setLocalVar('engageCheck', 1)
    local zoneId = mob:getZoneID()
    local mobID  = mob:getID()

    mob:setMobMod(xi.mobMod.MAGIC_DELAY, math.random(5, 15)) -- Random magic delay to make the casts delayed
    mob:stun(3000) -- Used to make the mob not move at all for 3 seconds

    -- Check for mobs on aggro conditions
    xi.dynamis.spawnAggroStatues(mob, target)

    -- If the mob has spawned from the master mob then do not check for more spawns
    if mob:getLocalVar('spawnedFromMaster') == 1 then
        debugPrint('I am an add, not spawning more mobs')
        return
    end

    local count = xi.dynamis.spawnTable[zoneId][mobID][1]
    if count > 0 then
        local checkForceSpawn = xi.dynamis.spawnTable[zoneId][mobID][2]
        xi.dynamis.spawnNextMobsOnce(mob, mobID, count, target, checkForceSpawn) -- Spawn the next X amount of IDs from that staue
    end
end

xi.dynamis.checkEyeColor = function(mob)
    local zoneId = mob:getZoneID()
    local mobID  = mob:getID()

    -- Check if table values exist to prevent nil errors
    local eyeColor = xi.dynamis.eyeColor[zoneId] and xi.dynamis.eyeColor[zoneId][mobID]
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
    debugPrint('Statue Aggro Spawns: ' .. (nonAggressiveSpawn or 0) .. ', ' .. (aggressiveSpawn or 0))
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
                mobToSpawn:updateEnmity(target)
            end
        end
    end
end

xi.dynamis.onStatueFight = function(mob, target)
    -- If its a normal statue don't try to do the restore effect
    local zoneId = mob:getZoneID()
    local restoreStatue = xi.dynamis.spawnTable[zoneId][mob:getID()]
    local eye = restoreStatue[2]
    if eye == xi.dynamis.eye.RED then
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
    -- I can probably just removed RED from everything, including the spawn files and use RED as default

    local zone    = mob:getZone()
    local players = zone:getPlayers()

    for name, playerObj in pairs(players) do
        -- Test is dead player triggers this
        if mob:checkDistance(playerObj) < 30 then
            if eye == xi.dynamis.eye.BLUE then
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
        xi.dynamis.spawnAggroStatues(mob, player)
    end

    -- If the statue gets 1 shotted
    -- Force spawn check for NMs
    local zoneId   = mob:getZoneID()
    local statueId = mob:getID()

    -- If the mob is one shotted we need to force spawn the NM mobs
    -- This means it has NOT been engaged yet
    local checkForceSpawn = xi.dynamis.spawnTable[zoneId][statueId][2]
    if mob:getLocalVar('engageCheck') == 0 and checkForceSpawn then
        local count    = xi.dynamis.spawnTable[zoneId][statueId][1]
        if count > 0 then
            xi.dynamis.spawnNextMobsOnce(mob, statueId, count, nil, checkForceSpawn) -- Spawn the next X amount of IDs from that staue
        end
    end

    mob:setLocalVar('statueDeathCheck', 1)

    -- This will check for TEs and NM deaths
    xi.dynamis.onMobDeath(mob, player, optParams)
end

-- ---------------------
-- Regular Mob functions
-- ---------------------
xi.dynamis.onMobSpawn = function(mob, mobType)
    xi.dynamis.generalInfo(mob)

    -- Set model sizes here instead of 100 SQL rows
    if
        mobType == 'Nightmare' and
        mob:getZoneID() ~= xi.zone.DYNAMIS_TAVNAZIA
    then
        mob:setRoamFlags(xi.roamFlag.NONE)
    elseif mobType == 'Nightmare' then
        mob:setModelSize(3)
    end

    -- If Kindred set auto attack
    if
        mob:getFamily() == 169 and
        (mob:getMainJob() == xi.job.RNG or mob:getMainJob() == xi.job.NIN)
    then
        mob:setMobMod(xi.mobMod.SPECIAL_SKILL, 560) -- Hecatomb Wave
    end

    -- If Quadav set auto attack
    if
        mob:getFamily() == 337 and
        (mob:getMainJob() == xi.job.RNG or mob:getMainJob() == xi.job.NIN)
    then
        mob:setMobMod(xi.mobMod.SPECIAL_SKILL, 1075) -- Ore Toss
    end
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

    -- Check if mob is far from spawn position
    if mob:checkDistance(spawnPos) > 5 then
        -- Return to original spawn position
        mob:pathThrough({ spawnPos }, xi.path.flag.COORDS)
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
                xi.dynamis.spawnWave(spawnCheck.spawn)
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

xi.dynamis.onBossSpawn = function(mob)
    xi.dynamis.generalInfo(mob)
    mob:setSpawnAnimation(0)

    if mob:getName() == 'Apocalyptic_Beast' then
        xi.dynamis.apocBeastSpawn(mob)
    end
end

xi.dynamis.onBossEngage = function(mob, target)
    -- TODO: for qufim bosses maybe
end

xi.dynamis.onBossRoam = function(mob)
    if mob:getName() == 'Apocalyptic_Beast' then
        xi.dynamis.apocBeastRoam(mob)
    end
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
xi.dynamis.spawnNextMobsOnce = function(statue, statueId, count, target, checkForceSpawn)
    debugPrint('Spawning next mobs once...')
    if
        count <= 0 or
        statue:getLocalVar('spawnedAdds') == 1
    then
        return
    end

    statue:setLocalVar('spawnedAdds', 1)

    local statuePos = statue:getPos()
    local randomStunTime = math.random(4000, 8000)

    for i = 1, count do
        local mobId = statueId + i
        local mobToSpawn = GetMobByID(mobId)

        -- If the mob you are trying to spawn is a pet, skip it
        if mobToSpawn and mobToSpawn:getMaster() == nil and not mobToSpawn:isSpawned() then
            mobToSpawn:setMobMod(xi.mobMod.SUPERLINK, statueId)
            mobToSpawn:setRoamFlags(xi.roamFlag.SCRIPTED)
            mobToSpawn:setSpawn(
                statuePos.x + math.random() * 6 - 3,
                statuePos.y + 1,
                statuePos.z + math.random() * 6 - 3,
                statuePos.rot
            )
            mobToSpawn:spawn()
            mobToSpawn:setLocalVar('spawnedFromMaster', 1)

            -- Sets the "pet" model sizes to one below its master
            local mainSize = statue:getModelSize()
            if string.find(mobToSpawn:getName(), 'Nightmare') then
                if mainSize > 1 then
                    mobToSpawn:setModelSize(mainSize - 1)
                else
                    mobToSpawn:setModelSize(1)
                end
            elseif string.find(mobToSpawn:getName(), 'Hydra') then
                -- Size 3 does not work for Hydra, max size is 2
                mobToSpawn:setModelSize(2)
            else
                mobToSpawn:setModelSize(mainSize)
            end

            mobToSpawn:setAutoAttackEnabled(false)
            mobToSpawn:setMagicCastingEnabled(false)
            mobToSpawn:setMobAbilityEnabled(false)

            mobToSpawn:stun(randomStunTime)

            -- If the statue dies in 1 shot and it has an NM then spawn the mobs regardless but do not update enmity
            if not checkForceSpawn then
                mobToSpawn:updateEnmity(target)
            end

            mobToSpawn:timer(3000, function(mobArg)
                if not checkForceSpawn then
                    mobArg:lookAt(target:getPos())
                end
                mobArg:setAutoAttackEnabled(true)
                mobArg:setMagicCastingEnabled(true)
                mobArg:setMobAbilityEnabled(true)
            end)
        end
    end
end

xi.dynamis.spawnWave = function(wave)
    -- debugPrint('Spawning wave...')
    -- debugPrint('Wave data: ' .. tostring(wave))
    if not wave then
        return
    end

    for _, mobId in ipairs(wave) do
        -- debugPrint('Spawning mob ID: ' .. mobId)
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
    local getID  = mob:getID()

    if
        xi.dynamis.paths[zoneId] and
        xi.dynamis.paths[zoneId][getID] ~= nil
    then
        local table = xi.dynamis.paths[zoneId][getID]
        local first = table[1]
        local second = table[2]
        local pathNodes =
        {
            { x = first[1],  y = first[2],  z = first[3],  wait = 1000 },
            { x = second[1], y = second[2], z = second[3], wait = 1000 }
        }
        mob:pathThrough(pathNodes, xi.path.flag.PATROL)
        mob:setLocalVar('currentPath', 1)
    end
end
