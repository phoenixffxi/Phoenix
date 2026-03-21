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

-- ---------------------
-- General Info functions
-- ---------------------
xi.dynamis.generalInfo = function(mob)
    mob:setTrueDetection(true)
    mob:setMobMod(xi.mobMod.CHARMABLE, 0)
    mob:setMobMod(xi.mobMod.CHECK_AS_NM, 1)
    mob:setMobMod(xi.mobMod.NO_DESPAWN, 1)
    mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.NON_EXCLUSIVE)
    mob:setMobMod(xi.mobMod.GIL_BONUS, -100)
    mob:setMobMod(xi.mobMod.EXP_BONUS, -100)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
    mob:setRoamFlags(xi.roamFlag.SCRIPTED)
end

-- ---------------------
-- Statue functions
-- ---------------------
xi.dynamis.statueOnSpawn = function(mob)
    -- Apply the general stats to from dynamis mobs
    xi.dynamis.generalInfo(mob)

    mob:setAnimationSub(0) -- Set statue to closed eye state
    mob:setRoamFlags(xi.roamFlag.SCRIPTED)

    -- Lets check if it has an eye color. If it does we need to set it to not die
    -- Set the eye color before the 1 shot happens
    local zoneID   = mob:getZoneID()
    local statueId = mob:getID()
    print('Statue spawned - ID:', statueId, 'Zone:', zoneID, 'isSpawned:', mob:isSpawned(), 'HP:', mob:getHP())
    local eyeColor = xi.dynamis.spawnTable[zoneID][statueId][2]
    if eyeColor ~= xi.dynamis.eye.RED then
        mob:setUnkillable(true)
    end

    xi.dynamis.generatePath(mob)
end

xi.dynamis.statueOnEngaged = function(mob, target)
    print('Statue engaged, checking for spawns...')
    print('Engaged mob ID:', mob:getID(), 'isSpawned:', mob:isSpawned(), 'Distance to spawn:', mob:checkDistance(mob:getSpawnPos()))

    -- Stop the spawning if the statue is re-engaged after a wipe
    if mob:getLocalVar('engageCheck') == 1 then
        return
    end

    xi.dynamis.spawnAggroStatues(mob, target)

    mob:setLocalVar('engageCheck', 1)
    local zoneID   = mob:getZoneID()
    local statueId = mob:getID()

    -- Sets the eye color
    local eyeColor = xi.dynamis.spawnTable[zoneID][statueId][2]
    if eyeColor ~= xi.dynamis.eye.RED then
        mob:setAnimationSub(eyeColor)
    else
        mob:setAnimationSub(xi.dynamis.eye.RED) -- Default to red if none specified
    end

    mob:setMobMod(xi.mobMod.MAGIC_DELAY, math.random(5, 15)) -- Random magic delay to make the casts delayed
    mob:stun(3000) -- Used to make the mob not move at all for 3 seconds

    local count = xi.dynamis.spawnTable[zoneID][statueId][1]
    print('Spawning next mobs for statue ID:', statueId, 'Count:', count)
    if count > 0 then
        xi.dynamis.spawnNextMobsOnce(mob, statueId, count, target) -- Spawn the next X amount of IDs from that staue
    end
end

xi.dynamis.spawnAggroStatues = function(mob, target)
    local zoneID   = mob:getZoneID()
    local statueId = mob:getID()
    -- Check special spawns on aggro conditions
    local zoneAggro          = xi.dynamis.aggro[zoneID]
    local nonAggressiveSpawn = zoneAggro.nonAggressive and zoneAggro.nonAggressive[statueId]
    local aggressiveSpawn    = zoneAggro.aggressive and zoneAggro.aggressive[statueId]
    print('Statue Aggro Spawns:', nonAggressiveSpawn or 0, aggressiveSpawn or 0)
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
            print('Aggressive Spawn Mob ID:', mobId)
            if mobToSpawn and not mobToSpawn:isSpawned() then
                mobToSpawn:spawn()
                mobToSpawn:updateEnmity(target)
            end
        end
    end
