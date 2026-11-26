-----------------------------------
-- Era experience rings: shorter Dedication and lower EXP caps; Redeyes can't be used.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix era items', function()
    local player

    local function expectDedication(itemName, power, duration, subPower)
        player:delStatusEffect(xi.effect.DEDICATION)
        xi.items[itemName].onItemUse(player)

        local effect = player:getStatusEffect(xi.effect.DEDICATION)
        assert(effect, string.format('%s gave no Dedication', itemName))

        local got = { effect:getPower(), effect:getDuration(), effect:getSubPower() }
        player:delStatusEffect(xi.effect.DEDICATION)

        assert(
            got[1] == power and
            got[2] == duration and
            got[3] == subPower,
            string.format('%s: expected %d%% for %d ms up to %d EXP, got %d%% for %d ms up to %d EXP', itemName, power, duration, subPower, got[1], got[2], got[3])
        )
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 30 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/items/era_items.lua')
    end)

    it('gives Chariot Band +75% for 90 minutes up to 500 EXP', function()
        expectDedication('chariot_band', 75, 5400000, 500)
    end)

    it('does not let Redeyes be used', function()
        local result = xi.items['redeyes'].onItemCheck(player, nil, player)
        assert(result == xi.msg.basic.ITEM_UNABLE_TO_USE, string.format('expected ITEM_UNABLE_TO_USE, got %s', tostring(result)))
    end)

    describe('every ring #exhaustive', function()
        it('gives Empress Band +50% for 180 minutes up to 1000 EXP', function()
            expectDedication('empress_band', 50, 10800000, 1000)
        end)

        it('gives Emperor Band +50% for 210 minutes up to 2000 EXP', function()
            expectDedication('emperor_band', 50, 12600000, 2000)
        end)

        it('gives Anniversary Ring +100% for 720 minutes up to 3000 EXP', function()
            expectDedication('anniversary_ring', 100, 43200000, 3000)
        end)
    end)
end)
