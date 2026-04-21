-----------------------------------
-- Chocobo Raising - Care Plans
-----------------------------------
require('scripts/globals/hobbies/chocobo_raising/constants')
-----------------------------------
xi = xi or {}
xi.chocoboRaising = xi.chocoboRaising or {}

local debug = utils.getDebugPlayerPrinter(xi.settings.main.DEBUG_CHOCOBO_RAISING)

xi.chocoboRaising.handleStatChange = function(stat, value, change, max)
    if change == 0 then
        return value
    end

    if change > 0 then
        debug(string.format('  %s += %i', xi.chocoboRaising.carePlanStatNames[stat], change))
        change = change * xi.settings.main.CHOCOBO_RAISING_STAT_POS_MULTIPLIER
    elseif change < 0 then
        debug(string.format('  %s -= %i', xi.chocoboRaising.carePlanStatNames[stat], -change))
        change = change * xi.settings.main.CHOCOBO_RAISING_STAT_NEG_MULTIPLIER
    end

    -- TODO: Handle Green Racing Silks here for energy?
    -- https://ffxiclopedia.fandom.com/wiki/Green_Race_Silks

    value = utils.clamp(value + change, 0, max)

    return value
end

xi.chocoboRaising.handleCarePlan = function(player, chocoState, carePlan, elapsedDays)
    elapsedDays = elapsedDays or 1

    debug(string.format('Execute Care Plan: %i days', elapsedDays))

    -- Process Care Plan shifting
    local plan1Length = bit.rshift(bit.band(chocoState.care_plan, 0xF0000000), 28)
    local plan1Type   = bit.rshift(bit.band(chocoState.care_plan, 0x0F000000), 24)
    local plan2Length = bit.rshift(bit.band(chocoState.care_plan, 0x00F00000), 20)
    local plan2Type   = bit.rshift(bit.band(chocoState.care_plan, 0x000F0000), 16)
    local plan3Length = bit.rshift(bit.band(chocoState.care_plan, 0x0000F000), 12)
    local plan3Type   = bit.rshift(bit.band(chocoState.care_plan, 0x00000F00),  8)
    local plan4Length = bit.rshift(bit.band(chocoState.care_plan, 0x000000F0),  4)
    local plan4Type   = bit.rshift(bit.band(chocoState.care_plan, 0x0000000F),  0)

    local remainingDays = elapsedDays

    while remainingDays > 0 do
        if plan1Length > 0 then
            local deduct  = math.min(plan1Length, remainingDays)
            plan1Length   = plan1Length - deduct
            remainingDays = remainingDays - deduct
        end

        if plan1Length == 0 then
            -- Shift plans left
            plan1Length = plan2Length
            plan1Type   = plan2Type
            plan2Length = plan3Length
            plan2Type   = plan3Type
            plan3Length = plan4Length
            plan3Type   = plan4Type
            plan4Length = 0
            plan4Type   = 0

            -- After shifting, if a plan slot is 0, it should be set back to 7 days of basic care
            if plan1Length == 0 then
                plan1Length = 7
                plan1Type   = xi.chocoboRaising.carePlans.BASIC_CARE
            end

            if plan2Length == 0 then
                plan2Length = 7
                plan2Type   = xi.chocoboRaising.carePlans.BASIC_CARE
            end

            if plan3Length == 0 then
                plan3Length = 7
                plan3Type   = xi.chocoboRaising.carePlans.BASIC_CARE
            end

            if plan4Length == 0 then
                plan4Length = 7
                plan4Type   = xi.chocoboRaising.carePlans.BASIC_CARE
            end
        end
    end

    -- Ensure all slots are refilled if they are still empty
    if plan1Length == 0 then
        plan1Length = 7
        plan1Type   = xi.chocoboRaising.carePlans.BASIC_CARE
    end

    if plan2Length == 0 then
        plan2Length = 7
        plan2Type   = xi.chocoboRaising.carePlans.BASIC_CARE
    end

    if plan3Length == 0 then
        plan3Length = 7
        plan3Type   = xi.chocoboRaising.carePlans.BASIC_CARE
    end

    if plan4Length == 0 then
        plan4Length = 7
        plan4Type   = xi.chocoboRaising.carePlans.BASIC_CARE
    end

    chocoState.care_plan =
        bit.lshift(plan1Length, 28) + bit.lshift(plan1Type, 24) +
        bit.lshift(plan2Length, 20) + bit.lshift(plan2Type, 16) +
        bit.lshift(plan3Length, 12) + bit.lshift(plan3Type,  8) +
        bit.lshift(plan4Length,  4) + bit.lshift(plan4Type,  0)

    chocoState.strength    = xi.chocoboRaising.handleStatChange(xi.chocoboRaising.carePlanStats.STRENGTH,    chocoState.strength,    xi.chocoboRaising.carePlanData[carePlan][1] * elapsedDays, 255)
    chocoState.endurance   = xi.chocoboRaising.handleStatChange(xi.chocoboRaising.carePlanStats.ENDURANCE,   chocoState.endurance,   xi.chocoboRaising.carePlanData[carePlan][2] * elapsedDays, 255)
    chocoState.discernment = xi.chocoboRaising.handleStatChange(xi.chocoboRaising.carePlanStats.DISCERNMENT, chocoState.discernment, xi.chocoboRaising.carePlanData[carePlan][3] * elapsedDays, 255)
    chocoState.receptivity = xi.chocoboRaising.handleStatChange(xi.chocoboRaising.carePlanStats.RECEPTIVITY, chocoState.receptivity, xi.chocoboRaising.carePlanData[carePlan][4] * elapsedDays, 255)
    chocoState.affection   = xi.chocoboRaising.handleStatChange(xi.chocoboRaising.carePlanStats.AFFECTION,   chocoState.affection,   xi.chocoboRaising.carePlanData[carePlan][5] * elapsedDays, 255)

    -- TODO: Double check this from caps.
    -- After each day the chocobo's energy is refreshed, so only previous day's energy cost is applied
    -- to the chocobo
    chocoState.energy = xi.chocoboRaising.handleStatChange(xi.chocoboRaising.carePlanStats.ENERGY, 100, xi.chocoboRaising.carePlanData[carePlan][6], 100)

    local payment = xi.chocoboRaising.carePlanData[carePlan][7]

    if payment then
        payment = payment * elapsedDays * xi.settings.main.CHOCOBO_RAISING_GIL_MULTIPLIER
        debug(string.format('Care Plan Payment: %d', payment))

        -- TODO: Handle payment using player object
        utils.unused(player)
    end
end
