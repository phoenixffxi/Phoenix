-----------------------------------
-- Final Meteor
-- Family: Behemoth (Chlevnik)
-- Description: Extreme non-elemental damage.
-- Notes: Used by Chlevnik upon death.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() * 32
    params.fTP        = { 1, 1, 1 }
    params.element    = xi.element.NONE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.NONE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.NONE)
    end

    -- Animation change happens after mobskill finishes.
    -- Animation: Chlevnik falls but calls in a final meteor barrage, then dies.
    skill:setFinalAnimationSub(1)

    return damage
end

return mobskillObject
