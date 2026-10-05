-----------------------------------
-- Module: Imperial Standing Shop Adjustments
-----------------------------------
--  Scroll of Instant Reraise: https://wiki.ffo.jp/html/2388.html (500 -> 7 in the December 7, 2010 version update)
--  Scroll of Instant Warp: https://wiki.ffo.jp/html/2389.html (750 -> 10 in the December 7, 2010 version update)
--  Heat Capacitor, Power Cooler, Barrage Turbine and Galvanizer: https://wiki.ffo.jp/html/23696.html (added in the May 10, 2011 version update)
--  Cipher: Mihli: https://wiki.ffo.jp/html/30257.html (added in the December 11, 2013 version update)
--  Ephramadian Throne: https://wiki.ffo.jp/html/34771.html (added in the September 16, 2015 version update)
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('era_imperial_standing_shop')

local scrolls =
{
    [   1] = { id = xi.item.SCROLL_OF_INSTANT_RERAISE, price = 500 },
    [4097] = { id = xi.item.SCROLL_OF_INSTANT_WARP,    price = 750 },
}

local outOfEraItems =
{
    [36865] = xi.item.HEAT_CAPACITOR,
    [40961] = xi.item.POWER_COOLER,
    [45057] = xi.item.BARRAGE_TURBINE,
    [53249] = xi.item.GALVANIZER,
    [57345] = xi.item.EPHRAMADIAN_THRONE,
    [69633] = xi.item.CIPHER_OF_MIHLIS_ALTER_EGO,
}

m:addOverride('xi.besieged.cipherValue', function()
    return 0
end)

m:addOverride('xi.besieged.onEventFinish', function(player, csid, option, npc)
    if outOfEraItems[option] then
        return
    end

    local scroll = scrolls[option]
    if not scroll then
        super(player, csid, option, npc)
        return
    end

    if xi.besieged.getMercenaryRank(player) == 0 then
        return
    end

    if player:getCurrency('imperial_standing') < scroll.price then
        return
    end

    if npcUtil.giveItem(player, scroll.id) then
        player:delCurrency('imperial_standing', scroll.price)
    end
end)
