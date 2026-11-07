-----------------------------------
-- Phoenix version of the systems/event_target.lua cases that use Sewer Syrup, whose
-- claim shield (custom/lua/claim_shield.lua) keeps it from engaging or dying for 5 seconds.
-----------------------------------
local packetReader = require('scripts.tests.helpers.packet_reader')

describe('Event target', function()
    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local syrup

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.BOSTAUNIEUX_OUBLIETTE })
        syrup  = player.entities:get('Sewer_Syrup')
        syrup:respawn()
        xi.test.world:skipTime(5)
        xi.test.world:tickEntity(syrup)
        player.entities:moveTo(syrup)
    end)

    it('is not inherited from a mob engaging the player', function()
        syrup:updateEnmity(player)
        assert(syrup:isEngaged(), 'Sewer Syrup did not engage the player')
        player.packets:clear()

        player:startEvent(8)

        assert(packetReader.lastEventStart(player).actor == player:getID(), 'The engaging mob became the actor')
        player.events:expect({ eventId = 8 })
    end)

    it('is not inherited from a kill that started no event', function()
        player:claimAndKillMob(syrup)
        player.packets:clear()

        player:startEvent(8)

        assert(packetReader.lastEventStart(player).actor == player:getID(), 'The killed mob became the actor')
        player.events:expect({ eventId = 8 })
    end)
end)
