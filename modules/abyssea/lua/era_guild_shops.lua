-----------------------------------
-- Era Guild Shops
-- Info from 2009 Guild Masters Guide Ver.101207, FFXI Lightning Brigade Ver.070613 and various archived https://wiki.ffo.jp/ pages
-----------------------------------
require('modules/module_utils')
-----------------------------------
local moduleName = 'era_guild_shops'

-----------------------------------
-- Smithing
-----------------------------------
-- Amulya & Vicious Eye
xi.data.guildShops['Vicious_Eye'] = { sharedStock = 'Amulya' }
table.insert(xi.data.guildShops['Amulya'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 60, restockRate = 40 })
xi.data.guildShops['Amulya'].stock[2].initial     = 120 -- Tin Ore
xi.data.guildShops['Amulya'].stock[3].initial     = 120 -- Iron Ore
xi.data.guildShops['Amulya'].stock[6].initial     = 12 -- Bronze Ingot
xi.data.guildShops['Amulya'].stock[7].initial     = 12 -- Iron Ingot
xi.data.guildShops['Amulya'].stock[11].initial     = 12 -- Bronze Sheet
xi.data.guildShops['Amulya'].stock[12].initial     = 12 -- Iron Sheet
table.insert(xi.data.guildShops['Amulya'].stock, { id = xi.item.MANDREL, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })
table.insert(xi.data.guildShops['Amulya'].stock, { id = xi.item.WORKSHOP_ANVIL, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })

-- Doggomehr & Lucretia
xi.data.guildShops['Lucretia'] = { sharedStock = 'Doggomehr' }
table.insert(xi.data.guildShops['Doggomehr'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 60, restockRate = 60 })
xi.data.guildShops['Doggomehr'].stock[2].initial     = 120 -- Tin Ore
xi.data.guildShops['Doggomehr'].stock[3].initial     = 120 -- Iron Ore
xi.data.guildShops['Doggomehr'].stock[6].initial     = 12 -- Bronze Ingot
xi.data.guildShops['Doggomehr'].stock[7].initial     = 12 -- Iron Ingot
xi.data.guildShops['Doggomehr'].stock[11].initial     = 12 -- Bronze Sheet
xi.data.guildShops['Doggomehr'].stock[12].initial     = 12 -- Iron Sheet
table.insert(xi.data.guildShops['Doggomehr'].stock, { id = xi.item.MANDREL, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })
table.insert(xi.data.guildShops['Doggomehr'].stock, { id = xi.item.WORKSHOP_ANVIL, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })

-- Mololo & Kamilah
xi.data.guildShops['Mololo'] = { sharedStock = 'Kamilah' }
table.insert(xi.data.guildShops['Kamilah'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 60, restockRate = 20 })
xi.data.guildShops['Kamilah'].stock[2].initial     = 120 -- Tin Ore
xi.data.guildShops['Kamilah'].stock[3].initial     = 120 -- Iron Ore
xi.data.guildShops['Kamilah'].stock[4].initial     = 60 -- Bronze Ingot
xi.data.guildShops['Kamilah'].stock[4].restockRate = 10 -- Bronze Ingot
xi.data.guildShops['Kamilah'].stock[5].initial     = 30 -- Iron Ingot
xi.data.guildShops['Kamilah'].stock[5].restockRate = 2 -- Iron Ingot

-- Ndego
xi.data.guildShops['Ndego'].stock[1].initial     = 120 -- Copper Ore
xi.data.guildShops['Ndego'].stock[2].initial     = 120 -- Tin Ore
xi.data.guildShops['Ndego'].stock[3].initial     = 120 -- Iron Ore
xi.data.guildShops['Ndego'].stock[6].initial     = 12 -- Bronze Ingot
xi.data.guildShops['Ndego'].stock[7].initial     = 12 -- Iron Ingot
xi.data.guildShops['Ndego'].stock[11].initial     = 12 -- Bronze Sheet
xi.data.guildShops['Ndego'].stock[12].initial     = 12 -- Iron Sheet
xi.data.guildShops['Ndego'].stock[80].initial     = 120 -- Mandrel
xi.data.guildShops['Ndego'].stock[81].initial     = 120 -- Workshop Anvil

-----------------------------------
-- Goldsmithing
-----------------------------------
-- Bornahn
xi.data.guildShops['Bornahn'].stock[1].initial     = 120 -- Copper Ore
xi.data.guildShops['Bornahn'].stock[3].initial     = 120 -- Silver Ore
xi.data.guildShops['Bornahn'].stock[4].initial     = 0 -- Mythril Ore
xi.data.guildShops['Bornahn'].stock[13].initial     = 1 -- Brass Sheet
xi.data.guildShops['Bornahn'].stock[13].restockRate = 1 -- Brass Sheet
xi.data.guildShops['Bornahn'].stock[17].initial     = 0 -- Handful of Brass Scales
xi.data.guildShops['Bornahn'].stock[17].restockRate = 0 -- Handful of Brass Scales
xi.data.guildShops['Bornahn'].stock[19].initial     = 1 -- Mythril Chain
xi.data.guildShops['Bornahn'].stock[22].initial     = 2 -- Red Rock
xi.data.guildShops['Bornahn'].stock[23].initial     = 2 -- Blue Rock
xi.data.guildShops['Bornahn'].stock[24].initial     = 2 -- Yellow Rock
xi.data.guildShops['Bornahn'].stock[25].initial     = 2 -- Green Rock
xi.data.guildShops['Bornahn'].stock[26].initial     = 2 -- Clear Rock
xi.data.guildShops['Bornahn'].stock[27].initial     = 2 -- Purple Rock
xi.data.guildShops['Bornahn'].stock[28].initial     = 2 -- Black Rock
xi.data.guildShops['Bornahn'].stock[29].initial     = 2 -- White Stone
xi.data.guildShops['Bornahn'].stock[30].initial     = 6 -- Lapis Lazuli
xi.data.guildShops['Bornahn'].stock[31].initial     = 6 -- Light Opal
xi.data.guildShops['Bornahn'].stock[32].initial     = 6 -- Onyx
xi.data.guildShops['Bornahn'].stock[33].initial     = 6 -- Amethyst
xi.data.guildShops['Bornahn'].stock[34].initial     = 6 -- Tourmaline
xi.data.guildShops['Bornahn'].stock[35].initial     = 6 -- Sardonyx
xi.data.guildShops['Bornahn'].stock[36].initial     = 6 -- Clear Topaz
xi.data.guildShops['Bornahn'].stock[37].initial     = 6 -- Amber
xi.data.guildShops['Bornahn'].stock[126].initial     = 0 -- Workshop Anvil
xi.data.guildShops['Bornahn'].stock[126].restockRate = 0 -- Workshop Anvil

-- Teerth & Visala
xi.data.guildShops['Teerth'] = { sharedStock = 'Visala' }
table.insert(xi.data.guildShops['Visala'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 60, restockRate = 60 })
xi.data.guildShops['Visala'].stock[2].initial     = 120 -- Silver Ore
xi.data.guildShops['Visala'].stock[3].initial     = 0 -- Mythril Ore
xi.data.guildShops['Visala'].stock[12].initial     = 1 -- Brass Sheet
xi.data.guildShops['Visala'].stock[12].restockRate = 1 -- Brass Sheet
xi.data.guildShops['Visala'].stock[16].initial     = 0 -- Handful of Brass Scales
xi.data.guildShops['Visala'].stock[16].restockRate = 0 -- Handful of Brass Scales
xi.data.guildShops['Visala'].stock[18].initial     = 1 -- Mythril Chain
xi.data.guildShops['Visala'].stock[21].initial     = 2 -- Red Rock
xi.data.guildShops['Visala'].stock[22].initial     = 2 -- Blue Rock
xi.data.guildShops['Visala'].stock[23].initial     = 2 -- Yellow Rock
xi.data.guildShops['Visala'].stock[24].initial     = 2 -- Green Rock
xi.data.guildShops['Visala'].stock[25].initial     = 2 -- Clear Rock
xi.data.guildShops['Visala'].stock[26].initial     = 2 -- Purple Rock
xi.data.guildShops['Visala'].stock[27].initial     = 2 -- Black Rock
xi.data.guildShops['Visala'].stock[28].initial     = 2 -- White Stone
xi.data.guildShops['Visala'].stock[29].initial     = 6 -- Lapis Lazuli
xi.data.guildShops['Visala'].stock[30].initial     = 6 -- Light Opal
xi.data.guildShops['Visala'].stock[31].initial     = 6 -- Onyx
xi.data.guildShops['Visala'].stock[32].initial     = 6 -- Amethyst
xi.data.guildShops['Visala'].stock[33].initial     = 6 -- Tourmaline
xi.data.guildShops['Visala'].stock[34].initial     = 6 -- Sardonyx
xi.data.guildShops['Visala'].stock[35].initial     = 6 -- Clear Topaz
xi.data.guildShops['Visala'].stock[36].initial     = 6 -- Amber
xi.data.guildShops['Visala'].stock[125].initial     = 120 -- Tufa

