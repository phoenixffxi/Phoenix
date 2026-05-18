-----------------------------------
-- Bone Crusher
-- Description: Delivers a threefold attack. Additional Effect: Stun.
-----------------------------------
---@type TAbilityAutomaton
local abilityObject = {}

abilityObject.onAutomatonAbilityCheck = function(target, automaton, skill)
    local master = automaton:getMaster()

    if not master then
        return
    end

    return master:countEffect(xi.effect.LIGHT_MANEUVER)
end

abilityObject.onAutomatonAbility = function(target, automaton, skill, master, action)
    local params = {}

    params.baseDamage     = automaton:getWeaponDmg()
    params.numHits        = 3
    params.fTP            = { 1.5, 1.5, 1.5 }
    params.vit_wSC        = 0.60
    params.attackType     = xi.attackType.PHYSICAL
    params.damageType     = xi.damageType.BLUNT
    params.shadowBehavior = xi.mobskills.shadowBehavior.NUMSHADOWS_3

    if xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES then
        params.fTP = { 2.66, 2.66, 2.66 }

        if target:isUndead() then
            params.fTP = { 3.66, 3.66, 3.66 }
        end
    else
        if target:isUndead() then
            params.fTP = { 2.5, 2.5, 2.5 }
        end
    end

    -- Flame Holder Adjustment
    local flameHolderfTP = automaton:getMod(xi.mod.WEAPONSKILL_DAMAGE_BASE) / 100
    if flameHolderfTP > 0 then
        params.fTP =
        {
            params.fTP[1] * flameHolderfTP,
            params.fTP[2] * flameHolderfTP,
            params.fTP[3] * flameHolderfTP,
        }
    end

    local info = xi.mobskills.mobPhysicalMove(automaton, target, skill, action, params)

    if xi.mobskills.processDamage(automaton, target, skill, action, info) then
        target:takeDamage(info.damage, automaton, info.attackType, info.damageType)

        xi.mobskills.mobStatusEffectMove(automaton, target, xi.effect.STUN, 1, 0, 4)
    end

    return info.damage
end

return abilityObject
