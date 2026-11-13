-----------------------------------
-- Shared checks for module tests (scripts/tests/modules).
-- The server clears xi.module.registry after loading each module file, so these read the
-- module source and inspect the live functions instead.
-----------------------------------
local moduleTest = {}

-- A quoted name after an opening bracket; \39 and \34 are the two quote characters.
local quotedName = '%s*%(%s*[\39\34]([^\39\34]+)[\39\34]'

local function readSource(path)
    local file = io.open(path, 'r')
    assert(file, string.format('%s is missing', path))
    io.close(file)

    local lines = {}
    for line in io.lines(path) do
        table.insert(lines, line)
    end

    local source = table.concat(lines, '\n')

    -- A commented-out override is not expected to apply.
    source = source:gsub('%-%-%[(=*)%[.-%]%1%]', '')
    source = source:gsub('%-%-[^\n]*', '')

    return source
end

local function sourcePath(fn)
    local info = debug.getinfo(fn, 'S')
    local path = info.source:gsub('^@', ''):gsub('^%./', '')

    return path, info.what
end

-- applyOverride gives each override an env holding the function it replaced as super.
local function overrideChain(fn)
    local links = {}
    while type(fn) == 'function' and #links < 512 do
        table.insert(links, fn)
        local env = getfenv(fn)
        fn = type(env) == 'table' and rawget(env, 'super') or nil
    end

    return links
end

-- The link path installed, or nil. Ignores case: a Windows checkout folds folders that differ
-- only in case (Quests/ and quests/).
local function linkFrom(links, path)
    for _, link in ipairs(links) do
        if string.lower(sourcePath(link)) == string.lower(path) then
            return link
        end
    end
end

local function resolve(target)
    local node = _G
    for part in target:gmatch('[^%.]+') do
        if type(node) ~= 'table' then
            return nil
        end

        node = node[part]
    end

    return node
end

local loadedZones = {}

-- Zone, NPC and mob overrides apply when the zone's scripts load, which a player entering does.
local function loadZoneFor(target)
    local zoneName = target:match('^xi%.zones%.([^%.]+)%.')
    if
        zoneName == nil or
        loadedZones[zoneName]
    then
        return
    end

    -- Script folders use '-' where the enum uses '_' (Dynamis-San_dOria -> DYNAMIS_SAN_DORIA).
    local zoneId = xi.zone[string.upper((zoneName:gsub('%-', '_')))]
    assert(zoneId, string.format('no xi.zone entry for %s (from %s)', zoneName, target))

    loadedZones[zoneName] = xi.test.world:spawnPlayer({ zone = zoneId })
end

-- The literal override targets and command names a module file declares. A name joined onto a
-- runtime value ('xi.zones.' .. zoneName) is not literal; pass the built names as opts.targets.
function moduleTest.declarations(path)
    local source   = readSource(path)
    local targets  = {}
    local commands = {}

    for target in source:gmatch('addOverride' .. quotedName .. '%s*,') do
        table.insert(targets, target)
    end

    for target in source:gmatch('addOverrideByEra' .. quotedName .. '%s*,') do
        table.insert(targets, target)
    end

    for name in source:gmatch('registerCommand' .. quotedName .. '%s*,') do
        table.insert(commands, name)
    end

    return targets, commands
end

