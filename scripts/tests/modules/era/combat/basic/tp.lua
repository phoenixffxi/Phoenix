-----------------------------------
-- Pre-SoA TP gain: players get TP from the same delay table as mobs.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era TP gain', function()
    local player

    local function expectTPReturn(delay, expected)
        local tpReturn = xi.combat.tp.calculateTPReturn(player, delay)
        assert(tpReturn == expected, string.format('delay %d: expected %d TP, got %s', delay, expected, tostring(tpReturn)))
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/combat/basic/tp.lua')
    end)

    it('gives a player 64 TP for a 240 delay hit', function()
        expectTPReturn(240, 64)
    end)

    describe('every delay band #exhaustive', function()
        it('follows the mob table from fast to slow weapons', function()
            expectTPReturn(100, 43)
            expectTPReturn(180, 50)
            expectTPReturn(300, 78)
            expectTPReturn(460, 120)
            expectTPReturn(500, 136)
            expectTPReturn(600, 150)
        end)
    end)
end)
