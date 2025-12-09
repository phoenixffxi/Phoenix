-----------------------------------
-- Implosion
-- Family: Shadow Lord
-- Description: Channels a wave of negative energy, damaging all targets in very wide area of effect.
-- Notes: Used during phase 2 of Shadow Lord mission fight.
-- Also used by Shadow Lord in past but with different properties. https://wiki.ffo.jp/html/19868.html
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- TODO: Version used in past reportedly deals 50% Max HP Damage + Knockback
    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1, 1, 1 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)
    end

    return damage
end

return mobskillObject
