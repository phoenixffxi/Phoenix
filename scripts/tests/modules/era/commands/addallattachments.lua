-----------------------------------
-- !addallattachments unlocks only the heads, frames and attachments released before June 2010.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/commands/addallattachments.lua'

describe('Era addallattachments command', function()
    local gm

    setup(function()
        gm = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.PUP, level = 75 })
    end)

    before_each(function()
        gm:setGMLevel(5)
    end)

    after_each(function()
        gm:setGMLevel(0)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('unlocks era attachments and skips later ones', function()
        xi.commands.addallattachments.onTrigger(gm)

        assert(gm:hasAttachment(xi.item.HARLEQUIN_HEAD), 'expected the Harlequin head')
        assert(gm:hasAttachment(xi.item.STROBE_ATTACHMENT), 'expected Strobe')
        assert(not gm:hasAttachment(xi.item.HEAT_CAPACITOR_ATTACHMENT), 'expected no Heat Capacitor')
        assert(not gm:hasAttachment(xi.item.SHOCK_ABSORBER_II_ATTACHMENT), 'expected no Shock Absorber II')
    end)

    describe('targets #exhaustive', function()
        it('unlocks only era attachments for a named player', function()
            local target = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.PUP, level = 75 })

            xi.commands.addallattachments.onTrigger(gm, target:getName())

            assert(target:hasAttachment(xi.item.DAMAGE_GAUGE_ATTACHMENT), 'expected Damage Gauge')
            assert(not target:hasAttachment(xi.item.DAMAGE_GAUGE_II_ATTACHMENT), 'expected no Damage Gauge II')
        end)
    end)
end)
