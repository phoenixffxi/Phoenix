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
    print('Trade container:', tradeContainer)
    if tradeContainer then
        print('Cleaning up trade container')
        tradeContainer:clean()
    end
end

-- ----------------
-- Entry NPC Logic
-- ----------------
xi.dynamis.entryNpcOnTrade = function(player, npc, trade)
    xi.dynamis.debugPrint('--------------------xi.dynamis.entryNpcOnTrade--------------------')
    local zoneId    = npc:getZoneID()
    local zone      = GetZone(zoneId)
    local entryInfo = xi.dynamis.entryInfoEra[zoneId]

    -- Validate zone exists
    if not zone then
        xi.dynamis.debugPrint('Zone is nil | xi.dynamis.entryNpcOnTrade')
        return
    end

    -- Check if zone is enabled
    if not entryInfo.enabled then
        xi.dynamis.debugPrint('entryNpcOnTrade - zone not enabled')
        return
    end

    local dynaZoneID = entryInfo.dynaZone
    local sysTime    = GetSystemTime()

    -- Vars again for readability
    local lockout = xi.dynamis.isPlayerLockedOut(player)

    local varZoneCooldown  = string.format('[DYNA]ZoneCooldown_%s', dynaZoneID)
    local varCleanupScript = string.format('[DYNA]CleanupScript_%s', zoneId)
    local varExpiration    = string.format('[DYNA]ExpirationTime_%s', dynaZoneID)

    -- Zone stuff
    local zoneExpiration         = GetServerVariable(varExpiration)
    local dynamisTimeRemaining  = xi.dynamis.getDynaTimeRemaining(zoneExpiration)
    xi.dynamis.debugPrint('Lockout: ' .. tostring(lockout) .. ' | zoneCooldownEnter: ' .. tostring(GetServerVariable(varZoneCooldown)) .. ' | cleanupScript: ' .. tostring(GetServerVariable(varCleanupScript)) .. ' | timeRemaining: ' .. tostring(dynamisTimeRemaining))

     -- 1. Check if player has the required item to trade
    local zoneCooldownEnter = zone:getLocalVar(varZoneCooldown)
    local cleanupScript     = zone:getLocalVar(varCleanupScript)

    -- Player stuff
    local playerEntered = player:getCharVar(entryInfo.enteredVar) or 0

    -- Check for entry requirements before trading
    if not xi.dynamis.checkEntryRequirements(player, zoneId) then
        releaseTrade(player)
        xi.dynamis.debugPrint('Entry requirements not met')
        return
    end

    -- Timeless hourglass trade (start new Dynamis instance)
    if npcUtil.tradeHasExactly(trade, { dynamisTimelessHourglass }) then
        xi.dynamis.debugPrint('Timeless hourglass trade detected')

        -- Check if another group is currently in Dynamis
        if dynamisTimeRemaining > 0 then
            xi.dynamis.debugPrint('Aother group is currently in Dynamis, time remaining: ' .. tostring(dynamisTimeRemaining))
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneId), entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- Let the GMs all go in because they are cool like that
        if xi.dynamis.isGM(player) then
            zone:setLocalVar(varZoneCooldown, 0)
            player:startEvent(entryInfo.csRegisterGlass, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- 3. Player must not be locked out
        if lockout ~= 0 then
            xi.dynamis.debugPrint('Player is locked out, lockout time remaining: ' .. tostring(lockout))
            player:messageSpecial(zones[zoneId].text.YOU_CANNOT_ENTER_DYNAMIS, lockout, entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- Zone cooldown check + cleanup script check
        -- TODO look into combining the check up top, returns same thing
        if zoneCooldownEnter > sysTime and cleanupScript ~= 1 then
            xi.dynamis.debugPrint('Zone is on cooldown, cooldown time remaining: ' .. tostring(zoneCooldownEnter - sysTime))
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneId), entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- Reset cooldown and start Dynamis
        zone:setLocalVar(varZoneCooldown, 0)
        player:startEvent(entryInfo.csRegisterGlass, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
        player:confirmTrade()
    -- Handle perpetual hourglass trade, this means an instance that is already running
    elseif npcUtil.tradeHasExactly(trade, { dynamisPerpetual }) then
        xi.dynamis.debugPrint('Perpetual hourglass trade detected')

        -- 1. Let the GMs all go in again because they are cool like that
        if xi.dynamis.isGM(player) then
            xi.dynamis.registerPlayer(player)
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        local glassObj  = trade:getItem()
        local glassData = xi.dynamis.decypherGlass(glassObj)
        xi.dynamis.debugPrint(string.format('GlassData from decypherGlass - startTime: %s, endTime: %s, zoneId: %s', glassData.startTime, glassData.endTime, glassData.zoneId))
        releaseTrade(player)

        -- 2. Check if the player is registered first - THEN check for lockout since the lockout changes after they register
        local glassValid            = xi.dynamis.verifyTradeHourglass(player, zoneId)
        local varRegisteredPlayers  = string.format('[DYNA]#OfRegisteredPlayers_%s', dynaZoneID)
        xi.dynamis.debugPrint('Perpetual hourglass validity: ' .. tostring(glassValid))
        if glassValid == xi.dynamis.hourglassTradeResult.REGISTERED then
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- 3. Player must not be locked out if they are no registered yet
        xi.dynamis.debugPrint('Checking player lockout')
        xi.dynamis.debugPrint('Player lockout: ' .. tostring(lockout))
        if lockout ~= 0 then
            player:messageSpecial(zones[zoneId].text.YOU_CANNOT_ENTER_DYNAMIS, lockout, entryInfo.csBit)
            return
        end

        -- 4. Check for new registered non-locked players
        if glassValid == xi.dynamis.hourglassTradeResult.NEW then
            -- 5. Check for capacity
            local dynaCapacity = GetServerVariable(string.format('[DYNA]#OfRegisteredPlayers_%s', dynaZoneID))
            if dynaCapacity < entryInfo.maxCapacity then
                xi.dynamis.registerPlayer(player)
                player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
                SetServerVariable(varRegisteredPlayers, dynaCapacity + 1)
            else
                player:printToPlayer('The Dynamis instance has reached its maximum capacity of ' .. entryInfo.maxCapacity .. ' registrants.', 29)
            end

            return
        end

        -- I think we are missing a re-entry check unless I am going crazy
        -- If the glass is NOT valid
        if dynamisTimeRemaining > 0 then
            xi.dynamis.debugPrint('Invalid hourglass trade, another group is currently in Dynamis, time remaining: ' .. tostring(dynamisTimeRemaining))
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneId), entryInfo.csBit)
        else
            player:printToPlayer('The Perpetual Hourglass\'s time has run out.', 29)
        end
    end
