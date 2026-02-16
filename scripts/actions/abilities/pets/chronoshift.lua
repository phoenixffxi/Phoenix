-----------------------------------
-- Chronoshift
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    local effectCount = 0
    local effectID    = pet:getLocalVar('aEffectID') or 0    -- Retrive the absorbed effect's ID
    local effect      = pet:getStatusEffect(effectID) or nil -- Find that effect on Atomos

    if effect then
        local effectIcon  = effect:getIcon()
        local power       = effect:getPower()
        local duration    = effect:getDuration() / 1000
        -- Delete old effect if on target already
        target:delStatusEffectSilent(effectID)
        -- Add the stolen effect to the party
        target:addStatusEffectEx(effectID, effectIcon, power, 0, duration, true)
        petskill:setMsg(xi.msg.basic.RECEIVE_MAGICAL_EFFECT)
        effectCount = 1
    else
        petskill:setMsg(xi.msg.basic.NO_EFFECT)
    end

    target:addEnmity(pet, 1, 60)

    pet:timer(5000, function()
        if summoner then
            summoner:despawnPet()
        end
    end)

    return effectCount
end

return abilityObject
