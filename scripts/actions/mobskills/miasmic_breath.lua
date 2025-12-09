-----------------------------------
-- Miasmic Breath
-- Family: Morbol
-- Description: A toxic odor is exhaled on any players in a fan-shaped area of effect.
-- Notes: Deals Breath damage and follows corresponding damage reductions but damage is not based on HP.
-- Used by Cirrate Christelle
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 4, 4, 4 }
    params.element    = xi.element.DARK
    params.useTBDA    = true

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.BREATH, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.DARK)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, 50, 3, 60)

        -- TODO: At some point we should handle skill attacks with a param to toggle messaging type.
        -- For now, we will just do a check here to convert xi.msg.basic.DAMAGE to xi.msg.basic.HIT_DMG.

        -- Note: Miasmic Breath (1604) uses Msg 185(xi.msg.basic.DAMAGE)
        -- Note: Miasmic Breath (1605) uses Msg 1(xi.msg.basic.HIT_DMG)
        -- https://youtu.be/QHcGtTR_xQg?t=879

        if skill:getID() == xi.mobSkill.MIASMIC_BREATH_2 then
            if skill:getMsg() == xi.msg.basic.DAMAGE then
                skill:setMsg(xi.msg.basic.HIT_DMG)
            end
        end
    end

    return damage
end

return mobskillObject
