-----------------------------------
-- Area: Arrapago Reef
--  NM: Lamia No.19
-- TODO: On retail, she walks randomly in her spawn zones rather than using set points. The set points are used here to avoid
--       complications with pathfinding and her long roam range.
-- TODO: Get more data on the reveal chance rate. 80% is an estimate based on current captures.
-- TODO: Get more data on the maximum respawn time. Minimum is 1 hour based on current captures, but more data is needed.
-----------------------------------
mixins = { require('scripts/mixins/weapon_break') }
-----------------------------------
local ID = zones[xi.zone.ARRAPAGO_REEF]

local moveInterval = 25 -- seconds between advancing to the next patrol point

-- 'state' local var: 0 = dormant (invisible, patrolling), 1 = revealed (awaiting engagement), 2 = returning home

-- Patrol zones. She spawns in one at random, starts on its first point, walks the list to the end, then back up, and repeats
local patrolZones =
{
    { -- Zone 1
        { x = -140.3979, y = -7.5625, z = 129.6947 },
        { x = -151.5618, y = -7.5669, z = 133.4263 },
        { x = -159.6965, y = -4.0674, z = 142.4664 },
        { x = -147.8239, y = -3.9370, z = 143.8264 },
        { x = -132.7979, y = -4.1487, z = 142.3289 },
        { x = -116.7645, y = -5.6650, z = 138.4146 },
        { x = -106.3411, y = -3.6548, z = 149.6426 },
        { x =  -95.9528, y = -7.0264, z = 157.3188 },
        { x =  -97.9981, y = -8.2839, z = 177.5508 },
        { x =  -95.9604, y = -6.5235, z = 194.4670 },
        { x =  -97.5012, y = -6.2962, z = 209.2726 },
        { x =  -84.0119, y = -6.6560, z = 216.9704 },
    },
    { -- Zone 2
        { x =  -70.4526, y = -3.4229, z = 225.8736 },
        { x =  -55.8334, y = -6.8534, z = 234.8286 },
        { x =  -52.0121, y = -7.6663, z = 252.0792 },
        { x =  -36.6158, y = -7.1406, z = 255.2419 },
        { x =  -18.6769, y = -4.2378, z = 257.9763 },
        { x =  -23.2517, y = -6.7339, z = 240.1379 },
        { x =  -29.7112, y = -7.3039, z = 226.7537 },
        { x =  -23.0620, y = -8.6800, z = 213.3530 },
        { x =  -27.1148, y = -8.1091, z = 204.9024 },
        { x =   -9.3409, y = -4.1911, z = 209.8858 },
        { x =   -6.8611, y = -3.6151, z = 227.8160 },
    },
    { -- Zone 3
        { x =   24.1552, y = -4.3124, z = 222.5897 },
        { x =   29.0236, y = -7.6649, z = 211.4547 },
        { x =   18.9880, y = -4.6938, z = 199.3556 },
        { x =    7.5865, y = -3.9338, z = 190.0146 },
        { x =   23.4894, y = -8.4546, z = 181.0779 },
        { x =   26.4053, y = -7.4731, z = 163.9737 },
        { x =   16.8353, y = -7.3900, z = 155.6682 },
        { x =    0.1742, y = -1.9985, z = 159.1774 },
    },
}

