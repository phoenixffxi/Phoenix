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
    UNKNOWN_24672              = 24672,
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
    [vmOpCodes.UNKNOWN_24672]              = 'Something around retirement?',
}

local function handleNamingUpdate(player, chocoState, option)
    local offset1     = bit.band(0x3FF, bit.rshift(option, 8))
    local offset2     = bit.band(0x3FF, bit.rshift(option, 18))
    local fname       = xi.chocoboNames[offset1]
    local lname       = xi.chocoboNames[offset2]
    local fullnamekey = string.format('%s %s', fname, lname)

    local nameTooLong = string.len(fullnamekey) > (15 + 1)

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

        xi.chocoboRaising.chocoState[player:getID()] = chocoState

        if chocoState.first_name == 'Chocobo' and chocoState.last_name == 'Chocobo' then
            player:updateEvent(1, 1, 1, 1, 1, 1, 1, 1)
        else
            player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
        end
    end
end

local function handleCarePlanUpdate(player, chocoState, option)
    local carePlanSlot   = bit.band(0xF, bit.rshift(option, 8))
    local carePlanLength = bit.band(0x7, bit.rshift(option, 16))
    local carePlanType   = bit.band(0xF, bit.rshift(option, 19))

    debug(string.format('carePlanSlot: %i, carePlanLength: %i, carePlanType: %i',
        carePlanSlot, carePlanLength, carePlanType))

    if chocoState.care_plan == 0 then
        local defaultCarePlan = bit.lshift(7, 4) + 0

        chocoState.care_plan =
            bit.lshift(defaultCarePlan, 24) +
            bit.lshift(defaultCarePlan, 16) +
            bit.lshift(defaultCarePlan,  8) +
            bit.lshift(defaultCarePlan,  0)
    end

    local carePlan = bit.lshift(carePlanLength, 4) + carePlanType
    local targetSlotOffset = 24 - (carePlanSlot * 8)
    local mask             = bit.bnot(bit.lshift(0xFF, targetSlotOffset))
    local zerodCarePlan    = bit.band(chocoState.care_plan, mask)

    local finalCarePlan  = bit.bor(zerodCarePlan, bit.lshift(carePlan, targetSlotOffset))
    chocoState.care_plan = finalCarePlan

    debug(string.format('%s updating chocobo care plan: slot: %i type: %i length: %i',
        player:getName(), carePlanSlot + 1, carePlanType, carePlanLength))

    xi.chocoboRaising.chocoState[player:getID()] = chocoState
end

