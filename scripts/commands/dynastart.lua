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
    parameters = ''
}

commandObj.onTrigger = function(player)
    -- Get the player's cursor target
    local target = player:getCursorTarget()

    if not target then
        player:printToPlayer('You must have a target selected.', xi.msg.channel.SYSTEM)
        return
    end

    -- Verify target is a player
    if target:isPC() then
        xi.dynamis.onNewDynamis(target, 1)
        player:printToPlayer(string.format('Started dynamis for %s in debug mode', target:getName()), xi.msg.channel.SYSTEM)
        player:printToPlayer(string.format('This is used for TESTING ONLY', target:getName()), xi.msg.channel.SYSTEM)
    else
        player:printToPlayer('Target must be a player.', xi.msg.channel.SYSTEM)
    end
end

return commandObj
