-----------------------------------
-- Deconstruction
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    if summoner == nil then
        return 0
    end

    local effectCount = 0
    local effectID = 0

    effectID = pet:stealStatusEffect(target)

    local newStatus = pet:getStatusEffect(effectID)

    if newStatus then
        -- Store the stolen effect ID for Chronoshift so we know what effect to transfer.
        pet:setLocalVar('aEffectID', effectID)
        target:delStatusEffectSilent(effectID)
        petskill:setMsg(xi.msg.basic.MAGIC_EFFECT_DRAINED)
        effectCount = 1
    else
        petskill:setMsg(xi.msg.basic.JA_NO_EFFECT_2)
    end

    target:addEnmity(pet, 1, 60)

    if summoner then
        target:addEnmity(summoner, 1, 0) -- this is to ensure you cannot cheese mobs with this, mob goes passive if not added
    end

    return effectCount
end

return abilityObject
