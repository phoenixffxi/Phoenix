-----------------------------------
-- Phoenix version of the systems/trading/event_storage.lua cases that charge the withdrawal fee.
-- era/lua/globals/event_storage.lua keeps the 500 gil fee from before the December 2008 update.
-----------------------------------
describe('Event Storage NPCs', function()
    ---@type CClientEntityPair
    local player

    -- Garridan in Port Jeuno.
    local storeEventId = 307
    local menuEventId  = 308

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.PORT_JEUNO })
        player:setGil(1000)
    end)

    it('stores a former race variant and returns the current one', function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.PORT_JEUNO, race = xi.race.MITHRA })
        player:setGil(1000)
        player:addItem(xi.item.HUME_GILET)
        player.actions:tradeNpc('Garridan', { xi.item.HUME_GILET }, { eventId = storeEventId })

        player.entities:gotoAndTrigger('Garridan', { eventId = menuEventId, finishOption = 50 })

        player.assert:hasItem(xi.item.MITHRA_TOP)
        assert(player:getGil() == 500, 'the 500 gil fee was not charged')
    end)

    it('stores a former gender variant and returns the current one', function()
        player:addItem(xi.item.OMINA_YUKATA)
        player.actions:tradeNpc('Garridan', { xi.item.OMINA_YUKATA }, { eventId = storeEventId })

        player.entities:gotoAndTrigger('Garridan', { eventId = menuEventId, finishOption = 48 })

        player.assert:hasItem(xi.item.ONOKO_YUKATA)
        assert(player:getGil() == 500, 'the 500 gil fee was not charged')
    end)

    it('hands the item back for the fee with its recast reset', function()
        -- The Moogle Cap is the thirteenth head slot, so bit 12 and option 44.
        player:setCharVar('[eventStorage]head', 4096)
        player.entities:gotoAndTrigger('Garridan', { eventId = menuEventId, finishOption = 44 })

        player.assert:hasItem(xi.item.MOOGLE_CAP)
        assert(player:getGil() == 500, 'the 500 gil fee was not charged')

        local cap = player:findItem(xi.item.MOOGLE_CAP)
        assert(cap)
        local lastUse = cap:getExData().timeValue1
        assert(lastUse and math.abs(lastUse - VanadielTime()) <= 5, 'the enchantment recast was not reset')
    end)
end)
