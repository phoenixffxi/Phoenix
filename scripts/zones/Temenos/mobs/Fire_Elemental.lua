-----------------------------------
-- Area: Central Temenos 2nd Floor
--  Mob: Fire Elemental
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
        [1] = { xi.magic.spell.FIRE_IV,    target, false, xi.action.type.DAMAGE_TARGET,        nil,              0, 100 },
        [2] = { xi.magic.spell.FIRE_V,     target, false, xi.action.type.DAMAGE_TARGET,        nil,              0, 100 },
        [3] = { xi.magic.spell.FIRAGA_III, target, false, xi.action.type.DAMAGE_TARGET,        nil,              0, 100 },
        [4] = { xi.magic.spell.FLARE,      target, false, xi.action.type.DAMAGE_TARGET,        nil,              0, 100 },
        [5] = { xi.magic.spell.BURN,       target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BURN,   0, 100 },
        [6] = { xi.magic.spell.ENFIRE,     mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.ENFIRE, 0, 100 },
    }

    return xi.combat.behavior.chooseAction(mob, target, nil, spellList)
end

entity.onAdditionalEffect = function(mob, target, damage)
    return xi.mob.onAddEffect(mob, target, damage, xi.mob.ae.PLAGUE)
end

entity.onMobDisengage = function(mob)
    mob:setMagicCastingEnabled(false)
end

return entity
