-----------------------------------
-- custom/lua/claim_shield.lua keeps listed NMs unclaimable and unkillable for 5 seconds after they spawn,
-- then gives the claim to one player from its enmity list.
-----------------------------------
describe('Claim shield', function()
    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local syrup

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.BOSTAUNIEUX_OUBLIETTE })
        syrup  = player.entities:get('Sewer_Syrup')
        syrup:respawn()
        player.entities:moveTo(syrup)
    end)

    it('keeps the NM unclaimed and alive while it lasts', function()
        syrup:updateClaim(player)
        syrup:takeDamage(syrup:getMaxHP() * 2, player)

        assert(not player:hasClaim(syrup), 'Sewer Syrup was claimed through its shield')
        syrup.assert:isAlive()
    end)

    it('gives the claim to a player on its enmity list when it ends', function()
        syrup:addEnmity(player, 1, 1)

        xi.test.world:skipTime(5)
        xi.test.world:tickEntity(syrup)

        assert(player:hasClaim(syrup), 'Sewer Syrup did not go to the only entrant')
    end)

    it('lets the NM be killed once it ends', function()
        xi.test.world:skipTime(5)
        xi.test.world:tickEntity(syrup)

        player:claimAndKillMob(syrup)
    end)
end)
