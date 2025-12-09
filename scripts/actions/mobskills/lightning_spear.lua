-----------------------------------
-- Lightning Spear
-- Family: Monoceros (Dark Ixion)
-- Description: Wide Cone Attack Thunder damage (600-1500). Additional Effect: Amnesia
-- Notes: Will pick a random person on the hate list for this attack.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 20.0, 20.0, 20.0 }
    params.element    = xi.element.THUNDER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

        local duration   = xi.mobskills.calculateDuration(30, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.AMNESIA, 1, 0, duration) -- TODO: Capture power of Amnesia
    end

    return damage
end

return mobskillObject
