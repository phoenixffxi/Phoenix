-----------------------------------
-- Area: Apollyon NE, Floor 4
--  Mob: Kerkopes (Boss)
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setModelSize(3)
    mob:setHitboxSize(2.6)
    mob:setMod(xi.mod.STORETP, 90)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
end

return entity
