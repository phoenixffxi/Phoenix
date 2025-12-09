-----------------------------------
-- Ink Jet
-- Family: Sea Monks
-- Description:  Deals Dark damage to targets in front of mob. Additional Effect: Blind
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1.50, 2.00, 2.50 }
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

        -- TODO: Jimmayus spreadsheet states 30-120s duration. Not sure if resists accounted for, if random, or tp scaling.
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 80, 0, 120)
    end

    return damage
end

return mobskillObject
