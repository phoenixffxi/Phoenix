-----------------------------------
-- Area: Temenos Central Temenos
--  Mob: Mystic Avatar
-----------------------------------
mixins = { require('scripts/mixins/job_special') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.ADD_EFFECT, 1)

    mob:addImmunity(xi.immunity.STUN)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
    mob:delImmunity(xi.immunity.SILENCE)
    mob:delImmunity(xi.immunity.PARALYZE)
    mob:delImmunity(xi.immunity.BLIND)
    mob:delImmunity(xi.immunity.SLOW)
    mob:delImmunity(xi.immunity.POISON)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)

    xi.mix.jobSpecial.config(mob, {
        specials =
        {
            { id = xi.mobSkill.SEARING_LIGHT_1, hpp = math.random(30, 55) }, -- uses Searing Light once while near 50% HPP.
        },
    })
end

entity.onAdditionalEffect = function(mob, target, damage)
    local pTable =
    {
        chance         = 100,
        attackType     = xi.attackType.MAGICAL,
        magicalElement = xi.element.LIGHT,
        basePower      = math.floor(damage / 2),
        actorStat      = xi.mod.INT,
    }

    return xi.combat.action.executeAddEffectDamage(mob, target, pTable)
end

return entity
