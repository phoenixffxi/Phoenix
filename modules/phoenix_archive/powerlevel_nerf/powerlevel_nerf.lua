-----------------------------------
-- Phoenix Power Leveling Nerf Module
--
-- Dirty exp of monsters if they attack a player that is more than 5 levels above them more than 3 times.
-----------------------------------
require('modules/module_utils')

local m = Module:new('powerlevel_nerf')

-- Configuration
local levelGrace = 5  -- Only stamp players this many levels or more above the mob
local swingGrace = 3  -- Attack rounds against a player before stamping begins
local graceReset = 60 -- Seconds without being hit before the swing count resets

m:addOverride('xi.player.onGameIn', function(player, firstLogin, zoning)
    super(player, firstLogin, zoning)

    player:addListener('ATTACKED', 'POWERLEVEL_NERF_ATTACKED', function(playerEntity, attacker)
        if not attacker or not attacker:isMob() then
            return
        end

        if attacker:isNM() then
            return
        end

        -- Within the level range of the mob's intended killers
        if playerEntity:getMainLvl() < attacker:getMainLvl() + levelGrace then
            return
        end

        local now    = GetSystemTime()
        local swings = attacker:getLocalVar('plNerfSwings')

        -- Stale count from an earlier engagement
        if now - attacker:getLocalVar('plNerfLastHit') > graceReset then
            swings = 0
        end

        swings = swings + 1
        attacker:setLocalVar('plNerfSwings', swings)
        attacker:setLocalVar('plNerfLastHit', now)

        if swings < swingGrace then
            return
        end

        attacker:updateEnmityFromDamage(playerEntity, 1)
    end)
end)
