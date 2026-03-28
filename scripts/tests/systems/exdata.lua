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

    it('can get and set Betting Slip exdata', function()
        local item = player:addItem({ id = xi.item.CHOCOBET_TICKET, quantity = 1 })
        assert(item)

        item:setExData(
            {
                raceId       = 12345,
                raceGrade    = xi.chocoboRacing.raceGrade.C1,
                racePairingL = 3,
                racePairingR = 5,
                quills       = 500,
            })

        local ex = item:getExData()
        assert(ex.raceId == 12345)
        assert(ex.raceGrade == xi.chocoboRacing.raceGrade.C1)
        assert(ex.racePairingL == 3)
        assert(ex.racePairingR == 5)
        assert(ex.quills == 500)
    end)

    it('can get and set Race Certificate exdata', function()
        local item = player:addItem({ id = xi.item.RACE_COMPLETION_CERTIFICATE, quantity = 1 })
        assert(item)

        item:setExData(
            {
                raceId    = 99999,
                raceGrade = xi.chocoboRacing.raceGrade.C3,
            })

        local ex = item:getExData()
        assert(ex.raceId == 99999)
        assert(ex.raceGrade == xi.chocoboRacing.raceGrade.C3)
    end)

    it('can get and set Assault Log exdata', function()
        local item = player:addItem({ id = xi.item.LEUJAOAM_OBSERVATION_LOG, quantity = 1 })
        assert(item)

        item:setExData(
            {
                flags =
                {
                    [1]  = true,
                    [2]  = false,
                    [3]  = true,
                    [4]  = false,
                    [5]  = true,
                    [6]  = false,
                    [7]  = true,
                    [8]  = false,
                    [9]  = true,
                    [10] = false,
                },
            })

        local ex = item:getExData()
        assert(ex.flags[1] == true)
        assert(ex.flags[2] == false)
        assert(ex.flags[3] == true)
        assert(ex.flags[7] == true)
        assert(ex.flags[10] == false)
    end)

    it('can get and set Brenner Book exdata', function()
        local item = player:addItem({ id = xi.item.COPY_OF_THE_BRENNER_BLUEBOOK, quantity = 1 })
        assert(item)

        item:setExData(
            {
                timeValue = 1000000,
                level     = xi.brenner.levelCap.LV50,
            })

        local ex = item:getExData()
        assert(ex.timeValue == 1000000)
        assert(ex.level == xi.brenner.levelCap.LV50)
    end)

    it('can get and set Meeble Grimoire exdata', function()
        local item = player:addItem({ id = xi.item.DILIGENCE_GRIMOIRE, quantity = 1 })
        assert(item)

        item:setExData(
            {
                clears =
                {
                    [xi.meeble.expeditionType.ADJUNCT]        = { [1] = 3, [2] = 2, [3] = 1, [4] = 0 },
                    [xi.meeble.expeditionType.ASSISTANT]      = { [1] = 1, [2] = 0, [3] = 0, [4] = 0 },
                    [xi.meeble.expeditionType.INSTRUCTOR]     = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
                    [xi.meeble.expeditionType.ASC_RESEARCHER] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
                    [xi.meeble.expeditionType.RESEARCHER]     = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
                },
                count  = 5,
                zone   = xi.meeble.zone.SAUROMUGUE_CHAMPAIGN,
            })

        local ex = item:getExData()
        assert(ex.clears[xi.meeble.expeditionType.ADJUNCT][1] == 3)
        assert(ex.clears[xi.meeble.expeditionType.ADJUNCT][2] == 2)
        assert(ex.clears[xi.meeble.expeditionType.ADJUNCT][3] == 1)
        assert(ex.clears[xi.meeble.expeditionType.ADJUNCT][4] == 0)
        assert(ex.clears[xi.meeble.expeditionType.ASSISTANT][1] == 1)
        assert(ex.count == 5)
        assert(ex.zone == xi.meeble.zone.SAUROMUGUE_CHAMPAIGN)
    end)

    it('can get and set Honeymoon Ticket exdata', function()
        local item = player:addItem({ id = xi.item.VCS_HONEYMOON_TICKET, quantity = 1 })
        assert(item)

        item:setExData(
            {
                plan = xi.chocoboRaising.honeymoonPlan.HIKING,
            })

        local ex = item:getExData()
        assert(ex.plan == xi.chocoboRaising.honeymoonPlan.HIKING)
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
