-----------------------------------
-- Hides NPCs for unreleased content (ZNM, Colosseum, Nyzul Isle, Einherjar), shows NPCs the content
-- gate hides but Phoenix uses, and keeps the Pankration gates shut.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Every NPC the zone holds under that name; the module acts on all of them.
local function npcsNamed(zoneId, name)
    local npcs = GetZone(zoneId):queryEntitiesByName(name)
    assert(#npcs > 0, string.format('zone %d has no NPC named %s', zoneId, name))

    return npcs
end

local function assertHidden(zoneId, name)
    for _, npc in ipairs(npcsNamed(zoneId, name)) do
        assert(npc:getStatus() == xi.status.DISAPPEAR, string.format('%s (%d) is visible', name, npc:getID()))
    end
end

local function assertShown(zoneId, name, pos)
    for _, npc in ipairs(npcsNamed(zoneId, name)) do
        assert(npc:getStatus() == xi.status.NORMAL, string.format('%s (%d) is hidden', name, npc:getID()))

        local at = npc:getPos()
        assert(
            math.abs(at.x - pos[1]) < 0.01 and
            math.abs(at.y - pos[2]) < 0.01 and
            math.abs(at.z - pos[3]) < 0.01,
            string.format('%s stands at (%.3f, %.3f, %.3f)', name, at.x, at.y, at.z)
        )
    end
end

describe('Phoenix NPC visibility', function()
    -- The module's lists, keyed by zone script name. The shown entries that phoenix/data already
    -- untags (Linkshell Concierges, Behemoth ???, Tales' Beginning in Lower Delkfutt's Tower and Norg)
    -- or that carry no tag (Fafnir and Adamantoise ???) are visible without the module, so they are left out.
    local zoneEntities =
    {
        Aht_Urhgan_Whitegate =
        {
            hidden       = { 'Giehnz', 'Ryo', 'Sanraku', 'Sashosho', 'Sorrowful_Sage' },
            untargetable = { '_1e7', '_1e9' },
        },

        Alzadaal_Undersea_Ruins = { hidden = { 'qm_armed_gears', 'qm_cheese_hoarder_gigiroon', 'qm_ob', 'qm_wulgaru' } },
        Arrapago_Reef           = { hidden = { 'qm1', 'qm2', 'qm3', 'qm4' } },
        Aydeewa_Subterrane      = { hidden = { 'qm1', 'qm3' } },
        Bhaflau_Thickets        = { hidden = { 'qm1', 'qm2' } },
        Caedarva_Mire           = { hidden = { 'qm1', 'qm2', 'qm3', 'qm4' } },
        Halvung                 = { hidden = { 'qm2', 'qm3', 'qm4' } },
        Lower_Jeuno             = { shown  = { { name = 'Tales_Beginning', pos = { -76.524, 0.000, -113.286 } } } },
        Mamook                  = { hidden = { 'qm1', 'qm2' } },
        Mount_Zhayolm           = { hidden = { 'qm1', 'qm2', 'qm3', 'qm4', 'qm5' } },
        Nashmau                 = { hidden = { 'Kilusha' } },
        Upper_Jeuno             = { hidden = { 'Afdeen' } },
        Wajaom_Woodlands        = { hidden = { 'qm1', 'qm2', 'qm3', 'qm4' } },
        Windurst_Walls          = { shown  = { { name = 'Tales_Beginning', pos = { -182.561, -2.456, 143.515 } } } },
    }

    it('applies its overrides', function()
        local targets = {}
        for zoneName in pairs(zoneEntities) do
            table.insert(targets, string.format('xi.zones.%s.Zone.onInitialize', zoneName))
        end

        for _, zoneName in ipairs({ 'Bastok_Mines', 'Behemoths_Dominion', 'Dragons_Aery', 'Lower_Delkfutts_Tower', 'Norg', 'Northern_San_dOria', 'Valley_of_Sorrows' }) do
            table.insert(targets, string.format('xi.zones.%s.Zone.onInitialize', zoneName))
        end

        moduleTest.assertOverridesApplied('modules/phoenix/lua/zones/npc_visibility.lua', { targets = targets })
    end)

    it('hides the ZNM pop item seller and shuts the Colosseum gate in Whitegate', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })

        assertHidden(player:getZoneID(), 'Sanraku')

        local gate = npcsNamed(player:getZoneID(), '_1e7')[1]
        assert(gate:getUntargetable(), 'Gate: The Colosseum is targetable')
    end)

    it('shows Tales\' Beginning in Lower Jeuno', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })

        assertShown(player:getZoneID(), 'Tales_Beginning', zoneEntities.Lower_Jeuno.shown[1].pos)
    end)

    describe('every listed NPC #exhaustive', function()
        ---@type CClientEntityPair
        local player

        setup(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
        end)

        local zoneNames = {}
        for zoneName in pairs(zoneEntities) do
            table.insert(zoneNames, zoneName)
        end

        table.sort(zoneNames)

        for _, zoneName in ipairs(zoneNames) do
            local entities = zoneEntities[zoneName]

            it(string.format('adjusts the NPCs in %s', zoneName), function()
                local zoneId = xi.zone[string.upper(zoneName)]
                player:gotoZone(zoneId)

                for _, name in ipairs(entities.hidden or {}) do
                    assertHidden(zoneId, name)
                end

                for _, entry in ipairs(entities.shown or {}) do
                    assertShown(zoneId, entry.name, entry.pos)
                end

                for _, name in ipairs(entities.untargetable or {}) do
                    for _, npc in ipairs(npcsNamed(zoneId, name)) do
                        assert(npc:getUntargetable(), string.format('%s (%d) is targetable', name, npc:getID()))
                    end
                end
            end)
        end

        it('keeps the Pankration gate from moving players to The Colosseum', function()
            local gatePlayer = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
            local gate       = npcsNamed(xi.zone.AHT_URHGAN_WHITEGATE, '_1e9')[1]
            local gateScript = xi.zones.Aht_Urhgan_Whitegate.npcs._1e9

            gateScript.onTrigger(gatePlayer, gate)
            gatePlayer.events:expectNotInEvent()

            -- Option 1 on the entry event is the one that used to send players in.
            local x = gatePlayer:getXPos()
            gateScript.onEventFinish(gatePlayer, 133, 1, gate)
            assert(gatePlayer:getXPos() == x, 'the gate moved the player toward The Colosseum')
        end)
    end)
end)
