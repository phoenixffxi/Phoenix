-----------------------------------
-- ID: 4237
-- Item: Perpetual Hourglass
-- Use: Placeholder for Module
-----------------------------------
local itemObject = {}

itemObject.onItemCheck = function(target, item, param, caster)
    return xi.dynamis.onGlassCheck(target, item)
end

itemObject.onItemUse = function(target, user, item, action)
    xi.dynamis.onGlassUse(target, item)
end

itemObject.onItemDrop = function(target, item)
    xi.dynamis.onGlassDrop(target, item)
end

return itemObject
