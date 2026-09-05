-----------------------------------
-- Cosmetic Wardrobe
-- Mog Wardrobe 8 opens at the full 80 slots and only accepts event and cosmetic items.
-- Launch leaves the wardrobes closed and the unlock system reopens 1-4 through content.
-- Wardrobe 8 is the cosmetic exception and is free for everyone.
--
-- This file opens the wardrobe and publishes the item list. The cpp half,
-- modules/phoenix/cpp/cosmetic_wardrobe.cpp, rejects any move into Wardrobe 8 that is
-- not on the list. A rejected item snaps back to its original slot with a system
-- message. The server never moves it. Items already inside stay usable, and moving
-- items out is never restricted. The list itself lives in
-- modules/phoenix/lua/data/cosmetic_wardrobe_items.lua.
--
-- Both halves read the setting at boot. Setting it false restores stock wardrobe
-- behavior on the next restart; wardrobe space already granted stays granted. A
-- missing list while enabled blocks everything, so a broken data file fails closed.
-- Enable by setting ENABLE_COSMETIC_WARDROBE = true in settings/main.lua, then run a
-- fresh cmake configure, rebuild xi_map, and restart.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('cosmetic_wardrobe', xi.settings.main.ENABLE_COSMETIC_WARDROBE == true)

local cosmeticItems = require('modules/phoenix/lua/data/cosmetic_wardrobe_items')

-- Publish the list as a set. The cpp filter reads xi.phoenix.cosmeticWardrobe on
-- every move into Wardrobe 8 and blocks everything if it is missing.
m:addOverride('xi.server.onServerStart', function()
    local allowed = {}
    local count   = 0
    local highest = 0
    for index, itemId in pairs(cosmeticItems) do
        count = count + 1
        if index > highest then
            highest = index
        end

        -- A mistyped id fails silently at the filter. Flag it at boot and leave it out.
        if GetReadOnlyItem(itemId) == nil then
            print('cosmetic_wardrobe: item id ' .. itemId .. ' does not exist')
        else
            allowed[itemId] = true
        end
    end

    -- A misspelled enum name becomes nil and leaves a hole in the table.
    if count ~= highest then
        print('cosmetic_wardrobe: the item list has a gap in it, check for a misspelled enum name')
    end

    xi.phoenix = xi.phoenix or {}
    xi.phoenix.cosmeticWardrobe = allowed

    -- The publish sits above this call on purpose. An error from another module's
    -- override must not leave the filter running with no list.
    super()
end)

-- Wardrobe 8 is closed at character creation. Open it to the full 80 slots on every
-- login so new and existing characters both get it.
m:addOverride('xi.player.onGameIn', function(player, firstLogin, zoning)
    super(player, firstLogin, zoning)

    local size = player:getContainerSize(xi.inv.WARDROBE8)
    if size < 80 then
        player:changeContainerSize(xi.inv.WARDROBE8, 80 - size)
    end
end)