end

-- This function is on every NPC that handles Dynamis entry.
-- Cleanup Done
xi.dynamis.entryNpcOnTriggerEra = function(player, npc)
    local zoneId     = player:getZoneID()
    local entryInfo  = xi.dynamis.entryInfoEra[zoneId]
    local defaultMsg = zones[zoneId].text.DYNA_NPC_DEFAULT_MESSAGE
    local status     = player:getCharVar('Dynamis_Status')

    -- Bail out if zone is not enabled
    if not entryInfo.enabled then
        player:messageSpecial(defaultMsg)
        return
    end

    -- If player does not have sand, start CS to give sand.
    if
        entryInfo.csVial ~= nil and
        status == 1 and
        not player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND)
    then
        player:startEvent(entryInfo.csVial)
        return
    end

    -- If player has not seen first CS play that shit
    if
        entryInfo.csFirst ~= nil and
        xi.dynamis.checkEntryRequirements(player, zoneId) and
        player:getCharVar(entryInfo.hasSeenFirstCSVar) == 0
    then
        player:startEvent(entryInfo.csFirst)
        return
    end

    -- If player has not seen win CS play win CS (assuming they have the KI)
    if
        entryInfo.csWin ~= nil and
        player:hasKeyItem(entryInfo.winKI) and
        player:getCharVar(entryInfo.hasSeenWinCSVar) == 0
    then
        if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
            -- player:startEvent(entryInfo.csWin, 0, getDynamisTavWinParam(player))
        else
            player:startEvent(entryInfo.csWin)
        end

        return
    end

    if xi.dynamis.isPlayerLockedOut(player) ~= 0 then
        player:messageSpecial(zones[zoneId].text.YOU_CANNOT_ENTER_DYNAMIS, xi.dynamis.isPlayerLockedOut(player), entryInfo.csBit)
        return
    end

    player:messageSpecial(defaultMsg) -- default message for everything else
