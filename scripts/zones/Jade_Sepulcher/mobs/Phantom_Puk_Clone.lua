-----------------------------------
-- Area: Jade Sepulcher
--   NM: Phantom Puk (Clone)
-----------------------------------
mixins = { require('scripts/mixins/families/puk') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMod(xi.mod.WIND_ABSORB, 100)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
end

entity.onMobSpawn = function(mob)
    mob:addStatusEffect(xi.effect.BLINK, 3, 0, 180)
    mob:setMod(xi.mod.ACC, 338)
    mob:setMod(xi.mod.DMG, 10000)
    mob:setMod(xi.mod.HP, 0)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
end

return entity
