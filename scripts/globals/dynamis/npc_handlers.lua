-----------------------------------
--   Dynamis NPC Handlers       --
-----------------------------------
-- Standard NPC interaction functions for dynamis entry zones
-- These are called from zone NPC scripts
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-----------------------------------
--   Global Dynamis Variables    --
-----------------------------------
local dynamisTimelessHourglass = xi.item.TIMELESS_HOURGLASS
local dynamisPerpetual         = xi.item.PERPETUAL_HOURGLASS

-- Helper function to clean up trade
local function releaseTrade(player)
    local tradeContainer = player:getTrade()
    if tradeContainer then
        xi.dynamis.debugPrint('Cleaning up trade container')
        tradeContainer:clean()
    end
end

-- ----------------
-- Entry NPC Logic
-- ----------------
-- Handles NPC trade interactions for players attempting to enter Dynamis
-- Validates zone state, player eligibility, and processes hourglass trades
xi.dynamis.entryNpcOnTrade = function(player, npc, trade)
    xi.dynamis.debugPrint('--------------------xi.dynamis.entryNpcOnTrade--------------------')
    local zoneId    = npc:getZoneID()
    local zone      = GetZone(zoneId)
    local entryInfo = xi.dynamis.entryInfoEra[zoneId]

    -- Validate zone object exists
    if not zone then
        xi.dynamis.debugPrint('Zone is nil | xi.dynamis.entryNpcOnTrade')
        return
    end

    -- Verify zone is enabled for Dynamis entry
    if not entryInfo.enabled then
        xi.dynamis.debugPrint('entryNpcOnTrade - zone not enabled')
        return
    end

    local dynaZoneId  = entryInfo.dynaZone
    local currentTime = GetSystemTime()
    local lockout     = xi.dynamis.isPlayerLockedOut(player)

    -- Track when current Dynamis instance expires
    local varExpiration        = string.format('[DYNA]ExpirationTime_%s', dynaZoneId)
    local zoneExpiration       = GetServerVariable(varExpiration)
    local dynamisTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneExpiration)

    -- Setup zone cooldown/cleanup tracking variables
    local varZoneCooldown   = string.format('[DYNA]ZoneCooldown_%s', dynaZoneId)
    local varCleanupScript  = string.format('[DYNA]CleanupScript_%s', dynaZoneId)
    local zoneCooldownEnter = zone:getLocalVar(varZoneCooldown)
    local cleanupScript     = zone:getLocalVar(varCleanupScript)

    xi.dynamis.debugPrint('Lockout: ' .. tostring(lockout) .. ' | zoneCooldownEnter: ' .. tostring(zoneCooldownEnter) .. ' | cleanupScript: ' .. tostring(cleanupScript) .. ' | timeRemaining: ' .. tostring(dynamisTimeRemaining))

    local playerEntered = player:getCharVar(entryInfo.enteredVar) or 0

    -- Check that player meets all entry requirements (level, CJ status, etc)
    if not xi.dynamis.checkEntryRequirements(player, zoneId) then
        releaseTrade(player)
        xi.dynamis.debugPrint('Entry requirements not met')
        return
    end

    -- Player trades a Timeless Hourglass
    if npcUtil.tradeHasExactly(trade, { dynamisTimelessHourglass }) then
        xi.dynamis.debugPrint('Timeless hourglass trade detected')

        -- 1. Check if another group is currently in Dynamis
        if dynamisTimeRemaining > 0 then
            xi.dynamis.debugPrint('Another group is currently in Dynamis, time remaining: ' .. tostring(dynamisTimeRemaining))
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneId), entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- 2. GM bypass - allow unrestricted entry
        if xi.dynamis.isGM(player) then
            zone:setLocalVar(varZoneCooldown, 0)
            player:startEvent(entryInfo.csRegisterGlass, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- 3. Player must not be locked out
        if lockout > 0 then
            xi.dynamis.debugPrint('Player is locked out, lockout time remaining (seconds): ' .. tostring(lockout))
            player:messageSpecial(zones[zoneId].text.YOU_CANNOT_ENTER_DYNAMIS, xi.dynamis.isPlayerLockedOut(player, true), entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- 4. Zone cooldown must have expired
        -- Zone stays on cooldown after an instance expires (unless cleanup succeeded)
        if zoneCooldownEnter > currentTime and cleanupScript ~= 1 then
            xi.dynamis.debugPrint('Zone is on cooldown, cooldown time remaining: ' .. tostring(zoneCooldownEnter - currentTime))
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneId), entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- 5. All checks passed - reset zone cooldown and initiate Dynamis registration
        if not trade:confirmItem(dynamisTimelessHourglass, 1) then
            xi.dynamis.debugPrint('Unable to confirm Timeless Hourglass trade')
            releaseTrade(player)
            return
        end

        zone:setLocalVar(varZoneCooldown, 0)

        player:startEvent(entryInfo.csRegisterGlass, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
        player:confirmTrade()
    -- Player trades a Perpetual Hourglass
    elseif npcUtil.tradeHasExactly(trade, { dynamisPerpetual }) then
        xi.dynamis.debugPrint('Perpetual hourglass trade detected')

        -- 1. GM bypass - allow direct entry and registration
        if xi.dynamis.isGM(player) then
            xi.dynamis.registerPlayer(player)
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        local glassObj  = trade:getItem()
        local glassData = xi.dynamis.decypherGlass(glassObj)
        xi.dynamis.debugPrint(string.format('GlassData from decypherGlass - startTime: %s, endTime: %s, zoneId: %s', glassData.startTime, glassData.endTime, glassData.zoneId))

        -- 2. Verify hourglass validity and check player registration status
        -- Important: Check registration status BEFORE lockout, since lockout can change after registration
        local glassValid = xi.dynamis.verifyTradeHourglass(player, zoneId, glassObj)
        xi.dynamis.debugPrint('Perpetual hourglass validity: ' .. tostring(glassValid))
        releaseTrade(player)

        -- 3. If player is already registered, allow entry immediately
        if glassValid == xi.dynamis.hourglassTradeResult.REGISTERED then
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- 4. Player cannot be locked out (only matters for new registrations)
        xi.dynamis.debugPrint('Checking player lockout')
        xi.dynamis.debugPrint('Player lockout (seconds): ' .. tostring(lockout))
        if lockout > 0 then
            player:messageSpecial(zones[zoneId].text.YOU_CANNOT_ENTER_DYNAMIS, xi.dynamis.isPlayerLockedOut(player, true), entryInfo.csBit)
            return
        end

        -- 5. Process new player registration (if hourglass is NEW/valid)
        if glassValid == xi.dynamis.hourglassTradeResult.NEW then
            -- 6. Verify instance has not reached max capacity
            local dynaCapacity = GetServerVariable(string.format('[DYNA]#OfRegisteredPlayers_%s', dynaZoneId))

            if dynaCapacity >= entryInfo.maxCapacity then
                -- Instance is full
                player:printToPlayer('The Dynamis instance has reached its maximum capacity of ' .. entryInfo.maxCapacity .. ' registrants.', 29)
                return
            end

            -- Register player and allow entry
            xi.dynamis.registerPlayer(player)
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- Hourglass is invalid or expired - inform player why entry is denied
        if dynamisTimeRemaining > 0 then
            xi.dynamis.debugPrint('Invalid hourglass trade, another group is currently in Dynamis, time remaining: ' .. tostring(dynamisTimeRemaining))
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneId), entryInfo.csBit)
        else
            player:printToPlayer('The Perpetual Hourglass\'s time has run out.', 29)
        end
    end
