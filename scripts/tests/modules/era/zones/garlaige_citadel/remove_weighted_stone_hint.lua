-----------------------------------
-- Pouch of Weighted Stones: the banishing gates give no hint and do not open for the key item.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Each gate, and a spot on the side where it shows its message.
local gates =
{
    { name = '_5k0', x = -203, y = -3, z = 220 },
    { name = '_5k9', x = -100, y = -3, z =  83 },
    { name = '_5ki', x = -100, y = -3, z = 357 },
}

-- Whether the zone sent the message since the last packet clear.
local function sentMessage(player, messageId)
    for _, packet in ipairs(player.packets:getIncoming()) do
        if
            packet.type == 0x02A and
            bit.band(packet.data[0x1A] + packet.data[0x1B] * 256, 0x7FFF) == messageId
        then
            return true
        end
    end

    return false
end

local function triggerGate(player, gate)
    player:setPos(gate.x, gate.y, gate.z)
    player.packets:clear()
    player.actions:trigger(player.entities:get(gate.name))
end

describe('Era Garlaige banishing gates', function()
    local player
    local ID

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.GARLAIGE_CITADEL })
        ID     = zones[xi.zone.GARLAIGE_CITADEL]
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/zones/garlaige_citadel/remove_weighted_stone_hint.lua')
    end)

    it('gives no hint about the Pouch of Weighted Stones', function()
        triggerGate(player, gates[1])

        assert(not sentMessage(player, ID.text.YOU_COULD_OPEN_THE_GATE), 'the gate hinted at the Pouch of Weighted Stones')
    end)

    describe('every gate #exhaustive', function()
        for _, gate in ipairs(gates) do
            it(string.format('keeps %s shut for the Pouch of Weighted Stones', gate.name), function()
                triggerGate(player, gate)
                assert(not sentMessage(player, ID.text.YOU_COULD_OPEN_THE_GATE), 'the gate hinted at the Pouch of Weighted Stones')

                player:addKeyItem(xi.keyItem.POUCH_OF_WEIGHTED_STONES)
                triggerGate(player, gate)
                xi.test.world:skipTime(2)
                xi.test.world:tick()
                player:delKeyItem(xi.keyItem.POUCH_OF_WEIGHTED_STONES)

                assert(not sentMessage(player, ID.text.THE_GATE_OPENS_FOR_YOU), 'the gate opened for the Pouch of Weighted Stones')
                player.entities:get(gate.name).assert:hasAnimation(xi.animation.CLOSE_DOOR)
            end)
        end
    end)
end)