-- Flat list of every patrol point (all zones, in order), plus the allPoints index of each zone's first point. On the way
-- home she enters this network at the nearest point and walks it back to her own zone's first point, so every leg is a
-- short, walkable hop between adjacent points instead of one long straight line across the map
local allPoints = {}
local zoneStart = {}
for _, zonePoints in ipairs(patrolZones) do
    zoneStart[#zoneStart + 1] = #allPoints + 1
    for _, point in ipairs(zonePoints) do
        allPoints[#allPoints + 1] = point
    end
end

---@type TMobEntity
local entity = {}

-- Tracks deaths she has already handled. Each death gets one reveal chance, evaluated once at the moment of death, so a
-- lingering corpse can't re-trigger. An entry is cleared once that player is alive again (their next death is eligible)
local rolledDeaths = {}

-- Hide her and (re)start the patrol from the first point of a zone. Pass a zoneIndex to keep her in the zone she just returned to; omit it on first spawn to pick a zone at random
local function goDormant(mob, zoneIndex)
    zoneIndex = zoneIndex or math.random(1, #patrolZones)

    mob:setLocalVar('zone', zoneIndex)
    mob:setLocalVar('state', 0)
    mob:setLocalVar('appearTime', 0)
    mob:setLocalVar('wpIndex', 1)    -- current patrol point (she starts on point 1)
    mob:setLocalVar('wpReverse', 0)  -- 0 = walking down the list, 1 = walking back up
    mob:setLocalVar('nextMoveTime', GetSystemTime() + moveInterval)

    mob:setStatus(xi.status.INVISIBLE)
    mob:hideHP(true)
    mob:hideName(true)
    mob:setUntargetable(true)
    mob:setAggressive(false)
    mob:setMobMod(xi.mobMod.ALWAYS_AGGRO, 0)
    mob:setTrueDetection(false)
    mob:setMobMod(xi.mobMod.NO_MOVE, 0)

    -- Start on the zone's first point; movement is driven in onMobRoam
    local first = patrolZones[zoneIndex][1]
    mob:clearPath()
    mob:setPos(first.x, first.y, first.z)
end

-- Index in allPoints of the patrol point nearest her current position
local function nearestIndexInAll(mob)
    local bestIdx, bestDist = 1, nil
    for i, p in ipairs(allPoints) do
        local d = mob:checkDistance(p.x, p.y, p.z)
        if not bestDist or d < bestDist then
            bestIdx, bestDist = i, d
        end
    end

    return bestIdx
end

-- Disengage/give up: enter the patrol-point network at the nearest point and walk it back home
local function startReturningHome(mob)
    -- The fight is over - send any summoned skeletons away so the next engage gets a fresh pair spawned at her side
    local mobId = mob:getID()
    DespawnMob(mobId + 1)
    DespawnMob(mobId + 2)

    mob:setLocalVar('state', 2)
    mob:setLocalVar('returnIndex', nearestIndexInAll(mob)) -- enter the network at the nearest point
    mob:setLocalVar('returnPauseUntil', 0)
    mob:setMobMod(xi.mobMod.NO_MOVE, 0)
    mob:clearPath()

    local wp = allPoints[mob:getLocalVar('returnIndex')]
    mob:pathThrough({ wp.x, wp.y, wp.z })
end

-- Reveal: Teleport onto the corpse, reveal herself, and become aggressive with true sight
local function reveal(mob, player)
    mob:clearPath()
    mob:setMobMod(xi.mobMod.NO_MOVE, 1)
    mob:setPos(player:getXPos(), player:getYPos(), player:getZPos())

    mob:setStatus(xi.status.UPDATE)
    mob:hideHP(false)
    mob:hideName(false)
    mob:setUntargetable(false)

    -- While visible she is always aggressive and has true sight
    mob:setAggressive(true)
    mob:setMobMod(xi.mobMod.ALWAYS_AGGRO, 1)
    mob:setMobMod(xi.mobMod.DETECTION, xi.detects.SIGHT)
    mob:setTrueDetection(true)

    mob:setLocalVar('state', 1)
    mob:setLocalVar('appearTime', GetSystemTime())
end

-- Show the foreboding message (not spoken by her - just a displayed area message) to every player within 30 yalms of the death
local function broadcastForeboding(deadPlayer)
    local zone = deadPlayer:getZone()
    if not zone then
        return
    end

    for _, p in pairs(zone:getPlayers()) do
        if p:checkDistance(deadPlayer) <= 30 then -- the foreboding message is displayed within 30 yalms
            p:messageSpecial(ID.text.FOREBODING)
        end
    end
end

-- Watch for a nearby player death; returns true if she is revealed
local function checkForDeath(mob)
    local zone = mob:getZone()
    if not zone then
        return false
    end

    for _, player in pairs(zone:getPlayers()) do
        local pid = player:getID()

        if not player:isDead() then
            -- Player is alive again; forget the handled death so a later one is eligible for a fresh chance
            rolledDeaths[pid] = nil
        elseif not rolledDeaths[pid] then
            -- First tick we have seen this death: it gets exactly one chance, right now. Mark it immediately whatever the
            -- outcome, so a lingering corpse can never re-trigger; she only reacts to a death that happens close to her
            rolledDeaths[pid] = true

            if mob:checkDistance(player) <= 15 then -- death happened within 15 yalms of her
                -- Show the foreboding message (not spoken by her - just displayed) to everyone near the death
                broadcastForeboding(player)

                -- 80% chance she answers it (estimate from current captures; needs more data for a precise rate)
                if math.random(100) <= 80 then
                    reveal(mob, player)
                    return true
                end
            end
        end
    end

    return false
end

-- Advance one patrol point every moveInterval seconds, going down the zone's list to the end and back up to the start
local function drivePatrol(mob)
    if GetSystemTime() < mob:getLocalVar('nextMoveTime') then
        return
    end

    local points  = patrolZones[mob:getLocalVar('zone')]
    local idx     = mob:getLocalVar('wpIndex')
    local reverse = mob:getLocalVar('wpReverse')

    if reverse == 0 then
        if idx >= #points then
            reverse = 1          -- reached the end; turn around
            idx = idx - 1
        else
            idx = idx + 1
        end
    else
        if idx <= 1 then
            reverse = 0          -- reached the start; turn around
            idx = idx + 1
        else
            idx = idx - 1
        end
    end

    mob:setLocalVar('wpIndex', idx)
    mob:setLocalVar('wpReverse', reverse)
    mob:setLocalVar('nextMoveTime', GetSystemTime() + moveInterval)

    local wp = points[idx]
    mob:pathThrough({ wp.x, wp.y, wp.z })
end

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.SILENCE)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.PETRIFY)
end

entity.onMobSpawn = function(mob)
    -- Don't let the engine drag her back to her DB spawn point (with WALLHACK) while she patrols far from it
    mob:setMobMod(xi.mobMod.DONT_ROAM_HOME, 1)
    goDormant(mob)
    mob:setMod(xi.mod.POWER_MULTIPLIER_SPELL, 20)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
end

entity.onMobRoam = function(mob)
    local state = mob:getLocalVar('state')

    -- Dormant and invisible: walk the patrol and watch for a nearby death
    if state == 0 then
        if not checkForDeath(mob) then
            drivePatrol(mob)
        end

    -- Revealed but never engaged: after the idle timer she gives up and walks home
    elseif state == 1 then
        if GetSystemTime() - mob:getLocalVar('appearTime') >= 120 then -- 2 minutes
            startReturningHome(mob)
        end

    -- Returning: walk the patrol-point network back to her zone's first point, pausing briefly at each, then re-hide
    elseif state == 2 then
        local idx = mob:getLocalVar('returnIndex')
        local wp  = allPoints[idx]

        if mob:checkDistance(wp.x, wp.y, wp.z) <= 3 then -- reached the current point
            local pauseUntil = mob:getLocalVar('returnPauseUntil')
            if pauseUntil == 0 then
                mob:setLocalVar('returnPauseUntil', GetSystemTime() + 3) -- pause ~3s before moving on
            elseif GetSystemTime() >= pauseUntil then
                mob:setLocalVar('returnPauseUntil', 0)

                local target = zoneStart[mob:getLocalVar('zone')]
                if idx == target then
                    goDormant(mob, mob:getLocalVar('zone')) -- back at her first point; hide & patrol
                else
                    idx = idx + (target > idx and 1 or -1) -- step one point toward home
                    mob:setLocalVar('returnIndex', idx)

                    local nxt = allPoints[idx]
                    mob:pathThrough({ nxt.x, nxt.y, nxt.z })
                end
            end
        elseif not mob:isFollowingPath() then
            mob:pathThrough({ wp.x, wp.y, wp.z }) -- path interrupted; resume
        end
    end
end

entity.onMobEngage = function(mob, target)
    -- She was holding position: let her move now that she fights
    mob:setMobMod(xi.mobMod.NO_MOVE, 0)

    -- Summon two Lamia's Skeleton next to her. Their DB spawn points sit by her original spawn, far from where she now
    -- reveals, so place them at her side before spawning or they would appear across the zone
    local mobId = mob:getID()
    local x, y, z = mob:getXPos(), mob:getYPos(), mob:getZPos()

    GetMobByID(mobId + 1):setSpawn(x + 2, y, z)
    GetMobByID(mobId + 2):setSpawn(x - 2, y, z)
    SpawnMob(mobId + 1):updateEnmity(target)
    SpawnMob(mobId + 2):updateEnmity(target)
end

entity.onMobSpellChoose = function(mob, target, spellId)
    local spellList =
    {
        [ 1] = { xi.magic.spell.SLEEPGA_II,  target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.SLEEP_I,    2, 100 },
        [ 2] = { xi.magic.spell.BLIND,       target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BLINDNESS,  0, 100 },
        [ 3] = { xi.magic.spell.ASPIR,       target, false, xi.action.type.DRAIN_MP,             nil,                  0, 100 },
        [ 4] = { xi.magic.spell.STONE_IV,    target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [ 5] = { xi.magic.spell.BIO_II,      target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BIO,        4, 100 },
        [ 6] = { xi.magic.spell.ICE_SPIKES,  mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.ICE_SPIKES, 0, 100 },
        [ 7] = { xi.magic.spell.BIND,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BIND,       0, 100 },
        [ 8] = { xi.magic.spell.FIRE_IV,     target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [ 9] = { xi.magic.spell.POISONGA_II, target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.POISON,     0, 100 },
        [10] = { xi.magic.spell.SLEEPGA,     target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.SLEEP_I,    1, 100 },
        [11] = { xi.magic.spell.FLOOD,       target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [12] = { xi.magic.spell.WATERGA_III, target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [13] = { xi.magic.spell.AERO_IV,     target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [14] = { xi.magic.spell.FIRAGA_III,  target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [15] = { xi.magic.spell.WATER_IV,    target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [16] = { xi.magic.spell.BLIZZARD_IV, target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
    }

    return xi.combat.behavior.chooseAction(mob, target, nil, spellList)
end

entity.onMobDisengage = function(mob)
    -- Combat ended (the player died fighting her, or she lost her target). She walks back along her zone's points; arrival is handled in onMobRoam
    startReturningHome(mob)
end

entity.onMobDespawn = function(mob)
    -- She is never despawned by script, so this only runs when she is killed. Take any summoned skeletons with her and respawn her in 1-3 hours
    local mobId = mob:getID()
    DespawnMob(mobId + 1)
    DespawnMob(mobId + 2)

    mob:setRespawnTime(math.random(3600, 10800)) -- respawn in 1-3 hours
end

return entity
