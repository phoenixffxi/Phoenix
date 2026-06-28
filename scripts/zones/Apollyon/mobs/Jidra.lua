-----------------------------------
-- Area: Apollyon SW
--  Mob: Jidra
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
    mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 0)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
end

return entity
