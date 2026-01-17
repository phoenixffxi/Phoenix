-----------------------------------
-- Area: Apollyon SE, Floor 2
--  Mob: Tieholtsodi
-----------------------------------
mixins = { require('scripts/mixins/job_special') }
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
    mob:setMod(xi.mod.PIERCE_SDT, 30000)
    mob:setMod(xi.mod.IMPACT_SDT, 15000)
    mob:setMod(xi.mod.HTH_SDT, 15000)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 250)

    xi.mix.jobSpecial.config(mob, {
        specials =
        {
            { id = xi.jsa.HUNDRED_FISTS, hpp = math.random(50, 75) },
        },
    })
end

return entity
