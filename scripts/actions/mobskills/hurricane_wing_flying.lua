-----------------------------------
-- Hurricane Wing (Airborne Version)
-- Family: Wyrm
-- Description: Deals hurricane-force wind damage to enemies within a very wide area of effect. Additional Effect: Blind
-- Notes: Used by Wyrm when in the air. Only use in a dedicated flying skill set.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:getAnimationSub() ~= 1 then -- Only use while flying
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3.250, 3.625, 4.000 }
    params.element    = xi.element.WIND

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        local power = 100
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, power, 0, 30)
    end

    return damage
end

return mobskillObject
