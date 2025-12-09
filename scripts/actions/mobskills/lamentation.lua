-----------------------------------
-- Lamentation
-- Family: Seethers
-- Description: Deals Light damage to all targets in range. Additional Effect: Dia
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1, 1, 1 } -- TODO: Capture fTPs
    params.element    = xi.element.LIGHT
    -- TODO: Capture shadowBehavior. JP Wiki says ignores shadows, EN Wikis say it wipes them.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.DIA, 8, 3, 30, 0, 20)

        local effect1 = target:getStatusEffect(xi.effect.DIA)
        if effect1 then
            effect1:delEffectFlag(xi.effectFlag.ERASABLE)
        end
    end

    return damage
end

return mobskillObject
