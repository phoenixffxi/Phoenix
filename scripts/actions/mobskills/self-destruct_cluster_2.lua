-----------------------------------
-- Self-Destruct
-- Used when only two clusters remain
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local damage = math.floor(mob:getHP() / 3)

    if mob:getPool() == xi.mobPool.RAZON then
        damage = mob:getMaxHP() / 2
        if mob:getHPP() <= 33 then
            damage = 0
        end
    end

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, damage, xi.element.FIRE, 0.4, xi.mobskills.magicalTpBonus.MAB_BONUS, 1)
    damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    skill:setFinalAnimationSub(6)

    return damage
end

return mobskillObject
