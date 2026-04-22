-----------------------------------
-- Guild Point Shop Modifications
-----------------------------------
-- TODO: Add a way to disable items from showing in the menu at all (client-side)
--
-- Signboards were added on 11/20/2007
-- Patch Notes: New items purchasable with guild points have been added to the trading contract quests.
-- Patch Notes Link: http://www.playonline.com/pcd/update/ff11us/20071120wwnX41/detail.html
--
-- Rings were added on 06/09/2008
-- Patch Notes: New equipment items have been added as rewards for completing guild contract quests.
-- Patch Notes Link:  https://www.bg-wiki.com/ffxi/Version_Update_(06/09/2008)
--
-- Emblems were added on 12/07/2010
-- Patch Notes: The following items may now be obtained in exchange for Guild Points:
--              Blacksmiths' Emblem / Goldsmiths' Emblem / Boneworkers' Emblem / Weavers' Emblem / Culinarians' Emblem /
--              Tanners' Emblem / Fishermen's Emblem / Carpenters' Emblem / Alchemists' Emblem
-- The seventh slot [6] entry items were also added on 12/07/2010: https://wiki.ffo.jp/html/22368.html
-- Patch Notes Link: http://www.playonline.com/pcd/verup/ff11us/detail/60wwnX41/detail.html
--
-- Emblems were added on 12/07/2010
-- Patch Notes: The rate at which guild points can be exchange for the following items has been adjusted.
--              Aurora Crystal       -     500 -> 200
--              Twilights Crystal    -     500 -> 200
-- Patch Notes Link: https://forum.square-enix.com/ffxi/threads/52095

-----------------------------------
require('scripts/globals/hobbies/crafting/guild_points')
-----------------------------------
local m = Module:new('guild_point_shop')

-----------------------------------
-- Helper to "disable" an item by setting rank impossibly high
-- The item still shows in the menu (client-side) but cannot be purchased
-----------------------------------
local disabledRank = 99 -- No player can reach this rank

-- Purchases are processed in guildPointOnEventUpdate, not OnEventFinish (Finish is contract dialog only).
m:addOverride('xi.crafting.guildPointOnEventUpdate', function(player, option, target, guildId)
    local category = bit.band(bit.rshift(option, 2), 3)

    -- Analysis Crystal messaging
    if
        category == 0 and
        option ~= utils.EVENT_CANCELLED_OPTION and
        bit.band(option, 3) == 2
    then
        player:printToPlayer('NOTICE: This item is not available on this server.', xi.msg.channel.SYSTEM_3)

        return
    end

    -- Key Item and Item messaging
    if category == 3 then
        local keyItem = xi.crafting.guildKeyItemTable[guildId][bit.band(bit.rshift(option, 5), 15) - 1]

        if keyItem and keyItem.rank >= disabledRank then
            player:printToPlayer('NOTICE: This item is not available on this server.', xi.msg.channel.SYSTEM_3)
        end
    elseif category == 2 or category == 1 then
        local item = xi.crafting.guildItemTable[guildId][(category - 1) * 4 + bit.band(option, 3)]

        if item and item.rank >= disabledRank then
            player:printToPlayer('NOTICE: This item is not available on this server.', xi.msg.channel.SYSTEM_3)
        end
    end

    return super(player, option, target, guildId)
end)

-----------------------------------
-- HQ Crystals - Set Aurora and Twilight to 500 GP
-----------------------------------

xi.crafting.hqCrystals[7].cost = 500 -- Aurora Crystal
xi.crafting.hqCrystals[8].cost = 500 -- Twilight Crystal

-- TODO: Disable analysis crystals when they are implemented on LSB

-----------------------------------
-- FISHING
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.FISHING][3].rank = disabledRank -- Angler's Almanac
xi.crafting.guildItemTable[xi.guild.FISHING][6].rank    = disabledRank -- Net and Lure
xi.crafting.guildItemTable[xi.guild.FISHING][7].rank    = disabledRank -- Fishermens' Emblem

-----------------------------------
-- WOODWORKING
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.WOODWORKING][4].rank = disabledRank -- Way of the Carpenter
xi.crafting.guildItemTable[xi.guild.WOODWORKING][6].rank    = disabledRank -- Carpenter's Kit
xi.crafting.guildItemTable[xi.guild.WOODWORKING][7].rank    = disabledRank -- Carpenters' Emblem

-----------------------------------
-- SMITHING
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.SMITHING][4].rank = disabledRank -- Way of the Blacksmith
xi.crafting.guildItemTable[xi.guild.SMITHING][6].rank    = disabledRank -- Stone Hearth
xi.crafting.guildItemTable[xi.guild.SMITHING][7].rank    = disabledRank -- Blacksmiths' Emblem

