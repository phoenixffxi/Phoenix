-----------------------------------
-- Phoenix economy telemetry semantic attribution
--
-- The C++ producer is disabled unless PHOENIX_ECONOMY_TELEMETRY_ENABLED
-- is explicitly enabled. These wrappers only maintain synchronous,
-- in-memory attribution context; they never perform I/O.
-----------------------------------
local enabledValue = string.lower(os.getenv('PHOENIX_ECONOMY_TELEMETRY_ENABLED') or '')
local enabled =
    enabledValue == '1' or
    enabledValue == 'true' or
    enabledValue == 'yes' or
    enabledValue == 'on'

if not enabled then
    -- A plain table keeps the module loader contract while registering no
    -- overrides, so the default-off path has no gameplay overhead.
    return { disabled = true }
end

require('modules/module_utils')
-----------------------------------
local m = Module:new('phoenix_economy_telemetry')

local function pack(...)
    return { n = select('#', ...), ... }
end

local function telemetryEnabled()
    return
        xi ~= nil and
        xi.economy ~= nil and
        xi.economy.enabled ~= nil and
        xi.economy.enabled()
end

local function withContext(player, context, fn, ...)
    if
        not telemetryEnabled() or
        player == nil or
        xi.economy.beginContext == nil or
        not xi.economy.beginContext(player, context)
    then
        return fn(...)
    end

    local result = pack(pcall(fn, ...))
    xi.economy.endContext(player)

    if not result[1] then
        error(result[2], 0)
    end

    return unpack(result, 2, result.n)
end

local function withContexts(players, context, fn, ...)
    if not telemetryEnabled() or type(players) ~= 'table' then
        return fn(...)
    end

    local pushed = {}
    for _, player in ipairs(players) do
        if
            player ~= nil and
            xi.economy.beginContext ~= nil and
            xi.economy.beginContext(player, context)
        then
            table.insert(pushed, player)
        end
    end

    local result = pack(pcall(fn, ...))
    for index = #pushed, 1, -1 do
        xi.economy.endContext(pushed[index])
    end

    if not result[1] then
        error(result[2], 0)
    end

    return unpack(result, 2, result.n)
end

local function invokeWalletMutation(player, operation, requested, fn, ...)
    if
        not telemetryEnabled() or
        player == nil or
        xi.economy.beginLuaWallet == nil or
        not xi.economy.beginLuaWallet(player)
    then
        return fn(...)
    end

    local before = player:getGil()
    local result = pack(pcall(fn, ...))
    local after = player:getGil()
    xi.economy.endLuaWallet(player, before, after, requested or 0, operation)

    if not result[1] then
        error(result[2], 0)
    end

    return unpack(result, 2, result.n)
end

local function isEntityType(value, method)
    if type(value) ~= 'userdata' then
        return false
    end

    local result = pack(pcall(function()
        return value[method](value)
    end))

    return result[1] and result[2] == true
end

local function findPlayer(...)
    for index = 1, select('#', ...) do
        local value = select(index, ...)
        if isEntityType(value, 'isPC') then
            return value
        end
    end
end

local function findNpc(...)
    for index = 1, select('#', ...) do
        local value = select(index, ...)
        if isEntityType(value, 'isNPC') then
            return value
        end
    end
end

local function entitySource(context, entity)
    if entity == nil then
        return context
    end

    if entity:isNPC() then
        context.sourceType = 'npc'
        context.scriptKey = nil
        context.systemKey = nil
        context.npcId = entity:getID()
        context.zoneId = entity:getZoneID()
    elseif entity:isMob() then
        context.sourceType = 'mob'
        context.scriptKey = nil
        context.systemKey = nil
        context.serviceKey = nil
        context.mobSpawnId = entity:getID()
        context.mobPoolId = entity:getPool()
        context.zoneId = entity:getZoneID()
    end

    return context
end

