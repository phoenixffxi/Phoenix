describe('Guild shop price curves', function()
    local function priceAt(player, name, itemId, stock, side)
        local state               = xi.guildShops.state[name]
        state.items[itemId].stock = stock
        state.lastRoll            = -1 -- the next roll locks the price from the seeded stock, with no restock

        local list  = side == 'sell' and player.actions:guildSellList() or player.actions:guildBuyList()
        local entry = list[itemId]
        return entry and entry.price
    end

    local function checkCurve(player, name, curve)
        for _, point in ipairs(curve.points) do
            local stock, retail = point[1], point[2]
            local got = priceAt(player, name, curve.item, stock, curve.side)

            assert(got == retail,
                string.format('%s @ stock %d: got %s, retail %d',
                    curve.label, stock, tostring(got), retail))
        end
    end

    describe('Kamilah', function()
        ---@type CClientEntityPair
        local player
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.MHAURA })
            player.entities:gotoAndTrigger('Kamilah')
        end)

        local curves =
            {
                {
                    side   = 'buy',
                    label  = 'Steel Ingot',
                    item   = xi.item.STEEL_INGOT,
                    points =
                    {
                        { 10,  22890 },
                        { 20,  19320 },
                        { 30,  15750 },
                        { 40,  12390 },
                        { 50,  8820 },
                        { 60,  5250 },
                        { 70,  4830 },
                        { 80,  4383 },
                        { 85,  4173 },
                        { 90,  3937 },
                        { 95,  3727 },
                        { 100, 3517 },
                    },
                },
                {
                    side   = 'buy',
                    label  = 'Bronze Sheet',
                    item   = xi.item.BRONZE_SHEET,
                    points =
                    {
                        { 2,  448 },
                        { 6,  423 },
                        { 12, 386 },
                        { 20, 338 },
                        { 30, 276 },
                        { 36, 239 },
                        { 49, 161 },
                        { 60, 92 },
                        { 66, 87 },
                        { 68, 86 },
                    },
                },
                {
                    side   = 'buy',
                    label  = 'Iron Sheet',
                    item   = xi.item.IRON_SHEET,
                    points =
                    {
                        { 12, 22680 }, { 100, 3618 },
                    },
                },
                {
                    side   = 'sell',
                    label  = 'Iron Sheet',
                    item   = xi.item.IRON_SHEET,
                    points =
                    {
                        { 0, 1350 }, { 9, 1316 }, { 10, 1314 }, { 11, 1309 }, { 12, 1305 },
                    },
                },
                {
                    side   = 'sell',
                    label  = 'Steel Ingot',
                    item   = xi.item.STEEL_INGOT,
                    points =
                    {
                        { 10,  1095 },
                        { 20,  1063 },
                        { 30,  1031 },
                        { 40,  1001 },
                        { 50,  969 },
                        { 60,  937 },
                        { 70,  907 },
                        { 80,  875 },
                        { 90,  843 },
                        { 100, 813 },
                    },
                },
                {
                    side   = 'sell',
                    label  = 'Bronze Sheet',
                    item   = xi.item.BRONZE_SHEET,
                    points =
                    {
                        { 2,  34 },
                        { 6,  33 },
                        { 16, 33 },
                        { 18, 32 },
                        { 28, 31 },
                        { 36, 31 },
                        { 49, 29 },
                        { 60, 28 },
                        { 68, 28 },
                        { 72, 27 },
                    },
                },
            }

        for _, curve in ipairs(curves) do
            it(curve.side .. ' -- ' .. curve.label, function()
                checkCurve(player, 'Kamilah', curve)
            end)
        end
    end)

    describe('Beugungel', function()
        ---@type CClientEntityPair
        local player
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.CARPENTERS_LANDING })
            player.entities:gotoAndTrigger('Beugungel')
        end)

        local curves =
            {
                {
                    side   = 'buy',
                    label  = 'Walnut Log',
                    item   = xi.item.WALNUT_LOG,
                    points =
                    {
                        { 20,  3723 },
                        { 40,  3142 },
                        { 60,  2562 },
                        { 80,  2015 },
                        { 100, 1434 },
                        { 120, 854 },
                        { 160, 713 },
                        { 180, 640 },
                    },
                },
                {
                    side = 'buy',
                    label = 'Hatchet',
                    item = xi.item.HATCHET,
                    points =
                    {
                        { 60,  1500 },
                        { 100, 840 },
                        { 120, 500 },
                        { 160, 375 },
                        { 180, 312 },
                    },
                },
            }

        for _, curve in ipairs(curves) do
            it(curve.side .. ' -- ' .. curve.label, function()
                checkCurve(player, 'Beugungel', curve)
            end)
        end
    end)

    describe('Yabby Tanmikey', function()
        ---@type CClientEntityPair
        local player
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.MHAURA })
            player.entities:gotoAndTrigger('Yabby_Tanmikey')
        end)

        local curves =
            {
                {
                    side   = 'buy',
                    label  = 'Chunk of Silver Ore',
                    item   = xi.item.CHUNK_OF_SILVER_ORE,
                    points =
                    {
                        { 10,  1965 },
                        { 11,  1948 },
                        { 20,  1831 },
                        { 30,  1680 },
                        { 50,  1411 },
                        { 70,  1125 },
                        { 90,  840 },
                        { 100, 705 },
                    },
                },
                {
                    side   = 'buy',
                    label  = 'Chunk of Mythril Ore',
                    item   = xi.item.CHUNK_OF_MYTHRIL_ORE,
                    points =
                    {
                        { 1,   9200 },
                        { 10,  2000 },
                        { 28,  1910 },
                        { 100, 1530 },
                    },
                },
                {
                    side   = 'buy',
                    label  = 'Chunk of Gold Ore',
                    item   = xi.item.CHUNK_OF_GOLD_ORE,
                    points =
                    {
                        { 1, 21252 }, { 2, 19404 },
                    },
                },
                {
                    side   = 'buy',
                    label  = 'Brass Ingot',
                    item   = xi.item.BRASS_INGOT,
                    points =
                    {
                        { 1, 920 }, { 2, 840 },
                    },
                },
                {
                    side   = 'buy',
                    label  = 'Red Rock',
                    item   = xi.item.RED_ROCK,
                    points =
                    {
                        { 1,  6832 },
                        { 2,  6664 },
                        { 3,  6440 },
                        { 5,  6104 },
                        { 10, 5152 },
                        { 15, 4200 },
                        { 20, 3304 },
                        { 22, 2912 },
                        { 35, 1288 },
                    },
                },
            }

        for _, curve in ipairs(curves) do
            it(curve.side .. ' -- ' .. curve.label, function()
                checkCurve(player, 'Yabby_Tanmikey', curve)
            end)
        end
    end)
end)