-- Yabby Tanmikey & Celestina
xi.data.guildShops['Celestina'] = { sharedStock = 'Yabby_Tanmikey' }
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE, initial = 90, maxStock = 240, targetStock = 180, buyMax = 133, restockRate = 15 }) -- buyMax Mhaura-specific (20g vs 9g at Bastok/Al Zahbi)
xi.data.guildShops['Yabby_Tanmikey'].stock[2].initial     = 70 -- Silver Ore
xi.data.guildShops['Yabby_Tanmikey'].stock[2].buyMax     = 4700 -- Silver Ore, Mhaura-specific price curve (705g vs 315g at Bastok/Al Zahbi)
xi.data.guildShops['Yabby_Tanmikey'].stock[21].initial     = 2 -- Red Rock
xi.data.guildShops['Yabby_Tanmikey'].stock[22].initial     = 2 -- Blue Rock
xi.data.guildShops['Yabby_Tanmikey'].stock[23].initial     = 2 -- Yellow Rock
xi.data.guildShops['Yabby_Tanmikey'].stock[24].initial     = 2 -- Green Rock
xi.data.guildShops['Yabby_Tanmikey'].stock[25].initial     = 2 -- Clear Rock
xi.data.guildShops['Yabby_Tanmikey'].stock[26].initial     = 2 -- Purple Rock
xi.data.guildShops['Yabby_Tanmikey'].stock[27].initial     = 2 -- Black Rock
xi.data.guildShops['Yabby_Tanmikey'].stock[28].initial     = 2 -- White Stone
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, { id = xi.item.MANDREL, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, { id = xi.item.WORKSHOP_ANVIL, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })

-----------------------------------
-- Woodworking
-----------------------------------
-- Cauzeriste & Chaupire
xi.data.guildShops['Cauzeriste'] = { sharedStock = 'Chaupire' }
table.insert(xi.data.guildShops['Chaupire'].stock, 1, { id = xi.item.ARROWWOOD_LOG, initial = 120, maxStock = 240, targetStock = 180, buyMax = 100, restockRate = 60 })
table.insert(xi.data.guildShops['Chaupire'].stock, 2, { id = xi.item.LAUAN_LOG, initial = 120, maxStock = 240, targetStock = 144, buyMax = 180, restockRate = 12 })
table.insert(xi.data.guildShops['Chaupire'].stock, 3, { id = xi.item.MAPLE_LOG, initial = 120, maxStock = 240, targetStock = 144, buyMax = 300, restockRate = 12 })
xi.data.guildShops['Chaupire'].stock[4].initial     = 120 -- Ash Log
xi.data.guildShops['Chaupire'].stock[5].initial     = 120 -- Willow Log
xi.data.guildShops['Chaupire'].stock[6].initial     = 90 -- Holly Log
xi.data.guildShops['Chaupire'].stock[7].initial     = 90 -- Yew Log
xi.data.guildShops['Chaupire'].stock[8].initial     = 60 -- Elm Log
xi.data.guildShops['Chaupire'].stock[9].initial     = 60 -- Walnut Log
xi.data.guildShops['Chaupire'].stock[10].initial     = 60 -- Chestnut Log
xi.data.guildShops['Chaupire'].stock[11].initial     = 30 -- Oak Log
xi.data.guildShops['Chaupire'].stock[12].initial     = 30 -- Rosewood Log
xi.data.guildShops['Chaupire'].stock[13].initial     = 10 -- Mahogany Log
xi.data.guildShops['Chaupire'].stock[14].initial     = 10 -- Ebony Log
xi.data.guildShops['Chaupire'].stock[15].initial     = 12 -- Bamboo Stick
xi.data.guildShops['Chaupire'].stock[17].initial     = 12 -- Arrowwood Lumber
xi.data.guildShops['Chaupire'].stock[18].initial     = 12 -- Lauan Lumber
xi.data.guildShops['Chaupire'].stock[19].initial     = 12 -- Maple Lumber
xi.data.guildShops['Chaupire'].stock[20].initial     = 12 -- Ash Lumber
xi.data.guildShops['Chaupire'].stock[21].initial     = 12 -- Willow Lumber
xi.data.guildShops['Chaupire'].stock[22].initial     = 9 -- Holly Lumber
xi.data.guildShops['Chaupire'].stock[23].initial     = 9 -- Yew Lumber
xi.data.guildShops['Chaupire'].stock[24].initial     = 12 -- Elm Lumber
xi.data.guildShops['Chaupire'].stock[24].restockRate = 12 -- Elm Lumber
xi.data.guildShops['Chaupire'].stock[25].initial     = 6 -- Chestnut Lumber
xi.data.guildShops['Chaupire'].stock[26].initial     = 6 -- Oak Lumber

-- Beugungel
xi.data.guildShops['Beugungel'].hours = { 5, 21 } -- close time corrected from base 22
xi.data.guildShops['Beugungel'].stock[1].initial     = 120 -- Bundling Twine
xi.data.guildShops['Beugungel'].stock[2].initial     = 120 -- Hatchet
xi.data.guildShops['Beugungel'].stock[3].initial     = 120 -- Arrowwood Log
xi.data.guildShops['Beugungel'].stock[4].initial     = 120 -- Ash Log
xi.data.guildShops['Beugungel'].stock[4].buyMax     = 500 -- Ash Log
xi.data.guildShops['Beugungel'].stock[5].initial     = 100 -- Yew Log
xi.data.guildShops['Beugungel'].stock[6].initial     = 100 -- Willow Log
xi.data.guildShops['Beugungel'].stock[7].initial     = 120 -- Walnut Log
xi.data.guildShops['Beugungel'].stock[7].restockRate = 50  -- Walnut Log

-- Dehbi_Moshal
xi.data.guildShops['Dehbi_Moshal'].stock[1].initial     = 120 -- Arrowwood Log
xi.data.guildShops['Dehbi_Moshal'].stock[2].initial     = 120 -- Lauan Log
xi.data.guildShops['Dehbi_Moshal'].stock[3].initial     = 120 -- Maple Log
xi.data.guildShops['Dehbi_Moshal'].stock[4].initial     = 100 -- Ash Log
xi.data.guildShops['Dehbi_Moshal'].stock[4].buyMax     = 400 -- Ash Log
xi.data.guildShops['Dehbi_Moshal'].stock[4].restockRate = 50 -- Ash Log
xi.data.guildShops['Dehbi_Moshal'].stock[5].initial     = 120 -- Willow Log
xi.data.guildShops['Dehbi_Moshal'].stock[5].restockRate = 20 -- Willow Log
xi.data.guildShops['Dehbi_Moshal'].stock[6].initial     = 90 -- Holly Log
xi.data.guildShops['Dehbi_Moshal'].stock[7].initial     = 120 -- Yew Log
xi.data.guildShops['Dehbi_Moshal'].stock[7].restockRate = 20 -- Yew Log
xi.data.guildShops['Dehbi_Moshal'].stock[8].initial     = 60 -- Elm Log
xi.data.guildShops['Dehbi_Moshal'].stock[9].initial     = 60 -- Walnut Log
xi.data.guildShops['Dehbi_Moshal'].stock[10].initial     = 60 -- Chestnut Log
xi.data.guildShops['Dehbi_Moshal'].stock[11].initial     = 30 -- Oak Log
xi.data.guildShops['Dehbi_Moshal'].stock[12].initial     = 30 -- Rosewood Log
xi.data.guildShops['Dehbi_Moshal'].stock[13].initial     = 10 -- Mahogany Log
xi.data.guildShops['Dehbi_Moshal'].stock[14].initial     = 10 -- Ebony Log
xi.data.guildShops['Dehbi_Moshal'].stock[17].initial     = 12 -- Bamboo Stick
xi.data.guildShops['Dehbi_Moshal'].stock[19].initial     = 12 -- Arrowwood Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[20].initial     = 12 -- Lauan Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[21].initial     = 12 -- Maple Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[22].initial     = 12 -- Ash Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[23].initial     = 12 -- Willow Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[24].initial     = 9 -- Holly Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[25].initial     = 9 -- Yew Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[26].initial     = 12 -- Elm Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[26].restockRate = 12 -- Elm Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[27].initial     = 6 -- Chestnut Lumber
xi.data.guildShops['Dehbi_Moshal'].stock[28].initial     = 6 -- Oak Lumber

