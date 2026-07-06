-----------------------------------
-- Area: Central Temenos 2nd Floor
--  Mob: Ice Elemental
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
        [1] = { xi.magic.spell.BLIZZARD_IV,  target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [2] = { xi.magic.spell.BLIZZARD_V,   target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [3] = { xi.magic.spell.BLIZZAGA_III, target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [4] = { xi.magic.spell.FREEZE,       target, false, xi.action.type.DAMAGE_TARGET,        nil,                  0, 100 },
        [5] = { xi.magic.spell.FROST,        target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.FROST,      0, 100 },
        [6] = { xi.magic.spell.BIND,         target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.BIND,       0, 100 },
        [7] = { xi.magic.spell.PARALYZE,     target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.PARALYSIS,  0, 100 },
        [8] = { xi.magic.spell.ENBLIZZARD,   mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.ENBLIZZARD, 0, 100 },
        [9] = { xi.magic.spell.ICE_SPIKES,   mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.ICE_SPIKES, 0, 100 },
    }

    return xi.combat.behavior.chooseAction(mob, target, nil, spellList)
end

entity.onAdditionalEffect = function(mob, target, damage)
    local pTable =
    {
        chance   = 25,
        effectId = xi.effect.PARALYSIS,
        power    = 20,
        duration = 30,
    }

    return xi.combat.action.executeAddEffectEnfeeblement(mob, target, pTable)
end

entity.onMobDisengage = function(mob)
    mob:setMagicCastingEnabled(false)
end

return entity
