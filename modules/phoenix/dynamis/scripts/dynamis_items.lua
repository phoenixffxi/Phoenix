-----------------------------------
-- Dynasmis Item Overrides
-----------------------------------
-- This is only used for DYNAMIS only items.
-----------------------------------
local m = Module:new('dynamis_items')

-----------------------------------
-- perpetual_hourglass
-----------------------------------
m:addOverride('xi.items.perpetual_hourglass.onItemCheck', function(target, item, param, caster)
    return xi.itemUtils.itemBoxOnItemCheck(target)
end)

m:addOverride('xi.items.perpetual_hourglass.onItemUse', function(target, user, item, action)
    target:addItem( { id = xi.item.PERPETUAL_HOURGLASS, quantity = 2, exdata = item:getExData() })
end)

return m
