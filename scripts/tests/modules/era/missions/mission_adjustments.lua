-----------------------------------
-- Mission Adjustments: ToAU and San d'Oria missions wait for JST midnight between steps.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Mission Adjustments', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/missions/mission_adjustments.lua')
    end)

    it('holds Knight of Gold until JST midnight after the Mog Locker scene', function()
        local player    = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
        local mission   = moduleTest.container('scripts/missions/toau/03_President_Salaheem')
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]
        player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.PRESIDENT_SALAHEEM)

        whitegate.onEventFinish[73](player, 73, 0, nil)
        mission:setVar(player, 'mustZone', 0)

        local action = whitegate['Naja_Salaheem'].onTrigger(player, nil)
        assert(action.id == 3003, string.format('expected the default dialogue 3003 after zoning, got %s', tostring(action.id)))
    end)

    describe('each patched mission #exhaustive', function()
        local player

        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
        end)

        it('holds Easterly Winds until JST midnight', function()
            local confessions = moduleTest.container('scripts/missions/toau/05_Confessions_of_Royalty')
            local easterly    = moduleTest.container('scripts/missions/toau/06_Easterly_Winds')
            local rulude      = easterly.sections[1][xi.zone.RULUDE_GARDENS]
            player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.CONFESSIONS_OF_ROYALTY)

            confessions.sections[1][xi.zone.CHATEAU_DORAGUILLE].onEventFinish[564](player, 564, 1, nil)

            assert(easterly:getVar(player, 'Timer') == 1, 'expected the JST midnight timer to start')
            assert(rulude.onTriggerAreaEnter[1](player, nil) == nil, 'Easterly Winds started before JST midnight')

            easterly:setVar(player, 'Timer', 0)
            local action = rulude.onTriggerAreaEnter[1](player, nil)
            assert(action and action.id == 10094, 'expected Easterly Winds to start once the timer ran out')
        end)

        it('holds A Mercenary Life until JST midnight', function()
            local westerly  = moduleTest.container('scripts/missions/toau/07_Westerly_Winds')
            local mercenary = moduleTest.container('scripts/missions/toau/08_A_Mercenary_Life')
            local whitegate = mercenary.sections[2][xi.zone.AHT_URHGAN_WHITEGATE]
            player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.WESTERLY_WINDS)

            westerly.sections[1][xi.zone.AHT_URHGAN_WHITEGATE].onEventFinish[3028](player, 3028, 0, nil)

            assert(mercenary:getVar(player, 'Timer') == 1, 'expected the JST midnight timer to start')
            assert(whitegate.onTriggerAreaEnter[3](player, nil) == nil, 'A Mercenary Life started before JST midnight')

            mercenary:setVar(player, 'Timer', 0)
            local action = whitegate.onTriggerAreaEnter[3](player, nil)
            assert(action and action.id == 3050, 'expected A Mercenary Life to start once the timer ran out')
        end)

        it('closes Passing Glory until JST midnight', function()
            local guests = moduleTest.container('scripts/missions/toau/17_Guests_of_the_Empire')
            local glory  = moduleTest.container('scripts/missions/toau/18_Passing_Glory')
            player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.GUESTS_OF_THE_EMPIRE)

            guests.sections[1][xi.zone.AHT_URHGAN_WHITEGATE].onEventFinish[3078](player, 3078, 0, nil)

            assert(glory:getVar(player, 'Timer') == 1, 'expected the JST midnight timer to start')
            assert(not glory.sections[1].check(player, xi.mission.id.toau.PASSING_GLORY, 0, {}), 'Passing Glory opened before JST midnight')

            glory:setVar(player, 'Timer', 0)
            assert(glory.sections[1].check(player, xi.mission.id.toau.PASSING_GLORY, 0, {}), 'expected Passing Glory to open once the timer ran out')
        end)

        it('holds Playing the Part until JST midnight', function()
            local foiled  = moduleTest.container('scripts/missions/toau/24_Foiled_Ambition')
            local playing = moduleTest.container('scripts/missions/toau/25_Playing_the_Part')
            local naja    = playing.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]['Naja_Salaheem']
            player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.FOILED_AMBITION)

            foiled.sections[1][xi.zone.AHT_URHGAN_WHITEGATE].onEventFinish[3097](player, 3097, 0, nil)

            assert(playing:getVar(player, 'Timer') == 1, 'expected the JST midnight timer to start')
            local action = naja.onTrigger(player, nil)
            assert(action.id == 3098, string.format('expected the waiting dialogue 3098, got %s', tostring(action.id)))

            playing:setVar(player, 'Timer', 0)
            action = naja.onTrigger(player, nil)
            assert(action.id == 3110, string.format('expected Playing the Part to start with 3110, got %s', tostring(action.id)))
        end)

        it("holds Sentinels' Honor until JST midnight", function()
            local blood     = moduleTest.container('scripts/missions/toau/32_In_the_Blood')
            local sentinels = moduleTest.container('scripts/missions/toau/33_Sentinels_Honor')
            local naja      = sentinels.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]['Naja_Salaheem']
            player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.IN_THE_BLOOD)

            blood.sections[1][xi.zone.AHT_URHGAN_WHITEGATE].onEventFinish[3113](player, 3113, 0, nil)

            assert(sentinels:getVar(player, 'Timer') == 1, 'expected the JST midnight timer to start')
            local action = naja.onTrigger(player, nil)
            assert(action.id == 3120, string.format('expected the waiting dialogue 3120, got %s', tostring(action.id)))

            sentinels:setVar(player, 'Timer', 0)
            action = naja.onTrigger(player, nil)
            assert(action.id == 3130, string.format("expected Sentinels' Honor to start with 3130, got %s", tostring(action.id)))
        end)

        it('closes Stirrings of War until JST midnight', function()
            local path      = moduleTest.container('scripts/missions/toau/37_Path_of_Blood')
            local stirrings = moduleTest.container('scripts/missions/toau/38_Stirrings_of_War')
            player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.PATH_OF_BLOOD)

            path.sections[1][xi.zone.AHT_URHGAN_WHITEGATE].onEventFinish[3220](player, 3220, 0, nil)

            assert(stirrings:getVar(player, 'Timer') == 1, 'expected the JST midnight timer to start')
            assert(not stirrings.sections[1].check(player, xi.mission.id.toau.STIRRINGS_OF_WAR, 0, {}), 'Stirrings of War opened before JST midnight')

            stirrings:setVar(player, 'Timer', 0)
            assert(stirrings.sections[1].check(player, xi.mission.id.toau.STIRRINGS_OF_WAR, 0, {}), 'expected Stirrings of War to open once the timer ran out')
        end)

        it("keeps the gate guards deciphering Ranperre's book until JST midnight", function()
            local mission  = moduleTest.container('scripts/missions/sandoria/6_2_Ranperres_Final_Rest')
            local southern = mission.sections[2][xi.zone.SOUTHERN_SAN_DORIA]
            local northern = mission.sections[2][xi.zone.NORTHERN_SAN_DORIA]
            player:addMission(xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.RANPERRES_FINAL_REST)

            southern.onEventFinish[1035](player, 1035, 0, nil)
            assert(mission:getVar(player, 'Timer') == 1, 'expected the JST midnight timer to start')

            -- A zone change lifts the base hold; the deciphering wait stays.
            player:setLocalVar('Mission[0][17]requiredToZone', 0)

            local waits =
            {
                { section = southern, name = 'Ambrotien', eventId = 1038 },
                { section = southern, name = 'Endracion', eventId = 1037 },
                { section = northern, name = 'Grilau',    eventId = 1037 },
            }

            for _, guard in ipairs(waits) do
                local action = guard.section[guard.name].onTrigger(player, nil)
                assert(action.id == guard.eventId, string.format('expected %s to play %d, got %s', guard.name, guard.eventId, tostring(action.id)))
            end
        end)

        it('starts the deciphering wait from every gate guard handover', function()
            local mission  = moduleTest.container('scripts/missions/sandoria/6_2_Ranperres_Final_Rest')
            local southern = mission.sections[2][xi.zone.SOUTHERN_SAN_DORIA]
            local northern = mission.sections[2][xi.zone.NORTHERN_SAN_DORIA]
            player:addMission(xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.RANPERRES_FINAL_REST)

            local handovers =
            {
                { section = southern, eventId = 1035 },
                { section = southern, eventId = 1036 },
                { section = northern, eventId = 1035 },
            }

            for _, handover in ipairs(handovers) do
                mission:setVar(player, 'Timer', 0)
                handover.section.onEventFinish[handover.eventId](player, handover.eventId, 0, nil)
                assert(mission:getVar(player, 'Timer') == 1, string.format('event %d did not start the timer', handover.eventId))
            end
        end)

        it('holds the Coming of Age finale until JST midnight', function()
            local mission = moduleTest.container('scripts/missions/sandoria/8_1_Coming_of_Age')
            player:addMission(xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.COMING_OF_AGE)

            mission.sections[2][xi.zone.CHATEAU_DORAGUILLE].onEventFinish[102](player, 102, 0, nil)

            assert(mission:getVar(player, 'Progress') == JstMidnight(), 'expected the finale to wait for JST midnight')
        end)
    end)
end)
