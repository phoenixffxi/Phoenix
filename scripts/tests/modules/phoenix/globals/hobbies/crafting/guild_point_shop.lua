-----------------------------------
-- Phoenix guild point shops: 500 GP Aurora and Twilight crystals, post-era rewards locked behind rank 99.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix guild point shop', function()
    local player
    local notice = 'NOTICE: This item is not available on this server.'

    -- Sends one fishing guild shop selection and returns the recorded notices and event updates.
    local function selectFishingOption(option)
        local proxy, calls = moduleTest.recordingProxy(player, { printToPlayer = true, updateEvent = true })
        xi.crafting.guildPointOnEventUpdate(proxy, option, nil, xi.guild.FISHING)

        return calls
    end

    setup(function()
        player = xi.test.world:spawnPlayer()
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/globals/hobbies/crafting/guild_point_shop.lua')
    end)

    it('charges 500 guild points for Aurora and Twilight crystals', function()
        assert(xi.crafting.hqCrystals[7].cost == 500, string.format('Aurora: expected 500, got %s', tostring(xi.crafting.hqCrystals[7].cost)))
        assert(xi.crafting.hqCrystals[8].cost == 500, string.format('Twilight: expected 500, got %s', tostring(xi.crafting.hqCrystals[8].cost)))
    end)

    it('locks the 2010 emblems', function()
        local emblem = xi.crafting.guildItemTable[xi.guild.FISHING][7]
        assert(emblem.rank == 99, string.format('expected rank 99, got %s', tostring(emblem.rank)))
    end)

    describe('every locked reward #exhaustive', function()
        it('locks every post-era key item', function()
            local locked =
            {
                [xi.guild.FISHING     ] = 3,
                [xi.guild.WOODWORKING ] = 4,
                [xi.guild.SMITHING    ] = 4,
                [xi.guild.GOLDSMITHING] = 5,
                [xi.guild.CLOTHCRAFT  ] = 4,
                [xi.guild.LEATHERCRAFT] = 3,
                [xi.guild.BONECRAFT   ] = 3,
                [xi.guild.ALCHEMY     ] = 6,
                [xi.guild.COOKING     ] = 4,
            }

            for guildId, index in pairs(locked) do
                local rank = xi.crafting.guildKeyItemTable[guildId][index].rank
                assert(rank == 99, string.format('guild %d key item %d: expected rank 99, got %s', guildId, index, tostring(rank)))
            end
        end)

        it('locks every post-era item, signboards and rings included', function()
            local locked =
            {
                [xi.guild.FISHING     ] = { 4, 6, 7 },
                [xi.guild.WOODWORKING ] = { 4, 5, 6, 7 },
                [xi.guild.SMITHING    ] = { 4, 5, 6, 7 },
                [xi.guild.GOLDSMITHING] = { 4, 5, 6, 7 },
                [xi.guild.CLOTHCRAFT  ] = { 4, 5, 6, 7 },
                [xi.guild.LEATHERCRAFT] = { 4, 5, 6, 7 },
                [xi.guild.BONECRAFT   ] = { 4, 5, 6, 7 },
                [xi.guild.ALCHEMY     ] = { 4, 5, 6, 7 },
                [xi.guild.COOKING     ] = { 4, 5, 6, 7 },
            }

            for guildId, indexes in pairs(locked) do
                for _, index in ipairs(indexes) do
                    local rank = xi.crafting.guildItemTable[guildId][index].rank
                    assert(rank == 99, string.format('guild %d item %d: expected rank 99, got %s', guildId, index, tostring(rank)))
                end
            end
        end)

        it('warns when a locked item or key item is picked, not an open one', function()
            -- Category 2 slot 3 is the emblem, category 1 slot 0 the belt, category 3 key item 4 the almanac.
            local emblemCalls  = selectFishingOption(11)
            local beltCalls    = selectFishingOption(4)
            local almanacCalls = selectFishingOption(140)

            assert(emblemCalls.printToPlayer[1] and emblemCalls.printToPlayer[1][1] == notice, 'no notice for the emblem')
            assert(#beltCalls.printToPlayer == 0, 'a notice for the open belt')
            assert(almanacCalls.printToPlayer[1] and almanacCalls.printToPlayer[1][1] == notice, 'no notice for the almanac')
        end)

        it('refuses analysis crystals with a notice', function()
            local calls = selectFishingOption(2)

            assert(calls.printToPlayer[1] and calls.printToPlayer[1][1] == notice, 'no notice for the analysis crystal')
            assert(#calls.updateEvent == 0, 'the shop went on to sell the analysis crystal')
        end)
    end)
end)
