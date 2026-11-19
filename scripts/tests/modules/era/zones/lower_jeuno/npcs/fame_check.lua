-----------------------------------
-- Fame checkers: Mendi and Namonutice quote fame on the scale their events have baked in.
-----------------------------------
-- Covers: modules/era/lua/zones/southern_san_doria/npcs/fame_check.lua
local moduleTest   = require('scripts.tests.helpers.modules')
local packetReader = require('scripts.tests.helpers.packet_reader')

-- The fame value a fame checker passes to its event.
local function quotedFame(player, npcName, csid)
    player.packets:clear()
    player.entities:gotoAndTrigger(npcName)

    local params = packetReader.lastEventStart(player).params
    player.events:finish(csid)

    return params[0]
end

describe('Era fame checkers', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/zones/lower_jeuno/npcs/fame_check.lua')
        moduleTest.assertOverridesApplied('modules/era/lua/zones/southern_san_doria/npcs/fame_check.lua')
    end)

    it('has Mendi quote Jeuno fame on the event scale', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })
        player:setFame(xi.fameArea.SANDORIA, xi.data.fame.rankPoints[5] + 10)
        player:setFame(xi.fameArea.BASTOK, xi.data.fame.rankPoints[5] + 10)

        local expected = xi.data.fame.fameConversionPoints[player:getFameLevel(xi.fameArea.JEUNO)]
        local quoted   = quotedFame(player, 'Mendi', 82)

        assert(quoted == expected, string.format('expected %d, got %d', expected, quoted))
    end)

    it('has Namonutice quote San d\'Oria fame on the event scale', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })
        player:setFame(xi.fameArea.SANDORIA, xi.data.fame.rankPoints[5] + 10)

        local expected = xi.data.fame.fameConversionPoints[player:getFameLevel(xi.fameArea.SANDORIA)]
        local quoted   = quotedFame(player, 'Namonutice', 31)

        assert(quoted == expected, string.format('expected %d, got %d', expected, quoted))
    end)
end)
