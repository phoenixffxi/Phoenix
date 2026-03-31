describe('Exdata', function()
    ---@type CClientEntityPair
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer(
        {
            zone = xi.zone.SOUTHERN_SAN_DORIA,
        })
    end)

    it('can get and set Legion Pass exdata', function()
        local item = player:addItem({ id = xi.item.LEGION_PASS, quantity = 1 })
        assert(item)

        local now = GetSystemTime()
        item:setExData(
        {
            timestamp = now + 300,
            title     = xi.legion.title.HALL_OF_AN_36,
            signature = player:getName(),
        })

        local ex = item:getExData()
        assert(ex.timestamp == now + 300)
        assert(ex.title == xi.legion.title.HALL_OF_AN_36)
        assert(ex.signature == player:getName())
    end)

    it('can get and set Perpetual Hourglass exdata', function()
        local item = player:addItem({ id = xi.item.PERPETUAL_HOURGLASS, quantity = 1 })
        assert(item)

        local now = GetSystemTime()
        item:setExData(
        {
            flags     = 0x01,
            startTime = now,
            endTime   = now + 1800,
            zoneId    = xi.zone.DYNAMIS_SAN_DORIA,
        })

        local ex = item:getExData()
        assert(ex.flags == 0x01)
        assert(ex.startTime == now)
        assert(ex.endTime == now + 1800)
        assert(ex.zoneId == xi.zone.DYNAMIS_SAN_DORIA)
    end)

    it('preserves unchanged fields on write-back', function()
        local item = player:addItem({ id = xi.item.LEGION_PASS, quantity = 1 })
        assert(item)

        item:setExData(
        {
            timestamp = 1000,
            title     = xi.legion.title.HALL_OF_KI_18,
            signature = 'TestPlayer',
        })

        local ex = item:getExData()
        ex.title = xi.legion.title.HALL_OF_MURU_36
        item:setExData(ex)

        local ex2 = item:getExData()
        assert(ex2.timestamp == 1000)
        assert(ex2.title == xi.legion.title.HALL_OF_MURU_36)
        assert(ex2.signature == 'TestPlayer')
    end)

    it('addItem accepts exdata table', function()
        local now = GetSystemTime()
        local item = player:addItem(
        {
            id       = xi.item.LEGION_PASS,
            quantity = 1,
            exdata   =
            {
                timestamp = now + 300,
                title     = xi.legion.title.HALL_OF_AN_36,
                signature = 'AddItemTest',
            },
        })
        assert(item)

        local ex = item:getExData()
        assert(ex.timestamp == now + 300)
        assert(ex.title == xi.legion.title.HALL_OF_AN_36)
        assert(ex.signature == 'AddItemTest')
    end)

    it('addItem accepts raw exdata bytes', function()
        local item = player:addItem(
        {
            id       = xi.item.FIRE_CRYSTAL,
            quantity = 1,
            exdata   = { [0] = 0x42, [5] = 0xCD },
        })
        assert(item)

        local ex = item:getExDataRaw()
        assert(ex[0] == 0x42)
        assert(ex[5] == 0xCD)
    end)

    it('raw functions bypass typed dispatch', function()
        local item = player:addItem({ id = xi.item.LEGION_PASS, quantity = 1 })
        assert(item)

        item:setExDataRaw({ [0] = 0xF4, [1] = 0x01 })

        local ex = item:getExData()
        assert(ex.timestamp == 500)
    end)

    it('unhandled items fall back to raw bytes', function()
        local item = player:addItem({ id = xi.item.FIRE_CRYSTAL, quantity = 1 })
        assert(item)

        item:setExDataRaw({ [0] = 0xAB, [5] = 0xCD })

        local ex = item:getExData()
        assert(ex[0] == 0xAB)
        assert(ex[5] == 0xCD)
    end)
end)
