-----------------------------------
--   Dynamis NPC Handlers       --
-----------------------------------
-- Standard NPC interaction functions for dynamis entry zones
-- These are called from zone NPC scripts

xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- Helper function to clean up trade
local function releaseTrade(player)
    local tradeContainer = player:getTrade()
    if tradeContainer then
        tradeContainer:clean()
    end
end

xi.dynamis.entryNpcOnTrade = function(player, npc, trade)
    local zoneID    = npc:getZoneID()
    local zone      = GetZone(zoneID)
    local entryInfo = xi.dynamis.entryInfoEra[zoneID]

    -- Validate zone exists
    if not zone then
        print('[DEBUG] Zone is nil | xi.dynamis.entryNpcOnTrade')
        return
    end

    -- Check if zone is enabled
    if not entryInfo.enabled then
        print('[DEBUG] entryNpcOnTrade - zone not enabled')
        return
    end

    local dynaZoneID = xi.dynamis.dynaInfoEra[zoneID].dynaZone
    local sysTime    = GetSystemTime()

    -- Vars again for readability
    local lockout = xi.dynamis.isPlayerLockedOut(player)
    -- TODO remove these possibly later
    local varZoneCooldown       = string.format('[DYNA]ZoneCooldown_%s', dynaZoneID)
    local varCleanupScript      = string.format('[DYNA]CleanupScript_%s', zoneID)
    local varRegisteredPlayers  = string.format('[DYNA]RegisteredPlayers_%s', dynaZoneID)
    local varTimepoint          = string.format('[DYNA]Timepoint_%s', dynaZoneID)

    -- Zone stuff
    local zoneTimepoint         = GetServerVariable(varTimepoint)
    local dynamisTimeRemaining  = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)
    local zoneCooldown          = zone:getLocalVar(varZoneCooldown)
    local cleanupScript         = zone:getLocalVar(varCleanupScript)

    -- Player stuff
    local playerEntered = player:getCharVar(entryInfo.enteredVar) or 0

    -- Reduce the logic because we were checking level again and everything inside xi.dynamis.checkEntryRequirements already
    -- TODO CHECK IF MESSEGING ALL WORKS AS INTENDED
    if player:getLocalVar(entryInfo.enteredVar) == 0 then
        if not xi.dynamis.checkEntryRequirements(player, zoneID) then
            releaseTrade(player)
            print('DEBUG: entryNpcOnTrade - entry requirements not met')
            return
        end
    end

    if playerEntered == nil then
        playerEntered = 0
    end

    -- Timeless hourglass trade (start new Dynamis instance)
    -- I have a feeling we are missing a first cutscene check here
    -- Need to test that still
    -- TODO
    if npcUtil.tradeHasExactly(trade, { dynamisTimelessHourglass }) then
        print('DEBUG: entryNpcOnTrade - timeless hourglass trade detected')

        -- Check if another group is currently in Dynamis
        if dynamisTimeRemaining > 0 then
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneID), entryInfo.csBit)
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
            player:messageSpecial(zones[zoneID].text.YOU_CANNOT_ENTER_DYNAMIS, lockout, entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- Zone cooldown check + cleanup script check
        -- TODO look into combining the check up top, returns same thing
        if zoneCooldown > sysTime and cleanupScript ~= 1 then
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneID), entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- Reset cooldown and start Dynamis
        zone:setLocalVar(varZoneCooldown, 0)
        player:startEvent(entryInfo.csRegisterGlass, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)

    -- Handle perpetual hourglass trade, this means an instance that is already running
    elseif npcUtil.tradeHasExactly(trade, { dynamisPerpetual }) then
        print('DEBUG: entryNpcOnTrade - perpetual hourglass trade detected')

        local glassValid   = xi.dynamis.verifyTradeHourglass(player, zoneID)
        local dynaCapacity = GetServerVariable(varRegisteredPlayers)

        -- Let the GMs all go in again because they are cool like that
        -- Idk if we need to register them again but whatever - TODO for later
        if xi.dynamis.isGM(player) then
            xi.dynamis.registerPlayer(player)
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- 3. Player must not be locked out
        if lockout ~= 0 then
            player:messageSpecial(zones[zoneID].text.YOU_CANNOT_ENTER_DYNAMIS, lockout, entryInfo.csBit)
            releaseTrade(player)
            return
        end

        -- Check if the player is registered first - THEN check for lockout since the lockout changes after they register
        if glassValid == xi.dynamis.hourglassTradeResult.REGISTERED then
            player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
            return
        end

        -- All your new friends want to help
        if glassValid == xi.dynamis.hourglassTradeResult.NEW then
            if dynaCapacity < entryInfo.maxCapacity then
                xi.dynamis.registerPlayer(player)
                player:startEvent(entryInfo.csDyna, entryInfo.csBit, playerEntered == 1 and 0 or 1, xi.dynamis.settings.RESERVATION_TIMEOUT, xi.dynamis.settings.REENTRY_DAYS, entryInfo.maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamisTimelessHourglass, dynamisPerpetual)
                SetServerVariable(varRegisteredPlayers, dynaCapacity + 1)
            else
                player:printToPlayer('The Dynamis instance has reached its maximum capacity of ' .. entryInfo.maxCapacity .. ' registrants.', 29)
                releaseTrade(player)
            end

            return
        end

        -- I think we are missing a re-entry check unless I am going crazy
        if dynamisTimeRemaining > 0 then
            player:messageSpecial(xi.dynamis.getZoneMessageID('ANOTHER_GROUP', zoneID), entryInfo.csBit)
            releaseTrade(player)
        else
            player:printToPlayer('The Perpetual Hourglass\'s time has run out.', 29)
        end
    end
