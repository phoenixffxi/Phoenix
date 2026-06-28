-----------------------------------
-- Area: Apollyon SW
--  NPC: Fir Bholg (BLM)
-----------------------------------
mixins = { require('scripts/mixins/job_special') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.PLAGUE)
    mob:addImmunity(xi.immunity.TERROR)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.NO_STANDBACK, 1)
    mob:setMod(xi.mod.MDEF, 100)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)

    xi.mix.jobSpecial.config(mob, {
        specials =
        {
            { id = xi.jsa.MANAFONT, hpp = math.random(50, 60) },
        },
    })
end

entity.onMobMobskillChoose = function(mob)
    -- TODO: Migrate to upstream mob_skills.lua
    local tpList =
    {
        241, -- NETHERSPIKES
        242, -- CARNAL_NIGHTMARE
        243, -- AEGIS_SCHISM
        244, -- DANCING_CHAINS
        xi.mobSkill.BARBED_CRESCENT_1,
        248, -- FOXFIRE
    }

    return tpList[math.random(1, #tpList)]
end

return entity
