-----------------------------------
-- Chocobo Raising
-----------------------------------
require('scripts/globals/hobbies/chocobo_raising/constants')
-----------------------------------
xi = xi or {}
xi.chocoboRaising = xi.chocoboRaising or {}

local debug = utils.getDebugPlayerPrinter(xi.settings.main.DEBUG_CHOCOBO_RAISING)

-- TODO: There's a lot of logic in here about reporting, should we move this into it's own file?
xi.chocoboRaising.initChocoState = function(player)
    local chocoState = player:getChocoboRaisingInfo()
    if not chocoState then
        return chocoState
    end

    -- Generate data that doesn't need to be persisted to the db
    -- but is needed at runtime

    -- Work out ranks, age, and stages from raw information

    -- Age is worked out alongside 'the day you handed in your egg'
    -- So on the 0th day, the chocobo is 1 day old.

    chocoState.age = math.floor((GetSystemTime() - chocoState.created) / xi.chocoboRaising.dayLength) + 1

    debug('chocoState.age = ' .. chocoState.age)
    debug('chocoState.last_update_age = ' .. chocoState.last_update_age)

    -- Add helpers and empty tables to navigate CSs
    chocoState.csList        = {}
    chocoState.foodGiven     = {}
    chocoState.report        = {}
    chocoState.report.events = {}

    -- Step 1: Determine if enough time has passed to show a report (n > 0 day)

    -- No need to generate a report, bail out!
    if chocoState.age - chocoState.last_update_age <= 0 then
        chocoState.last_update_age = chocoState.age

        return chocoState
    end

    chocoState.report.day_start = chocoState.last_update_age
    chocoState.report.day_end   = chocoState.age

    local reportLength = chocoState.report.day_end - chocoState.report.day_start
    debug('Report length:', reportLength)

    chocoState.last_update_age = chocoState.age

    -- Step 2: Build a table of every event that happened on every day
    -- Example: If the reporting period is Day1-Day10, the table will
    -- contain _at least_ 10 entries - one for every day, plus others.
    -- TODO: Each event needs to know the age and stage of the chocobo at that day
    local events = {}

    local plan1Length = bit.rshift(bit.band(chocoState.care_plan, 0xF0000000), 28)
    local plan1Type   = bit.rshift(bit.band(chocoState.care_plan, 0x0F000000), 24)
    local plan2Length = bit.rshift(bit.band(chocoState.care_plan, 0x00F00000), 20)
    local plan2Type   = bit.rshift(bit.band(chocoState.care_plan, 0x000F0000), 16)
    local plan3Length = bit.rshift(bit.band(chocoState.care_plan, 0x0000F000), 12)
    local plan3Type   = bit.rshift(bit.band(chocoState.care_plan, 0x00000F00),  8)
    local plan4Length = bit.rshift(bit.band(chocoState.care_plan, 0x000000F0),  4)
    local plan4Type   = bit.rshift(bit.band(chocoState.care_plan, 0x0000000F),  0)

    local possibleCarePlanFuture = {}

    for _ = 1, plan1Length do
        table.insert(possibleCarePlanFuture, plan1Type)
    end

    for _ = 1, plan2Length do
        table.insert(possibleCarePlanFuture, plan2Type)
    end

    for _ = 1, plan3Length do
        table.insert(possibleCarePlanFuture, plan3Type)
    end

    for _ = 1, plan4Length do
        table.insert(possibleCarePlanFuture, plan4Type)
    end

    -- NOTE: To aid with tracking and playback, we have to keep a variable to track this quest,
    --     : rather than the actual KI checks.
    local whiteHandkerchiefStarted   = false
    local whiteHandkerchiefCancelled = false
    local whiteHandkerchiefFinished  = false

    local chocoboWhistleQuestBegan = player:getCharVar('HQuest[ChocoboWhistle]Prog') > 0

    for idx = 1, reportLength do
        local possibleCarePlanEvent = possibleCarePlanFuture[idx]

        if possibleCarePlanEvent == nil then -- We went past the end of the care plan
            possibleCarePlanEvent = xi.chocoboRaising.carePlans.BASIC_CARE
        end

        local age          = chocoState.report.day_start + idx - 1
        local currentStage = xi.chocoboRaising.ageToStage(age)
        local event        = { age, { possibleCarePlanEvent } }

        table.insert(events, event)

        -- If the chocobo doesn't have any conditions, roll to see if they get one
        if not xi.chocoboRaising.hasCondition(chocoState) then
            for _, condition in ipairs(xi.chocoboRaising.conditions) do
                -- TODO: Use stats and history instead of pure chance to see what
                --     : conditions might happen
                if math.random(1, 100) <= 5 then
                    xi.chocoboRaising.setCondition(chocoState, condition, true)
                    break
                end
            end
        end

        -- For each condition, if chocobo has that condition, play
        -- out relevant CS.
        for _, condition in ipairs(xi.chocoboRaising.conditions) do
            if xi.chocoboRaising.getCondition(chocoState, condition) then
                -- TODO: Mark that we've played this CS today so we don't immediately resolve it
                utils.unused()
            end
        end

        -- TODO: For each condition that the chocobo has, if they haven't JUST
        --     : had the CS play for it, roll 50% to see if it resolved on its own.

        -- Handle age-up cs's
        for _, entry in ipairs(xi.chocoboRaising.ageBoundaries) do
            if currentStage == entry[1] and age >= entry[2] then
                table.insert(events, { age, { entry[3] } })
            end
        end

        --
        -- Quest conditions
        --

        -- TODO: Come up with a more modular way to track these

        -- Start White Handkerchief quest
        -- TODO: Extract out the ages and timings for this into settings?
        if
            not whiteHandkerchiefStarted and
            not player:hasKeyItem(xi.keyItem.WHITE_HANDKERCHIEF) and
            age == 7 and
            not chocoboWhistleQuestBegan
        then
            debug('Starting White Handkerchief quest')
            table.insert(events, { age, { xi.chocoboRaising.cutscenes.CRYING_AT_NIGHT } })
            whiteHandkerchiefStarted = true
        end

        -- Cancel White Handkerchief quest
        -- NOTE: If we've played all the way out here, it'll then not be possible to complete
        --     : this quest until the next chocobo.
        if
            whiteHandkerchiefStarted and
            not whiteHandkerchiefCancelled and
            age == 15 and
            reportLength >= 7
        then
            debug('Cancelling White Handkerchief quest')
            table.insert(events, { age, { xi.chocoboRaising.cutscenes.HAVENT_SEEN_YOU } })
            whiteHandkerchiefCancelled = true
            -- TODO: Mark this on the chocobo permanently, we'll need to know this event happened
            --     : when we do the chocobo whistle quest
        end

        -- End White Handkerchief quest
        -- NOTE: It isn't possible to fly through and complete this in one go in retail, so the KI
        --     : check ensures you have to finish talking to the trainer, pass some time, and then
        --     : come back
        -- TODO: Need to zone too?
        -- TODO: Does this play out as part of the report, or before it?
        if
            not whiteHandkerchiefStarted and
            not whiteHandkerchiefCancelled and
            not whiteHandkerchiefFinished and
            age >= 8 and -- At least one day has to have passed, so this is the earliest possible age
            player:hasKeyItem(xi.keyItem.WHITE_HANDKERCHIEF)
        then
            debug('Ending White Handkerchief quest')
            table.insert(events, { age, { xi.chocoboRaising.cutscenes.THAT_SHOULD_BE_ENOUGH } })
            whiteHandkerchiefFinished = true
        end
    end

    -- Step 3: Condense that table down
    -- Step 4: Assign this report to the cache
    chocoState.report.events = xi.chocoboRaising.condenseEvents(events)

    return chocoState
