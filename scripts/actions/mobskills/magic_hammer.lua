-----------------------------------
-- Magic Hammer
-- Family: Poroggos
-- Description: Steals an amount of enemy's MP equal to damage dealt. Ineffective against undead.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- TODO: Verify message
    params.baseDamage      = mob:getMainLvl()
    params.fTP             = { 2.0, 2.0, 2.0 }
    params.element         = xi.element.LIGHT
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)

        -- TODO: MP Drain might not be linked directly to damage dealt or may have other mechanics involved. See video capture below.
        -- Magic Hammer did 14 damage but drained 90 MP.
        -- https://youtu.be/Qy-i4KNMnWQ?t=276
        -- https://discord.com/channels/443544205206355968/791182054015762482/1128174532507729941
        local mpDrainRatio = damage * 0.10
        xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.MP, mpDrainRatio)
    end

    return damage
end

return mobskillObject
