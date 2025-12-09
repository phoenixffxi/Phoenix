-----------------------------------
-- Hydro Wave
-- Family: Ruszors
-- Description: Deals Water damage to enemies around the caster. Removes 1 piece of equipment.
-- Notes: Ruszors will absorb Water damage after using this move. (Handled in Ruszor mixin)
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.50, 2.50, 2.50 }
    params.element    = xi.element.WATER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

         -- Remove 1 piece of equipment from a random slot.
        xi.mobskills.unequipRandomSlots(target, 1)
    end

    -- Water aura that provides special stoneskin that absorbs only magical/breath/non-elemental damage
    skill:setFinalAnimationSub(2)
    mob:delStatusEffectSilent(xi.effect.STONESKIN)
    mob:addStatusEffect(xi.effect.STONESKIN, 0, 0, 180, 2, 1500)

    return damage
end

return mobskillObject
