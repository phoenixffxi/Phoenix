-----------------------------------
-- Area: Temenos E T
--  Mob: Light Elemental
-----------------------------------
local ID = zones[xi.zone.TEMENOS]
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
end

entity.onMobSpawn = function(mob)
    mob:setMagicCastingEnabled(false)
end

entity.onMobEngage = function(mob, target)
    mob:setMagicCastingEnabled(true)

    local mobID = mob:getID()
    if mobID == ID.mob.TEMENOS_C_MOB[2] + 1 then
        GetMobByID(ID.mob.TEMENOS_C_MOB[2] + 2):updateEnmity(target)
        GetMobByID(ID.mob.TEMENOS_C_MOB[2]):updateEnmity(target)
    elseif mobID == ID.mob.TEMENOS_C_MOB[2] + 2 then
        GetMobByID(ID.mob.TEMENOS_C_MOB[2] + 1):updateEnmity(target)
        GetMobByID(ID.mob.TEMENOS_C_MOB[2]):updateEnmity(target)
    end
end

entity.onMobDisengage = function(mob)
    mob:setMagicCastingEnabled(false)
end

entity.onMobDeath = function(mob, player, optParams)
    if optParams.isKiller or optParams.noKiller then
        switch (mob:getID()): caseof
        {
            [ID.mob.TEMENOS_C_MOB[2] + 1] = function()
                if
                    GetMobByID(ID.mob.TEMENOS_C_MOB[2]):isDead() and
                    GetMobByID(ID.mob.TEMENOS_C_MOB[2] + 2):isDead()
                then
                    GetNPCByID(ID.npc.TEMENOS_C_CRATE[2]):setStatus(xi.status.NORMAL)
                end
            end,

            [ID.mob.TEMENOS_C_MOB[2] + 2] = function()
                if
                    GetMobByID(ID.mob.TEMENOS_C_MOB[2]):isDead() and
                    GetMobByID(ID.mob.TEMENOS_C_MOB[2] + 1):isDead()
                then
                    GetNPCByID(ID.npc.TEMENOS_C_CRATE[2]):setStatus(xi.status.NORMAL)
                end
            end,
        }
    end
end

return entity
