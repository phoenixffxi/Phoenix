-----------------------------------
-- Analyzer (Pre 2012)
-- Reduces damage taken from repeated TP moves by 10%, with an additional 10% per Earth Maneuver.
-- Resets after a new skill is used.
-- Was changed March 27th, 2012 to analyze multiple TP moves based off earth maneuvers, with a 40% damage reduction.
-- NOTE: This module touches both the attachment, and the combat utility. Both are needed for this attachment to function correctly.
-- https://wiki.ffo.jp/html/10746.html
-----------------------------------
require('modules/module_utils')
-----------------------------------

local moduleName = 'era_analyzer'

if xi.module.isContentEnabled('ABYSSEA') then
    return { name = moduleName }
end

local m = Module:new(moduleName)

-----------------------------------
-- Attachment Module
-----------------------------------
m:addOverride('xi.actions.abilities.pets.attachments.analyzer.onEquip', function(pet, attachment)
    -- Analyzed skills do not carry over between zones, onEquip is called when rebuilding the automaton after zoning.
    pet:setLocalVar('analyzedSkill1', 0)

    pet:addListener('WEAPONSKILL_TAKE', 'ANALYZER_WEAPONSKILL_TAKE', function(mob, target, skill, tp, action)
        local analyzerModifier = target:getMod(xi.mod.AUTO_ANALYZER)
        local incomingSkill    = skill:getID()

        -- If Analyzer modifier is 0, return. (Should be impossible since the attachment wouldn't be equipped, but just in case.)
        if analyzerModifier <= 0 then
            return
        end

        local analyzedSkill = target:getLocalVar('analyzedSkill1')

        -- If the incoming skill is the one we have already analyzed, return.
        if incomingSkill == analyzedSkill then
            return
        end

        -- If the incoming skill is different from the analyzed skill, update the analyzed skill ID.
        if incomingSkill ~= analyzedSkill then
            target:setLocalVar('analyzedSkill1', incomingSkill)
        end
    end)

    xi.automaton.onAttachmentEquip(pet, attachment)
end)

m:addOverride('xi.actions.abilities.pets.attachments.analyzer.onUnequip', function(pet, attachment)
    -- Clear analyzed skill on unequip, and remove the listener.
    pet:setLocalVar('analyzedSkill1', 0)

    pet:removeListener('ANALYZER_WEAPONSKILL_TAKE')

    xi.automaton.onAttachmentUnequip(pet, attachment)
end)

m:addOverride('xi.actions.abilities.pets.attachments.analyzer.onManeuverGain', function(pet, attachment, maneuvers)
end)

m:addOverride('xi.actions.abilities.pets.attachments.analyzer.onManeuverLose', function(pet, attachment, maneuvers)
end)

m:addOverride('xi.actions.abilities.pets.attachments.analyzer.onUpdate', function(pet, attachment, maneuvers)
end)

-----------------------------------
-- Combat Utility Override
-----------------------------------
m:addOverride('utils.handleAutomatonAutoAnalyzer', function(actor, skill, damage)
    local analyzerModifier = actor:getMod(xi.mod.AUTO_ANALYZER)

    -- If no Analyzer equipped, return unmodified damage.
    if analyzerModifier <= 0 then
        return damage
    end

    local automatonId = actor:getID()

    -- If we can't track this automaton, return unmodified damage.
    if not automatonId then
        return damage
    end

    local automatonMaster = actor:getMaster()

    -- If we can't get the master of this automaton, return unmodified damage.
    if not automatonMaster then
        return damage
    end

    local incomingSkill = skill:getID()
    local analyzedSkill = actor:getLocalVar('analyzedSkill1')

    -- If the incoming skill is the same ID as the analyzed skill, apply the Analyzer damage reduction and return.
    if incomingSkill == analyzedSkill then
        local earthManeuvers  = automatonMaster:countEffect(xi.effect.EARTH_MANEUVER)
        local damageReduction = 10 + 10 * earthManeuvers

        return math.floor(damage * (100 - damageReduction) / 100)
    end

    -- If we somehow make it here, return unmodified damage.
    return damage
end)

return m
