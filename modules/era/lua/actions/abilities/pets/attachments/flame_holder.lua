-----------------------------------
-- Flame Holder
-- Reverts Flame Holder to its pre-2015 functionality - Where it consumed Fire Maneuvers on skill execution.
-- Flame Holder Bonus increased on August 5th, 2015.
-- Changed to no longer consume Fire Maneuvers on August 6th, 2019.
-- Source : https://wiki.ffo.jp/html/11183.html
-----------------------------------
require('modules/module_utils')
-----------------------------------
local moduleName = 'era_flame_holder'

if xi.module.isContentEnabled('SOA') then
    return { name = moduleName }
end

local m = Module:new(moduleName)

local validSkills = set
{
    xi.mobSkill.ARCUBALLISTA_AUTOMATON,
    xi.mobSkill.ARMOR_PIERCER_AUTOMATON,
    xi.mobSkill.ARMOR_SHATTERER_AUTOMATON,
    xi.mobSkill.BONE_CRUSHER_AUTOMATON,
    xi.mobSkill.CANNIBAL_BLADE_AUTOMATON,
    xi.mobSkill.CHIMERA_RIPPER_AUTOMATON,
    xi.mobSkill.DAZE_AUTOMATON,
    xi.mobSkill.KNOCKOUT_AUTOMATON,
    xi.mobSkill.MAGIC_MORTAR_AUTOMATON,
    xi.mobSkill.SLAPSTICK_AUTOMATON,
    xi.mobSkill.STRING_CLIPPER_AUTOMATON,
    xi.mobSkill.STRING_SHREDDER_AUTOMATON,
}

m:addOverride('xi.actions.abilities.pets.attachments.flame_holder.onEquip', function(pet, attachment)
    pet:addListener('WEAPONSKILL_STATE_ENTER', 'AUTO_FLAME_HOLDER_START', function(automaton, skillId)
        -- Not a valid skill for Flame Holder
        if not validSkills[skillId] then
            return
        end

        local master = automaton:getMaster()

        if not master then
            return
        end

        -- Fetch the amount of active Fire Maneuvers on weaponskill state entry.
        local fireManeuvers = master:countEffect(xi.effect.FIRE_MANEUVER)

        -- No Fire Maneuvers
        if fireManeuvers == 0 then
            return
        end

        -- Set the WEAPONSKILL_DAMAGE_BASE mod to 125% / 150% / 175% based on the number of Fire Maneuvers active.
        local flameHolderAmount = 100 + 25 * fireManeuvers

        automaton:setLocalVar('fireManeuvers', fireManeuvers)
        automaton:setLocalVar('flameHolderAmount', flameHolderAmount)
        automaton:addMod(xi.mod.WEAPONSKILL_DAMAGE_BASE, flameHolderAmount)
    end)

    pet:addListener('WEAPONSKILL_STATE_EXIT', 'AUTO_FLAME_HOLDER_END', function(automaton, skillId, wasExecuted)
        local flameHolderAmount = automaton:getLocalVar('flameHolderAmount')

        -- If no Flame Holder bonus is active, do nothing.
        if flameHolderAmount == 0 then
            return
        end

        local fireManeuvers = automaton:getLocalVar('fireManeuvers')
        local master        = automaton:getMaster()

        if not master then
            return
        end

        -- Consume all Fire Maneuvers on execution.
        for i = 1, fireManeuvers do
            master:delStatusEffectSilent(xi.effect.FIRE_MANEUVER)
        end

        -- Remove the Flame Holder bonus and reset local variables.
        automaton:delMod(xi.mod.WEAPONSKILL_DAMAGE_BASE, flameHolderAmount)
        automaton:setLocalVar('flameHolderAmount', 0)
        automaton:setLocalVar('fireManeuvers', 0)
    end)
end)

m:addOverride('xi.actions.abilities.pets.attachments.flame_holder.onUnequip', function(pet, attachment)
    local amount = pet:getLocalVar('flameHolderAmount')

    -- Should be nearly impossible, but just in case.
    if amount ~= 0 then
        pet:delMod(xi.mod.WEAPONSKILL_DAMAGE_BASE, amount)
    end

    pet:setLocalVar('flameHolderAmount', 0)
    pet:setLocalVar('fireManeuvers', 0)
    pet:removeListener('AUTO_FLAME_HOLDER_START')
    pet:removeListener('AUTO_FLAME_HOLDER_END')
end)

m:addOverride('xi.actions.abilities.pets.attachments.flame_holder.onManeuverGain', function(pet, attachment, maneuvers)
end)

m:addOverride('xi.actions.abilities.pets.attachments.flame_holder.onManeuverLose', function(pet, attachment, maneuvers)
end)

m:addOverride('xi.actions.abilities.pets.attachments.flame_holder.onUpdate', function(pet, attachment, maneuvers)
end)

return m
