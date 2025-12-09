-----------------------------------
-- Mind Blast
-- Family: Soulflayers
-- Description: Deals Thunder damage to an enemy. Additional Effect: Paralysis
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 2.0, 2.0, 2.0 }
    params.element         = xi.element.THUNDER
    params.dStatMultiplier = 1.5

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

        -- TODO: Capture Paralysis power. Sources say its extremely potent.
        -- TODO: More captures for duration to account for effect resistance.
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PARALYSIS, 20, 0, xi.mobskills.calculateDuration(skill:getTP(), 15, 45))
    end

    return damage
end

return mobskillObject
