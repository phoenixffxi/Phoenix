-----------------------------------
-- Leeching Current
-- Family: Orobons
-- Description: Deal Water damage spread evenly among targets in range. Additional Effect: HP Drain
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- We use a var here so that mobs can use different values
    local base = mob:getLocalVar('leechingCurrent')

    if base == 0 then
        base = 1000
    end

    params.baseDamage         = base / skill:getTotalTargets()
    params.fTP                = { 1, 1, 1 }
    params.element            = xi.element.WATER -- TODO: Capture if element is Water or Dark.
    params.skipMagicBonusDiff = true -- Captures show this does not get reduced by MDB.
    params.skipTMDA           = true -- TODO: Is this reduced by shell?
    params.skipResist         = true -- TODO: Can this be resisted?
    -- TODO: Can this be absorbed? Test With Liement.
    -- TODO: Does day/weather affect it?

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        -- Note: This is a drain move but it returns a normal damage message instead of a drain message.
        xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.HP, damage)
    end

    return damage
end

return mobskillObject
