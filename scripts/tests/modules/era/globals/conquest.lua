-----------------------------------
-- Pre-December 2011 outposts: teleports cost gil only, conquest points are refused.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era outpost teleport payment', function()
    local player

    local function tookTeleport()
        local teleporting = player:hasStatusEffect(xi.effect.TELEPORT)
        player:delStatusEffect(xi.effect.TELEPORT)

        return teleporting
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
        player:addCP(1000)
    end)

    after_each(function()
        player:setLocalVar('outpostCpNoticeShown', 0)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/globals/conquest.lua')
    end)

    it('shows the outpost vendor no conquest points', function()
        local proxy, calls = moduleTest.recordingProxy(player, { startEvent = true })
        xi.conquest.vendorOnTrigger(proxy, xi.region.RONFAURE, 32756)

        -- startEvent(eventId, nation, fee, 0, cpFee, conquestPoints, ...)
        local params = calls.startEvent[1]
        assert(params, 'the vendor started no event')
        assert(params[6] == 0, string.format('expected 0 conquest points, got %s', tostring(params[6])))
    end)

    it('refuses conquest points at the outpost vendor', function()
        xi.conquest.vendorOnEventFinish(player, 6, xi.region.RONFAURE)

        assert(not tookTeleport(), 'the vendor teleported the player')
        assert(player:getCP() == 1000, string.format('expected 1000 conquest points, got %d', player:getCP()))
    end)

    describe('every payment path #exhaustive', function()
        it('warns once per vendor visit and shows no conquest points', function()
            local proxy, calls = moduleTest.recordingProxy(player, { startEvent = true, updateEvent = true, printToPlayer = true })
            xi.conquest.vendorOnTrigger(proxy, xi.region.RONFAURE, 32756)
            xi.conquest.vendorOnEventUpdate(proxy, xi.region.RONFAURE)
            xi.conquest.vendorOnEventUpdate(proxy, xi.region.RONFAURE)

            assert(#calls.printToPlayer == 1, string.format('expected one warning, got %d', #calls.printToPlayer))
            assert(calls.printToPlayer[1][1] == 'Outpost Teleportation using Conquest Points is out of era.', 'unexpected warning text')
            assert(calls.updateEvent[1][5] == 0, string.format('expected 0 conquest points, got %s', tostring(calls.updateEvent[1][5])))
        end)

        it('warns and shows the outpost teleporter no conquest points', function()
            local proxy, calls = moduleTest.recordingProxy(player, { updateEvent = true, printToPlayer = true })
            xi.conquest.teleporterOnEventUpdate(proxy, 581, xi.region.RONFAURE + 1073741829, 581)

            assert(#calls.printToPlayer == 1, string.format('expected one warning, got %d', #calls.printToPlayer))
            assert(calls.updateEvent[1][5] == 0, string.format('expected 0 conquest points, got %s', tostring(calls.updateEvent[1][5])))
        end)

        it('refuses conquest points at the outpost teleporter', function()
            xi.test.world:setSetting('main.UNLOCK_OUTPOST_WARPS', 2)
            xi.conquest.teleporterOnEventFinish(player, 581, 1029 + xi.region.RONFAURE, 581)

            assert(not tookTeleport(), 'the teleporter teleported the player')
            assert(player:getCP() == 1000, string.format('expected 1000 conquest points, got %d', player:getCP()))
        end)
    end)
end)
