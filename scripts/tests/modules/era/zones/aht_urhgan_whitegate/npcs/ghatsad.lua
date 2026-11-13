-----------------------------------
-- Choosing an Automaton Frame: Ghatsad takes Tigerfangs and a Repeating Crossbow, finishes frames at
-- JST midnight, and works on a head one coffee-fuelled day at a time, each day ending at JST midnight.
-----------------------------------
local moduleTest   = require('scripts.tests.helpers.modules')
local packetReader = require('scripts.tests.helpers.packet_reader')

local originalFrames =
{
    {
        status = 2,
        items  = { xi.item.BRASS_SHEET, xi.item.WAMOURA_COCOON, xi.item.CHUNK_OF_IMPERIAL_CERMET, xi.item.TIGERFANGS },
    },
    {
        status = 3,
        items  = { xi.item.PIECE_OF_ROSEWOOD_LUMBER, xi.item.SQUARE_OF_KARAKUL_CLOTH, xi.item.SQUARE_OF_KARAKUL_LEATHER, xi.item.REPEATING_CROSSBOW },
    },
}

local workVars =
{
    'PUP_AttachmentStatus',
    'PUP_AttachmentReady',
    'PUP_nextCoffeeTrade',
    '[PUP]FrameCompletion',
    '[PUP]HeadDaysRemaining',
    '[PUP]HeadFueled',
}

local function spawnPuppetmaster()
    local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE, job = xi.job.PUP, level = 75 })
    player:completeQuest(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.NO_STRINGS_ATTACHED)

    return player
end

-- Accepted frame materials move the commission on to the payment step.
local function tradeFrameMaterials(player, frame)
    player:setCharVar('PUP_AttachmentStatus', frame.status)
    for _, itemId in ipairs(frame.items) do
        player:addItem(itemId)
    end

    player.actions:tradeNpc('Ghatsad', frame.items, { eventId = 624 })

    assert(player:getCharVar('PUP_AttachmentStatus') == frame.status + 3, string.format('expected status %d, got %d', frame.status + 3, player:getCharVar('PUP_AttachmentStatus')))
end

-- A Soulsoother Head in the works, with the base script's Vana'diel day timer still running.
local function setHeadWork(player, daysRemaining, fueledUntil)
    player:setCharVar('PUP_AttachmentStatus', 12)
    player:setCharVar('PUP_AttachmentReady', VanadielUniqueDay() + 30)
    player:setCharVar('[PUP]HeadDaysRemaining', daysRemaining)
    player:setCharVar('[PUP]HeadFueled', fueledUntil)
end

-- The params of the head progress event, 903.
local function headProgress(player)
    player.packets:clear()
    player.entities:gotoAndTrigger('Ghatsad')

    local params = packetReader.lastEventStart(player).params
    player.events:finish(903)

    return params
end

