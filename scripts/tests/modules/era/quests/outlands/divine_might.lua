-----------------------------------
-- Divine Might: the Qu'Hau Spring takes the trades only on a clear full moon night, 00:00 to 03:00.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local function spawnAtSpring(questId)
    local player = xi.test.world:spawnPlayer({ zone = xi.zone.ROMAEVE })
    player:addQuest(xi.questLog.OUTLANDS, questId)
    player:addItem(xi.item.BOTTLE_OF_ILLUMININK)
    player:addItem(xi.item.SHEET_OF_PARCHMENT)
    stub('getVanadielMoonCycle', xi.moonCycle.FULL_MOON)
    player:setWeather(xi.weather.NONE)

    return player
end

describe('Era Divine Might', function()
    local inkAndParchment = { xi.item.BOTTLE_OF_ILLUMININK, xi.item.SHEET_OF_PARCHMENT }

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/outlands/divine_might.lua')
    end)

    it('takes the ink and parchment at 01:00 but not at 20:00', function()
        local player = spawnAtSpring(xi.quest.id.outlands.DIVINE_MIGHT)

        xi.test.world:setVanaTime(20, 0)
        player.actions:tradeNpc('QuHau_Spring', inkAndParchment)
        player.events:expectNotInEvent()

        xi.test.world:setVanaTime(1, 0)
        player.actions:tradeNpc('QuHau_Spring', inkAndParchment, { eventId = 7, finishOption = 0 })
    end)

    describe('spring window #exhaustive', function()
        it('closes at 03:00 and stays closed from 18:00', function()
            local player = spawnAtSpring(xi.quest.id.outlands.DIVINE_MIGHT)

            for _, hour in ipairs({ 3, 5, 18, 23 }) do
                xi.test.world:setVanaTime(hour, 0)
                player.actions:tradeNpc('QuHau_Spring', inkAndParchment)
                player.events:expectNotInEvent()
            end

            xi.test.world:setVanaTime(0, 0)
            player.actions:tradeNpc('QuHau_Spring', inkAndParchment, { eventId = 7, finishOption = 0 })
        end)

        it('stays closed in rain', function()
            local player = spawnAtSpring(xi.quest.id.outlands.DIVINE_MIGHT)
            xi.test.world:setVanaTime(1, 0)

            player:setWeather(xi.weather.RAIN)
            player.actions:tradeNpc('QuHau_Spring', inkAndParchment)
            player.events:expectNotInEvent()

            player:setWeather(xi.weather.SUNSHINE)
            player.actions:tradeNpc('QuHau_Spring', inkAndParchment, { eventId = 7, finishOption = 0 })
        end)

        it('gates both Divine Might (Repeat) trades the same way', function()
            local player = spawnAtSpring(xi.quest.id.outlands.DIVINE_MIGHT_REPEAT)
            player:addItem(xi.item.CHUNK_OF_LIGHT_ORE)

            xi.test.world:setVanaTime(20, 0)
            player.actions:tradeNpc('QuHau_Spring', inkAndParchment)
            player.events:expectNotInEvent()
            player.actions:tradeNpc('QuHau_Spring', { xi.item.CHUNK_OF_LIGHT_ORE })
            player.events:expectNotInEvent()

            xi.test.world:setVanaTime(1, 0)
            player:setWeather(xi.weather.RAIN)
            player.actions:tradeNpc('QuHau_Spring', { xi.item.CHUNK_OF_LIGHT_ORE })
            player.events:expectNotInEvent()

            player:setWeather(xi.weather.NONE)
            player.actions:tradeNpc('QuHau_Spring', { xi.item.CHUNK_OF_LIGHT_ORE }, { eventId = 8, finishOption = 0 })
            player.assert:hasKI(xi.keyItem.MOONLIGHT_ORE)
        end)
    end)
end)