-----------------------------------
-- Clothcraft
-----------------------------------
-- Kuzah Hpirohpon & Meriri
xi.data.guildShops['Meriri'] = { sharedStock = 'Kuzah_Hpirohpon' }
table.insert(xi.data.guildShops['Kuzah_Hpirohpon'].stock, 1, { id = xi.item.CLUMP_OF_MOKO_GRASS, initial = 120, maxStock = 240, targetStock = 180, buyMax = 100, restockRate = 60 })
xi.data.guildShops['Kuzah_Hpirohpon'].stock[2].initial     = 0 -- Saruta Cotton
xi.data.guildShops['Kuzah_Hpirohpon'].stock[2].buyMax     = 214 -- Saruta Cotton
xi.data.guildShops['Kuzah_Hpirohpon'].stock[3].initial     = 120 -- Flax
xi.data.guildShops['Kuzah_Hpirohpon'].stock[4].initial     = 120 -- Sheep Wool
xi.data.guildShops['Kuzah_Hpirohpon'].stock[5].initial     = 40 -- Crawler Cocoon
xi.data.guildShops['Kuzah_Hpirohpon'].stock[7].initial     = 120 -- Grass Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[8].initial     = 120 -- Cotton Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[8].buyMax     = 780 -- Cotton Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[9].initial     = 90 -- Linen Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[10].initial     = 60 -- Wool Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[11].initial     = 6 -- Silk Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[11].buyMax     = 2375 -- Silk Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[12].initial     = 4 -- Silver Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[12].buyMax     = 1875 -- Silver Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[13].initial     = 3 -- Gold Thread
xi.data.guildShops['Kuzah_Hpirohpon'].stock[15].initial     = 12 -- Grass Cloth
xi.data.guildShops['Kuzah_Hpirohpon'].stock[16].initial     = 12 -- Cotton Cloth
table.insert(xi.data.guildShops['Kuzah_Hpirohpon'].stock, 78, { id = xi.item.SPINDLE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })

-- Taten-Bilten
xi.data.guildShops['Taten-Bilten'].stock[1].initial     = 6 -- Silk Thread
xi.data.guildShops['Taten-Bilten'].stock[1].buyMax     = 2944 -- Silk Thread
xi.data.guildShops['Taten-Bilten'].stock[2].initial     = 120 -- Grass Thread
xi.data.guildShops['Taten-Bilten'].stock[3].initial     = 120 -- Cotton Thread
xi.data.guildShops['Taten-Bilten'].stock[4].initial     = 90 -- Linen Thread
xi.data.guildShops['Taten-Bilten'].stock[6].initial     = 4 -- Silver Thread
xi.data.guildShops['Taten-Bilten'].stock[6].buyMax     = 4480 -- Silver Thread
xi.data.guildShops['Taten-Bilten'].stock[7].initial     = 3 -- Gold Thread
xi.data.guildShops['Taten-Bilten'].stock[8].initial     = 12 -- Grass Cloth
xi.data.guildShops['Taten-Bilten'].stock[9].initial     = 12 -- Cotton Cloth
xi.data.guildShops['Taten-Bilten'].stock[14].initial     = 120 -- Sheep Wool
xi.data.guildShops['Taten-Bilten'].stock[15].initial     = 120 -- Moko Grass
xi.data.guildShops['Taten-Bilten'].stock[16].initial     = 0 -- Saruta Cotton
xi.data.guildShops['Taten-Bilten'].stock[16].buyMax     = 84 -- Saruta Cotton
xi.data.guildShops['Taten-Bilten'].stock[17].initial     = 120 -- Flax
xi.data.guildShops['Taten-Bilten'].stock[19].initial     = 40 -- Crawler Cocoon
xi.data.guildShops['Taten-Bilten'].stock[21].initial     = 120 -- Spindle
xi.data.guildShops['Taten-Bilten'].stock[22].initial     = 120 -- Spool of Zephyr Thread
xi.data.guildShops['Taten-Bilten'].stock[26].initial     = 60 -- Wamoura Cocoon
xi.data.guildShops['Taten-Bilten'].stock[27].initial     = 60 -- Karakul Thread
table.insert(xi.data.guildShops['Taten-Bilten'].stock, { id = xi.item.SPOOL_OF_WOOL_THREAD, initial = 60, maxStock = 120, targetStock = 90, buyMax = 18000, restockRate = 3 })

-- Tilala & Gibol
xi.data.guildShops['Gibol'] = { sharedStock = 'Tilala' }
table.insert(xi.data.guildShops['Tilala'].stock, 1, { id = xi.item.CLUMP_OF_MOKO_GRASS, initial = 120, maxStock = 240, targetStock = 180, buyMax = 100, restockRate = 40 })
xi.data.guildShops['Tilala'].stock[3].initial     = 60 -- Flax
xi.data.guildShops['Tilala'].stock[4].initial     = 55 -- Sheep Wool
xi.data.guildShops['Tilala'].stock[5].initial     = 40 -- Crawler Cocoon
xi.data.guildShops['Tilala'].stock[5].restockRate = 10 -- Crawler Cocoon
xi.data.guildShops['Tilala'].stock[7].initial     = 90 -- Grass Thread
xi.data.guildShops['Tilala'].stock[8].initial     = 90 -- Cotton Thread
xi.data.guildShops['Tilala'].stock[8].restockRate = 30 -- Cotton Thread
xi.data.guildShops['Tilala'].stock[9].initial     = 90 -- Linen Thread
xi.data.guildShops['Tilala'].stock[9].buyMax     = 4524 -- Linen Thread
xi.data.guildShops['Tilala'].stock[10].initial     = 60 -- Wool Thread
xi.data.guildShops['Tilala'].stock[11].initial     = 12 -- Silk Thread
xi.data.guildShops['Tilala'].stock[11].buyMax     = 699 -- Silk Thread
xi.data.guildShops['Tilala'].stock[12].initial     = 6 -- Silver Thread
xi.data.guildShops['Tilala'].stock[13].initial     = 3 -- Gold Thread

-----------------------------------
-- Leatherworking
-----------------------------------
-- Cletae & Kueh Igunahmori
xi.data.guildShops['Cletae'] = { sharedStock = 'Kueh_Igunahmori' }
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, 1, { id = xi.item.RABBIT_HIDE, initial = 12, maxStock = 160, targetStock = 120, buyMax = 400, restockRate = 12 }) -- targetStock assumed
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, 2, { id = xi.item.SHEEPSKIN,   initial = 12, maxStock = 160, targetStock = 120, buyMax = 506, restockRate = 12 }) -- targetStock assumed
xi.data.guildShops['Kueh_Igunahmori'].stock[4].initial     = 0 -- Wolf Hide
xi.data.guildShops['Kueh_Igunahmori'].stock[5].initial     = 0 -- Ram Skin
xi.data.guildShops['Kueh_Igunahmori'].stock[6].initial     = 0 -- Tiger Hide
xi.data.guildShops['Kueh_Igunahmori'].stock[7].initial     = 0 -- Coeurl Hide
xi.data.guildShops['Kueh_Igunahmori'].stock[16].initial     = 30 -- Raptor Skin
xi.data.guildShops['Kueh_Igunahmori'].stock[17].initial     = 30 -- Cockatrice Skin
xi.data.guildShops['Kueh_Igunahmori'].stock[19].initial     = 120 -- Willow Log
xi.data.guildShops['Kueh_Igunahmori'].stock[20].initial     = 120 -- Distilled Water
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, { id = xi.item.TANNING_VAT, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })

-----------------------------------
-- Bonecraft
-----------------------------------
-- Retto-Marutto & Shih Tayuun
xi.data.guildShops['Retto-Marutto'] = { sharedStock = 'Shih_Tayuun' }
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, 1, { id = xi.item.BONE_CHIP, initial = 12, maxStock = 240, targetStock = 180, buyMax = 380, restockRate = 12 })
xi.data.guildShops['Shih_Tayuun'].stock[3].initial     = 12  -- Sheep Tooth
xi.data.guildShops['Shih_Tayuun'].stock[5].initial     = 4   -- Turtle Shell
xi.data.guildShops['Shih_Tayuun'].stock[6].initial     = 120 -- Seashell
xi.data.guildShops['Shih_Tayuun'].stock[13].initial     = 7  -- Chicken Bone
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, 14, { id = xi.item.HANDFUL_OF_FISH_SCALES, initial = 30, maxStock = 240, targetStock = 180, buyMax = 480, restockRate = 15 })
xi.data.guildShops['Shih_Tayuun'].stock[60].initial     = 0  -- Bone Arrow
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, { id = xi.item.SHAGREEN_FILE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })

