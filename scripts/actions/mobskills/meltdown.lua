-----------------------------------
-- Meltdown
-- Family: Dolls
-- Description: Doll self destructs and deals Light damage to targets in range.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:isMobType(xi.mobType.NOTORIOUS) then -- TODO: Set skill lists instead of conditional.
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = skill:getMobHP() / 2
    params.fTP        = { 1, 1, 1 }
    params.element    = xi.element.LIGHT
    -- TODO: Can this be out ranged or does it always go off? Need packet capture.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)
    end

    return damage
end

mobskillObject.onMobSkillFinalize = function(mob, skill)
    mob:setHP(0)
end

return mobskillObject
