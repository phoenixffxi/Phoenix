-----------------------------------
-- Phoenix Level Sync Penalty Module
-- Applies EXP penalties based on server population and level sync difference
-----------------------------------
require('modules/module_utils')
require('scripts/globals/npc_util')
-----------------------------------
-- luacheck: globals GetOnlinePlayerCount
-----------------------------------
local m = Module:new('population_level_sync_penalty')

-- Configuration (Launch values to be determined at a later date)
local graceLevels  = 10 -- No penalty within this many levels of sync target
local maxPenalty   = 50 -- Maximum penalty percentage

-- Population thresholds and penalty rates
local penaltyTiers =
{
    { threshold = 500,  rate = 0 },  -- Below 500: no penalty
    { threshold = 1000, rate = 15 }, -- 500-999:   1.5% per level
    { threshold = 2000, rate = 20 }, -- 1000-1999: 2.0% per level
    { threshold = 9999, rate = 25 }, -- 2000+:     2.5% per level
}

local function calculatePenalty(player)
    if not player then
        return 0
    end

    if not player:hasStatusEffect(xi.effect.LEVEL_SYNC) then
        return 0
    end

    -- Get player's actual level and current synced level
    local actualLevel = player:getJobLevel(player:getMainJob())
    local syncLevel = player:getMainLvl()
    local levelDiff = actualLevel - syncLevel

    if levelDiff <= graceLevels then
        return 0
    end

    local penaltyPerLevel = GetServerVariable('[SyncPenalty]RatePerLevel')
    if penaltyPerLevel == 0 then
        return 0
    end

    -- Calculate total penalty
    local levelsOver = levelDiff - graceLevels
    local totalPenalty = (levelsOver * penaltyPerLevel) / 10
    totalPenalty = math.min(totalPenalty, maxPenalty)

    return math.floor(totalPenalty)
end

-- Determines and applies the appropriate penalty to level synced player
local function applyPenalty(player)
    local penaltyValue = calculatePenalty(player)

    if penaltyValue == 0 then
        return
    end

    player:setLocalVar('[SyncPenalty]Amount', penaltyValue)
    player:delMod(xi.mod.EXP_BONUS, penaltyValue)
end

local function removePenalty(player)
    local penaltyAmount = player:getLocalVar('[SyncPenalty]Amount')

    if penaltyAmount > 0 then
        player:addMod(xi.mod.EXP_BONUS, penaltyAmount)
        player:setLocalVar('[SyncPenalty]Amount', 0)
    end
end

-- Update penalty tiers every Vana'diel day, triggered once in GM Home zone file
m:addOverride('xi.zones.GM_Home.Zone.onGameDay', function()
    super()

    local playerCount = GetOnlinePlayerCount()
    local penaltyPerLevel = 0

    for i = 1, #penaltyTiers do
        if playerCount < penaltyTiers[i].threshold then
            penaltyPerLevel = penaltyTiers[i].rate
            break
        end
    end

    SetServerVariable('[SyncPenalty]RatePerLevel', penaltyPerLevel)
end)

-- When a player with sync levels up, recalculate and apply/remove penalty as needed for all party members
m:addOverride('xi.player.onPlayerLevelUp', function(player)
    super(player)

    if
        player:hasStatusEffect(xi.effect.LEVEL_SYNC) and
        GetServerVariable('[SyncPenalty]RatePerLevel') ~= 0
    then
        local party = player:getParty()
        for _, member in pairs(party) do
            removePenalty(member)
            applyPenalty(member)
        end
    end
end)

-- Apply penalty when level sync effect is gained
m:addOverride('xi.effects.level_sync.onEffectGain', function(target, effect)
    super(target, effect)

    if target:getObjType() == xi.objType.PC then
        applyPenalty(target)
    end
end)

-- Remove penalty when level sync effect is lost
m:addOverride('xi.effects.level_sync.onEffectLose', function(target, effect)
    super(target, effect)

    if target:getObjType() == xi.objType.PC then
        removePenalty(target)
    end
end)

return m
