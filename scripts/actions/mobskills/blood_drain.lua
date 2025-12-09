-----------------------------------
-- Blood Drain
-- Family: Giant Bats
-- Description: Steals an enemy's HP. Ineffective against undead.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 1.00, 2.00, 2.83 }
    params.element         = xi.element.DARK

    -- From captures, this HP Drains don't seem to be affected by these.
    params.skipResist         = true
    params.skipMagicBonusDiff = true

    local shadowBehavior   = xi.mobskills.shadowBehavior.NUMSHADOWS_1

    -- Asanbosam (Pool ID 256) uses a modified Blood Drain that ignores shadows
    if mob:getPool() == xi.mobPools.ASANBOSAM then
        shadowBehavior = xi.mobskills.shadowBehavior.IGNORE_SHADOWS
    end

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, shadowBehavior, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        skill:setMsg(xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.HP, damage))
    end

    return damage
end

return mobskillObject
