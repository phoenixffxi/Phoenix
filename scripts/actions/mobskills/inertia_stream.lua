-----------------------------------
-- Inertia Stream
-- Family: Chariots
-- Description: Deals Light damage to enemies within range. Additional Effect: Bind
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 6, 6, 6 } -- TODO: Capture fTPs
    params.element    = xi.element.LIGHT

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT, { breakBind = false })

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BIND, 1, 0, 30)
    end

    return damage
end

return mobskillObject
