-----------------------------------
-- Malevolent Blessing
-- Family: Promathia
-- Description: Deals conal aoe Dark damage in front of mob. Additional Effect: Curse
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}
    -- TODO: Verify if Physical/Magical
    -- TODO: Capture shadowBehavior
    -- TODO: Capture Curse power/duration

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3.75, 3.75, 3.75 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.NUMSHADOWS_3, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

        -- TODO: Capture power/duration
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.CURSE_I, 35, 0, 45)
    end

    return damage
end

return mobskillObject
