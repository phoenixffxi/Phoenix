-----------------------------------
-- Dynamis Participants Code
-- In-memory table-based tracking of participants per instance
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}
xi.dynamis.instances = xi.dynamis.instances or {}

-- Helper function to convert table to string for logging/debugging
local function tableToString(tbl)
    if not tbl or type(tbl) ~= 'table' then
        return '{}'
    end

    local result = '{'
    for k, v in pairs(tbl) do
        result = result .. string.format('[%s]=%s ', tostring(k), tostring(v))
    end

    result = result .. '}'

    return result
end

-- Add a participant to an instance
xi.dynamis.addParticipant = function(instanceId, charId, playerName)
    xi.dynamis.debugPrint(string.format('------------addParticipant------------'))
    if not xi.dynamis.instances[instanceId] then
        xi.dynamis.instances[instanceId] = {}
        xi.dynamis.debugPrint(string.format('Created new instance table for instanceId: %u', instanceId))
    end

    xi.dynamis.instances[instanceId][charId] = playerName
    xi.dynamis.debugPrint(string.format('Added participant - instanceId: %u, charId: %u, playerName: %s', instanceId, charId, playerName))
    xi.dynamis.debugPrint(string.format('Instance %u participants: %s', instanceId, tableToString(xi.dynamis.instances[instanceId])))
end

-- Get all participants for an instance
xi.dynamis.getParticipants = function(instanceId)
    xi.dynamis.debugPrint(string.format('------------getParticipants------------'))
    xi.dynamis.debugPrint(string.format('Retrieving participants for instanceId: %u', instanceId))
    xi.dynamis.debugPrint(string.format('Participants table: %s', tableToString(xi.dynamis.instances[instanceId] or {})))
    return xi.dynamis.instances[instanceId] or { }
end

-- Remove a participant from all instances
xi.dynamis.removeParticipant = function(charId)
    xi.dynamis.debugPrint(string.format('------------removeParticipant------------'))
    for instanceId, participants in pairs(xi.dynamis.instances) do
        if participants[charId] then
            xi.dynamis.debugPrint(string.format('Found participant in instanceId: %u, removing...', instanceId))
            participants[charId] = nil
            xi.dynamis.debugPrint(string.format('Instance %u participants after removal: %s', instanceId, tableToString(xi.dynamis.instances[instanceId])))
        end
    end
end

-- Remove a participant from a specific instance
xi.dynamis.removeParticipantFromInstance = function(instanceId, charId)
    xi.dynamis.debugPrint(string.format('------------removeParticipantFromInstance------------'))
    if xi.dynamis.instances[instanceId] then
        if xi.dynamis.instances[instanceId][charId] then
            xi.dynamis.instances[instanceId][charId] = nil
            xi.dynamis.debugPrint(string.format('Participant removed from instance %u', instanceId))
            xi.dynamis.debugPrint(string.format('Instance %u participants: %s', instanceId, tableToString(xi.dynamis.instances[instanceId])))
        else
            xi.dynamis.debugPrint(string.format('Participant charId: %u not found in instanceId: %u', charId, instanceId))
        end
    else
        xi.dynamis.debugPrint(string.format('Instance %u does not exist', instanceId))
    end
end

-- Clear all participants from an instance
xi.dynamis.clearParticipants = function(instanceId)
    xi.dynamis.debugPrint(string.format('------------clearParticipants------------'))
    if xi.dynamis.instances[instanceId] then
        xi.dynamis.debugPrint(string.format('Clearing all participants from instanceId: %u', instanceId))
        xi.dynamis.debugPrint(string.format('Participants before clear: %s', tableToString(xi.dynamis.instances[instanceId])))
        xi.dynamis.instances[instanceId] = nil
        xi.dynamis.debugPrint(string.format('Instance %u participants cleared', instanceId))
    else
        xi.dynamis.debugPrint(string.format('Instance %u does not exist, nothing to clear', instanceId))
    end
end

-- Check if a participant exists in an instance
xi.dynamis.isParticipant = function(instanceId, charId)
    xi.dynamis.debugPrint(string.format('------------isParticipant------------'))
    if xi.dynamis.instances[instanceId] then
        local exists = xi.dynamis.instances[instanceId][charId] ~= nil
        xi.dynamis.debugPrint(string.format('Checking if charId: %u exists in instanceId: %u - Result: %s', charId, instanceId, tostring(exists)))
        xi.dynamis.debugPrint(string.format('Instance %u participants: %s', instanceId, tableToString(xi.dynamis.instances[instanceId])))
        return exists
    end

    xi.dynamis.debugPrint(string.format('Instance %u does not exist, returning false', instanceId))
    return false
end

-- Get the instance ID that a player is currently in
xi.dynamis.getDynaInstance = function(charId)
    xi.dynamis.debugPrint(string.format('------------getDynaInstance------------'))
    xi.dynamis.debugPrint(string.format('Searching for charId: %u in all instances', charId))

    for instanceId, participants in pairs(xi.dynamis.instances) do
        if participants[charId] then
            xi.dynamis.debugPrint(string.format('Found charId: %u in instanceId: %u', charId, instanceId))
            return instanceId
        end
    end

    xi.dynamis.debugPrint(string.format('charId: %u not found in any instance, returning -1', charId))
    return -1
end
