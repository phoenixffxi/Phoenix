-----------------------------------
-- Phoenix Limbus: Temenos and Apollyon use the message IDs this client's DATs carry.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix Limbus text IDs', function()
    local expected =
    {
        [xi.zone.TEMENOS] =
        {
            ITEM_OBTAINED                 = 6390,
            GIL_OBTAINED                  = 6391,
            KEYITEM_OBTAINED              = 6393,
            MEMBERS_LEVELS_ARE_RESTRICTED = 7023,
            CHIP_TRADE_T                  = 7030,
            CONQUEST_BASE                 = 7386,
        },

        [xi.zone.APOLLYON] =
        {
            ITEM_OBTAINED                 = 6390,
            GIL_OBTAINED                  = 6391,
            KEYITEM_OBTAINED              = 6393,
            MEMBERS_LEVELS_ARE_RESTRICTED = 7023,
            CONQUEST_BASE                 = 7377,
        },
    }

    local function expectTextIds(zoneId)
        for key, textId in pairs(expected[zoneId]) do
            local live = zones[zoneId].text[key]
            assert(live == textId, string.format('zone %d %s: expected %d, got %s', zoneId, key, textId, tostring(live)))
        end
    end

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/custom/limbus_text_ids.lua')
    end)

    it('uses 6390 for an obtained item in Temenos and Apollyon', function()
        assert(zones[xi.zone.TEMENOS].text.ITEM_OBTAINED == 6390, string.format('Temenos: got %s', tostring(zones[xi.zone.TEMENOS].text.ITEM_OBTAINED)))
        assert(zones[xi.zone.APOLLYON].text.ITEM_OBTAINED == 6390, string.format('Apollyon: got %s', tostring(zones[xi.zone.APOLLYON].text.ITEM_OBTAINED)))
    end)

    describe('every message #exhaustive', function()
        it('sets every Temenos and Apollyon message', function()
            expectTextIds(xi.zone.TEMENOS)
            expectTextIds(xi.zone.APOLLYON)
        end)
    end)
end)
