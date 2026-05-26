-----------------------------------
-- Eraser (Pre-2011)
-- Removes up to 3 status effects from the Automaton or its Master based on the number of Light Maneuvers active.
-- Consumes all maneuvers on use.
-- Eraser cannot remove Venom, Death Sentence, Charm or Gradual Petrification.
-- Prioritizes removing effects from the Automaton over the Master.
-- Updated to consume only Light Maneuvers on December 15th, 2011.
-- Updated to consume no maneuvers on March 11th, 2019.
-- https://wiki.ffo.jp/html/5365.html
-----------------------------------
require('modules/module_utils')
-----------------------------------

local m = Module:new('era_eraser')

local maneuvers =
{
    xi.effect.FIRE_MANEUVER,
    xi.effect.ICE_MANEUVER,
    xi.effect.WIND_MANEUVER,
    xi.effect.EARTH_MANEUVER,
    xi.effect.THUNDER_MANEUVER,
    xi.effect.WATER_MANEUVER,
    xi.effect.LIGHT_MANEUVER,
    xi.effect.DARK_MANEUVER,
}

local removables =
{
    -- Songs
    xi.effect.ELEGY,
    xi.effect.REQUIEM,
    xi.effect.THRENODY,

    -- Enfeebling
    xi.effect.BLINDNESS,
    xi.effect.PARALYSIS,
    xi.effect.SILENCE,
    xi.effect.POISON,
    xi.effect.CURSE_I,
    xi.effect.CURSE_II,
    xi.effect.DISEASE,
    xi.effect.PLAGUE,
    xi.effect.WEIGHT,
    xi.effect.BIND,
    xi.effect.ADDLE,
    xi.effect.SLOW,
    xi.effect.PETRIFICATION,

    -- DoTs
    xi.effect.BIO,
    xi.effect.DIA,
    xi.effect.BURN,
    xi.effect.FROST,
    xi.effect.CHOKE,
    xi.effect.RASP,
    xi.effect.SHOCK,
    xi.effect.DROWN,

    -- Main Stat Downs
    xi.effect.STR_DOWN,
    xi.effect.DEX_DOWN,
    xi.effect.VIT_DOWN,
    xi.effect.AGI_DOWN,
    xi.effect.INT_DOWN,
    xi.effect.MND_DOWN,
    xi.effect.CHR_DOWN,

    -- Combat Stat Downs
    xi.effect.ACCURACY_DOWN,
    xi.effect.ATTACK_DOWN,
    xi.effect.EVASION_DOWN,
    xi.effect.DEFENSE_DOWN,

    -- Magic Stat Downs
    xi.effect.MAGIC_ACC_DOWN,
    xi.effect.MAGIC_ATK_DOWN,
    xi.effect.MAGIC_EVASION_DOWN,
    xi.effect.MAGIC_DEF_DOWN,

    -- HP/MP/TP Stat Downs
    xi.effect.MAX_TP_DOWN,
    xi.effect.MAX_MP_DOWN,
    xi.effect.MAX_HP_DOWN,
}

m:addOverride('xi.actions.abilities.pets.automaton.eraser.onAutomatonAbilityCheck', function(target, automaton, skill)
    return 0
end)

m:addOverride('xi.actions.abilities.pets.automaton.eraser.onAutomatonAbility', function(target, automaton, skill, master, action)
    automaton:addRecast(xi.recast.ABILITY, skill:getID(), 30)

    local lightManeuvers = master:countEffect(xi.effect.LIGHT_MANEUVER)
    local effectsRemoved = 0

    for _, effectId in ipairs(removables) do
        if target:hasStatusEffect(effectId) then
            target:delStatusEffectSilent(effectId)
            effectsRemoved = effectsRemoved + 1

            if effectsRemoved >= lightManeuvers then
                break
            end
        end
    end

    for _, maneuverId in ipairs(maneuvers) do
        for _ = 1, master:countEffect(maneuverId) do
            master:delStatusEffectSilent(maneuverId)
        end
    end

    if effectsRemoved > 0 then
        skill:setMsg(xi.msg.basic.DISAPPEAR_NUM)
    else
        skill:setMsg(xi.msg.basic.USES)
    end

    return effectsRemoved
end)

return m
