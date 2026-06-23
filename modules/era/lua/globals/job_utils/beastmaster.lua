-----------------------------------
-- Module: Beastmaster Job Adjustments
-----------------------------------
require('modules/module_utils')
-----------------------------------
local moduleName = 'era_job_utils_beastmaster'

-- If Abyssea or later is enabled, no changes.
if xi.module.isContentEnabled('ABYSSEA') then
    return { name = moduleName }
end

local m = Module:new(moduleName)

-- Reward: Override pet food healing values to pre-Abyssea values
-- Source: https://www.bg-wiki.com/ffxi/Version_Update_(09/08/2010)
xi.job_utils.beastmaster.petFoodData =
{
    [xi.item.PET_FOOD_ALPHA_BISCUIT]   = { minHealing =  25, regen =  1, mndMult = 2, mndThreshold = 10 },
    [xi.item.PET_FOOD_BETA_BISCUIT]    = { minHealing =  50, regen =  3, mndMult = 1, mndThreshold = 33 },
    [xi.item.PET_FOOD_GAMMA_BISCUIT]   = { minHealing = 100, regen =  5, mndMult = 1, mndThreshold = 35 },
    [xi.item.PET_FOOD_DELTA_BISCUIT]   = { minHealing = 150, regen =  8, mndMult = 2, mndThreshold = 40 },
    [xi.item.PET_FOOD_EPSILON_BISCUIT] = { minHealing = 300, regen = 11, mndMult = 2, mndThreshold = 45 },
    [xi.item.PET_FOOD_ZETA_BISCUIT]    = { minHealing = 350, regen = 14, mndMult = 3, mndThreshold = 45 },
}

-- Feral Howl: Apply merit recast reduction, remove extra accuracy from merits
m:addOverride('xi.job_utils.beastmaster.useFeralHowl', function(player, target, ability, action)
    local recastReduction = player:getMerit(xi.merit.FERAL_HOWL) - 150
    action:setRecast(action:getRecast() - recastReduction)

    if
        not xi.data.statusEffect.isTargetImmune(target, xi.effect.TERROR, xi.element.DARK) and
        not xi.data.statusEffect.isTargetResistant(player, target, xi.effect.TERROR) and
        not xi.data.statusEffect.isEffectNullified(target, xi.effect.TERROR, 0)
    then
        local resistanceRate = xi.combat.magicHitRate.calculateResistRate(player, target, 0, 0, xi.skillRank.B_MINUS, xi.element.DARK, xi.mod.CHR, xi.effect.TERROR)

        if xi.data.statusEffect.isResistRateSuccessfull(xi.effect.TERROR, resistanceRate, 0) then
            target:addStatusEffect(xi.effect.TERROR, { power = 1, duration = 10 * resistanceRate, origin = player })
        end
    end

    return xi.effect.TERROR
end)

-- Killer Insinct: Apply merit recast reduction, remove extra duration from merits
m:addOverride('xi.job_utils.beastmaster.useKillerInstinct', function(player, target, ability, action)
    local recastReduction = player:getMerit(xi.merit.KILLER_INSTINCT) - 150
    action:setRecast(action:getRecast() - recastReduction)

    -- Notes: Pet ecosystem is assigned to the subPower, then mapped to the correct killer mod in the effect script.
    local pet          = player:getPet()
    local petEcosystem = pet:getEcosystem()
    local power        = 10

    target:addStatusEffect(xi.effect.KILLER_INSTINCT, { power = power, duration = 60, origin = player, subPower = petEcosystem })

    return xi.effect.KILLER_INSTINCT
end)

return m
