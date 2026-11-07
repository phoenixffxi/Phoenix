-----------------------------------
-- Phoenix version of systems/pathing/dynamis_jeuno_roam_pathing.lua.
-- The old-school layout (phoenix/data/zones/dynamis_jeuno) puts the nearest Vanguard Armorer on the
-- Mog House floor, so this one uses the nearest Armorer spawned a floor above it.
-----------------------------------
describe('Dynamis - Jeuno roam pathing away from the spawn anchor', function()
    local mogHouse = { x = 48.930, y = 10.002, z = -71.032 }
    local stairs   = { x = 49.057, y = 7.250, z = -44.000 }

    local function distance(a, b)
        local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
        return math.sqrt(dx * dx + dy * dy + dz * dz)
    end

    it('roams out via the staircase instead of cutting straight at the spawn anchor', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.DYNAMIS_JEUNO })

        local nearest         = nil
        local nearestDistance = math.huge
        for _, entity in ipairs(player:getZone():queryEntitiesByName('Vanguard_Armorer')) do
            local spawnPos      = entity:getSpawnPos()
            local spawnDistance = distance(spawnPos, mogHouse)
            if
                mogHouse.y - spawnPos.y > 9.0 and
                spawnDistance < nearestDistance
            then
                nearest         = entity
                nearestDistance = spawnDistance
            end
        end

        assert(nearest, 'no Vanguard Armorer spawns a floor above the Mog House')

        local mob   = player.entities:get(nearest:getID())
        local spawn = mob:getSpawnPos()
        assert(distance(mogHouse, spawn) < 50.0, 'Mog House should be inside roam range of the spawn point')

        mob:respawn()
        mob:clearPath()

        -- Tick past the post-spawn window.
        for _ = 1, 5 do
            xi.test.world:skipTime(5)
            xi.test.world:tickEntity(mob)
        end

        mob:setPos(mogHouse.x, mogHouse.y, mogHouse.z)
        mob:clearPath()
        mob:pathTo(spawn.x, spawn.y, spawn.z)

        local moved        = 0.0
        local nearestStair = math.huge

        for _ = 1, 90 do
            xi.test.world:skipTime(1)
            xi.test.world:tickEntity(mob)

            local pos    = mob:getPos()
            moved        = math.max(moved, distance(pos, mogHouse))
            nearestStair = math.min(nearestStair, distance(pos, stairs))
        end

        assert(moved > 1.0, 'mob should have roamed off the Mog House')
        assert(nearestStair < 6.0,
            string.format('mob should have reached the staircase; closest was %.1fy', nearestStair))
    end)
end)