describe('Era Ghatsad', function()
    local player

    setup(function()
        player = spawnPuppetmaster()
    end)

    before_each(function()
        for _, name in ipairs(workVars) do
            player:setCharVar(name, 0)
        end
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/zones/aht_urhgan_whitegate/npcs/ghatsad.lua')
    end)

    it('takes Tigerfangs for the Valoredge frame', function()
        tradeFrameMaterials(player, originalFrames[1])
    end)

    it('keeps a paid frame in the works until JST midnight', function()
        player:setCharVar('PUP_AttachmentStatus', 8)
        player:setCharVar('PUP_AttachmentReady', VanadielUniqueDay())
        player:setCharVar('[PUP]FrameCompletion', JstMidnight())

        player.entities:gotoAndTrigger('Ghatsad', { eventId = 626 })
    end)

    describe('frames and heads #exhaustive', function()
        it('takes a Repeating Crossbow for the Sharpshot frame', function()
            tradeFrameMaterials(player, originalFrames[2])
        end)

        it('starts the frame wait when the commission is paid', function()
            xi.zones.Aht_Urhgan_Whitegate.npcs.Ghatsad.onEventFinish(player, 625, 0, nil)

            assert(player:getCharVar('[PUP]FrameCompletion') == JstMidnight(), 'expected the frame to finish at JST midnight')
        end)

        it('hands the frame over once JST midnight has passed', function()
            local puppetmaster = spawnPuppetmaster()
            puppetmaster:setCharVar('PUP_AttachmentStatus', 8)
            puppetmaster:setCharVar('PUP_AttachmentReady', VanadielUniqueDay() + 1)
            puppetmaster:setCharVar('[PUP]FrameCompletion', JstMidnight() - 86400)

            puppetmaster.entities:gotoAndTrigger('Ghatsad', { eventId = 627 })

            assert(puppetmaster:getCharVar('[PUP]FrameCompletion') == 0, 'expected the frame wait to be cleared')
        end)

        it('turns the wait for a commissioned head into days of work', function()
            local puppetmaster = spawnPuppetmaster()
            puppetmaster:unlockAttachment(xi.item.VALOREDGE_HEAD)
            puppetmaster:unlockAttachment(xi.item.SHARPSHOT_HEAD)
            puppetmaster:unlockAttachment(xi.item.STORMWAKER_HEAD)
            puppetmaster:setCharVar('PUP_AttachmentStatus', 11)
            puppetmaster:addItem(xi.item.WHITE_PUPPET_TURBAN)
            puppetmaster:addItem(xi.item.SCROLL_OF_CURE_II)
            puppetmaster:addItem(xi.item.IMPERIAL_MYTHRIL_PIECE, 2)

            puppetmaster.actions:tradeNpc('Ghatsad', {
                xi.item.WHITE_PUPPET_TURBAN,
                xi.item.SCROLL_OF_CURE_II,
                { itemId = xi.item.IMPERIAL_MYTHRIL_PIECE, quantity = 2 },
            }, { eventId = 902 })

            assert(puppetmaster:getCharVar('[PUP]HeadDaysRemaining') == 5, string.format('expected 5 days of work, got %d', puppetmaster:getCharVar('[PUP]HeadDaysRemaining')))
            assert(puppetmaster:getCharVar('[PUP]HeadFueled') == JstMidnight(), 'expected the commission day to be worked until JST midnight')
        end)

        it('reports the days left on a head he is working on', function()
            setHeadWork(player, 3, JstMidnight())

            local params = headProgress(player)

            assert(params[0] == 3 and params[1] == 1, string.format('expected [3, 1], got [%d, %d]', params[0], params[1]))
        end)

        it('dozes until he gets the day\'s coffee', function()
            setHeadWork(player, 3, 0)

            local params = headProgress(player)

            assert(params[0] == 3 and params[1] == 0, string.format('expected [3, 0], got [%d, %d]', params[0], params[1]))
        end)

        it('counts a fuelled day as done once JST midnight has passed', function()
            setHeadWork(player, 3, JstMidnight() - 86400)

            local params = headProgress(player)

            assert(params[0] == 2 and params[1] == 0, string.format('expected [2, 0], got [%d, %d]', params[0], params[1]))
            assert(player:getCharVar('[PUP]HeadDaysRemaining') == 2, 'expected two days of work left')
        end)

        it('finishes the head when the last fuelled day is done', function()
            local puppetmaster = spawnPuppetmaster()
            setHeadWork(puppetmaster, 1, JstMidnight() - 86400)

            puppetmaster.entities:gotoAndTrigger('Ghatsad', { eventId = 905 })

            assert(puppetmaster:hasAttachment(xi.item.SOULSOOTHER_HEAD), 'expected the Soulsoother Head')
        end)

        it('works until JST midnight on the day\'s coffee', function()
            setHeadWork(player, 2, 0)
            player:addItem(xi.item.CUP_OF_IMPERIAL_COFFEE)

            player.actions:tradeNpc('Ghatsad', { xi.item.CUP_OF_IMPERIAL_COFFEE }, { eventId = 904 })

            assert(player:getCharVar('[PUP]HeadFueled') == JstMidnight(), 'expected the coffee to fuel work until JST midnight')
        end)

        it('turns down a second coffee on a fuelled day', function()
            setHeadWork(player, 2, JstMidnight())
            player:addItem(xi.item.CUP_OF_IMPERIAL_COFFEE)

            player.actions:tradeNpc('Ghatsad', { xi.item.CUP_OF_IMPERIAL_COFFEE })

            player.events:expectNotInEvent()
            player.assert:hasItem(xi.item.CUP_OF_IMPERIAL_COFFEE)
        end)

        it('clears the work vars when a frame or head is handed over', function()
            for _, csid in ipairs({ 627, 905 }) do
                player:setCharVar('[PUP]FrameCompletion', JstMidnight())
                player:setCharVar('[PUP]HeadDaysRemaining', 1)
                player:setCharVar('[PUP]HeadFueled', JstMidnight())

                xi.zones.Aht_Urhgan_Whitegate.npcs.Ghatsad.onEventFinish(player, csid, 0, nil)

                assert(player:getCharVar('[PUP]FrameCompletion') == 0, string.format('event %d left the frame wait', csid))
                assert(player:getCharVar('[PUP]HeadDaysRemaining') == 0, string.format('event %d left the head days', csid))
                assert(player:getCharVar('[PUP]HeadFueled') == 0, string.format('event %d left the coffee', csid))
            end
        end)
    end)
end)
