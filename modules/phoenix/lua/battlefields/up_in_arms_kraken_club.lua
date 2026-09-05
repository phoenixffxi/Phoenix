-----------------------------------
-- Up in Arms Kraken Club Drop Rate
-- Raises the Kraken Club roll from 1/10000 to 10/10000
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('up_in_arms_kraken_club')

m:addOverride('xi.server.onServerStart', function()
    super()

    local content = xi.battlefield.contents[xi.battlefield.id.UP_IN_ARMS]
    if not content then
        return
    end

    for _, lootGroup in ipairs(content.loot) do
        local krakenClub
        local filler

        for _, entry in pairs(lootGroup) do
            if type(entry) == 'table' then
                if entry.itemId == xi.item.KRAKEN_CLUB then
                    krakenClub = entry
                elseif entry.itemId == xi.item.NONE then
                    filler = entry
                end
            end
        end

        if krakenClub and filler then
            krakenClub.weight = 10
            filler.weight     = 9990
        end
    end
end)
