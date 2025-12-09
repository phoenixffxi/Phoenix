-----------------------------------
-- Maelstrom
-- Family: Sea Monk
-- Description: Deals Water damage to enemies within range. Additional Effect: STR Down.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.00, 2.50, 3.00 }
    params.element    = xi.element.WATER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

        local power    = 10
        local duration = 180 -- TODO: Capture duration
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.STR_DOWN, power, 9, duration)
    end

    return damage
end

return mobskillObject
