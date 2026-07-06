-----------------------------------
-- Area: Central Temenos 2nd Floor
--  Mob: Mystic Avatar (Titan)
-----------------------------------
mixins = { require('scripts/mixins/job_special') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.ADD_EFFECT, 1)

    mob:addImmunity(xi.immunity.BIND)
    mob:addImmunity(xi.immunity.STUN)
    mob:addImmunity(xi.immunity.PARALYZE)
    mob:addImmunity(xi.immunity.BLIND)
    mob:addImmunity(xi.immunity.SLOW)
    mob:addImmunity(xi.immunity.POISON)
    mob:addImmunity(xi.immunity.ELEGY)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)

    xi.mix.jobSpecial.config(mob, {
        specials =
        {
            { id = xi.mobSkill.EARTHEN_FURY_1, hpp = math.random(30, 55) }, -- uses Earthen Fury once while near 50% HPP.
        },
    })
end

entity.onAdditionalEffect = function(mob, target, damage)
    local pTable =
    {
        chance         = 20,
        attackType     = xi.attackType.MAGICAL,
        magicalElement = xi.element.EARTH,
        basePower      = math.floor(damage / 2),
        actorStat      = xi.mod.INT,
    }

    return xi.combat.action.executeAddEffectDamage(mob, target, pTable)
end

return entity
