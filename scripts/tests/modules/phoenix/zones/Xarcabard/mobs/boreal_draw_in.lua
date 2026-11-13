-----------------------------------
-- The Boreal NMs in Xarcabard draw a target back from outside their tunnel at any distance instead
-- of disengaging, and skip their path point pauses while engaged.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix Boreal NM draw-in', function()
    ---@type CClientEntityPair
    local player

    -- Spots outside each tunnel (more than 10 yalms from the NM) and inside it.
    local tunnels =
    {
        { name = 'Boreal_Coeurl', outside = { 580, -9, 245 },   inside = { 580, -9, 285 }   },
        { name = 'Boreal_Hound',  outside = { 5, -25, -445 },   inside = { -21, -25, -485 } },
        { name = 'Boreal_Tiger',  outside = { 341, -29, 320 },  inside = { 341, -29, 365 }  },
    }

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.XARCABARD })
    end)

    before_each(function()
        player:setLocalVar('[Draw-In]WaitTime', 0)
    end)

    it('applies its overrides', function()
        local targets = {}
        for _, tunnel in ipairs(tunnels) do
            table.insert(targets, string.format('xi.zones.Xarcabard.mobs.%s.onPathPoint', tunnel.name))
            table.insert(targets, string.format('xi.zones.Xarcabard.mobs.%s.onMobFight', tunnel.name))
        end

        moduleTest.assertOverridesApplied('modules/phoenix/lua/zones/Xarcabard/mobs/boreal_draw_in.lua', { targets = targets })
    end)

    it('holds a far target outside the tunnel for a draw-in instead of disengaging', function()
        local tiger = player.entities:get('Boreal_Tiger')

        player:setPos(341, -29, 320)
        xi.zones.Xarcabard.mobs.Boreal_Tiger.onMobFight(tiger, player)

        local noMove   = tiger:getMobMod(xi.mobMod.NO_MOVE)
        local waitTime = player:getLocalVar('[Draw-In]WaitTime')
        tiger:setMobMod(xi.mobMod.NO_MOVE, 0)

        assert(noMove == 1, 'Boreal Tiger is free to move')
        assert(waitTime > 0, 'no draw-in is pending')
    end)

    describe('each NM #exhaustive', function()
        for _, tunnel in ipairs(tunnels) do
            it(string.format('draws a far target back to %s and frees it inside the tunnel', tunnel.name), function()
                local mob   = player.entities:get(tunnel.name)
                local fight = xi.zones.Xarcabard.mobs[tunnel.name].onMobFight

                player:setPos(unpack(tunnel.outside))
                fight(mob, player)
                assert(mob:getMobMod(xi.mobMod.NO_MOVE) == 1, string.format('%s is free to move', tunnel.name))

                -- Past the 2 second wait the target is drawn to the NM.
                local drawIn = spy('DrawIn')
                player:setLocalVar('[Draw-In]WaitTime', GetSystemTime() - 1)
                fight(mob, player)
                drawIn:called(1)

                local mobPos = mob:getPos()
                local toPos  = drawIn.calls[1].args[2]
                assert(
                    toPos.x == mobPos.x and
                    toPos.z == mobPos.z,
                    string.format('drawn to (%.1f, %.1f) instead of %s', toPos.x, toPos.z, tunnel.name)
                )

                player:setPos(unpack(tunnel.inside))
                fight(mob, player)
                assert(mob:getMobMod(xi.mobMod.NO_MOVE) == 0, string.format('%s stays rooted inside its tunnel', tunnel.name))
                assert(player:getLocalVar('[Draw-In]WaitTime') == 0, 'a draw-in is pending inside the tunnel')
            end)
        end

        it('skips the path point pause while engaged', function()
            -- The upstream pause rolls 50 percent, so the lowest roll always pauses.
            stub('math.randomInt', 1)

            for _, tunnel in ipairs(tunnels) do
                local calls       = 0
                local engagedMob  = setmetatable(
                {
                    isEngaged = function()
                        return true
                    end,
                },
                {
                    __index = function()
                        return function()
                            calls = calls + 1
                        end
                    end,
                })

                xi.zones.Xarcabard.mobs[tunnel.name].onPathPoint(engagedMob)
                assert(calls == 0, string.format('engaged %s paused at a path point', tunnel.name))
            end
        end)
    end)
end)
