-----------------------------------
-- Ice Maker
-- Reverts Ice Maker to its pre-2015 functionality - Where it consumed Ice Maneuvers on skill execution.
-- Icemaker MAB Coefficients increased on August 5th, 2015.
-- Changed to no longer consume Ice Maneuvers on August 6th, 2019.
-- Source : https://wiki.ffo.jp/html/11198.html
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('era_ice_maker')

m:addOverride('xi.actions.abilities.pets.attachments.ice_maker.onEquip', function(pet, attachment)
    pet:addListener('MAGIC_START', 'AUTO_ICE_MAKER_START', function(automaton, skillId)
        local master = automaton:getMaster()

        if not master then
            return
        end

        local iceManeuvers = master:countEffect(xi.effect.ICE_MANEUVER)

        if iceManeuvers == 0 then
            return
        end

        local iceMakerAmount = 20 * iceManeuvers

        automaton:setLocalVar('iceManeuvers', iceManeuvers)
        automaton:setLocalVar('iceMakerAmount', iceMakerAmount)
        automaton:addMod(xi.mod.AUTO_MAB_COEFFICIENT, iceMakerAmount)
    end)

    pet:addListener('MAGIC_STATE_EXIT', 'AUTO_ICE_MAKER_END', function(automaton, skillId, wasExecuted)
        local iceMakerAmount = automaton:getLocalVar('iceMakerAmount')

        -- If no Ice Maker bonus, do nothing.
        if iceMakerAmount == 0 then
            return
        end

        local iceManeuvers = automaton:getLocalVar('iceManeuvers')
        local master        = automaton:getMaster()

        if not master then
            return
        end

        -- Consume all Ice Maneuvers on magic state exit.
        for i = 1, iceManeuvers do
            master:delStatusEffectSilent(xi.effect.ICE_MANEUVER)
        end

        automaton:delMod(xi.mod.AUTO_MAB_COEFFICIENT, iceMakerAmount)
        automaton:setLocalVar('iceMakerAmount', 0)
        automaton:setLocalVar('iceManeuvers', 0)
    end)
end)

m:addOverride('xi.actions.abilities.pets.attachments.ice_maker.onUnequip', function(pet, attachment)
    local amount = pet:getLocalVar('iceMakerAmount')

    if amount ~= 0 then
        pet:delMod(xi.mod.AUTO_MAB_COEFFICIENT, amount)
    end

    pet:setLocalVar('iceMakerAmount', 0)
    pet:setLocalVar('iceManeuvers', 0)
    pet:removeListener('AUTO_ICE_MAKER_START')
    pet:removeListener('AUTO_ICE_MAKER_END')
end)

m:addOverride('xi.actions.abilities.pets.attachments.ice_maker.onManeuverGain', function(pet, attachment, maneuvers)
end)

m:addOverride('xi.actions.abilities.pets.attachments.ice_maker.onManeuverLose', function(pet, attachment, maneuvers)
end)

m:addOverride('xi.actions.abilities.pets.attachments.ice_maker.onUpdate', function(pet, attachment, maneuvers)
end)

return m
