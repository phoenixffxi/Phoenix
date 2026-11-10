-----------------------------------
-- Jailer of Love never brings out Absolute Virtue: its death only clears its pets.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix Jailer of Love without Absolute Virtue', function()
    ---@type CClientEntityPair
    local player
    local ID

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.ALTAIEU })
        ID     = zones[xi.zone.ALTAIEU]
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/zones/AlTaieu/mobs/disable_av_spawn.lua')
    end)

    it('leaves Absolute Virtue at its own spawn point on the lowest roll', function()
        local jailer = player.entities:get(ID.mob.JAILER_OF_LOVE)
        local virtue = player.entities:get(ID.mob.ABSOLUTE_VIRTUE)
        local before = virtue:getSpawnPos()

        -- The lowest roll is the 25 percent that used to call Absolute Virtue onto the Jailer.
        stub('math.randomInt', 1)
        xi.zones.AlTaieu.mobs.Jailer_of_Love.onMobDeath(jailer, player, { isKiller = true })

        local after = virtue:getSpawnPos()
        assert(
            after.x == before.x and
            after.z == before.z,
            string.format('Absolute Virtue moved from (%.1f, %.1f) to (%.1f, %.1f)', before.x, before.z, after.x, after.z)
        )
    end)

    describe('a live Jailer #exhaustive', function()
        it('does not spawn Absolute Virtue after it dies', function()
            local jailer = player.entities:get(ID.mob.JAILER_OF_LOVE)
            local virtue = player.entities:get(ID.mob.ABSOLUTE_VIRTUE)

            jailer:respawn()
            jailer.assert:isAlive()

            stub('math.randomInt', 1)
            xi.zones.AlTaieu.mobs.Jailer_of_Love.onMobDeath(jailer, player, { isKiller = true })

            -- Absolute Virtue used to arrive 10 seconds after the Jailer's death.
            xi.test.world:skipTime(11)
            xi.test.world:tickEntity(jailer)

            virtue.assert.no:isSpawned()
            jailer:despawn()
        end)
    end)
end)
