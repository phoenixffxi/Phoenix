-----------------------------------
-- Area: Central Temenos 2nd Floor
--  Mob: Air Elemental
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.ADD_EFFECT, 1)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
    mob:setMagicCastingEnabled(false)
    mob:setMod(xi.mod.DESPAWN_TIME_REDUCTION, 0)
end

entity.onMobEngage = function(mob, target)
    mob:setMagicCastingEnabled(true)
end

entity.onMobSpellChoose = function(mob, target, spellId)
    local spellList =
    {
        [1] = { xi.magic.spell.AERO_IV,    target, false, xi.action.type.DAMAGE_TARGET,        nil,               0, 100 },
        [2] = { xi.magic.spell.AERO_V,     target, false, xi.action.type.DAMAGE_TARGET,        nil,               0, 100 },
        [3] = { xi.magic.spell.AEROGA_III, target, false, xi.action.type.DAMAGE_TARGET,        nil,               0, 100 },
        [4] = { xi.magic.spell.TORNADO,    target, false, xi.action.type.DAMAGE_TARGET,        nil,               0, 100 },
        [5] = { xi.magic.spell.CHOKE,      target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.CHOKE,   0, 100 },
        [6] = { xi.magic.spell.SILENCE,    target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.SILENCE, 0, 100 },
        [7] = { xi.magic.spell.GRAVITY,    target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.WEIGHT,  0, 100 },
        [8] = { xi.magic.spell.ENAERO,     mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.ENAERO,  0, 100 },
        [9] = { xi.magic.spell.BLINK,      mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.BLINK,   0, 100 },
    }

    return xi.combat.behavior.chooseAction(mob, target, nil, spellList)
end

entity.onAdditionalEffect = function(mob, target, damage)
    return xi.mob.onAddEffect(mob, target, damage, xi.mob.ae.SILENCE)
end

entity.onMobDisengage = function(mob)
    mob:setMagicCastingEnabled(false)
end

return entity