local function makeStaticOverride(mintCategory, burnCategory, serviceKey)
    return function(...)
        local player = findPlayer(...)
        local context = entitySource({
            mintCategory = mintCategory,
            burnCategory = burnCategory,
            sourceType = 'system',
            systemKey = serviceKey,
        }, findNpc(...))

        if context.sourceType == 'npc' then
            context.serviceKey = serviceKey
        end

        return withContext(player, context, super, ...)
    end
end

-- Observe actual applied deltas while preserving the stock Lua bindings and
-- their return values. The C++ observer suppresses the synchronous ITEM_NUM
-- packet during super so each mutation produces one semantic record or gap.
m:addOverride('CBaseEntity.addGil', function(player, amount)
    return invokeWalletMutation(player, 'add', amount, super, player, amount)
end)

m:addOverride('CBaseEntity.delGil', function(player, amount)
    return invokeWalletMutation(player, 'del', amount, super, player, amount)
end)

m:addOverride('CBaseEntity.setGil', function(player, amount)
    return invokeWalletMutation(player, 'set', amount, super, player, amount)
end)

m:addOverride('CBaseEntity.confirmTrade', function(player)
    return invokeWalletMutation(player, 'confirm_trade', 0, super, player)
end)

m:addOverride('CBaseEntity.tradeComplete', function(player)
    return invokeWalletMutation(player, 'trade_complete', 0, super, player)
end)

-- Normal shop packets contain only a menu slot. Capture the stable active NPC
-- at menu creation and let the native correlator bind it to later purchases.
m:addOverride('CBaseEntity.createShop', function(player, ...)
    local result = pack(pcall(super, player, ...))
    if result[1] and telemetryEnabled() and xi.economy.captureShop ~= nil then
        xi.economy.captureShop(player)
    end

    if not result[1] then
        error(result[2], 0)
    end

    return unpack(result, 2, result.n)
end)

local function contextForContainer(container)
    if type(container.questId) == 'number' and type(container.areaId) == 'number' then
        return {
            mintCategory = 'quest_reward',
            burnCategory = 'quest_fee',
            sourceType = 'quest',
            questLogId = container.areaId,
            questId = container.questId,
        }
    elseif type(container.missionId) == 'number' and type(container.areaId) == 'number' then
        return {
            mintCategory = 'mission_reward',
            burnCategory = 'quest_fee',
            sourceType = 'mission',
            missionLogId = container.areaId,
            missionId = container.missionId,
        }
    elseif type(container.battlefieldId) == 'number' then
        return {
            mintCategory = 'battlefield_reward',
            sourceType = 'battlefield',
            battlefieldId = container.battlefieldId,
        }
    end
end

local wrappedContainers = setmetatable({}, { __mode = 'k' })

local function wrapContainerTable(value, context, seen)
    if seen[value] then
        return
    end

    seen[value] = true
    for key, entry in pairs(value) do
        if type(entry) == 'function' then
            local original = entry
            value[key] = function(...)
                return withContext(findPlayer(...), context, original, ...)
            end
        elseif type(entry) == 'table' then
            wrapContainerTable(entry, context, seen)
        end
    end
end

-- Wrap interaction containers before InteractionLookup preprocesses their
-- handlers. This covers direct gil mutations in quest/mission callbacks and
-- continues to work when a container is reloaded.
m:addOverride('InteractionLookup.addContainer', function(lookup, container, validZoneTable)
    local context = contextForContainer(container)
    if context ~= nil and not wrappedContainers[container] then
        wrappedContainers[container] = true
        wrapContainerTable(container.sections, context, {})
    end

    return super(lookup, container, validZoneTable)
end)

-- Legacy completion helpers can be called outside interaction containers.
m:addOverride('npcUtil.completeQuest', function(player, area, questId, params)
    local questLogId = type(area) == 'table' and area.quest_log or area
    local context = {
        mintCategory = 'quest_reward',
        burnCategory = 'quest_fee',
        sourceType = 'quest',
        questLogId = questLogId,
        questId = questId,
    }

    return withContext(player, context, super, player, area, questId, params)
end)

