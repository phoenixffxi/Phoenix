-----------------------------------
-- Account-wide Chocobo Digging Fatigue
-- Overrides the chocobo digging fatigue system to use account-wide tracking
-- instead of per-character tracking
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('chocobo_account_fatigue')

-- Override the fetchFatigue function to use account variables
m:addOverride('xi.chocoboDig.fetchFatigue', function(player)
    return player:getAccountVar('[DIG]DigCount')
end)

-- Override the updateFatigue function to use account variables
-- Uses NextJstDay() to match the original behavior for daily resets
m:addOverride('xi.chocoboDig.updateFatigue', function(player, newValue)
    player:setAccountVar('[DIG]DigCount', newValue, NextJstDay())
end)

return m
