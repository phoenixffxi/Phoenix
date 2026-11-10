-----------------------------------
-- !jailaccount and !pardonaccount run !jail and !pardon on every played character of an account,
-- !pardon releases offline prisoners, and a prisoner who zones out of Mordion Gaol is sent back.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix account jail', function()
    local gm
    local target

    setup(function()
        gm = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
    end)

    before_each(function()
        gm:setGMLevel(2)
        target = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        gm.packets:clear()
    end)

    after_each(function()
        gm:setGMLevel(0)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/commands/account_jail.lua')
    end)

    it('jails every played character on the account', function()
        target:setHomePoint()
        xi.commands.jailaccount.onTrigger(gm, target:getName(), 5, 'Testing')

        assert(target:getCharVar('inJail') == 5, string.format('expected cell 5, got %d', target:getCharVar('inJail')))
        moduleTest.assertChatPrinted(gm, string.format('Jailing 1 characters on %s\'s account: %s', target:getName(), target:getName()))
    end)

    describe('account commands #exhaustive', function()
        it('skips characters that never played', function()
            xi.commands.jailaccount.onTrigger(gm, target:getName())

            assert(target:getCharVar('inJail') == 0, 'a never-played character was jailed')
            moduleTest.assertChatLines(gm,
            {
                string.format('Skipping 1 never-played characters: %s', target:getName()),
                string.format('Jailing 0 characters on %s\'s account: ', target:getName()),
            })
        end)

        it('rejects an unknown player for either command', function()
            xi.commands.jailaccount.onTrigger(gm, 'Nobodyhere')
            xi.commands.pardonaccount.onTrigger(gm, 'Nobodyhere')

            moduleTest.assertChatLines(gm,
            {
                'Invalid player \'Nobodyhere\' given.',
                '!jailaccount <player> (cell) (reason)',
                'Invalid player \'Nobodyhere\' given.',
                '!pardonaccount <player>',
            })
        end)

        it('pardons every played character on the account', function()
            target:setHomePoint()
            target:setCharVar('inJail', 5)
            xi.commands.pardonaccount.onTrigger(gm, target:getName())

            assert(target:getCharVar('inJail') == 0, 'the prisoner was not pardoned')
            moduleTest.assertChatPrinted(gm, string.format('Pardoning 1 characters on %s\'s account: %s', target:getName(), target:getName()))
        end)

        it('refuses below tier 2 and jails at tier 2', function()
            target:setHomePoint()
            gm:setGMLevel(1)
            xi.commands.jailaccount.onTrigger(gm, target:getName())
            assert(target:getCharVar('inJail') == 0, 'tier 1 jailed the account')
            moduleTest.assertChatLines(gm, { 'Tier 2 is required to use !jailaccount.' })

            gm:setGMLevel(2)
            xi.commands.jailaccount.onTrigger(gm, target:getName())
            assert(target:getCharVar('inJail') == 1, 'tier 2 did not jail the account')
        end)
    end)

    -- An online test character stands in for an offline one by hiding it from the online lookups.
    describe('offline pardon #exhaustive', function()
        it('releases an offline prisoner to their home point', function()
            target:setHomePoint()
            target:setCharVar('inJail', 5)
            stub('GetPlayerByName', function()
            end)

            stub('PlayerHasValidSession', false)
            xi.commands.pardon.onTrigger(gm, target:getName())

            assert(GetCharVar(target:getID(), 'inJail') == 0, 'the offline prisoner was not pardoned')
            moduleTest.assertChatLines(gm, { string.format('%s pardoned %s (offline) from jail.', gm:getName(), target:getName()) })
        end)

        it('skips an offline prisoner who never played', function()
            target:setCharVar('inJail', 5)
            stub('GetPlayerByName', function()
            end)

            stub('PlayerHasValidSession', false)
            xi.commands.pardon.onTrigger(gm, target:getName())

            assert(GetCharVar(target:getID(), 'inJail') == 5, 'a never-played prisoner was moved')
            moduleTest.assertChatLines(gm, { string.format('%s has never played and has no home point, skipping.', target:getName()) })
        end)

        it('says nothing for an offline character who is not jailed', function()
            target:setHomePoint()
            stub('GetPlayerByName', function()
            end)

            stub('PlayerHasValidSession', false)
            xi.commands.pardon.onTrigger(gm, target:getName())

            moduleTest.assertChatLines(gm, {})
        end)

        it('points to the other cluster for a prisoner online elsewhere', function()
            target:setCharVar('inJail', 5)
            stub('GetPlayerByName', function()
            end)

            xi.commands.pardon.onTrigger(gm, target:getName())

            assert(target:getCharVar('inJail') == 5, 'a prisoner on another cluster was pardoned')
            moduleTest.assertChatLines(gm, { string.format('Player \'%s\' is online but in a different zone group (cluster). Go to that zone group to use !pardon', target:getName()) })
        end)
    end)

    describe('escaped prisoner #exhaustive', function()
        it('sends a prisoner who zones out back to their cell', function()
            target:setCharVar('inJail', 3)
            target:gotoZone(xi.zone.EAST_RONFAURE)
            xi.test.world:tick()
            xi.test.world:tick()

            target.assert:inZone(xi.zone.MORDION_GAOL)
            assert(target:getXPos() == 260 and target:getZPos() == 660, string.format('expected cell 3, got %.1f, %.1f', target:getXPos(), target:getZPos()))
        end)
    end)
end)
