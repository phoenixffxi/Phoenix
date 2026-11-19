---@diagnostic disable: undefined-field, inject-field
-----------------------------------
-- !spin turns the cursor target or a named online player in place, 180 degrees unless told otherwise.
-----------------------------------
local ffi        = require('ffi')
local moduleTest = require('scripts.tests.helpers.modules')

ffi.cdef [[
    typedef struct {
        uint16_t id : 9;
        uint16_t size : 7;
        uint16_t sync;
        float    x;
        float    z;
        float    y;
        uint16_t MovTime;
        uint16_t MoveFlame;
        int8_t   dir;
        uint8_t  flags;
        uint16_t facetarget;
        uint32_t TimeNow;
        uint32_t padding00;
    } PHX_SPIN_POS;
]]

-- Puts the target under the player's cursor with a position update, or clears the cursor with nil.
local function faceTarget(player, target)
    local packet      = ffi.new('PHX_SPIN_POS')
    packet.x          = player:getXPos()
    packet.z          = player:getYPos()
    packet.y          = player:getZPos()
    packet.dir        = player:getRotPos()
    packet.facetarget = target and target:getTargID() or 0
    player.packets:send(0x015, packet, ffi.sizeof(packet))
end

describe('Phoenix spin command', function()
    local gm
    local target

    setup(function()
        gm     = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        target = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
    end)

    before_each(function()
        gm:setGMLevel(1)
        gm.packets:clear()
    end)

    after_each(function()
        gm:setGMLevel(0)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/commands/spin.lua')
    end)

    it('turns a named player by the given degrees', function()
        local before = target:getRotPos()
        xi.commands.spin.onTrigger(gm, '90', target:getName())

        assert(target:getRotPos() == (before + 64) % 256, string.format('expected heading %d, got %d', (before + 64) % 256, target:getRotPos()))
        moduleTest.assertChatPrinted(gm, string.format('Rotated %s by 90 degrees.', target:getName()))
    end)

    describe('targets and arguments #exhaustive', function()
        it('turns 180 degrees when only a name is given', function()
            local before = target:getRotPos()
            xi.commands.spin.onTrigger(gm, target:getName())

            assert(target:getRotPos() == (before + 128) % 256, string.format('expected heading %d, got %d', (before + 128) % 256, target:getRotPos()))
            moduleTest.assertChatPrinted(gm, string.format('Rotated %s by 180 degrees.', target:getName()))
        end)

        it('turns the player under the cursor when no name is given', function()
            faceTarget(gm, target)
            local before = target:getRotPos()
            xi.commands.spin.onTrigger(gm, '45')

            assert(target:getRotPos() == (before + 32) % 256, string.format('expected heading %d, got %d', (before + 32) % 256, target:getRotPos()))
            moduleTest.assertChatPrinted(gm, string.format('Rotated %s by 45 degrees.', target:getName()))
        end)

        it('rounds to the nearest heading step and wraps negative turns', function()
            local before = target:getRotPos()
            xi.commands.spin.onTrigger(gm, '10', target:getName())
            assert(target:getRotPos() == (before + 7) % 256, string.format('expected heading %d, got %d', (before + 7) % 256, target:getRotPos()))

            before = target:getRotPos()
            xi.commands.spin.onTrigger(gm, '-45', target:getName())
            assert(target:getRotPos() == (before - 32) % 256, string.format('expected heading %d, got %d', (before - 32) % 256, target:getRotPos()))
            moduleTest.assertChatPrinted(gm, string.format('Rotated %s by -45 degrees.', target:getName()))
        end)

        it('refuses without a cursor target or name', function()
            faceTarget(gm, nil)
            xi.commands.spin.onTrigger(gm, '90')

            moduleTest.assertChatPrinted(gm, 'You must target a player or specify the name of an online player.')
            moduleTest.assertChatPrinted(gm, '!spin (degrees) (player)')
        end)

        it('refuses a name that is not online', function()
            local before = target:getRotPos()
            xi.commands.spin.onTrigger(gm, '90', 'Nobodyhere')

            assert(target:getRotPos() == before, 'a missing player still turned someone')
            moduleTest.assertChatPrinted(gm, 'You must target a player or specify the name of an online player.')
        end)
    end)
end)
