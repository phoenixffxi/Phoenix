-----------------------------------
-- Era Guild Shops
-- Info from 2009 Guild Masters Guide Ver.101207, FFXI Lightning Brigade Ver.070613 and various archived https://wiki.ffo.jp/ pages
-----------------------------------
require('modules/module_utils')
-----------------------------------
local moduleName = 'era_guild_shops'

-----------------------------------
local function getShop(shopName)
    local shop = xi.data.guildShops[shopName]
    assert(shop and shop.stock, ('Missing guild shop: %s'):format(shopName))
    return shop
end

local function findStock(shopName, itemId)
    for index, cfg in ipairs(getShop(shopName).stock) do
        if cfg.id == itemId then
            return cfg, index
        end
    end

    error(('Missing item %s in guild shop %s'):format(itemId, shopName))
end

local function patchStock(shopName, itemId, patch)
    local cfg = findStock(shopName, itemId)

    for key, value in pairs(patch) do
        cfg[key] = value
    end
end

local function removeStock(shopName, itemId)
    local _, index = findStock(shopName, itemId)
    table.remove(getShop(shopName).stock, index)
end

-----------------------------------
-- Smithing
-----------------------------------
-- Amulya & Vicious Eye
xi.data.guildShops['Vicious_Eye'] = { sharedStock = 'Amulya' }
table.insert(xi.data.guildShops['Amulya'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,   restockRate = 40 })
patchStock('Amulya', xi.item.CHUNK_OF_TIN_ORE, { initial = 120 }) -- Tin Ore
patchStock('Amulya', xi.item.CHUNK_OF_IRON_ORE, { initial = 120 }) -- Iron Ore
patchStock('Amulya', xi.item.BRONZE_INGOT, { initial = 12 }) -- Bronze Ingot
patchStock('Amulya', xi.item.IRON_INGOT, { initial = 12 }) -- Iron Ingot
patchStock('Amulya', xi.item.BRONZE_SHEET, { initial = 12 }) -- Bronze Sheet
patchStock('Amulya', xi.item.IRON_SHEET, { initial = 12 }) -- Iron Sheet
table.insert(xi.data.guildShops['Amulya'].stock, { id = xi.item.MANDREL,              initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })
table.insert(xi.data.guildShops['Amulya'].stock, { id = xi.item.WORKSHOP_ANVIL,       initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-- Doggomehr & Lucretia
xi.data.guildShops['Lucretia'] = { sharedStock = 'Doggomehr' }
table.insert(xi.data.guildShops['Doggomehr'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,   restockRate = 60 })
patchStock('Doggomehr', xi.item.CHUNK_OF_TIN_ORE, { initial = 120 }) -- Tin Ore
patchStock('Doggomehr', xi.item.CHUNK_OF_IRON_ORE, { initial = 120 }) -- Iron Ore
patchStock('Doggomehr', xi.item.BRONZE_INGOT, { initial = 12 }) -- Bronze Ingot
patchStock('Doggomehr', xi.item.IRON_INGOT, { initial = 12 }) -- Iron Ingot
patchStock('Doggomehr', xi.item.BRONZE_SHEET, { initial = 12 }) -- Bronze Sheet
patchStock('Doggomehr', xi.item.IRON_SHEET, { initial = 12 }) -- Iron Sheet
table.insert(xi.data.guildShops['Doggomehr'].stock, { id = xi.item.MANDREL,              initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })
table.insert(xi.data.guildShops['Doggomehr'].stock, { id = xi.item.WORKSHOP_ANVIL,       initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-- Mololo & Kamilah
xi.data.guildShops['Mololo'] = { sharedStock = 'Kamilah' }
table.insert(xi.data.guildShops['Kamilah'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,  restockRate = 20 })
patchStock('Kamilah', xi.item.CHUNK_OF_TIN_ORE, { initial = 120 }) -- Tin Ore
patchStock('Kamilah', xi.item.CHUNK_OF_IRON_ORE, { initial = 120 }) -- Iron Ore

-- Ndego
patchStock('Ndego', xi.item.CHUNK_OF_COPPER_ORE, { initial = 120 }) -- Copper Ore
patchStock('Ndego', xi.item.CHUNK_OF_TIN_ORE, { initial = 120 }) -- Tin Ore
patchStock('Ndego', xi.item.CHUNK_OF_IRON_ORE, { initial = 120 }) -- Iron Ore
patchStock('Ndego', xi.item.BRONZE_INGOT, { initial = 12 }) -- Bronze Ingot
patchStock('Ndego', xi.item.IRON_INGOT, { initial = 12 }) -- Iron Ingot
patchStock('Ndego', xi.item.BRONZE_SHEET, { initial = 12 }) -- Bronze Sheet
patchStock('Ndego', xi.item.IRON_SHEET, { initial = 12 }) -- Iron Sheet
patchStock('Ndego', xi.item.MANDREL, { initial = 120 }) -- Mandrel
patchStock('Ndego', xi.item.WORKSHOP_ANVIL, { initial = 120 }) -- Workshop Anvil

-----------------------------------
-- Goldsmithing
-----------------------------------
-- Bornahn
patchStock('Bornahn', xi.item.CHUNK_OF_COPPER_ORE, { initial = 120 }) -- Copper Ore
patchStock('Bornahn', xi.item.CHUNK_OF_SILVER_ORE, { initial = 120 }) -- Silver Ore
patchStock('Bornahn', xi.item.CHUNK_OF_MYTHRIL_ORE, { initial = 0 }) -- Mythril Ore
patchStock('Bornahn', xi.item.HANDFUL_OF_BRASS_SCALES, { initial = 1, restockRate = 1 }) -- Handful of Brass Scales
patchStock('Bornahn', xi.item.MYTHRIL_CHAIN, { initial = 1, restockRate = 1 }) -- Mythril Chain
patchStock('Bornahn', xi.item.RED_ROCK, { initial = 2 }) -- Red Rock
patchStock('Bornahn', xi.item.BLUE_ROCK, { initial = 2 }) -- Blue Rock
patchStock('Bornahn', xi.item.YELLOW_ROCK, { initial = 2 }) -- Yellow Rock
patchStock('Bornahn', xi.item.GREEN_ROCK, { initial = 2 }) -- Green Rock
patchStock('Bornahn', xi.item.TRANSLUCENT_ROCK, { initial = 2 }) -- Clear Rock
patchStock('Bornahn', xi.item.PURPLE_ROCK, { initial = 2 }) -- Purple Rock
patchStock('Bornahn', xi.item.BLACK_ROCK, { initial = 2 }) -- Black Rock
patchStock('Bornahn', xi.item.WHITE_ROCK, { initial = 2 }) -- White Stone
patchStock('Bornahn', xi.item.LAPIS_LAZULI, { initial = 6 }) -- Lapis Lazuli
patchStock('Bornahn', xi.item.LIGHT_OPAL, { initial = 6 }) -- Light Opal
patchStock('Bornahn', xi.item.ONYX, { initial = 6 }) -- Onyx
patchStock('Bornahn', xi.item.AMETHYST, { initial = 6 }) -- Amethyst
patchStock('Bornahn', xi.item.TOURMALINE, { initial = 6 }) -- Tourmaline
patchStock('Bornahn', xi.item.SARDONYX, { initial = 6 }) -- Sardonyx
patchStock('Bornahn', xi.item.CLEAR_TOPAZ, { initial = 6 }) -- Clear Topaz
patchStock('Bornahn', xi.item.AMBER_STONE, { initial = 6 }) -- Amber
patchStock('Bornahn', xi.item.WORKSHOP_ANVIL, { initial = 0, restockRate = 0 }) -- Workshop Anvil

-- Teerth & Visala
xi.data.guildShops['Teerth'] = { sharedStock = 'Visala' }
table.insert(xi.data.guildShops['Visala'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,  restockRate = 60 })
patchStock('Visala', xi.item.CHUNK_OF_SILVER_ORE, { initial = 120 }) -- Silver Ore
patchStock('Visala', xi.item.CHUNK_OF_MYTHRIL_ORE, { initial = 0 }) -- Mythril Ore
patchStock('Visala', xi.item.HANDFUL_OF_BRASS_SCALES, { initial = 1, restockRate = 1 }) -- Handful of Brass Scales
patchStock('Visala', xi.item.MYTHRIL_CHAIN, { initial = 1 }) -- Mythril Chain
patchStock('Visala', xi.item.RED_ROCK, { initial = 2 }) -- Red Rock
patchStock('Visala', xi.item.BLUE_ROCK, { initial = 2 }) -- Blue Rock
patchStock('Visala', xi.item.YELLOW_ROCK, { initial = 2 }) -- Yellow Rock
patchStock('Visala', xi.item.GREEN_ROCK, { initial = 2 }) -- Green Rock
patchStock('Visala', xi.item.TRANSLUCENT_ROCK, { initial = 2 }) -- Clear Rock
patchStock('Visala', xi.item.PURPLE_ROCK, { initial = 2 }) -- Purple Rock
patchStock('Visala', xi.item.BLACK_ROCK, { initial = 2 }) -- Black Rock
patchStock('Visala', xi.item.WHITE_ROCK, { initial = 2 }) -- White Stone
patchStock('Visala', xi.item.LAPIS_LAZULI, { initial = 6 }) -- Lapis Lazuli
patchStock('Visala', xi.item.LIGHT_OPAL, { initial = 6 }) -- Light Opal
patchStock('Visala', xi.item.ONYX, { initial = 6 }) -- Onyx
patchStock('Visala', xi.item.AMETHYST, { initial = 6 }) -- Amethyst
patchStock('Visala', xi.item.TOURMALINE, { initial = 6 }) -- Tourmaline
patchStock('Visala', xi.item.SARDONYX, { initial = 6 }) -- Sardonyx
patchStock('Visala', xi.item.CLEAR_TOPAZ, { initial = 6 }) -- Clear Topaz
patchStock('Visala', xi.item.AMBER_STONE, { initial = 6 }) -- Amber
patchStock('Visala', xi.item.SLAB_OF_TUFA, { initial = 120 }) -- Tufa

-- Yabby Tanmikey & Celestina
xi.data.guildShops['Celestina'] = { sharedStock = 'Yabby_Tanmikey' }
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 90,   maxStock = 240,  targetStock = 180,  buyMax = 133,  restockRate = 15 }) -- buyMax Mhaura-specific (20g vs 9g at Bastok/Al Zahbi)
patchStock('Yabby_Tanmikey', xi.item.CHUNK_OF_SILVER_ORE, { initial = 70, buyMax = 4700 }) -- Silver Ore, Mhaura-specific price curve (705g vs 315g at Bastok/Al Zahbi)
patchStock('Yabby_Tanmikey', xi.item.RED_ROCK, { initial = 2 }) -- Red Rock
patchStock('Yabby_Tanmikey', xi.item.BLUE_ROCK, { initial = 2 }) -- Blue Rock
patchStock('Yabby_Tanmikey', xi.item.YELLOW_ROCK, { initial = 2 }) -- Yellow Rock
patchStock('Yabby_Tanmikey', xi.item.GREEN_ROCK, { initial = 2 }) -- Green Rock
patchStock('Yabby_Tanmikey', xi.item.TRANSLUCENT_ROCK, { initial = 2 }) -- Clear Rock
patchStock('Yabby_Tanmikey', xi.item.PURPLE_ROCK, { initial = 2 }) -- Purple Rock
patchStock('Yabby_Tanmikey', xi.item.BLACK_ROCK, { initial = 2 }) -- Black Rock
patchStock('Yabby_Tanmikey', xi.item.WHITE_ROCK, { initial = 2 }) -- White Stone
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, { id = xi.item.MANDREL,              initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, { id = xi.item.WORKSHOP_ANVIL,       initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-----------------------------------
-- Woodworking
-----------------------------------
-- Cauzeriste & Chaupire
xi.data.guildShops['Cauzeriste'] = { sharedStock = 'Chaupire' }
table.insert(xi.data.guildShops['Chaupire'].stock, 1, { id = xi.item.ARROWWOOD_LOG,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 100,  restockRate = 60 })
table.insert(xi.data.guildShops['Chaupire'].stock, 2, { id = xi.item.LAUAN_LOG,      initial = 120,  maxStock = 240,  targetStock = 144,  buyMax = 180,  restockRate = 12 })
table.insert(xi.data.guildShops['Chaupire'].stock, 3, { id = xi.item.MAPLE_LOG,      initial = 120,  maxStock = 240,  targetStock = 144,  buyMax = 300,  restockRate = 12 })
patchStock('Chaupire', xi.item.ASH_LOG, { initial = 120 }) -- Ash Log
patchStock('Chaupire', xi.item.WILLOW_LOG, { initial = 120 }) -- Willow Log
patchStock('Chaupire', xi.item.HOLLY_LOG, { initial = 90 }) -- Holly Log
patchStock('Chaupire', xi.item.YEW_LOG, { initial = 90 }) -- Yew Log
patchStock('Chaupire', xi.item.ELM_LOG, { initial = 60 }) -- Elm Log
patchStock('Chaupire', xi.item.WALNUT_LOG, { initial = 60 }) -- Walnut Log
patchStock('Chaupire', xi.item.CHESTNUT_LOG, { initial = 60 }) -- Chestnut Log
patchStock('Chaupire', xi.item.OAK_LOG, { initial = 30 }) -- Oak Log
patchStock('Chaupire', xi.item.ROSEWOOD_LOG, { initial = 30 }) -- Rosewood Log
patchStock('Chaupire', xi.item.MAHOGANY_LOG, { initial = 10 }) -- Mahogany Log
patchStock('Chaupire', xi.item.EBONY_LOG, { initial = 10 }) -- Ebony Log
patchStock('Chaupire', xi.item.BAMBOO_STICK, { initial = 12 }) -- Bamboo Stick
patchStock('Chaupire', xi.item.PIECE_OF_ARROWWOOD_LUMBER, { initial = 12 }) -- Arrowwood Lumber
patchStock('Chaupire', xi.item.PIECE_OF_LAUAN_LUMBER, { initial = 12 }) -- Lauan Lumber
patchStock('Chaupire', xi.item.PIECE_OF_MAPLE_LUMBER, { initial = 12 }) -- Maple Lumber
patchStock('Chaupire', xi.item.PIECE_OF_ASH_LUMBER, { initial = 12 }) -- Ash Lumber
patchStock('Chaupire', xi.item.PIECE_OF_WILLOW_LUMBER, { initial = 12 }) -- Willow Lumber
patchStock('Chaupire', xi.item.PIECE_OF_HOLLY_LUMBER, { initial = 9 }) -- Holly Lumber
patchStock('Chaupire', xi.item.PIECE_OF_YEW_LUMBER, { initial = 9 }) -- Yew Lumber
patchStock('Chaupire', xi.item.PIECE_OF_ELM_LUMBER, { initial = 12, restockRate = 12 }) -- Elm Lumber
patchStock('Chaupire', xi.item.PIECE_OF_CHESTNUT_LUMBER, { initial = 6 }) -- Chestnut Lumber
patchStock('Chaupire', xi.item.PIECE_OF_OAK_LUMBER, { initial = 6 }) -- Oak Lumber

-- Beugungel
xi.data.guildShops['Beugungel'].hours = { 5, 21 } -- close time corrected from base 22
patchStock('Beugungel', xi.item.SPOOL_OF_BUNDLING_TWINE, { initial = 120 }) -- Bundling Twine
patchStock('Beugungel', xi.item.HATCHET, { initial = 120 }) -- Hatchet
patchStock('Beugungel', xi.item.ARROWWOOD_LOG, { initial = 120 }) -- Arrowwood Log
patchStock('Beugungel', xi.item.ASH_LOG, { initial = 120, buyMax = 500 }) -- Ash Log
patchStock('Beugungel', xi.item.YEW_LOG, { initial = 100 }) -- Yew Log
patchStock('Beugungel', xi.item.WILLOW_LOG, { initial = 100 }) -- Willow Log
patchStock('Beugungel', xi.item.WALNUT_LOG, { initial = 120, restockRate = 50 }) -- Walnut Log

-- Dehbi_Moshal
patchStock('Dehbi_Moshal', xi.item.ARROWWOOD_LOG, { initial = 120 }) -- Arrowwood Log
patchStock('Dehbi_Moshal', xi.item.LAUAN_LOG, { initial = 120 }) -- Lauan Log
patchStock('Dehbi_Moshal', xi.item.MAPLE_LOG, { initial = 120 }) -- Maple Log
patchStock('Dehbi_Moshal', xi.item.ASH_LOG, { initial = 100, buyMax = 400, restockRate = 50 }) -- Ash Log
patchStock('Dehbi_Moshal', xi.item.WILLOW_LOG, { initial = 120, restockRate = 20 }) -- Willow Log
patchStock('Dehbi_Moshal', xi.item.HOLLY_LOG, { initial = 90 }) -- Holly Log
patchStock('Dehbi_Moshal', xi.item.YEW_LOG, { initial = 120, restockRate = 20 }) -- Yew Log
patchStock('Dehbi_Moshal', xi.item.ELM_LOG, { initial = 60 }) -- Elm Log
patchStock('Dehbi_Moshal', xi.item.WALNUT_LOG, { initial = 60 }) -- Walnut Log
patchStock('Dehbi_Moshal', xi.item.CHESTNUT_LOG, { initial = 60 }) -- Chestnut Log
patchStock('Dehbi_Moshal', xi.item.OAK_LOG, { initial = 30 }) -- Oak Log
patchStock('Dehbi_Moshal', xi.item.ROSEWOOD_LOG, { initial = 30 }) -- Rosewood Log
patchStock('Dehbi_Moshal', xi.item.MAHOGANY_LOG, { initial = 10 }) -- Mahogany Log
patchStock('Dehbi_Moshal', xi.item.EBONY_LOG, { initial = 10 }) -- Ebony Log
patchStock('Dehbi_Moshal', xi.item.BAMBOO_STICK, { initial = 12 }) -- Bamboo Stick
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_ARROWWOOD_LUMBER, { initial = 12 }) -- Arrowwood Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_LAUAN_LUMBER, { initial = 12 }) -- Lauan Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_MAPLE_LUMBER, { initial = 12 }) -- Maple Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_ASH_LUMBER, { initial = 12 }) -- Ash Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_WILLOW_LUMBER, { initial = 12 }) -- Willow Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_HOLLY_LUMBER, { initial = 9 }) -- Holly Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_YEW_LUMBER, { initial = 9 }) -- Yew Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_ELM_LUMBER, { initial = 12, restockRate = 12 }) -- Elm Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_CHESTNUT_LUMBER, { initial = 6 }) -- Chestnut Lumber
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_OAK_LUMBER, { initial = 6 }) -- Oak Lumber

