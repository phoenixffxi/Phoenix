---@type TMobEntity
local entity = {}
-----------------------------------
local ID = zones[xi.zone.MINE_SHAFT_2716]
-----------------------------------

entity.onMobDeath = function(mob, player, optParams)
    if optParams.isKiller or optParams.noKiller then
        local moblinFantoccini = GetMobByID(mob:getID() - 2)
        if moblinFantoccini and moblinFantoccini:isAlive() then
            moblinFantoccini:messageText(moblinFantoccini, ID.text.HO_HO + 8) -- No-no, no-no! Papa bought me that, you know!
            mob:timer(1000, function(mobArg)
                moblinFantoccini:messageText(moblinFantoccini, ID.text.HO_HO + 9) -- No-no, no-no! Not how it's 'sposed to go!
                DespawnMob(mob:getID() - 2)
            end)
        end
    end
end

return entity
