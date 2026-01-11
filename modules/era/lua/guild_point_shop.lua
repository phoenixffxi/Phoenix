-----------------------------------
-- Guild Point Shop Modifications
-----------------------------------
--
-- Emblems were added on 12/07/2010
-- Patch Notes: The following items may now be obtained in exchange for Guild Points:
--              Blacksmiths' Emblem / Goldsmiths' Emblem / Boneworkers' Emblem / Weavers' Emblem / Culinarians' Emblem /
--              Tanners' Emblem / Fishermen's Emblem / Carpenters' Emblem / Alchemists' Emblem
-- The seventh slot [6] entry items were also added on  on 12/07/2010: https://wiki.ffo.jp/html/22368.html
-- Patch Notes Link: http://www.playonline.com/pcd/verup/ff11us/detail/6035/detail.html
--
-- Signboards were added on 11/20/2007
-- Patch Notes: New items purchasable with guild points have been added to the trading contract quests.
-- Patch Notes Link: http://www.playonline.com/pcd/update/ff11us/20071120wwnX41/detail.html
-----------------------------------
require('scripts/globals/hobbies/crafting/guild_points')
-----------------------------------
local m = Module:new('guild_point_shop')

-----------------------------------
-- HQ Crystals - Set all to 500 GP (except Robber Rig at 1500)
-----------------------------------
for i = 1, 8 do
    if xi.crafting.hqCrystals[i] then
        xi.crafting.hqCrystals[i].cost = 500
    end
end

-----------------------------------
-- Helper to "disable" an item by setting rank impossibly high
-- The item still shows in the menu (client-side) but cannot be purchased
-----------------------------------
local disabledRank = 99 -- No player can reach this rank

-----------------------------------
-- FISHING
-----------------------------------
-- Remove key items (set rank impossibly high)
xi.crafting.guildKeyItemTable[xi.guild.FISHING][3].rank = disabledRank -- Angler's Almanac

-- Remove items (WoTG/post-era) - set rank impossibly high
xi.crafting.guildItemTable[xi.guild.FISHING][4].rank = disabledRank -- Fisherman's Signboard
xi.crafting.guildItemTable[xi.guild.FISHING][6].rank = disabledRank -- Net and Lure
xi.crafting.guildItemTable[xi.guild.FISHING][7].rank = disabledRank -- Fishermens' Emblem

-----------------------------------
-- WOODWORKING
-----------------------------------
-- Remove key items
xi.crafting.guildKeyItemTable[xi.guild.WOODWORKING][4].rank = disabledRank -- Way of the Carpenter

-- Remove items
xi.crafting.guildItemTable[xi.guild.WOODWORKING][4].rank = disabledRank -- Carpenter's Signboard
xi.crafting.guildItemTable[xi.guild.WOODWORKING][5].rank = disabledRank -- Carpenter's Ring
xi.crafting.guildItemTable[xi.guild.WOODWORKING][6].rank = disabledRank -- Carpenter's Kit
xi.crafting.guildItemTable[xi.guild.WOODWORKING][7].rank = disabledRank -- Carpenters' Emblem

-----------------------------------
-- SMITHING
-----------------------------------
-- Remove key items
xi.crafting.guildKeyItemTable[xi.guild.SMITHING][4].rank = disabledRank -- Way of the Blacksmith

-- Remove items
xi.crafting.guildItemTable[xi.guild.SMITHING][4].rank = disabledRank -- Blacksmith's Signboard
xi.crafting.guildItemTable[xi.guild.SMITHING][5].rank = disabledRank -- Smith's Ring
xi.crafting.guildItemTable[xi.guild.SMITHING][6].rank = disabledRank -- Stone Hearth
xi.crafting.guildItemTable[xi.guild.SMITHING][7].rank = disabledRank -- Blacksmiths' Emblem

-----------------------------------
-- GOLDSMITHING
-----------------------------------
-- Remove key items
xi.crafting.guildKeyItemTable[xi.guild.GOLDSMITHING][5].rank = disabledRank -- Way of the Goldsmith