m:addOverride('npcUtil.completeMission', function(player, missionLogId, missionId, params)
    local context = {
        mintCategory = 'mission_reward',
        burnCategory = 'quest_fee',
        sourceType = 'mission',
        missionLogId = missionLogId,
        missionId = missionId,
    }

    return withContext(player, context, super, player, missionLogId, missionId, params)
end)

-- Character creation is the sole authoritative START_GIL grant. Adventurer
-- coupon NPC rewards are ordinary scripted rewards, not starting gil.
m:addOverride('xi.player.charCreate',
    makeStaticOverride('starting_gil', nil, 'character-creation'))

local function adminContext(player, mintCategory, burnCategory)
    return {
        mintCategory = mintCategory,
        burnCategory = burnCategory,
        sourceType = 'admin',
        actorCharId = player:getID(),
    }
end

m:addOverride('xi.commands.givegil.onTrigger', function(player, amount, target)
    local recipient = target == nil and player or GetPlayerByName(target)
    return withContext(recipient, adminContext(player, 'admin_grant', nil),
        super, player, amount, target)
end)

m:addOverride('xi.commands.setgil.onTrigger', function(player, amount)
    return withContext(player, adminContext(player, 'admin_grant', 'admin_remove'),
        super, player, amount)
end)

m:addOverride('xi.commands.takegil.onTrigger', function(player, amount, target)
    local recipient = target == nil and player or GetPlayerByName(target)
    return withContext(recipient, adminContext(player, nil, 'admin_remove'),
        super, player, amount, target)
end)

-- Guild shops are Lua-authoritative and expose both the NPC and item identity.
m:addOverride('xi.guildShops.onPlayerBuy', function(player, npc, itemId, quantity)
    local context = entitySource({
        burnCategory = 'guild_shop_purchase',
        sourceType = 'system',
        systemKey = 'guild-shop',
        serviceKey = 'guild-shop',
        itemId = itemId,
        itemQuantity = quantity,
    }, npc)

    return withContext(player, context, super, player, npc, itemId, quantity)
end)

m:addOverride('xi.guildShops.onPlayerSell', function(player, npc, itemId, quantity)
    local context = entitySource({
        mintCategory = 'guild_vendor_sale',
        sourceType = 'system',
        systemKey = 'guild-shop',
        serviceKey = 'guild-shop',
        itemId = itemId,
        itemQuantity = quantity,
    }, npc)

    return withContext(player, context, super, player, npc, itemId, quantity)
end)

m:addOverride('xi.job_utils.thief.useMug', function(player, target, ability, action)
    local context = entitySource({
        mintCategory = 'mug',
        sourceType = 'system',
        systemKey = 'mug',
    }, target)

    return withContext(player, context, super, player, target, ability, action)
end)

m:addOverride('xi.regime.checkRegime', function(player, mob, regimeId, index, regimeType)
    local context = {
        mintCategory = 'regime_reward',
        sourceType = 'regime',
        regimeId = regimeId,
    }

    return withContext(player, context, super, player, mob, regimeId, index, regimeType)
end)

m:addOverride('Battlefield.handleLootRolls', function(battlefieldContent, battlefield, lootTable, npc, gilBonusMod)
    local context = {
        mintCategory = 'battlefield_reward',
        sourceType = 'battlefield',
        battlefieldId = battlefieldContent.battlefieldId,
    }

    return withContexts(battlefield:getPlayers(), context, super,
        battlefieldContent, battlefield, lootTable, npc, gilBonusMod)
end)

m:addOverride('xi.chocobo.renterOnEventFinish',
    makeStaticOverride(nil, 'chocobo_rental', 'chocobo-rental'))

