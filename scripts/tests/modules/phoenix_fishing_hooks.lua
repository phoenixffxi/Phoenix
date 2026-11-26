-----------------------------------
-- Sends real fishing packets through modules/phoenix/cpp/fishing_hooks.cpp
-- Covers: modules/phoenix/cpp/fishing_hooks.cpp
-- Covers: modules/phoenix/cpp/fishing_history.cpp
-----------------------------------
---@diagnostic disable: undefined-field, undefined-global
-- luacheck: globals GetFishingHistory GetFishingRecords GetFishingAttempts
local ffi          = require('ffi')
local packetReader = require('scripts.tests.helpers.packet_reader')

local actionPacket  = 0x01A
local fishingPacket = 0x110
local fishPacket    = 0x115
local fishActionId  = 0x0E
local checkHook     = 2
local endMiniGame   = 3
local release       = 4
local reeledIn      = 0
local gaveUp        = 200
local outcomeReeled = 1
local outcomeGaveUp = 2
local outcomeLost   = 3
local dailyPoints   = '[Fish]DailyPoints'
local fatigue       = '[Fish]Fatigue'
local maxCasts      = 60

local function putBytes(packet, offset, value, width)
    for byte = 0, width - 1 do
        packet[offset + byte] = bit.band(bit.rshift(value, byte * 8), 0xFF)
    end
end

local function sendCast(player)
    local packet = ffi.new('uint8_t[28]')
    putBytes(packet, 4, player:getID(), 4)
    putBytes(packet, 8, player:getTargID(), 2)
    putBytes(packet, 10, fishActionId, 2)
    player.packets:send(actionPacket, packet, ffi.sizeof(packet))
end

local function sendFishing(player, mode, para, para2)
    local packet = ffi.new('uint8_t[20]')
    putBytes(packet, 4, player:getID(), 4)
    putBytes(packet, 8, para or 0, 4)
    putBytes(packet, 12, player:getTargID(), 2)
    packet[14] = mode
    putBytes(packet, 16, para2 or 0, 4)
    player.packets:send(fishingPacket, packet, ffi.sizeof(packet))
end

-- The hook delay runs on the Earth clock, and two Vana'diel hours is always well past it
local function waitForHookDelay()
    xi.test.world:setVanaTime((VanadielHour() + 2) % 24, 0)
end

local function castAndCheck(player)
    sendCast(player)
    assert(player:getAnimation() == xi.animation.NEW_FISHING_START, 'The cast was refused')

    waitForHookDelay()
    player.packets:clear()
    sendFishing(player, checkHook)
end

local function hasBite(player)
    return player:getAnimation() == xi.animation.NEW_FISHING_FISH
end

-- The client echoes the intuition it was sent or the reel counts as lost
local function endFight(player, stamina)
    local intuition = 0
    for _, packet in ipairs(player.packets:getIncoming()) do
        if packet.type == fishPacket then
            intuition = packetReader.readU32(packet.data, 0x14)
        end
    end

    sendFishing(player, endMiniGame, stamina, intuition)
end

