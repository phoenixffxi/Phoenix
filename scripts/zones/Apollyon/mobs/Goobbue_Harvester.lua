-----------------------------------
-- Area: Apollyon NE
--   NM: Goobbue_Harvester
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
    mob:setMobMod(xi.mobMod.ADD_EFFECT, 1)
end

entity.onMobSpawn = function(mob)
    mob:setMod(xi.mod.STORETP, 90)
    mob:setMod(xi.mod.DEFP, 75)
    mob:setMod(xi.mod.REGEN, 10)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
end

entity.onAdditionalEffect = function(mob, target, damage)
    local pTable =
    {
        chance   = 25,
        effectId = xi.effect.PARALYSIS,
        power    = 30,
        duration = 45,
    }

    return xi.combat.action.executeAddEffectEnfeeblement(mob, target, pTable)
end

return entity