end

xi.dynamis.onStatueFight = function(mob, target)
    -- If its a normal statue don't try to do the restore effect
    local zoneID = mob:getZoneID()
    local restoreStatue = xi.dynamis.spawnTable[zoneID][mob:getID()]
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

    print('I am at 1 HP')
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
            else
                local missingMP = playerObj:getMaxMP() - playerObj:getMP()
                playerObj:restoreMP(missingMP)
                playerObj:messageBasic(xi.msg.basic.RECOVERS_MP, 0, missingMP)
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

    -- If the statue gets 1 shotted
    -- Force spawn check for NMs
    local zoneID   = mob:getZoneID()
    local statueId = mob:getID()

    -- If the statue gets 1 shotted we need to force spawn the statues for aggro conditions
    if mob:getLocalVar('engageCheck') == 0 then
        xi.dynamis.spawnAggroStatues(mob, player)
    end

    local checkForceSpawn = xi.dynamis.spawnTable[zoneID][statueId][3] or 0
    -- If the mob is one shotted we need to force spawn the NM mobs
    -- This means it has NOT been engaged yet
    if mob:getLocalVar('engageCheck') == 0 and checkForceSpawn == 1 then
        local count    = xi.dynamis.spawnTable[zoneID][statueId][1]
        if count > 0 then
            xi.dynamis.spawnNextMobsOnce(mob, statueId, count, nil, checkForceSpawn) -- Spawn the next X amount of IDs from that staue
        end
    end

    -- Make sure this only runs once FOR all players. Death functions get called for every single player
    if mob:getLocalVar('deathCheck') == 1 then
        return
    end

    mob:setLocalVar('deathCheck', 1)

    -- This will check for TEs and NM deaths
    xi.dynamis.onMobDeath(mob, player, optParams)
end

-- ---------------------
-- Regular Mob functions
-- ---------------------
xi.dynamis.onMobSpawn = function(mob)
    mob:setSpawnAnimation(1) -- This is the cool looking spwan animation
    xi.dynamis.generalInfo(mob)

    -- TODO: figure out DRG wyvern calls later
    local job = mob:getMainJob()
    if
        job == xi.job.BST or
        job == xi.job.SMN
    then
        xi.mob.callPets(mob, mob:getID() + 1)
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
    -- Check for time extensions
    xi.dynamis.addTimeToDynamis(mob:getZone(), mob)

    -- Check for NM death actions
    xi.dynamis.onNMDeath(mob, player, optParams)
end

-- ---------------------
-- NM Mob functions
-- ---------------------
-- TODO: apply this to bosses
xi.dynamis.onBossInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.TERROR)
end

-- NM Death Actions - define conditional spawns when specific NMs die
xi.dynamis.onNMDeath = function(mob, player, optParams)
    if not optParams.isKiller then
        return
    end

    local zoneID = mob:getZoneID()
    local mobID = mob:getID()
    local zone = mob:getZone()

    -- Get the death var for this mob
    local deathVarByMob = xi.dynamis.deathVarByMob[zoneID]
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
    local spawnCheckTable = xi.dynamis.spawnCheck[zoneID]
    if not spawnCheckTable then
        return
    end

    for _, spawnCheck in ipairs(spawnCheckTable) do

        -- Only evaluate if it hasn't spawned yet
        if zone:getLocalVar(spawnCheck.spawnedVar) ~= 1 then
            -- Check if all required vars are met
            local allRequiredVarsMet = true

            for _, requiredVar in ipairs(spawnCheck.requiredVars or {}) do
                if zone:getLocalVar(requiredVar) ~= 1 then
                    allRequiredVarsMet = false
                    break
                end
            end

            -- If all conditions are met, spawn and set the var to prevent respawn
            if allRequiredVarsMet and spawnCheck.spawn then
                xi.dynamis.spawnWave(spawnCheck.spawn)
                zone:setLocalVar(spawnCheck.spawnedVar, 1)
            end
        end
    end
