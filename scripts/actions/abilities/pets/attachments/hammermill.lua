-----------------------------------
-- Attachment: Hammermill
-----------------------------------
---@type TAttachment
local attachmentObject = {}

attachmentObject.onEquip = function(pet, attachment)
    xi.automaton.onAttachmentEquip(pet, attachment)
    pet:setLocalVar('hammermill', 1)
end

attachmentObject.onUnequip = function(pet, attachment)
    xi.automaton.onAttachmentUnequip(pet, attachment)
    pet:setLocalVar('hammermill', 0)
end

attachmentObject.onManeuverGain = function(pet, attachment, maneuvers)
    xi.automaton.onManeuverGain(pet, attachment, maneuvers)
end

attachmentObject.onManeuverLose = function(pet, attachment, maneuvers)
    xi.automaton.onManeuverLose(pet, attachment, maneuvers)
end

attachmentObject.onUpdate = function(pet, attachment, maneuvers)
    xi.automaton.updateAttachmentModifier(pet, attachment, maneuvers)
end

return attachmentObject