local transportOverrides =
{
    { 'xi.barge.onTicketShopEventFinish',                                      'barge-ticket' },
    { 'xi.conquest.overseerOnEventFinish',                                     'conquest-homepoint' },
    { 'xi.conquest.teleporterOnEventFinish',                                   'outpost-teleport' },
    { 'xi.conquest.vendorOnEventFinish',                                       'outpost-return' },
    { 'xi.homepoint.onEventFinish',                                             'homepoint' },
    { 'xi.survivalGuide.onEventFinish',                                         'survival-guide' },
    { 'xi.teleport.explorerMoogleOnEventFinish',                                'explorer-moogle' },
    { 'xi.zones.Aht_Urhgan_Whitegate.npcs.Atiza.onEventFinish',                 'ferry-ticket' },
    { 'xi.zones.Aht_Urhgan_Whitegate.npcs.Tazhaal.onEventFinish',               'ferry-ticket' },
    { 'xi.zones.Bibiki_Bay.npcs.Tswe_Panipahr.onEventFinish',                   'manaclipper-ticket' },
    { 'xi.zones.Kazham.npcs.Bhoyu_Halpatacco.onEventFinish',                    'airship' },
    { 'xi.zones.Lower_Jeuno.npcs.Derrick.onEventUpdate',                        'airship-pass' },
    { 'xi.zones.Lower_Jeuno.npcs.Domenic.onEventFinish',                        'battlefield-teleport' },
    { 'xi.zones.Mhaura.npcs.Felisa.onEventFinish',                              'ferry-ticket' },
    { 'xi.zones.Nashmau.npcs.Abihaal.onEventFinish',                            'ferry-ticket' },
    { 'xi.zones.Newton_Movalpolos.npcs.Sleakachiq.onEventFinish',               'movalpolos-teleport' },
    { 'xi.zones.Oldton_Movalpolos.npcs.Twinkbrix.onEventFinish',                'mineshaft-teleport' },
    { 'xi.zones.Port_Bastok.npcs.Alib-Mufalib.onEventFinish',                   'whitegate-teleport' },
    { 'xi.zones.Port_Bastok.npcs.Rajesh.onEventFinish',                         'airship' },
    { 'xi.zones.Port_Bastok.npcs.Varden.onEventFinish',                         'airship' },
    { 'xi.zones.Port_Bastok.npcs._6k8.onEventFinish',                           'airship' },
    { 'xi.zones.Port_Jeuno.npcs.Guddal.onEventUpdate',                          'airship-pass' },
    { 'xi.zones.Port_Jeuno.npcs.Illauvolahaut.onEventFinish',                   'airship' },
    { 'xi.zones.Port_Jeuno.npcs.Omiro-Zamiro.onEventFinish',                    'airship' },
    { 'xi.zones.Port_Jeuno.npcs.Purequane.onEventFinish',                       'airship' },
    { 'xi.zones.Port_Jeuno.npcs.Zedduva.onEventFinish',                         'airship' },
    { 'xi.zones.Port_Jeuno.npcs._6u4.onEventFinish',                            'airship' },
    { 'xi.zones.Port_Jeuno.npcs._6u8.onEventFinish',                            'airship' },
    { 'xi.zones.Port_Jeuno.npcs._6ua.onEventFinish',                            'airship' },
    { 'xi.zones.Port_Jeuno.npcs._6ue.onEventFinish',                            'airship' },
    { 'xi.zones.Port_San_dOria.npcs.Anton.onEventFinish',                       'airship' },
    { 'xi.zones.Port_San_dOria.npcs._6g9.onEventFinish',                        'airship' },
    { 'xi.zones.Port_Windurst.npcs.Honorio.onEventFinish',                      'airship' },
    { 'xi.zones.Port_Windurst.npcs._6o6.onEventFinish',                         'airship' },
    { 'xi.zones.Selbina.npcs.Lucia.onEventFinish',                              'ferry-ticket' },
    { 'xi.zones.Southern_San_dOria.npcs.Amutiyaal.onEventFinish',               'whitegate-teleport' },
    { 'xi.zones.Upper_Jeuno.npcs.Ajithaam.onEventFinish',                       'whitegate-teleport' },
    { 'xi.zones.Windurst_Woods.npcs.Ibwam.onEventFinish',                       'whitegate-teleport' },
}

