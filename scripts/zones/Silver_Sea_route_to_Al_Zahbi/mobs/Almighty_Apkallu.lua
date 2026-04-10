-----------------------------------
-- Area: Silver Sea route to Al Zahbi
--   NM: Almighty Apkallu
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.GRAVITY)
    mob:addImmunity(xi.immunity.PLAGUE)
    mob:addImmunity(xi.immunity.PARALYZE)
end

entity.onMobSpawn = function(mob)
    mob:setMod(xi.mod.REGAIN, 300)
    mob:setMod(xi.mod.DMGMAGIC, -2500)
end

entity.onMobDespawn = function(mob)
    mob:setLocalVar('respawn', GetSystemTime() + 300) -- 5 minutes
end

return entity
