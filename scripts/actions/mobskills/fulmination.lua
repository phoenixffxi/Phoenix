-----------------------------------
-- Fulmination
-- Family: Khimaira
-- Description: Deals Thunder damage in an area of effect. Additional Effect: Paralysis, Stun
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 12, 12, 12 } -- TODO: Capture fTPs
    params.element    = xi.element.THUNDER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

        -- TODO: Capture power/durations
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PARALYSIS, 40, 0, 60)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.STUN, 1, 0, 4)
    end

    return damage
end

return mobskillObject
