-----------------------------------
-- Chocobo Raising - Update Event VM
-----------------------------------
require('scripts/globals/hobbies/chocobo_raising/constants')
-----------------------------------
xi = xi or {}
xi.chocoboRaising = xi.chocoboRaising or {}

local debug = utils.getDebugPlayerPrinter(xi.settings.main.DEBUG_CHOCOBO_RAISING)

local vmOpCodes =
{
    RETIRE_YOUR_CHOCOBO        = 40,
    PREPARE_CHOCOBO_MENU       = 46,
    CHECK_REPORT_STATUS        = 208,
    INTRO_MENU_PT_2            = 214,
    INTRO_MENU_PT_3            = 215,
    FORCED_NAMING              = 216,
    BUY_CHOCOBO_WHISTLE        = 221,
    RECEIVE_CHOCOBO_WHISTLE    = 222,
    REGISTER_CHOCOBO_WHISTLE   = 223,
    DEBUG_ABILITIES_PRINT      = 229,
    DEBUG_USER_WORK_PRINT      = 232,
    GIVE_UP_CHOCOBO            = 240,
    FEED_CHOCOBO               = 241,
    CARE_FOR_CHOCOBO_MENU      = 243,
    PRESENT_CHOCOBO_APPEARANCE = 244,
    EVENT_PLAYOUT              = 246,
    INTRO_MENU_PT_1            = 248,
    SET_CARE_SCHEDULE_MENU     = 250,
    ASK_ABOUT_CONDITION_MENU   = 251,
    UNKNOWN_252                = 252,
    SET_BASIC_CARE_PLAN_1      = 254,
    BRIEF_REPORT               = 256,
    WHISTLE_GAME_RESULT        = 344,
    DEBUG_GO_FORWARD_1_UNIT    = 482,
    SKIP_REPORT                = 504,
    SET_BASIC_CARE_PLAN_2      = 510,
    UNKNOWN_600                = 600,
    SET_BASIC_CARE_PLAN_3      = 766,
    SET_BASIC_CARE_PLAN_4      = 1022,
    UNKNOWN_1056               = 1056,
    UNKNOWN_1241               = 1241,
    GO_ON_A_WALK_SHORT         = 10994,
    GO_ON_A_WALK_REGULAR       = 11250,
    GO_ON_A_WALK_LONG          = 11506,
    WATCH_OVER_CHOCOBO_CONFIRM = 12530,
    TELL_A_STORY               = 13042,
    SCOLD_CHOCOBO              = 13298,
    COMPETE_WITH_OTHERS        = 13554,
}

local vmOpCodeNames =
{
    [vmOpCodes.RETIRE_YOUR_CHOCOBO]        = 'Retire your chocobo',
    [vmOpCodes.PREPARE_CHOCOBO_MENU]       = 'Prepare chocobo menu',
    [vmOpCodes.CHECK_REPORT_STATUS]        = 'Check report status',
    [vmOpCodes.INTRO_MENU_PT_2]            = 'Intro menu pt 2',
    [vmOpCodes.INTRO_MENU_PT_3]            = 'Intro menu pt 3',
    [vmOpCodes.FORCED_NAMING]              = 'Forced naming',
    [vmOpCodes.BUY_CHOCOBO_WHISTLE]        = 'Buy chocobo whistle',
    [vmOpCodes.RECEIVE_CHOCOBO_WHISTLE]    = 'Receive chocobo whistle',
    [vmOpCodes.REGISTER_CHOCOBO_WHISTLE]   = 'Register chocobo whistle',
    [vmOpCodes.DEBUG_ABILITIES_PRINT]      = 'Debug abilities print',
    [vmOpCodes.DEBUG_USER_WORK_PRINT]      = 'Debug user work print',
    [vmOpCodes.GIVE_UP_CHOCOBO]            = 'Give up your chocobo',
    [vmOpCodes.FEED_CHOCOBO]               = 'Feed chocobo',
    [vmOpCodes.CARE_FOR_CHOCOBO_MENU]      = 'Care for your chocobo (menu)',
    [vmOpCodes.PRESENT_CHOCOBO_APPEARANCE] = 'Present chocobo appearance',
    [vmOpCodes.EVENT_PLAYOUT]              = 'Event playout',
    [vmOpCodes.INTRO_MENU_PT_1]            = 'Intro menu pt 1',
    [vmOpCodes.SET_CARE_SCHEDULE_MENU]     = 'Set care schedule (menu)',
    [vmOpCodes.ASK_ABOUT_CONDITION_MENU]   = 'Ask about chocobos condition (menu)',
    [vmOpCodes.UNKNOWN_252]                = 'Unknown 252',
    [vmOpCodes.SET_BASIC_CARE_PLAN_1]      = 'Set basic care plan 1',
    [vmOpCodes.BRIEF_REPORT]               = 'Brief report',
    [vmOpCodes.WHISTLE_GAME_RESULT]        = 'Chocobo Whistle game result',
    [vmOpCodes.DEBUG_GO_FORWARD_1_UNIT]    = 'Debug go forward 1 unit',
    [vmOpCodes.SKIP_REPORT]                = 'Skip the report',
    [vmOpCodes.SET_BASIC_CARE_PLAN_2]      = 'Set basic care plan 2',
    [vmOpCodes.UNKNOWN_600]                = 'Unknown 600',
    [vmOpCodes.SET_BASIC_CARE_PLAN_3]      = 'Set basic care plan 3',
    [vmOpCodes.SET_BASIC_CARE_PLAN_4]      = 'Set basic care plan 4',
    [vmOpCodes.UNKNOWN_1056]               = 'Unknown 1056',
    [vmOpCodes.UNKNOWN_1241]               = 'Unknown 1241',
    [vmOpCodes.GO_ON_A_WALK_SHORT]         = 'Go on a walk (Short) - Leisurely / Brisk',
    [vmOpCodes.GO_ON_A_WALK_REGULAR]       = 'Go on a walk (Regular) - Leisurely / Brisk',
    [vmOpCodes.GO_ON_A_WALK_LONG]          = 'Go on a walk (Long) - Leisurely / Brisk',
    [vmOpCodes.WATCH_OVER_CHOCOBO_CONFIRM] = 'Watch over your your chocobo (confirm)',
    [vmOpCodes.TELL_A_STORY]               = 'Tell a story',
    [vmOpCodes.SCOLD_CHOCOBO]              = 'Scold the chocobo',
    [vmOpCodes.COMPETE_WITH_OTHERS]        = 'Compete with others',
}

