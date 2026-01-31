-----------------------------------
-- Area: SE Apollyon
--  Mob: Adamantshell
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setMod(xi.mod.SLASH_SDT, -10000)
    mob:setMod(xi.mod.PIERCE_SDT, 15000)
    mob:setMod(xi.mod.IMPACT_SDT, 10000)
    mob:setMod(xi.mod.HTH_SDT, 10000)
end

return entity
