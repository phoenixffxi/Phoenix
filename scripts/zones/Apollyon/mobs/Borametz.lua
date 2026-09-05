-----------------------------------
-- Area: Apollyon NE, Floor 1
--  Mob: Borametz
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setMod(xi.mod.COUNTER, 35)
    mob:setMod(xi.mod.ADDITIVE_GUARD, 5)
    mob:setMobMod(xi.mobMod.ALLI_HATE, 50)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
end

entity.onMobMobskillChoose = function(mob, target)
    local tpMoves =
    {
        xi.mobSkill.HEAD_BUTT_1,
        xi.mobSkill.DREAM_FLOWER_1,
        xi.mobSkill.WILD_OATS_1,
        xi.mobSkill.LEAF_DAGGER_1,
        xi.mobSkill.SCREAM_1,
    }

    return tpMoves[math.randomInt(1, #tpMoves)]
end

return entity