-- Asserts every override and command the module file declares is live in the running server.
-- opts.targets: extra targets the file builds at runtime (loops, string.format).
-- opts.skip: declared targets not expected to apply under CI's settings.
-- opts.newTargets: targets the module adds rather than replaces, so no upstream function sits under them.
function moduleTest.assertOverridesApplied(path, opts)
    opts = opts or {}

    local targets, commands = moduleTest.declarations(path)
    for _, target in ipairs(opts.targets or {}) do
        table.insert(targets, target)
    end

    local skipped = {}
    for _, target in ipairs(opts.skip or {}) do
        skipped[target] = true
    end

    local added = {}
    for _, target in ipairs(opts.newTargets or {}) do
        added[target] = true
    end

    assert(#targets + #commands > 0, string.format('%s declares no overrides or commands; pass opts.targets', path))

    local checked = {}
    for _, target in ipairs(targets) do
        if
            not skipped[target] and
            not checked[target]
        then
            checked[target] = true
            loadZoneFor(target)

            local live = resolve(target)
            assert(type(live) == 'function', string.format('%s: override target %s does not resolve to a function', path, target))

            local links = overrideChain(live)
            assert(linkFrom(links, path), string.format('%s: override of %s is not applied', path, target))

            -- The loader fills a missing target with an empty C function, so the override sits on nothing.
            local _, baseKind = sourcePath(links[#links])
            if not added[target] then
                assert(baseKind ~= 'C', string.format('%s: %s has no upstream function under the override (renamed or removed upstream?)', path, target))
            end
        end
    end

    -- gm_command_tiers wraps command triggers with overrides, so look down the chain.
    for _, name in ipairs(commands) do
        local command = xi.commands and xi.commands[name]
        assert(type(command) == 'table', string.format('%s: command !%s is not registered', path, name))
        assert(linkFrom(overrideChain(command.onTrigger), path), string.format('%s: command !%s comes from another file', path, name))
    end

    return checked
end

-- The function the module file at path installed for target, and the original at the bottom of its chain.
function moduleTest.overrideAndUpstream(target, path)
    local links = overrideChain(resolve(target))

    return linkFrom(links, path), links[#links]
end

-- The test file that called into this helper, found on the call stack.
local function callingTestFile()
    for level = 2, 32 do
        local info = debug.getinfo(level, 'S')
        if info == nil then
            break
        end

        -- \92 is a backslash, which Windows paths use.
        local path = info.source:gsub('^@', ''):gsub('\92', '/')
        if
            path:find('scripts/tests/', 1, true) and
            not path:find('scripts/tests/helpers/', 1, true)
        then
            return path
        end
    end

    error('not called from a test file')
end

-- The module Lua files named on the calling test's Covers lines.
function moduleTest.coveredFiles()
    local testPath = callingTestFile()
    local files    = {}
    for line in io.lines(testPath) do
        local path = line:match('^%-%-%s*Covers:%s*(%S+%.lua)%s*$')
        if path then
            table.insert(files, path)
        end
    end

    assert(#files > 0, string.format('%s has no Covers lines naming a Lua file', testPath))

    return files
end

-- assertOverridesApplied on every module Lua file the calling test covers.
-- optsByPath: the opts for files that need them, keyed by module path.
function moduleTest.assertCoveredOverridesApplied(optsByPath)
    optsByPath = optsByPath or {}

    for _, path in ipairs(moduleTest.coveredFiles()) do
        moduleTest.assertOverridesApplied(path, optsByPath[path])
    end
end

-- The quest, mission or battlefield table the Interaction Framework runs, by its script path.
-- modifyInteractionEntry stores a patched copy under the forward-slash path, while the
-- framework loads its own with the platform's separator (backslashes on Windows).
function moduleTest.container(path)
    local container = package.loaded[path] or package.loaded[(path:gsub('/', '\\'))]
    assert(container, string.format('%s is not loaded', path))

    return container
end

-- Stubs the shared weapon skill damage functions, so an override can run without a fight.
-- Returns run(wsName, player, target, tp), which calls the weapon skill's onUseWeaponSkill and
-- gives back the params it passed on, or nil if it passed none.
function moduleTest.weaponskillRunner()
    local captured

    local function capture(_, _, _, params)
        captured = params
        return 0, false, 0, 0
    end

    stub('xi.weaponskills.doPhysicalWeaponskill', capture)
    stub('xi.weaponskills.doMagicWeaponskill', capture)
    stub('xi.weaponskills.doRangedWeaponskill', capture)
    stub('xi.weaponskills.takeWeaponskillDamage', 0)

    -- Accepts any action method call, so overrides that report results directly still run.
    local action = setmetatable({}, {
        __index = function()
            return function()
            end
        end,
    })

    return function(wsName, player, target, tp)
        captured = nil
        local weaponskill = xi.actions.weaponskills[wsName]
        assert(weaponskill, string.format('no weapon skill script for %s', wsName))
        weaponskill.onUseWeaponSkill(player, target, 0, tp, true, action, nil)

        return captured
    end
end

-- Stubs the shops and returns stockOf(player, npcName), which walks the player to the NPC,
-- triggers it, and gives back { [itemId] = price } for what the shop offered.
-- Outpost shops pass their stock on to xi.shop.general, so they are read there.
function moduleTest.shopReader()
    local offered

    local function capture(_, stock)
        offered = {}
        for _, entry in ipairs(stock) do
            offered[entry[1]] = entry[2]
        end
    end

    stub('xi.shop.general', capture)
    stub('xi.shop.nation', capture)

    return function(player, npcName)
        offered = nil
        player.entities:gotoAndTrigger(npcName)
        assert(offered, string.format('%s opened no shop', npcName))

        return offered
    end
end

-- The files each kind of shared skill code reads its params in.
local paramSources =
{
    mobskill    = { 'scripts/globals/mobskills.lua' },
    weaponskill = { 'scripts/globals/weaponskills.lua', 'scripts/globals/magic.lua' },
}

-- The params keys the shared 'mobskill' or 'weaponskill' code reads, from its source, so a key
-- an override sets but nothing reads (a renamed param upstream) can be caught.
function moduleTest.paramKeys(kind)
    local keys = {}
    for _, path in ipairs(paramSources[kind]) do
        for key in readSource(path):gmatch('[%w_]*[pP]arams%.([%a_][%w_]*)') do
            keys[key] = true
        end
    end

    return keys
end

-- A stand-in entity, skill or action: logs every call except reads into trace and returns
-- answers[method], calling it first when it is a function.
function moduleTest.standIn(trace, label, answers)
    return setmetatable({}, {
        __index = function(_, method)
            return function(_, ...)
                if
                    not method:find('^get') and
                    not method:find('^has') and
                    not method:find('^is') and
                    not method:find('^can') and
                    not method:find('^count') and
                    not method:find('^check')
                then
                    table.insert(trace, { name = label .. ':' .. method, args = { ... } })
                end

                local answer = answers[method]
                if type(answer) == 'function' then
                    return answer(...)
                end

                return answer
            end
        end,
    })
end

-- The arguments of every logged call with this name, in order.
function moduleTest.callsTo(trace, name)
    local found = {}
    for _, entry in ipairs(trace) do
        if entry.name == name then
            table.insert(found, entry.args)
        end
    end

    return found
end

-- Text form of a log: stand-ins and engine objects by kind, tables with sorted keys.
function moduleTest.render(value)
    local kind = type(value)
    if kind ~= 'table' then
        if
            kind == 'userdata' or
            kind == 'function'
        then
            return '<' .. kind .. '>'
        end

        return tostring(value)
    end

    if getmetatable(value) then
        return '<entity>'
    end

    local keys = {}
    for key in pairs(value) do
        table.insert(keys, key)
    end

    table.sort(keys, function(a, b)
        return tostring(a) < tostring(b)
    end)

    local parts = {}
    for _, key in ipairs(keys) do
        table.insert(parts, tostring(key) .. '=' .. moduleTest.render(value[key]))
    end

    return '{' .. table.concat(parts, ',') .. '}'
end

-- A proxy for target that records the arguments of each method named in recorded instead of
-- calling it, and calls recorded[name] when that is a function. Other calls go to target.
-- Returns the proxy and { [name] = { args, ... } }.
function moduleTest.recordingProxy(target, recorded)
    local calls = {}
    for name in pairs(recorded) do
        calls[name] = {}
    end

    local proxy = setmetatable({}, {
        __index = function(_, name)
            if calls[name] then
                return function(_, ...)
                    table.insert(calls[name], { ... })

                    if type(recorded[name]) == 'function' then
                        return recorded[name](...)
                    end
                end
            end

            return function(_, ...)
                return target[name](target, ...)
            end
        end,
    })

    return proxy, calls
end

-- The text of every chat line (0x017) the server sent the player since the last clear.
function moduleTest.chatLines(player)
    local lines = {}
    for _, packet in ipairs(player.packets:getIncoming()) do
        if packet.type == 0x017 then
            -- The message follows the 15-byte sender name, at 0x17.
            local chars = {}
            for i = 0x17, packet.size - 1 do
                local byte = packet.data[i]
                if
                    byte == nil or
                    byte == 0
                then
                    break
                end

                table.insert(chars, string.char(byte))
            end

            table.insert(lines, table.concat(chars))
        end
    end

    return lines
end

-- Asserts the chat lines since the last clear are expected, in order.
function moduleTest.assertChatLines(player, expected)
    local lines = moduleTest.chatLines(player)
    assert(#lines == #expected, string.format('expected %d lines, got %d: %s', #expected, #lines, table.concat(lines, ' | ')))
    for i, line in ipairs(expected) do
        assert(lines[i] == line, string.format('line %d: expected "%s", got "%s"', i, line, lines[i]))
    end
end

-- Asserts one of the chat lines since the last clear is expected.
function moduleTest.assertChatPrinted(player, expected)
    local lines = moduleTest.chatLines(player)
    for _, line in ipairs(lines) do
        if line == expected then
            return
        end
    end

    error(string.format('expected "%s", got: %s', expected, table.concat(lines, ' | ')), 2)
end

return moduleTest
