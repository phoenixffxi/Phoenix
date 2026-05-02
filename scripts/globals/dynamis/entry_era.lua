-----------------------------------
--   Dynamis Entry Management    --
-----------------------------------
-- Handles validation, restrictions, and entry requirements for Dynamis zones
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- Determines if a player has GM privileges (visible GM level 3+)
-- Used to bypass entry restrictions and requirements
xi.dynamis.isGM = function(player)
    return player:getVisibleGMLevel() > 2
end

-- Validates that a player meets all prerequisites to enter a Dynamis zone
-- This includes level requirements, mission progress, and key items
xi.dynamis.checkEntryRequirements = function(player, entryZoneID)
    local entryInfo = xi.dynamis.entryInfoEra[entryZoneID]

    -- Verify entry configuration exists
    if not entryInfo then
        return false
    end

    xi.dynamis.debugPrint('Checking player charvar ' .. entryInfo.enteredVar .. ' for previous Dynamis entry.')

    -- 1. GMs and players who have previously entered this zone bypass all requirements
    --    This allows GMs to test content and returning players to enter freely
    if
        xi.dynamis.isGM(player) or
        player:getCharVar(entryInfo.enteredVar) ~= 0
    then
        xi.dynamis.debugPrint('Player is GM or has already entered this Dynamis before, skipping requirements.')
        return true
    end

    -- 2. Player must be at least level 65 to enter Dynamis
    if player:getMainLvl() < xi.dynamis.settings.MIN_LEVEL then
        player:printToPlayer('Players who have not reached 65 are prohibited from entering Dynamis.', xi.msg.channel.NS_SAY)
        return false
    end

    -- 3. Dreamlands Dynamis (zones 7+) requires completion of "Darkness Named" CoP mission
    if
        entryInfo.csBit >= 7 and
        not player:hasCompletedMission(xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED)
    then
        xi.dynamis.debugPrint('Missing CoP mission requirement to enter Dynamis.')
        player:printToPlayer('You have not completed the required CoP mission.', xi.msg.channel.NS_SAY)
        return false
    end

    -- 4. Player must possess all zone-specific key items (e.g., past expansion items, progress flags)
    for _, keyItemID in ipairs(entryInfo.reqs) do
        if not player:hasKeyItem(keyItemID) then
            xi.dynamis.debugPrint('Missing required key item to enter Dynamis: ' .. keyItemID)
            player:printToPlayer('You do not have the required key item.', xi.msg.channel.NS_SAY)
            return false
        end
    end

    return true
end

-- Applies zone-specific gameplay restrictions when player enters Dynamis
-- For Dreamlands zones: applies SJ restriction and removes non-compatible status effects
xi.dynamis.applyEntryRestrictions = function(player, dynaZoneID)
    local zone = GetZone(dynaZoneID)
    if not zone then
        return
    end

    -- Only Dreamlands zones (higher tier Dynamis) have SJ restrictions
    -- Non-Dreamlands zones have no special entry restrictions
    if not xi.dynamis.dreamlandsZones[dynaZoneID] then
        xi.dynamis.debugPrint('Zone is not a dreamlands zone, skipping entry restrictions.')
        return
    end

    -- If restrictions already applied, skip to avoid re-applying
    if zone:getLocalVar('SJUnlocked') == 1 then
        xi.dynamis.debugPrint('SJ unlock flag already set, skipping entry restrictions.')
        return
    end

    -- GMs are not subject to SJ restrictions
    if xi.dynamis.isGM(player) then
        xi.dynamis.debugPrint('Player is a GM, skipping entry restrictions.')
        return
    end

    -- Remove all status effects EXCEPT those in the preserved list
    -- Preserved effects: buffs that should persist into Dynamis (e.g., some utility buffs)
    for _, effect in pairs(player:getStatusEffects()) do
        local effectID = effect:getEffectType()
        if not xi.dynamis.preservedStatusEffects[effectID] then
            player:delStatusEffectSilent(effectID)
        end
    end

    -- Apply the SJ restriction effect
    xi.dynamis.debugPrint('Applying SJ restriction effect to player.')
    player:addStatusEffect(xi.effect.SJ_RESTRICTION, { origin = player })
end

-- Retrieves the appropriate in-game message ID for a specific connection status
-- Different zones and events use different message text stored in the zone's text table
xi.dynamis.getZoneMessageID = function(messageType, entryZoneID)
    local lookupEntry = xi.dynamis.dynaIDLookup[entryZoneID]
    if lookupEntry and lookupEntry.text then
        return lookupEntry.text[messageType]
    end

    return nil
end
