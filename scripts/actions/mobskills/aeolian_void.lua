-----------------------------------
-- Aeolian Void
-- Family: Sand Worm
-- Description: Deals conal AoE Wind damage to targets in front of mob. Additional Effect: Blind, Silence
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill, action)
    local damage = mob:getWeaponDmg() * 2

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, damage, xi.element.WIND, 1, xi.mobskills.magicalTpBonus.MAB_BONUS, 1)
    damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

    xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SILENCE, 1, 0, 180)
    xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 50, 0, 180)

    return damage
end

return mobskillObject
