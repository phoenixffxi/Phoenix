-----------------------------------
-- Map vendors sell only the maps each carried before the 2014 list merges, at the old prices.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- The menu mask for slots 0-31 the vendor answers with: a set bit hides the map, so only the vendor's own slots are clear.
local function expectedMask(slots)
    local mask = -1
    for _, slot in ipairs(slots) do
        if slot < 32 then
            mask = bit.band(mask, bit.bnot(bit.lshift(1, slot)))
        end
    end

    return mask
end

describe('Era map vendors', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/globals/maps.lua')
    end)

    describe('Karine', function()
        local player

        setup(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.BASTOK_MARKETS })
        end)

        it('lists only the maps she sold', function()
            player.entities:gotoAndTrigger('Karine')
            local mask = player.events:updateWithPosition(210, 0)
            player.events:finish(210, 0)

            assert(mask, 'Karine sent no map list')
            assert(bit.band(mask, bit.lshift(1, 11)) ~= 0, 'the Map of Giddeus (slot 11) is on sale')
            assert(bit.band(mask, bit.lshift(1, 10)) == 0, 'the Map of Beadeaux (slot 10) is not on sale')
        end)

        it('charges 3000 gil for the Map of Beadeaux', function()
            player:setGil(5000)
            player.entities:gotoAndTrigger('Karine')
            player.events:updateWithPosition(210, bit.bor(bit.lshift(10, 16), 1))
            player.events:finish(210, 0)

            assert(player:hasKeyItem(xi.keyItem.MAP_OF_BEADEAUX), 'the Map of Beadeaux was not sold')
            assert(player:getGil() == 2000, string.format('expected 2000 gil left, got %d', player:getGil()))

            player:delKeyItem(xi.keyItem.MAP_OF_BEADEAUX)
        end)
    end)

    describe('every vendor #exhaustive', function()
        -- Menu slot: key item and era price.
        local maps =
        {
            [ 0] = { xi.keyItem.MAP_OF_THE_SAN_DORIA_AREA,      200 },
            [ 1] = { xi.keyItem.MAP_OF_THE_BASTOK_AREA,         200 },
            [ 2] = { xi.keyItem.MAP_OF_THE_WINDURST_AREA,       200 },
            [ 3] = { xi.keyItem.MAP_OF_THE_JEUNO_AREA,          600 },
            [ 4] = { xi.keyItem.MAP_OF_ORDELLES_CAVES,          600 },
            [ 5] = { xi.keyItem.MAP_OF_GHELSBA,                 600 },
            [ 6] = { xi.keyItem.MAP_OF_DAVOI,                  3000 },
            [ 7] = { xi.keyItem.MAP_OF_CARPENTERS_LANDING,     3000 },
            [ 8] = { xi.keyItem.MAP_OF_THE_ZERUHN_MINES,        200 },
            [ 9] = { xi.keyItem.MAP_OF_THE_PALBOROUGH_MINES,    600 },
            [10] = { xi.keyItem.MAP_OF_BEADEAUX,               3000 },
            [11] = { xi.keyItem.MAP_OF_GIDDEUS,                 600 },
            [12] = { xi.keyItem.MAP_OF_CASTLE_OZTROJA,         3000 },
            [13] = { xi.keyItem.MAP_OF_THE_MAZE_OF_SHAKHRAMI,   600 },
            [14] = { xi.keyItem.MAP_OF_THE_LITELOR_REGION,     3000 },
            [15] = { xi.keyItem.MAP_OF_BIBIKI_BAY,             3000 },
            [16] = { xi.keyItem.MAP_OF_QUFIM_ISLAND,           3000 },
            [17] = { xi.keyItem.MAP_OF_THE_ELDIEME_NECROPOLIS, 3000 },
            [18] = { xi.keyItem.MAP_OF_THE_GARLAIGE_CITADEL,   3000 },
            [19] = { xi.keyItem.MAP_OF_THE_ELSHIMO_REGIONS,    3000 },
            [32] = { xi.keyItem.MAP_OF_THE_KUZOTZ_REGION,      3000 },
            [37] = { xi.keyItem.MAP_OF_THE_KORROLOKA_TUNNEL,   3000 },
            [44] = { xi.keyItem.MAP_OF_THE_VOLLBOW_REGION,     3000 },
            [58] = { xi.keyItem.MAP_OF_AL_ZAHBI,                600 },
            [59] = { xi.keyItem.MAP_OF_NASHMAU,                3000 },
            [60] = { xi.keyItem.MAP_OF_WAJAOM_WOODLANDS,       3000 },
            [68] = { xi.keyItem.MAP_OF_BHAFLAU_THICKETS,       3000 },
        }

        local vendors =
        {
            { name = 'Ashu_Bolkhomo',   zone = xi.zone.RABAO,                event =  1006, slots = { 32, 37, 44 }                       },
            { name = 'Elesca',          zone = xi.zone.NORTHERN_SAN_DORIA,   event =   567, slots = { 0, 1, 2, 3, 4, 5, 6, 7 }           },
            { name = 'Karine',          zone = xi.zone.BASTOK_MARKETS,       event =   210, slots = { 0, 1, 2, 3, 8, 9, 10 }             },
            { name = 'Lombaria',        zone = xi.zone.SELBINA,              event =   500, slots = { 0, 1, 2, 3 }                       },
            { name = 'Ludwig',          zone = xi.zone.MHAURA,               event =   500, slots = { 0, 1, 2, 3, 14, 15 }               },
            { name = 'Mhoji_Roccoruh',  zone = xi.zone.PORT_WINDURST,        event = 10000, slots = { 0, 1, 2, 3, 11, 12, 13 }           },
            { name = 'Pehki_Machumaht', zone = xi.zone.WINDURST_WOODS,       event = 10000, slots = { 0, 1, 2, 3, 11, 12, 13 }           },
            { name = 'Promurouve',      zone = xi.zone.LOWER_JEUNO,          event = 10000, slots = { 0, 1, 2, 3, 16, 17, 18, 19 }       },
            { name = 'Rex',             zone = xi.zone.PORT_BASTOK,          event =   115, slots = { 0, 1, 2, 3, 8, 9, 10 }             },
            { name = 'Riyadahf',        zone = xi.zone.AHT_URHGAN_WHITEGATE, event =   563, slots = { 58, 59, 60, 68 }                   },
            { name = 'Rusese',          zone = xi.zone.UPPER_JEUNO,          event = 10000, slots = { 0, 1, 2, 3, 16, 17, 18, 19 }       },
            { name = 'Violitte',        zone = xi.zone.SOUTHERN_SAN_DORIA,   event =   595, slots = { 0, 1, 2, 3, 4, 5, 6, 7 }           },
        }

        for _, vendor in ipairs(vendors) do
            it(string.format('%s sells only the era maps at the era prices', vendor.name), function()
                local player = xi.test.world:spawnPlayer({ zone = vendor.zone })
                player.entities:gotoAndTrigger(vendor.name)

                local mask = player.events:updateWithPosition(vendor.event, 0)
                assert(mask == expectedMask(vendor.slots), string.format('%s sent menu mask %s, expected %s', vendor.name, tostring(mask), expectedMask(vendor.slots)))

                -- A crafted purchase of a map the vendor never carried is refused.
                player:setGil(30000)
                player.events:updateWithPosition(vendor.event, bit.bor(bit.lshift(20, 16), 1))
                assert(not player:hasKeyItem(xi.keyItem.MAP_OF_THE_NORTHLANDS_AREA), string.format('%s sold the Map of the Northlands Area', vendor.name))
                assert(player:getGil() == 30000, string.format('%s took gil for a refused map', vendor.name))

                for _, slot in ipairs(vendor.slots) do
                    local keyItem = maps[slot][1]
                    local price   = maps[slot][2]
                    local option  = bit.bor(bit.lshift(slot, 16), 1)

                    player:setGil(price - 1)
                    player.events:updateWithPosition(vendor.event, option)
                    assert(not player:hasKeyItem(keyItem), string.format('%s sold slot %d for less than %d gil', vendor.name, slot, price))

                    player:setGil(price)
                    mask = player.events:updateWithPosition(vendor.event, option)
                    assert(player:hasKeyItem(keyItem), string.format('%s did not sell slot %d for %d gil', vendor.name, slot, price))
                    assert(player:getGil() == 0, string.format('%s charged %d gil for slot %d, expected %d', vendor.name, price - player:getGil(), slot, price))
                end

                -- Owned maps are hidden as well, so the whole first word is set.
                assert(mask == -1, string.format('%s still lists maps after the player bought them all (mask %s)', vendor.name, tostring(mask)))

                player.events:finish(vendor.event, 0)
            end)
        end
    end)
end)
