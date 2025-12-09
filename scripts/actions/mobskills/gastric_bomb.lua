-----------------------------------
-- Gastric Bomb
-- Family: Worms
-- Description: Deals Water damage with a long-range acid bomb. Additional Effect: Attack Down
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 2.0, 2.0, 2.0 }
    params.element         = xi.element.WATER
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)


    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

        -- TODO: Dreamland Dynamis ATTP power.
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.ATTACK_DOWN, 50, 0, 180)
    end

    return damage
end

return mobskillObject
