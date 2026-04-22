-----------------------------------
-- Area: Apollyon NW
--  NPC: Armoury Crate Mimic
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:setMod(xi.mod.SLASH_SDT, -5000)
    mob:setMod(xi.mod.PIERCE_SDT, -5000)
    mob:setMod(xi.mod.IMPACT_SDT, -5000)
    mob:setMod(xi.mod.HTH_SDT, -5000)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.NO_MOVE, 1)
    mob:setMobMod(xi.mobMod.NO_DESPAWN, 1)
    mob:setMobMod(xi.mobMod.NO_AGGRO, 1)
    mob:setMod(xi.mod.MDEF, 50)
end

entity.onMobFight = function(mob, target)
    -- Ignore pets, redirect to master
    if target:isPet() then
        local master = target:getMaster()

        if master and master:isAlive() then
            mob:resetEnmity(target)
            mob:updateEnmity(master)

            return
        end
    end

    local distance = mob:checkDistance(target)
    local drawInTable =
    {
        conditions =
        {
            distance >= mob:getMeleeRange(target) and distance <= 20,
        },
        position = mob:getPos(),
    }
    utils.drawIn(target, drawInTable)
end

return entity
