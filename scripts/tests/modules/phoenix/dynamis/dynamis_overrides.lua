-----------------------------------
-- 75 era Dynamis: entry by Timeless Hourglass trade at the markers, Timeless Hourglasses sold for gil
-- with no refund, no ejection on zone-in, era handlers per mob type, and the win ??? rewards.
-- Covers: modules/phoenix/dynamis/lua/dynamis_items.lua
-----------------------------------
local moduleTest   = require('scripts.tests.helpers.modules')
local packetReader = require('scripts.tests.helpers.packet_reader')

-- Stubs the named xi.dynamis functions and returns how often each gets called.
local function countCalls(names)
    local counts = {}
    for _, name in ipairs(names) do
        counts[name] = 0
        stub('xi.dynamis.' .. name, function()
            counts[name] = counts[name] + 1
        end)
    end

    return counts
end

local function assertCalled(counts, where)
    for name, count in pairs(counts) do
        assert(count > 0, string.format('%s never reached xi.dynamis.%s', where, name))
    end
end

local entryMarkers =
{
    { 'Southern_San_dOria', 'Trail_Markings' },
    { 'Bastok_Mines',       'Trail_Markings' },
    { 'Windurst_Walls',     'Trail_Markings' },
    { 'RuLude_Gardens',     'Trail_Markings' },
    { 'Beaucedine_Glacier', 'Trail_Markings' },
    { 'Xarcabard',          'Trail_Markings' },
    { 'Valkurm_Dunes',      'Hieroglyphics'  },
    { 'Buburimu_Peninsula', 'Hieroglyphics'  },
    { 'Qufim_Island',       'Hieroglyphics'  },
    { 'Tavnazian_Safehold', 'Hieroglyphics'  },
}

-- assertOverridesApplied options for the marker overrides; upstream markers have no trade or event update handler.
local function markerTargets(markers)
    local targets    = {}
    local newTargets = {}
    for _, marker in ipairs(markers) do
        local path = string.format('xi.zones.%s.npcs.%s', marker[1], marker[2])
        table.insert(targets, path .. '.onTrade')
        table.insert(targets, path .. '.onEventUpdate')
        table.insert(targets, path .. '.onEventFinish')
        table.insert(newTargets, path .. '.onTrade')
        table.insert(newTargets, path .. '.onEventUpdate')
    end

    return { targets = targets, newTargets = newTargets }
end

