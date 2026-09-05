-----------------------------------
-- Area: Apollyon NE, Floor 2
--  Mob: Bialozar (Boss)
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setBaseSpeed(60)
    mob:setMod(xi.mod.STORETP, 90)
    mob:setMod(xi.mod.DOUBLE_ATTACK, 100)
    mob:setMobMod(xi.mobMod.DETECTION, xi.detects.HEARING)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
    mob:setMobMod(xi.mobMod.MAGIC_COOL, 31)
end

entity.onMobSpellChoose = function(mob, target, spellId)
    local spellList =
    {
        [1] = { xi.magic.spell.HORDE_LULLABY,  target, false, xi.action.type.ENFEEBLING_TARGET, xi.effect.SLEEP_I, 1, 100 },
        [2] = { xi.magic.spell.MASSACRE_ELEGY, target, false, xi.action.type.ENFEEBLING_TARGET, xi.effect.ELEGY,   0, 100 },
        [3] = { xi.magic.spell.MAGIC_FINALE,   target, false, xi.action.type.DAMAGE_TARGET,     nil,               0,  50 },
    }

    return xi.combat.behavior.chooseAction(mob, target, nil, spellList)
end

return entity
