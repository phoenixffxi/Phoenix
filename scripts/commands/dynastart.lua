-----------------------------------
-- func: dynastart
-- desc: Starts a dynamis event for the targeted player in DEBUG mode
-- **GM USE ONLY**
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 3,
    parameters = 'i'
}

commandObj.onTrigger = function(player, mode)
    -- Validate parameters
    if not mode or mode == '' then
        player:printToPlayer('Usage: !dynastart mode', xi.msg.channel.SYSTEM_3)
        player:printToPlayer('Mode: 0 = normal, 1 = debug', xi.msg.channel.SYSTEM_3)
        player:printToPlayer('Player must be inside the starting connecting zone.', xi.msg.channel.SYSTEM_3)
        return
    end

    if not mode or (mode ~= 0 and mode ~= 1) then
        player:printToPlayer('Mode must be 0 (normal) or 1 (debug)', xi.msg.channel.SYSTEM_3)
        return
    end

    -- Get the player's cursor target
    local target = player:getCursorTarget()

    if not target then
        player:printToPlayer('You must have a target selected.', xi.msg.channel.SYSTEM_3)
        return
    end

    -- Verify target is a player
    if target:isPC() then
        xi.dynamis.onNewDynamis(target, mode)
        local modeStr = mode == 1 and 'debug' or 'normal'
        player:printToPlayer(string.format('Started dynamis for %s in %s mode', target:getName(), modeStr), xi.msg.channel.SYSTEM_3)
    else
        player:printToPlayer('Target must be a player.', xi.msg.channel.SYSTEM_3)
    end
end

return commandObj