-----------------------------------
-- Alchemy
-----------------------------------
-- Maymunah & Odoba
xi.data.guildShops['Odoba'] = { sharedStock = 'Maymunah' }
table.insert(xi.data.guildShops['Maymunah'].stock, 1, { id = xi.item.VIAL_OF_MERCURY, initial = 8, maxStock = 60, targetStock = 45, buyMax = 7500, restockRate = 1 })
xi.data.guildShops['Maymunah'].stock[9].initial     = 60 -- Wijnruit
xi.data.guildShops['Maymunah'].stock[10].initial     = 60 -- Crying Mustard
xi.data.guildShops['Maymunah'].stock[11].initial     = 60 -- Dried Marjoram
xi.data.guildShops['Maymunah'].stock[12].initial     = 60 -- Chamomile
xi.data.guildShops['Maymunah'].stock[17].initial     = 12 -- Cobalt Jelly
xi.data.guildShops['Maymunah'].stock[18].initial     = 30 -- Glass Fiber
xi.data.guildShops['Maymunah'].stock[71].initial     = 120 -- Battery
xi.data.guildShops['Maymunah'].stock[72].initial     = 120 -- Hydro Pump
xi.data.guildShops['Maymunah'].stock[73].initial     = 120 -- Wind Fan
table.insert(xi.data.guildShops['Maymunah'].stock, { id = xi.item.TRITURATOR, initial = 120, maxStock = 240, targetStock = 180, buyMax = 500, restockRate = 60 })

-- Wahraga & Gathweeda
xi.data.guildShops['Wahraga'].stock[33].initial     = 8 -- Mercury
xi.data.guildShops['Wahraga'].stock[34].initial     = 8 -- Morbol Vine
xi.data.guildShops['Wahraga'].stock[38].initial     = 40 -- Sulfur
xi.data.guildShops['Wahraga'].stock[40].initial     = 60 -- Wijnruit
xi.data.guildShops['Wahraga'].stock[41].initial     = 60 -- Crying Mustard
xi.data.guildShops['Wahraga'].stock[42].initial     = 60 -- Dried Marjoram
xi.data.guildShops['Wahraga'].stock[43].initial     = 60 -- Chamomile
xi.data.guildShops['Wahraga'].stock[46].initial     = 120 -- Sage
xi.data.guildShops['Wahraga'].stock[48].initial     = 12 -- Cobalt Jelly
xi.data.guildShops['Wahraga'].stock[49].initial     = 30 -- Glass Fiber
xi.data.guildShops['Wahraga'].stock[77].initial     = 120 -- Triturator
xi.data.guildShops['Wahraga'].stock[78].initial     = 120 -- Homunculus Nerves
xi.data.guildShops['Wahraga'].stock[79].initial     = 120 -- Polyflan Paper
xi.data.guildShops['Wahraga'].stock[80].initial     = 120 -- Battery
xi.data.guildShops['Wahraga'].stock[81].initial     = 120 -- Hydro Pump
xi.data.guildShops['Wahraga'].stock[82].initial     = 120 -- Wind Fan
xi.data.guildShops['Wahraga'].stock[83].initial     = 12 -- Minium

-----------------------------------
-- Cooking
-----------------------------------
-- Chomo Jinhahl & Kopopo
xi.data.guildShops['Chomo_Jinjahl'] = { sharedStock = 'Kopopo' }
table.insert(xi.data.guildShops['Kopopo'].stock, 1, { id = xi.item.CHUNK_OF_ROCK_SALT, initial = 120, maxStock = 240, targetStock = 180, buyMax = 93, restockRate = 12 }) -- targetStock assumed
table.insert(xi.data.guildShops['Kopopo'].stock, 42, { id = xi.item.SARUTA_ORANGE, initial = 60, maxStock = 240, targetStock = 180, buyMax = 300, restockRate = 2 }) -- targetStock assumed
table.insert(xi.data.guildShops['Kopopo'].stock, 47, { id = xi.item.BUNCH_OF_SAN_DORIAN_GRAPES, initial = 12, maxStock = 240, targetStock = 180, buyMax = 380, restockRate = 2 }) -- targetStock assumed
xi.data.guildShops['Kopopo'].stock[3].initial     = 120 -- Rye Flour
xi.data.guildShops['Kopopo'].stock[4].initial     = 120 -- San d'Orian Flour
xi.data.guildShops['Kopopo'].stock[5].initial     = 120 -- Kazham Peppers
xi.data.guildShops['Kopopo'].stock[6].initial     = 120 -- Mhaura Garlic
xi.data.guildShops['Kopopo'].stock[7].initial     = 120 -- Selbina Milk
xi.data.guildShops['Kopopo'].stock[9].initial     = 6 -- Pie Dough
xi.data.guildShops['Kopopo'].stock[10].initial     = 120 -- Blue Peas
xi.data.guildShops['Kopopo'].stock[11].initial     = 120 -- Poteto (Popoto)
xi.data.guildShops['Kopopo'].stock[12].initial     = 120 -- Tarutaru Rice
xi.data.guildShops['Kopopo'].stock[13].initial     = 120 -- Crying Mustard
xi.data.guildShops['Kopopo'].stock[14].initial     = 120 -- Dried Marjoram
xi.data.guildShops['Kopopo'].stock[15].initial     = 0 -- Apple Vinegar
xi.data.guildShops['Kopopo'].stock[18].initial     = 120 -- Cinnamon
xi.data.guildShops['Kopopo'].stock[19].initial     = 120 -- Millioncorn
xi.data.guildShops['Kopopo'].stock[25].initial     = 60 -- Bird Egg
xi.data.guildShops['Kopopo'].stock[26].initial     = 60 -- Faerie Apple
xi.data.guildShops['Kopopo'].stock[28].initial     = 60 -- La Theine Cabbage
xi.data.guildShops['Kopopo'].stock[29].initial     = 60 -- Beaucedine Cabbage
xi.data.guildShops['Kopopo'].stock[30].initial     = 0 -- Batallia Cabbage
xi.data.guildShops['Kopopo'].stock[32].initial     = 0 -- Smoked Salmon
xi.data.guildShops['Kopopo'].stock[36].initial     = 60 -- San d'Orian Carrot
xi.data.guildShops['Kopopo'].stock[37].initial     = 60 -- Mithran Tomato
xi.data.guildShops['Kopopo'].stock[40].initial     = 12 -- Thundermelon
xi.data.guildShops['Kopopo'].stock[41].initial     = 12 -- Kazham Pineapple
xi.data.guildShops['Kopopo'].stock[51].initial     = 12 -- Watermelon
xi.data.guildShops['Kopopo'].stock[52].initial     = 4 -- White Bread
xi.data.guildShops['Kopopo'].stock[53].initial     = 8 -- Black Bread
xi.data.guildShops['Kopopo'].stock[99].initial     = 30 -- Turmeric
xi.data.guildShops['Kopopo'].stock[100].initial     = 30 -- Coriander
xi.data.guildShops['Kopopo'].stock[101].initial     = 15 -- Holy Basil
xi.data.guildShops['Kopopo'].stock[103].initial     = 60 -- Semolina
xi.data.guildShops['Kopopo'].stock[104].initial     = 50 -- Fish Stock
xi.data.guildShops['Kopopo'].stock[105].initial     = 50 -- Soy Stock

-----------------------------------
-- Fishing
-----------------------------------
-- Babubu
xi.data.guildShops['Babubu'].stock[1].initial     = 120 -- Little Worm
xi.data.guildShops['Babubu'].stock[2].initial     = 120 -- Lugworm
xi.data.guildShops['Babubu'].stock[3].initial     = 120 -- Sardine Ball
xi.data.guildShops['Babubu'].stock[4].initial     = 120 -- Shrimp Ball
xi.data.guildShops['Babubu'].stock[5].initial     = 120 -- Bug Ball
xi.data.guildShops['Babubu'].stock[6].initial     = 120 -- Trout Ball
xi.data.guildShops['Babubu'].stock[7].initial     = 120 -- Meatball
xi.data.guildShops['Babubu'].stock[8].initial     = 120 -- Slice of Sardine
xi.data.guildShops['Babubu'].stock[9].initial     = 120 -- Slice of Cod
xi.data.guildShops['Babubu'].stock[10].initial     = 120 -- Peeled Lobster
xi.data.guildShops['Babubu'].stock[11].initial     = 120 -- Slice of Bluetail
xi.data.guildShops['Babubu'].stock[12].initial     = 120 -- Peeled Crayfish
xi.data.guildShops['Babubu'].stock[13].initial     = 120 -- Slice of Moat Carp
xi.data.guildShops['Babubu'].stock[14].initial     = 120 -- Fly Lure
xi.data.guildShops['Babubu'].stock[15].initial     = 120 -- Minnow
xi.data.guildShops['Babubu'].stock[17].initial     = 120 -- Worm Lure
xi.data.guildShops['Babubu'].stock[21].initial     = 120 -- Sabiki Rig
xi.data.guildShops['Babubu'].stock[22].initial     = 90 -- Willow Fishing Rod
xi.data.guildShops['Babubu'].stock[23].initial     = 90 -- Yew Fishing Rod
xi.data.guildShops['Babubu'].stock[24].initial     = 90 -- Bamboo Fishing Rod
xi.data.guildShops['Babubu'].stock[25].initial     = 60 -- Fastwater Rod
xi.data.guildShops['Babubu'].stock[26].initial     = 30 -- Tarutaru Fishing Rod
xi.data.guildShops['Babubu'].stock[27].initial     = 30 -- Mithran Fishing Rod
xi.data.guildShops['Babubu'].stock[30].initial     = 30 -- Single Hook Rod