for _, entry in ipairs(transportOverrides) do
    m:addOverride(entry[1], makeStaticOverride(nil, 'transport_fee', entry[2]))
end

local serviceOverrides =
{
    { 'xi.appraisal.appraisalOnEventFinish',                                    'appraisal' },
    { 'xi.armorStorage.onEventFinish',                                           'armor-storage' },
    { 'xi.artisan.moogleOnUpdate',                                               'mog-sack' },
    { 'xi.clamming.zonikkiOnEventFinish',                                        'clamming-kit' },
    { 'xi.crafting.oldImageSupportOnEventFinish',                                'crafting-image-support' },
    { 'xi.dynamis.hourglassAndCurrencyExchangeNPCOnEventFinish',                 'dynamis-hourglass' },
    { 'xi.dynamis.hourglassAndCurrencyExchangeNPCOnEventUpdate',                 'dynamis-map' },
    { 'xi.fishingContest.onEventFinish',                                         'fishing-contest' },
    { 'xi.linkshellConcierge.onEventFinish',                                     'linkshell-concierge' },
    { 'xi.maps.onEventUpdate',                                                   'map-vendor' },
    { 'xi.porter_moogle.onEventFinish',                                          'porter-moogle' },
    { 'xi.titleChanger.onEventFinish',                                           'title-changer' },
    { 'xi.voidwalker.npcOnEventFinish',                                          'voidwalker-abyssite' },
    { 'xi.zones.Aht_Urhgan_Whitegate.npcs.Abda-Lurabda.onEventFinish',           'character-rename' },
    { 'xi.zones.Bastok_Markets.npcs.Lamepaue.onEventUpdate',                     'cutscene-replay' },
    { 'xi.zones.Heavens_Tower.npcs.Rakano-Marukano.onEventFinish',               'armor-storage' },
    { 'xi.zones.Lower_Jeuno.npcs.Vingijard.onEventFinish',                       'artifact-reset' },
    { 'xi.zones.Metalworks.npcs.Mythily.onEventFinish',                          'armor-storage' },
    { 'xi.zones.Nashmau.npcs.Kilusha.onEventFinish',                             'einherjar-lamp' },
    { 'xi.zones.Norg.npcs.Fouvia.onEventFinish',                                 'character-rename' },
    { 'xi.zones.Northern_San_dOria.npcs.Beriphaule.onEventFinish',               'armor-storage' },
    { 'xi.zones.Northern_San_dOria.npcs.Durogg.onEventUpdate',                   'cutscene-replay' },
    { 'xi.zones.Oldton_Movalpolos.npcs.Twinkbrix.onTrade',                       'twinkbrix-gamble' },
    { 'xi.zones.Port_Bastok.npcs.Dalba.onEventUpdate',                           'cutscene-replay' },
    { 'xi.zones.Port_Jeuno.npcs.Sagheera.onEventUpdate',                         'cosmo-cleanse' },
    { 'xi.zones.Temple_of_Uggalepih.npcs._4f3.onEventFinish',                    'tonberry-hate-reset' },
    { 'xi.zones.Upper_Jeuno.npcs.Monberaux.onEventFinish',                       'monberaux-training' },
}

for _, entry in ipairs(serviceOverrides) do
    m:addOverride(entry[1], makeStaticOverride(nil, 'service_fee', entry[2]))
end

-- Stage only stable mob/member evidence after the stock death callback. The
-- native ITEM_NUM + MsgBasic::Obtains pair decides whether a correlated event,
-- forgone mint, or attribution gap is emitted.
m:addOverride('xi.mob.onMobDeathEx', function(mob, player, isKiller, isWeaponSkillKill)
    local result = pack(pcall(super, mob, player, isKiller, isWeaponSkillKill))
    if
        player ~= nil and
        telemetryEnabled() and
        xi.economy.stageMobDeath ~= nil
    then
        xi.economy.stageMobDeath(player, mob)
    end

    if not result[1] then
        error(result[2], 0)
    end

    return unpack(result, 2, result.n)
end)

return m
