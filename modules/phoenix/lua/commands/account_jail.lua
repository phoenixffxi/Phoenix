-----------------------------------
-- func: jailaccount <player> (cell) (reason)
-- desc: Runs !jail on every played character on the player's account.
-----------------------------------
-- func: pardonaccount <player>
-- desc: Runs !pardon on every played character on the player's account.
-----------------------------------
-- !pardon also releases offline characters, so an account's alts can be pardoned without logging each in.
-- Never-played characters have no home point yet, so a pardon would send them to zone 0.
-- Loads before gm_command_tiers.lua so the tier check wraps the offline pardon too.
-----------------------------------
-- luacheck: globals GetAccountCharacters PardonOffline
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('phoenix_account_jail')

local function error(player, msg, usage)
    player:printToPlayer(msg)
    player:printToPlayer(usage)
end

m:addOverride('xi.commands.pardon.onTrigger', function(player, target)
    local charId = GetPlayerIDByName(target or '')
    if
        charId == 0 or
        GetPlayerByName(target) ~= nil
    then
        return super(player, target)
    end

    if PlayerHasValidSession(charId) then
        player:printToPlayer(string.format('Player \'%s\' is online but in a different zone group (cluster). Go to that zone group to use !pardon', target))
        return
    end

    if GetCharVar(charId, 'inJail') == 0 then
        return
    end

    if not PardonOffline(charId) then
        player:printToPlayer(string.format('%s has never played and has no home point, skipping.', target))
        return
    end

    local message = string.format('%s pardoned %s (offline) from jail.', player:getName(), target)
    player:printToPlayer(message)
    printf(message)
end)

---@type TCommand
local jailAccount = {}

jailAccount.cmdprops =
{
    permission = 2,
    parameters = 'sis'
}

jailAccount.onTrigger = function(player, target, cellId, reason)
    local characters = GetAccountCharacters(target or '')
    if #characters == 0 then
        error(player, string.format('Invalid player \'%s\' given.', tostring(target)), '!jailaccount <player> (cell) (reason)')
        return
    end

    local names    = {}
    local unplayed = {}
    for _, character in ipairs(characters) do
        if character.played then
            table.insert(names, character.name)
        else
            table.insert(unplayed, character.name)
        end
    end

    if #unplayed > 0 then
        player:printToPlayer(string.format('Skipping %i never-played characters: %s', #unplayed, table.concat(unplayed, ', ')))
    end

    player:printToPlayer(string.format('Jailing %i characters on %s\'s account: %s', #names, target, table.concat(names, ', ')))
    for _, name in ipairs(names) do
        xi.commands.jail.onTrigger(player, name, cellId, reason)
    end
end

---@type TCommand
local pardonAccount = {}

pardonAccount.cmdprops =
{
    permission = 2,
    parameters = 's'
}

pardonAccount.onTrigger = function(player, target)
    local characters = GetAccountCharacters(target or '')
    if #characters == 0 then
        error(player, string.format('Invalid player \'%s\' given.', tostring(target)), '!pardonaccount <player>')
        return
    end

    local names    = {}
    local unplayed = {}
    for _, character in ipairs(characters) do
        if character.played then
            table.insert(names, character.name)
        else
            table.insert(unplayed, character.name)
        end
    end

    if #unplayed > 0 then
        player:printToPlayer(string.format('Skipping %i never-played characters: %s', #unplayed, table.concat(unplayed, ', ')))
    end

    player:printToPlayer(string.format('Pardoning %i characters on %s\'s account: %s', #names, target, table.concat(names, ', ')))
    for _, name in ipairs(names) do
        xi.commands.pardon.onTrigger(player, name)
    end
end

xi.module.registerCommand('jailaccount', jailAccount)
xi.module.registerCommand('pardonaccount', pardonAccount)
