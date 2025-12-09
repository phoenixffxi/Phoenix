-----------------------------------
-- Lux Arrow
-- Trust: Semih Lafihna
-- Notes: Fragmentation/Distortion skillchain properties
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.50, 2.50, 2.50 } -- TODO: Capture fTPs
    params.element    = xi.element.LIGHT

    -- TODO: Capture Damage Type / Attack Type.
    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.RANGED, xi.damageType.PIERCING, xi.mobskills.shadowBehavior.NUMSHADOWS_1, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.RANGED, xi.damageType.PIERCING)
    end

    return damage
end

return mobskillObject
