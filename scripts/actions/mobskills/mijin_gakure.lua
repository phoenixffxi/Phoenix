-----------------------------------
-- Mijin Gakure
-- Description: Deals unaspected magic damage to targets in range.
-- Note: Behavior of skill differs from players. Example: Not all mobs die after using skill.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- TODO: Capture fTPs/Formula
    params.baseDamage      = mob:getWeaponDmg() * skill:getMobHPP() / 10 + 6
    params.fTP             = { 1.0, 1.0, 1.0 }
    params.element         = xi.element.NONE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.ELEMENTAL, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.ELEMENTAL)
    end

    return damage
end

return mobskillObject
