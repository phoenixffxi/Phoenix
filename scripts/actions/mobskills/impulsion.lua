---------------------------------------------
-- Impulsion
-- Family: Bahamut
-- Description: Deals unaspected magical damage to enemies within an area of effect. Additional Effects: Blind, Knockback, Petrification
-- Note: Used by Bahamut in The Wyrmking Descends
---------------------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl()
    params.fTP        = { 2.75, 2.75, 2.75 }
    params.element    = xi.element.NONE
    -- TODO: Does this ignore or wipe shadows?
    -- TODO: Capture Knockback

    -- https://docs.google.com/spreadsheets/d/1YBoveP-weMdidrirY-vPDzHyxbEI2ryECINlfCnFkLI/edit?pli=1&gid=57955395#gid=57955395&range=A915
    -- TODO: Once Gigaflare is available for use, the fTP of this skill increases to 5.50.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.NONE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.ELEMENTAL)

        local petrifyDuration = 15
        -- TODO: Once Gigaflare is available for use, the duration of petrification increases to 30.
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PETRIFICATION, 1, 0, petrifyDuration)

        -- TODO: Confirm Blind effect, power/duration.
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 15, 0, 60)
    end

    return damage
end

return mobskillObject
