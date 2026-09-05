-----------------------------------
-- Guild Shop Persistence
-- Keeps a copy of what was last saved and finds what changed, for the guild_shop_persistence C++ module.
-- Registers nothing. The module fetches xi.guildShops.persistence on its first tick.
-----------------------------------
require('scripts/globals/guild_shops')
-----------------------------------
local helper = {}

-- What was last saved for each shop. [shop] = { lastRoll = day, items = { [itemId] = stock } }
local shadow = {}

-- Put saved rows back into xi.guildShops.state and fill the shadow copy.
-- Each row is { shop, itemId, stock, buyPrice, sellPrice, offered, lastRoll }.
-- Returns the rows to delete ({ shop, itemId }) and how many shops were handled each way.
helper.restore = function(rows)
    local today  = VanadielUniqueDay()
    local byShop = {}
    for _, row in ipairs(rows) do
        local saved = byShop[row.shop]
        if not saved then
            saved = {}
            byShop[row.shop] = saved
        end

        saved[row.itemId] = row
    end

    local deletes  = {}
    local restored = 0
    local reRolled = 0
    for shopName, saved in pairs(byShop) do
        local shop = xi.data.guildShops[shopName]

        -- A shop with no config right now (module off, or it became an alias) keeps its
        -- rows in case it comes back. A shop a player already opened keeps its fresh roll.
        if shop and shop.stock and not xi.guildShops.state[shopName] then
            local state       = { lastRoll = -1, items = {} }
            local shadowItems = {}
            local configIds   = {}

            -- The saved rows are only used as they are when every configured item has one.
            -- An item with no row but today's lastRoll would crash the shop handlers.
            local lastRoll = -1
            local covered  = true
            for _, cfg in ipairs(shop.stock) do
                configIds[cfg.id] = true

                local row = saved[cfg.id]
                if row then
                    lastRoll = math.max(lastRoll, row.lastRoll)
                    state.items[cfg.id] =
                    {
                        stock     = row.stock,
                        buyPrice  = row.buyPrice,
                        sellPrice = row.sellPrice,
                        offered   = row.offered ~= 0,
                    }

                    shadowItems[cfg.id] = row.stock
                else
                    covered = false
                end
            end

            -- A saved day in the future means the host clock went backwards.
            -- rollShopDay would restock with negative days, so re-roll instead.
            if lastRoll > today then
                covered = false
            end

            -- A shop with rows missing only gets its stock back. lastRoll = -1 makes
            -- rollShopDay recompute the prices and keep that stock.
            if covered then
                state.lastRoll = lastRoll
                restored = restored + 1
            else
                reRolled = reRolled + 1
            end

            xi.guildShops.state[shopName] = state
            shadow[shopName] = { lastRoll = state.lastRoll, items = shadowItems }

            -- rollShopDay never rewrites rows for items that left the stock list,
            -- so delete them.
            for itemId in pairs(saved) do
                if not configIds[itemId] then
                    deletes[#deletes + 1] = { shop = shopName, itemId = itemId }
                end
            end
        end
    end

    return { deletes = deletes, restored = restored, reRolled = reRolled }
end

-- Collect the rows that changed since the last call and update the shadow copy.
-- Shops that have not rolled yet (lastRoll < 0) are never saved. Prices and the
-- offered flag only change at a roll, so a lastRoll change writes the whole shop.
-- Otherwise only stock is compared.
helper.collect = function()
    local deltas = {}
    for shopName, state in pairs(xi.guildShops.state) do
        if state.lastRoll >= 0 then
            local shadowShop = shadow[shopName]
            if not shadowShop then
                shadowShop = { lastRoll = -1, items = {} }
                shadow[shopName] = shadowShop
            end

            local rolled = state.lastRoll ~= shadowShop.lastRoll
            for itemId, item in pairs(state.items) do
                if rolled or shadowShop.items[itemId] ~= item.stock then
                    deltas[#deltas + 1] =
                    {
                        shop      = shopName,
                        itemId    = itemId,
                        stock     = item.stock,
                        buyPrice  = item.buyPrice,
                        sellPrice = item.sellPrice,
                        offered   = item.offered and 1 or 0,
                        lastRoll  = state.lastRoll,
                    }

                    shadowShop.items[itemId] = item.stock
                end
            end

            shadowShop.lastRoll = state.lastRoll
        end
    end

    return deltas
end

xi.guildShops.persistence = helper
