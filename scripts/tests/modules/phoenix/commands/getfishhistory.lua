---@diagnostic disable: undefined-field, inject-field
-----------------------------------
-- !getfishhistory prints a player's lifetime fishing records and their last 10 catches, by name or cursor target.
-----------------------------------
-- luacheck: globals GetFishingRecords GetFishingHistory
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
    } PHX_FISHHISTORY_POS;
]]

-- Puts the target under the player's cursor with a position update, or clears the cursor with nil.
local function faceTarget(player, target)
    local packet      = ffi.new('PHX_FISHHISTORY_POS')
    packet.x          = player:getXPos()
    packet.z          = player:getYPos()
    packet.y          = player:getZPos()
    packet.dir        = player:getRotPos()
    packet.facetarget = target and target:getTargID() or 0
    player.packets:send(0x015, packet, ffi.sizeof(packet))
end

describe('Phoenix getfishhistory command', function()
    local gm
    local angler

    setup(function()
        gm     = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        angler = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
    end)

    before_each(function()
        gm:setGMLevel(1)
        faceTarget(gm, nil)
        gm.packets:clear()
    end)

    after_each(function()
        gm:setGMLevel(0)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/commands/getfishhistory.lua')
    end)

    it('reports an angler with no fishing history', function()
        xi.commands.getfishhistory.onTrigger(gm, angler:getName())

        moduleTest.assertChatLines(gm, { string.format('No fishing history for "%s".', angler:getName()) })
    end)

    describe('records and catches #exhaustive', function()
        it('prints the records and each catch with its age, item and zone', function()
            local now = GetSystemTime()
            stub('GetFishingRecords', function()
                return { linesCast = 42, longestIlms = 55, longestName = 'black_sole', heaviestPonzes = 120, heaviestName = 'giant_catfish' }
            end)

            local history = stub('GetFishingHistory', function()
                return
                {
                    { caughtAt = now + 5,           itemId = xi.item.MOAT_CARP_1, itemName = 'moat_carp', count = 1, zoneName = 'West_Ronfaure' },
                    { caughtAt = now - 2 * 3600,    itemId = xi.item.BLACK_SOLE, itemName = 'black_sole', count = 2, zoneName = 'Ship_bound_for_Selbina' },
                    { caughtAt = now - 86400 - 300, itemId = xi.item.GIANT_CATFISH_1, itemName = 'giant_catfish', count = 1, zoneName = 'Jugner_Forest' },
                }
            end)

            xi.commands.getfishhistory.onTrigger(gm, angler:getName())

            history:calledWith(angler:getName(), 10)
            moduleTest.assertChatLines(gm,
            {
                string.format('== %s: 42 lines cast ==', angler:getName()),
                'Longest: black sole, 55 ilms',
                'Heaviest: giant catfish, 120 ponzes',
                'Last 3 catches:',
                string.format('  just now: %i moat carp x1 (West Ronfaure)', xi.item.MOAT_CARP_1),
                string.format('  2 hours ago: %i black sole x2 (Ship bound for Selbina)', xi.item.BLACK_SOLE),
                string.format('  1 day ago: %i giant catfish x1 (Jugner Forest)', xi.item.GIANT_CATFISH_1),
            })
        end)

        it('says when no big fish or recent catch is on record', function()
            stub('GetFishingRecords', { linesCast = 7, longestIlms = 0, longestName = '', heaviestPonzes = 0, heaviestName = '' })

            stub('GetFishingHistory', {})
            xi.commands.getfishhistory.onTrigger(gm, angler:getName())

            moduleTest.assertChatLines(gm,
            {
                string.format('== %s: 7 lines cast ==', angler:getName()),
                'Longest and heaviest: no big fish landed yet.',
                'No catches in the last 30 days.',
            })
        end)

        it('reads the player under the cursor when no name is given', function()
            local records = stub('GetFishingRecords', { linesCast = 0, longestIlms = 0, longestName = '', heaviestPonzes = 0, heaviestName = '' })
            stub('GetFishingHistory', {})
            faceTarget(gm, angler)
            gm.packets:clear()
            xi.commands.getfishhistory.onTrigger(gm)

            records:calledWith(angler:getName())
            moduleTest.assertChatLines(gm, { string.format('No fishing history for "%s".', angler:getName()) })
        end)

        it('asks for a target when there is no name or cursor player', function()
            xi.commands.getfishhistory.onTrigger(gm)

            moduleTest.assertChatLines(gm, { 'You must target a player or specify a name.', '!getfishhistory (player)' })
        end)
    end)
end)
