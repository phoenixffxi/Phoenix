-----------------------------------
-- Area: Central Temenos 2nd Floor
--  Mob: Earth Elemental
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
        [1] = { xi.magic.spell.STONE_IV,    target, false, xi.action.type.DAMAGE_TARGET,        nil,                 0, 100 },
        [2] = { xi.magic.spell.STONE_V,     target, false, xi.action.type.DAMAGE_TARGET,        nil,                 0, 100 },
        [3] = { xi.magic.spell.STONEGA_III, target, false, xi.action.type.DAMAGE_TARGET,        nil,                 0, 100 },
        [4] = { xi.magic.spell.QUAKE,       target, false, xi.action.type.DAMAGE_TARGET,        nil,                 0, 100 },
        [5] = { xi.magic.spell.RASP,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.RASP,      0, 100 },
        [6] = { xi.magic.spell.SLOW,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.SLOW,      0, 100 },
        [7] = { xi.magic.spell.ENAERO,      mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.ENSTONE,   0, 100 },
        [8] = { xi.magic.spell.STONESKIN,   mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.STONESKIN, 0, 100 },
    }

    return xi.combat.behavior.chooseAction(mob, target, nil, spellList)
end

entity.onAdditionalEffect = function(mob, target, damage)
    return xi.mob.onAddEffect(mob, target, damage, xi.mob.ae.PETRIFY)
end

entity.onMobDisengage = function(mob)
    mob:setMagicCastingEnabled(false)
end

return entity
