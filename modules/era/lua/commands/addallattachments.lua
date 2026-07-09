-----------------------------------
-- !addallattachments
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('era_addallattachments')

-- Restricts !addallattachments to heads, frames, and attachments released before June 2010 : https://wiki.ffo.jp/html/5367.html
local eraAttachments =
{
    8193, 8194, 8195, 8196, 8197, 8198, 8224, 8225, 8226, 8227, -- Heads and Frames
    8449, 8450, 8451, 8452, 8453, 8454, 8455,                   -- Fire
    8481, 8482, 8483, 8484, 8485, 8486, 8487,                   -- Ice
    8513, 8514, 8515, 8516, 8517, 8518, 8519,                   -- Wind
    8545, 8546, 8547, 8548, 8549, 8550, 8551,                   -- Earth
    8577, 8578, 8579, 8580, 8581, 8582, 8583,                   -- Thunder
    8609, 8610, 8611, 8612, 8613, 8614, 8615,                   -- Water
    8641, 8642, 8643, 8644, 8645, 8646,                         -- Light
    8673, 8674, 8675, 8676, 8677, 8678,                         -- Dark
}

local function addAllAttachments(player)
    for i = 1, #eraAttachments do
        player:unlockAttachment(eraAttachments[i])
    end

    player:printToPlayer(string.format('%s now has all attachments.', player:getName()))
end

m:addOverride('xi.commands.addallattachments.onTrigger', function(player, target)
    if target == nil then
        addAllAttachments(player)
    else
        local targ = GetPlayerByName(target)
        if targ == nil then
            player:printToPlayer(string.format('Player named "%s" not found!', target))
        else
            addAllAttachments(targ)
        end
    end
end)

return m
