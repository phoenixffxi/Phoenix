-----------------------------------
-- The Lamian Fang Key ??? gives one key per conquest tally instead of one per Vana'diel day.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Lamian Fang Key', function()
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.CAEDARVA_MIRE })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/zones/caedarva_mire/npcs/qm8.lua')
    end)

    it('hands out a key that holds the ??? until the conquest tally', function()
        player.entities:gotoAndTrigger('qm8')

        player.assert:hasItem(xi.item.LAMIAN_FANG_KEY)
        assert(player:getCharVar('[TIMER]Lamian_Fang_Key') == 1, string.format('expected the tally timer flag, got %d', player:getCharVar('[TIMER]Lamian_Fang_Key')))
    end)

    describe('timer #exhaustive', function()
        it('gives no second key before the tally', function()
            player:setCharVar('[TIMER]Lamian_Fang_Key', 1, NextConquestTally())

            player.entities:gotoAndTrigger('qm8')

            player.assert.no:hasItem(xi.item.LAMIAN_FANG_KEY)
        end)
    end)
end)