-- Remove items
xi.crafting.guildItemTable[xi.guild.GOLDSMITHING][4].rank = disabledRank -- Goldsmith's Signboard
xi.crafting.guildItemTable[xi.guild.GOLDSMITHING][5].rank = disabledRank -- Goldsmith's Ring
xi.crafting.guildItemTable[xi.guild.GOLDSMITHING][6].rank = disabledRank -- Gemscope
xi.crafting.guildItemTable[xi.guild.GOLDSMITHING][7].rank = disabledRank -- Goldsmiths' Emblem

-----------------------------------
-- CLOTHCRAFT
-----------------------------------
-- Remove key items
xi.crafting.guildKeyItemTable[xi.guild.CLOTHCRAFT][4].rank = disabledRank -- Way of the Weaver

-- Remove items
xi.crafting.guildItemTable[xi.guild.CLOTHCRAFT][4].rank = disabledRank -- Weaver's Signboard
xi.crafting.guildItemTable[xi.guild.CLOTHCRAFT][5].rank = disabledRank -- Tailor's Ring
xi.crafting.guildItemTable[xi.guild.CLOTHCRAFT][6].rank = disabledRank -- Spinning Wheel
xi.crafting.guildItemTable[xi.guild.CLOTHCRAFT][7].rank = disabledRank -- Weavers' Emblem

-----------------------------------
-- LEATHERCRAFT
-----------------------------------
-- Remove key items
xi.crafting.guildKeyItemTable[xi.guild.LEATHERCRAFT][3].rank = disabledRank -- Way of the Tanner

-- Remove items
xi.crafting.guildItemTable[xi.guild.LEATHERCRAFT][4].rank = disabledRank -- Tanner's Signboard
xi.crafting.guildItemTable[xi.guild.LEATHERCRAFT][5].rank = disabledRank -- Tanner's Ring
xi.crafting.guildItemTable[xi.guild.LEATHERCRAFT][6].rank = disabledRank -- Hide Stretcher
xi.crafting.guildItemTable[xi.guild.LEATHERCRAFT][7].rank = disabledRank -- Tanners' Emblem

-----------------------------------
-- BONECRAFT
-----------------------------------
-- Remove key items
xi.crafting.guildKeyItemTable[xi.guild.BONECRAFT][3].rank = disabledRank -- Way of the Boneworker

-- Remove items
xi.crafting.guildItemTable[xi.guild.BONECRAFT][4].rank = disabledRank -- Boneworker's Signboard
xi.crafting.guildItemTable[xi.guild.BONECRAFT][5].rank = disabledRank -- Bonecrafter's Ring
xi.crafting.guildItemTable[xi.guild.BONECRAFT][6].rank = disabledRank -- Bonecraft Tools
xi.crafting.guildItemTable[xi.guild.BONECRAFT][7].rank = disabledRank -- Boneworkers' Emblem

-----------------------------------
-- ALCHEMY
-----------------------------------
-- Remove key items
xi.crafting.guildKeyItemTable[xi.guild.ALCHEMY][6].rank = disabledRank -- Way of the Alchemist

-- Remove items
xi.crafting.guildItemTable[xi.guild.ALCHEMY][4].rank = disabledRank -- Alchemist's Signboard
xi.crafting.guildItemTable[xi.guild.ALCHEMY][5].rank = disabledRank -- Alchemist's Ring
xi.crafting.guildItemTable[xi.guild.ALCHEMY][6].rank = disabledRank -- Alembic
xi.crafting.guildItemTable[xi.guild.ALCHEMY][7].rank = disabledRank -- Alchemists' Emblem

-----------------------------------
-- COOKING
-----------------------------------
-- Remove key items
xi.crafting.guildKeyItemTable[xi.guild.COOKING][4].rank = disabledRank -- Way of the Culinarian

-- Remove items
xi.crafting.guildItemTable[xi.guild.COOKING][4].rank = disabledRank -- Culinarian's Signboard
xi.crafting.guildItemTable[xi.guild.COOKING][5].rank = disabledRank -- Chef's Ring
xi.crafting.guildItemTable[xi.guild.COOKING][6].rank = disabledRank -- Brass Crock
xi.crafting.guildItemTable[xi.guild.COOKING][7].rank = disabledRank -- Culinarians' Emblem

return m
