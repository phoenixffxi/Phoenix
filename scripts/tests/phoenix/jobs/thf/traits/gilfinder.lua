-----------------------------------
-- Phoenix version of jobs/thf/traits/gilfinder.lua: a level 75 Thief, and Sewer Syrup's
-- claim shield (custom/lua/claim_shield.lua) runs out before each kill.
-----------------------------------
describe('Gilfinder', function()
    local syrup
    ---@type CClientEntityPair
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.BOSTAUNIEUX_OUBLIETTE })
        syrup  = player.entities:get('Sewer_Syrup')
    end)

    before_each(function()
        player:changeJob(xi.job.THF)
        player:setLevel(75)
        player:setGil(0)
        syrup:respawn()
        xi.test.world:skipTime(5)
        xi.test.world:tickEntity(syrup)
        player.entities:moveTo(syrup)

        syrup:setMobMod(xi.mobMod.GIL_MIN, 12000)
        syrup:setMobMod(xi.mobMod.GIL_MAX, 12000)
    end)

    it('drops GIL_MIN <> GIL_MAX without Gilfinder', function()
        player:changeJob(xi.job.WAR)
        player:claimAndKillMob(syrup)
        player.assert:hasGil(12000)
    end)

    it('base GF increases gil obtained by 50%', function()
        player:claimAndKillMob(syrup)
        player.assert:hasGil(18000)
    end)
end)
