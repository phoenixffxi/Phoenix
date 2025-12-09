-----------------------------------
-- MP Drainkiss
-- Family: Leeches
-- Description: Steals MP from target.
-- Notes: Ineffective vs undead.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 1.50, 1.50, 1.50 }
    params.element         = xi.element.DARK
    params.dStatMultiplier = 1.5
    -- TODO: This skill should penetrate/deal no damage to stoneskin.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        skill:setMsg(xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.MP, damage))
    end

    return damage
end

return mobskillObject