-- Test characters reuse their ids and the clock skips, so earlier runs can leave rows with any date, and spawnAngler clears the meters for the same reason
local function catchLog(player)
    local log = {}
    for _, entry in ipairs(GetFishingHistory(player:getName(), 50)) do
        log[#log + 1] = string.format('%d:%d', entry.itemId, entry.caughtAt)
    end

    return table.concat(log, ',')
end

local function holdsQuestPoolItem(player)
    return player:hasItem(xi.item.HYDROGAUGE) or player:hasItem(xi.item.RUSTY_LEGGINGS) or player:hasItem(xi.item.RUSTY_SUBLIGAR)
end

local function releaseLine(player)
    sendFishing(player, release)
    waitForHookDelay()
end

local function spawnAngler(zone)
    local player = xi.test.world:spawnPlayer({ zone = zone })
    player:setAccountVar(dailyPoints, 0, 0)
    player:setAccountVar(fatigue, 0, 0)
    player:setSkillLevel(xi.skill.FISHING, 1000)
    player:addItem(xi.item.LU_SHANGS_FISHING_ROD)
    player:addItem(xi.item.MINNOW)
    player:equipItem(xi.item.LU_SHANGS_FISHING_ROD)
    player:equipItem(xi.item.MINNOW)

    return player
end

-- The quest makes the item pool bite almost every cast, which holds the Hydrogauge and two rusty pieces
local function spawnItemAngler()
    local player = spawnAngler(xi.zone.NASHMAU)
    player:addQuest(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.NAVIGATING_THE_UNFRIENDLY_SEAS)

    return player
end

local function castUntilBite(player)
    for _ = 1, maxCasts do
        castAndCheck(player)
        if hasBite(player) then
            return
        end

        releaseLine(player)
    end

    assert(false, 'Nothing bit')
end

describe('Module: phoenix fishing hooks', function()
    before_each(function()
        assert(GetFishingHistory, 'fishing_history.cpp is not built into xi_test, check modules/init.txt')
        xi.test.world:setSetting('map.FISHING_ENABLE', true)
        xi.test.world:setSeed(1710)
    end)

    it('counts a cast only when the line goes out', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.NASHMAU })
        local before = GetFishingRecords(player:getName()).linesCast

        sendCast(player)
        assert(GetFishingRecords(player:getName()).linesCast == before, 'A cast without a rod was counted')

        player:addItem(xi.item.LU_SHANGS_FISHING_ROD)
        player:addItem(xi.item.MINNOW)
        player:equipItem(xi.item.LU_SHANGS_FISHING_ROD)
        player:equipItem(xi.item.MINNOW)
        waitForHookDelay()

        sendCast(player)
        assert(GetFishingRecords(player:getName()).linesCast == before + 1, 'The cast was not counted')
    end)

    it('records a landed item', function()
        local player = spawnItemAngler()
        local before = catchLog(player)

        castUntilBite(player)
        endFight(player, reeledIn)

        assert(holdsQuestPoolItem(player), 'The item did not land')
        assert(catchLog(player) ~= before, 'The catch was not recorded')

        sendFishing(player, release)
        assert(player:getAnimation() == xi.animation.NONE, 'The release did not finish the cast')
    end)

    it('does not record a catch the inventory cannot hold', function()
        local player = spawnItemAngler()
        local before = catchLog(player)
        for _ = 1, 100 do
            if player:getFreeSlotsCount() == 0 then
                break
            end

            player:addItem(xi.item.BRONZE_DAGGER)
        end

        castUntilBite(player)
        endFight(player, reeledIn)

        assert(not holdsQuestPoolItem(player), 'The item fit in a full inventory')
        assert(catchLog(player) == before, 'A catch that never landed was recorded')
    end)

    it('does not record a fight given up', function()
        local player = spawnItemAngler()
        local before = catchLog(player)

        castUntilBite(player)
        endFight(player, gaveUp)
        assert(catchLog(player) == before, 'A fight given up was recorded')
    end)

    it('stops the bite while the account allowance is spent', function()
        local player = spawnItemAngler()

        player:setAccountVar(dailyPoints, 200, 0)
        castAndCheck(player)
        assert(not hasBite(player), 'A catch bit with the allowance spent')
        releaseLine(player)

        player:setAccountVar(dailyPoints, 0, 0)
        castUntilBite(player)
    end)

    it('stops the bite while the account is worn out', function()
        local player = spawnItemAngler()

        player:setAccountVar(fatigue, 20000, 0)
        castAndCheck(player)
        assert(not hasBite(player), 'A catch bit with the account worn out')
        releaseLine(player)

        player:setAccountVar(fatigue, 0, 0)
        castUntilBite(player)
    end)

    it('charges a landed fish to the account', function()
        local player = spawnAngler(xi.zone.PORT_WINDURST)
        local before = catchLog(player)
        player:setAccountVar(dailyPoints, 5, 0)

        for _ = 1, maxCasts do
            castAndCheck(player)

            if hasBite(player) then
                endFight(player, reeledIn)
            end

            if player:hasItem(xi.item.BASTORE_BREAM) then
                break
            end

            releaseLine(player)
        end

        assert(player:hasItem(xi.item.BASTORE_BREAM), 'No fish landed')
        assert(catchLog(player) ~= before, 'The fish was not recorded')
        assert(player:getAccountVar(dailyPoints) >= 6, 'The catch was not added to the account allowance')
        assert(player:getAccountVar(fatigue) > 0, 'The catch did not tire the account')
        assert(player:getCharVar(dailyPoints) == player:getAccountVar(dailyPoints), 'The character and account disagree')
    end)

    it('tells the fishing audit how each fight ended', function()
        -- The audit is in the private phoenix_ac module, which CI doesn't have.
        if GetFishingAttempts == nil then
            return
        end

        local player = spawnItemAngler()
        local name   = player:getName()

        castUntilBite(player)
        endFight(player, gaveUp)
        releaseLine(player)

        local attempts = GetFishingAttempts(name, 1)
        assert(attempts[1].outcome == outcomeGaveUp and attempts[1].catchId > 0, 'The fight given up was not audited')

        castUntilBite(player)
        releaseLine(player)
        assert(GetFishingAttempts(name, 1)[1].outcome == outcomeLost, 'The hook let go was not audited')

        castUntilBite(player)
        endFight(player, reeledIn)
        releaseLine(player)
        assert(GetFishingAttempts(name, 1)[1].outcome == outcomeReeled, 'The reel was not audited')
    end)
end)
