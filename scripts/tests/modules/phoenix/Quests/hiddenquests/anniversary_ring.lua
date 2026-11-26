-----------------------------------
-- New characters get an Anniversary Ring with the Adventurer's Coupon, on their first opening cutscene only.
-- Covers: modules/phoenix/lua/quests/hiddenquests/anniversary_ring.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix Anniversary Ring', function()
    local quest

    setup(function()
        quest = moduleTest.container('scripts/quests/hiddenQuests/New_Character_Cutscenes')
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/quests/hiddenquests/anniversary_ring.lua')
    end)

    it('gives the ring with the coupon at the end of the Bastok Markets opening', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.BASTOK_MARKETS })

        quest.sections[1][xi.zone.BASTOK_MARKETS].onEventFinish[7](player, 7, 0, nil)

        player.assert:hasItem(xi.item.ADVENTURER_COUPON)
        player.assert:hasItem(xi.item.ANNIVERSARY_RING)
    end)

    describe('opening cutscenes #exhaustive', function()
        local openings =
        {
            { name = 'Bastok Mines',         zoneId = xi.zone.BASTOK_MINES,       eventId = 1   },
            { name = 'Port Bastok',          zoneId = xi.zone.PORT_BASTOK,        eventId = 1   },
            { name = 'Northern San d\'Oria', zoneId = xi.zone.NORTHERN_SAN_DORIA, eventId = 535 },
            { name = 'Southern San d\'Oria', zoneId = xi.zone.SOUTHERN_SAN_DORIA, eventId = 503 },
            { name = 'Port San d\'Oria',     zoneId = xi.zone.PORT_SAN_DORIA,     eventId = 500 },
            { name = 'Windurst Waters',      zoneId = xi.zone.WINDURST_WATERS,    eventId = 531 },
            { name = 'Windurst Woods',       zoneId = xi.zone.WINDURST_WOODS,     eventId = 367 },
            { name = 'Port Windurst',        zoneId = xi.zone.PORT_WINDURST,      eventId = 305 },
        }

        for _, opening in ipairs(openings) do
            it(string.format('gives the ring at the end of the %s opening', opening.name), function()
                local player = xi.test.world:spawnPlayer({ zone = opening.zoneId })

                quest.sections[1][opening.zoneId].onEventFinish[opening.eventId](player, opening.eventId, 0, nil)

                player.assert:hasItem(xi.item.ANNIVERSARY_RING)
            end)
        end

        it('gives no second ring when a nation change replays the opening', function()
            local player  = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS })
            local handler = quest.sections[1][xi.zone.WINDURST_WOODS].onEventFinish[367]

            handler(player, 367, 0, nil)
            player.assert:hasItem(xi.item.ANNIVERSARY_RING)
            player:delItem(xi.item.ANNIVERSARY_RING, 1)

            handler(player, 367, 0, nil)
            player.assert.no:hasItem(xi.item.ANNIVERSARY_RING)
        end)
    end)
end)
