-----------------------------------
-- Area: Apollyon SW
--  Mob: Jidra (Boss)
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.PLAGUE)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.BIND)
    mob:setMod(xi.mod.UDMGBREATH, -2500)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 0)
    mob:setMod(xi.mod.DEF, 750)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 250)
end

return entity
