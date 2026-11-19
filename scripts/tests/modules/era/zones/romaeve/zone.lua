-----------------------------------
-- Ro'Maeve moongates open on a full moon from 00:00 to 03:00 only, and the fountain flows only in clear weather.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Runs a Ro'Maeve zone hook on a full moon at the given Vana'diel hour.
local function onFullMoonAt(hook, hour)
    stub('getVanadielMoonCycle', xi.moonCycle.FULL_MOON)
    xi.test.world:setVanaTime(hour, 0)
    hook(GetZone(xi.zone.ROMAEVE))
end

describe('Era Ro\'Maeve moongates', function()
    local player
    local moongateId

    setup(function()
        player     = xi.test.world:spawnPlayer({ zone = xi.zone.ROMAEVE })
        moongateId = zones[xi.zone.ROMAEVE].npc.MOONGATE_OFFSET
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/zones/romaeve/zone.lua')
    end)

    it('keeps the moongates shut on a full moon evening', function()
        onFullMoonAt(xi.zones.RoMaeve.Zone.onGameHour, 20)

        for _, npcId in ipairs({ moongateId, moongateId + 1 }) do
            local moongate = GetNPCByID(npcId)
            assert(moongate, string.format('no moongate %d', npcId))
            assert(moongate:getAnimation() == xi.animation.CLOSE_DOOR, string.format('moongate %d is open', npcId))
            assert(not moongate:getUntargetable(), string.format('moongate %d is untargetable', npcId))
        end
    end)

    describe('moongate hours #exhaustive', function()
        it('opens the moongates after midnight but keeps the fountain dry in the rain', function()
            player:setWeather(xi.weather.RAIN)

            onFullMoonAt(xi.zones.RoMaeve.Zone.onGameHour, 1)

            assert(GetNPCByID(moongateId):getAnimation() == xi.animation.OPEN_DOOR, 'expected the moongate open')
            assert(GetNPCByID(moongateId + 6):getAnimation() == xi.animation.CLOSE_DOOR, 'the fountain flows in the rain')
        end)

        it('shuts the moongates again at 03:00', function()
            onFullMoonAt(xi.zones.RoMaeve.Zone.onGameHour, 3)

            assert(GetNPCByID(moongateId):getAnimation() == xi.animation.CLOSE_DOOR, 'the moongate is open at 03:00')
        end)

        it('starts the zone with the moongates shut on a full moon evening', function()
            onFullMoonAt(xi.zones.RoMaeve.Zone.onInitialize, 20)

            assert(GetNPCByID(moongateId):getAnimation() == xi.animation.CLOSE_DOOR, 'the moongate is open on a full moon evening')
        end)
    end)
end)
