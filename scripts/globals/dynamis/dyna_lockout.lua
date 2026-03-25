-----------------------------------
-- 75 Dynamis: Player lockout
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

xi.dynamis.isPlayerLockedOut = function(player)
    local lockout = player:getCharVar('[DYNA]lockout')
    if lockout == 0 then
        return 0
    end

    return math.floor((lockout - GetSystemTime()) / 3456) -- Vanadiel days
end

xi.dynamis.recordLockout = function(player)
    local lockoutInHours = 71
    local expiry = GetSystemTime() + (lockoutInHours * 60 * 60)
    player:setCharVar('[DYNA]lockout', expiry, expiry)
end
