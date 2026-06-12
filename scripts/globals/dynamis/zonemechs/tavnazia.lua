-- Dynamis Tavnazia Mob Information and Mechanics
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- -----------------
-- Nightmare Worm and Antlion Spawns
-- -----------------
local spawns =
{
    worm = {
        positions = {
            { x = -0.4922, z = -26.778, rot = 193 },
            { x = -21.282, z = -21.588, rot = 226 },
            { x = -20.901, z = 21.3637, rot = 34 },
            { x = 0.183, z = 24.414, rot = 62 },
            { x = 30.721, z = -2.156, rot = 142 },
        },
        mobId = 2,
        yMin = -23,
        yMax = -22,
    },
    antlion = {
        positions = {
            { x = 19.105, z = 18.66, rot = 100 },
            { x = 19.72, z = -18.83, rot = 164 },
            { x = -19.13, z = -19.75, rot = 225 },
            { x = -21.65, z = 18.61, rot = 25 },
        },
        mobId = 3,
        yMin = -36,
        yMax = -35,
    }
}

xi.dynamis.onNewDynamisTav = function(player, zone)
    zone:setLocalVar('wormSpawnIndex', math.random(#spawns.worm.positions))
    zone:setLocalVar('antlionSpawnIndex', math.random(#spawns.antlion.positions))
end

xi.dynamis.onZoneInitTav = function(zone)
    local triggerId = 1
    local spawnOffset = 5
    -- Register worm trigger areas
    for i, pos in ipairs(spawns.worm.positions) do
        zone:registerCuboidTriggerArea(triggerId, pos.x - spawnOffset, spawns.worm.yMin, pos.z - spawnOffset, pos.x + spawnOffset, spawns.worm.yMax, pos.z + spawnOffset)
        spawns.worm.positions[i].triggerId = triggerId
        triggerId = triggerId + 1
    end

    -- Register antlion trigger areas
    for i, pos in ipairs(spawns.antlion.positions) do
        zone:registerCuboidTriggerArea(triggerId, pos.x - spawnOffset, spawns.antlion.yMin, pos.z - spawnOffset, pos.x + spawnOffset, spawns.antlion.yMax, pos.z + spawnOffset)
        spawns.antlion.positions[i].triggerId = triggerId
        triggerId = triggerId + 1
    end
end

xi.dynamis.onTriggerAreaEnterTav = function(player, triggerArea)
    local zone = player:getZone()
    local triggerID = triggerArea:getTriggerAreaID()

    -- Check worm spawn
    if zone:getLocalVar('wormSpawned') == 0 then
        local spawnIdx = zone:getLocalVar('wormSpawnIndex')
        if spawns.worm.positions[spawnIdx].triggerId == triggerID then
            zone:setLocalVar('wormSpawned', 1)
            local worm = GetMobByID(xi.tav.mobs.NIGHTMARE_WORM)
            if worm then
                local pos  = spawns.worm.positions[spawnIdx]
                worm:setSpawn(pos.x, spawns.worm.yMin + 1, pos.z)  -- rough Y estimate
                worm:spawn()
                worm:updateEnmity(player)
            end
        end
    end

    -- Check antlion spawn
    if zone:getLocalVar('antlionSpawned') == 0 then
        local spawnIdx = zone:getLocalVar('antlionSpawnIndex')
        if spawns.antlion.positions[spawnIdx].triggerId == triggerID then
            zone:setLocalVar('antlionSpawned', 1)
            local antlion = GetMobByID(xi.tav.mobs.NIGHTMARE_ANTLION)
            if antlion then
                local pos     = spawns.antlion.positions[spawnIdx]
                antlion:setSpawn(pos.x, spawns.antlion.yMin + 1, pos.z)  -- rough Y estimate
                antlion:spawn()
                antlion:updateEnmity(player)
            end
        end
    end
end

xi.dynamis.sjDeathCheck = function(zone)
    xi.dynamis.debugPrint('Checking SJ unlock conditions...')
    -- Use a var just in case GM intervention
    if zone:getLocalVar('SJUnlocked') == 1 then
        return
    end

    local sjVars =
    {
        '[DYNA]AntlionKilled',
        '[DYNA]WormKilled',
    }

    -- Check for both vars to be set
    for _, v in ipairs(sjVars) do
        if zone:getLocalVar(v) == 0 then
            return
        end
    end

    local playersInZone = zone:getPlayers()
    for _, playerEntity in pairs(playersInZone) do
        if playerEntity:hasStatusEffect(xi.effect.SJ_RESTRICTION) then
            playerEntity:delStatusEffect(xi.effect.SJ_RESTRICTION)
        end
    end

    zone:setLocalVar('SJUnlocked', 1)
end

-- Time Extension Mechanics
local qm1 = xi.dynamis.dynaInfoEra[xi.zone.DYNAMIS_TAVNAZIA].timeExtensions[1]
local qm2 = xi.dynamis.dynaInfoEra[xi.zone.DYNAMIS_TAVNAZIA].timeExtensions[2]

local firstEyes  = { '[DYNA]VE9Killed', '[DYNA]VE15Killed' }
local secondEyes = { '[DYNA]VE67Killed', '[DYNA]VE75Killed' }

local function checkAndSpawnQm(zone, qmNpc, spawnVarName, eyeVars)
    if
        zone:getLocalVar(spawnVarName) == 1 or
        qmNpc:getStatus() == xi.status.NORMAL
    then
        return
    end

    -- Start the count for math later
    local killedCount = 0
    for _, eyeVar in ipairs(eyeVars) do
        if zone:getLocalVar(eyeVar) == 1 then
            killedCount = killedCount + 1
        end
    end

    -- 50% chance with 1 eye killed, 100% with 2 eyes killed
    if
        (killedCount == 1 and math.random(1, 2) == 1) or
        killedCount == 2
    then
        qmNpc:setStatus(xi.status.NORMAL)
        zone:setLocalVar(spawnVarName, 1)
    end
end

xi.dynamis.checkQmSpawn = function(mob, zone, zoneID)
    checkAndSpawnQm(zone, GetNPCByID(qm1), 'timeExtensionOneSpawned', firstEyes)
    checkAndSpawnQm(zone, GetNPCByID(qm2), 'timeExtensionTwoSpawned', secondEyes)
end

local qmInfo =
{
    [qm1] = { varName = 'qmOne clicked', waveIndex = 2 },
    [qm2] = { varName = 'qmTwo clicked', waveIndex = 3 },
}

xi.dynamis.teOnTrigger = function(player, npc)
    if npc:getLocalVar('timeExtensionUsed') == 1 then
        return
    end

    local zone = player:getZone()

    -- Change music for all players
    for _, member in pairs(zone:getPlayers()) do
        for channel = 0, 3 do
            member:changeMusic(channel, 227)
        end
    end

    -- Handle QM stuff
    local npcInfo = qmInfo[npc:getID()]

    if npcInfo then
        zone:setLocalVar(npcInfo.varName, 1)
        xi.dynamis.spawnWave(xi.dynamis.wave[zone:getID()][npcInfo.waveIndex])
    end

    -- Each ??? gives 30 minute extension
    -- Make sure it goes invis before applying time
    npc:setStatus(xi.status.DISAPPEAR)
    xi.dynamis.addMinutesToDynamis(zone, 30)

    npc:setLocalVar('timeExtensionUsed', 1)
end
