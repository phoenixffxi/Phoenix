-----------------------------------
-- String Clipper
-- Description: Delivers a twofold attack. Accuracy varies with TP.
-----------------------------------
---@type TAbilityAutomaton
local abilityObject = {}

abilityObject.onAutomatonAbilityCheck = function(target, automaton, skill)
    local master = automaton:getMaster()

    if not master then
        return
    end

    return master:countEffect(xi.effect.THUNDER_MANEUVER)
end

abilityObject.onAutomatonAbility = function(target, automaton, skill, master, action)
    local params = {}

    params.baseDamage       = automaton:getWeaponDmg()
    params.numHits          = 2
    params.fTP              = { 2.0, 2.0, 2.0 }
    params.str_wSC          = 0.30
    params.dex_wSC          = 0.30
    params.attackMultiplier = { 1.5, 1.5, 1.5 }
    params.accuracyModifier = { 0, 50, 100 }
    params.attackType       = xi.attackType.PHYSICAL
    params.damageType       = xi.damageType.SLASHING
    params.shadowBehavior   = xi.mobskills.shadowBehavior.NUMSHADOWS_2

    if xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES then
        params.fTP = { 3.5, 3.5, 3.5 }
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
    end

    return info.damage
end

return abilityObject