end

local function tavWinCutscene(player)
    -- Tavnazia Win CS are unique depending on how far you are in the story
    if player:hasCompletedQuest(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.APOCALYPSE_NIGH) then
        return 3  -- AN (includes ZM and CoP)
    end

    local zmComplete = player:getCurrentMission(xi.mission.log_id.ZILART) >= xi.mission.id.zilart.AWAKENING
    local copComplete = player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.DAWN

    if zmComplete and copComplete then
        return 2  -- ZM and CoP
    elseif zmComplete then
        return 1  -- ZM only
    end

    return 0  -- Nothing complete
end

-- This function is called when a player interacts with an entry NPC
-- It determines which cutscene or message should play based on player state
xi.dynamis.entryNpcOnTriggerEra = function(player, npc)
    local zoneId     = player:getZoneID()
    local entryInfo  = xi.dynamis.entryInfoEra[zoneId]
    local defaultMsg = zones[zoneId].text.DYNA_NPC_DEFAULT_MESSAGE
    local status     = player:getCharVar('Dynamis_Status')

    -- Return if zone is not enabled
    if not entryInfo.enabled then
        player:messageSpecial(defaultMsg)
        return
    end

    -- If player is eligible but doesn't have Vial of Shrouded Sand, give them one
    if
        entryInfo.csVial ~= nil and
        status == 1 and
        not player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND)
    then
        player:startEvent(entryInfo.csVial)
        return
    end

    -- First time players see an introductory cutscene (if they meet requirements)
    if
        entryInfo.csFirst ~= nil and
        xi.dynamis.checkEntryRequirements(player, zoneId) and
        player:getCharVar(entryInfo.hasSeenFirstCSVar) == 0
    then
        player:startEvent(entryInfo.csFirst)
        return
    end

    -- Players who have cleared Dynamis see a special victory cutscene
    if
        entryInfo.csWin ~= nil and
        player:hasKeyItem(entryInfo.winKI) and
        player:getCharVar(entryInfo.hasSeenWinCSVar) == 0
    then
        -- Tavnazia has zone-dependent win cutscenes based on mission progress
        if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
            player:startEvent(entryInfo.csWin, 0, tavWinCutscene(player))
        else
            player:startEvent(entryInfo.csWin)
        end

        return
    end

    -- Check for player lockout
    if xi.dynamis.isPlayerLockedOut(player) > 0 then
        player:messageSpecial(zones[zoneId].text.YOU_CANNOT_ENTER_DYNAMIS, xi.dynamis.isPlayerLockedOut(player, true), entryInfo.csBit)
        return
    end

    player:messageSpecial(defaultMsg) -- default message for everything else
