-----------------------------------
-- Ominous Cloud makes toolbags only for the original ninja tools, so no fuda, later tools or shuriken.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Trades a stack of a tool and a Wijnruit, and checks the stack comes back without a toolbag.
local function expectRefused(zoneId, toolId, toolbagId)
    local player = xi.test.world:spawnPlayer({ zone = zoneId })
    player:addItem(toolId, 99)
    player:addItem(xi.item.WIJNRUIT)

    -- A conquest regional NPC, shown only in the leading nation's city.
    local cloud
    for _, entity in pairs(GetZone(zoneId):queryEntitiesByName('Ominous_Cloud')) do
        if math.abs(entity:getXPos()) > 0 then
            cloud = entity
        end
    end

    local status = cloud:getStatus()
    cloud:setStatus(xi.status.NORMAL)
    player.actions:tradeNpc(cloud, { { itemId = toolId, quantity = 99 }, xi.item.WIJNRUIT })
    cloud:setStatus(status)

    player.assert.no:hasItem(toolbagId)
    assert(player:getItemCount(toolId) == 99, string.format('expected 99 tools back, got %d', player:getItemCount(toolId)))
end

describe('Era Ominous Cloud', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/zones/ominous_cloud_toolbags.lua', {
            targets =
            {
                'xi.zones.Port_Bastok.npcs.Ominous_Cloud.onTrade',
                'xi.zones.Southern_San_dOria.npcs.Ominous_Cloud.onTrade',
                'xi.zones.Windurst_Woods.npcs.Ominous_Cloud.onTrade',
            },
        })
    end)

    it('makes no Inoshishinofuda toolbag in Port Bastok', function()
        expectRefused(xi.zone.PORT_BASTOK, xi.item.INOSHISHINOFUDA, xi.item.TOOLBAG_INOSHISHINOFUDA)
    end)

    describe('every Ominous Cloud #exhaustive', function()
        it('makes no Shuriken pouch in Southern San d\'Oria', function()
            expectRefused(xi.zone.SOUTHERN_SAN_DORIA, xi.item.SHURIKEN, xi.item.SHURIKEN_POUCH)
        end)

        it('makes no Soshi toolbag in Windurst Woods', function()
            expectRefused(xi.zone.WINDURST_WOODS, xi.item.SOSHI, xi.item.TOOLBAG_SOSHI)
        end)
    end)
end)
