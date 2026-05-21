-----------------------------------
-- Attachment: Damage Gauge
-- Causes an automaton with access to healing magic use Cure sooner and reduces the recast time for healing magic. Reduces healing magic cooldown further for each active light maneuver.
-- Light Maneuvers increase the percent that the automaton will cure its master, but not itself, this will always remain at 50%.
-- Equipping Damage Gauge also increases when Replicator activates, from ≤50% to ≤75%.
-----------------------------------
---@type TAttachment
local attachmentObject = {}

attachmentObject.onEquip = function(pet, attachment)
    xi.automaton.onAttachmentEquip(pet, attachment) -- Used for Healing Magic interactions.
    pet:setLocalVar('damageGaugeEquipped', 1) -- Used for Replicator interactions.
end

attachmentObject.onUnequip = function(pet, attachment)
    xi.automaton.onAttachmentUnequip(pet, attachment) -- Used for Healing Magic interactions.
    pet:setLocalVar('damageGaugeEquipped', 0) -- Used for Replicator interactions.
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
