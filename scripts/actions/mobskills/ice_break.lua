-----------------------------------
-- Ice Break
-- Family: Golems
-- Description: Deals Ice damage to enemies within range. Additional Effect: Bind
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 2.00, 2.00, 2.00 }
    params.element         = xi.element.ICE
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.ICE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.ICE, { breakBind = false })

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BIND, 1, 0, xi.mobskills.calculateDuration(skill:getTP(), 120, 180))
    end

    return damage
end

return mobskillObject
