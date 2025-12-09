-----------------------------------
-- Hellfire Arrow
-- Family: Yztarg (Red)
-- Description: Deals Fire damage to targets in front of mob. Additional Effect: Burn
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.7, 2.7, 2.7 } -- TODO: Capture fTPs
    params.element    = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

         -- TODO: Capture power/duration
        local power  = math.random(10, 30)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BURN, power, 3, 60)
    end

    return damage
end

return mobskillObject
