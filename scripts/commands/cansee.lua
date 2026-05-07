-----------------------------------
-- func: cansee <target>
-- desc: Can you see (via ximesh raycasting) your cursor target?
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 1,
    parameters = ''
}

commandObj.onTrigger = function(player)
    local target = player:getCursorTarget()
    if not target then
        player:printToPlayer('No cursor target provided')
        return
    end

    if player:canSee(target) then
        player:printToPlayer(string.format('%s CAN see %s', player:getName(), target:getName()))
    else
        player:printToPlayer(string.format('%s CANNOT see %s', player:getName(), target:getName()))
    end
end

return commandObj
