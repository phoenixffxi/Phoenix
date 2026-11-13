-----------------------------------
-- Pre-SoA Scavenge pools: each zone gives its own arrow and bolt parts, Firesand or its ammo boxes.
-----------------------------------
describe('Era Scavenge data', function()
    local player

    -- The era Scavenge reads only these three action methods.
    local action =
    {
        getRecast = function()
            return 300
        end,

        setRecast = function()
        end,

        messageID = function()
        end,
    }

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.EAST_RONFAURE, job = xi.job.RNG, level = 75 })
    end)

    after_each(function()
        player:setLocalVar('[Scavenge]LastX', 0)
        player:setLocalVar('[Scavenge]LastZ', 0)
    end)

    it('finds East Ronfaure stone arrowheads on the first pick', function()
        stub('math.randomInt', 1)

        local itemId = xi.job_utils.ranger.useScavenge(player, player, nil, action)
        assert(itemId == xi.item.HANDFUL_OF_STONE_ARROWHEADS, string.format('expected stone arrowheads, got %s', tostring(itemId)))
        player.assert:hasItem(xi.item.HANDFUL_OF_STONE_ARROWHEADS)
        player:delItem(xi.item.HANDFUL_OF_STONE_ARROWHEADS, 1)
    end)

    describe('every pool #exhaustive', function()
        it('finds the zone\'s ammo box on the last supplies pick', function()
            stub('math.randomInt', function(lower, upper)
                if upper == 100 then
                    return lower
                end

                return upper
            end)

            local itemId = xi.job_utils.ranger.useScavenge(player, player, nil, action)
            assert(itemId == xi.item.RUSTY_BOLT_CASE, string.format('expected a rusty bolt case, got %s', tostring(itemId)))
            player:delItem(xi.item.RUSTY_BOLT_CASE, 1)
        end)

        it('gives every mapped zone four parts and two ammo boxes', function()
            local scavengeData = require('modules/era/lua/data/scavenge_data')
            assert(scavengeData.commonItems[1] == xi.item.JAR_OF_FIRESAND, 'Firesand is not the common item')
            assert(#scavengeData.commonItems == 1, string.format('expected one common item, got %d', #scavengeData.commonItems))

            local zoneCount = 0
            for zoneId, pools in pairs(scavengeData.zonePoolMap) do
                zoneCount = zoneCount + 1
                assert(#pools.scavengePool == 4, string.format('zone %d: expected 4 parts, got %d', zoneId, #pools.scavengePool))
                assert(#pools.ammoPool == 2, string.format('zone %d: expected 2 ammo boxes, got %d', zoneId, #pools.ammoPool))
            end

            assert(zoneCount == 113, string.format('expected 113 zones, got %d', zoneCount))
        end)
    end)
end)
