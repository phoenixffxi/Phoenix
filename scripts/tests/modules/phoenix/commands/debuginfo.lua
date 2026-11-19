---@diagnostic disable: undefined-field, inject-field
-----------------------------------
-- !debuginfo prints the caller's zone, position, level, job, HP and MP, and the cursor target, to any player.
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
    } PHX_DEBUGINFO_POS;
]]

-- Puts the target under the player's cursor with a position update, or clears the cursor with nil.
local function faceTarget(player, target)
    local packet      = ffi.new('PHX_DEBUGINFO_POS')
    packet.x          = player:getXPos()
    packet.z          = player:getYPos()
    packet.y          = player:getZPos()
    packet.dir        = player:getRotPos()
    packet.facetarget = target and target:getTargID() or 0
    player.packets:send(0x015, packet, ffi.sizeof(packet))
end

local function expectedLines(player)
    local zone = player:getZone()

    return
    {
        string.format('Zone: %s (%i)  Pos: X %.2f  Y %.2f  Z %.2f  Rot %i',
            zone:getName(), zone:getID(), player:getXPos(), player:getYPos(), player:getZPos(), player:getRotPos()),
        string.format('Level: %i  Job: %i/%i  HP: %i/%i  MP: %i/%i',
            player:getMainLvl(), player:getMainJob(), player:getSubJob(),
            player:getHP(), player:getMaxHP(), player:getMP(), player:getMaxMP()),
    }
end

describe('Phoenix debuginfo command', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WHM, level = 30 })
    end)

    before_each(function()
        faceTarget(player, nil)
        player.packets:clear()
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/commands/debuginfo.lua')
    end)

    it('prints the zone, position, level and job lines', function()
        xi.commands.debuginfo.onTrigger(player)

        moduleTest.assertChatLines(player, expectedLines(player))
    end)

    describe('cursor target #exhaustive', function()
        it('adds a line for the cursor target', function()
            local npc = player.entities:get('Harvetour')
            faceTarget(player, npc)
            player.packets:clear()
            xi.commands.debuginfo.onTrigger(player)

            local expected = expectedLines(player)
            table.insert(expected, string.format('Target: %s  ID: %i  Pos: X %.2f  Y %.2f  Z %.2f',
                npc:getName(), npc:getID(), npc:getXPos(), npc:getYPos(), npc:getZPos()))
            moduleTest.assertChatLines(player, expected)
        end)
    end)
end)
