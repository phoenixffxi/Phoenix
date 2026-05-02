-----------------------------------
-- 75 Dynamis: Player lockout
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- Returns seconds remaining until lockout expires, or 0 if not locked out
-- Pass returnDays = true to get Vanadiel days instead (for display purposes)
xi.dynamis.isPlayerLockedOut = function(player, returnDays)
    local lockout = player:getCharVar('[DYNA]lockout')
    if lockout == 0 then
        return 0
    end

    local secondsRemaining = lockout - GetSystemTime()
    if secondsRemaining <= 0 then
        return 0
    end

    if returnDays then
        return math.ceil(secondsRemaining / 3456)
    end

    return secondsRemaining
end

xi.dynamis.recordLockout = function(player)
    local lockoutInHours = 72
    local expiry = GetSystemTime() + (lockoutInHours * 60 * 60)
    player:setCharVar('[DYNA]lockout', expiry, expiry)
end