end

-- Called when a cutscene completes (after player confirms hourglass trade)
-- Handles Dynamis instance creation and registration
xi.dynamis.entryNpcOnEventUpdate = function(player, csid, option, npc)
    local zoneId    = player:getZoneID()
    local entryInfo = xi.dynamis.entryInfoEra[zoneId]

    -- Return if zone is not enabled
    if not entryInfo.enabled then
        return
    end

    -- Only process glass registration cutscenes
    if csid ~= entryInfo.csRegisterGlass then
        return
    end

    xi.dynamis.debugPrint('--------------xi.dynamis.entryNpcOnEventUpdate--------------')

    local zone       = GetZone(zoneId)
    local dynaZoneId = entryInfo.dynaZone

    if not zone then
        xi.dynamis.debugPrint('zone is nil')
        return
    end

    -- Return if NPC is invalid
    if npc == nil then
        xi.dynamis.debugPrint('npc is nil')
        return
    else
        xi.dynamis.debugPrint('npc is valid - ID: ' .. tostring(npc:getID()) .. ' | Name: ' .. tostring(npc:getName()))
    end

    -- Process successful cutscene completion
    local zoneExpiration       = GetServerVariable(string.format('[DYNA]ExpirationTime_%s', dynaZoneId))
    local dynamisTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneExpiration)

    -- Proceed only if cutscene completed successfully and no instance is running
    if option == 0 and dynamisTimeRemaining <= 0 then
        xi.dynamis.debugPrint('Calling registerDynamis')

        -- Tavnazia instances start with less time
        local expirationTime = xi.dynamis.settings.DEFAULT_TIME_LIMIT
        if dynaZoneId == xi.zone.DYNAMIS_TAVNAZIA then
            expirationTime = xi.dynamis.settings.TAVNAZIA_TIME_LIMIT
        end

        xi.dynamis.debugPrint('Using expiration time of: ' .. tostring(expirationTime) .. ' seconds for this instance.')
        local startTime = GetSystemTime()
        local endTime   = startTime + expirationTime
        xi.dynamis.debugPrint('RegisterDynamis with startTime: ' .. tostring(startTime) .. ', endTime: ' .. tostring(endTime) .. ' (difference: ' .. tostring(endTime - startTime) .. ' seconds)')

        -- Create a perpetual hourglass item encoded with instance data
        SetServerVariable(string.format('[DYNA]StartTime_%s', dynaZoneId), startTime)
        SetServerVariable(string.format('[DYNA]ExpirationTime_%s', dynaZoneId), endTime)
        xi.dynamis.makeGlass(player, dynaZoneId, startTime, endTime)

        -- Register the Dynamis instance server-wide and register player
        xi.dynamis.registerDynamis(player, startTime, endTime)

        player:tradeComplete()

        -- Inform player of success
        player:messageSpecial(zones[zoneId].text.ITEM_OBTAINED, dynamisPerpetual)
        player:messageSpecial(xi.dynamis.getZoneMessageID('INFORMATION_RECORDED', zoneId), dynamisPerpetual)

        -- Complete entry process
        player:instanceEntry(npc, 4) -- Successful completion of CS.
        return
    end

    -- Cutscene failed
    player:instanceEntry(npc, 3)
    player:messageSpecial(xi.dynamis.getZoneMessageID('UNABLE_TO_CONNECT', zoneId))
