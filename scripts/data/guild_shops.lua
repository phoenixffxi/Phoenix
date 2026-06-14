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
    ['Amulya'] =
    {
        hours      = { 8, 23 },
        priceFloor = xi.guildPriceFloor.THREE_QUARTER_MAX,
        stock      =
        {
            { id = xi.item.CHUNK_OF_TIN_ORE,         initial = 180, maxStock = 240, targetStock = 180, buyMax = 200,    restockRate = 40 },
            { id = xi.item.CHUNK_OF_IRON_ORE,        initial = 180, maxStock = 240, targetStock = 180, buyMax = 4500,   restockRate = 30 },
            { id = xi.item.CHUNK_OF_MYTHRIL_ORE,     initial = 0,   maxStock = 240, targetStock = 180, buyMax = 10000,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.CHUNK_OF_DARKSTEEL_ORE,   initial = 0,   maxStock = 240, targetStock = 180, buyMax = 28500,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_INGOT,             initial = 36,  maxStock = 240, targetStock = 180, buyMax = 380,    restockRate = 12 },
            { id = xi.item.IRON_INGOT,               initial = 36,  maxStock = 240, targetStock = 180, buyMax = 18000,  restockRate = 12 },
            { id = xi.item.STEEL_INGOT,              initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 26250,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.MYTHRIL_INGOT,            initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 50000,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.DARKSTEEL_INGOT,          initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 142500, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_SHEET,             initial = 36,  maxStock = 240, targetStock = 180, buyMax = 460,    restockRate = 12 },
            { id = xi.item.IRON_SHEET,               initial = 36,  maxStock = 240, targetStock = 180, buyMax = 27000,  restockRate = 12 },
            { id = xi.item.STEEL_SHEET,              initial = 0,   maxStock = 240, targetStock = 180, buyMax = 42000,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.MYTHRIL_SHEET,            initial = 0,   maxStock = 240, targetStock = 180, buyMax = 60000,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.DARKSTEEL_SHEET,          initial = 0,   maxStock = 240, targetStock = 180, buyMax = 171000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.HANDFUL_OF_BRONZE_SCALES, initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 540,    restockRate = 0 },  -- targetStock assumed
            { id = xi.item.HANDFUL_OF_IRON_SCALES,   initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 31500,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.HANDFUL_OF_STEEL_SCALES,  initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 49500,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.IRON_CHAIN,               initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 31500,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.DARKSTEEL_CHAIN,          initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 199500, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_KNUCKLES,          initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 1220,   restockRate = 0 },
            { id = xi.item.METAL_KNUCKLES,           initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 26190,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.MYTHRIL_KNUCKLES,         initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 103320, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.DARKSTEEL_KNUCKLES,       initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 233700, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BAGHNAKHS,                initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 43200,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.PATAS,                    initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 228800, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_KNIFE,             initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 820,    restockRate = 0 },  -- targetStock assumed
            { id = xi.item.KNIFE,                    initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 12125,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.MYTHRIL_KNIFE,            initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 72800,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.DARKSTEEL_KNIFE,          initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 288600, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.KUKRI,                    initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 31050,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.MYTHRIL_KUKRI,            initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 99360,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.SCIMITAR,                 initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 22625,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.TULWAR,                   initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 194000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.FALCHION,                 initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 340000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.DARKSTEEL_FALCHION,       initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 555000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BILBO,                    initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 17475,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.TUCK,                     initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 64380,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.DEGEN,                    initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 51120,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.SCHLAEGER,                initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 559000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_AXE,               initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 1580,   restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BATTLEAXE,                initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 61335,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.MYTHRIL_AXE,              initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 243000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.TABAR,                    initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 330000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BUTTERFLY_AXE,            initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 3360,   restockRate = 0 },  -- targetStock assumed
            { id = xi.item.GREATAXE,                 initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 22750,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.HEAVY_AXE,                initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 206080, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_HAMMER,            initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 1700,   restockRate = 0 },  -- targetStock assumed
            { id = xi.item.WARHAMMER,                initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 32790,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.MAUL,                     initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 79800,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.ARQUEBUS,                 initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 260200, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_LEGGINGS,          initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 640,    restockRate = 0 },  -- targetStock assumed
            { id = xi.item.LEGGINGS,                 initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 78720,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.PLATE_LEGGINGS,           initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 118800, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_CAP,               initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 840,    restockRate = 0 },  -- targetStock assumed
            { id = xi.item.PADDED_CAP,               initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 102000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_SUBLIGAR,          initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 1040,   restockRate = 0 },  -- targetStock assumed
            { id = xi.item.IRON_SUBLIGAR,            initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 126720, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.CUISSES,                  initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 189000, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_MITTENS,           initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 700,    restockRate = 0 },  -- targetStock assumed
            { id = xi.item.IRON_MITTENS,             initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 86400,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.GAUNTLETS,                initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 129600, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BRONZE_HARNESS,           initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 1280,   restockRate = 0 },  -- targetStock assumed
            { id = xi.item.PADDED_ARMOR,             initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 157440, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.BREASTPLATE,              initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 245700, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.GORGET,                   initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 91800,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.ASPIS,                    initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 4725,   restockRate = 0 },  -- targetStock assumed
            { id = xi.item.TARGE,                    initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 61200,  restockRate = 0 },  -- targetStock assumed
            { id = xi.item.SCUTUM,                   initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 273600, restockRate = 0 },  -- targetStock assumed
            { id = xi.item.CROSSBOW_BOLT,            initial = 0,   maxStock = 240, targetStock = 180, buyMax = 30,     restockRate = 0 },
            { id = xi.item.MYTHRIL_BOLT,             initial = 0,   maxStock = 240, targetStock = 180, buyMax = 120,    restockRate = 0 },
            { id = xi.item.TATHLUM,                  initial = 0,   maxStock = 240, targetStock = 180, buyMax = 1610,   restockRate = 0 },
            { id = xi.item.BRONZE_BED,               initial = 0,   maxStock = 60,  targetStock = 45,  buyMax = 38925,  restockRate = 0 },  -- targetStock assumed
        },
    },
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