-----------------------------------
-- GOLDSMITHING
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.GOLDSMITHING][5].rank = disabledRank -- Way of the Goldsmith
xi.crafting.guildItemTable[xi.guild.GOLDSMITHING][6].rank    = disabledRank -- Gemscope
xi.crafting.guildItemTable[xi.guild.GOLDSMITHING][7].rank    = disabledRank -- Goldsmiths' Emblem

-----------------------------------
-- CLOTHCRAFT
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.CLOTHCRAFT][4].rank = disabledRank -- Way of the Weaver
xi.crafting.guildItemTable[xi.guild.CLOTHCRAFT][6].rank    = disabledRank -- Spinning Wheel
xi.crafting.guildItemTable[xi.guild.CLOTHCRAFT][7].rank    = disabledRank -- Weavers' Emblem

-----------------------------------
-- LEATHERCRAFT
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.LEATHERCRAFT][3].rank = disabledRank -- Way of the Tanner
xi.crafting.guildItemTable[xi.guild.LEATHERCRAFT][6].rank    = disabledRank -- Hide Stretcher
xi.crafting.guildItemTable[xi.guild.LEATHERCRAFT][7].rank    = disabledRank -- Tanners' Emblem

-----------------------------------
-- BONECRAFT
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.BONECRAFT][3].rank = disabledRank -- Way of the Boneworker
xi.crafting.guildItemTable[xi.guild.BONECRAFT][6].rank    = disabledRank -- Bonecraft Tools
xi.crafting.guildItemTable[xi.guild.BONECRAFT][7].rank    = disabledRank -- Boneworkers' Emblem

-----------------------------------
-- ALCHEMY
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.ALCHEMY][6].rank = disabledRank -- Way of the Alchemist
xi.crafting.guildItemTable[xi.guild.ALCHEMY][6].rank    = disabledRank -- Alembic
xi.crafting.guildItemTable[xi.guild.ALCHEMY][7].rank    = disabledRank -- Alchemists' Emblem

-----------------------------------
-- COOKING
-----------------------------------
xi.crafting.guildKeyItemTable[xi.guild.COOKING][4].rank = disabledRank -- Way of the Culinarian
xi.crafting.guildItemTable[xi.guild.COOKING][6].rank    = disabledRank -- Brass Crock
xi.crafting.guildItemTable[xi.guild.COOKING][7].rank    = disabledRank -- Culinarians' Emblem

-----------------------------------
-- Signboards (11/20/2007) and Rings (06/09/2008) - disabled when WoTG is not enabled
-----------------------------------
if xi.settings.main.ENABLE_WOTG == 0 then
    xi.crafting.guildItemTable[xi.guild.FISHING][4].rank      = disabledRank -- Fisherman's Signboard
    xi.crafting.guildItemTable[xi.guild.WOODWORKING][4].rank  = disabledRank -- Carpenter's Signboard
    xi.crafting.guildItemTable[xi.guild.WOODWORKING][5].rank  = disabledRank -- Carpenter's Ring
    xi.crafting.guildItemTable[xi.guild.SMITHING][4].rank     = disabledRank -- Blacksmith's Signboard
    xi.crafting.guildItemTable[xi.guild.SMITHING][5].rank     = disabledRank -- Smith's Ring
    xi.crafting.guildItemTable[xi.guild.GOLDSMITHING][4].rank = disabledRank -- Goldsmith's Signboard
    xi.crafting.guildItemTable[xi.guild.GOLDSMITHING][5].rank = disabledRank -- Goldsmith's Ring
    xi.crafting.guildItemTable[xi.guild.CLOTHCRAFT][4].rank   = disabledRank -- Weaver's Signboard
    xi.crafting.guildItemTable[xi.guild.CLOTHCRAFT][5].rank   = disabledRank -- Tailor's Ring
    xi.crafting.guildItemTable[xi.guild.LEATHERCRAFT][4].rank = disabledRank -- Tanner's Signboard
    xi.crafting.guildItemTable[xi.guild.LEATHERCRAFT][5].rank = disabledRank -- Tanner's Ring
    xi.crafting.guildItemTable[xi.guild.BONECRAFT][4].rank    = disabledRank -- Boneworker's Signboard
    xi.crafting.guildItemTable[xi.guild.BONECRAFT][5].rank    = disabledRank -- Bonecrafter's Ring
    xi.crafting.guildItemTable[xi.guild.ALCHEMY][4].rank      = disabledRank -- Alchemist's Signboard
    xi.crafting.guildItemTable[xi.guild.ALCHEMY][5].rank      = disabledRank -- Alchemist's Ring
    xi.crafting.guildItemTable[xi.guild.COOKING][4].rank      = disabledRank -- Culinarian's Signboard
    xi.crafting.guildItemTable[xi.guild.COOKING][5].rank      = disabledRank -- Chef's Ring
end

return m
