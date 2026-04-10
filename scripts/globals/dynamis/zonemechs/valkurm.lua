-- Dynamis Valkurm Mob Information and Mechanics
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

xi.dynamis.flyCheck = function(zone)
    -- Use a var just in case GM intervention
    if zone:getLocalVar('SJUnlocked') == 1 then
        return
    end

    local nightmareFlies =
    {
        xi.valk.mobs.NIGHTMARE_FLY_1,
        xi.valk.mobs.NIGHTMARE_FLY_2,
        xi.valk.mobs.NIGHTMARE_FLY_3,
    }

    -- Check if Nightmare Flies are still up
    -- If they any are still alive early return
    for _, flyId in ipairs(nightmareFlies) do
        local fly = GetMobByID(flyId)
        if fly and not fly:isDead() then
            return
        end
    end

    local playersInZone = zone:getPlayers()
    for _, playerEntity in pairs(playersInZone) do
        if playerEntity:hasStatusEffect(xi.effect.SJ_RESTRICTION) then
            playerEntity:delStatusEffect(xi.effect.SJ_RESTRICTION)
        end
    end

    zone:setLocalVar('SJUnlocked', 1)
end
