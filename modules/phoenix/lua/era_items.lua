-----------------------------------
-- Era Items Module
-- Adjusts item availability and properties to match era-appropriate values
-- These are only meant to be here for items that require a DAT edit to change
-----------------------------------
local m = Module:new('era_items')

-- Chariot Band
-- Bonus: +75%
-- Duration: 720 min -> 90 min
-- Max bonus: 10000 exp -> 500 exp
m:addOverride('xi.items.chariot_band.onItemUse', function(target)
    local effect    = xi.effect.DEDICATION
    local power     = 75
    local duration  = 5400 -- 90 minutes in seconds
    local subpower  = 500  -- Max bonus of 500 exp

    xi.itemUtils.addItemExpEffect(target, effect, power, duration, subpower)
end)

-- Empress Band
-- Bonus: +50%
-- Duration: 720 min -> 180 min
-- Max bonus: 10000 exp -> 1000 exp
m:addOverride('xi.items.empress_band.onItemUse', function(target)
    local effect    = xi.effect.DEDICATION
    local power     = 50
    local duration  = 10800 -- 180 minutes in seconds
    local subpower  = 1000  -- Max bonus of 1000 exp

    xi.itemUtils.addItemExpEffect(target, effect, power, duration, subpower)
end)

-- Emperor Band
-- Bonus: +50%
-- Duration: 720 min -> 210 min
-- Max bonus: 30000 exp -> 2000 exp
m:addOverride('xi.items.emperor_band.onItemUse', function(target)
    local effect    = xi.effect.DEDICATION
    local power     = 50
    local duration  = 12600 -- 210 minutes in seconds
    local subpower  = 2000  -- Max bonus of 2000 exp

    xi.itemUtils.addItemExpEffect(target, effect, power, duration, subpower)
end)

-- Anniversary Ring
-- Bonus: +100%
-- Duration: 720 min
-- Max bonus: 10000 exp -> 3000 exp
m:addOverride('xi.items.anniversary_ring.onItemUse', function(target)
    local effect    = xi.effect.DEDICATION
    local power     = 100
    local duration  = 43200 -- 720 minutes in seconds
    local subpower  = 3000  -- Max bonus of 3000 exp

    xi.itemUtils.addItemExpEffect(target, effect, power, duration, subpower)
end)

-- Warp Cudgel
-- Duration: 3 seconds - > 30 seconds
m:addOverride('xi.items.warp_cudgel.onItemUse', function(target, user)
    target:addStatusEffect(xi.effect.TELEPORT, { power = xi.teleport.id.WARP, duration = 30, origin = user, icon = 0 })
end)

return m