end

-- ---------------------
-- Spawn mechanics
-- ---------------------
xi.dynamis.spawnNextMobsOnce = function(statue, statueId, count, target, checkForceSpawn)
    print('Spawning next mobs once...')
    if
        count <= 0 or
        statue:getLocalVar('spawnedAdds') == 1
    then
        return
    end

    statue:setLocalVar('spawnedAdds', 1)

    local statuePos = statue:getPos()
    local randomStunTime = math.random(4000, 8000)
    local spawnedCount = 0
    local i = 1
    while spawnedCount < count do
        local mobId = statueId + i
        local mobToSpawn = GetMobByID(mobId)

        -- If the mob you are trying to spawn is a pet, skip it and go to next ID
        if mobToSpawn and mobToSpawn:getMaster() ~= nil then
            i = i + 1
        elseif mobToSpawn and not mobToSpawn:isSpawned() then
            mobToSpawn:setMobMod(xi.mobMod.SUPERLINK, statueId)
            mobToSpawn:setRoamFlags(xi.roamFlag.SCRIPTED)
            mobToSpawn:setSpawn(statuePos.x + math.random() * 6 - 3, statuePos.y, statuePos.z + math.random() * 6 - 3, statuePos.rot)
            mobToSpawn:spawn()

            spawnedCount = spawnedCount + 1
            i = i + 1

            -- If the statue dies in 1 shot and it has an NM then spawn the mobs regardless but do not update enmity
            if checkForceSpawn == 1 then
                return
            end

            mobToSpawn:updateEnmity(target)

            mobToSpawn:setAutoAttackEnabled(false)
            mobToSpawn:setMagicCastingEnabled(false)
            mobToSpawn:setMobAbilityEnabled(false)

            mobToSpawn:stun(randomStunTime)
            mobToSpawn:timer(3000, function(mobArg)
                mobArg:lookAt(target:getPos())
                mobArg:setAutoAttackEnabled(true)
                mobArg:setMagicCastingEnabled(true)
                mobArg:setMobAbilityEnabled(true)
            end)

        else
            i = i + 1
        end
    end
end

xi.dynamis.spawnWave = function(wave)
    print('Spawning wave...')
    print('Wave data:', wave)
    if not wave then
        return
    end

    for _, mobId in ipairs(wave) do
        print('Spawning mob ID:', mobId)
        local mob = GetMobByID(mobId)
        if mob and not mob:isSpawned() then
            mob:spawn()
        end
    end

    -- zone:setLocalVar(string.format('Wave_%i_Spawned', 1), 1)
    -- zone:setLocalVar(string.format('[DYNA]CurrentWave_%s', zoneID), 1)
end

-- FOR TESTING PURPOSES ONLY
xi.dynamis.despawnWave = function(wave, mobArg)
    print(mobArg)
    print('Despawning wave...')
    if not wave then
        return
    end

    for _, mobId in ipairs(wave) do
        local mob = GetMobByID(mobId)
        if mob and mob:isSpawned() then
            DespawnMob(mobId)
        end
    end

    local zone = mobArg:getZone()
    zone:resetLocalVars()
end

-- FOR TESTING PURPOSES ONLY
xi.dynamis.despawnEverything = function(target)
    print(target)
    print('Despawning everything...')
    local zone = target:getZone()
    for _, mobInZone in pairs(zone:getMobs()) do
        if
            mobInZone:isSpawned()
        then
            DespawnMob(mobInZone:getID())
        end
    end

    zone:resetLocalVars()
end

-----------------------------------
--    Dynamis Mob Pathing/Roam   --
-----------------------------------
xi.dynamis.generatePath = function(mob)
    -- print(mob)
    local zoneID = mob:getZoneID()
    local getID  = mob:getID()

    if
        xi.dynamis.paths[zoneID] and
        xi.dynamis.paths[zoneID][getID] ~= nil
    then
        local table = xi.dynamis.paths[zoneID][getID]
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
