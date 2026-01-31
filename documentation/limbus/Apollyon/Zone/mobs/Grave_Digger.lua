-----------------------------------
-- Area: SE Apollyon
--  Mob: Grave Digger
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
    mob:setMobMod(xi.mobMod.NO_STANDBACK, 1)
end

entity.onMobSpawn = function(mob)
    mob:setMod(xi.mod.SLASH_SDT, 15000)
    mob:setMod(xi.mod.PIERCE_SDT, -10000)
    mob:setMod(xi.mod.IMPACT_SDT, 30000)
    mob:setMod(xi.mod.HTH_SDT, 30000)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 300)
end

return entity
