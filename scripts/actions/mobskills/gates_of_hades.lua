-----------------------------------
-- Gates of Hades
-- Family: Cerberus
-- Description: Deals severe Fire damage to enemies within an area of effect. Additional effect: Burn
-- Notes: Only used when a cerberus's health is 25% or lower (may not be the case for Orthrus). The burn effect takes off upwards of 20 HP per tick.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:getHPP() < 25 then
        return 0
    end

    return 1
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl()
    params.fTP             = { 12.5, 12.5, 12.5 }
    params.element         = xi.element.FIRE
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

        local power = 30
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BURN, power, 3, 60)
    end

    return damage
end

return mobskillObject
