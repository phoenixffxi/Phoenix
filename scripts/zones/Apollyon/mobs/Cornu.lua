-----------------------------------
-- Area: Apollyon NE, Floor 2
--  Mob: Cornu
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
end

entity.onMobMobskillChoose = function(mob, target)
    local tpMoves =
    {
        xi.mobSkill.BROADSIDE_BARRAGE_1,
        xi.mobSkill.BLIND_SIDE_BARRAGE_1,
    }

    return tpMoves[math.randomInt(1, #tpMoves)]
end

return entity
