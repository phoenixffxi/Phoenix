-----------------------------------
-- Phoenix versions of the Spawn Handler cases tools/ci/phoenix/xi_test_skips.md leaves out.
-- custom/lua/claim_shield.lua keeps listed NMs unkillable for 5 seconds after they spawn,
-- and phoenix/data/zones gives Quicksand Caves mobs a 960 second era respawn.
-- Covers: modules/era/lua/globals/old_nm_respawn_timers.lua
-----------------------------------
-- Also ends a case: a shield timer still running would act on the NM's next life in a later case.
local function waitOutClaimShield(mob)
    xi.test.world:skipTime(5)
    xi.test.world:tickEntity(mob)
end

local function killAndRespawn(player, mob, respawnSeconds)
    player:claimAndKillMob(mob)
    xi.test.world:skipTime(respawnSeconds)
    xi.test.world:tick(xi.tick.SPAWN)
end

-- A despawn the mob survives.
local function leaveAlive(mob)
    DespawnMob(mob:getID())
    for _ = 1, 3 do
        xi.test.world:skipTime(5)
        xi.test.world:tickEntity(mob)
    end
end

describe('Spawn Handler', function()
    -- Xolotl in Attohwa Chasm: night spawn with 21-24 hour respawn timer
    describe('timed night spawns', function()
        it('does not respawn killed Xolotl on next night', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.ATTOHWA_CHASM })
            xi.test.world:setVanaTime(22, 0)

            local xolotl = player.entities:get(zones[xi.zone.ATTOHWA_CHASM].mob.XOLOTL)
            xolotl:respawn()
            xi.test.world:tick()
            waitOutClaimShield(xolotl)

            player:claimAndKillMob(xolotl)

            -- Skip to next night (about 24 vana hours)
            xi.test.world:setVanaTime(22, 0)
            xi.test.world:tick(xi.tick.SPAWN)

            xolotl.assert.no:isSpawned()
        end)
    end)

    -- era/lua/globals/old_nm_respawn_timers.lua gives Simurgh its old 21 to 24 hour window
    describe('scripted spawns', function()
        it('respawns Simurgh after kill within respawn window', function()
            local player  = xi.test.world:spawnPlayer({ zone = xi.zone.ROLANBERRY_FIELDS })
            local simurgh = player.entities:get(zones[xi.zone.ROLANBERRY_FIELDS].mob.SIMURGH)

            -- The window rolled at zone load ends within 24 hours.
            xi.test.world:skipTime(86400)
            xi.test.world:tick(xi.tick.SPAWN)
            simurgh.assert:isSpawned()
            waitOutClaimShield(simurgh)

            player:claimAndKillMob(simurgh)

            xi.test.world:skipTime(75600 - 60)
            xi.test.world:tick(xi.tick.SPAWN)
            simurgh.assert.no:isSpawned()

            xi.test.world:skipTime(86400 - 75600 + 60)
            xi.test.world:tick(xi.tick.SPAWN)
            simurgh.assert:isSpawned()
            waitOutClaimShield(simurgh)
        end)
    end)

    describe('lottery slot', function()
        ---@type CClientEntityPair
        local player
        ---@type CTestEntity
        local nm
        ---@type CTestEntity
        local ph

        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.VALKURM_DUNES })
            local ID = zones[xi.zone.VALKURM_DUNES]
            nm = player.entities:get(ID.mob.VALKURM_EMPEROR)
            ph = player.entities:get(ID.mob.VALKURM_EMPEROR - 4)

            xi.test.world:setSlotChance(nm, 100)

            if nm:isSpawned() then
                nm:despawn()
                SpawnMob(ph:getID())
            end
        end)

        it('brings the same NM back after it deaggros', function()
            killAndRespawn(player, ph, 305)
            nm.assert:isSpawned()
            waitOutClaimShield(nm)

            -- notorious mobs walk home instead of despawning, and a Hill Lizard across the zone marks walkable ground far outside the NM's region
            nm:setMobMod(xi.mobMod.NO_DESPAWN, 0)
            local far = player.entities:get(17199263):getPos()
            nm:setPos(far.x, far.y, far.z)
            nm:clearPath()

            for _ = 1, 10 do
                xi.test.world:skipTime(5)
                xi.test.world:tickEntity(nm)
            end

            nm.assert.no:isSpawned()

            xi.test.world:skipTime(65)
            xi.test.world:tick(xi.tick.SPAWN)
            nm.assert:isSpawned()
            ph.assert.no:isSpawned()
            waitOutClaimShield(nm)
        end)

        it('keeps the NM out of the roll until its cooldown ends', function()
            local ID    = zones[xi.zone.VALKURM_DUNES]
            local bat   = player.entities:get(ID.mob.GOLDEN_BAT)
            local batPh = player.entities:get(ID.mob.GOLDEN_BAT - 2)
            xi.test.world:setSlotChance(bat, 100)

            killAndRespawn(player, batPh, 305)
            bat.assert:isSpawned()
            waitOutClaimShield(bat)

            -- the slot rolls again on the NM's own respawn timer
            player:claimAndKillMob(bat)
            xi.test.world:tick(xi.tick.SPAWN)
            batPh.assert.no:isSpawned()

            xi.test.world:skipTime(305)
            xi.test.world:tick(xi.tick.SPAWN)
            batPh.assert:isSpawned()

            killAndRespawn(player, batPh, 305)
            batPh.assert:isSpawned()
            bat.assert.no:isSpawned()

            xi.test.world:skipTime(3600)
            killAndRespawn(player, batPh, 305)
            bat.assert:isSpawned()
            waitOutClaimShield(bat)
        end)
    end)

    -- Nussknacker shares a slot with a Sand Lizard and its script only lets it spawn in a sandstorm
    describe('weather lottery slot', function()
        ---@type CClientEntityPair
        local player
        ---@type CTestEntity
        local nm
        ---@type CTestEntity
        local ph

        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.QUICKSAND_CAVES })
            local ID = zones[xi.zone.QUICKSAND_CAVES]
            nm = player.entities:get(ID.mob.NUSSKNACKER)
            ph = player.entities:get(ID.mob.NUSSKNACKER - 6)

            xi.test.world:setSlotChance(nm, 100)

            -- every case starts in clear weather with the placeholder up and the NM off cooldown
            xi.test.world:skipTime(3600)
            xi.test.world:tick(xi.tick.SPAWN)
            if nm:isSpawned() then
                leaveAlive(nm)
            end

            if not ph:isSpawned() then
                SpawnMob(ph:getID())
            end
        end)

        it('brings the placeholder back in clear weather', function()
            killAndRespawn(player, ph, 965)

            ph.assert:isSpawned()
            nm.assert.no:isSpawned()
        end)

        it('rolls the NM in a sandstorm', function()
            player:setWeather(xi.weather.SAND_STORM)
            killAndRespawn(player, ph, 965)

            nm.assert:isSpawned()
            ph.assert.no:isSpawned()
            waitOutClaimShield(nm)
        end)

        it('does not roll the NM in a dust storm', function()
            player:setWeather(xi.weather.DUST_STORM)
            killAndRespawn(player, ph, 965)

            ph.assert:isSpawned()
            nm.assert.no:isSpawned()
        end)

        it('leaves the NM up when the sandstorm ends', function()
            player:setWeather(xi.weather.SAND_STORM)
            killAndRespawn(player, ph, 965)
            nm.assert:isSpawned()

            player:setWeather(xi.weather.NONE)
            xi.test.world:skipTime(5)
            xi.test.world:tickEntity(nm)
            nm.assert:isSpawned()
        end)
    end)

    -- Citipati shares a slot with its placeholder Corse, and both only spawn from 20:00 to 04:00
    describe('night lottery slot', function()
        it('keeps a killed NM out of the roll until its cooldown ends', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.ATTOHWA_CHASM })
            local ID     = zones[xi.zone.ATTOHWA_CHASM]
            local nm     = player.entities:get(ID.mob.CITIPATI)
            local ph     = player.entities:get(ID.mob.CITIPATI - 1)

            -- start at night with the placeholder up, the NM off cooldown and no roll left over
            xi.test.world:setVanaTime(22, 0)
            xi.test.world:setSlotChance(nm, 100)
            xi.test.world:skipTime(10800)
            xi.test.world:tick(xi.tick.SPAWN)
            if nm:isSpawned() then
                leaveAlive(nm)
            end

            if not ph:isSpawned() then
                SpawnMob(ph:getID())
            end

            killAndRespawn(player, ph, 305)
            nm.assert:isSpawned()
            waitOutClaimShield(nm)

            killAndRespawn(player, nm, 305)
            ph.assert:isSpawned()

            killAndRespawn(player, ph, 305)
            ph.assert:isSpawned()
            nm.assert.no:isSpawned()

            xi.test.world:skipTime(10800)
            killAndRespawn(player, ph, 305)
            nm.assert:isSpawned()
            waitOutClaimShield(nm)
        end)
    end)
end)
