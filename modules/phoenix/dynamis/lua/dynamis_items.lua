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
    return xi.dynamis.onGlassCheck(target, item)
end)

m:addOverride('xi.items.perpetual_hourglass.onItemUse', function(target, user, item, action)
    xi.dynamis.onGlassUse(target, item)
end)

return m
