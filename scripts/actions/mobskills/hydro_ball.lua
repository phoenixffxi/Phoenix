-----------------------------------
-- Hydroball
-- Family: Sahagin
-- Description: Deals Water damage to targets in a fan-shaped area of effect. Additional Effect: STR Down
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 1.5, 1.5, 1.5 }
    params.element         = xi.element.WATER
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

        -- TODO: JP Wiki states this scales off mob level.
        -- https://discord.com/channels/443544205206355968/674750598939279400/1367925653667840250

        -- Need more captures to determine proper forumula.
        -- Capture thread: https://discord.com/channels/443544205206355968/674750598939279400/1367925653667840250

        -- There are at least 2 different versions of this move. Tan sahagin use skillID 771 while blue uses 772.
        -- Tan models seem to have a slightly weaker STR down.

        -- Captures had -17 STR at Level 35 and reaching -32 STR at 75.
        local power = math.ceil(mob:getMainLvl() * 0.375 + 3.875) -- Basic scaling formula for now until we get more data.

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.STR_DOWN, power, 9, 120)
    end

    return damage
end

return mobskillObject