xi.chocoboRaising.eventVM = function(player, csid, option, npc)
    -- TODO: The majority of logic is controlled by the option, which is
    -- sent in by the client. We can't trust this isn't tampered with.
    -- We shouldtrack which options are valid at which time.

    local ID         = zones[player:getZoneID()]
    local mainCsid   = xi.chocoboRaising.csidTable[player:getZoneID()][2]
    local tradeCsid  = xi.chocoboRaising.csidTable[player:getZoneID()][3]
    local chocoState = xi.chocoboRaising.chocoState[player:getID()]

    -- Egg trade
    if csid == tradeCsid then
        if option == 252 then
            player:updateEvent(0, xi.chocoboRaising.raisingLocation[player:getZoneID()], 0, 0, 0, 0, 0, 0)
        end

    -- Egg check
    elseif csid == mainCsid then
        if chocoState == nil then
            print('ERROR! onEventUpdateVCSTrainer \'chocoState\' is nil!')

            return
        end

        --------------------------------------------------------
        -- Special cases
        --
        --    The VM option will have additional information packed into it and signal
        --   this is the case by using a flag in the last byte. We'll look for it and
        --   then handle these special cases, bailing out before we hit the VM proper.
        --------------------------------------------------------

        --------------------------------------------------------
        -- Setting the name for a chocobo: when the name is
        -- applied from the menu the name offsets (from the menu)
        -- are sent combined inside the option. The bottom byte
        -- of the option is filled as below:
        -- (Name offsets are 10-bits wide)
        --
        -- 0000 0000 0000 0100 0000 0000 1111 1111
        --      ^----------^^----------^ ^-------^
        --       last_name   first_name   name_change_flag (0xFF)
        --------------------------------------------------------
        if bit.band(0x000000FF, option) == 0xFF then
            local offset1     = bit.band(0x3FF, bit.rshift(option, 8))
            local offset2     = bit.band(0x3FF, bit.rshift(option, 18))
            local fname       = xi.chocoboNames[offset1]
            local lname       = xi.chocoboNames[offset2]
            local fullnamekey = string.format('%s %s', fname, lname)

            -- https://ffxiclopedia.fandom.com/wiki/Chocobo_Names
            -- '... with the caveat that your chocobo's name may be no more than 15 letters in total.'
            -- NOTE: This is enforced by the client, this is here to stop malicious naming attempts
            local nameTooLong = string.len(fullnamekey) > (15 + 1) -- 15 + the space character

            -- If renaming fails, the name will remain as 'Chocobo Chocobo' and the
            -- rejection CS will play
            if not fname or not lname then
                print('ERROR! onEventUpdateVCSTrainer - chocoboNames lookup failed!')
            elseif nameTooLong then
                print(string.format('ERROR! %s selected name combination too long for chocobo: %s', player:getName(), fullnamekey))
            elseif xi.bannedChocoboNames[fullnamekey] then
                print(string.format('ERROR! %s selected banned name for chocobo: %s', player:getName(), fullnamekey))
            else
                chocoState.first_name = fname
                chocoState.last_name  = lname

                debug(string.format('%s updating chocobo name: %s', player:getName(), fullnamekey))

                -- Write to cache
                xi.chocoboRaising.chocoState[player:getID()] = chocoState

                -- If the name is still 'Chocobo Chocobo' then the renaming failed or was
                -- rejected, play the appropriate response.
                if chocoState.first_name == 'Chocobo' and chocoState.last_name == 'Chocobo' then
                    player:updateEvent(1, 1, 1, 1, 1, 1, 1, 1)
                else
                    player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
                end

                -- TODO: Write to db?
            end

            -- There's no follow-up CSs here, bail out
            return
        end

        --------------------------------------------------------
        -- Similar to above, updates to care plan are flagged by setting bits
        -- in the update option. In this case, the mask if 0xFE (1111 1110).
        --
        -- Plan 1, basic care, 7 days
        -- 459006
        -- 0000 0000 0000 0111 0000 0000 1111 1110
        --            ^---^^-^      ^--^ ^-------^
        --             1    2        3    4
        --
        -- 1: Length of care plan
        -- 2: Type of care plan
        -- 3: Slot of care plan
        -- 4: 'Key' for care plan updates (0xFE)
        --------------------------------------------------------
        if bit.band(0x000000FF, option) == 0xFE then
            local carePlanSlot   = bit.band(0xF, bit.rshift(option, 8))
            local carePlanLength = bit.band(0x7, bit.rshift(option, 16))
            local carePlanType   = bit.band(0xF, bit.rshift(option, 19))

            debug(string.format('carePlanSlot: %i, carePlanLength: %i, carePlanType: %i',
                carePlanSlot, carePlanLength, carePlanType))

            -- If zero, make sure to default
            if chocoState.care_plan == 0 then
                local defaultCarePlan = bit.lshift(7, 4) + 0

                chocoState.care_plan =
                    bit.lshift(defaultCarePlan, 24) +
                    bit.lshift(defaultCarePlan, 16) +
                    bit.lshift(defaultCarePlan,  8) +
                    bit.lshift(defaultCarePlan,  0)
            end

            local carePlan = bit.lshift(carePlanLength, 4) + carePlanType

            -- Zero out the target slot
            local targetSlotOffset = 24 - (carePlanSlot * 8)
            local mask             = bit.bnot(bit.lshift(0xFF, targetSlotOffset))
            local zerodCarePlan    = bit.band(chocoState.care_plan, mask)

            -- Then write the new care plan to it
            local finalCarePlan  = bit.bor(zerodCarePlan, bit.lshift(carePlan, targetSlotOffset))
            chocoState.care_plan = finalCarePlan

            debug(string.format('%s updating chocobo care plan: slot: %i type: %i length: %i',
                player:getName(), carePlanSlot + 1, carePlanType, carePlanLength))

            -- Write to cache
            xi.chocoboRaising.chocoState[player:getID()] = chocoState

            -- TODO: Write to db?

            -- There's no follow-up CSs here, bail out
            return
        end

        --------------------------------------------------------
        -- Main body update logic
        --------------------------------------------------------
        local opCodeName = vmOpCodeNames[option] or '?'
        debug(string.format('ChocoVM Op: %i: %s', option, opCodeName))

        switch (option): caseof
        {
            [vmOpCodes.CHECK_REPORT_STATUS] = function()
                local hasReport = 0
                if #chocoState.report.events > 0 then
                    hasReport = 0xFFFFFFFF
                end

                player:updateEvent(hasReport, 0, 0, 0, chocoState.stage, 0, 0, 0)
            end,

            -- ?
            [vmOpCodes.UNKNOWN_252] = function()
                local hasReport = 0
                if #chocoState.report.events > 0 then
                    hasReport = 0xFFFFFFFF
                end

                player:updateEvent(hasReport, 1, 1, 1, chocoState.stage, 1, 1, 1)
            end,

            -- Main menu (248 -> 214 -> 215)
            -- Update (248 -> 246 -> 244)
            [vmOpCodes.INTRO_MENU_PT_1] = function()
                local report = 0x00000000

                if #chocoState.report.events > 0 then
                    -- Pop the event from the front of the list
                    local currentEvent = chocoState.report.events[1]
                    table.remove(chocoState.report.events, 1)

                    local eventStartStart = currentEvent[1]
                    local eventStartEnd   = currentEvent[2]
                    local eventCSList     = currentEvent[3]

                    chocoState.age   = eventStartStart
                    chocoState.stage = xi.chocoboRaising.ageToStage(chocoState.age)

                    for _, cs in ipairs(eventCSList) do
                        table.insert(chocoState.csList, { cs, eventStartEnd - eventStartStart + 1 })
                    end

                    report = bit.lshift(eventStartStart, 0) + bit.lshift(eventStartEnd, 20)

                    if eventStartStart == eventStartEnd then
                        -- Single day update
                        report = report + 0x00000400
                    else
                        -- Multi-day update
                        report = report + 0x00001000
                    end
                end

                local playMultipleCutscenes = 0

                if #chocoState.report.events > 0 then
                    report = report + 0x80000000
                    playMultipleCutscenes = 0x00010000
                end

                -- TODO: What's this?
                local exitFlag = 0

                player:updateEvent(248, report, #chocoState.csList, playMultipleCutscenes, chocoState.stage, 0, 0, exitFlag)
            end,

            [vmOpCodes.INTRO_MENU_PT_2] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.INTRO_MENU_PT_3] = function()
                -- NOTE:
                -- To add options to these menus, we remove bits from the full mask.
                -- Therefore, we've defined the options as subtractive values, so we
                -- can add and remove at the same time...
                local menuFlags = 0xFFFFFFFF

                --
                -- Regular menu options
                --

                local askAboutChocoboCondition = -bit.lshift(0x01, 0)
                local careForYourChocobo       = -bit.lshift(0x01, 1)
                local setUpCareSchedule        = -bit.lshift(0x01, 2)

                menuFlags = menuFlags +
                    askAboutChocoboCondition +
                    careForYourChocobo +
                    setUpCareSchedule

                if
                    chocoState.stage > xi.chocoboRaising.stage.EGG and
                    chocoState.first_name == 'Chocobo' and
                    chocoState.last_name == 'Chocobo'
                then
                    local nameYourChocobo = -bit.lshift(0x01, 3)
                    menuFlags             = menuFlags + nameYourChocobo
                end

                if player:getCharVar('HQuest[ChocoboWhistle]Prog') >= 4 then
                    local requestDocumentation      = -bit.lshift(0x01, 4)
                    local registerToCallYourChocobo = -bit.lshift(0x01, 5)
                    local receiveYourChocoboWhistle = -bit.lshift(0x01, 6)
                    local purchaseAChocoboWhistle   = -bit.lshift(0x01, 7)

                    menuFlags = menuFlags +
                        requestDocumentation +
                        registerToCallYourChocobo +
                        receiveYourChocoboWhistle +
                        purchaseAChocoboWhistle
                end

                -- 8 - 25 are all '-----' (blank)

                --
                -- Debug options
                --

                local gmModeToggled = player:getVisibleGMLevel() >= 3
                if gmModeToggled then
                    -- Go forward   1 unit (debug) (Unused, see command: !chocoboraising)
                    local goForward1UnitDebug = -bit.lshift(0x01, 26)

                    -- Abilities print (debug) (Unused, see command: !chocoboraising)
                    local abilitiesPrintDebug = -bit.lshift(0x01, 27)

                    -- User work print (debug) (Unused, see command: !chocoboraising)
                    local userWorkPrintDebug = -bit.lshift(0x01, 28)

                    menuFlags = menuFlags +
                        goForward1UnitDebug +
                        abilitiesPrintDebug +
                        userWorkPrintDebug
                end

                --
                -- Danger zone
                --

                if chocoState.stage >= xi.chocoboRaising.stage.ADULT_1 then
                    local retireYourChocobo = -bit.lshift(0x01, 29) -- Retire your chocobo
                    menuFlags = menuFlags + retireYourChocobo
                else
                    local giveUpChocoboRaising = -bit.lshift(0x01, 30) -- Give up chocobo raising
                    menuFlags = menuFlags + giveUpChocoboRaising
                end

                -- Exit is always available
                local exit = -bit.lshift(0x01, 31)
                menuFlags = menuFlags + exit

                player:updateEvent(menuFlags, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.FORCED_NAMING] = function()
                -- NOTE: The renaming is done in event playout, otherwise the CS won't see the
                --     : new name in time to present it.
                -- TODO: If you skip the report where the chocobo is force-named, the new name won't
                --     : be visible until you've closed and reopened the menu.
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.FEED_CHOCOBO] = function()
                -- Complete the trade here to prevent any cheesing
                player:confirmTrade()

                for idx, itemId in ipairs(chocoState.foodGiven) do
                    local itemData     = xi.chocoboRaising.validFoods[itemId]
                    local hungerAmount = itemData[1]
                    local energyAmount = itemData[3]
                    local glowColor    = itemData[10]

                    player:messageSpecial(ID.text.CHOCOBO_FEEDING_ITEM, itemId, idx)

                    -- TODO: Handle item effects

                    if xi.chocoboRaising.hasCondition(chocoState) then
                        for _, condition in ipairs(chocoState.conditions) do
                            if xi.chocoboRaising.getCondition(chocoState, condition) then
                                local foodCureTable = xi.chocoboRaising.conditionsHealedByItems[condition]

                                if foodCureTable then
                                    if utils.contains(itemId, foodCureTable) then
                                        -- TODO: Play CS for healing condition, or messaging?
                                        xi.chocoboRaising.setCondition(chocoState, condition, false)
                                    end
                                end
                            end
                        end
                    end

                    local reaction = 1

                    chocoState.hunger = utils.clamp(chocoState.hunger + hungerAmount, 0, 255)
                    chocoState.energy = utils.clamp(chocoState.energy + energyAmount, 0, 100)

                    -- If multiple items, glow is always green
                    if #chocoState.foodGiven > 1 then
                        glowColor = xi.chocoboRaising.glow.GREEN
                    end

                    player:updateEvent(10, glowColor, 0, 0, reaction, xi.chocoboRaising.numberToRank(chocoState.hunger), 0, 0)
                end

                chocoState.foodGiven = nil

                xi.chocoboRaising.updateChocoState(player, chocoState)
            end,

            [vmOpCodes.PRESENT_CHOCOBO_APPEARANCE] = function()
                -- We don't want to leak color or physical trait information to the client before it's
                -- meant to be seen, so we're going to put in default dummy data in the early lifecycle
                -- stages.
                if chocoState.stage == xi.chocoboRaising.stage.EGG then
                    -- No information
                    player:updateEvent(xi.chocobo.color.YELLOW, 0, 0, 0, chocoState.stage, 0, 0, 0)
                elseif chocoState.stage < xi.chocoboRaising.stage.ADOLESCENT then
                    -- A little information
                    player:updateEvent(xi.chocobo.color.YELLOW, 0, 0, 0, chocoState.stage, chocoState.sex, 0, 0)
                elseif chocoState.stage < xi.chocoboRaising.stage.ADULT_1 then
                    -- Partial information
                    player:updateEvent(chocoState.color, 0, 0, 0, chocoState.stage, chocoState.sex, 0, 0)
                else -- Full information
                    -- TODO: These appearance changes are locked in on day 29 if
                    -- they are 'Average' (128) or above. This will need to be
                    -- written to the db and this part rewritten.
                    local enlargedCrest    = chocoState.discernment >= 128 and 1 or 0
                    local enlargedFeet     = chocoState.strength >= 128 and 1 or 0
                    local moreTailFeathers = chocoState.endurance >= 128 and 1 or 0

                    player:updateEvent(chocoState.color, enlargedCrest, enlargedFeet, moreTailFeathers, chocoState.stage, chocoState.sex, 0, 0)
                end
            end,

            -- TODO: This is hit directly after the CS for an egg hatching when we return to the main
            --     : menu, so what does this mean? What does it do?
            [vmOpCodes.PREPARE_CHOCOBO_MENU] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            -- TODO: Is this even getting hit?
            [vmOpCodes.UNKNOWN_600] = function()
                -- Get KI during another CS (determined randomly)
                local ki    = xi.ki.DIRTY_HANDKERCHIEF
                local getKi = 1

                player:updateEvent(ki, 0, 0, 0, 0, getKi, 0, 0)
                player:addKeyItem(ki)
            end,

            [vmOpCodes.ASK_ABOUT_CONDITION_MENU] = function()
                -- TODO: When is this used?
                -- Block all other information
                -- local blockFlag = bit.lshift(0x01, 31) -- Sorry, but you will have to do this later. I have something new to report.

                local arg0 = vmOpCodes.ASK_ABOUT_CONDITION_MENU

                local arg1 = xi.chocoboRaising.packStats1(chocoState)

                local affection = xi.chocoboRaising.affectionToAffectionRank(chocoState.affection)
                local arg2      = bit.lshift(affection, 0) +
                    bit.lshift(chocoState.hunger, 16)

                -- TODO: Does this leak the ability information early? Should we block this out?
                local arg3 = bit.lshift(chocoState.personality, 0) +
                    bit.lshift(chocoState.weather_preference, 4) +
                    bit.lshift(chocoState.ability1, 8) +
                    bit.lshift(chocoState.ability2, 12) +
                    bit.lshift(chocoState.stage, 16)

                debug(string.format('strength: %i', chocoState.strength))
                debug(string.format('endurance: %i', chocoState.endurance))
                debug(string.format('discernment: %i', chocoState.discernment))
                debug(string.format('receptivity: %i', chocoState.receptivity))
                debug(string.format('affection: %i', chocoState.affection))

                --
                -- NOTE: This does NOT use the negative masks of the menus!
                --

                local legWounded         = bit.lshift(0x01, 0)
                local slightlyIll        = bit.lshift(0x01, 1)
                local stomachAche        = bit.lshift(0x01, 2)
                local depressed          = bit.lshift(0x01, 3)
                local excellentCondition = bit.lshift(0x01, 4)
                local sleepingSoundly    = bit.lshift(0x01, 5)
                local veryIll            = bit.lshift(0x01, 6)
                local boredRestless      = bit.lshift(0x01, 7)
                local hopelesslySpoiled  = bit.lshift(0x01, 8)
                local ranAway            = bit.lshift(0x01, 9)
                local inLove             = bit.lshift(0x01, 10)
                local makingAFuss        = bit.lshift(0x01, 11)
                local fullOfEnergy       = bit.lshift(0x01, 12)
                local brightAndFocussed  = bit.lshift(0x01, 13)

                -- No flags: Stable
                local arg4 = 0x00000000

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.INJURED) then
                    arg4 = arg4 + legWounded
                end

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.SICK) then
                    arg4 = arg4 + slightlyIll
                end

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.ILL) then
                    arg4 = arg4 + stomachAche
                end

                -- TODO: depressed
                utils.unused(depressed)

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.HIGH_SPIRITS) then
                    arg4 = arg4 + excellentCondition
                end

                -- TODO: sleepingSoundly
                utils.unused(sleepingSoundly)

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.VERY_ILL) then
                    arg4 = arg4 + veryIll
                end

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.BORED) then
                    arg4 = arg4 + boredRestless
                end

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.SPOILED) then
                    arg4 = arg4 + hopelesslySpoiled
                end

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.RUN_AWAY) then
                    arg4 = arg4 + ranAway
                end

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.LOVESICK) then
                    arg4 = arg4 + inLove
                end

                -- TODO: makingAFuss
                utils.unused(makingAFuss)

                if
                    xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.FULL_OF_ENERGY_1) or
                    xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.FULL_OF_ENERGY_2)
                then
                    arg4 = arg4 + fullOfEnergy
                end

                if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.BRIGHT_AND_FOCUSED) then
                    arg4 = arg4 + brightAndFocussed
                end

                player:updateEvent(arg0, arg1, arg2, arg3, arg4, 0, 0, 0)
            end,

            [vmOpCodes.CARE_FOR_CHOCOBO_MENU] = function()
                debug(string.format('  Energy: %i', chocoState.energy))

                local watchOverChocobo  = -bit.lshift(0x01, 0)
                local tellAStory        = -bit.lshift(0x01, 1)
                local scoldTheChocobo   = -bit.lshift(0x01, 2)
                local competeWithOthers = -bit.lshift(0x01, 3)
                local goOnAWalkShort    = -bit.lshift(0x01, 4)
                local goOnAWalkRegular  = -bit.lshift(0x01, 5)
                local goOnAWalkLong     = -bit.lshift(0x01, 6)

                local mask = 0x7FFFFFFF + watchOverChocobo

                if chocoState.stage >= xi.chocoboRaising.stage.CHICK then
                    mask = mask +
                        scoldTheChocobo +
                        goOnAWalkShort
                end

                if chocoState.stage >= xi.chocoboRaising.stage.ADOLESCENT then
                    -- TODO: Is this unlocked per-chocobo, or per-player?
                    local knowsAStory = true
                    if knowsAStory then
                        mask = mask + tellAStory
                    end

                    mask = mask + goOnAWalkRegular

                    -- TODO: competeWithOthers: Available at adolescent stage; You must go on a regular walk to unlock this.
                    local hasGoneOnRegularWalk = true
                    if hasGoneOnRegularWalk then
                        mask = mask + competeWithOthers
                    end
                end

                if chocoState.stage >= xi.chocoboRaising.stage.ADULT_1 then
                    mask = mask + goOnAWalkLong
                end

                player:updateEvent(mask, chocoState.energy, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.GO_ON_A_WALK_SHORT] = function()
                table.insert(chocoState.csList, xi.chocoboRaising.cutscenes.TAKE_A_WALK)

                player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name,
                    0, 0, 0, 0, 0, 0, 0, 0)

                local csData =
                {
                    -- Sandoria (Chick)
                    -- [0] = { 0, 0,  2, 0, 0, 0, 0, 0 }, -- Find lost chocobo
                    [1] = { 0, 0,  7, 0, 0, 0, 0, 0 }, -- Find item (chocobo takes home)
                    -- [2] = { 0, 0,  0, 0, 0, 0, 0, 0 }, -- Nothing?
                    [2] = { 0, 0, 3, 256, 0, 3, 0, 0 }, -- Meet Ace

                    -- Bastok (Chick)
                    -- [11] = {},

                    -- Windurst (Chick)
                    -- [20] = { 0, 0, 7, 0,   0, 0, 0, 0 }, -- Get KI
                    -- [21] = { 0, 0, 2, 0,   0, 0, 0, 0 }, -- Find lost chocobo
                    -- [22] = { 0, 0, 0, 0,   0, 0, 0, 0 }, -- Nothing?
                    -- [23] = { 0, 0, 3, 256, 0, 1, 0, 0 }, -- Meet Ace
                    -- [24] = { 0, 0, 0, 0,   0, 0, 0, 0 }, -- Nothing?
                    -- [25] = { 0, 0, 7, 0,   0, 0, 0, 0 }, -- Find item (chocobo takes home)
                }

                local baseCS       = xi.chocoboRaising.csidTable[player:getZoneID()][6]
                local energyAmount = xi.chocoboRaising.walkEnergyAmount[1] + math.random(0, xi.chocoboRaising.walkEnergyRandomness)
                local energyFlag   = 0

                if chocoState.energy < energyAmount then
                    energyFlag = -1
                else
                    chocoState.energy = chocoState.energy - energyAmount
                end

                local walkZoneId = xi.chocoboRaising.shortWalkLocation[xi.chocoboRaising.raisingLocation[player:getZoneID()]]
                local csWeather  = xi.chocoboRaising.getWeatherInZone(walkZoneId)
                local output     = { 0, 0, 0, 0, 0, 0, 0, 0 }

                -- NOTE: We have to enforce the stage, otherwise this CS will freeze the client.
                --     : The result is client-side, we can't force success.
                local doWhistleWalkEvent = player:getCharVar('HQuest[ChocoboWhistle]Prog') == 2 and
                    chocoState.stage >= xi.chocoboRaising.stage.ADULT_1

                if doWhistleWalkEvent then -- Force whistle event
                    debug('Forcing Chocobo Whistle Walk event')
                    output = { 0, 14929, 1, 0, 4, 0, 2, 0 }
                elseif math.random(1, 100) <= xi.chocoboRaising.walkEventChance then -- Will there be a random event?
                    local possibleEvents = {}

                    -- If not holding an item, it's possible to find an item
                    if chocoState.held_item == 0 then
                        table.insert(possibleEvents, 1)
                    end

                    -- TODO: This is wrong?
                    -- If you haven't completed the White Handkerchief quest yet
                    -- if not player:hasKeyItem(xi.keyItem.WHITE_HANDKERCHIEF) then
                    --     table.insert(possibleEvents, 2)
                    -- end

                    -- TODO: Meet other chocobos & raisers

                    local randomEvent = utils.randomEntry(possibleEvents)
                    if randomEvent then
                        output = { unpack(csData[randomEvent]) }
                    end
                end

                -- Patch with the base CS and other bits
                output[1] = baseCS
                -- output[2] = energyFlag
                output[5] = chocoState.stage
                output[8] = csWeather

                -- TODO: This is a bit confusing
                if output[3] == 7 and energyFlag >= 0 then -- Chocobo found an item
                    local itemId         = utils.randomEntry(xi.chocoboRaising.walkItems[walkZoneId])
                    output[2]            = itemId
                    chocoState.held_item = itemId
                end

                player:updateEvent(unpack(output))
            end,

            [vmOpCodes.GO_ON_A_WALK_REGULAR] = function()
                table.insert(chocoState.csList, xi.chocoboRaising.cutscenes.TAKE_A_WALK)

                player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name,
                    0, 0, 0, 0, 0, 0, 0, 0)

                local csData =
                {
                    [1] = { 0, 0,  7, 0, 0, 0, 0, 0 }, -- Find item (chocobo takes home)
                }

                local baseCS       = xi.chocoboRaising.csidTable[player:getZoneID()][6]
                local energyAmount = xi.chocoboRaising.walkEnergyAmount[2] + math.random(0, xi.chocoboRaising.walkEnergyRandomness)
                local energyFlag   = 0

                if chocoState.energy < energyAmount then
                    energyFlag = -1
                else
                    chocoState.energy = chocoState.energy - energyAmount
                end

                local walkZoneId = xi.chocoboRaising.mediumWalkLocation[xi.chocoboRaising.raisingLocation[player:getZoneID()]]
                local csWeather  = xi.chocoboRaising.getWeatherInZone(walkZoneId)

                local output = { 0, 0, 0, 0, 0, 0, 0, 0 }

                -- Will there be an event?
                if math.random(1, 100) <= xi.chocoboRaising.walkEventChance then
                    -- TODO: Hard-coded to randomly finding an item
                    output = { unpack(csData[1]) }
                end

                output[1] = baseCS
                output[2] = energyFlag
                output[5] = chocoState.stage
                output[8] = csWeather

                -- If the chocobo is going to find and item, but already has one:
                -- Don't play the cutscene!
                if output[3] == 7 and chocoState.held_item > 0 then
                    output[3] = 0
                end

                if output[3] == 7 and energyFlag >= 0 then -- Chocobo found an item
                    local itemId         = utils.randomEntry(xi.chocoboRaising.walkItems[walkZoneId])
                    output[2]            = itemId
                    chocoState.held_item = itemId
                end

                player:updateEvent(unpack(output))
            end,

            [vmOpCodes.GO_ON_A_WALK_LONG] = function()
                table.insert(chocoState.csList, xi.chocoboRaising.cutscenes.TAKE_A_WALK)

                player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name,
                    0, 0, 0, 0, 0, 0, 0, 0)

                local csData =
                {
                    [1] = { 0, 0,  7, 0, 0, 0, 0, 0 }, -- Find item (chocobo takes home)
                }

                local baseCS       = xi.chocoboRaising.csidTable[player:getZoneID()][6]
                local energyAmount = xi.chocoboRaising.walkEnergyAmount[3] + math.random(0, xi.chocoboRaising.walkEnergyRandomness)
                local energyFlag   = 0

                if chocoState.energy < energyAmount then
                    energyFlag = -1
                else
                    chocoState.energy = chocoState.energy - energyAmount
                end

                local walkZoneId = xi.chocoboRaising.longWalkLocation[xi.chocoboRaising.raisingLocation[player:getZoneID()]]
                local csWeather  = xi.chocoboRaising.getWeatherInZone(walkZoneId)
                local output     = { 0, 0, 0, 0, 0, 0, 0, 0 }

                -- Will there be an event?
                if math.random(1, 100) <= xi.chocoboRaising.walkEventChance then
                    -- TODO: Hard-coded to randomly finding an item
                    output = { unpack(csData[1]) }
                end

                output[1] = baseCS
                output[2] = energyFlag
                output[5] = chocoState.stage
                output[8] = csWeather

                -- If the chocobo is going to find and item, but already has one:
                -- Don't play the cutscene!
                if output[3] == 7 and chocoState.held_item > 0 then
                    output[3] = 0
                end

                if output[3] == 7 and energyFlag >= 0 then -- Chocobo found an item
                    local itemId         = utils.randomEntry(xi.chocoboRaising.walkItems[walkZoneId])
                    output[2]            = itemId
                    chocoState.held_item = itemId
                end

                player:updateEvent(unpack(output))
            end,

            [vmOpCodes.WATCH_OVER_CHOCOBO_CONFIRM] = function()
            -- TODO: Is this needed? Check caps
                -- player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name,
                --     0, 0, 0, 0, 0, 0, 0)

                local baseCS = xi.chocoboRaising.csidTable[player:getZoneID()][9]

                --
                -- Handle egg case
                --
                if chocoState.stage == xi.chocoboRaising.stage.EGG then
                    -- Your egg does not seem to be in the best condition at the moment...
                    local badEggFlag = 0 -- bit.lshift(0x01, 31) -- 1st arg

                    player:updateEvent(baseCS, badEggFlag, 0, 0, 0, 0, 0, 0)
                    return
                end

                --
                -- Regular case
                --
                local energyFlag = 0

                if chocoState.energy < xi.chocoboRaising.watchOverEnergy then
                    energyFlag = -1
                else
                    chocoState.energy = chocoState.energy - xi.chocoboRaising.watchOverEnergy
                end

                -- Sandy: 304, 14396, 0, 0, 6, 0, 0, 2
                -- Windurst: 816, 18250, 1, 511, 2, 0, 0, 1
                local givingItem = 0
                local givenItem  = 0

                if chocoState.held_item > 0 then
                    givingItem = 1
                    givenItem  = chocoState.held_item
                end

                if
                    givingItem == 1 and
                    player:getFreeSlotsCount() == 0
                then
                    givingItem = 2
                end

                player:updateEvent(baseCS, energyFlag, givingItem, givenItem, 2, 0, 0, 1)

                if givingItem == 1 then
                    player:addItem({ id = givenItem, silent = true })
                    chocoState.held_item = 0
                end
            end,

            [vmOpCodes.TELL_A_STORY] = function()
                -- A chocobo must have a DSC of D (A bit deficient, 64-95) or
                -- higher to have a chance at learning a skill from a story
                if chocoState.discernment >= 64 then
                    utils.unused()
                    -- TODO: Chance to learn skill
                end

                local storyMask = 0xFFFFFFFE -- 0xFFFFFF9C

                -- TODO: This looks very similar to SCOLD_CHOCOBO and COMPETE_WITH_OTHERS, should we move those updates
                --     : inside onRaisingEventPlayout?
                chocoState = xi.chocoboRaising.onRaisingEventPlayout(player, xi.chocoboRaising.cutscenes.INTERESTED_IN_YOUR_STORY, chocoState)

                player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name, 0, 0, 0, 0, 0, 0, 0)
                player:updateEvent(xi.chocoboRaising.getCutsceneWithOffset(player, xi.chocoboRaising.cutscenes.INTERESTED_IN_YOUR_STORY), 0, storyMask, 0, chocoState.stage, 0, 0, 3)
                xi.chocoboRaising.updateChocoState(player, chocoState)
            end,

            [vmOpCodes.SCOLD_CHOCOBO] = function()
                chocoState = xi.chocoboRaising.onRaisingEventPlayout(player, xi.chocoboRaising.cutscenes.HANGS_HEAD_IN_SHAME, chocoState)

                player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name, 0, 0, 0, 0, 0, 0, 0)
                player:updateEvent(xi.chocoboRaising.getCutsceneWithOffset(player, xi.chocoboRaising.cutscenes.HANGS_HEAD_IN_SHAME), 0, 0, 0, chocoState.stage, 0, 0, 0)
                xi.chocoboRaising.updateChocoState(player, chocoState)
            end,

            [vmOpCodes.COMPETE_WITH_OTHERS] = function()
                -- player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name,
                --     4163, 67, 0, 0, 0, 0, 0)
                -- player:updateEvent(820, 18017, 0, 72, 3, 254, 46, 1)

                -- 0: player chocobo, 1: tie, 2: rival chocobo
                -- NOTE: The guides claim that the winner is random, so
                --     : let's make it 50/50 to start with, and then a small
                --     : chance on top for a tie.
                local winner = utils.randomEntry({ 0, 2 })
                if math.random(1, 100) <= 5 then
                    winner = 1
                end

                local winnerStr =
                {
                    [0] = 'Player',
                    [1] = 'Tie',
                    [2] = 'Rival',
                }

                debug('Competition Winner: ' .. winnerStr[winner])

                -- TODO: Use relevant name for area
                local rivalsName = 'Hero'

                -- TODO: Hook up rival's look

                -- TODO: Track wins in chocoState+db, only need to track up to 3

                chocoState = xi.chocoboRaising.onRaisingEventPlayout(player, xi.chocoboRaising.cutscenes.COMPETE_WITH_OTHERS, chocoState)

                player:updateEventString(chocoState.first_name, rivalsName, '', '', 0, 0, 0, 0, 0, 0, 0)
                player:updateEvent(xi.chocoboRaising.getCutsceneWithOffset(player, xi.chocoboRaising.cutscenes.COMPETE_WITH_OTHERS), 0, winner, 0, chocoState.stage, 0, 0, 0)
            end,

            [vmOpCodes.SET_CARE_SCHEDULE_MENU] = function()
                local plan1Length = bit.rshift(bit.band(chocoState.care_plan, 0xF0000000), 28)
                local plan1Type   = bit.rshift(bit.band(chocoState.care_plan, 0x0F000000), 24)
                local plan2Length = bit.rshift(bit.band(chocoState.care_plan, 0x00F00000), 20)
                local plan2Type   = bit.rshift(bit.band(chocoState.care_plan, 0x000F0000), 16)
                local plan3Length = bit.rshift(bit.band(chocoState.care_plan, 0x0000F000), 12)
                local plan3Type   = bit.rshift(bit.band(chocoState.care_plan, 0x00000F00),  8)
                local plan4Length = bit.rshift(bit.band(chocoState.care_plan, 0x000000F0),  4)
                local plan4Type   = bit.rshift(bit.band(chocoState.care_plan, 0x0000000F),  0)

                local planInfo =
                    bit.lshift(plan1Length,   0) + bit.lshift(plan1Type,   3) +
                    bit.lshift(plan2Length,   8) + bit.lshift(plan2Type,  11) +
                    bit.lshift(plan3Length,  16) + bit.lshift(plan3Type,  19) +
                    bit.lshift(plan4Length,  24) + bit.lshift(plan4Type,  27)

                local emptyMask            = 0x7FFFFFFF
                local basicCare            = -bit.lshift(0x01, 0)
                local rest                 = -bit.lshift(0x01, 1)
                local takeAWalkInTown      = -bit.lshift(0x01, 2)
                local listenToMusic        = -bit.lshift(0x01, 3)
                local exerciseAlone        = -bit.lshift(0x01, 4)
                local exerciseInAGroup     = -bit.lshift(0x01, 5)
                local interactWithChildren = -bit.lshift(0x01, 6)
                local interactWithChocobos = -bit.lshift(0x01, 7)
                local carryPackages        = -bit.lshift(0x01, 8)
                local exhibitToThePublic   = -bit.lshift(0x01, 9)
                local deliverMessages      = -bit.lshift(0x01, 10)
                local digForTreasure       = -bit.lshift(0x01, 11)
                local actInAPlay           = -bit.lshift(0x01, 12)
                -- The remaining options are blank and there seemingly are no
                -- debug options

                --
                -- Append more options depending on chocobo's age
                --

                -- TODO: Make all of this a table

                -- Options for Egg and beyond
                local menuMask = emptyMask + basicCare

                if chocoState.stage >= xi.chocoboRaising.stage.CHICK then
                    menuMask = menuMask +
                        rest +
                        takeAWalkInTown +
                        listenToMusic
                end

                if chocoState.stage >= xi.chocoboRaising.stage.ADOLESCENT then
                    menuMask = menuMask +
                        exerciseAlone +
                        exerciseInAGroup +
                        interactWithChildren +
                        interactWithChocobos +
                        carryPackages +
                        exhibitToThePublic
                end

                if chocoState.stage >= xi.chocoboRaising.stage.ADULT_1 then
                    menuMask = menuMask +
                        deliverMessages +
                        digForTreasure +
                        actInAPlay
                end

                player:updateEvent(250, planInfo, 0, 0, 0, 0, 0, menuMask)
            end,

            [vmOpCodes.SET_BASIC_CARE_PLAN_1] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.SET_BASIC_CARE_PLAN_2] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.SET_BASIC_CARE_PLAN_3] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.SET_BASIC_CARE_PLAN_4] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.UNKNOWN_1056] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.UNKNOWN_1241] = function() -- Called during 'Compete with Others'
                -- Appears to always be blank
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.EVENT_PLAYOUT] = function()
                chocoState = xi.chocoboRaising.handleCSUpdate(player, chocoState, true)
            end,

            [vmOpCodes.BRIEF_REPORT] = function()
                -- TODO
            end,

            [vmOpCodes.WHISTLE_GAME_RESULT] = function()
                -- TODO: Handle this:
                --     : A successful search does not guarantee you'll find the item. That means the item is not in that area, and you should look in the other two areas.
                --     : We'll need to pre-assign which area the search will succeed in, and also remember
                --     : if the chocobo finished the white handkerchief quest with the player.

                -- TODO: If you finished the white handerchief quest, you'll get the
                --     : DIRTY_HANDKERCHIEF instead of HANDKERCHIEF.
                local keyItem = xi.keyItem.HANDKERCHIEF

                -- TODO: What are the chances here, seems fair but not guaranteed from caps.
                if math.random(1, 100) < 25 then -- success
                    player:updateEvent(keyItem, 0, 0, 0, 0, 1, 0, 0)
                    player:addKeyItem(keyItem)
                    player:setCharVar('HQuest[ChocoboWhistle]Prog', 3)
                else -- failure
                    player:updateEvent(0, 0, 0, 0, 0, 2, 0, 0)
                end
            end,

            [vmOpCodes.SKIP_REPORT] = function()
                for _, currentEvent in ipairs(chocoState.report.events) do
                    local eventStartStart = currentEvent[1]
                    local eventStartEnd   = currentEvent[2]
                    local eventCSList     = currentEvent[3]

                    chocoState.age   = eventStartStart
                    chocoState.stage = xi.chocoboRaising.ageToStage(chocoState.age)

                    for _, cs in ipairs(eventCSList) do
                        table.insert(chocoState.csList, { cs, eventStartEnd - eventStartStart + 1 })
                    end
                end

                chocoState.report.events = {}

                -- NOTE: Each cs will be popped off inside of handleCSUpdate
                while #chocoState.csList > 0 do
                    chocoState = xi.chocoboRaising.handleCSUpdate(player, chocoState, false)
                end

                xi.chocoboRaising.updateChocoState(player, chocoState)
            end,

            [vmOpCodes.BUY_CHOCOBO_WHISTLE] = function()
                -- TODO
            end,

            [vmOpCodes.RECEIVE_CHOCOBO_WHISTLE] = function()
                -- TODO
            end,

            [vmOpCodes.REGISTER_CHOCOBO_WHISTLE] = function()
                debug('Registering field chocobo details')
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)

                -- TODO: These appearance changes are locked in on day 29 if
                -- they are 'Average' (128) or above. This will need to be
                -- written to the db and this part rewritten.
                local traits =
                {
                    largeBeak   = chocoState.discernment >= 128 and 1 or 0,
                    fullTail    = chocoState.endurance >= 128 and 1 or 0,
                    largeTalons = chocoState.strength >= 128 and 1 or 0,
                }

                player:registerChocobo(chocoState.color, traits)
            end,

            [vmOpCodes.DEBUG_GO_FORWARD_1_UNIT] = function()
                -- TODO: Split stored age and time of creation so age can be manipulated from here
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.DEBUG_ABILITIES_PRINT] = function()
                local packedRawStats =
                    bit.lshift(chocoState.strength,     0) +
                    bit.lshift(chocoState.endurance,    8) +
                    bit.lshift(chocoState.discernment, 16) +
                    bit.lshift(chocoState.receptivity, 24)

                player:updateEvent(1, packedRawStats, xi.chocoboRaising.packStats2(chocoState), 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.DEBUG_USER_WORK_PRINT] = function()
                -- TODO: Should we be tracking all user interactions with the chocobo?
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
            end,

            [vmOpCodes.GIVE_UP_CHOCOBO] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
                player:deleteRaisedChocobo()
            end,

            [vmOpCodes.RETIRE_YOUR_CHOCOBO] = function()
                player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
                player:deleteRaisedChocobo()
            end,
        }
    end
end
