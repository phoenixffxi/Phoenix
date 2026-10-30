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
    { threshold = 500,       rate = 0 },  -- Below 500: no penalty
    { threshold = 1000,      rate = 15 }, -- 500-999:   1.5% per level
    { threshold = 2000,      rate = 20 }, -- 1000-1999: 2.0% per level
    { threshold = math.huge, rate = 25 }, -- 2000+:     2.5% per level
}

local function updatePenaltyRate()
    -- Guard for builds missing the paired cpp module
    if type(GetOnlinePlayerCount) ~= 'function' then
        return
    end

    local playerCount = GetOnlinePlayerCount()
    local penaltyPerLevel = 0

    for i = 1, #penaltyTiers do
        if playerCount < penaltyTiers[i].threshold then
            penaltyPerLevel = penaltyTiers[i].rate
            break
        end
    end

    SetServerVariable('[SyncPenalty]RatePerLevel', penaltyPerLevel)
end

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

    -- Calculate total penalty (grace levels count once the penalty kicks in)
    local totalPenalty = (levelDiff * penaltyPerLevel) / 10
    totalPenalty = math.min(totalPenalty, maxPenalty)

    return math.floor(totalPenalty)
end

local function removePenalty(player)
    local penaltyAmount = player:getLocalVar('[SyncPenalty]Amount')

    if penaltyAmount > 0 then
        player:addMod(xi.mod.EXP_BONUS, penaltyAmount)
        player:setLocalVar('[SyncPenalty]Amount', 0)
    end
end

-- Determines and applies the appropriate penalty to level synced player
local function applyPenalty(player)
    removePenalty(player)

    local penaltyValue = calculatePenalty(player)

    if penaltyValue == 0 then
        return
    end

    player:setLocalVar('[SyncPenalty]Amount', penaltyValue)
    player:delMod(xi.mod.EXP_BONUS, penaltyValue)
end

-- Set the penalty rate on startup
m:addOverride('xi.server.onServerStart', function()
    super()

    updatePenaltyRate()
end)

-- Update penalty tiers every 12 Vana'diel hours (28.8 real minutes), triggered once in GM Home zone file
-- Synced players pick up the new rate after their next EXP award
m:addOverride('xi.zones.GM_Home.Zone.onGameHour', function(zone)
    super(zone)

    if VanadielHour() % 12 == 0 then
        updatePenaltyRate()
    end
end)

-- Recalculate the penalty when a synced player levels up their actual job
m:addOverride('xi.player.onPlayerLevelUp', function(player)
    super(player)

    if player:hasStatusEffect(xi.effect.LEVEL_SYNC) then
        applyPenalty(player)
    end
end)

-- Apply penalty when level sync effect is gained
m:addOverride('xi.effects.level_sync.onEffectGain', function(target, effect)
    super(target, effect)

    if target:getObjType() == xi.objType.PC then
        applyPenalty(target)

        -- Fires after the award, so a rate change lands on the following kill
        target:addListener('EXPERIENCE_POINTS', '[SyncPenalty]Refresh', function(player)
            applyPenalty(player)
        end)
    end
end)

-- Remove penalty when level sync effect is lost
m:addOverride('xi.effects.level_sync.onEffectLose', function(target, effect)
    super(target, effect)

    if target:getObjType() == xi.objType.PC then
        target:removeListener('[SyncPenalty]Refresh')
        removePenalty(target)
    end
end)
