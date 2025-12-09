-----------------------------------
-- Molting Burst
-- Family: Limules
-- Description: Deals Light damage to . Restores HP of mob. Transfers any negative status effects on the mob to the target.
-- Notes: Used by Limules affiliated with light element.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 5, 5, 5 } -- TODO: capture fTPs
    params.element    = xi.element.LIGHT

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)

        -- TODO: Might want to make a new binding to tranfer status effects to other targets based on effect flags.
        -- TODO: This skill also transfers debuffs on the mob to the target.
    end

    -- TODO: This may need to be handled via mixin or listener since this will execute for every target hit.
    -- xi.mobskills.mobHealMove(mob, mob:getMaxHP() * 0.10) -- TODO: Capture heal power

    return damage
end

return mobskillObject
