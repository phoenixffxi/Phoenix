-----------------------------------
-- Area: Apollyon NE, Floor 3
--  Mob: Apollyon Cleaner
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
    mob:setMobMod(xi.mobMod.MAGIC_COOL, 17)
end

entity.onMobSpellChoose = function(mob, target, spellId)
    local spellList =
    {
        [ 1] = { xi.magic.spell.FIRE_IV,      target, false, xi.action.type.DAMAGE_TARGET,        nil,                    0, 100 },
        [ 2] = { xi.magic.spell.BLIZZARD_IV,  target, false, xi.action.type.DAMAGE_TARGET,        nil,                    0, 100 },
        [ 3] = { xi.magic.spell.AERO_IV,      target, false, xi.action.type.DAMAGE_TARGET,        nil,                    0, 100 },
        [ 4] = { xi.magic.spell.THUNDER_IV,   target, false, xi.action.type.DAMAGE_TARGET,        nil,                    0, 100 },
        [ 5] = { xi.magic.spell.WATER_IV,     target, false, xi.action.type.DAMAGE_TARGET,        nil,                    0, 100 },
        [ 6] = { xi.magic.spell.FIRAGA_III,   target, false, xi.action.type.DAMAGE_TARGET,        nil,                    0, 100 },
        [ 7] = { xi.magic.spell.THUNDAGA_III, target, false, xi.action.type.DAMAGE_TARGET,        nil,                    0, 100 },
        [ 8] = { xi.magic.spell.FLARE,        target, false, xi.action.type.DAMAGE_TARGET,        nil,                    0, 100 },
        [ 9] = { xi.magic.spell.DRAIN,        target, false, xi.action.type.DRAIN_HP,             nil,                    0, 100 },
        [10] = { xi.magic.spell.ASPIR,        target, false, xi.action.type.DRAIN_MP,             nil,                    0, 100 },
        [11] = { xi.magic.spell.BIO_II,       target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BIO,          2, 100 },
        [12] = { xi.magic.spell.POISONGA_II,  target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.POISON,       0, 100 },
        [13] = { xi.magic.spell.BURN,         target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BURN,         0, 100 },
        [14] = { xi.magic.spell.FROST,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.FROST,        0, 100 },
        [15] = { xi.magic.spell.CHOKE,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.CHOKE,        0, 100 },
        [16] = { xi.magic.spell.DROWN,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.DROWN,        0, 100 },
        [17] = { xi.magic.spell.BLIND,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BLINDNESS,    0, 100 },
        [18] = { xi.magic.spell.BIND,         target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BIND,         0, 100 },
        [19] = { xi.magic.spell.SLEEP,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.SLEEP_I,      1, 100 },
        [20] = { xi.magic.spell.SLEEP_II,     target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.SLEEP_I,      2, 100 },
        [21] = { xi.magic.spell.BLAZE_SPIKES, mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.BLAZE_SPIKES, 0, 100 },
    }

    return xi.combat.behavior.chooseAction(mob, target, nil, spellList)
end

return entity
