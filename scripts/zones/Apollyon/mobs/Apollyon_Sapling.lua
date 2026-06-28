-----------------------------------
-- Area: Apollyon SW
--  Mob: Apollyon Sapling
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.PLAGUE)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:setMod(xi.mod.UDMGBREATH, -2500)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
end

return entity
