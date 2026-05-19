-----------------------------------
-- Area: Dynamis - Bastok
--  Mob: Aa'Nyu Dismantler
-----------------------------------
mixins =
{
    require('scripts/mixins/job_special')
}
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobSpawn = function(mob)
end

entity.onMobDeath = function(mob, player, optParams)
end

return entity
