-----------------------------------
-- Replicator (Pre-2011)
-- Description : Applies Blink based on Wind Maneuvers when HP is below a certain threshold. Cooldown of 1 minute. Consumes all Wind Maneuvers on use.
-- If Automaton has a Damage Gauge equipped, activation threshold is increased to 75% HP.
-- Amount of images increased on December 15th, 2011.
-- Changed from Blink to Copy Image on August 5th, 2015.
-- Changed to not consume Wind Maneuvers on August 6th, 2019.
-- https://wiki.ffo.jp/html/12225.html
-----------------------------------
require('modules/module_utils')
-----------------------------------

local m = Module:new('era_replicator')

local shadowTable =
{
    [1] = 2,
    [2] = 3,
    [3] = 4,
}

m:addOverride('xi.actions.abilities.pets.automaton.replicator.onAutomatonAbilityCheck', function(target, automaton, skill)
    return 0
end)

m:addOverride('xi.actions.abilities.pets.automaton.replicator.onAutomatonAbility', function(target, automaton, skill, master, action)
    local windManeuvers = master:countEffect(xi.effect.WIND_MANEUVER)
    local shadows       = shadowTable[windManeuvers]

    automaton:addRecast(xi.recast.ABILITY, skill:getID(), 60)

    for i = 1, windManeuvers do
        master:delStatusEffectSilent(xi.effect.WIND_MANEUVER)
    end

    if target:addStatusEffect(xi.effect.BLINK, { power = shadows, duration = 300, origin = automaton }) then
        skill:setMsg(xi.msg.basic.SKILL_GAIN_EFFECT)
    else
        skill:setMsg(xi.msg.basic.SKILL_NO_EFFECT)
    end

    return xi.effect.BLINK
end)

return m
