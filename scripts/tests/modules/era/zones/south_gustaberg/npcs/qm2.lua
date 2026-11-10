-----------------------------------
-- Smoke on the Mountain: meat on the South Gustaberg campfire cooks for one Vana'diel day.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era South Gustaberg campfire', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/zones/south_gustaberg/npcs/qm2.lua')
    end)

    it('cooks the meat for one Vana\'diel day', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTH_GUSTABERG })
        player:addItem(xi.item.SLICE_OF_GIANT_SHEEP_MEAT)

        local before = GetSystemTime()
        player.actions:tradeNpc('qm2', { xi.item.SLICE_OF_GIANT_SHEEP_MEAT })
        local after  = GetSystemTime()

        local doneAt = player:getCharVar('SouthGustabergCampfire')
        assert(doneAt >= before + xi.vanaTime.DAY and doneAt <= after + xi.vanaTime.DAY, string.format('expected about %d, got %d', before + xi.vanaTime.DAY, doneAt))
    end)
end)