end

-- This function is on every NPC that handles Dynamis entry.
-- Cleanup Done
xi.dynamis.entryNpcOnTriggerEra = function(player, npc)
    local zoneID     = player:getZoneID()
    local entryInfo  = xi.dynamis.entryInfoEra[zoneID]
    local defaultMsg = zones[zoneID].text.DYNA_NPC_DEFAULT_MESSAGE
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
        xi.dynamis.checkEntryRequirements(player, zoneID) and
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
        if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
            player:startEvent(entryInfo.csWin, 0, getDynamisTavWinParam(player))
        else
            player:startEvent(entryInfo.csWin)
        end

        return
    end

    player:messageSpecial(defaultMsg) -- default message for everything else
end

-- Cleanup Done
xi.dynamis.entryNpcOnEventUpdate = function(player, csid, option, npc)
    local zoneID = player:getZoneID()
    local entryInfo = xi.dynamis.entryInfoEra[zoneID]

     -- If not enabled return
    if not entryInfo.enabled then
        return
    end

    -- If the event is finishing that means the glass is registering
    if csid ~= entryInfo.csRegisterGlass then
        return
    end

    print('DEBUG: entryNpcOnEventUpdate - csRegisterGlass cutscene')

    if npc == nil then
        print('[DEBUG] npc is nil | xi.dynamis.entryNpcOnEventUpdate - csRegisterGlass')
        return
    else
        -- Delete this later???
        print('[DEBUG] npc is valid - ID: ' .. tostring(npc:getID()) .. ' | Name: ' .. tostring(npc:getName()))
    end

    local dynaZoneID           = xi.dynamis.dynaInfoEra[zoneID].dynaZone
    local zoneTimepoint        = GetServerVariable(string.format('[DYNA]Timepoint_%s', dynaZoneID))
    local dynamisTimeRemaining = xi.dynamis.getDynaTimeRemaining(zoneTimepoint)

    -- Proceed if cutscene completed successfully
    if option == 0 and dynamisTimeRemaining <= 0 then
        print('DEBUG: entryNpcOnEventUpdate - calling registerDynamis')

        xi.dynamis.registerDynamis(player) -- Trigger the generation of a token, timepoint, and start spawning wave 1.
        player:tradeComplete()

        local dynaZone = GetZone(dynaZoneID)
        if dynaZone == nil then
            print('[DEBUG] dynaZone is nil | xi.dynamis.entryNpcOnEventUpdate')
            return
        end

        -- luacheck: ignore 113
        local dynamisToken = dynaZone:getLocalVar(string.format('[DYNA]Token_%s', dynaZoneID))
        player:createHourglass(dynaZoneID, dynamisToken, player:getID()) -- Create initial perpetual.
        player:messageSpecial(zones[zoneID].text.ITEM_OBTAINED, dynamisPerpetual) -- Give player a message stating the perpetual has been obtained.
        player:messageSpecial(xi.dynamis.getZoneMessageID('INFORMATION_RECORDED', zoneID), dynamisPerpetual) -- Send player the recorded message.

        player:instanceEntry(npc, 4) -- Successful completion of CS.
        return
    end

    -- Failed to complete CS.
    player:instanceEntry(npc, 3)
    player:messageSpecial(xi.dynamis.getZoneMessageID('UNABLE_TO_CONNECT', zoneID))
end

-- Cleanup Done
xi.dynamis.entryNpcOnEventFinishEra = function(player, csid, option)
    local zoneID    = player:getZoneID()
    local entryInfo = xi.dynamis.entryInfoEra[zoneID]

    -- If not enabled return
    if not entryInfo.enabled then
        return
    end

    -- Lets enter dynamis
    if csid == entryInfo.csDyna then
        if option ~= 0 then
            return
        end

        local entryPos = entryInfo.enterPos
        if not entryPos then
            return
        end

        -- Does this message even happen?
        -- TODO Check
        player:messageSpecial(xi.dynamis.getZoneMessageID('CONNECTING_WITH_THE_SERVER', zoneID))
        player:setCharVar(entryInfo.enteredVar, 1) -- Mark the player as having entered at least once.
        player:setPos(entryPos[1], entryPos[2], entryPos[3], entryPos[4], entryPos[5])
        return
    end

    -- Give Shrouded Sand KI
    if csid == entryInfo.csVial then
        npcUtil.giveKeyItem(player, xi.ki.VIAL_OF_SHROUDED_SAND)
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

        if zoneID == xi.zone.DYNAMIS_TAVNAZIA then
            player:addTitle(xi.dynamis.dynaInfoEra[zoneID].csTitle)
        end

        return
    end
end
