-----------------------------------
-- Self-Destruct (Fire in the Sky)
-- Description: Deals massive fire damage to enemies within range. Damage scales 1:1 with remaining HP.
-- Type: Magical Fire
-- Range: 10'
-- Utsusemi/Blink absorb: Ignores shadows
-- Notes: Used by Razon in ENM "Fire in the Sky" when final self-destruct is triggered. Results in immediate ejection from the battlefield.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local damage = mob:getHP() * 2

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, damage, xi.element.FIRE, 1, xi.mobskills.magicalTpBonus.MAB_BONUS, 1)
    damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

    return damage
end

mobskillObject.onMobSkillFinalize = function(mob, skill)
    mob:setHP(0)
end

return mobskillObject
