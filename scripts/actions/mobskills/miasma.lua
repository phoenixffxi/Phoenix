-----------------------------------
-- Miasma
-- Family: Mamool Ja (Gulool Ja Ja)
-- Description: Releases a toxic cloud on nearby targets. Additional Effect: Slow, Plague, Poison
-- Notes: Used by Gulool Ja Ja.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4, 4, 4 }      -- TODO: Capture fTPs
    params.element    = xi.element.EARTH -- TODO: Capture Element

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.EARTH, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.EARTH)

        -- TODO: Capture powers/durations
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PLAGUE, 5, 3, 60)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, math.floor(mob:getMainLvl() / 3), 3, 60)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SLOW, 1250, 3, 120)
    end

    return damage
end

return mobskillObject
