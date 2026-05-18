-----------------------------------
-- Cannibal Blade
-- Description: Delivers a single hit attack. Additional Effect: Convert damage dealt to HP.
-----------------------------------
---@type TAbilityAutomaton
local abilityObject = {}

abilityObject.onAutomatonAbilityCheck = function(target, automaton, skill)
    local master = automaton:getMaster()

    if not master then
        return
    end

    return master:countEffect(xi.effect.DARK_MANEUVER)
end

abilityObject.onAutomatonAbility = function(target, automaton, skill, master, action)
    local params = {}

    params.baseDamage         = (math.floor(automaton:getSkillLevel(xi.skill.AUTOMATON_MELEE) / 9 * 11))
    params.numHits            = 1
    params.fTP                = { 1.0, 1.15, 1.3 }
    params.skipPDIF           = true
    params.guaranteedFirstHit = true
    params.attackType         = xi.attackType.PHYSICAL
    params.damageType         = xi.damageType.SLASHING
    params.shadowBehavior     = xi.mobskills.shadowBehavior.NUMSHADOWS_1

    if xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES then
        params.baseDamage = automaton:getWeaponDmg()
        params.fTP        = { 16.0, 23.5, 31.5 }
        params.mnd_wSC    = 1.0
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

        if not target:isUndead() then
            automaton:addHP(info.damage)
            skill:setMsg(xi.msg.basic.SKILL_DRAIN_HP)
        end
    end

    return info.damage
end

return abilityObject
