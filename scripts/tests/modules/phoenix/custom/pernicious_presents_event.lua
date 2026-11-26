---@diagnostic disable: undefined-field, inject-field
-----------------------------------
-- Pernicious Presents: a Festive Moogle grants an event level cap that keeps EXP, ends on death or lapse, the
-- Twinkling Treant spawns with event stats, and outpost vendors only open their shop while the event runs.
-----------------------------------
local ffi          = require('ffi')
local moduleTest   = require('scripts.tests.helpers.modules')
local packetReader = require('scripts.tests.helpers.packet_reader')

ffi.cdef [[
    typedef struct {
        uint16_t id : 9;
        uint16_t size : 7;
        uint16_t sync;
        uint8_t  unknown04;
        uint8_t  unknown05;
        char     sName[15];
        char     Mes[128];
    } PHX_TREANT_CHAT_NAME;
]]

local function assertNotPrinted(player, unexpected)
    for _, line in ipairs(moduleTest.chatLines(player)) do
        assert(line ~= unexpected, string.format('did not expect "%s"', unexpected))
    end
end

-- Answers the open custom menu, the way the client replies through a GM tell.
local function chooseMenuOption(player, option)
    local packet     = ffi.new('PHX_TREANT_CHAT_NAME')
    packet.unknown04 = 3
    ffi.copy(packet.sName, '_CUSTOM_MENU')
    ffi.copy(packet.Mes, string.format(': Result (%s)', option))
    player.packets:send(0x0B6, packet, ffi.sizeof(packet))
end

