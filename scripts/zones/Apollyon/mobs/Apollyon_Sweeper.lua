-----------------------------------
-- Area: Apollyon NE, Floor 3
--  Mob: Apollyon Sweeper
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setMod(xi.mod.STORETP, 90)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
end

entity.onMobMobskillChoose = function(mob, target)
    local tpMoves =
    {
        xi.mobSkill.KARTSTRAHL,
        xi.mobSkill.BLITZSTRAHL,
        xi.mobSkill.PANZERFAUST,
        xi.mobSkill.BERSERK_DOLL,
        xi.mobSkill.PANZERSCHRECK,
        xi.mobSkill.TYPHOON,
        xi.mobSkill.GRAVITY_FIELD,
    }

    return tpMoves[math.randomInt(1, #tpMoves)]
end

return entity
