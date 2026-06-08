-----------------------------------
-- PET: Automaton
-----------------------------------
xi = xi or {}
xi.pets = xi.pets or {}
xi.pets.automaton = {}

xi.pets.automaton.frameMods =
{
    -----------------------------------
    -- Harlequin
    -----------------------------------
    [xi.automaton.frame.HARLEQUIN] =
    {
        mods =
        {
            { xi.mod.DMG,              -625 },
        },
    },

    -----------------------------------
    -- Valoredge
    -----------------------------------
    [xi.automaton.frame.VALOREDGE] =
    {
        mobMods =
        {
            { xi.mobMod.CAN_SHIELD_BLOCK, 1 },
        },

        mods =
        {
            { xi.mod.SHIELDBLOCKRATE,    45 },
            { xi.mod.DMG,             -1250 },
        },
    },

    -----------------------------------
    -- Sharpshot
    -----------------------------------
    [xi.automaton.frame.SHARPSHOT] =
    {
        mods =
        {
            { xi.mod.PIERCE_SDT,       8750 },
            { xi.mod.DMGBREATH,       -1250 },
            { xi.mod.DMGMAGIC,        -1250 },
        },
    },

    -----------------------------------
    -- Stormwaker
    -----------------------------------
    [xi.automaton.frame.STORMWAKER] =
    {
        mods =
        {
            { xi.mod.DMGBREATH,       -2500 },
            { xi.mod.DMGMAGIC,        -2500 },
        },
    },
}

local function applyAutomatonFrameMods(mob)
    local frameEquipped = mob:getAutomatonFrame()
    local frameData     = xi.pets.automaton.frameMods[frameEquipped]

    if not frameData then
        return
    end

    for _, mobModData in ipairs(frameData.mobMods or {}) do
        mob:setMobMod(mobModData[1], mobModData[2])
    end

    for _, modData in ipairs(frameData.mods or {}) do
        mob:setMod(modData[1], modData[2])
    end
end

xi.pets.automaton.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.CAN_PARRY, 1)
    applyAutomatonFrameMods(mob)

    mob:setLocalVar('MANEUVER_DURATION', 60)

    mob:addListener('EFFECTS_TICK', 'MANEUVER_DURATION', function(automaton)
        if automaton:getTarget() then
            local maneuverDuration = automaton:getLocalVar('MANEUVER_DURATION')
            automaton:setLocalVar('MANEUVER_DURATION', math.min(maneuverDuration + 3, 300))
        end
    end)

    -- All Automaton Attachments have their cooldowns applied on spawn.
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.BARRAGE_TURBINE, 180)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.DISRUPTOR,        60)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.ECONOMIZER,       60)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.ERASER,           30)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.FLASHBULB,        45)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.HEAT_CAPACITOR,   90)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.MANA_CONVERTER,  180)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.PROVOKE,          30)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.REACTIVE_SHIELD,  60)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.REGULATOR,        60)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.REPLICATOR,       60)
    mob:addRecast(xi.recast.ABILITY, xi.automaton.abilities.SHOCK_ABSORBER,  180)
end

xi.pets.automaton.onMobDeath = function(mob)
    mob:removeListener('MANEUVER_DURATION')
end
