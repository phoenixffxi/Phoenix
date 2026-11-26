-----------------------------------
-- Pre-SoA home points: a set-or-cancel menu replaces the home point teleport cutscene.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era home point menu', function()
    local player

    -- Triggers Port Bastok's first home point and returns the menu it opened.
    local function openMenu(cursorTarget)
        local proxy, calls = moduleTest.recordingProxy(player, {
            customMenu      = true,
            setFreezeFlag   = true,
            startEvent      = true,
            getCursorTarget = function()
                return cursorTarget
            end,
        })

        xi.homepoint.onTrigger(proxy, 8700, 14)

        local menu = calls.customMenu[1] and calls.customMenu[1][1]
        assert(menu, 'the home point opened no menu')

        return menu, calls
    end

    local function chooseSet(distance)
        local npc, npcCalls  = moduleTest.recordingProxy(nil, { entityAnimationPacket = true })
        local menu           = openMenu(npc)
        local chooser, calls = moduleTest.recordingProxy(player, {
            setHomePoint   = true,
            messageSpecial = true,
            checkDistance  = function()
                return distance
            end,
        })

        menu.options[1][2](chooser)

        return calls, npcCalls
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.PORT_BASTOK })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/globals/homepoint.lua')
    end)

    it('opens a set or cancel menu instead of the teleport cutscene', function()
        local menu, calls = openMenu(nil)

        assert(menu.title == 'What will you do?', string.format('unexpected title %s', tostring(menu.title)))
        assert(#menu.options == 2, string.format('expected 2 options, got %d', #menu.options))
        assert(menu.options[1][1] == 'Set this as your home point.', 'first option is not the set option')
        assert(menu.options[2][1] == 'On second thought, never mind.', 'second option is not the cancel option')
        assert(#calls.startEvent == 0, 'the home point still started its cutscene')
        assert(calls.setFreezeFlag[1][1] == true, 'the player was not frozen while the menu is open')
    end)

    describe('menu choices #exhaustive', function()
        it('sets the home point from within six yalms', function()
            local calls, npcCalls = chooseSet(3)

            assert(#calls.setHomePoint == 1, 'the home point was not set')
            assert(npcCalls.entityAnimationPacket[1][1] == xi.animationString.EFFECT_HOME_POINT, 'the home point played no animation')
            assert(calls.messageSpecial[1][1] == zones[xi.zone.PORT_BASTOK].text.HOMEPOINT_SET, 'no home point set message')
        end)

        it('does not set the home point from farther away', function()
            local calls = chooseSet(10)

            assert(#calls.setHomePoint == 0, 'the home point was set from 10 yalms')
        end)

        it('unfreezes the player when the menu ends or is cancelled', function()
            local menu           = openMenu(nil)
            local chooser, calls = moduleTest.recordingProxy(player, { setFreezeFlag = true })

            menu.onEnd(chooser)
            menu.onCancelled(chooser)

            assert(#calls.setFreezeFlag == 2, string.format('expected 2 unfreezes, got %d', #calls.setFreezeFlag))
            assert(calls.setFreezeFlag[1][1] == false and calls.setFreezeFlag[2][1] == false, 'the player was not unfrozen')
        end)
    end)
end)
