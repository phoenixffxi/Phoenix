-----------------------------------
--  Mighty Snort
--
--  Deals Wind damage to targets in a fan-shaped area of effect. Additional effect: Hate reset
--  Type: Magical (Wind)
--  Only used by certain Buffalo NMs
--
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 4.00, 4.00, 4.00 }
    params.element         = xi.element.WIND
    params.dStatMultiplier = 1
    -- TODO: Capture Knockback range

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        -- TODO: NM: Audumbla reportedly has hate reset on this skill.
    end

    return damage
end

return mobskillObject
