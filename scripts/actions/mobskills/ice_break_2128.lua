-----------------------------------
-- Ice Break (Hrungnir)
-- Family: Golems
-- Description: Deals ice damage to enemies within range. Additional Effect: "Bind."
-- Note: Shows as a regular attack
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 2.0, 2.0, 2.0 }
    params.element         = xi.element.ICE
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.ICE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.ICE, { breakBind = false })

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BIND, 1, 0, xi.mobskills.calculateDuration(skill:getTP(), 120, 180))
        skill:setMsg(xi.msg.basic.HIT_DMG) -- TODO: Handle in final adjustments eventually.
    end

    return damage
end

return mobskillObject
