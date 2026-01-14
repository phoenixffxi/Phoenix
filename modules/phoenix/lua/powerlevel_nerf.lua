-----------------------------------
-- Phoenix Power Leveling Nerf Module
--
-- Penalize players tanking mobs for parties they're not in.
-- Penalty stacks up to 5x (-20% EXP each), resets when mob roams at full HP.
-----------------------------------
require('modules/module_utils')

local m = Module:new('powerlevel_nerf')

-- Configuration
local maxPenalty      = 5
local penaltyPerStack = 20  -- 20% reduction per stack

-- Applies roam listener to mob to ensure exp penalty resets when mob roams at full HP
local function applyRoamListener(mob)
    if mob:getLocalVar('expReduction') > 0 then
        return
    end

    mob:addListener('ROAM_TICK', 'POWERLEVEL_NERF_ROAM', function(mobEntity)
        if mobEntity:getHPP() < 100 then
            return
        end

        mobEntity:setLocalVar('expReduction', 0)
        mobEntity:setMobMod(xi.mobMod.EXP_BONUS, 0)
        mobEntity:removeListener('POWERLEVEL_NERF_ROAM')
    end)
end

m:addOverride('xi.player.onGameIn', function(player, firstLogin, zoning)
    super(player, firstLogin, zoning)

    player:addListener('ATTACKED', 'POWERLEVEL_NERF_ATTACKED', function(playerEntity, attacker)
        if not attacker or not attacker:isMob() then
            return
        end

        if attacker:isNM() then
            return
        end

         -- Don't continue if the mob has no enmity table (not claimed)
        local enmityList = attacker:getEnmityList()
        if not enmityList or not next(enmityList) then
            return
        end

        -- Mob is claimed - check if player has claim
        if playerEntity:hasClaim(attacker) then
            return
        end

        -- Mob is already at max penalty
        local currentPenalty = attacker:getLocalVar('expReduction')
        if currentPenalty >= maxPenalty then
            return
        end

        -- Apply roam listener to reset penalty if mob deaggros
        if currentPenalty == 0 then
            applyRoamListener(attacker)
        end

        currentPenalty = currentPenalty + 1
        attacker:setLocalVar('expReduction', currentPenalty)

        local expReduction = math.floor(-currentPenalty * penaltyPerStack)
        attacker:setMobMod(xi.mobMod.EXP_BONUS, expReduction)
    end)
end)

return m
