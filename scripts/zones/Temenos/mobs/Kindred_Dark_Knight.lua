-----------------------------------
-- Area: Temenos Northern Tower
--  Mob: Kindred Dark Knight
-----------------------------------
mixins = { require('scripts/mixins/job_special') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
    mob:setMod(xi.mod.UDMGMAGIC, -2500)
end

return entity
