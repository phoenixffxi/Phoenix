-----------------------------------
-- Marrow Drain
-- Family: Big Bat (Single Bat)
-- Description: Steals an enemy's MP. Ineffective against undead.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage     = mob:getMainLvl() - 2
    params.additiveDamage = { 0, 5, 10 }
    params.fTP            = { 1, 1, 1 }
    params.element        = xi.element.DARK

    -- From captures, TP Drains don't seem to be affected by these.
    params.skipTMDA           = true
    params.skipResist         = true
    params.skipMagicBonusDiff = true
    params.skipAbsorbNullify  = true
    -- TODO: Does Day/Weather affect MP Drains? Need more capture data.
    -- TODO: This skill should penetrate/deal no damage to stoneskin.
    --       Need to pass a param into mobFinalAdjustments in the future.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        skill:setMsg(xi.mobskills.mobPhysicalDrainMove(mob, target, skill, xi.mobskills.drainType.MP, damage))
    end

    return damage
end

return mobskillObject