-----------------------------------
-- Clothcraft
-----------------------------------
-- Kuzah Hpirohpon & Meriri
xi.data.guildShops['Meriri'] = { sharedStock = 'Kuzah_Hpirohpon' }
table.insert(xi.data.guildShops['Kuzah_Hpirohpon'].stock, 1, { id = xi.item.CLUMP_OF_MOKO_GRASS,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 100,  restockRate = 60 })
patchStock('Kuzah_Hpirohpon', xi.item.BALL_OF_SARUTA_COTTON, { initial = 0, buyMax = 214 }) -- Saruta Cotton
patchStock('Kuzah_Hpirohpon', xi.item.FLAX_FLOWER, { initial = 120 }) -- Flax
patchStock('Kuzah_Hpirohpon', xi.item.CLUMP_OF_SHEEP_WOOL, { initial = 120 }) -- Sheep Wool
patchStock('Kuzah_Hpirohpon', xi.item.PIECE_OF_CRAWLER_COCOON, { initial = 40 }) -- Crawler Cocoon
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_GRASS_THREAD, { initial = 120 }) -- Grass Thread
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_COTTON_THREAD, { initial = 120, buyMax = 780 }) -- Cotton Thread
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_LINEN_THREAD, { initial = 90 }) -- Linen Thread
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_WOOL_THREAD, { initial = 60 }) -- Wool Thread
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_SILK_THREAD, { initial = 6, buyMax = 2375 }) -- Silk Thread
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_SILVER_THREAD, { initial = 4, buyMax = 1875 }) -- Silver Thread
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_GOLD_THREAD, { initial = 3 }) -- Gold Thread
patchStock('Kuzah_Hpirohpon', xi.item.SQUARE_OF_GRASS_CLOTH, { initial = 12 }) -- Grass Cloth
patchStock('Kuzah_Hpirohpon', xi.item.SQUARE_OF_COTTON_CLOTH, { initial = 12 }) -- Cotton Cloth
table.insert(xi.data.guildShops['Kuzah_Hpirohpon'].stock, 78, { id = xi.item.SPINDLE,              initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-- Taten-Bilten
patchStock('Taten-Bilten', xi.item.SPOOL_OF_SILK_THREAD, { initial = 6, buyMax = 2944 }) -- Silk Thread
patchStock('Taten-Bilten', xi.item.SPOOL_OF_GRASS_THREAD, { initial = 120 }) -- Grass Thread
patchStock('Taten-Bilten', xi.item.SPOOL_OF_COTTON_THREAD, { initial = 120 }) -- Cotton Thread
patchStock('Taten-Bilten', xi.item.SPOOL_OF_LINEN_THREAD, { initial = 90 }) -- Linen Thread
patchStock('Taten-Bilten', xi.item.SPOOL_OF_SILVER_THREAD, { initial = 4, buyMax = 4480 }) -- Silver Thread
patchStock('Taten-Bilten', xi.item.SPOOL_OF_GOLD_THREAD, { initial = 3 }) -- Gold Thread
patchStock('Taten-Bilten', xi.item.SQUARE_OF_GRASS_CLOTH, { initial = 12 }) -- Grass Cloth
patchStock('Taten-Bilten', xi.item.SQUARE_OF_COTTON_CLOTH, { initial = 12 }) -- Cotton Cloth
patchStock('Taten-Bilten', xi.item.CLUMP_OF_SHEEP_WOOL, { initial = 120 }) -- Sheep Wool
patchStock('Taten-Bilten', xi.item.CLUMP_OF_MOKO_GRASS, { initial = 120 }) -- Moko Grass
patchStock('Taten-Bilten', xi.item.BALL_OF_SARUTA_COTTON, { initial = 0, buyMax = 84 }) -- Saruta Cotton
patchStock('Taten-Bilten', xi.item.FLAX_FLOWER, { initial = 120 }) -- Flax
patchStock('Taten-Bilten', xi.item.PIECE_OF_CRAWLER_COCOON, { initial = 40 }) -- Crawler Cocoon
patchStock('Taten-Bilten', xi.item.SPINDLE, { initial = 120 }) -- Spindle
patchStock('Taten-Bilten', xi.item.SPOOL_OF_ZEPHYR_THREAD, { initial = 120 }) -- Spool of Zephyr Thread
patchStock('Taten-Bilten', xi.item.WAMOURA_COCOON, { initial = 60 }) -- Wamoura Cocoon
patchStock('Taten-Bilten', xi.item.SPOOL_OF_KARAKUL_THREAD, { initial = 60 }) -- Karakul Thread
table.insert(xi.data.guildShops['Taten-Bilten'].stock, { id = xi.item.SPOOL_OF_WOOL_THREAD,  initial = 60,  maxStock = 120,  targetStock = 90,  buyMax = 18000,  restockRate = 3 })

-- Tilala & Gibol
xi.data.guildShops['Gibol'] = { sharedStock = 'Tilala' }
table.insert(xi.data.guildShops['Tilala'].stock, 1, { id = xi.item.CLUMP_OF_MOKO_GRASS,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 100,  restockRate = 40 })
patchStock('Tilala', xi.item.FLAX_FLOWER, { initial = 60 }) -- Flax
patchStock('Tilala', xi.item.CLUMP_OF_SHEEP_WOOL, { initial = 55 }) -- Sheep Wool
patchStock('Tilala', xi.item.SPOOL_OF_GRASS_THREAD, { initial = 90 }) -- Grass Thread
patchStock('Tilala', xi.item.SPOOL_OF_COTTON_THREAD, { initial = 90, restockRate = 30 }) -- Cotton Thread
patchStock('Tilala', xi.item.SPOOL_OF_LINEN_THREAD, { initial = 90, buyMax = 4524 }) -- Linen Thread
patchStock('Tilala', xi.item.SPOOL_OF_WOOL_THREAD, { initial = 60 }) -- Wool Thread
patchStock('Tilala', xi.item.SPOOL_OF_SILK_THREAD, { initial = 12, buyMax = 699 }) -- Silk Thread
patchStock('Tilala', xi.item.SPOOL_OF_SILVER_THREAD, { initial = 6 }) -- Silver Thread
patchStock('Tilala', xi.item.SPOOL_OF_GOLD_THREAD, { initial = 3 }) -- Gold Thread

-----------------------------------
-- Leatherworking
-----------------------------------
-- Cletae & Kueh Igunahmori
xi.data.guildShops['Cletae'] = { sharedStock = 'Kueh_Igunahmori' }
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, 1, { id = xi.item.RABBIT_HIDE,  initial = 12,   maxStock = 160,  targetStock = 120,  buyMax = 400,  restockRate = 12 }) -- targetStock assumed
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, 2, { id = xi.item.SHEEPSKIN,    initial = 12,   maxStock = 160,  targetStock = 120,  buyMax = 506,  restockRate = 12 }) -- targetStock assumed
patchStock('Kueh_Igunahmori', xi.item.WOLF_HIDE, { initial = 0 }) -- Wolf Hide
patchStock('Kueh_Igunahmori', xi.item.RAM_SKIN, { initial = 0 }) -- Ram Skin
patchStock('Kueh_Igunahmori', xi.item.TIGER_HIDE, { initial = 0 }) -- Tiger Hide
patchStock('Kueh_Igunahmori', xi.item.COEURL_HIDE, { initial = 0 }) -- Coeurl Hide
patchStock('Kueh_Igunahmori', xi.item.RAPTOR_SKIN, { initial = 30 }) -- Raptor Skin
patchStock('Kueh_Igunahmori', xi.item.COCKATRICE_SKIN, { initial = 30 }) -- Cockatrice Skin
patchStock('Kueh_Igunahmori', xi.item.WILLOW_LOG, { initial = 120 }) -- Willow Log
patchStock('Kueh_Igunahmori', xi.item.FLASK_OF_DISTILLED_WATER, { initial = 120 }) -- Distilled Water
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, { id = xi.item.TANNING_VAT,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-----------------------------------
-- Bonecraft
-----------------------------------
-- Retto-Marutto & Shih Tayuun
xi.data.guildShops['Retto-Marutto'] = { sharedStock = 'Shih_Tayuun' }
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, 1, { id = xi.item.BONE_CHIP,               initial = 12,   maxStock = 240,  targetStock = 180,  buyMax = 380,  restockRate = 12 })
patchStock('Shih_Tayuun', xi.item.SHEEP_TOOTH, { initial = 12 }) -- Sheep Tooth
patchStock('Shih_Tayuun', xi.item.TURTLE_SHELL, { initial = 4 }) -- Turtle Shell
patchStock('Shih_Tayuun', xi.item.SEASHELL, { initial = 120 }) -- Seashell
patchStock('Shih_Tayuun', xi.item.CHICKEN_BONE, { initial = 7 }) -- Chicken Bone
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, 14, { id = xi.item.HANDFUL_OF_FISH_SCALES,  initial = 30,   maxStock = 240,  targetStock = 180,  buyMax = 480,  restockRate = 15 })
patchStock('Shih_Tayuun', xi.item.BONE_ARROW, { initial = 0 }) -- Bone Arrow
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, { id = xi.item.SHAGREEN_FILE,           initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-----------------------------------
-- Alchemy
-----------------------------------
-- Maymunah & Odoba
xi.data.guildShops['Odoba'] = { sharedStock = 'Maymunah' }
table.insert(xi.data.guildShops['Maymunah'].stock, 1, { id = xi.item.VIAL_OF_MERCURY,  initial = 8,    maxStock = 60,   targetStock = 45,   buyMax = 7500,  restockRate =  1 })
patchStock('Maymunah', xi.item.WIJNRUIT, { initial = 60 }) -- Wijnruit
patchStock('Maymunah', xi.item.POT_OF_CRYING_MUSTARD, { initial = 60 }) -- Crying Mustard
patchStock('Maymunah', xi.item.PINCH_OF_DRIED_MARJORAM, { initial = 60 }) -- Dried Marjoram
patchStock('Maymunah', xi.item.CHAMOMILE, { initial = 60 }) -- Chamomile
patchStock('Maymunah', xi.item.COBALT_JELLYFISH, { initial = 12 }) -- Cobalt Jelly
patchStock('Maymunah', xi.item.LOOP_OF_GLASS_FIBER, { initial = 30 }) -- Glass Fiber
patchStock('Maymunah', xi.item.BATTERY, { initial = 120 }) -- Battery
patchStock('Maymunah', xi.item.HYDRO_PUMP, { initial = 120 }) -- Hydro Pump
patchStock('Maymunah', xi.item.WIND_FAN, { initial = 120 }) -- Wind Fan
table.insert(xi.data.guildShops['Maymunah'].stock, { id = xi.item.TRITURATOR,       initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,   restockRate = 60 })

-- Wahraga & Gathweeda
patchStock('Wahraga', xi.item.VIAL_OF_MERCURY, { initial = 8 }) -- Mercury
patchStock('Wahraga', xi.item.MALBORO_VINE, { initial = 8 }) -- Morbol Vine
patchStock('Wahraga', xi.item.PINCH_OF_SULFUR, { initial = 40 }) -- Sulfur
patchStock('Wahraga', xi.item.WIJNRUIT, { initial = 60 }) -- Wijnruit
patchStock('Wahraga', xi.item.POT_OF_CRYING_MUSTARD, { initial = 60 }) -- Crying Mustard
patchStock('Wahraga', xi.item.PINCH_OF_DRIED_MARJORAM, { initial = 60 }) -- Dried Marjoram
patchStock('Wahraga', xi.item.CHAMOMILE, { initial = 60 }) -- Chamomile
patchStock('Wahraga', xi.item.SPRIG_OF_SAGE, { initial = 120 }) -- Sage
patchStock('Wahraga', xi.item.COBALT_JELLYFISH, { initial = 12 }) -- Cobalt Jelly
patchStock('Wahraga', xi.item.LOOP_OF_GLASS_FIBER, { initial = 30 }) -- Glass Fiber
patchStock('Wahraga', xi.item.TRITURATOR, { initial = 120 }) -- Triturator
patchStock('Wahraga', xi.item.BUNDLE_OF_HOMUNCULUS_NERVES, { initial = 120 }) -- Homunculus Nerves
patchStock('Wahraga', xi.item.SHEET_OF_POLYFLAN_PAPER, { initial = 120 }) -- Polyflan Paper
patchStock('Wahraga', xi.item.BATTERY, { initial = 120 }) -- Battery
patchStock('Wahraga', xi.item.HYDRO_PUMP, { initial = 120 }) -- Hydro Pump
patchStock('Wahraga', xi.item.WIND_FAN, { initial = 120 }) -- Wind Fan
patchStock('Wahraga', xi.item.PINCH_OF_MINIUM, { initial = 12 }) -- Minium

-----------------------------------
-- Cooking
-----------------------------------
-- Chomo Jinhahl & Kopopo
xi.data.guildShops['Chomo_Jinjahl'] = { sharedStock = 'Kopopo' }
table.insert(xi.data.guildShops['Kopopo'].stock, 1, { id = xi.item.CHUNK_OF_ROCK_SALT,          initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 93,   restockRate = 12 }) -- targetStock assumed
table.insert(xi.data.guildShops['Kopopo'].stock, 42, { id = xi.item.SARUTA_ORANGE,               initial = 60,   maxStock = 240,  targetStock = 180,  buyMax = 300,  restockRate =  2 }) -- targetStock assumed
table.insert(xi.data.guildShops['Kopopo'].stock, 47, { id = xi.item.BUNCH_OF_SAN_DORIAN_GRAPES,  initial = 12,   maxStock = 240,  targetStock = 180,  buyMax = 380,  restockRate =  2 }) -- targetStock assumed
patchStock('Kopopo', xi.item.BAG_OF_RYE_FLOUR, { initial = 120 }) -- Rye Flour
patchStock('Kopopo', xi.item.BAG_OF_SAN_DORIAN_FLOUR, { initial = 120 }) -- San d'Orian Flour
patchStock('Kopopo', xi.item.BUNCH_OF_KAZHAM_PEPPERS, { initial = 120 }) -- Kazham Peppers
patchStock('Kopopo', xi.item.BULB_OF_MHAURA_GARLIC, { initial = 120 }) -- Mhaura Garlic
patchStock('Kopopo', xi.item.JUG_OF_SELBINA_MILK, { initial = 120 }) -- Selbina Milk
patchStock('Kopopo', xi.item.PIECE_OF_PIE_DOUGH, { initial = 6 }) -- Pie Dough
patchStock('Kopopo', xi.item.POD_OF_BLUE_PEAS, { initial = 120 }) -- Blue Peas
patchStock('Kopopo', xi.item.POPOTO, { initial = 120 }) -- Poteto (Popoto)
patchStock('Kopopo', xi.item.BOX_OF_TARUTARU_RICE, { initial = 120 }) -- Tarutaru Rice
patchStock('Kopopo', xi.item.POT_OF_CRYING_MUSTARD, { initial = 120 }) -- Crying Mustard
patchStock('Kopopo', xi.item.PINCH_OF_DRIED_MARJORAM, { initial = 120 }) -- Dried Marjoram
patchStock('Kopopo', xi.item.BOTTLE_OF_APPLE_VINEGAR, { initial = 0 }) -- Apple Vinegar
patchStock('Kopopo', xi.item.STICK_OF_CINNAMON, { initial = 120 }) -- Cinnamon
patchStock('Kopopo', xi.item.EAR_OF_MILLIONCORN, { initial = 120 }) -- Millioncorn
patchStock('Kopopo', xi.item.BIRD_EGG, { initial = 60 }) -- Bird Egg
patchStock('Kopopo', xi.item.FAERIE_APPLE, { initial = 60 }) -- Faerie Apple
patchStock('Kopopo', xi.item.LA_THEINE_CABBAGE, { initial = 60 }) -- La Theine Cabbage
patchStock('Kopopo', xi.item.CLUMP_OF_BEAUGREENS, { initial = 60 }) -- Beaucedine Cabbage
patchStock('Kopopo', xi.item.CLUMP_OF_BATAGREENS, { initial = 0 }) -- Batallia Cabbage
patchStock('Kopopo', xi.item.SMOKED_SALMON, { initial = 0 }) -- Smoked Salmon
patchStock('Kopopo', xi.item.SAN_DORIAN_CARROT, { initial = 60 }) -- San d'Orian Carrot
patchStock('Kopopo', xi.item.MITHRAN_TOMATO, { initial = 60 }) -- Mithran Tomato
patchStock('Kopopo', xi.item.THUNDERMELON, { initial = 12 }) -- Thundermelon
patchStock('Kopopo', xi.item.KAZHAM_PINEAPPLE, { initial = 12 }) -- Kazham Pineapple
patchStock('Kopopo', xi.item.WATERMELON, { initial = 12 }) -- Watermelon
patchStock('Kopopo', xi.item.LOAF_OF_WHITE_BREAD, { initial = 4 }) -- White Bread
patchStock('Kopopo', xi.item.LOAF_OF_BLACK_BREAD, { initial = 8 }) -- Black Bread
patchStock('Kopopo', xi.item.ONZ_OF_TURMERIC, { initial = 30 }) -- Turmeric
patchStock('Kopopo', xi.item.ONZ_OF_CORIANDER, { initial = 30 }) -- Coriander
patchStock('Kopopo', xi.item.SPRIG_OF_HOLY_BASIL, { initial = 15 }) -- Holy Basil
patchStock('Kopopo', xi.item.BAG_OF_SEMOLINA, { initial = 60 }) -- Semolina
patchStock('Kopopo', xi.item.JAR_OF_FISH_STOCK, { initial = 50 }) -- Fish Stock
patchStock('Kopopo', xi.item.SAUCER_OF_SOY_STOCK, { initial = 50 }) -- Soy Stock

-----------------------------------
-- Fishing
-----------------------------------
-- Babubu
patchStock('Babubu', xi.item.LITTLE_WORM, { initial = 120 }) -- Little Worm
patchStock('Babubu', xi.item.LUGWORM, { initial = 120 }) -- Lugworm
patchStock('Babubu', xi.item.BALL_OF_SARDINE_PASTE, { initial = 120 }) -- Sardine Ball
patchStock('Babubu', xi.item.BALL_OF_CRAYFISH_PASTE, { initial = 120 }) -- Shrimp Ball
patchStock('Babubu', xi.item.BALL_OF_INSECT_PASTE, { initial = 120 }) -- Bug Ball
patchStock('Babubu', xi.item.BALL_OF_TROUT_PASTE, { initial = 120 }) -- Trout Ball
patchStock('Babubu', xi.item.MEATBALL, { initial = 120 }) -- Meatball
patchStock('Babubu', xi.item.SLICE_OF_SARDINE, { initial = 120 }) -- Slice of Sardine
patchStock('Babubu', xi.item.SLICE_OF_COD, { initial = 120 }) -- Slice of Cod
patchStock('Babubu', xi.item.PEELED_LOBSTER, { initial = 120 }) -- Peeled Lobster
patchStock('Babubu', xi.item.SLICE_OF_BLUETAIL, { initial = 120 }) -- Slice of Bluetail
patchStock('Babubu', xi.item.PEELED_CRAYFISH, { initial = 120 }) -- Peeled Crayfish
patchStock('Babubu', xi.item.SLICE_OF_MOAT_CARP, { initial = 120 }) -- Slice of Moat Carp
patchStock('Babubu', xi.item.FLY_LURE, { initial = 120 }) -- Fly Lure
patchStock('Babubu', xi.item.MINNOW, { initial = 120 }) -- Minnow
patchStock('Babubu', xi.item.WORM_LURE, { initial = 120 }) -- Worm Lure
patchStock('Babubu', xi.item.SABIKI_RIG, { initial = 120 }) -- Sabiki Rig
patchStock('Babubu', xi.item.WILLOW_FISHING_ROD, { initial = 90 }) -- Willow Fishing Rod
patchStock('Babubu', xi.item.YEW_FISHING_ROD, { initial = 90 }) -- Yew Fishing Rod
patchStock('Babubu', xi.item.BAMBOO_FISHING_ROD, { initial = 90 }) -- Bamboo Fishing Rod
patchStock('Babubu', xi.item.FASTWATER_FISHING_ROD, { initial = 60 }) -- Fastwater Rod
patchStock('Babubu', xi.item.TARUTARU_FISHING_ROD, { initial = 30 }) -- Tarutaru Fishing Rod
patchStock('Babubu', xi.item.MITHRAN_FISHING_ROD, { initial = 30 }) -- Mithran Fishing Rod
patchStock('Babubu', xi.item.SINGLE_HOOK_FISHING_ROD, { initial = 30 }) -- Single Hook Rod

-- Cehn Teyohngo
patchStock('Cehn_Teyohngo', xi.item.SABIKI_RIG, { initial = 10 }) -- Sabiki Rig
patchStock('Cehn_Teyohngo', xi.item.MINNOW, { initial = 10 }) -- Minnow
patchStock('Cehn_Teyohngo', xi.item.TARUTARU_FISHING_ROD, { initial = 120 }) -- Tarutaru Fishing Rod

-- Graegham & Mendoline
table.insert(xi.data.guildShops['Graegham'].stock, 1, { id = xi.item.LITTLE_WORM,             initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 20,      restockRate = 60 })
table.insert(xi.data.guildShops['Graegham'].stock, 2, { id = xi.item.LUGWORM,                 initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,      restockRate = 60 })
table.insert(xi.data.guildShops['Graegham'].stock, 3, { id = xi.item.BALL_OF_SARDINE_PASTE,   initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 350,     restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 4, { id = xi.item.BALL_OF_CRAYFISH_PASTE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 350,     restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 5, { id = xi.item.SLICE_OF_COD,            initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 1425,    restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 6, { id = xi.item.FLY_LURE,                initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 3600,    restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 7, { id = xi.item.MINNOW,                  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 2025,    restockRate = 12 })
patchStock('Graegham', xi.item.SABIKI_RIG, { initial = 120, restockRate = 12 }) -- Sabiki Rig
table.insert(xi.data.guildShops['Graegham'].stock, 9, { id = xi.item.WILLOW_FISHING_ROD,      initial = 90,   maxStock = 180,  targetStock = 160,  buyMax = 360,     restockRate =  9 })
table.insert(xi.data.guildShops['Graegham'].stock, 10, { id = xi.item.YEW_FISHING_ROD,         initial = 90,   maxStock = 180,  targetStock = 160,  buyMax = 1180,    restockRate =  9 })
table.insert(xi.data.guildShops['Graegham'].stock, 11, { id = xi.item.BAMBOO_FISHING_ROD,      initial = 90,   maxStock = 180,  targetStock = 160,  buyMax = 2700,    restockRate =  9 })
patchStock('Graegham', xi.item.TARUTARU_FISHING_ROD, { initial = 30, restockRate = 15 }) -- Tarutaru Fishing Rod
table.insert(xi.data.guildShops['Graegham'].stock, 13, { id = xi.item.MITHRAN_FISHING_ROD,     initial = 30,   maxStock = 60,   targetStock = 45,   buyMax = 171600,  restockRate =  5 })
patchStock('Graegham', xi.item.CLOTHESPOLE, { initial = 30, restockRate = 15 }) -- Clothespole
patchStock('Graegham', xi.item.FASTWATER_FISHING_ROD, { initial = 30, restockRate = 15 }) -- Fastwater Rod
patchStock('Graegham', xi.item.SINGLE_HOOK_FISHING_ROD, { initial = 30, restockRate = 3 }) -- Single Hook Rod
patchStock('Graegham', xi.item.BASTORE_SARDINE_1, { restockRate = 0 }) -- Bastore Sardine
patchStock('Graegham', xi.item.DARK_BASS_1, { restockRate = 0 }) -- Dark Bass
patchStock('Graegham', xi.item.RED_TERRAPIN, { restockRate = 0 }) -- Red Terrapin
patchStock('Graegham', xi.item.SILVER_SHARK, { restockRate = 0 }) -- Silver Shark
patchStock('Graegham', xi.item.BLACK_SOLE, { restockRate = 0 }) -- Black Sole
patchStock('Graegham', xi.item.GREEDIE, { restockRate = 0 }) -- Greedie

-- Jidwahn
patchStock('Jidwahn', xi.item.SABIKI_RIG, { initial = 10 }) -- Sabiki Rig
patchStock('Jidwahn', xi.item.MINNOW, { initial = 10 }) -- Minnow
patchStock('Jidwahn', xi.item.ICE_CARD, { initial = 120 }) -- Ice Card
patchStock('Jidwahn', xi.item.THUNDER_CARD, { initial = 120 }) -- Thunder Card
patchStock('Jidwahn', xi.item.LIGHT_CARD, { initial = 120 }) -- Light Card
patchStock('Jidwahn', xi.item.DARK_CARD, { initial = 120 }) -- Dark Card

-- Lokhong
patchStock('Lokhong', xi.item.SABIKI_RIG, { initial = 10 }) -- Sabiki Rig
patchStock('Lokhong', xi.item.MINNOW, { initial = 10 }) -- Minnow
patchStock('Lokhong', xi.item.TARUTARU_FISHING_ROD, { initial = 120 }) -- Tarutaru Fishing Rod

-- Mep Nhapopoluko
table.insert(xi.data.guildShops['Mep_Nhapopoluko'].stock, 1, { id = xi.item.SABIKI_RIG,            initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 15960,  restockRate = 12 })
patchStock('Mep_Nhapopoluko', xi.item.FASTWATER_FISHING_ROD, { initial = 80 }) -- Fastwater Rod
table.insert(xi.data.guildShops['Mep_Nhapopoluko'].stock, 3, { id = xi.item.TARUTARU_FISHING_ROD,  initial = 30,   maxStock = 60,   targetStock = 45,   buyMax = 27180,  restockRate =  3 })
patchStock('Mep_Nhapopoluko', xi.item.SINGLE_HOOK_FISHING_ROD, { initial = 80 }) -- Single Hook Rod
patchStock('Mep_Nhapopoluko', xi.item.BLUETAIL_1, { initial = 100 }) -- Bluetail
patchStock('Mep_Nhapopoluko', xi.item.NOBLE_LADY, { initial = 100 }) -- Noble Lady
patchStock('Mep_Nhapopoluko', xi.item.TRILOBITE, { initial = 100 }) -- Trilobite
patchStock('Mep_Nhapopoluko', xi.item.SHALL_SHELL, { initial = 100 }) -- Shall Shell
patchStock('Mep_Nhapopoluko', xi.item.ZAFMLUG_BASS, { initial = 100 }) -- Zafmlug Bass
patchStock('Mep_Nhapopoluko', xi.item.MOORISH_IDOL, { initial = 100 }) -- Moorish Idol
patchStock('Mep_Nhapopoluko', xi.item.BIBIKIBO, { initial = 100 }) -- Bibikibo
patchStock('Mep_Nhapopoluko', xi.item.BIBIKI_URCHIN, { initial = 100 }) -- Bibiki Urchin
patchStock('Mep_Nhapopoluko', xi.item.CLUMP_OF_PAMTAM_KELP, { initial = 100 }) -- Pamtam Kelp
patchStock('Mep_Nhapopoluko', xi.item.COBALT_JELLYFISH, { initial = 100 }) -- Cobalt Jellyfish

-- Pashi Maccaleh
patchStock('Pashi_Maccaleh', xi.item.SABIKI_RIG, { initial = 10 }) -- Sabiki Rig
patchStock('Pashi_Maccaleh', xi.item.MINNOW, { initial = 10 }) -- Minnow
patchStock('Pashi_Maccaleh', xi.item.TARUTARU_FISHING_ROD, { initial = 120 }) -- Tarutaru Fishing Rod

-- Rajmonda
patchStock('Rajmonda', xi.item.SABIKI_RIG, { initial = 10 }) -- Sabiki Rig
patchStock('Rajmonda', xi.item.MINNOW, { initial = 10 }) -- Minnow
patchStock('Rajmonda', xi.item.TARUTARU_FISHING_ROD, { initial = 120 }) -- Tarutaru Fishing Rod

-- Wahnid
patchStock('Wahnid', xi.item.LITTLE_WORM, { initial = 120 }) -- Little Worm
patchStock('Wahnid', xi.item.LUGWORM, { initial = 120 }) -- Lugworm
patchStock('Wahnid', xi.item.BALL_OF_SARDINE_PASTE, { initial = 0, restockRate = 0 }) -- Sardine Ball
patchStock('Wahnid', xi.item.BALL_OF_CRAYFISH_PASTE, { initial = 0, restockRate = 0 }) -- Shrimp Lure
patchStock('Wahnid', xi.item.BALL_OF_INSECT_PASTE, { initial = 0, restockRate = 0 }) -- Bug Lure
patchStock('Wahnid', xi.item.BALL_OF_TROUT_PASTE, { initial = 0, restockRate = 0 }) -- Trout Lure
patchStock('Wahnid', xi.item.MEATBALL, { initial = 0, restockRate = 0 }) -- Meat Lure
patchStock('Wahnid', xi.item.SLICE_OF_SARDINE, { initial = 0, restockRate = 0 }) -- Slice of Sardine
patchStock('Wahnid', xi.item.SLICE_OF_COD, { initial = 0, restockRate = 0 }) -- Slice of Cod
patchStock('Wahnid', xi.item.PEELED_LOBSTER, { initial = 0, restockRate = 0 }) -- Peeled Lobster
patchStock('Wahnid', xi.item.SLICE_OF_BLUETAIL, { initial = 0, restockRate = 0 }) -- Slice of Bluetail
patchStock('Wahnid', xi.item.PEELED_CRAYFISH, { initial = 0, restockRate = 0 }) -- Peeled Crayfish
patchStock('Wahnid', xi.item.SLICE_OF_MOAT_CARP, { initial = 0, restockRate = 0 }) -- Slice of Moat Carp
patchStock('Wahnid', xi.item.FLY_LURE, { initial = 0, restockRate = 0 }) -- Fly Lure
patchStock('Wahnid', xi.item.MINNOW, { initial = 0, restockRate = 0 }) -- Minnow
patchStock('Wahnid', xi.item.SINKING_MINNOW, { initial = 0, restockRate = 0 }) -- Sinking Minnow
patchStock('Wahnid', xi.item.SABIKI_RIG, { initial = 120, restockRate = 12 }) -- Sabiki Rig
patchStock('Wahnid', xi.item.YEW_FISHING_ROD, { initial = 0, restockRate = 0 }) -- Yew Fishing Rod
patchStock('Wahnid', xi.item.BAMBOO_FISHING_ROD, { initial = 90 }) -- Bamboo Fishing Rod
patchStock('Wahnid', xi.item.FASTWATER_FISHING_ROD, { initial = 60, restockRate = 6 }) -- Fastwater Rod
patchStock('Wahnid', xi.item.TARUTARU_FISHING_ROD, { initial = 30, restockRate = 3 }) -- Tarutaru Fishing Rod
patchStock('Wahnid', xi.item.DENIZANASI, { restockRate = 0 }) -- Denizanasi

-- Yahliq
patchStock('Yahliq', xi.item.SABIKI_RIG, { initial = 10 }) -- Sabiki Rig
patchStock('Yahliq', xi.item.MINNOW, { initial = 10 }) -- Minnow
patchStock('Yahliq', xi.item.ICE_CARD, { initial = 120 }) -- Ice Card
patchStock('Yahliq', xi.item.THUNDER_CARD, { initial = 120 }) -- Thunder Card
patchStock('Yahliq', xi.item.LIGHT_CARD, { initial = 120 }) -- Light Card
patchStock('Yahliq', xi.item.DARK_CARD, { initial = 120 }) -- Dark Card

-----------------------------------
-- Tenshodo
-----------------------------------
-- Jabbar
patchStock('Jabbar', xi.item.BAMBOO_STICK, { initial = 30 }) -- Bamboo Stick
patchStock('Jabbar', xi.item.SCROLL_OF_KATON_ICHI, { initial = 10 }) -- Katon: Ichi
patchStock('Jabbar', xi.item.SCROLL_OF_HUTON_ICHI, { initial = 10 }) -- Huton: Ichi
patchStock('Jabbar', xi.item.SCROLL_OF_DOTON_ICHI, { initial = 10 }) -- Doton: Ichi
patchStock('Jabbar', xi.item.SCROLL_OF_ABSORB_MND, { initial = 12 }) -- Absorb MND
patchStock('Jabbar', xi.item.SCROLL_OF_ABSORB_CHR, { initial = 12 }) -- Absorb CHR
patchStock('Jabbar', xi.item.ONZ_OF_TURMERIC, { initial = 30 }) -- Turmeric
patchStock('Jabbar', xi.item.ONZ_OF_CORIANDER, { initial = 30 }) -- Coriander
patchStock('Jabbar', xi.item.SPRIG_OF_HOLY_BASIL, { initial = 30 }) -- Holy Basil
patchStock('Jabbar', xi.item.ONZ_OF_CURRY_POWDER, { initial = 15 }) -- Curry Powder
patchStock('Jabbar', xi.item.JAR_OF_GROUND_WASABI, { initial = 50 }) -- Ground Wasabi
patchStock('Jabbar', xi.item.BOTTLE_OF_RICE_VINEGAR, { initial = 50 }) -- Rice Vinegar
patchStock('Jabbar', xi.item.CLUMP_OF_SHUNGIKU, { initial = 50 }) -- Shungiku

-- Silver_Owl
patchStock('Silver_Owl', xi.item.KUNAI, { initial = 15 }) -- Kunai
patchStock('Silver_Owl', xi.item.SHINOBI_GATANA, { initial = 15 }) -- Shinobi Gatana
patchStock('Silver_Owl', xi.item.KANESADA, { initial = 5 }) -- Kanesada
patchStock('Silver_Owl', xi.item.TACHI, { initial = 15 }) -- Tachi
patchStock('Silver_Owl', xi.item.KOTETSU, { initial = 5 }) -- Kotetsu
patchStock('Silver_Owl', xi.item.HACHIMAKI, { initial = 10 }) -- Hachimaki
patchStock('Silver_Owl', xi.item.COTTON_HACHIMAKI, { initial = 10 }) -- Cotton Hachimaki
patchStock('Silver_Owl', xi.item.KENPOGI, { initial = 10 }) -- Kenpogi
patchStock('Silver_Owl', xi.item.COTTON_DOGI, { initial = 10 }) -- Cotton Dogi
patchStock('Silver_Owl', xi.item.TEKKO, { initial = 10 }) -- Tekko
patchStock('Silver_Owl', xi.item.COTTON_TEKKO, { initial = 10 }) -- Cotton Tekko
patchStock('Silver_Owl', xi.item.SOIL_TEKKO, { initial = 10, restockRate = 5 }) -- Soil Tekko
patchStock('Silver_Owl', xi.item.SITABAKI, { initial = 10 }) -- Sitabaki
patchStock('Silver_Owl', xi.item.COTTON_SITABAKI, { initial = 10 }) -- Cotton Sitabaki
patchStock('Silver_Owl', xi.item.SOIL_SITABAKI, { initial = 10, restockRate = 5 }) -- Soil Sitabaki
patchStock('Silver_Owl', xi.item.KYAHAN, { initial = 10 }) -- Kyahan
patchStock('Silver_Owl', xi.item.COTTON_KYAHAN, { initial = 10 }) -- Cotton Kyahan
removeStock('Silver_Owl', xi.item.JUJI_SHURIKEN)

-- Jirokichi
patchStock('Jirokichi', xi.item.KUNAI, { initial = 30 }) -- Kunai
patchStock('Jirokichi', xi.item.SUZUME, { initial = 30 }) -- Suzume
patchStock('Jirokichi', xi.item.WAKIZASHI, { initial = 30 }) -- Wakizashi
patchStock('Jirokichi', xi.item.SHINOBI_GATANA, { initial = 30 }) -- Shinobi Gatana
patchStock('Jirokichi', xi.item.UCHIGATANA, { initial = 30 }) -- Uchigatana
patchStock('Jirokichi', xi.item.KANESADA, { initial = 10 }) -- Kanesada
patchStock('Jirokichi', xi.item.TACHI, { initial = 30 }) -- Tachi
patchStock('Jirokichi', xi.item.NODACHI, { initial = 10 }) -- Nodachi
patchStock('Jirokichi', xi.item.OKANEHIRA, { initial = 5 }) -- Okanehira
patchStock('Jirokichi', xi.item.SHURIKEN, { initial = 30 }) -- Shuriken
patchStock('Jirokichi', xi.item.JUJI_SHURIKEN, { initial = 20, buyMax = 2970 }) -- Juji Shuriken, buyMax changed because of RMT change reverts

-- Achika
patchStock('Achika', xi.item.HACHIMAKI, { initial = 30 }) -- Hachimaki
patchStock('Achika', xi.item.TEKKO, { initial = 30 }) -- Tekko
patchStock('Achika', xi.item.COTTON_KYAHAN, { initial = 30 }) -- Cotton Kyahan
patchStock('Achika', xi.item.SOIL_KYAHAN, { initial = 30 }) -- Soil Kyahan

-- Chiyo
patchStock('Chiyo', xi.item.SCROLL_OF_HYOTON_ICHI, { initial = 20 }) -- Hyoton: Ichi
patchStock('Chiyo', xi.item.SCROLL_OF_HUTON_ICHI, { initial = 20 }) -- Huton: Ichi
patchStock('Chiyo', xi.item.SCROLL_OF_DOTON_ICHI, { initial = 20 }) -- Doton: Ichi
patchStock('Chiyo', xi.item.SCROLL_OF_RAITON_ICHI, { initial = 20 }) -- Raiton: Ichi
patchStock('Chiyo', xi.item.SCROLL_OF_SUITON_ICHI, { initial = 20 }) -- Suiton: Ichi

-- Vuliaie
patchStock('Vuliaie', xi.item.JAR_OF_TOAD_OIL, { initial = 10 }) -- Toad Oil
patchStock('Vuliaie', xi.item.SHEET_OF_BAST_PARCHMENT, { initial = 6 }) -- Bast Parchment
patchStock('Vuliaie', xi.item.HANDFUL_OF_IRON_SAND, { initial = 180 }) -- Iron Sand
patchStock('Vuliaie', xi.item.UCHITAKE, { initial = 60 }) -- Uchitake
patchStock('Vuliaie', xi.item.TSURARA, { initial = 60 }) -- Tsurara
patchStock('Vuliaie', xi.item.KAWAHORI_OGI, { initial = 60 }) -- Kawahori Ogi
patchStock('Vuliaie', xi.item.MAKIBISHI, { initial = 60 }) -- Makibishi
patchStock('Vuliaie', xi.item.HIRAISHIN, { initial = 60 }) -- Hiraishin
patchStock('Vuliaie', xi.item.MIZU_DEPPO, { initial = 60 }) -- Mizu Deppo
patchStock('Vuliaie', xi.item.GARDENIA_SEED, { initial = 50 }) -- Gardenia Seed
patchStock('Vuliaie', xi.item.ONZ_OF_TURMERIC, { initial = 120 }) -- Turmeric
patchStock('Vuliaie', xi.item.ONZ_OF_CORIANDER, { initial = 120 }) -- Coriander
patchStock('Vuliaie', xi.item.SPRIG_OF_HOLY_BASIL, { initial = 120 }) -- Holy Basil
patchStock('Vuliaie', xi.item.ONZ_OF_CURRY_POWDER, { initial = 60 }) -- Curry Powder
patchStock('Vuliaie', xi.item.JAR_OF_GROUND_WASABI, { initial = 100 }) -- Ground Wasabi
patchStock('Vuliaie', xi.item.BOTTLE_OF_RICE_VINEGAR, { initial = 100 }) -- Rice Vinegar
patchStock('Vuliaie', xi.item.HEAD_OF_NAPA, { initial = 100 }) -- Napa
table.insert(xi.data.guildShops['Vuliaie'].stock, { id = xi.item.KOMA,  initial = 30,  maxStock = 60,  targetStock = 45,  buyMax = 660,  restockRate = 15 }) -- Koma

-- Tsutsuroon
patchStock('Tsutsuroon', xi.item.KUNAI, { initial = 30 }) -- Kunai
patchStock('Tsutsuroon', xi.item.SUZUME, { initial = 30 }) -- Suzume
patchStock('Tsutsuroon', xi.item.WAKIZASHI, { initial = 30 }) -- Wakizashi
patchStock('Tsutsuroon', xi.item.SHINOBI_GATANA, { initial = 30 }) -- Shinobi Gatana
patchStock('Tsutsuroon', xi.item.UCHIGATANA, { initial = 30 }) -- Uchigatana
patchStock('Tsutsuroon', xi.item.KANESADA, { initial = 10 }) -- Kanesada
patchStock('Tsutsuroon', xi.item.TACHI, { initial = 30 }) -- Tachi
patchStock('Tsutsuroon', xi.item.NODACHI, { initial = 10 }) -- Nodachi
patchStock('Tsutsuroon', xi.item.OKANEHIRA, { initial = 5 }) -- Okanehira
patchStock('Tsutsuroon', xi.item.KOTETSU, { initial = 5 }) -- Kotetsu
patchStock('Tsutsuroon', xi.item.SHURIKEN, { initial = 30 }) -- Shuriken
patchStock('Tsutsuroon', xi.item.JUJI_SHURIKEN, { initial = 20, buyMax = 2970 }) -- Juji Shuriken, buyMax changed because of RMT change reverts
patchStock('Tsutsuroon', xi.item.FIRE_ARROW, { initial = 30 }) -- Fire Arrow
patchStock('Tsutsuroon', xi.item.BULLET, { initial = 20 }) -- Bullet
patchStock('Tsutsuroon', xi.item.FUMA_SHURIKEN, { buyMax = 78750 }) -- Fuma Shuriken, buyMax changed because of RMT change reverts
patchStock('Tsutsuroon', xi.item.SOIL_HACHIMAKI, { initial = 30 }) -- Soil Hachimaki
patchStock('Tsutsuroon', xi.item.KENPOGI, { initial = 30 }) -- Kenpogi
patchStock('Tsutsuroon', xi.item.COTTON_DOGI, { initial = 30 }) -- Cotton Dogi
patchStock('Tsutsuroon', xi.item.SOIL_GI, { initial = 30 }) -- Soil Gi
patchStock('Tsutsuroon', xi.item.TEKKO, { initial = 30 }) -- Tekko
patchStock('Tsutsuroon', xi.item.COTTON_TEKKO, { initial = 30 }) -- Cotton Tekko
patchStock('Tsutsuroon', xi.item.SITABAKI, { initial = 30 }) -- Sitabaki
patchStock('Tsutsuroon', xi.item.COTTON_SITABAKI, { initial = 30 }) -- Cotton Sitabaki
patchStock('Tsutsuroon', xi.item.SOIL_SITABAKI, { initial = 30 }) -- Soil Sitabaki
patchStock('Tsutsuroon', xi.item.KYAHAN, { initial = 30 }) -- Kyahan
patchStock('Tsutsuroon', xi.item.COTTON_KYAHAN, { initial = 30 }) -- Cotton Kyahan
patchStock('Tsutsuroon', xi.item.SOIL_KYAHAN, { initial = 30 }) -- Soil Kyahan
patchStock('Tsutsuroon', xi.item.JAR_OF_TOAD_OIL, { initial = 10 }) -- Toad Oil
patchStock('Tsutsuroon', xi.item.SHEET_OF_BAST_PARCHMENT, { initial = 6 }) -- Bast Parchment
patchStock('Tsutsuroon', xi.item.SQUARE_OF_SILK_CLOTH, { initial = 10 }) -- Silk Cloth
patchStock('Tsutsuroon', xi.item.HANDFUL_OF_IRON_SAND, { initial = 180, buyMax = 3074 }) -- Iron Sand, buyMax changed because of RMT change reverts
patchStock('Tsutsuroon', xi.item.UCHITAKE, { initial = 60 }) -- Uchitake
patchStock('Tsutsuroon', xi.item.TSURARA, { initial = 60 }) -- Tsurara
patchStock('Tsutsuroon', xi.item.KAWAHORI_OGI, { initial = 60 }) -- Kawahori Ogi
patchStock('Tsutsuroon', xi.item.MAKIBISHI, { initial = 60 }) -- Makibishi
patchStock('Tsutsuroon', xi.item.HIRAISHIN, { initial = 60 }) -- Hiraishin
patchStock('Tsutsuroon', xi.item.MIZU_DEPPO, { initial = 60 }) -- Mizu Deppo
patchStock('Tsutsuroon', xi.item.GARDENIA_SEED, { initial = 50 }) -- Gardenia Seed
patchStock('Tsutsuroon', xi.item.ONZ_OF_TURMERIC, { initial = 120 }) -- Turmeric
patchStock('Tsutsuroon', xi.item.ONZ_OF_CORIANDER, { initial = 120 }) -- Coriander
patchStock('Tsutsuroon', xi.item.SPRIG_OF_HOLY_BASIL, { initial = 120 }) -- Holy Basil
patchStock('Tsutsuroon', xi.item.ONZ_OF_CURRY_POWDER, { initial = 60 }) -- Curry Powder
patchStock('Tsutsuroon', xi.item.JAR_OF_GROUND_WASABI, { initial = 100 }) -- Ground Wasabi
patchStock('Tsutsuroon', xi.item.BOTTLE_OF_RICE_VINEGAR, { initial = 100 }) -- Rice Vinegar
patchStock('Tsutsuroon', xi.item.HEAD_OF_NAPA, { initial = 100 }) -- Napa
table.insert(xi.data.guildShops['Tsutsuroon'].stock, { id = xi.item.KOMA,  initial = 30,  maxStock = 60,  targetStock = 45,  buyMax = 660,  restockRate = 15 }) -- Koma

-----------------------------------
-- Tenshodo (new shops -- Akamafula and Amalasanda did not exist in base guild_shops.lua)
-----------------------------------
xi.data.guildShops['Akamafula'] =
{
    hours = { 1, 23 },
    holiday = xi.day.EARTHSDAY,
    stock =
    {
        { id = xi.item.KUNAI,             initial = 20,  maxStock = 60,  targetStock = 55,  buyMax = 4419,    restockRate =  5 }, -- Kunai
        { id = xi.item.WAKIZASHI,         initial = 20,  maxStock = 60,  targetStock = 55,  buyMax = 12000,   restockRate =  5 }, -- Wakizashi
        { id = xi.item.UCHIGATANA,        initial = 20,  maxStock = 60,  targetStock = 55,  buyMax = 26680,   restockRate =  5 }, -- Uchigatana
        { id = xi.item.KANESADA,          initial = 2,   maxStock = 60,  targetStock = 55,  buyMax = 99000,   restockRate = 10 }, -- Kanesada
        { id = xi.item.TACHI,             initial = 20,  maxStock = 60,  targetStock = 55,  buyMax = 15695,   restockRate =  5 }, -- Tachi
        { id = xi.item.NODACHI,           initial = 2,   maxStock = 60,  targetStock = 55,  buyMax = 40620,   restockRate =  0 }, -- Nodachi
        { id = xi.item.OKANEHIRA,         initial = 5,   maxStock = 60,  targetStock = 55,  buyMax = 104730,  restockRate =  7 }, -- Okanehira
        { id = xi.item.TANEGASHIMA,       initial = 2,   maxStock = 60,  targetStock = 55,  buyMax = 65310,   restockRate =  0 }, -- Tanegashima
        { id = xi.item.SHURIKEN,          initial = 30,  maxStock = 60,  targetStock = 55,  buyMax = 250,     restockRate = 10 }, -- Shuriken
        { id = xi.item.HACHIMAKI,         initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 4125,    restockRate =  3 }, -- Hachimaki
        { id = xi.item.COTTON_HACHIMAKI,  initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 24420,   restockRate =  3 }, -- Cotton Hachimaki
        { id = xi.item.SOIL_HACHIMAKI,    initial = 10,  maxStock = 60,  targetStock = 45,  buyMax = 66960,   restockRate =  5 }, -- Soil Hachimaki
        { id = xi.item.KENPOGI,           initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 6225,    restockRate =  3 }, -- Kenpogi
        { id = xi.item.COTTON_DOGI,       initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 36800,   restockRate =  3 }, -- Cotton Dogi
        { id = xi.item.SOIL_GI,           initial = 10,  maxStock = 60,  targetStock = 45,  buyMax = 99000,   restockRate =  5 }, -- Soil Gi
        { id = xi.item.TEKKO,             initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 3425,    restockRate =  3 }, -- Tekko
        { id = xi.item.COTTON_TEKKO,      initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 20250,   restockRate =  3 }, -- Cotton Tekko
        { id = xi.item.SOIL_TEKKO,        initial = 10,  maxStock = 60,  targetStock = 45,  buyMax = 55440,   restockRate =  5 }, -- Soil Tekko
        { id = xi.item.SITABAKI,          initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 4975,    restockRate =  3 }, -- Sitabaki
        { id = xi.item.COTTON_SITABAKI,   initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 29490,   restockRate =  3 }, -- Cotton Sitabaki
        { id = xi.item.SOIL_SITABAKI,     initial = 10,  maxStock = 60,  targetStock = 45,  buyMax = 80640,   restockRate =  5 }, -- Soil Sitabaki
        { id = xi.item.KYAHAN,            initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 3175,    restockRate =  3 }, -- Kyahan
        { id = xi.item.COTTON_KYAHAN,     initial = 5,   maxStock = 60,  targetStock = 45,  buyMax = 18870,   restockRate =  3 }, -- Cotton Kyahan
        { id = xi.item.SOIL_KYAHAN,       initial = 10,  maxStock = 60,  targetStock = 45,  buyMax = 82620,   restockRate =  5 }, -- Soil Kyahan
    },
}

xi.data.guildShops['Amalasanda'] =
{
    hours = { 9, 23 },
    holiday = xi.day.EARTHSDAY,
    stock =
    {
        { id = xi.item.BAMBOO_STICK,            initial = 30,   maxStock = 240,  targetStock = 180,  buyMax = 720,     restockRate =  10 }, -- Bamboo Stick
        { id = xi.item.KOMA,                    initial = 30,   maxStock = 60,   targetStock = 45,   buyMax = 660,     restockRate =  15 }, -- Koma
        { id = xi.item.LUMP_OF_TAMA_HAGANE,     initial = 20,   maxStock = 60,   targetStock = 45,   buyMax = 35000,   restockRate =   5 }, -- Tama Hagane
        { id = xi.item.POT_OF_URUSHI,           initial = 10,   maxStock = 60,   targetStock = 45,   buyMax = 367650,  restockRate =   1 }, -- Urushi
        { id = xi.item.BOX_OF_STICKY_RICE,      initial = 50,   maxStock = 150,  targetStock = 120,  buyMax = 316,     restockRate = 100, priceFloor = 150, noSell = true }, -- Sticky Rice
        { id = xi.item.BAG_OF_BUCKWHEAT_FLOUR,  initial = 50,   maxStock = 150,  targetStock = 120,  buyMax = 1500,    restockRate = 100, priceFloor = 150, noSell = true }, -- Buckwheat Flour
        { id = xi.item.PINCH_OF_BLACK_PEPPER,   initial = 10,   maxStock = 60,   targetStock = 45,   buyMax = 1111,    restockRate =   5 }, -- Black Pepper
        { id = xi.item.ONZ_OF_TURMERIC,         initial = 20,   maxStock = 60,   targetStock = 50,   buyMax = 3225,    restockRate =  15 }, -- Turmeric
        { id = xi.item.ONZ_OF_CORIANDER,        initial = 20,   maxStock = 60,   targetStock = 50,   buyMax = 7925,    restockRate =  15 }, -- Coriander
        { id = xi.item.SPRIG_OF_HOLY_BASIL,     initial = 20,   maxStock = 60,   targetStock = 50,   buyMax = 4000,    restockRate =  15 }, -- Holy Basil
        { id = xi.item.ONZ_OF_CURRY_POWDER,     initial = 10,   maxStock = 30,   targetStock = 25,   buyMax = 1456,    restockRate =   7 }, -- Curry Powder
        { id = xi.item.JAR_OF_GROUND_WASABI,    initial = 100,  maxStock = 150,  targetStock = 120,  buyMax = 12974,   restockRate = 100 }, -- Wasabi
        { id = xi.item.BOTTLE_OF_RICE_VINEGAR,  initial = 100,  maxStock = 150,  targetStock = 120,  buyMax = 1000,    restockRate = 100 }, -- Rice Vinegar
        { id = xi.item.BUNDLE_OF_SHIRATAKI,     initial = 50,   maxStock = 150,  targetStock = 120,  buyMax = 369,     restockRate = 100, priceFloor = 150, noSell = true }, -- Shirataki
        { id = xi.item.SCROLL_OF_KATON_ICHI,    initial = 10,   maxStock = 60,   targetStock = 45,   buyMax = 11655,   restockRate =   3 }, -- Katon: Ichi
        { id = xi.item.SCROLL_OF_HUTON_ICHI,    initial = 10,   maxStock = 60,   targetStock = 45,   buyMax = 11655,   restockRate =   3 }, -- Huton: Ichi
        { id = xi.item.SCROLL_OF_DOTON_ICHI,    initial = 10,   maxStock = 60,   targetStock = 45,   buyMax = 11655,   restockRate =   3 }, -- Doton: Ichi
        { id = xi.item.SCROLL_OF_SUITON_ICHI,   initial = 10,   maxStock = 60,   targetStock = 45,   buyMax = 11655,   restockRate =   3 }, -- Suiton: Ichi
        { id = xi.item.UCHITAKE,                initial = 10,   maxStock = 60,   targetStock = 50,   buyMax = 200,     restockRate =   0 }, -- Uchitake
        { id = xi.item.KAWAHORI_OGI,            initial = 10,   maxStock = 60,   targetStock = 50,   buyMax = 200,     restockRate =   0 }, -- Kawahori Ogi
        { id = xi.item.MAKIBISHI,               initial = 10,   maxStock = 60,   targetStock = 50,   buyMax = 200,     restockRate =   0 }, -- Makibishi
        { id = xi.item.MIZU_DEPPO,              initial = 10,   maxStock = 60,   targetStock = 50,   buyMax = 200,     restockRate =   0 }, -- Mizu Deppo
    },
}

-----------------------------------
-- Linkshell / Pendant Compass Vendors
-----------------------------------
removeStock('Ilita', xi.item.PENDANT_COMPASS) -- Pendant Compass
removeStock('Khel_Pahlhama', xi.item.PENDANT_COMPASS) -- Pendant Compass
removeStock('Paunelie', xi.item.PENDANT_COMPASS) -- Pendant Compass

return { name = moduleName }
