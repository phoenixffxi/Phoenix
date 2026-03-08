-----------------------------------
--   Dynamis Entry Management    --
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- Check if player is a GM (level 3)
xi.dynamis.isGM = function(player)
    return player:getVisibleGMLevel() > 2
end

-- Check if player meets entry requirements for a zone
xi.dynamis.checkEntryRequirements = function(player, entryZoneID)
    local entryInfo = xi.dynamis.entryInfoEra[entryZoneID]
    print('[DEBUG] Checking player charvar ' .. entryInfo.enteredVar .. ' for previous Dynamis entry.')

    -- Check if entryInfo is valid
    if not entryInfo then
        return false
    end

    -- 1. Check if player is GM or has already entered this Dynamis before (charvar check)
    if
        xi.dynamis.isGM(player) or
        player:getCharVar(entryInfo.enteredVar) ~= 0
    then
        print('[DEBUG] Player is GM or has already entered this Dynamis before, skipping requirements.')
        return true
    end

    -- 2. Check minimum level (65)
    if player:getMainLvl() < xi.dynamis.settings.MIN_LEVEL then
        player:printToPlayer('Players who have not reached 65 are prohibited from entering Dynamis.', xi.msg.channel.NS_SAY)
        return false
    end

    -- 3. CoP requirement for Dreamlands Dynamis (zones 7+)
    if
        entryInfo.csBit >= 7 and
        not player:hasCompletedMission(xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED)
    then
        print('[DEBUG] Missing CoP mission requirement to enter Dynamis.')
        player:printToPlayer('You have not completed the required CoP mission.', xi.msg.channel.NS_SAY)
        return false
    end

    -- 4. Check all required key items
    for _, keyItemID in ipairs(entryInfo.reqs) do
        if not player:hasKeyItem(keyItemID) then
            print('[DEBUG] Missing required key item to enter Dynamis: ', keyItemID)
            player:printToPlayer('You do not have the required key item.', xi.msg.channel.NS_SAY)
            return false
        end
    end

    return true
end

-- Verify hourglass trade and determine if NEW or REGISTERED
-- Returns: xi.dynamis.hourglassTradeResult.NEW, REGISTERED, or INVALID
xi.dynamis.verifyTradeHourglass = function(player, zoneID)
    local dynaZone = xi.dynamis.dynaInfoEra[zoneID].dynaZone
    -- Check if the zone is valid for Dynamis
    if not dynaZone then
        return xi.dynamis.hourglassTradeResult.INVALID
    end

    local dynamisToken = GetServerVariable(string.format('[DYNA]Token_%s', dynaZone))

    -- Validate hourglass first
    -- luacheck: ignore 113
    if not player:validateHourglass(dynamisToken) then
        return xi.dynamis.hourglassTradeResult.INVALID
    end

    -- Check if player is already registered in this session
    local playerRegistered = player:getCharVar(string.format('[DYNA]PlayerRegistered_%s', dynaZone))
    local playerRegKey     = player:getCharVar(string.format('[DYNA]PlayerRegisterKey_%s', dynaZone))

    -- If remainder matches key, player already registered
    if (playerRegistered - dynamisToken) == playerRegKey then
        return xi.dynamis.hourglassTradeResult.REGISTERED
    end

    return xi.dynamis.hourglassTradeResult.NEW
end

-- Update player's hourglass with session info using Player API
xi.dynamis.updatePlayerHourglass = function(player, zoneDynamisToken)
    local zoneID        = player:getZoneID()
    local zoneTimepoint = GetServerVariable(string.format('[DYNA]Timepoint_%s', zoneID))

    -- This updates the actual hourglass item with the new timepoint
    -- luacheck: ignore 113
    player:updateHourglass(zoneDynamisToken, zoneTimepoint)
end

-- Apply entry zone restrictions (SJ restriction, status effects)
xi.dynamis.applyEntryRestrictions = function(player, dynaZoneID)
    local zone = GetZone(dynaZoneID)
    if not zone then
        return
    end

    -- Only apply restrictions if this is a dreamlands zone (SJ restricted)
    if not xi.dynamis.dreamlandsZones[dynaZoneID] then
        return
    end

    -- Check if SJ unlock flag is already set (skip if already unlocked)
    if zone:getLocalVar('SJUnlock') == 1 then
        return
    end

    -- Skip restrictions for GMs
    if player:getGMLevel() >= 2 then
        return
    end

    -- Remove status effects that aren't preserved
    for _, effect in pairs(player:getStatusEffects()) do
        local effectID = effect:getEffectType()
        if not xi.dynamis.preservedStatusEffects[effectID] then
            player:delStatusEffectSilent(effectID)
        end
    end

    -- Apply SJ restriction effect (18000 = duration in ticks)
    player:addStatusEffect(xi.effect.SJ_RESTRICTION, 0, 0, 18000)
end

-- Get the appropriate message ID for zone connection status
xi.dynamis.getZoneMessageID = function(messageType, entryZoneID)
    local lookupEntry = xi.dynamis.dynaIDLookup[entryZoneID]
    if lookupEntry and lookupEntry.text then
        return lookupEntry.text[messageType]
    end

    return nil
end
