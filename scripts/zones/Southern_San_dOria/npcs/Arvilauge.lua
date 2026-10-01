-----------------------------------
-- Area: Southern San d'Oria
--  NPC: Arvilauge
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    -- param [0] is related to having a chocobo in raising. it adds more help text to the event.
    player:startEvent(846, { [0] = 0, [1] =  math.floor(player:getCharSkillLevel(xi.skill.DIG) / 10) })
end

return entity
