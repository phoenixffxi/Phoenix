-----------------------------------
-- Pre-2014 fame ranks: the old, higher thresholds (rank 5 at 1300) and the client fame check values.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era fame ranks', function()
    local player

    local function rankAt(fame)
        player:setFame(xi.fameArea.SANDORIA, fame)

        return player:getFameLevel(xi.fameArea.SANDORIA)
    end

    setup(function()
        player = xi.test.world:spawnPlayer()
    end)

    after_each(function()
        player:setFame(xi.fameArea.SANDORIA, 0)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/data/fame_rank_points.lua')
    end)

    it('needs 1300 fame for rank 5', function()
        assert(xi.data.fame.rankPoints[5] == 1300, string.format('expected 1300, got %s', tostring(xi.data.fame.rankPoints[5])))
        assert(rankAt(1300) == 5, string.format('expected rank 5 at 1300 fame, got %s', tostring(rankAt(1300))))
    end)

    describe('every rank #exhaustive', function()
        it('sets every rank threshold', function()
            local expected = { 0, 200, 500, 900, 1300, 1700, 1950, 2200, 2450 }

            for rank, points in ipairs(expected) do
                local live = xi.data.fame.rankPoints[rank]
                assert(live == points, string.format('rank %d: expected %d points, got %s', rank, points, tostring(live)))
                assert(rankAt(points) == rank, string.format('expected rank %d at %d fame, got %s', rank, points, tostring(rankAt(points))))

                if rank > 1 then
                    assert(rankAt(points - 1) == rank - 1, string.format('expected rank %d at %d fame, got %s', rank - 1, points - 1, tostring(rankAt(points - 1))))
                end
            end
        end)

        it('sets the client fame check values', function()
            local expected = { 0, 50, 125, 225, 325, 425, 488, 550, 613 }
            local live     = xi.data.fame.fameConversionPoints
            assert(live, 'no fame conversion points')

            for rank, points in ipairs(expected) do
                assert(live[rank] == points, string.format('rank %d: expected %d, got %s', rank, points, tostring(live[rank])))
            end
        end)
    end)
end)
