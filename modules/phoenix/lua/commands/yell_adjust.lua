-----------------------------------
-- !yell ban tells the target how long the mute lasts and when it ends.
-- Muted yell attempts are answered in cpp/chat_adjustments.cpp.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('phoenix_yell_adjust')

m:addOverride('xi.commands.yell.onTrigger', function(player, value, target, days)
    local targ = GetPlayerByName(target or '')
    if
        value ~= 'ban' or
        targ == nil
    then
        return super(player, value, target, days)
    end

    -- Stock sets an indefinite mute to expire now, which setCharVar rejects.
    if
        days == nil or
        days < 1
    then
        player:printToPlayer('Invalid duration specified, defaulting to indefinite ban.', xi.msg.channel.SYSTEM_3)
        targ:setCharVar('[YELL]Banned', 1)
        targ:printToPlayer('You have been muted from /yell indefinitely.', xi.msg.channel.SYSTEM_3)
        player:printToPlayer(string.format('%s has been banned from using the /yell command indefinitely.', targ:getName()), xi.msg.channel.SYSTEM_3)
        return
    end

    local expiry = GetSystemTime() + utils.days(days)

    targ:setCharVar('[YELL]Banned', 1, expiry)
    targ:printToPlayer(string.format('You have been muted from /yell for %i day%s. The mute ends %s UTC.', days, days == 1 and '' or 's', os.date('!%Y-%m-%d %H:%M', expiry)), xi.msg.channel.SYSTEM_3)
    player:printToPlayer(string.format('%s has been banned from using the /yell command for %i day%s.', targ:getName(), days, days == 1 and '' or 's'), xi.msg.channel.SYSTEM_3)
end)
