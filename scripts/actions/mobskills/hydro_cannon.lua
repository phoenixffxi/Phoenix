-----------------------------------
-- Hydro Cannon
-- Family: Ultima
-- Description: Deals Water damage in a conal AOE. Additional Effect : 30hp/tick Poison
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = 350
    params.fTP        = { 1, 1, 1 }
    params.element    = xi.element.WATER
    params.useTBDA    = true

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

        xi.mobskills.mobPhysicalStatusEffectMove(mob, target, skill, xi.effect.POISON, 30, 3, 120)

        if target:hasStatusEffect(xi.effect.ELEMENTALRES_DOWN) then
            target:delStatusEffectSilent(xi.effect.ELEMENTALRES_DOWN)
        end
    end

    mob:setLocalVar('nuclearWaste', 0) -- TODO: Handle in mob script?

    return damage
end

return mobskillObject
