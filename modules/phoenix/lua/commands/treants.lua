-----------------------------------
-- func: treants
-- desc: Twinkling Treant event management: status (default), start, spawn, reset, complete
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 5,
    parameters = 's'
}

local function printStatus(player)
    local started  = GetServerVariable('[TreantEvent]Started')
    local complete = GetServerVariable('[TreantEvent]Complete')
    local blocking = started ~= 0 and complete == 0

    player:printToPlayer(string.format('TreantEvent: started=%i complete=%i (outpost blocking %s)',
        started, complete, blocking and 'ON' or 'OFF'))

    local zoneIds = {}
    for zoneId in pairs(xi.treantEvent.zones) do
        table.insert(zoneIds, zoneId)
    end

    table.sort(zoneIds)

    for _, zoneId in ipairs(zoneIds) do
        local entry = xi.treantEvent.zones[zoneId]
        local dead  = GetServerVariable('[TreantEvent]Dead_' .. zoneId)
        local spots = xi.treantEvent.spots(entry)
        local _, spotIndex = xi.treantEvent.currentSpot(zoneId, entry)
        local state = string.format('ALIVE (spot %i/%i)', spotIndex, #spots)

        if dead ~= 0 then
            state = string.format('DEAD @ %i', dead)
        else
            local savedHP = GetServerVariable('[TreantEvent]HP_' .. zoneId)
            if savedHP > 0 then
                state = string.format('ALIVE (spot %i/%i, hp %i/%i)', spotIndex, #spots, savedHP, entry.hp)
            end
        end

        player:printToPlayer(string.format('[%i] %s (Lv%i): %s', zoneId, entry.zone, entry.cap, state))
    end
end

local function trySpawn(player)
    local zone   = player:getZone()
    local zoneId = zone:getID()
    local entry  = xi.treantEvent.zones[zoneId]

    if not entry then
        player:printToPlayer('This is not a treant event zone.')
        return
    end

    if GetServerVariable('[TreantEvent]Started') == 0 then
        player:printToPlayer('The event has not started. Use "!treants start" first.')
        return
    end

    if GetServerVariable('[TreantEvent]Complete') ~= 0 then
        player:printToPlayer('The event is complete. Use "!treants reset" first.')
        return
    end

    if GetServerVariable('[TreantEvent]Dead_' .. zoneId) ~= 0 then
        player:printToPlayer('This zone is marked dead. Use "!treants reset" first.')
        return
    end

    local mobId = zone:getLocalVar('[TreantEvent]MobId')
    if mobId ~= 0 then
        local existing = GetMobByID(mobId)
        if
            existing and
            existing:isSpawned()
        then
            player:printToPlayer('The treant is already up in this zone.')
            return
        end
    end

    xi.treantEvent.startZone(zoneId)
    player:printToPlayer('Treant spawned.')
end

local function startEvent(player)
    if GetServerVariable('[TreantEvent]Complete') ~= 0 then
        player:printToPlayer('The event is complete. Use "!treants reset" first.')
        return
    end

    if GetServerVariable('[TreantEvent]Started') ~= 0 then
        player:printToPlayer('The event is already running.')
        return
    end

    SetServerVariable('[TreantEvent]Started', GetSystemTime())

    for zoneId in pairs(xi.treantEvent.zones) do
        SendLuaFuncStringToZone(player:getZoneID(), zoneId, string.format('xi.treantEvent.startZone(%i)', zoneId))
    end

    for cityZoneId in pairs(xi.treantEvent.cityTeleporters) do
        SendLuaFuncStringToZone(player:getZoneID(), cityZoneId, string.format('xi.treantEvent.setTeleporterStatus(%i, %i)', cityZoneId, xi.status.DISAPPEAR))
    end

    player:printToPlayer('Event started: treants and moogles spawned, outpost teleportation blocked.')
end

local function resetEvent(player)
    SetServerVariable('[TreantEvent]Started', 0)
    SetServerVariable('[TreantEvent]Complete', 0)

    for zoneId in pairs(xi.treantEvent.zones) do
        SetServerVariable('[TreantEvent]Dead_' .. zoneId, 0)
        SetServerVariable('[TreantEvent]HP_' .. zoneId, 0)
        SetServerVariable('[TreantEvent]Spot_' .. zoneId, 0)
        SendLuaFuncStringToZone(player:getZoneID(), zoneId, string.format('xi.treantEvent.resetZone(%i)', zoneId))
    end

    for cityZoneId in pairs(xi.treantEvent.cityTeleporters) do
        SendLuaFuncStringToZone(player:getZoneID(), cityZoneId, string.format('xi.treantEvent.setTeleporterStatus(%i, %i)', cityZoneId, xi.status.NORMAL))
    end

    player:printToPlayer('Event reset: treants and moogles despawned. Use "!treants start" to launch.')
end

local function completeEvent(player)
    local now = GetSystemTime()

    if GetServerVariable('[TreantEvent]Started') == 0 then
        SetServerVariable('[TreantEvent]Started', now)
    end

    for zoneId in pairs(xi.treantEvent.zones) do
        if GetServerVariable('[TreantEvent]Dead_' .. zoneId) == 0 then
            SetServerVariable('[TreantEvent]Dead_' .. zoneId, now)
            SendLuaFuncStringToZone(player:getZoneID(), zoneId, string.format('xi.treantEvent.resetZone(%i)', zoneId))
        end
    end

    SetServerVariable('[TreantEvent]Complete', now)
    for cityZoneId in pairs(xi.treantEvent.cityTeleporters) do
        SendLuaFuncStringToZone(player:getZoneID(), cityZoneId, string.format('xi.treantEvent.setTeleporterStatus(%i, %i)', cityZoneId, xi.status.NORMAL))
    end

    player:printToPlayer('Event force completed. Live treants and moogles despawned.')
end

commandObj.onTrigger = function(player, action)
    if
        action == nil or
        action == 'status'
    then
        printStatus(player)
    elseif action == 'start' then
        startEvent(player)
    elseif action == 'spawn' then
        trySpawn(player)
    elseif action == 'reset' then
        resetEvent(player)
    elseif action == 'complete' then
        completeEvent(player)
    else
        player:printToPlayer('Usage: !treants [status|start|spawn|reset|complete]')
    end
end

xi.module.registerCommand('treants', commandObj)