describe('Phoenix Pernicious Presents event', function()
    local player
    local savedVars = {}
    local eventVars =
    {
        '[TreantEvent]Started',
        '[TreantEvent]Complete',
        '[TreantEvent]Dead_' .. xi.zone.WEST_RONFAURE,
        '[TreantEvent]Spot_' .. xi.zone.WEST_RONFAURE,
        '[TreantEvent]HP_' .. xi.zone.WEST_RONFAURE,
    }

    setup(function()
        for _, name in ipairs(eventVars) do
            savedVars[name] = GetServerVariable(name)
            SetServerVariable(name, 0)
        end
    end)

    teardown(function()
        for _, name in ipairs(eventVars) do
            SetServerVariable(name, savedVars[name])
        end
    end)

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 75 })
        player.packets:clear()
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/custom/pernicious_presents_event.lua')
    end)

    it('keeps full EXP and shows the timer under the event level cap', function()
        player:addStatusEffect(xi.effect.LEVEL_RESTRICTION, { power = 20, subType = xi.treantEvent.capSubType, duration = 3600, origin = player })

        local effect = player:getStatusEffect(xi.effect.LEVEL_RESTRICTION)
        assert(player:getMod(xi.mod.EXPERIENCE_RETAINED) == 100, string.format('expected 100 EXP retained, got %d', player:getMod(xi.mod.EXPERIENCE_RETAINED)))
        assert(not effect:hasEffectFlag(xi.effectFlag.HIDE_TIMER), 'the event cap hides its timer')
    end)

    describe('event level cap #exhaustive', function()
        it('keeps EXP only for the event cap, not another level cap', function()
            player:addStatusEffect(xi.effect.LEVEL_RESTRICTION, { power = 20, subType = xi.treantEvent.capSubType, duration = 3600, origin = player })
            assert(player:getMod(xi.mod.EXPERIENCE_RETAINED) == 100, 'the event cap kept no EXP')
            player:delStatusEffect(xi.effect.LEVEL_RESTRICTION)

            player:addStatusEffect(xi.effect.LEVEL_RESTRICTION, { power = 20, duration = 3600, origin = player })
            assert(player:getMod(xi.mod.EXPERIENCE_RETAINED) == 0, 'another level cap kept EXP')
        end)

        it('warns when the event cap lapses but not when it is removed early', function()
            local lapse = 'Your right to face the Twinkling Treant has lapsed, kupo. Speak with a Festive Moogle to rejoin the fight!'
            player:addStatusEffect(xi.effect.LEVEL_RESTRICTION, { power = 20, subType = xi.treantEvent.capSubType, duration = 3600, origin = player })
            player:delStatusEffect(xi.effect.LEVEL_RESTRICTION)
            assertNotPrinted(player, lapse)

            player:addStatusEffect(xi.effect.LEVEL_RESTRICTION, { power = 20, subType = xi.treantEvent.capSubType, duration = 1, origin = player })
            xi.test.world:skipTime(2)
            xi.test.world:tick(xi.tick.EFFECT)

            assert(not player:hasStatusEffect(xi.effect.LEVEL_RESTRICTION), 'the event cap did not lapse')
            moduleTest.assertChatPrinted(player, lapse)
        end)

        it('ends the event cap when the player dies', function()
            player:addStatusEffect(xi.effect.LEVEL_RESTRICTION, { power = 20, subType = xi.treantEvent.capSubType, duration = 3600, origin = player })
            player:setHP(0)
            xi.test.world:tickEntity(player)

            assert(not player:hasStatusEffect(xi.effect.LEVEL_RESTRICTION), 'the event cap outlived the player')
            moduleTest.assertChatPrinted(player, 'Your right to face the Twinkling Treant ends with your defeat, kupo. Speak with a Festive Moogle to rejoin the fight!')
        end)

        it('reminds a player without the cap at most every 10 seconds', function()
            local notice = 'Only those who hold the right may face the Twinkling Treant. Speak with a Festive Moogle to join the fight, kupo!'
            xi.treantEvent.onGateRejected(player)
            xi.treantEvent.onGateRejected(player)

            local count = 0
            for _, line in ipairs(moduleTest.chatLines(player)) do
                if line == notice then
                    count = count + 1
                end
            end

            assert(count == 1, string.format('expected one reminder, got %d', count))
        end)
    end)

    describe('treant and moogles #exhaustive', function()
        local zone

        before_each(function()
            zone = GetZone(xi.zone.WEST_RONFAURE)
        end)

        after_each(function()
            xi.treantEvent.resetZone(xi.zone.WEST_RONFAURE)
            SetServerVariable('[TreantEvent]Dead_' .. xi.zone.WEST_RONFAURE, 0)
            SetServerVariable('[TreantEvent]Spot_' .. xi.zone.WEST_RONFAURE, 0)
            SetServerVariable('[TreantEvent]HP_' .. xi.zone.WEST_RONFAURE, 0)
        end)

        it('spawns an event treant with saved HP and the moogles, and clears them on reset', function()
            SetServerVariable('[TreantEvent]HP_' .. xi.zone.WEST_RONFAURE, 12345)
            xi.treantEvent.startZone(xi.zone.WEST_RONFAURE)

            local maxHP = xi.treantEvent.zones[xi.zone.WEST_RONFAURE].hp
            local mobId = zone:getLocalVar('[TreantEvent]MobId')
            local mob   = GetMobByID(mobId)
            assert(mob and mob:isSpawned(), 'no treant spawned')
            assert(mob:getMaxHP() == maxHP, string.format('expected %d max HP, got %d', maxHP, mob:getMaxHP()))
            assert(mob:getHP() == 12345, string.format('expected the saved 12345 HP, got %d', mob:getHP()))
            assert(mob:getMainLvl() == 25, string.format('expected level 25, got %d', mob:getMainLvl()))
            assert(mob:getMobMod(xi.mobMod.NO_AGGRO) == 1, 'the treant aggroes')
            assert(mob:getLocalVar('[TreantEvent]CapSubType') == xi.treantEvent.capSubType, 'the gate cannot read the cap subtype')

            local moogle = GetNPCByID(zone:getLocalVar('[TreantEvent]MoogleId1'))
            assert(moogle and moogle:getStatus() == xi.status.NORMAL, 'the moogle is not shown')

            -- The treant fades out over three seconds and releases its id, so look it up again
            xi.treantEvent.resetZone(xi.zone.WEST_RONFAURE)
            xi.test.world:skipTime(4)
            xi.test.world:tick()
            mob = GetMobByID(mobId)
            assert(mob == nil or not mob:isSpawned(), 'the treant outlived the reset')
            assert(zone:getLocalVar('[TreantEvent]MobId') == 0, 'the treant id outlived the reset')
            assert(moogle:getStatus() == xi.status.DISAPPEAR, 'the moogle outlived the reset')
        end)

        it('joins the fight at the zone cap through a Festive Moogle, and leaves on a second talk', function()
            xi.treantEvent.startZone(xi.zone.WEST_RONFAURE)
            player.entities:gotoAndTrigger('DE_Treant_Moogle_1')
            moduleTest.assertChatPrinted(player, 'Hello hello, kupo! I can help you join in the fight to defeat the pernicious Twinkling Treants!')

            chooseMenuOption(player, 'Yes, kupo!')
            local effect = player:getStatusEffect(xi.effect.LEVEL_RESTRICTION)
            assert(effect, 'joining gave no level cap')
            assert(effect:getPower() == 20, string.format('expected a level 20 cap, got %d', effect:getPower()))
            assert(effect:getSubType() == xi.treantEvent.capSubType, 'joining gave a cap without the event subtype')

            player.packets:clear()
            player.entities:gotoAndTrigger('DE_Treant_Moogle_1')
            assert(not player:hasStatusEffect(xi.effect.LEVEL_RESTRICTION), 'talking again did not withdraw the cap')
            moduleTest.assertChatPrinted(player, 'Your participation is withdrawn, kupo. Come back if you change your mind!')
        end)

        it('turns joiners away once the zone treant has fallen', function()
            xi.treantEvent.startZone(xi.zone.WEST_RONFAURE)
            SetServerVariable('[TreantEvent]Dead_' .. xi.zone.WEST_RONFAURE, 1)
            player.entities:gotoAndTrigger('DE_Treant_Moogle_1')
            chooseMenuOption(player, 'Yes, kupo!')

            assert(not player:hasStatusEffect(xi.effect.LEVEL_RESTRICTION), 'a fallen treant still granted the cap')
            moduleTest.assertChatPrinted(player, 'The Twinkling Treant here has already fallen, kupo!')
        end)

        it('turns away a player bound by another level cap', function()
            xi.treantEvent.startZone(xi.zone.WEST_RONFAURE)
            player:addStatusEffect(xi.effect.LEVEL_RESTRICTION, { power = 30, duration = 3600, origin = player })
            player.entities:gotoAndTrigger('DE_Treant_Moogle_1')

            assert(player:getStatusEffect(xi.effect.LEVEL_RESTRICTION):getPower() == 30, 'the other level cap was replaced')
            moduleTest.assertChatPrinted(player, 'You are already bound by another engagement, kupo. Settle that business first!')
        end)

        it('reads the treant spot from the server variable, falling back to the first', function()
            local entry = xi.treantEvent.zones[xi.zone.WEST_RONFAURE]
            SetServerVariable('[TreantEvent]Spot_' .. xi.zone.WEST_RONFAURE, 2)
            local spot, index = xi.treantEvent.currentSpot(xi.zone.WEST_RONFAURE, entry)
            assert(index == 2 and spot == entry.treant[2], string.format('expected spot 2, got %d', index))

            SetServerVariable('[TreantEvent]Spot_' .. xi.zone.WEST_RONFAURE, 9)
            spot, index = xi.treantEvent.currentSpot(xi.zone.WEST_RONFAURE, entry)
            assert(index == 1 and spot == entry.treant[1], string.format('expected spot 1, got %d', index))
        end)

        it('hides and restores a city outpost teleporter', function()
            local visitor = xi.test.world:spawnPlayer({ zone = xi.zone.NORTHERN_SAN_DORIA })
            visitor.assert:inZone(xi.zone.NORTHERN_SAN_DORIA)
            local npc = GetNPCByID(xi.treantEvent.cityTeleporters[xi.zone.NORTHERN_SAN_DORIA])
            assert(npc, 'no city teleporter found')
            xi.treantEvent.setTeleporterStatus(xi.zone.NORTHERN_SAN_DORIA, xi.status.DISAPPEAR)
            assert(npc:getStatus() == xi.status.DISAPPEAR, 'the teleporter was not hidden')

            xi.treantEvent.setTeleporterStatus(xi.zone.NORTHERN_SAN_DORIA, xi.status.NORMAL)
            assert(npc:getStatus() == xi.status.NORMAL, 'the teleporter was not restored')
        end)
    end)

    describe('outpost vendors while the event runs #exhaustive', function()
        before_each(function()
            xi.test.world:setSetting('main.UNLOCK_OUTPOST_WARPS', 1)
            SetServerVariable('[TreantEvent]Started', GetSystemTime())
            SetServerVariable('[TreantEvent]Complete', 0)
        end)

        after_each(function()
            SetServerVariable('[TreantEvent]Started', 0)
        end)

        -- Harvetour, the West Ronfaure vendor, is hidden under the test conquest state, so call his trigger directly
        it('offers the vendor with no teleport fee', function()
            xi.conquest.vendorOnTrigger(player, xi.region.RONFAURE, 32756)

            local fee = packetReader.lastEventStart(player).params[1] or 0
            player.events:finish(32756, 0)
            assert(fee == 0, string.format('expected no teleport fee, got %d', fee))
        end)

        it('refuses an outpost teleport', function()
            player:addGil(1000)
            xi.conquest.vendorOnEventFinish(player, 2, xi.region.RONFAURE)

            assert(not player:hasStatusEffect(xi.effect.TELEPORT), 'the vendor teleported the player during the event')
        end)
    end)
end)
