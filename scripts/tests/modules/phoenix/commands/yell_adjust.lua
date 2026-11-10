-----------------------------------
-- !yell ban tells the muted player how long the mute lasts and when it ends, and a ban with no days is indefinite.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- The mute notice for a ban of the given days; the end time is read on either side of a second tick.
local function assertMuteNotice(target, days, before)
    local lines = moduleTest.chatLines(target)
    assert(#lines == 1, string.format('expected the mute notice, got: %s', table.concat(lines, ' | ')))

    local plural = days == 1 and '' or 's'
    for elapsed = 0, 1 do
        local ends = os.date('!%Y-%m-%d %H:%M', before + elapsed + utils.days(days))
        if lines[1] == string.format('You have been muted from /yell for %i day%s. The mute ends %s UTC.', days, plural, ends) then
            return
        end
    end

    error(string.format('unexpected mute notice: %s', lines[1]), 2)
end

describe('Phoenix yell adjust', function()
    local gm
    local target

    setup(function()
        gm     = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        target = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
    end)

    before_each(function()
        gm:setGMLevel(3)
        gm.packets:clear()
        target.packets:clear()
    end)

    after_each(function()
        gm:setGMLevel(0)
        target:setCharVar('[YELL]Banned', 0)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/commands/yell_adjust.lua')
    end)

    it('tells the muted player the length and end of the mute', function()
        local before = GetSystemTime()
        xi.commands.yell.onTrigger(gm, 'ban', target:getName(), 2)

        assert(target:getCharVar('[YELL]Banned') == 1, 'the target was not muted')
        assertMuteNotice(target, 2, before)
        moduleTest.assertChatLines(gm, { string.format('%s has been banned from using the /yell command for 2 days.', target:getName()) })
    end)

    describe('durations and tier #exhaustive', function()
        it('says day, not days, for a one day mute', function()
            local before = GetSystemTime()
            xi.commands.yell.onTrigger(gm, 'ban', target:getName(), 1)

            assertMuteNotice(target, 1, before)
            moduleTest.assertChatLines(gm, { string.format('%s has been banned from using the /yell command for 1 day.', target:getName()) })
        end)

        it('mutes indefinitely when no days are given', function()
            xi.commands.yell.onTrigger(gm, 'ban', target:getName())

            assert(target:getCharVar('[YELL]Banned') == 1, 'an indefinite ban did not mute the target')
            moduleTest.assertChatLines(target, { 'You have been muted from /yell indefinitely.' })
            moduleTest.assertChatLines(gm,
            {
                'Invalid duration specified, defaulting to indefinite ban.',
                string.format('%s has been banned from using the /yell command indefinitely.', target:getName()),
            })
        end)

        it('mutes indefinitely for zero days', function()
            xi.commands.yell.onTrigger(gm, 'ban', target:getName(), 0)

            assert(target:getCharVar('[YELL]Banned') == 1, 'a zero day ban did not mute the target')
            moduleTest.assertChatLines(target, { 'You have been muted from /yell indefinitely.' })
        end)
    end)
end)
