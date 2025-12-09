-----------------------------------
-- Mephitic Spore
-- Family: Funguar
-- Description: Deals Dark damage to targets in a fan-shaped area of effect. Additional Effect: Poison
-- Notes: Used by Fairy Ring as its auto attack.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 4, 4, 4 }
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.BREATH, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.DARK)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, 50, 3, 180)

        skill:setMsg(xi.msg.basic.HIT_DMG) -- TODO: Move logic to mob final adjustments eventually.
    end

    return damage
end

return mobskillObject
