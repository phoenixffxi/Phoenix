-----------------------------------
-- Homing Missle
-- Family: Chariots
-- Description: Deals near death damage to target. Resets hate.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage   = target:getHP() * 0.90
    params.fTP          = { 1, 1, 1 }
    params.element      = xi.element.NONE -- TODO: Capture element (Possibly Fire?)
    params.skipTMDA     = true            -- TODO: Is it reduced by Shell?

    -- TODO: Long-Bowed Chariot mechanics
    -- https://www.bg-wiki.com/ffxi/Long-Bowed_Chariot

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.NONE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if  not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.NONE)

        mob:resetEnmity(target)
    end

    return damage
end

return mobskillObject
