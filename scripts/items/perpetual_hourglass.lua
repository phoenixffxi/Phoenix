-----------------------------------
-- ID: 4237
-- Item: Perpetual Hourglass
-- Use: Placeholder for Module
-----------------------------------
local itemObject = {}

itemObject.onItemCheck = function(target, item, param, caster)
    return xi.itemUtils.itemBoxOnItemCheck(target)
end

itemObject.onItemUse = function(target, user, item, action)
    target:addItem( { id = xi.item.PERPETUAL_HOURGLASS, quantity = 2, exdata = item:getExData() })
end

return itemObject
