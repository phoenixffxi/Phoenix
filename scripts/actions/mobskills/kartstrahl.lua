-----------------------------------
-- Kartstrahl
-- Family: Dolls
-- Description: Deals Ice damage to a target. Additional Effect: Sleep
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.0, 2.0, 2.0 }
    params.element    = xi.element.ICE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.ICE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.ICE)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SLEEP_I, 1, 0, 90)
    end

    return damage
end

return mobskillObject
