-----------------------------------
-- Guild merchants open the shared-stock guild shop instead of the generic guild stock.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Triggers the NPC and asserts it handed itself to the guild shop.
local function assertOpensGuildShop(player, npcName)
    local shop = stub('xi.guildShops.onTrigger', false)
    stub('xi.shop.generalGuild')

    player.entities:gotoAndTrigger(npcName)

    assert(#shop.calls == 1, string.format('%s opened the guild shop %d times', npcName, #shop.calls))
    assert(shop.calls[1].args[2]:getName() == npcName, string.format('%s opened the guild shop of %s', npcName, shop.calls[1].args[2]:getName()))
end

describe('Phoenix era guild shared stocks', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/zones/era_guild_shared_stocks.lua')
    end)

    it('Vicious Eye opens the guild shop', function()
        assertOpensGuildShop(xi.test.world:spawnPlayer({ zone = xi.zone.METALWORKS }), 'Vicious_Eye')
    end)

    describe('every guild merchant #exhaustive', function()
        local merchants =
        {
            { 'Bastok Markets',     xi.zone.BASTOK_MARKETS,     { 'Teerth' }                  },
            { 'Bastok Mines',       xi.zone.BASTOK_MINES,       { 'Odoba' }                   },
            { 'Lower Jeuno',        xi.zone.LOWER_JEUNO,        { 'Akamafula', 'Amalasanda' } },
            { 'Metalworks',         xi.zone.METALWORKS,         { 'Vicious_Eye' }             },
            { 'Mhaura',             xi.zone.MHAURA,             { 'Mololo', 'Celestina' }     },
            { 'Northern San dOria', xi.zone.NORTHERN_SAN_DORIA, { 'Lucretia', 'Cauzeriste' }  },
            { 'Selbina',            xi.zone.SELBINA,            { 'Gibol' }                   },
            { 'Southern San dOria', xi.zone.SOUTHERN_SAN_DORIA, { 'Cletae' }                  },
            { 'Windurst Waters',    xi.zone.WINDURST_WATERS,    { 'Chomo_Jinjahl' }           },
            { 'Windurst Woods',     xi.zone.WINDURST_WOODS,     { 'Meriri', 'Retto-Marutto' } },
        }

        for _, entry in ipairs(merchants) do
            describe(entry[1], function()
                local player

                setup(function()
                    player = xi.test.world:spawnPlayer({ zone = entry[2] })

                    -- The Tenshodo merchants only deal with members.
                    player:addKeyItem(xi.keyItem.TENSHODO_MEMBERS_CARD)
                end)

                for _, npcName in ipairs(entry[3]) do
                    it(string.format('%s opens the guild shop', npcName), function()
                        assertOpensGuildShop(player, npcName)
                    end)
                end
            end)
        end
    end)
end)
