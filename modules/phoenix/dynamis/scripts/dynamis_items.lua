-----------------------------------
-- Dynasmis Item Overrides
-----------------------------------
-- This is only used for DYNAMIS only items.
-----------------------------------
local m = Module:new('dynamis_items')

-----------------------------------
-- perpetual_hourglass
-----------------------------------
m:addOverride('xi.items.perpetual_hourglass.onItemCheck', function(target, effect)
    -- Only allow inside dynamis and previous zone
    local targetZone = target:getZoneID()
    local zoneID = xi.dynamis.entryInfoEra[targetZone] -- Check if the target is in the zone before dyna

    if target:isInDynamis() then
        zoneID = targetZone
    elseif zoneID then
        zoneID = zoneID.dynaZone
    else
        return xi.msg.basic.ITEM_UNABLE_TO_USE
    end

    local zoneToken = GetServerVariable(string.format('[DYNA]Token_%s', zoneID))
    local validateresult = target:validateHourglass(zoneToken)
    local result = 0

    if target:getFreeSlotsCount() == 0 then
        result = xi.msg.basic.ITEM_NO_USE_INVENTORY
    end

    if not validateresult then
        result = xi.msg.basic.ITEM_UNABLE_TO_USE
    end

    return result
end)

m:addOverride('xi.items.perpetual_hourglass.onItemUse', function(target, effect)
    local targetZone = target:getZoneID()
    local zoneID = xi.dynamis.entryInfoEra[targetZone].dynaZone

    if target:isInDynamis() then
        zoneID = targetZone
    end

    local zoneToken = GetServerVariable(string.format('[DYNA]Token_%s', zoneID))
    local zoneOriginalRegistrant = GetServerVariable(string.format('[DYNA]OriginalRegistrant_%s', zoneID))

    target:duplicateHourglass(zoneID, zoneToken, zoneOriginalRegistrant) -- Duplicate the glass.
end)

return m