end

-- Called when a cutscene ends successfully
-- Handles various post-cutscene actions (giving items, setting flags, teleporting)
xi.dynamis.entryNpcOnEventFinishEra = function(player, csid, option)
    local zoneId    = player:getZoneID()
    local entryInfo = xi.dynamis.entryInfoEra[zoneId]

    -- Return if zone is not enabled
    if not entryInfo.enabled then
        return
    end

    -- Give player Vial of Shrouded Sand when sand distribution CS completes
    if entryInfo.csVial and csid == entryInfo.csVial then
        npcUtil.giveKeyItem(player, xi.ki.VIAL_OF_SHROUDED_SAND)
        return
    end

    -- When player confirms entry, teleport them into Dynamis
    if csid == entryInfo.csDyna then
        if option ~= 0 then
            return
        end

        player:setCharVar(entryInfo.enteredVar, 1) -- Mark the player as having entered at least once
        player:setPos(unpack(entryInfo.enterPos))  -- Teleport to entry position
        return
    end

    -- Mark that player has seen intro CS
    if csid == entryInfo.csFirst then
        player:setCharVar(entryInfo.hasSeenFirstCSVar, 1)
        return
    end

    -- Mark victory CS as viewed and award title if applicable
    if csid == entryInfo.csWin then
        player:setCharVar(entryInfo.hasSeenWinCSVar, 1)

        -- Tavnazia awards a unique title
        if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
            player:addTitle(xi.dynamis.dynaInfoEra[zoneId].csTitle)
        end

        return
    end
end

-- ----------------
-- QM Logic
-- ----------------
xi.dynamis.qmOnTriggerEra = function(player, npc)
    local zoneId = npc:getZoneID()

    -- Win KIs
    if not player:hasKeyItem(xi.dynamis.dynaInfoEra[zoneId].winKI) then
        npcUtil.giveKeyItem(player, xi.dynamis.dynaInfoEra[zoneId].winKI)
    end

    -- Tavnazia awards a unique title for QM defeat
    if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
        player:addTitle(xi.dynamis.dynaInfoEra[zoneId].qmTitle)
    end
end
