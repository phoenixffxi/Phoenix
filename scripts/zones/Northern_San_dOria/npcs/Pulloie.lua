-----------------------------------
-- Area: Northern San d'Oria
--  NPC: Pulloie
-- !pos 132.847 -0.199 -2.627 231
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    player:startEvent(838, player:getNation())
end

entity.onEventFinish = function(player, csid, option, npc)
    xi.moghouse.visitNpcOnEventFinish(player, csid, option, npc)
end

return entity
