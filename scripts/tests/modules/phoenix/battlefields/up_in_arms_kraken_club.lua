-----------------------------------
-- Phoenix Up in Arms: the Kraken Club drops 10 times in 10000 instead of once.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix Up in Arms Kraken Club', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/battlefields/up_in_arms_kraken_club.lua')
    end)

    it('rolls the Kraken Club at 10 in 10000', function()
        local content = xi.battlefield.contents[xi.battlefield.id.UP_IN_ARMS]
        assert(content, 'Up in Arms is not loaded')

        local weights = {}
        for _, lootGroup in ipairs(content.loot) do
            local group = {}
            for _, entry in ipairs(lootGroup) do
                group[entry.itemId] = entry.weight
            end

            if group[xi.item.KRAKEN_CLUB] then
                weights = group
            end
        end

        assert(weights[xi.item.KRAKEN_CLUB] == 10, string.format('expected weight 10, got %s', tostring(weights[xi.item.KRAKEN_CLUB])))
        assert(weights[xi.item.NONE] == 9990, string.format('expected filler weight 9990, got %s', tostring(weights[xi.item.NONE])))
    end)
end)
