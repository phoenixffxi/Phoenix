-----------------------------------
-- Ice Guillotine
-- Family: Ruszors
-- Description: Bites at all targets in front. Additional Effect: Max HP Down
-- Notes:
-- * Scylla exclusive, this skill is not used on its own and is scripted to fire after Frozen Mist is used.
-- * This skill can be dodged by side stepping.
-- * Skill can not be interrupted by being out of range. The skill will always go off and hit anyone inside the cone.
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3.00, 3.00, 3.00 } -- TODO: Capture fTPs
    params.element    = xi.element.ICE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.ICE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.ICE)

         -- TODO: Capture durations of effects
         -- Capture power of Amnesia.
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.MAX_HP_DOWN, 50, 0, 180)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.AMNESIA, 1, 0, 60)
        -- TODO: Scylla gains a Paralysis aura after using this skill. Maybe handle in mob script.
    end

    return damage
end

return mobskillObject