local vmHandlers =
{
    [vmOpCodes.CHECK_REPORT_STATUS] = function(player, chocoState, option)
        local hasReport = 0
        if #chocoState.report.events > 0 then
            hasReport = 0xFFFFFFFF
        end
        player:updateEvent(hasReport, 0, 0, 0, chocoState.stage, 0, 0, 0)
    end,

    [vmOpCodes.UNKNOWN_252] = function(player, chocoState, option)
        local hasReport = 0
        if #chocoState.report.events > 0 then
            hasReport = 0xFFFFFFFF
        end
        player:updateEvent(hasReport, 1, 1, 1, chocoState.stage, 1, 1, 1)
    end,

    [vmOpCodes.INTRO_MENU_PT_1] = function(player, chocoState, option)
        local report = 0x00000000

        if #chocoState.report.events > 0 then
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
                report = report + 0x00000400
            else
                report = report + 0x00001000
            end
        end

        local playMultipleCutscenes = 0

        if #chocoState.report.events > 0 then
            report = report + 0x80000000
            playMultipleCutscenes = 0x00010000
        end

        local exitFlag = 0
        player:updateEvent(248, report, #chocoState.csList, playMultipleCutscenes, chocoState.stage, 0, 0, exitFlag)
    end,

    [vmOpCodes.INTRO_MENU_PT_2] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.INTRO_MENU_PT_3] = function(player, chocoState, option)
        local menuFlags = 0xFFFFFFFF

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

        local gmModeToggled = player:getVisibleGMLevel() >= 3
        if gmModeToggled then
            local goForward1UnitDebug = -bit.lshift(0x01, 26)
            local abilitiesPrintDebug = -bit.lshift(0x01, 27)
            local userWorkPrintDebug = -bit.lshift(0x01, 28)

            menuFlags = menuFlags +
                goForward1UnitDebug +
                abilitiesPrintDebug +
                userWorkPrintDebug
        end

        if chocoState.stage >= xi.chocoboRaising.stage.ADULT_1 then
            local retireYourChocobo = -bit.lshift(0x01, 29)
            menuFlags = menuFlags + retireYourChocobo
        else
            local giveUpChocoboRaising = -bit.lshift(0x01, 30)
            menuFlags = menuFlags + giveUpChocoboRaising
        end

        local exit = -bit.lshift(0x01, 31)
        menuFlags = menuFlags + exit

        player:updateEvent(menuFlags, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.FORCED_NAMING] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.FEED_CHOCOBO] = function(player, chocoState, option)
        player:confirmTrade()
        local ID = zones[player:getZoneID()]

        for idx, itemId in ipairs(chocoState.foodGiven) do
            local itemData     = xi.chocoboRaising.validFoods[itemId]
            local hungerAmount = itemData[1]
            local energyAmount = itemData[3]
            local glowColor    = itemData[10]

            player:messageSpecial(ID.text.CHOCOBO_FEEDING_ITEM, itemId, idx)

            if xi.chocoboRaising.hasCondition(chocoState) then
                for _, condition in ipairs(chocoState.conditions) do
                    if xi.chocoboRaising.getCondition(chocoState, condition) then
                        local foodCureTable = xi.chocoboRaising.conditionsHealedByItems[condition]

                        if foodCureTable then
                            if utils.contains(itemId, foodCureTable) then
                                xi.chocoboRaising.setCondition(chocoState, condition, false)
                            end
                        end
                    end
                end
            end

            local reaction = 1

            chocoState.hunger = utils.clamp(chocoState.hunger + hungerAmount, 0, 255)
            chocoState.energy = utils.clamp(chocoState.energy + energyAmount, 0, 100)

            if #chocoState.foodGiven > 1 then
                glowColor = xi.chocoboRaising.glow.GREEN
            end

            player:updateEvent(10, glowColor, 0, 0, reaction, xi.chocoboRaising.numberToRank(chocoState.hunger), 0, 0)
        end

        chocoState.foodGiven = nil
        xi.chocoboRaising.updateChocoState(player, chocoState)
    end,

    [vmOpCodes.PRESENT_CHOCOBO_APPEARANCE] = function(player, chocoState, option)
        if chocoState.stage == xi.chocoboRaising.stage.EGG then
            player:updateEvent(xi.chocobo.color.YELLOW, 0, 0, 0, chocoState.stage, 0, 0, 0)
        elseif chocoState.stage < xi.chocoboRaising.stage.ADOLESCENT then
            player:updateEvent(xi.chocobo.color.YELLOW, 0, 0, 0, chocoState.stage, chocoState.sex, 0, 0)
        elseif chocoState.stage < xi.chocoboRaising.stage.ADULT_1 then
            player:updateEvent(chocoState.color, 0, 0, 0, chocoState.stage, chocoState.sex, 0, 0)
        else
            local enlargedCrest    = chocoState.discernment >= 128 and 1 or 0
            local enlargedFeet     = chocoState.strength >= 128 and 1 or 0
            local moreTailFeathers = chocoState.endurance >= 128 and 1 or 0

            player:updateEvent(chocoState.color, enlargedCrest, enlargedFeet, moreTailFeathers, chocoState.stage, chocoState.sex, 0, 0)
        end
    end,

    [vmOpCodes.PREPARE_CHOCOBO_MENU] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.UNKNOWN_600] = function(player, chocoState, option)
        local ki    = xi.ki.DIRTY_HANDKERCHIEF
        local getKi = 1

        player:updateEvent(ki, 0, 0, 0, 0, getKi, 0, 0)
        player:addKeyItem(ki)
    end,

    [vmOpCodes.ASK_ABOUT_CONDITION_MENU] = function(player, chocoState, option)
        local arg0 = vmOpCodes.ASK_ABOUT_CONDITION_MENU
        local arg1 = xi.chocoboRaising.packStats1(chocoState)
        local affection = xi.chocoboRaising.affectionToAffectionRank(chocoState.affection)
        local arg2 = bit.lshift(affection, 0) + bit.lshift(chocoState.hunger, 16)
        local arg3 = bit.lshift(chocoState.personality, 0) +
            bit.lshift(chocoState.weather_preference, 4) +
            bit.lshift(chocoState.ability1, 8) +
            bit.lshift(chocoState.ability2, 12) +
            bit.lshift(chocoState.stage, 16)

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
        if xi.chocoboRaising.getCondition(chocoState, xi.chocoboRaising.conditions.HIGH_SPIRITS) then
            arg4 = arg4 + excellentCondition
        end
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

    [vmOpCodes.CARE_FOR_CHOCOBO_MENU] = function(player, chocoState, option)
        local watchOverChocobo  = -bit.lshift(0x01, 0)
        local tellAStory        = -bit.lshift(0x01, 1)
        local scoldTheChocobo   = -bit.lshift(0x01, 2)
        local competeWithOthers = -bit.lshift(0x01, 3)
        local goOnAWalkShort    = -bit.lshift(0x01, 4)
        local goOnAWalkRegular  = -bit.lshift(0x01, 5)
        local goOnAWalkLong     = -bit.lshift(0x01, 6)

        local mask = 0x7FFFFFFF + watchOverChocobo

        if chocoState.stage >= xi.chocoboRaising.stage.CHICK then
            mask = mask + scoldTheChocobo + goOnAWalkShort
        end

        if chocoState.stage >= xi.chocoboRaising.stage.ADOLESCENT then
            local knowsAStory = true
            if knowsAStory then
                mask = mask + tellAStory
            end
            mask = mask + goOnAWalkRegular

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

    [vmOpCodes.GO_ON_A_WALK_SHORT] = function(player, chocoState, option)
        table.insert(chocoState.csList, xi.chocoboRaising.cutscenes.TAKE_A_WALK)

        player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name,
            0, 0, 0, 0, 0, 0, 0, 0)

        local csData = {
            [1] = { 0, 0,  7, 0, 0, 0, 0, 0 },
            [2] = { 0, 0, 3, 256, 0, 3, 0, 0 },
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

        local doWhistleWalkEvent = player:getCharVar('HQuest[ChocoboWhistle]Prog') == 2 and
            chocoState.stage >= xi.chocoboRaising.stage.ADULT_1

        if doWhistleWalkEvent then
            output = { 0, 14929, 1, 0, 4, 0, 2, 0 }
        elseif math.random(1, 100) <= xi.chocoboRaising.walkEventChance then
            local possibleEvents = {}
            if chocoState.held_item == 0 then
                table.insert(possibleEvents, 1)
            end

            local randomEvent = utils.randomEntry(possibleEvents)
            if randomEvent then
                output = { unpack(csData[randomEvent]) }
            end
        end

        output[1] = baseCS
        output[5] = chocoState.stage
        output[8] = csWeather

        if output[3] == 7 and energyFlag >= 0 then
            local itemId         = utils.randomEntry(xi.chocoboRaising.walkItems[walkZoneId])
            output[2]            = itemId
            chocoState.held_item = itemId
        end

        player:updateEvent(unpack(output))
    end,

    [vmOpCodes.GO_ON_A_WALK_REGULAR] = function(player, chocoState, option)
        table.insert(chocoState.csList, xi.chocoboRaising.cutscenes.TAKE_A_WALK)

        player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name,
            0, 0, 0, 0, 0, 0, 0, 0)

        local csData = {
            [1] = { 0, 0,  7, 0, 0, 0, 0, 0 },
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
        local output     = { 0, 0, 0, 0, 0, 0, 0, 0 }

        if math.random(1, 100) <= xi.chocoboRaising.walkEventChance then
            output = { unpack(csData[1]) }
        end

        output[1] = baseCS
        output[2] = energyFlag
        output[5] = chocoState.stage
        output[8] = csWeather

        if output[3] == 7 and chocoState.held_item > 0 then
            output[3] = 0
        end

        if output[3] == 7 and energyFlag >= 0 then
            local itemId         = utils.randomEntry(xi.chocoboRaising.walkItems[walkZoneId])
            output[2]            = itemId
            chocoState.held_item = itemId
        end

        player:updateEvent(unpack(output))
    end,

    [vmOpCodes.GO_ON_A_WALK_LONG] = function(player, chocoState, option)
        table.insert(chocoState.csList, xi.chocoboRaising.cutscenes.TAKE_A_WALK)

        player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name,
            0, 0, 0, 0, 0, 0, 0, 0)

        local csData = {
            [1] = { 0, 0,  7, 0, 0, 0, 0, 0 },
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

        if math.random(1, 100) <= xi.chocoboRaising.walkEventChance then
            output = { unpack(csData[1]) }
        end

        output[1] = baseCS
        output[2] = energyFlag
        output[5] = chocoState.stage
        output[8] = csWeather

        if output[3] == 7 and chocoState.held_item > 0 then
            output[3] = 0
        end

        if output[3] == 7 and energyFlag >= 0 then
            local itemId         = utils.randomEntry(xi.chocoboRaising.walkItems[walkZoneId])
            output[2]            = itemId
            chocoState.held_item = itemId
        end

        player:updateEvent(unpack(output))
    end,

    [vmOpCodes.WATCH_OVER_CHOCOBO_CONFIRM] = function(player, chocoState, option)
        local baseCS = xi.chocoboRaising.csidTable[player:getZoneID()][9]

        if chocoState.stage == xi.chocoboRaising.stage.EGG then
            local badEggFlag = 0
            player:updateEvent(baseCS, badEggFlag, 0, 0, 0, 0, 0, 0)
            return
        end

        local energyFlag = 0
        if chocoState.energy < xi.chocoboRaising.watchOverEnergy then
            energyFlag = -1
        else
            chocoState.energy = chocoState.energy - xi.chocoboRaising.watchOverEnergy
        end

        local givingItem = 0
        local givenItem  = 0

        if chocoState.held_item > 0 then
            givingItem = 1
            givenItem  = chocoState.held_item
        end

        if givingItem == 1 and player:getFreeSlotsCount() == 0 then
            givingItem = 2
        end

        player:updateEvent(baseCS, energyFlag, givingItem, givenItem, 2, 0, 0, 1)

        if givingItem == 1 then
            player:addItem({ id = givenItem, silent = true })
            chocoState.held_item = 0
        end
    end,

    [vmOpCodes.TELL_A_STORY] = function(player, chocoState, option)
        local storyMask = 0xFFFFFFFE

        chocoState = xi.chocoboRaising.onRaisingEventPlayout(player, xi.chocoboRaising.cutscenes.INTERESTED_IN_YOUR_STORY, chocoState)

        player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name, 0, 0, 0, 0, 0, 0, 0)
        player:updateEvent(xi.chocoboRaising.getCutsceneWithOffset(player, xi.chocoboRaising.cutscenes.INTERESTED_IN_YOUR_STORY), 0, storyMask, 0, chocoState.stage, 0, 0, 3)
    end,

    [vmOpCodes.SCOLD_CHOCOBO] = function(player, chocoState, option)
        chocoState = xi.chocoboRaising.onRaisingEventPlayout(player, xi.chocoboRaising.cutscenes.HANGS_HEAD_IN_SHAME, chocoState)

        player:updateEventString(chocoState.first_name, chocoState.last_name, chocoState.first_name, chocoState.last_name, 0, 0, 0, 0, 0, 0, 0)
        player:updateEvent(xi.chocoboRaising.getCutsceneWithOffset(player, xi.chocoboRaising.cutscenes.HANGS_HEAD_IN_SHAME), 0, 0, 0, chocoState.stage, 0, 0, 0)
    end,

    [vmOpCodes.COMPETE_WITH_OTHERS] = function(player, chocoState, option)
        local winner = utils.randomEntry({ 0, 2 })
        if math.random(1, 100) <= 5 then
            winner = 1
        end

        local winnerStr = {
            [0] = 'Player',
            [1] = 'Tie',
            [2] = 'Rival',
        }

        debug('Competition Winner: ' .. winnerStr[winner])
        local rivalsName = 'Hero'

        chocoState = xi.chocoboRaising.onRaisingEventPlayout(player, xi.chocoboRaising.cutscenes.COMPETE_WITH_OTHERS, chocoState)

        player:updateEventString(chocoState.first_name, rivalsName, '', '', 0, 0, 0, 0, 0, 0, 0)
        player:updateEvent(xi.chocoboRaising.getCutsceneWithOffset(player, xi.chocoboRaising.cutscenes.COMPETE_WITH_OTHERS), 0, winner, 0, chocoState.stage, 0, 0, 0)
    end,

    [vmOpCodes.SET_CARE_SCHEDULE_MENU] = function(player, chocoState, option)
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

    [vmOpCodes.SET_BASIC_CARE_PLAN_1] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.SET_BASIC_CARE_PLAN_2] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.SET_BASIC_CARE_PLAN_3] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.SET_BASIC_CARE_PLAN_4] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.UNKNOWN_1056] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.UNKNOWN_1241] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.EVENT_PLAYOUT] = function(player, chocoState, option)
        chocoState = xi.chocoboRaising.handleCSUpdate(player, chocoState, true)
    end,

    [vmOpCodes.BRIEF_REPORT] = function(player, chocoState, option)
    end,

    [vmOpCodes.WHISTLE_GAME_RESULT] = function(player, chocoState, option)
        local keyItem = xi.keyItem.HANDKERCHIEF

        if math.random(1, 100) < 25 then
            player:updateEvent(keyItem, 0, 0, 0, 0, 1, 0, 0)
            player:addKeyItem(keyItem)
            player:setCharVar('HQuest[ChocoboWhistle]Prog', 3)
        else
            player:updateEvent(0, 0, 0, 0, 0, 2, 0, 0)
        end
    end,

    [vmOpCodes.SKIP_REPORT] = function(player, chocoState, option)
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

        while #chocoState.csList > 0 do
            chocoState = xi.chocoboRaising.handleCSUpdate(player, chocoState, false)
        end

        xi.chocoboRaising.updateChocoState(player, chocoState)
    end,

    [vmOpCodes.BUY_CHOCOBO_WHISTLE] = function(player, chocoState, option)
    end,

    [vmOpCodes.RECEIVE_CHOCOBO_WHISTLE] = function(player, chocoState, option)
    end,

    [vmOpCodes.REGISTER_CHOCOBO_WHISTLE] = function(player, chocoState, option)
        debug('Registering field chocobo details')
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)

        local traits = {
            largeBeak   = chocoState.discernment >= 128 and 1 or 0,
            fullTail    = chocoState.endurance >= 128 and 1 or 0,
            largeTalons = chocoState.strength >= 128 and 1 or 0,
        }

        player:registerChocobo(chocoState.color, traits)
    end,

    [vmOpCodes.DEBUG_GO_FORWARD_1_UNIT] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.DEBUG_ABILITIES_PRINT] = function(player, chocoState, option)
        local packedRawStats =
            bit.lshift(chocoState.strength,     0) +
            bit.lshift(chocoState.endurance,    8) +
            bit.lshift(chocoState.discernment, 16) +
            bit.lshift(chocoState.receptivity, 24)

        player:updateEvent(1, packedRawStats, xi.chocoboRaising.packStats2(chocoState), 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.DEBUG_USER_WORK_PRINT] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end,

    [vmOpCodes.GIVE_UP_CHOCOBO] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
        player:deleteRaisedChocobo()
    end,

    [vmOpCodes.RETIRE_YOUR_CHOCOBO] = function(player, chocoState, option)
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
        player:deleteRaisedChocobo()
    end,

    [vmOpCodes.UNKNOWN_24672] = function(player, chocoState, option)
        player:updateEvent(0, 352, 0, 0, chocoState.stage, 0, 0, 0)
    end,
}

xi.chocoboRaising.eventVM = function(player, csid, option, npc)
    local mainCsid   = xi.chocoboRaising.csidTable[player:getZoneID()][2]
    local tradeCsid  = xi.chocoboRaising.csidTable[player:getZoneID()][3]
    local chocoState = xi.chocoboRaising.chocoState[player:getID()]

    if csid == tradeCsid then
        if option == 252 then
            player:updateEvent(0, xi.chocoboRaising.raisingLocation[player:getZoneID()], 0, 0, 0, 0, 0, 0)
        end
    elseif csid == mainCsid then
        if chocoState == nil then
            print('ERROR! onEventUpdateVCSTrainer \'chocoState\' is nil!')
            return
        end

        if bit.band(0x000000FF, option) == 0xFF then
            return handleNamingUpdate(player, chocoState, option)
        end

        if bit.band(0x000000FF, option) == 0xFE then
            return handleCarePlanUpdate(player, chocoState, option)
        end

        local opCodeName = vmOpCodeNames[option] or '?'
        debug(string.format('ChocoVM Op: %i: %s', option, opCodeName))

        local handler = vmHandlers[option]
        if handler then
            handler(player, chocoState, option)
        end
    end
end
