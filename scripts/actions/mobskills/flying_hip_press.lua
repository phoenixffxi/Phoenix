-----------------------------------
-- Flying Hip Press
-- Family: Bugbears
-- Description: Deals Wind damage to enemies within area of effect.
-- Note: Mob version of this skill is NOT a breath attack like the BLU spell is.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.0, 2.0, 2.0 }
    params.element    = xi.element.WIND

    if mob:getPool() == xi.mobPool.BUGBOY then
        params.fTP = 7.0
    end

    if mob:getPool() == xi.mobPool.BUGBEAR_MATMAN then
        params.fTP = 10.0
    end

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)
    end

    return damage
end

return mobskillObject
