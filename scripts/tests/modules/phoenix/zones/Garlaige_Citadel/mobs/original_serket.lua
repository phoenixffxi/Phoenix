-----------------------------------
-- Serket uses its original 2004 model (285) and its original TP move animations.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/phoenix/lua/zones/Garlaige_Citadel/mobs/original_serket.lua'

-- The link of an override chain that the given file defines; each override keeps the function it replaced as super.
local function overrideFrom(fn, path)
    while type(fn) == 'function' do
        local source = debug.getinfo(fn, 'S').source:gsub('^@', ''):gsub('^%./', '')
        if source == path then
            return fn
        end

        local env = getfenv(fn)
        fn = type(env) == 'table' and rawget(env, 'super') or nil
    end
end

describe('Phoenix original Serket', function()
    ---@type CClientEntityPair
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.GARLAIGE_CITADEL })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('wears the original model', function()
        local serket = player.entities:get('Serket')

        assert(serket:getModelId() == 285, string.format('expected model 285, got %d', serket:getModelId()))
    end)

    describe('TP moves #exhaustive', function()
        it('shows each TP move with its original animation', function()
            -- Other modules wrap the same function, so run only this file's link and what it wraps,
            -- on a stand-in that keeps the listeners and passes every other call to the real Serket.
            local initialize = overrideFrom(xi.zones.Garlaige_Citadel.mobs.Serket.onMobInitialize, modulePath)
            assert(initialize, 'Serket onMobInitialize does not run the original Serket override')

            local real = player.entities:get('Serket')
            local listener
            local serket = setmetatable(
            {
                addListener = function(_, _, name, fn)
                    if name == 'SERKET_WEAPONSKILL_USE' then
                        listener = fn
                    end
                end,
            },
            {
                __index = function(_, method)
                    return function(_, ...)
                        return real[method](real, ...)
                    end
                end,
            })

            initialize(serket)
            assert(listener, 'no animation listener was added')

            local animations =
            {
                [xi.mobSkill.VENOM_STING_1 ] = 104,
                [xi.mobSkill.VENOM_STORM_1 ] = 107,
                [xi.mobSkill.VENOM_BREATH_1] = 101,
                [xi.mobSkill.CRITICAL_BITE ] = 103,
                [xi.mobSkill.EARTHBREAKER_1] = 108,
                [xi.mobSkill.STASIS        ] = 106,
                [xi.mobSkill.EVASION       ] = 109,
            }

            local skillId
            local shown
            local skill =
            {
                getID = function()
                    return skillId
                end,
            }

            local action =
            {
                setAnimation = function(_, _, animationId)
                    shown = animationId
                end,
            }

            for id, animationId in pairs(animations) do
                skillId = id
                shown   = nil
                listener(serket, player, skill, 0, action, 0)
                assert(shown == animationId, string.format('mob skill %d shows animation %s, expected %d', id, tostring(shown), animationId))
            end
        end)
    end)
end)
