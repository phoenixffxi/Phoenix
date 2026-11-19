-----------------------------------
-- Pre-Abyssea stealth items: Deodorizer, Prism Powder and Silent Oil last a random 90-360s,
-- Rainbow Powder a fixed 180s.
-- Covers: modules/era/lua/items/pinch_of_prism_powder.lua
-- Covers: modules/era/lua/items/pinch_of_rainbow_powder.lua
-- Covers: modules/era/lua/items/pot_of_silent_oil.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era stealth items', function()
    local player

    local function durationAfterUse(itemName, effectId)
        player:delStatusEffect(effectId)
        xi.items[itemName].onItemUse(player, player)

        local effect = player:getStatusEffect(effectId)
        assert(effect, string.format('%s gave no effect', itemName))

        local duration = effect:getDuration()
        player:delStatusEffect(effectId)

        return duration
    end

    local function expectRandomDuration(itemName, effectId)
        local duration = durationAfterUse(itemName, effectId)
        assert(
            duration >= 90000 and
            duration <= 360000,
            string.format('%s: expected 90000-360000 ms, got %d', itemName, duration)
        )
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.THF, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/items/flask_of_deodorizer.lua')
        moduleTest.assertOverridesApplied('modules/era/lua/items/pinch_of_prism_powder.lua')
        moduleTest.assertOverridesApplied('modules/era/lua/items/pinch_of_rainbow_powder.lua')
        moduleTest.assertOverridesApplied('modules/era/lua/items/pot_of_silent_oil.lua')
    end)

    it('gives Deodorizer a 90-360s Deodorize', function()
        expectRandomDuration('flask_of_deodorizer', xi.effect.DEODORIZE)
    end)

    it('gives Prism Powder a 90-360s Invisible', function()
        expectRandomDuration('pinch_of_prism_powder', xi.effect.INVISIBLE)
    end)

    it('gives Rainbow Powder a 180s Invisible', function()
        local duration = durationAfterUse('pinch_of_rainbow_powder', xi.effect.INVISIBLE)
        assert(duration == 180000, string.format('expected 180000 ms, got %d', duration))
    end)

    it('gives Silent Oil a 90-360s Sneak', function()
        expectRandomDuration('pot_of_silent_oil', xi.effect.SNEAK)
    end)

    describe('every item #exhaustive', function()
        it('scales the powder and oil durations by the stealth duration setting', function()
            xi.test.world:setSetting('main.SNEAK_INVIS_DURATION_MULTIPLIER', 2)

            local rainbow = durationAfterUse('pinch_of_rainbow_powder', xi.effect.INVISIBLE)
            assert(rainbow == 360000, string.format('Rainbow Powder: expected 360000 ms, got %d', rainbow))

            for _, entry in ipairs({ { 'pinch_of_prism_powder', xi.effect.INVISIBLE }, { 'pot_of_silent_oil', xi.effect.SNEAK } }) do
                local duration = durationAfterUse(entry[1], entry[2])
                assert(
                    duration >= 180000 and
                    duration <= 720000,
                    string.format('%s: expected 180000-720000 ms, got %d', entry[1], duration)
                )
            end
        end)

        it('applies Prism Powder used from the inventory', function()
            player:delStatusEffect(xi.effect.INVISIBLE)
            player:addItem(xi.item.PINCH_OF_PRISM_POWDER)
            local powder = player:findItem(xi.item.PINCH_OF_PRISM_POWDER)
            assert(powder, 'no Prism Powder in the inventory')

            player.actions:useItem(player, powder:getSlotID())
            xi.test.world:skipTime(5)

            local invisible = player:getStatusEffect(xi.effect.INVISIBLE)
            assert(invisible, 'Prism Powder gave no Invisible')
            assert(
                invisible:getDuration() >= 90000 and
                invisible:getDuration() <= 360000,
                string.format('expected 90000-360000 ms, got %d', invisible:getDuration())
            )
            player:delStatusEffect(xi.effect.INVISIBLE)
        end)
    end)
end)
