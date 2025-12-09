-----------------------------------
-- Lesson in Pain
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 2.8, 2.8, 2.8 } -- TODO: Capture fTPs
    params.element    = xi.element.NONE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.NONE, xi.damageType.NONE, xi.mobskills.shadowBehavior.NUMSHADOWS_1)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.NONE, xi.damageType.NONE)
    end

    return damage
end

return mobskillObject