-- Cehn Teyohngo
xi.data.guildShops['Cehn_Teyohngo'].stock[2].initial     = 10 -- Sabiki Rig
xi.data.guildShops['Cehn_Teyohngo'].stock[3].initial     = 10 -- Minnow
xi.data.guildShops['Cehn_Teyohngo'].stock[5].initial     = 120 -- Tarutaru Fishing Rod

-- Graegham & Mendoline
table.insert(xi.data.guildShops['Graegham'].stock, 1, { id = xi.item.LITTLE_WORM, initial = 120, maxStock = 240, targetStock = 180, buyMax = 20, restockRate = 60 })
table.insert(xi.data.guildShops['Graegham'].stock, 2, { id = xi.item.LUGWORM, initial = 120, maxStock = 240, targetStock = 180, buyMax = 60, restockRate = 60 })
table.insert(xi.data.guildShops['Graegham'].stock, 3, { id = xi.item.BALL_OF_SARDINE_PASTE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 350, restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 4, { id = xi.item.BALL_OF_CRAYFISH_PASTE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 350, restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 5, { id = xi.item.SLICE_OF_COD, initial = 120, maxStock = 240, targetStock = 180, buyMax = 1425, restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 6, { id = xi.item.FLY_LURE, initial = 120, maxStock = 240, targetStock = 180, buyMax = 3600, restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 7, { id = xi.item.MINNOW, initial = 120, maxStock = 240, targetStock = 180, buyMax = 2025, restockRate = 12 })
xi.data.guildShops['Graegham'].stock[8].initial     = 120 -- Sabiki Rig
xi.data.guildShops['Graegham'].stock[8].restockRate = 12 -- Sabiki Rig
table.insert(xi.data.guildShops['Graegham'].stock, 9, { id = xi.item.WILLOW_FISHING_ROD, initial = 90, maxStock = 180, targetStock = 160, buyMax = 360, restockRate = 9 })
table.insert(xi.data.guildShops['Graegham'].stock, 10, { id = xi.item.YEW_FISHING_ROD, initial = 90, maxStock = 180, targetStock = 160, buyMax = 1180, restockRate = 9 })
table.insert(xi.data.guildShops['Graegham'].stock, 11, { id = xi.item.BAMBOO_FISHING_ROD, initial = 90, maxStock = 180, targetStock = 160, buyMax = 2700, restockRate = 9 })
xi.data.guildShops['Graegham'].stock[12].initial     = 30 -- Tarutaru Fishing Rod
xi.data.guildShops['Graegham'].stock[12].restockRate = 15 -- Tarutaru Fishing Rod
table.insert(xi.data.guildShops['Graegham'].stock, 13, { id = xi.item.MITHRAN_FISHING_ROD, initial = 30, maxStock = 60, targetStock = 45, buyMax = 171600, restockRate = 5 })
xi.data.guildShops['Graegham'].stock[14].initial     = 30 -- Clothespole
xi.data.guildShops['Graegham'].stock[14].restockRate = 15 -- Clothespole
xi.data.guildShops['Graegham'].stock[15].initial     = 30 -- Fastwater Rod
xi.data.guildShops['Graegham'].stock[15].restockRate = 15 -- Fastwater Rod
xi.data.guildShops['Graegham'].stock[17].initial     = 30 -- Single Hook Rod
xi.data.guildShops['Graegham'].stock[17].restockRate = 3 -- Single Hook Rod
xi.data.guildShops['Graegham'].stock[18].initial     = 120 -- Cobalt Jellyfish
xi.data.guildShops['Graegham'].stock[18].restockRate = 12 -- Cobalt Jellyfish
xi.data.guildShops['Graegham'].stock[19].initial     = 6 -- Crayfish
xi.data.guildShops['Graegham'].stock[19].restockRate = 6 -- Crayfish
xi.data.guildShops['Graegham'].stock[31].restockRate = 0 -- Dark Bass
xi.data.guildShops['Graegham'].stock[37].restockRate = 0 -- Red Terrapin
xi.data.guildShops['Graegham'].stock[43].restockRate = 0 -- Silver Shark
xi.data.guildShops['Graegham'].stock[45].restockRate = 0 -- Black Sole
xi.data.guildShops['Graegham'].stock[46].restockRate = 0 -- Greedie

-- Jidwahn
xi.data.guildShops['Jidwahn'].stock[2].initial     = 10 -- Sabiki Rig
xi.data.guildShops['Jidwahn'].stock[3].initial     = 10 -- Minnow
xi.data.guildShops['Jidwahn'].stock[33].initial     = 120 -- Ice Card
xi.data.guildShops['Jidwahn'].stock[34].initial     = 120 -- Thunder Card
xi.data.guildShops['Jidwahn'].stock[35].initial     = 120 -- Light Card
xi.data.guildShops['Jidwahn'].stock[36].initial     = 120 -- Dark Card

-- Lokhong
xi.data.guildShops['Lokhong'].stock[2].initial     = 10 -- Sabiki Rig
xi.data.guildShops['Lokhong'].stock[3].initial     = 10 -- Minnow
xi.data.guildShops['Lokhong'].stock[5].initial     = 120 -- Tarutaru Fishing Rod

-- Mep Nhapopoluko
table.insert(xi.data.guildShops['Mep_Nhapopoluko'].stock, 1, { id = xi.item.SABIKI_RIG, initial = 120, maxStock = 240, targetStock = 180, buyMax = 15960, restockRate = 12 })
xi.data.guildShops['Mep_Nhapopoluko'].stock[2].initial     = 80 -- Fastwater Rod
table.insert(xi.data.guildShops['Mep_Nhapopoluko'].stock, 3, { id = xi.item.TARUTARU_FISHING_ROD, initial = 30, maxStock = 60, targetStock = 45, buyMax = 27180, restockRate = 3 })
xi.data.guildShops['Mep_Nhapopoluko'].stock[4].initial     = 80 -- Single Hook Rod
xi.data.guildShops['Mep_Nhapopoluko'].stock[5].initial     = 100 -- Bluetail
xi.data.guildShops['Mep_Nhapopoluko'].stock[6].initial     = 100 -- Noble Lady
xi.data.guildShops['Mep_Nhapopoluko'].stock[7].initial     = 100 -- Trilobite
xi.data.guildShops['Mep_Nhapopoluko'].stock[8].initial     = 100 -- Shall Shell
xi.data.guildShops['Mep_Nhapopoluko'].stock[9].initial     = 100 -- Zafmlug Bass
xi.data.guildShops['Mep_Nhapopoluko'].stock[10].initial     = 100 -- Moorish Idol
xi.data.guildShops['Mep_Nhapopoluko'].stock[11].initial     = 100 -- Bibikibo
xi.data.guildShops['Mep_Nhapopoluko'].stock[12].initial     = 100 -- Bibiki Urchin
xi.data.guildShops['Mep_Nhapopoluko'].stock[13].initial     = 100 -- Pamtam Kelp
xi.data.guildShops['Mep_Nhapopoluko'].stock[14].initial     = 100 -- Cobalt Jellyfish

-- Pashi Maccaleh
xi.data.guildShops['Pashi_Maccaleh'].stock[2].initial     = 10 -- Sabiki Rig
xi.data.guildShops['Pashi_Maccaleh'].stock[3].initial     = 10 -- Minnow
xi.data.guildShops['Pashi_Maccaleh'].stock[5].initial     = 120 -- Tarutaru Fishing Rod

-- Rajmonda
xi.data.guildShops['Rajmonda'].stock[2].initial     = 10 -- Sabiki Rig
xi.data.guildShops['Rajmonda'].stock[3].initial     = 10 -- Minnow
xi.data.guildShops['Rajmonda'].stock[5].initial     = 120 -- Tarutaru Fishing Rod

-- Wahnid
xi.data.guildShops['Wahnid'].stock[1].initial     = 120 -- Little Worm
xi.data.guildShops['Wahnid'].stock[2].initial     = 120 -- Lugworm
xi.data.guildShops['Wahnid'].stock[3].initial     = 0 -- Sardine Ball
xi.data.guildShops['Wahnid'].stock[3].restockRate = 0 -- Sardine Ball
xi.data.guildShops['Wahnid'].stock[4].initial     = 0 -- Shrimp Lure
xi.data.guildShops['Wahnid'].stock[4].restockRate = 0 -- Shrimp Lure
xi.data.guildShops['Wahnid'].stock[5].initial     = 0 -- Bug Lure
xi.data.guildShops['Wahnid'].stock[5].restockRate = 0 -- Bug Lure
xi.data.guildShops['Wahnid'].stock[6].initial     = 0 -- Trout Lure
xi.data.guildShops['Wahnid'].stock[6].restockRate = 0 -- Trout Lure
xi.data.guildShops['Wahnid'].stock[7].initial     = 0 -- Meat Lure
xi.data.guildShops['Wahnid'].stock[7].restockRate = 0 -- Meat Lure
xi.data.guildShops['Wahnid'].stock[8].initial     = 0 -- Slice of Sardine
xi.data.guildShops['Wahnid'].stock[8].restockRate = 0 -- Slice of Sardine
xi.data.guildShops['Wahnid'].stock[9].initial     = 0 -- Slice of Cod
xi.data.guildShops['Wahnid'].stock[9].restockRate = 0 -- Slice of Cod
xi.data.guildShops['Wahnid'].stock[10].initial     = 0 -- Peeled Lobster
xi.data.guildShops['Wahnid'].stock[10].restockRate = 0 -- Peeled Lobster
xi.data.guildShops['Wahnid'].stock[11].initial     = 0 -- Slice of Bluetail
xi.data.guildShops['Wahnid'].stock[11].restockRate = 0 -- Slice of Bluetail
xi.data.guildShops['Wahnid'].stock[12].initial     = 0 -- Peeled Crayfish
xi.data.guildShops['Wahnid'].stock[12].restockRate = 0 -- Peeled Crayfish
xi.data.guildShops['Wahnid'].stock[13].initial     = 0 -- Slice of Moat Carp
xi.data.guildShops['Wahnid'].stock[13].restockRate = 0 -- Slice of Moat Carp
xi.data.guildShops['Wahnid'].stock[14].initial     = 0 -- Fly Lure
xi.data.guildShops['Wahnid'].stock[14].restockRate = 0 -- Fly Lure
xi.data.guildShops['Wahnid'].stock[15].initial     = 0 -- Minnow
xi.data.guildShops['Wahnid'].stock[15].restockRate = 0 -- Minnow
xi.data.guildShops['Wahnid'].stock[16].initial     = 10 -- Sinking Minnow
xi.data.guildShops['Wahnid'].stock[21].initial     = 120 -- Sabiki Rig
xi.data.guildShops['Wahnid'].stock[21].restockRate = 12 -- Sabiki Rig
xi.data.guildShops['Wahnid'].stock[23].initial     = 0 -- Yew Fishing Rod
xi.data.guildShops['Wahnid'].stock[23].restockRate = 0 -- Yew Fishing Rod
xi.data.guildShops['Wahnid'].stock[24].initial     = 90 -- Bamboo Fishing Rod
xi.data.guildShops['Wahnid'].stock[25].initial     = 60 -- Fastwater Rod
xi.data.guildShops['Wahnid'].stock[25].restockRate = 6 -- Fastwater Rod
xi.data.guildShops['Wahnid'].stock[26].initial     = 30 -- Tarutaru Fishing Rod
xi.data.guildShops['Wahnid'].stock[26].restockRate = 3 -- Tarutaru Fishing Rod
xi.data.guildShops['Wahnid'].stock[31].restockRate = 0 -- Denizanasi

-- Yahliq
xi.data.guildShops['Yahliq'].stock[2].initial     = 10 -- Sabiki Rig
xi.data.guildShops['Yahliq'].stock[3].initial     = 10 -- Minnow
xi.data.guildShops['Yahliq'].stock[33].initial     = 120 -- Ice Card
xi.data.guildShops['Yahliq'].stock[34].initial     = 120 -- Thunder Card
xi.data.guildShops['Yahliq'].stock[35].initial     = 120 -- Light Card
xi.data.guildShops['Yahliq'].stock[36].initial     = 120 -- Dark Card

-----------------------------------
-- Tenshodo
-----------------------------------
-- Jabbar
xi.data.guildShops['Jabbar'].stock[1].initial     = 30 -- Bamboo Stick
xi.data.guildShops['Jabbar'].stock[18].initial     = 10 -- Katon: Ichi
xi.data.guildShops['Jabbar'].stock[20].initial     = 10 -- Huton: Ichi
xi.data.guildShops['Jabbar'].stock[21].initial     = 10 -- Doton: Ichi
xi.data.guildShops['Jabbar'].stock[35].initial     = 12 -- Absorb MND
xi.data.guildShops['Jabbar'].stock[36].initial     = 12 -- Absorb CHR
xi.data.guildShops['Jabbar'].stock[37].initial     = 30 -- Turmeric
xi.data.guildShops['Jabbar'].stock[38].initial     = 30 -- Coriander
xi.data.guildShops['Jabbar'].stock[39].initial     = 30 -- Holy Basil
xi.data.guildShops['Jabbar'].stock[40].initial     = 15 -- Curry Powder
xi.data.guildShops['Jabbar'].stock[41].initial     = 50 -- Ground Wasabi
xi.data.guildShops['Jabbar'].stock[42].initial     = 50 -- Rice Vinegar
xi.data.guildShops['Jabbar'].stock[43].initial     = 50 -- Shungiku

-- Silver_Owl
xi.data.guildShops['Silver_Owl'].stock[10].initial     = 15 -- Kunai
xi.data.guildShops['Silver_Owl'].stock[15].initial     = 15 -- Shinobi Gatana
xi.data.guildShops['Silver_Owl'].stock[21].initial     = 5 -- Kanesada
xi.data.guildShops['Silver_Owl'].stock[23].initial     = 15 -- Tachi
xi.data.guildShops['Silver_Owl'].stock[27].initial     = 5 -- Kotetsu
xi.data.guildShops['Silver_Owl'].stock[52].initial     = 10 -- Hachimaki
xi.data.guildShops['Silver_Owl'].stock[53].initial     = 10 -- Cotton Hachimaki
xi.data.guildShops['Silver_Owl'].stock[59].initial     = 10 -- Kenpogi
xi.data.guildShops['Silver_Owl'].stock[60].initial     = 10 -- Cotton Dogi
xi.data.guildShops['Silver_Owl'].stock[65].initial     = 10 -- Tekko
xi.data.guildShops['Silver_Owl'].stock[66].initial     = 10 -- Cotton Tekko
xi.data.guildShops['Silver_Owl'].stock[67].initial     = 10 -- Soil Tekko
xi.data.guildShops['Silver_Owl'].stock[67].restockRate = 5 -- Soil Tekko
xi.data.guildShops['Silver_Owl'].stock[70].initial     = 10 -- Sitabaki
xi.data.guildShops['Silver_Owl'].stock[71].initial     = 10 -- Cotton Sitabaki
xi.data.guildShops['Silver_Owl'].stock[72].initial     = 10 -- Soil Sitabaki
xi.data.guildShops['Silver_Owl'].stock[72].restockRate = 5 -- Soil Sitabaki
xi.data.guildShops['Silver_Owl'].stock[75].initial     = 10 -- Kyahan
xi.data.guildShops['Silver_Owl'].stock[76].initial     = 10 -- Cotton Kyahan

-- Jirokichi
xi.data.guildShops['Jirokichi'].stock[10].initial     = 30 -- Kunai
xi.data.guildShops['Jirokichi'].stock[11].initial     = 30 -- Suzume
xi.data.guildShops['Jirokichi'].stock[14].initial     = 30 -- Wakizashi
xi.data.guildShops['Jirokichi'].stock[15].initial     = 30 -- Shinobi Gatana
xi.data.guildShops['Jirokichi'].stock[19].initial     = 30 -- Uchigatana
xi.data.guildShops['Jirokichi'].stock[21].initial     = 10 -- Kanesada
xi.data.guildShops['Jirokichi'].stock[23].initial     = 30 -- Tachi
xi.data.guildShops['Jirokichi'].stock[24].initial     = 10 -- Nodachi
xi.data.guildShops['Jirokichi'].stock[26].initial     = 5 -- Okanehira
xi.data.guildShops['Jirokichi'].stock[41].initial     = 30 -- Shuriken
xi.data.guildShops['Jirokichi'].stock[42].initial     = 20 -- Juji Shuriken

-- Achika
xi.data.guildShops['Achika'].stock[1].initial     = 30 -- Hachimaki
xi.data.guildShops['Achika'].stock[14].initial     = 30 -- Tekko
xi.data.guildShops['Achika'].stock[25].initial     = 30 -- Cotton Kyahan
xi.data.guildShops['Achika'].stock[26].initial     = 30 -- Soil Kyahan

-- Chiyo
xi.data.guildShops['Chiyo'].stock[9].initial     = 20 -- Hyoton: Ichi
xi.data.guildShops['Chiyo'].stock[10].initial     = 20 -- Huton: Ichi
xi.data.guildShops['Chiyo'].stock[11].initial     = 20 -- Doton: Ichi
xi.data.guildShops['Chiyo'].stock[12].initial     = 20 -- Raiton: Ichi
xi.data.guildShops['Chiyo'].stock[13].initial     = 20 -- Suiton: Ichi

-- Vuliaie
xi.data.guildShops['Vuliaie'].stock[2].initial     = 10 -- Toad Oil
xi.data.guildShops['Vuliaie'].stock[3].initial     = 6 -- Bast Parchment
xi.data.guildShops['Vuliaie'].stock[4].initial     = 10 -- Silk Cloth
xi.data.guildShops['Vuliaie'].stock[5].initial     = 180 -- Iron Sand
xi.data.guildShops['Vuliaie'].stock[8].initial     = 60 -- Uchitake
xi.data.guildShops['Vuliaie'].stock[9].initial     = 60 -- Tsurara
xi.data.guildShops['Vuliaie'].stock[10].initial     = 60 -- Kawahori Ogi
xi.data.guildShops['Vuliaie'].stock[11].initial     = 60 -- Makibishi
xi.data.guildShops['Vuliaie'].stock[12].initial     = 60 -- Hiraishin
xi.data.guildShops['Vuliaie'].stock[13].initial     = 60 -- Mizu Deppo
xi.data.guildShops['Vuliaie'].stock[20].initial     = 50 -- Gardenia Seed
xi.data.guildShops['Vuliaie'].stock[21].initial     = 120 -- Turmeric
xi.data.guildShops['Vuliaie'].stock[22].initial     = 120 -- Coriander
xi.data.guildShops['Vuliaie'].stock[23].initial     = 120 -- Holy Basil
xi.data.guildShops['Vuliaie'].stock[24].initial     = 60 -- Curry Powder
xi.data.guildShops['Vuliaie'].stock[25].initial     = 100 -- Ground Wasabi
xi.data.guildShops['Vuliaie'].stock[26].initial     = 100 -- Rice Vinegar
xi.data.guildShops['Vuliaie'].stock[27].initial     = 100 -- Napa
table.insert(xi.data.guildShops['Vuliaie'].stock, { id = xi.item.KOMA, initial = 30, maxStock = 60, targetStock = 45, buyMax = 660, restockRate = 15 }) -- Koma

-- Tsutsuroon
xi.data.guildShops['Tsutsuroon'].stock[1].initial     = 30 -- Kunai
xi.data.guildShops['Tsutsuroon'].stock[2].initial     = 30 -- Suzume
xi.data.guildShops['Tsutsuroon'].stock[5].initial     = 30 -- Wakizashi
xi.data.guildShops['Tsutsuroon'].stock[6].initial     = 30 -- Shinobi Gatana
xi.data.guildShops['Tsutsuroon'].stock[10].initial     = 30 -- Uchigatana
xi.data.guildShops['Tsutsuroon'].stock[12].initial     = 10 -- Kanesada
xi.data.guildShops['Tsutsuroon'].stock[14].initial     = 30 -- Tachi
xi.data.guildShops['Tsutsuroon'].stock[15].initial     = 10 -- Nodachi
xi.data.guildShops['Tsutsuroon'].stock[17].initial     = 5 -- Okanehira
xi.data.guildShops['Tsutsuroon'].stock[18].initial     = 5 -- Kotetsu
xi.data.guildShops['Tsutsuroon'].stock[32].initial     = 30 -- Shuriken
xi.data.guildShops['Tsutsuroon'].stock[33].initial     = 20 -- Juji Shuriken
xi.data.guildShops['Tsutsuroon'].stock[41].initial     = 30 -- Fire Arrow
xi.data.guildShops['Tsutsuroon'].stock[42].initial     = 20 -- Bullet
xi.data.guildShops['Tsutsuroon'].stock[45].initial     = 30 -- Soil Hachimaki
xi.data.guildShops['Tsutsuroon'].stock[50].initial     = 30 -- Kenpogi
xi.data.guildShops['Tsutsuroon'].stock[51].initial     = 30 -- Cotton Dogi
xi.data.guildShops['Tsutsuroon'].stock[53].initial     = 30 -- Soil Gi
xi.data.guildShops['Tsutsuroon'].stock[56].initial     = 30 -- Tekko
xi.data.guildShops['Tsutsuroon'].stock[57].initial     = 30 -- Cotton Tekko
xi.data.guildShops['Tsutsuroon'].stock[61].initial     = 30 -- Sitabaki
xi.data.guildShops['Tsutsuroon'].stock[62].initial     = 30 -- Cotton Sitabaki
xi.data.guildShops['Tsutsuroon'].stock[63].initial     = 30 -- Soil Sitabaki
xi.data.guildShops['Tsutsuroon'].stock[66].initial     = 30 -- Kyahan
xi.data.guildShops['Tsutsuroon'].stock[67].initial     = 30 -- Cotton Kyahan
xi.data.guildShops['Tsutsuroon'].stock[68].initial     = 30 -- Soil Kyahan
xi.data.guildShops['Tsutsuroon'].stock[75].initial     = 10 -- Toad Oil
xi.data.guildShops['Tsutsuroon'].stock[76].initial     = 6 -- Bast Parchment
xi.data.guildShops['Tsutsuroon'].stock[77].initial     = 10 -- Silk Cloth
xi.data.guildShops['Tsutsuroon'].stock[78].initial     = 180 -- Iron Sand
xi.data.guildShops['Tsutsuroon'].stock[81].initial     = 60 -- Uchitake
xi.data.guildShops['Tsutsuroon'].stock[82].initial     = 60 -- Tsurara
xi.data.guildShops['Tsutsuroon'].stock[83].initial     = 60 -- Kawahori Ogi
xi.data.guildShops['Tsutsuroon'].stock[84].initial     = 60 -- Makibishi
xi.data.guildShops['Tsutsuroon'].stock[85].initial     = 60 -- Hiraishin
xi.data.guildShops['Tsutsuroon'].stock[86].initial     = 60 -- Mizu Deppo
xi.data.guildShops['Tsutsuroon'].stock[93].initial     = 50 -- Gardenia Seed
xi.data.guildShops['Tsutsuroon'].stock[94].initial     = 120 -- Turmeric
xi.data.guildShops['Tsutsuroon'].stock[95].initial     = 120 -- Coriander
xi.data.guildShops['Tsutsuroon'].stock[96].initial     = 120 -- Holy Basil
xi.data.guildShops['Tsutsuroon'].stock[97].initial     = 60 -- Curry Powder
xi.data.guildShops['Tsutsuroon'].stock[98].initial     = 100 -- Ground Wasabi
xi.data.guildShops['Tsutsuroon'].stock[99].initial     = 100 -- Rice Vinegar
xi.data.guildShops['Tsutsuroon'].stock[100].initial     = 100 -- Napa
table.insert(xi.data.guildShops['Tsutsuroon'].stock, { id = xi.item.KOMA, initial = 30, maxStock = 60, targetStock = 45, buyMax = 660, restockRate = 15 }) -- Koma


-----------------------------------
-- Tenshodo (new shops -- Akamafula and Amalasanda did not exist in base guild_shops.lua)
-----------------------------------
xi.data.guildShops['Akamafula'] =
{
    hours = { 1, 23 },
    holiday = xi.day.EARTHSDAY,
    stock =
    {
        { id = xi.item.KUNAI, initial = 20, maxStock = 60, targetStock = 55, buyMax = 4419, restockRate = 5 }, -- Kunai
        { id = xi.item.WAKIZASHI, initial = 20, maxStock = 60, targetStock = 55, buyMax = 12000, restockRate = 5 }, -- Wakizashi
        { id = xi.item.UCHIGATANA, initial = 20, maxStock = 60, targetStock = 55, buyMax = 26680, restockRate = 5 }, -- Uchigatana
        { id = xi.item.KANESADA, initial = 2, maxStock = 60, targetStock = 55, buyMax = 99000, restockRate = 10 }, -- Kanesada
        { id = xi.item.TACHI, initial = 20, maxStock = 60, targetStock = 55, buyMax = 15695, restockRate = 5 }, -- Tachi
        { id = xi.item.NODACHI, initial = 2, maxStock = 60, targetStock = 55, buyMax = 40620, restockRate = 0 }, -- Nodachi
        { id = xi.item.OKANEHIRA, initial = 5, maxStock = 60, targetStock = 55, buyMax = 104730, restockRate = 7 }, -- Okanehira
        { id = xi.item.TANEGASHIMA, initial = 2, maxStock = 60, targetStock = 55, buyMax = 65310, restockRate = 0 }, -- Tanegashima
        { id = xi.item.SHURIKEN, initial = 30, maxStock = 60, targetStock = 55, buyMax = 250, restockRate = 10 }, -- Shuriken
        { id = xi.item.HACHIMAKI, initial = 5, maxStock = 60, targetStock = 45, buyMax = 4125, restockRate = 3 }, -- Hachimaki
        { id = xi.item.COTTON_HACHIMAKI, initial = 5, maxStock = 60, targetStock = 45, buyMax = 24420, restockRate = 3 }, -- Cotton Hachimaki
        { id = xi.item.SOIL_HACHIMAKI, initial = 10, maxStock = 60, targetStock = 45, buyMax = 66960, restockRate = 5 }, -- Soil Hachimaki
        { id = xi.item.KENPOGI, initial = 5, maxStock = 60, targetStock = 45, buyMax = 6225, restockRate = 3 }, -- Kenpogi
        { id = xi.item.COTTON_DOGI, initial = 5, maxStock = 60, targetStock = 45, buyMax = 36800, restockRate = 3 }, -- Cotton Dogi
        { id = xi.item.SOIL_GI, initial = 10, maxStock = 60, targetStock = 45, buyMax = 99000, restockRate = 5 }, -- Soil Gi
        { id = xi.item.TEKKO, initial = 5, maxStock = 60, targetStock = 45, buyMax = 3425, restockRate = 3 }, -- Tekko
        { id = xi.item.COTTON_TEKKO, initial = 5, maxStock = 60, targetStock = 45, buyMax = 20250, restockRate = 3 }, -- Cotton Tekko
        { id = xi.item.SOIL_TEKKO, initial = 10, maxStock = 60, targetStock = 45, buyMax = 55440, restockRate = 5 }, -- Soil Tekko
        { id = xi.item.SITABAKI, initial = 5, maxStock = 60, targetStock = 45, buyMax = 4975, restockRate = 3 }, -- Sitabaki
        { id = xi.item.COTTON_SITABAKI, initial = 5, maxStock = 60, targetStock = 45, buyMax = 29490, restockRate = 3 }, -- Cotton Sitabaki
        { id = xi.item.SOIL_SITABAKI, initial = 10, maxStock = 60, targetStock = 45, buyMax = 80640, restockRate = 5 }, -- Soil Sitabaki
        { id = xi.item.KYAHAN, initial = 5, maxStock = 60, targetStock = 45, buyMax = 3175, restockRate = 3 }, -- Kyahan
        { id = xi.item.COTTON_KYAHAN, initial = 5, maxStock = 60, targetStock = 45, buyMax = 18870, restockRate = 3 }, -- Cotton Kyahan
        { id = xi.item.SOIL_KYAHAN, initial = 10, maxStock = 60, targetStock = 45, buyMax = 82620, restockRate = 5 }, -- Soil Kyahan
    },
}

xi.data.guildShops['Amalasanda'] =
{
    hours = { 9, 23 },
    holiday = xi.day.EARTHSDAY,
    stock =
    {
        { id = xi.item.BAMBOO_STICK, initial = 30, maxStock = 240, targetStock = 180, buyMax = 720, restockRate = 10 }, -- Bamboo Stick
        { id = xi.item.KOMA, initial = 30, maxStock = 60, targetStock = 45, buyMax = 660, restockRate = 15 }, -- Koma
        { id = xi.item.LUMP_OF_TAMA_HAGANE, initial = 20, maxStock = 60, targetStock = 45, buyMax = 35000, restockRate = 5 }, -- Tama Hagane
        { id = xi.item.POT_OF_URUSHI, initial = 10, maxStock = 60, targetStock = 45, buyMax = 367650, restockRate = 1 }, -- Urushi
        { id = xi.item.BOX_OF_STICKY_RICE, initial = 50, maxStock = 150, targetStock = 120, buyMax = 316, restockRate = 100, priceFloor = 150, noSell = true }, -- Sticky Rice
        { id = xi.item.BAG_OF_BUCKWHEAT_FLOUR, initial = 50, maxStock = 150, targetStock = 120, buyMax = 1500, restockRate = 100, priceFloor = 150, noSell = true }, -- Buckwheat Flour
        { id = xi.item.PINCH_OF_BLACK_PEPPER, initial = 10, maxStock = 60, targetStock = 45, buyMax = 1111, restockRate = 5 }, -- Black Pepper
        { id = xi.item.ONZ_OF_TURMERIC, initial = 20, maxStock = 60, targetStock = 50, buyMax = 3225, restockRate = 15 }, -- Turmeric
        { id = xi.item.ONZ_OF_CORIANDER, initial = 20, maxStock = 60, targetStock = 50, buyMax = 7925, restockRate = 15 }, -- Coriander
        { id = xi.item.SPRIG_OF_HOLY_BASIL, initial = 20, maxStock = 60, targetStock = 50, buyMax = 4000, restockRate = 15 }, -- Holy Basil
        { id = xi.item.ONZ_OF_CURRY_POWDER, initial = 10, maxStock = 30, targetStock = 25, buyMax = 1456, restockRate = 7 }, -- Curry Powder
        { id = xi.item.JAR_OF_GROUND_WASABI, initial = 100, maxStock = 150, targetStock = 120, buyMax = 12974, restockRate = 100 }, -- Wasabi
        { id = xi.item.BOTTLE_OF_RICE_VINEGAR, initial = 100, maxStock = 150, targetStock = 120, buyMax = 1000, restockRate = 100 }, -- Rice Vinegar
        { id = xi.item.BUNDLE_OF_SHIRATAKI, initial = 50, maxStock = 150, targetStock = 120, buyMax = 369, restockRate = 100, priceFloor = 150, noSell = true }, -- Shirataki
        { id = xi.item.SCROLL_OF_KATON_ICHI, initial = 10, maxStock = 60, targetStock = 45, buyMax = 11655, restockRate = 3 }, -- Katon: Ichi 
        { id = xi.item.SCROLL_OF_HUTON_ICHI, initial = 10, maxStock = 60, targetStock = 45, buyMax = 11655, restockRate = 3 }, -- Huton: Ichi
        { id = xi.item.SCROLL_OF_DOTON_ICHI, initial = 10, maxStock = 60, targetStock = 45, buyMax = 11655, restockRate = 3 }, -- Doton: Ichi
        { id = xi.item.SCROLL_OF_SUITON_ICHI, initial = 10, maxStock = 60, targetStock = 45, buyMax = 11655, restockRate = 3 }, -- Suiton: Ichi 
        { id = xi.item.UCHITAKE, initial = 10, maxStock = 60, targetStock = 50, buyMax = 200, restockRate = 0 }, -- Uchitake
        { id = xi.item.KAWAHORI_OGI, initial = 10, maxStock = 60, targetStock = 50, buyMax = 200, restockRate = 0 }, -- Kawahori Ogi
        { id = xi.item.MAKIBISHI, initial = 10, maxStock = 60, targetStock = 50, buyMax = 200, restockRate = 0 }, -- Makibishi
        { id = xi.item.MIZU_DEPPO, initial = 10, maxStock = 60, targetStock = 50, buyMax = 200, restockRate = 0 }, -- Mizu Deppo
    },
}

-----------------------------------
-- Linkshell / Pendant Compass Vendors
-----------------------------------
table.remove(xi.data.guildShops['Ilita'].stock, 2) -- Pendant Compass
table.remove(xi.data.guildShops['Khel_Pahlhama'].stock, 2) -- Pendant Compass
table.remove(xi.data.guildShops['Paunelie'].stock, 2) -- Pendant Compass

return { name = moduleName }