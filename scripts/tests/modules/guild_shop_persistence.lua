-----------------------------------
-- Verifies the 'guild_shop_persistence' module (listed in modules/init.txt)
-- puts saved rows back the way each case needs, and reports only the rows
-- that changed since the last save.
--
-- See: modules/phoenix/lua/custom/guild_shop_persistence.lua
-----------------------------------
describe('Module: guild_shop_persistence', function()
    ---@type CClientEntityPair
    local player
    local persistence

    local shopName = 'Kamilah'
    local probe    = xi.item.CHUNK_OF_TIN_ORE

    local function configItems()
        return xi.data.guildShops[shopName].stock
    end

    local function cfgOf(itemId)
        for _, cfg in ipairs(configItems()) do
            if cfg.id == itemId then
                return cfg
            end
        end
    end

    -- A saved row for every configured item, with prices no roll would produce.
    local function savedRows(lastRoll)
        local rows = {}
        for i, cfg in ipairs(configItems()) do
            rows[#rows + 1] =
            {
                shop      = shopName,
                itemId    = cfg.id,
                stock     = cfg.initial,
                buyPrice  = 100000 + i,
                sellPrice = 50000 + i,
                offered   = 1,
                lastRoll  = lastRoll,
            }
        end

        return rows
    end

    local function rowFor(rows, itemId)
        for i, row in ipairs(rows) do
            if row.itemId == itemId then
                return row, i
            end
        end
    end

    -- Other suites leave their own shops in state, so only count this shop's rows.
    local function changedRows(deltas)
        local mine = {}
        for _, delta in ipairs(deltas) do
            if delta.shop == shopName then
                mine[#mine + 1] = delta
            end
        end

        return mine
    end

    local function open()
        xi.test.world:setVanaTime(8, 0)
        player.entities:gotoAndTrigger(shopName)
    end

    before_each(function()
        persistence = xi.guildShops.persistence
        assert(persistence, 'the guild_shop_persistence module is not loaded, check modules/init.txt')

        player = xi.test.world:spawnPlayer({ zone = xi.zone.MHAURA })
        xi.guildShops.state[shopName] = nil
    end)

    after_each(function()
        xi.guildShops.state[shopName] = nil
    end)

    it('puts a full snapshot back with its prices and lastRoll intact', function()
        local today  = VanadielUniqueDay()
        local result = persistence.restore(savedRows(today))
        local state  = xi.guildShops.state[shopName]

        assert(result.restored == 1, 'shop not counted as restored')
        assert(result.reRolled == 0, 'full snapshot was set to re-roll')
        assert(state.lastRoll == today, 'lastRoll not restored')

        local saved = rowFor(savedRows(today), probe)
        assert(state.items[probe].buyPrice == saved.buyPrice, 'buy price not restored')
        assert(state.items[probe].sellPrice == saved.sellPrice, 'sell price not restored')
        assert(state.items[probe].offered == true, 'offered not restored as a boolean')
    end)

    it('re-rolls a shop that gained a config item, keeping stock without restocking', function()
        local rows = savedRows(VanadielUniqueDay())

        -- Drop another item's saved row so the snapshot no longer covers every item.
        local missing = configItems()[1].id == probe and configItems()[2] or configItems()[1]
        local _, index = rowFor(rows, missing.id)
        table.remove(rows, index)

        -- Leave the probe below targetStock so a normal roll would restock it.
        local cfg   = cfgOf(probe)
        local stock = cfg.targetStock - cfg.restockRate * 2
        local saved = rowFor(rows, probe)
        saved.stock = stock

        local result = persistence.restore(rows)
        assert(result.reRolled == 1, 'shop with a missing row not set to re-roll')
        assert(xi.guildShops.state[shopName].lastRoll == -1, 'lastRoll not cleared')

        open()

        local state = xi.guildShops.state[shopName]
        assert(state.lastRoll == VanadielUniqueDay(), 'first open did not roll')
        assert(state.items[probe].stock == stock, 'first roll restocked the saved stock')
        assert(state.items[probe].buyPrice ~= saved.buyPrice, 'first roll kept the saved price')
        assert(state.items[missing.id].stock == missing.initial, 'new config item not given its starting stock')
    end)

    it('re-rolls a snapshot saved on a future day', function()
        local result = persistence.restore(savedRows(VanadielUniqueDay() + 5))

        assert(result.reRolled == 1, 'future snapshot not set to re-roll')
        assert(xi.guildShops.state[shopName].lastRoll == -1, 'future lastRoll kept')
    end)

    it('reports saved rows for items no longer in the config', function()
        local rows = savedRows(VanadielUniqueDay())
        rows[#rows + 1] =
        {
            shop      = shopName,
            itemId    = 60000,
            stock     = 5,
            buyPrice  = 1,
            sellPrice = 1,
            offered   = 1,
            lastRoll  = VanadielUniqueDay(),
        }

        local result = persistence.restore(rows)

        assert(result.restored == 1, 'the extra row stopped the shop restoring')
        assert(#result.deletes == 1, 'stale row not reported')
        assert(result.deletes[1].shop == shopName and result.deletes[1].itemId == 60000, 'wrong stale row reported')
    end)

    it('reports only stock changes until a roll, which returns every row', function()
        persistence.restore(savedRows(VanadielUniqueDay()))
        persistence.collect() -- the first call picks up shops other suites left behind

        assert(#changedRows(persistence.collect()) == 0, 'restoring on its own reported changes')

        local state = xi.guildShops.state[shopName]
        state.items[probe].stock = state.items[probe].stock - 1

        local changed = changedRows(persistence.collect())
        assert(#changed == 1, 'a stock change did not report exactly one row')
        assert(changed[1].itemId == probe and changed[1].stock == state.items[probe].stock, 'wrong row reported')
        assert(#changedRows(persistence.collect()) == 0, 'the same change was reported twice')

        state.lastRoll = state.lastRoll + 1
        assert(#changedRows(persistence.collect()) == #configItems(), 'a roll did not report every row')
    end)
end)
