-----------------------------------
-- Nerve Gas
-- Family: Hydras
-- Description: Deals Magic (Element unknown) damage to targets around mob. Additional Effect: Curse, Poison
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:getFamily() == 313 then -- Tinnin can use at will
        return 0
    else
        if mob:getAnimationSub() == 0 then -- 3 Heads
            return 0
        else
            return 1
        end
    end
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1.0, 1.0, 1.0 } -- TODO: Capture fTPs
    params.element    = xi.element.NONE   -- TODO: Capture element (Water or None?)

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.NONE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.NONE)

        -- TODO: Capture power/durations
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.CURSE_I, 50, 0, 420)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, 20, 3, 60)
    end

    return damage
end

return mobskillObject
