-----------------------------------
-- Area: Open Sea route to Mhaura
--  Mob: Gugru Orobon
-----------------------------------
mixins = { require('scripts/mixins/families/orobon') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
end

return entity
