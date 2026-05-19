-----------------------------------
-- Magic Mortar
-- Description: Damage varies with Automaton HP.
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

    params.baseDamage     = automaton:getMaxHP() - automaton:getHP()
    params.fTP            = { 0.50, 0.75, 1.00 }
    params.element        = xi.element.NONE
    params.attackType     = xi.attackType.MAGICAL
    params.damageType     = xi.damageType.ELEMENTAL
    params.shadowBehavior = xi.mobskills.shadowBehavior.IGNORE_SHADOWS

    if xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES then
        params.fTP = { 1.5, 1.75, 2.5 }
    end

    -- Flame Holder multiplies the base damage of Magic Mortar.
    local flameHolderModifier = 1.0 + automaton:getMod(xi.mod.WEAPONSKILL_DAMAGE_BASE) / 1000

    if flameHolderModifier > 1.0 then
        params.baseDamage = math.floor(params.baseDamage * flameHolderModifier)
    end

    -- A flat amount of damage is added to Magic Mortar based on the automatons skill level, not multiplied by Flame Holder.
    local automatonSkill  = automaton:getSkillLevel(xi.skill.AUTOMATON_MELEE)

    params.baseDamage = params.baseDamage + automatonSkill

    local info = xi.mobskills.mobMagicalMove(automaton, target, skill, action, params)

    if xi.mobskills.processDamage(automaton, target, skill, action, info) then
        target:takeDamage(info.damage, automaton, info.attackType, info.damageType)
    end

    return info.damage
end

return abilityObject
