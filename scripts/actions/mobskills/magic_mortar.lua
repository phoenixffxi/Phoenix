-----------------------------------
-- Magic Mortar
-- Family: Automatons
-- Description: Deals Light damage to enemies within an area of effect.
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- Wikis say Ob starts using this skill around 50%HP.
    -- Damage ranges 1500-2500~ based on mob's missing HP (Unsure if shell was calculated into this account or not or if it applies at all)

    params.baseDamage = (mob:getMaxHP() - skill:getMobHP()) / 6 -- TODO: Capture data for damage formula
    params.fTP        = { 1.00, 1.00, 1.00 } -- TODO: Capture fTPs
    params.element    = xi.element.LIGHT -- TODO: Light or None?

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)
    end

    return damage
end

return mobskillObject
