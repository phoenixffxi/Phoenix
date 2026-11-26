-----------------------------------
-- Only Private Second Class assaults are open, and promotions stop at Superior Private.
-- Covers: modules/phoenix/lua/quests/assault_limits.lua
-----------------------------------
local moduleTest   = require('scripts.tests.helpers.modules')
local packetReader = require('scripts.tests.helpers.packet_reader')

-- First parameter of the numbered event the server started, or nil if it started none.
local function firstEventParam(player, eventId)
    for _, packet in ipairs(player.packets:getIncoming()) do
        if
            packet.type == 0x034 and
            packetReader.readU16(packet.data, 0x2C) == eventId
        then
            return packetReader.readU32(packet.data, 0x08)
        end
    end
end

describe('Phoenix Assault Limits', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/quests/assault_limits.lua')
    end)

    it('refuses entry to a Private First Class assault the player holds orders for', function()
        local player  = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE, level = 75 })
        local content = { assaultID = xi.assault.mission.LEBROS_SUPPLIES, requiredOrders = xi.keyItem.LEBROS_ASSAULT_ORDERS }
        player:addKeyItem(xi.keyItem.LEBROS_ASSAULT_ORDERS)
        player:addAssault(xi.assault.mission.LEBROS_SUPPLIES)

        assert(not xi.assault.checkRequirements(player, content), 'a Private First Class assault let the player in')
    end)

    it('withholds the Lance Corporal promotion from a player who has earned it', function()
        local quest  = moduleTest.container('scripts/quests/ahtUrhgan/Promotion_Lance_Corporal')
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
        player:setCharVar('AssaultPromotion', 25)
        player:completeQuest(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.PROMOTION_SUPERIOR_PRIVATE)

        assert(not quest.sections[1].check(player, xi.questStatus.QUEST_AVAILABLE, {}), 'the Lance Corporal promotion is still offered')
    end)

    describe('assault and promotion limits #exhaustive', function()
        it('closes every section of the promotions above Superior Private', function()
            local player   = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
            local zeroVars = setmetatable({}, {
                __index = function()
                    return 0
                end,
            })
            local promotions =
            {
                'Promotion_Lance_Corporal',
                'Promotion_Corporal',
                'Promotion_Sergeant',
                'Promotion_Sergeant_Major',
                'Promotion_Chief_Sergeant',
                'Promotion_Second_Lieutenant',
                'Promotion_First_Lieutenant',
            }

            for _, name in ipairs(promotions) do
                local quest = moduleTest.container('scripts/quests/ahtUrhgan/' .. name)
                for index, section in ipairs(quest.sections) do
                    for _, status in ipairs({ xi.questStatus.QUEST_AVAILABLE, xi.questStatus.QUEST_ACCEPTED }) do
                        assert(not section.check(player, status, zeroVars), string.format('%s section %d is still open', name, index))
                    end
                end
            end
        end)

        it('tells a Superior Private the promotion limit instead of offering Lance Corporal', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
            player:addKeyItem(xi.keyItem.SP_WILDCAT_BADGE)
            player:setCharVar('AssaultPromotion', 25)
            player:completeQuest(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.PROMOTION_PRIVATE_FIRST_CLASS)
            player:completeQuest(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.PROMOTION_SUPERIOR_PRIVATE)
            player.packets:clear()

            player.entities:gotoAndTrigger('Abquhbah', { eventId = 255, finishOption = 0 })

            assert(string.find(table.concat(moduleTest.chatLines(player), '\n'), 'You have reached the current promotion limit', 1, true), 'expected the promotion limit message')
        end)

        it('shows a Superior Private only Private Second Class missions at the counter', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
            player:addKeyItem(xi.keyItem.SP_WILDCAT_BADGE)
            player.packets:clear()

            player.entities:gotoAndTrigger('Famad', { eventId = 275, finishOption = 0 })

            local rank = firstEventParam(player, 275)
            assert(rank == xi.assault.mercenaryRank.PRIVATE_SECOND_CLASS, string.format('the mission menu opened at rank %s', tostring(rank)))
            assert(string.find(table.concat(moduleTest.chatLines(player), '\n'), 'Only Private Second Class Assault missions are currently available', 1, true), 'expected the assault limit message')
        end)

        it('hands out Private Second Class orders but not Private First Class ones', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
            player:addKeyItem(xi.keyItem.SP_WILDCAT_BADGE)
            player:addKeyItem(xi.keyItem.IMPERIAL_ARMY_ID_TAG)

            player.entities:gotoAndTrigger('Famad', { eventId = 275, finishOption = bit.bor(bit.lshift(xi.assault.mission.LEBROS_SUPPLIES, 4), 1) })
            player.assert.no:hasKI(xi.keyItem.LEBROS_ASSAULT_ORDERS)
            player.assert:hasKI(xi.keyItem.IMPERIAL_ARMY_ID_TAG)

            player.entities:gotoAndTrigger('Famad', { eventId = 275, finishOption = bit.bor(bit.lshift(xi.assault.mission.EXCAVATION_DUTY, 4), 1) })
            player.assert:hasKI(xi.keyItem.LEBROS_ASSAULT_ORDERS)
            assert(player:getCurrentAssault() == xi.assault.mission.EXCAVATION_DUTY, 'expected Excavation Duty as the current assault')
        end)

        it('turns a Private First Class instance away at the Runic Seal', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.MOUNT_ZHAYOLM })
            local seal   = player.entities:get('_1p3')
            player:setLocalVar('INSTANCE_ID', xi.assault.instance.LEBROS_SUPPLIES)

            assert(xi.instance.onEventUpdate(player, 0, 0, seal) == false, 'the instance entry went ahead')
            player.assert:hasLocalVar('INSTANCE_REQUESTED', 0)
        end)
    end)
end)
