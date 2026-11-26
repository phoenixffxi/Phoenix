-----------------------------------
-- Pre-Abyssea Signet: three hours shorter (player rank plus nation rank, in hours).
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Signet duration', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/effects/era_signet_duration.lua')
    end)

    it('lasts player rank plus nation rank hours', function()
        local nation   = player:getNation()
        local rank     = player:getRank(nation)
        local expected = (rank + GetNationRank(nation)) * 3600 * 1000

        player:delStatusEffect(xi.effect.SIGNET)
        xi.conquest.bestowSignet(player, nation, rank, zones[player:getZoneID()].text.CONQUEST)

        local signet = player:getStatusEffect(xi.effect.SIGNET)
        assert(signet, 'no Signet was bestowed')
        assert(signet:getDuration() == expected, string.format('expected %d ms, got %d', expected, signet:getDuration()))
    end)
end)