end

xi.chocoboRaising.updateChocoState = function(player, chocoState)
    -- Update age and last_update_age
    chocoState.age             = math.floor((GetSystemTime() - chocoState.created) / xi.chocoboRaising.dayLength) + 1
    chocoState.last_update_age = chocoState.age

    debug(string.format('Writing chocoState to cache and db. age: %d, last_update_age: %d', chocoState.age, chocoState.last_update_age))

    -- Write to cache
    xi.chocoboRaising.chocoState[player:getID()] = chocoState

    -- Write to db
    player:setChocoboRaisingInfo(chocoState)

    return chocoState
end

xi.chocoboRaising.newChocobo = function(player, egg)
    local newChoco = {}

    -- TODO: If egg exdata is empty (historic objects, etc.) then generate it randomly now.
    --     : Otherwise, extract the exdata for use.
    -- local exData = egg:getExData();

    --[[
        https://github.com/Ivaar/Windower-addons/blob/master/chococard/chococard.lua

        plan        = {[0]='A','B','C','D'},
        gender      = {[0]='Male','Female'},
        color       = {[0]='Yellow','Black','Blue','Red','Green'},
        ability     = {[0]='None','Gallop','Canter','Burrow','Bore','Auto-Regen','Treasure Finder'},

        fields.egg = {
            DNA         = {'b3b3b3', 0x00+1,        fn=map_fields+{'color'}},
            ability     = {'b4',     0x01+1, 1+1},
            unknown1    = {'b1',     0x01+1, 5+1},
            plan        = {'b2',     0x01+1, 6+1},
            unknown2    = {'b15',    0x02+1},
            is_bred     = {'q',      0x03+1, 7+1},
        }

        Egg exData from Dabih Jajalioh (CHOCOBO_EGG_FAINTLY_WARM: 2312):
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

        Egg exData from breeder:(CHOCOBO_EGG_A_BIT_WARM: 2317)

        8C C0 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

        8C: 1000 1100
        C0: 1100 0000
        00: 0000 0000
        80: 1000 0000

        Plan: D
        DNA: [Green, Black, Blue]
        Ability: None
    ]]

    newChoco.first_name      = 'Chocobo'
    newChoco.last_name       = 'Chocobo'
    newChoco.sex             = math.ceil(math.random() - 0.5) -- Random 0 or 1
    newChoco.created         = GetSystemTime()
    newChoco.age             = 0
    newChoco.last_update_age = 1
    newChoco.stage           = xi.chocoboRaising.stage.EGG
    newChoco.location        = xi.chocoboRaising.raisingLocation[player:getZoneID()]

    -- TODO: Random genes, or take from egg
    newChoco.dominant_gene  = 0 -- TODO
    newChoco.recessive_gene = 0 -- TODO

    -- TODO: Pick various stats based on genetics
    newChoco.color              = xi.chocoboRaising.color.YELLOW
    newChoco.strength           = 0
    newChoco.endurance          = 0
    newChoco.discernment        = 0
    newChoco.receptivity        = 0
    newChoco.affection          = 255
    newChoco.energy             = 100
    newChoco.satisfaction       = 0
    newChoco.conditions         = 0
    newChoco.ability1           = 0
    newChoco.ability2           = 0
    newChoco.personality        = 0
    newChoco.weather_preference = 0
    newChoco.hunger             = 0

    -- NOTE: We store the care plans in-order as 4x 8-bit values:
    -- The first 4 bits are the length of the plan
    -- The last 4 bits are the type of the plan
    local defaultCarePlan = bit.lshift(7, 4) + 0
    newChoco.care_plan =
        bit.lshift(defaultCarePlan, 24) +
        bit.lshift(defaultCarePlan, 16) +
        bit.lshift(defaultCarePlan,  8) +
        bit.lshift(defaultCarePlan,  0)

    newChoco.held_item = 0

    return newChoco
end