end

-- Cleanup Done
xi.dynamis.entryNpcOnEventUpdate = function(player, csid, option, npc)
    local zoneId    = player:getZoneID()
    local entryInfo = xi.dynamis.entryInfoEra[zoneId]

     -- If not enabled return
    if not entryInfo.enabled then
        return
    end

    -- If the event is finishing that means the glass is registering
    if csid ~= entryInfo.csRegisterGlass then
        return
    end

    xi.dynamis.debugPrint('--------------xi.dynamis.entryNpcOnEventUpdate--------------')

    if npc == nil then
        xi.dynamis.debugPrint('npc is nil')
        return
    else
        -- Delete this later???
        xi.dynamis.debugPrint('npc is valid - ID: ' .. tostring(npc:getID()) .. ' | Name: ' .. tostring(npc:getName()))
    end

    local dynaZoneID           = entryInfo.dynaZone
    local zoneExpiration       = GetServerVariable(string.format('[DYNA]ExpirationTime_%s', dynaZoneID))
    local dynamisTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneExpiration)
    -- Proceed if cutscene completed successfully
    if option == 0 and dynamisTimeRemaining <= 0 then
        xi.dynamis.debugPrint('Calling registerDynamis')

        local expirationTime = xi.dynamis.settings.DEFAULT_TIME_LIMIT
        if dynaZoneID == xi.zone.DYNAMIS_TAVNAZIA then
            expirationTime = xi.dynamis.settings.TAVNAZIA_TIME_LIMIT
        end

        xi.dynamis.debugPrint('Using expiration time of: ' .. tostring(expirationTime) .. ' seconds for this instance.')
        local startTime = GetSystemTime()
        local endTime   = startTime + expirationTime
        xi.dynamis.debugPrint('RegisterDynamis with startTime: ' .. tostring(startTime) .. ', endTime: ' .. tostring(endTime) .. ' (difference: ' .. tostring(endTime - startTime) .. ' seconds)')
        xi.dynamis.makeGlass(player, dynaZoneID, startTime, endTime)

        xi.dynamis.registerDynamis(player, startTime, endTime)

        player:tradeComplete()

        player:messageSpecial(zones[zoneId].text.ITEM_OBTAINED, dynamisPerpetual) -- Give player a message stating the perpetual has been obtained.
        player:messageSpecial(xi.dynamis.getZoneMessageID('INFORMATION_RECORDED', zoneId), dynamisPerpetual) -- Send player the recorded message.

        player:instanceEntry(npc, 4) -- Successful completion of CS.
        return
    end

    -- Failed to complete CS.
    player:instanceEntry(npc, 3)
    player:messageSpecial(xi.dynamis.getZoneMessageID('UNABLE_TO_CONNECT', zoneId))
end

-- Cleanup Done
xi.dynamis.entryNpcOnEventFinishEra = function(player, csid, option)
    local zoneId    = player:getZoneID()
    local entryInfo = xi.dynamis.entryInfoEra[zoneId]

    -- If not enabled return
    if not entryInfo.enabled then
        return
    end

    -- 1. Check for KI first
    if entryInfo.csVial and csid == entryInfo.csVial then
        npcUtil.giveKeyItem(player, xi.ki.VIAL_OF_SHROUDED_SAND)
        return
    end

    -- Lets enter dynamis
    if csid == entryInfo.csDyna then
        if option ~= 0 then
            return
        end

        player:setCharVar(entryInfo.enteredVar, 1) -- Mark the player as having entered at least once.
        player:setPos(unpack(entryInfo.enterPos))
        return
    end

    -- First CS seen
    if csid == entryInfo.csFirst then
        player:setCharVar(entryInfo.hasSeenFirstCSVar, 1)
        return
    end

    -- Win CS seen
    if csid == entryInfo.csWin then
        player:setCharVar(entryInfo.hasSeenWinCSVar, 1)

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

    if zoneId == xi.zone.DYNAMIS_TAVNAZIA then
        player:addTitle(xi.dynamis.dynaInfoEra[zoneId].qmTitle)
    end
end
