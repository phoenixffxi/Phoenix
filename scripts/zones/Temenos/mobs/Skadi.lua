-----------------------------------
-- Area: Temenos Northern Tower
--  Mob: Skadi
-----------------------------------
mixins = { require('scripts/mixins/job_special') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)

    xi.mix.jobSpecial.config(mob, {
        specials =
        {
            { id = xi.mobSkill.CHARM, hpp = math.random(50, 60) },
        },
    })
end

return entity