describe('Phoenix era Dynamis', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/dynamis/lua/dynamis_overrides.lua', markerTargets({ entryMarkers[1] }))
    end)

    it('applies the Perpetual Hourglass overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/dynamis/lua/dynamis_items.lua')
    end)

    it('opens registration for a Timeless Hourglass traded at the entry marker', function()
        local player    = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA, job = xi.job.WAR, level = 75 })
        local entryInfo = xi.dynamis.entryInfoEra[xi.zone.SOUTHERN_SAN_DORIA]
        player:addKeyItem(xi.keyItem.VIAL_OF_SHROUDED_SAND)
        player:addItem(xi.item.TIMELESS_HOURGLASS)

        player.actions:tradeNpc('Trail_Markings', { xi.item.TIMELESS_HOURGLASS }, { eventId = entryInfo.csRegisterGlass })

        -- The hourglass is only taken once registration goes through.
        player.assert:hasItem(xi.item.TIMELESS_HOURGLASS)
    end)

    it('sells a Timeless Hourglass for gil at the beastmen stronghold goblins', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.DAVOI })
        local cost   = xi.dynamis.settings.TIMELESS_HOURGLASS_COST
        local gil    = player:getGil()
        player:addKeyItem(xi.keyItem.VIAL_OF_SHROUDED_SAND)
        player:addGil(cost)

        player.actions:tradeNpc('Lootblox', { { itemId = xi.item.GIL, quantity = cost } }, { eventId = 134 })

        player.assert:hasItem(xi.item.TIMELESS_HOURGLASS)
        player.assert.no:hasKI(xi.keyItem.PRISMATIC_HOURGLASS)
        assert(player:getGil() == gil, string.format('gil changed by %+d', player:getGil() - gil))
    end)

    describe('in Dynamis - San d\'Oria', function()
        ---@type CClientEntityPair
        local player

        setup(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.DYNAMIS_SAN_DORIA })
        end)

        it('lets a player without the Dynamis effect stay', function()
            -- The zone tick would eject a player without a Perpetual Hourglass before the check.
            stub('xi.dynamis.dynamisTick')
            local visitor = xi.test.world:spawnPlayer({ zone = xi.zone.DYNAMIS_SAN_DORIA })
            assert(visitor:getZoneID() == xi.zone.DYNAMIS_SAN_DORIA, 'the player was moved out of Dynamis')

            -- Upstream answers with the ejection event, 100.
            local cs = xi.zones['Dynamis-San_dOria'].Zone.onZoneIn(visitor, xi.zone.SOUTHERN_SAN_DORIA)

            assert(cs == -1, string.format('zone-in answered event %d', cs))
        end)

        it('sends a statue death to the era statue handler', function()
            local statue = GetZone(xi.zone.DYNAMIS_SAN_DORIA):queryEntitiesByName('Serjeant_Tombstone')[1]
            local counts = countCalls({ 'onStatueDeath' })

            xi.zones['Dynamis-San_dOria'].mobs.Serjeant_Tombstone.onMobDeath(statue, player, { isKiller = true })

            assertCalled(counts, 'Serjeant Tombstone death')
        end)
    end)

    describe('entry markers #exhaustive', function()
        it('applies every entry marker override', function()
            moduleTest.assertOverridesApplied('modules/phoenix/dynamis/lua/dynamis_overrides.lua', markerTargets(entryMarkers))
        end)

        it('plays the win cutscene for a holder of the win key item and marks it seen', function()
            local player    = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA, job = xi.job.WAR, level = 75 })
            local entryInfo = xi.dynamis.entryInfoEra[xi.zone.SOUTHERN_SAN_DORIA]
            player:addKeyItem(entryInfo.winKI)

            player.entities:gotoAndTrigger('Trail_Markings', { eventId = entryInfo.csWin })

            assert(player:getCharVar(entryInfo.hasSeenWinCSVar) == 1, 'the win cutscene is not marked seen')
        end)
    end)

    describe('hourglass goblins #exhaustive', function()
        local cost

        setup(function()
            cost = xi.dynamis.settings.TIMELESS_HOURGLASS_COST
        end)

        it('quotes the Timeless Hourglass price', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.DAVOI })
            player:addKeyItem(xi.keyItem.VIAL_OF_SHROUDED_SAND)
            player.packets:clear()

            player.entities:gotoAndTrigger('Lootblox', { eventId = 133 })

            local params = packetReader.lastEventStart(player).params
            assert(params[5] == cost, string.format('quoted %d gil in the hourglass slot', params[5]))
            assert(params[7] == cost, string.format('quoted %d gil for the Timeless Hourglass', params[7]))
        end)

        it('gives no refund for a Timeless Hourglass', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.DAVOI })
            player:addKeyItem(xi.keyItem.VIAL_OF_SHROUDED_SAND)
            player:addItem(xi.item.TIMELESS_HOURGLASS)

            player.actions:tradeNpc('Lootblox', { xi.item.TIMELESS_HOURGLASS })

            player.events:expectNotInEvent()
            player.assert:hasItem(xi.item.TIMELESS_HOURGLASS)
        end)

        local goblins =
        {
            { zone = xi.zone.BEADEAUX,       npc = 'Haggleblix', eventId = 134 },
            { zone = xi.zone.CASTLE_OZTROJA, npc = 'Antiqix',    eventId = 54  },
        }

        for _, goblin in ipairs(goblins) do
            it(string.format('sells a Timeless Hourglass at %s', goblin.npc), function()
                local player = xi.test.world:spawnPlayer({ zone = goblin.zone })
                player:addKeyItem(xi.keyItem.VIAL_OF_SHROUDED_SAND)
                player:addGil(cost)

                player.actions:tradeNpc(goblin.npc, { { itemId = xi.item.GIL, quantity = cost } }, { eventId = goblin.eventId })

                player.assert:hasItem(xi.item.TIMELESS_HOURGLASS)
            end)
        end
    end)

    describe('win ??? and procs #exhaustive', function()
        ---@type CClientEntityPair
        local player

        setup(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.DYNAMIS_SAN_DORIA })
        end)

        it('gives the win key item from the ???', function()
            local qm = GetZone(xi.zone.DYNAMIS_SAN_DORIA):queryEntitiesByName('qm0')[1]

            xi.dynamis.qmOnTrigger(player, qm)

            player.assert:hasKI(xi.dynamis.dynaInfoEra[xi.zone.DYNAMIS_SAN_DORIA].winKI)
        end)

        it('never procs a monster', function()
            local mob = GetZone(xi.zone.DYNAMIS_SAN_DORIA):queryEntitiesByName('Vanguard_Footsoldier')[1]
            player:addKeyItem(xi.keyItem.CRIMSON_GRANULES_OF_TIME)
            player:addKeyItem(xi.keyItem.AZURE_GRANULES_OF_TIME)
            player:addKeyItem(xi.keyItem.AMBER_GRANULES_OF_TIME)

            xi.dynamis.procMonster(mob, player)

            assert(mob:getLocalVar('dynamis_proc') == 0, 'the monster was procced')
        end)
    end)

    describe('each Dynamis zone #exhaustive', function()
        -- One mob per zone, with the era handlers its overridden event runs.
        local spots =
        {
            { name = 'Dynamis-San_dOria',  zone = xi.zone.DYNAMIS_SAN_DORIA,  mob = 'Vanguard_Footsoldier', event = 'onMobDeath',  calls = { 'onMobDeath' } },
            { name = 'Dynamis-Bastok',     zone = xi.zone.DYNAMIS_BASTOK,     mob = 'GuDha_Effigy',         event = 'onMobDeath',  calls = { 'onBossDeath' } },
            { name = 'Dynamis-Windurst',   zone = xi.zone.DYNAMIS_WINDURST,   mob = 'Avatar_Icon',          event = 'onMobFight',  calls = { 'onStatueFight' } },
            { name = 'Dynamis-Jeuno',      zone = xi.zone.DYNAMIS_JEUNO,      mob = 'Goblin_Golem',         event = 'onMobRoam',   calls = { 'onMobRoam', 'onBossRoam' } },
            { name = 'Dynamis-Beaucedine', zone = xi.zone.DYNAMIS_BEAUCEDINE, mob = 'Dynamis_Effigy',       event = 'onMobEngage', calls = { 'onSharedEngage', 'checkEyeColor' } },
            { name = 'Dynamis-Xarcabard',  zone = xi.zone.DYNAMIS_XARCABARD,  mob = 'Kindred_Summoner',     event = 'onMobFight',  calls = { 'summonerOnFight' } },
            { name = 'Dynamis-Valkurm',    zone = xi.zone.DYNAMIS_VALKURM,    mob = 'Nightmare_Morbol',     event = 'onMobSpawn',  calls = { 'onMobSpawn', 'generatePath' } },
            { name = 'Dynamis-Buburimu',   zone = xi.zone.DYNAMIS_BUBURIMU,   mob = 'Apocalyptic_Beast',    event = 'onMobSpawn',  calls = { 'generalInfo', 'onBossSpawn' }, qm = 'sjQMOnTrigger', marks = 'currentPath' },
            { name = 'Dynamis-Qufim',      zone = xi.zone.DYNAMIS_QUFIM,      mob = 'Nightmare_Kraken',     event = 'onMobEngage', calls = { 'onSharedEngage' }, qm = 'sjQMOnTrigger' },
            { name = 'Dynamis-Tavnazia',   zone = xi.zone.DYNAMIS_TAVNAZIA,   mob = 'Vanguard_Eye',         event = 'onMobSpawn',  calls = { 'statueOnSpawn' }, qm = 'teOnTrigger', tavnazia = true },
        }

        for _, spot in ipairs(spots) do
            it(string.format('runs the era zone and %s handlers in %s', spot.mob, spot.name), function()
                -- Stubbing dynamisTick before zoning in also keeps the zone from ejecting the player.
                local names = { 'clearOnInit', 'dynamisTick' }
                for _, name in ipairs(spot.calls) do
                    table.insert(names, name)
                end

                if spot.qm then
                    table.insert(names, spot.qm)
                end

                if spot.tavnazia then
                    table.insert(names, 'onZoneInitTav')
                    table.insert(names, 'onTriggerAreaEnterTav')
                end

                local counts = countCalls(names)
                local player = xi.test.world:spawnPlayer({ zone = spot.zone })
                local script = xi.zones[spot.name]
                local zone   = GetZone(spot.zone)
                assert(zone, string.format('no zone %d', spot.zone))
                local mob    = zone:queryEntitiesByName(spot.mob)[1]
                assert(player:getZoneID() == spot.zone, 'the player was moved out of Dynamis')
                assert(mob, string.format('no %s in %s', spot.mob, spot.name))

                -- Upstream answers with the ejection event, 100.
                local cs = script.Zone.onZoneIn(player, 0)
                assert(cs == -1, string.format('zone-in answered event %d', cs))

                script.Zone.onInitialize(zone)
                script.Zone.onZoneTick(zone)
                script.mobs[spot.mob][spot.event](mob, player, { isKiller = true })

                if spot.marks then
                    assert(mob:getLocalVar(spot.marks) == 1, string.format('%s did not run its own %s handler', spot.mob, spot.event))
                end

                if spot.qm then
                    local qm = zone:queryEntitiesByName('qm1')[1]
                    assert(qm, string.format('no qm1 in %s', spot.name))
                    script.npcs.qm1.onTrigger(player, qm)
                end

                if spot.tavnazia then
                    script.npcs.qm2.onTrigger(player, zone:queryEntitiesByName('qm2')[1])
                    script.Zone.onTriggerAreaEnter(player, nil)
                end

                assertCalled(counts, spot.name)
            end)
        end
    end)
end)
