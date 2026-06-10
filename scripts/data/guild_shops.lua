-----------------------------------
-- Guild shop definitions
-----------------------------------
xi = xi or {}
xi.data = xi.data or {}

---@class GuildShopItem
---@field id          xi.item
---@field initial     integer   -- stock on server restart
---@field maxStock    integer   -- hard ceiling the shop can hold
---@field targetStock integer   -- stock each open settles to (restock fills up to it, overstock trims down)
---@field buyMax      integer   -- buy price when the shelf is empty (top of the buy curve)
---@field restockRate integer   -- items restocked per day, up to targetStock
---@field hidden?     boolean   -- sell-list row hidden from the client

---@class GuildShop
---@field hours      integer[]          -- { openHour, closeHour }
---@field priceFloor xi.guildPriceFloor -- buy-curve floor rule
---@field stock      GuildShopItem[]

---@type table<string, GuildShop>
xi.data.guildShops =
{
    ['Beugungel'] =
    {
        hours      = { 5, 22 },
        priceFloor = xi.guildPriceFloor.TARGET_STOCK,
        stock      =
        {
            { id = xi.item.SPOOL_OF_BUNDLING_TWINE, initial = 180, maxStock = 240, targetStock = 180, buyMax = 500,  restockRate = 60 },
            { id = xi.item.HATCHET,                 initial = 180, maxStock = 200, targetStock = 180, buyMax = 2500, restockRate = 60 },
            { id = xi.item.ARROWWOOD_LOG,           initial = 180, maxStock = 200, targetStock = 180, buyMax = 100,  restockRate = 60 },
            { id = xi.item.ASH_LOG,                 initial = 180, maxStock = 200, targetStock = 180, buyMax = 480,  restockRate = 60 },
            { id = xi.item.YEW_LOG,                 initial = 150, maxStock = 200, targetStock = 150, buyMax = 2200, restockRate = 50 },
            { id = xi.item.WILLOW_LOG,              initial = 150, maxStock = 200, targetStock = 150, buyMax = 800,  restockRate = 50 },
            { id = xi.item.WALNUT_LOG,              initial = 180, maxStock = 240, targetStock = 180, buyMax = 4270, restockRate = 20 },
        },
    },
    ['Kamilah'] =
    {
        hours      = { 8, 23 },
        priceFloor = xi.guildPriceFloor.THREE_QUARTER_MAX,
        stock      =
        {
            { id = xi.item.CHUNK_OF_TIN_ORE,         initial = 110, maxStock = 240, targetStock = 110, buyMax = 200,    restockRate = 20 },
            { id = xi.item.CHUNK_OF_IRON_ORE,        initial = 110, maxStock = 240, targetStock = 110, buyMax = 4500,   restockRate = 10 },
            { id = xi.item.BRONZE_INGOT,             initial = 0,   maxStock = 120, targetStock = 100, buyMax = 380,    restockRate = 0 },  -- targetStock assumed
            { id = xi.item.IRON_INGOT,               initial = 0,   maxStock = 120, targetStock = 100, buyMax = 18000,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.STEEL_INGOT,              initial = 90,  maxStock = 120, targetStock = 100, buyMax = 26250,  restockRate = 10 },
            { id = xi.item.BRONZE_SHEET,             initial = 36,  maxStock = 120, targetStock = 100, buyMax = 460,    restockRate = 2 },
            { id = xi.item.IRON_SHEET,               initial = 0,   maxStock = 120, targetStock = 100, buyMax = 27000,  restockRate = 0 },
            { id = xi.item.HANDFUL_OF_BRONZE_SCALES, initial = 0,   maxStock = 60,  targetStock = 50,  buyMax = 540,    restockRate = 0 },
            { id = xi.item.HANDFUL_OF_IRON_SCALES,   initial = 0,   maxStock = 60,  targetStock = 50,  buyMax = 31500,  restockRate = 0 },
            { id = xi.item.IRON_CHAIN,               initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 31500,  restockRate = 0 }, -- targetStock assumed
            { id = xi.item.CHAINMAIL,                initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 79200,  restockRate = 0 },
            { id = xi.item.SCALE_MAIL,               initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 11150,  restockRate = 0 }, -- targetStock assumed
            { id = xi.item.PADDED_ARMOR,             initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 157440, restockRate = 0 }, -- targetStock assumed
            { id = xi.item.GREAVES,                  initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 38700,  restockRate = 0 },
            { id = xi.item.SCALE_GREAVES,            initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 5420,   restockRate = 0 },
            { id = xi.item.LEGGINGS,                 initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 78720,  restockRate = 0 },
            { id = xi.item.CHAIN_MITTENS,            initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 42300,  restockRate = 0 },
            { id = xi.item.SCALE_FINGER_GAUNTLETS,   initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 5950,   restockRate = 0 }, -- targetStock assumed
            { id = xi.item.IRON_MITTENS,             initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 86400,  restockRate = 0 },
        },
    },
}
