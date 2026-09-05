-----------------------------------
-- Area: Apollyon NE, Floor 4
--  Mob: Okeanos
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setMod(xi.mod.STORETP, 90)
    mob:setMod(xi.mod.MDEF, 100)
    mob:setMod(xi.mod.NULL_RANGED_DAMAGE, 100)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
end

entity.onMobMobskillChoose = function(mob, target)
    local tpMoves =
    {
        xi.mobSkill.ICE_ROAR_1,
        xi.mobSkill.IMPACT_ROAR_1,
        xi.mobSkill.GRAND_SLAM_1,
        xi.mobSkill.POWER_ATTACK_ARMED_1,
    }

    return tpMoves[math.randomInt(1, #tpMoves)]
end

return entity
