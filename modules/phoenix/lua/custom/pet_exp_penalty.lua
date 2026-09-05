-----------------------------------
-- Phoenix Level-Restricted EXP and Pet EXP Penalty Module
-- Restores the experience points penalty applied in level-restricted zones added in 2004.
-- Parties of 3 or less will not be affected by the pet EXP penalty.
-- When 4 players are in the party, pets will only give 30% of their normal EXP (70% penalty).
-- When 5 players are in the party, pets will only give 20% of their normal EXP (80% penalty).
-- When 6 or more players are in the party/alliance, pets will only give 10% of their normal EXP (90% penalty).
-----------------------------------
require('modules/module_utils')

local m = Module:new('pet_exp_penalty', xi.pre(xi.expansion.ABYSSEA))

-- Zones where the level capped experience penalty applies.
local cappedZones =
{
    [xi.zone.PSOXJA]             = true,
    [xi.zone.PROMYVION_HOLLA]    = true,
    [xi.zone.PROMYVION_DEM]      = true,
    [xi.zone.PROMYVION_MEA]      = true,
    [xi.zone.PROMYVION_VAHZL]    = true,
    [xi.zone.PHOMIUNA_AQUEDUCTS] = true,
    [xi.zone.SACRARIUM]          = true,
    [xi.zone.RIVERNE_SITE_A01]   = true,
    [xi.zone.RIVERNE_SITE_B01]   = true,
}

local function getExperienceToLevel(level)
    if level <= 7 then
        return 250 * (level + 1)
    elseif level <= 22 then
        return 200 * level + 600
    end

    return 100 * level + 2800
end

local function getExperienceGrade(data)
    if
        data.highestMemberLevel > 50 or
        data.highestMemberLevel > data.memberLevel + 7
    then
        return data.baseExp * data.memberLevel / data.highestMemberLevel
    end

    return data.baseExp * data.memberTNL / data.highestMemberTNL
end

local function getActualPartyLevel(member, mob, data)
    local actualLevel   = member:getJobLevel(member:getMainJob())
    local highestActual = math.min(math.max(actualLevel, data.highestMemberLevel), 99)

    local mobLevel        = mob:getMainLvl() + mob:getMod(xi.mod.EXP_LVL_MOD)
    local baseTableRow    = xi.data.experiencePoints.baseTable[utils.clamp(mobLevel - highestActual, -44, 15)]
    local actualPartyData = {}
    for key, value in pairs(data) do
        actualPartyData[key] = value
    end

    actualPartyData.baseExp            = baseTableRow[math.floor((highestActual - 1) / 5) + 1]
    actualPartyData.memberLevel        = actualLevel
    actualPartyData.highestMemberLevel = highestActual

    if highestActual <= 50 and highestActual <= actualLevel + 7 then
        actualPartyData.memberTNL        = getExperienceToLevel(actualLevel)
        actualPartyData.highestMemberTNL = getExperienceToLevel(highestActual)
    end

    return actualPartyData
end

-- EXP removed from monster-owned pets, by party size.
local penaltyBySize =
{
    [4] = 70,
    [5] = 80,
    [6] = 90,
}

m:addOverride('xi.experiencePoints.calculate', function(member, mob, data)
    local calculationData     = data
    local hasLevelRestriction = member:getStatusEffect(xi.effect.LEVEL_RESTRICTION)
    if
        cappedZones[member:getZoneID()] and
        hasLevelRestriction and
        member:getMainLvl() < member:getJobLevel(member:getMainJob())
    then
        local actualPartyData = getActualPartyLevel(member, mob, data)
        if getExperienceGrade(data) * 0.5 <= getExperienceGrade(actualPartyData) then
            calculationData = actualPartyData
        else
            calculationData = {}
            for key, value in pairs(data) do
                calculationData[key] = value
            end

            calculationData.baseExp = data.baseExp * 0.5
        end
    end

    local result = super(member, mob, calculationData)

    if not result or data.partySize < 4 then
        return result
    end

    local master = mob:getMaster()
    if not master or not master:isMob() then
        return result
    end

    local penalty = penaltyBySize[math.min(data.partySize, 6)]
    result.exp = math.floor(result.exp * (100 - penalty) / 100)

    return result
end)
