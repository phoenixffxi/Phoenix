-----------------------------------
-- Gil Economy Ledger - Script Sources
--
-- The gil_audit C++ module observes every gil balance change but not why it moved.
-- These overrides declare the reason for the central helpers most scripted gil
-- funnels through, call super() unchanged, then retire the reason so a helper
-- that bails without moving gil cannot label a later movement.
--
-- Leaf scripts calling player:addGil directly still have their amount recorded,
-- but land as Unknown rather than Script.
-----------------------------------
-- luacheck: globals __gilAuditSetReason __gilAuditRetireReason
local m = Module:new('gil_audit_sources')

-- The module loader replaces a missing override target with an empty function, which would
-- silently turn the helper into a no-op. Refuse to load instead so an upstream rename is caught at startup.
local function resolve(path)
    local value = _G
    for part in string.gmatch(path, '[^.]+') do
        if type(value) ~= 'table' then
            return nil
        end

        value = value[part]
    end

    return value
end

local overrideTargets =
{
    'npcUtil.giveCurrency',
    'npcUtil.giveReward',
    'npcUtil.completeQuest',
    'npcUtil.completeMission',
    'xi.player.charCreate',
    'xi.mob.onMobDeathEx',
    'xi.job_utils.thief.useMug',
    'xi.rentalChocobo.renterOnEventFinish',
    'xi.regime.checkRegime',
    'xi.commands.givegil.onTrigger',
    'xi.commands.takegil.onTrigger',
    'xi.commands.setgil.onTrigger',
}

for _, path in ipairs(overrideTargets) do
    if type(resolve(path)) ~= 'function' then
        error(string.format('gil_audit_sources: override target %s does not exist, refusing to load', path))
    end
end

-- Must match the GilSource enum in modules/phoenix/cpp/gil_audit.cpp
local gilSource =
{
    MOB_DROP   = 1,
    SCRIPT     = 12,
    GM_COMMAND = 13,
}

-- `player` is whose gil moves, which for !givegil is the target rather than the caller.
-- Returns whether a reason was pushed, so retire() can pop exactly what was pushed.
-- No-op when the C++ module is not loaded, and never allowed to break the game action.
local function declare(player, source, detail, counterparty)
    if not __gilAuditSetReason or not player then
        return false
    end

    local ok = pcall(__gilAuditSetReason, player:getID(), source, detail or '', counterparty or 0)
    return ok
end

local function retire(declared)
    if declared and __gilAuditRetireReason then
        pcall(__gilAuditRetireReason)
    end
end

-----------------------------------
-- npcUtil helpers
-----------------------------------

m:addOverride('npcUtil.giveCurrency', function(player, currency, amount, useTreasurePoolMsg)
    local declared = false
    if type(currency) == 'string' and string.lower(currency) == 'gil' then
        declared = declare(player, gilSource.SCRIPT, 'npcUtil.giveCurrency')
    end

    local result = super(player, currency, amount, useTreasurePoolMsg)
    retire(declared)

    return result
end)

m:addOverride('npcUtil.giveReward', function(player, params)
    local declared = false
    if type(params) == 'table' and type(params.gil) == 'number' then
        declared = declare(player, gilSource.SCRIPT, 'npcUtil.giveReward')
    end

    local result = super(player, params)
    retire(declared)

    return result
end)

m:addOverride('npcUtil.completeQuest', function(player, area, quest, params)
    local declared = false
    if type(params) == 'table' and type(params.gil) == 'number' then
        declared = declare(player, gilSource.SCRIPT, 'npcUtil.completeQuest')
    end

    local result = super(player, area, quest, params)
    retire(declared)

    return result
end)

m:addOverride('npcUtil.completeMission', function(player, logId, missionId, params)
    local declared = false
    if type(params) == 'table' and type(params.gil) == 'number' then
        declared = declare(player, gilSource.SCRIPT, 'npcUtil.completeMission')
    end

    local result = super(player, logId, missionId, params)
    retire(declared)

    return result
end)

-----------------------------------
-- Character creation
-----------------------------------

m:addOverride('xi.player.charCreate', function(player)
    local declared = declare(player, gilSource.SCRIPT, 'starting_gil')

    local result = super(player)
    retire(declared)

    return result
end)

-----------------------------------
-- Mob drops and Mug
--
-- Both are gil created from a mob's purse, so both share the AUDIT_GIL_MOBS gate.
-----------------------------------

-- Fires for every alliance member before the core hands out the drop. Only the killer declares;
-- the C++ side widens the reason to the alliance in zone, and the zone tick retires it afterwards.
m:addOverride('xi.mob.onMobDeathEx', function(mob, player, isKiller, isWeaponSkillKill)
    if isKiller then
        declare(player, gilSource.MOB_DROP, 'mob_drop', mob and mob:getID() or 0)
    end

    return super(mob, player, isKiller, isWeaponSkillKill)
end)

m:addOverride('xi.job_utils.thief.useMug', function(player, target, ability, action)
    local declared = declare(player, gilSource.MOB_DROP, 'mug', target and target:getID() or 0)

    local result = super(player, target, ability, action)
    retire(declared)

    return result
end)

-----------------------------------
-- Chocobo rental
-----------------------------------

m:addOverride('xi.rentalChocobo.renterOnEventFinish', function(player, csid, option, eventSucceed)
    local declared = declare(player, gilSource.SCRIPT, 'chocobo_rental')

    local result = super(player, csid, option, eventSucceed)
    retire(declared)

    return result
end)

-----------------------------------
-- Field/Grounds of Valor regime rewards
-----------------------------------

m:addOverride('xi.regime.checkRegime', function(player, mob, regimeId, index, regimeType)
    local declared = declare(player, gilSource.SCRIPT, 'regime_reward')

    local result = super(player, mob, regimeId, index, regimeType)
    retire(declared)

    return result
end)

-----------------------------------
-- GM gil commands
--
-- !givegil and !takegil move the target's gil, so the target is the actor and the GM the counterparty.
-----------------------------------

local function resolveGilCommandTarget(player, target)
    if not target then
        return player
    end

    return GetPlayerByName(target)
end

m:addOverride('xi.commands.givegil.onTrigger', function(player, amount, target)
    local declared = declare(resolveGilCommandTarget(player, target), gilSource.GM_COMMAND, 'givegil', player:getID())

    local result = super(player, amount, target)
    retire(declared)

    return result
end)

m:addOverride('xi.commands.takegil.onTrigger', function(player, amount, target)
    local declared = declare(resolveGilCommandTarget(player, target), gilSource.GM_COMMAND, 'takegil', player:getID())

    local result = super(player, amount, target)
    retire(declared)

    return result
end)

m:addOverride('xi.commands.setgil.onTrigger', function(player, amount)
    local declared = declare(player, gilSource.GM_COMMAND, 'setgil')

    local result = super(player, amount)
    retire(declared)

    return result
end)

return m
