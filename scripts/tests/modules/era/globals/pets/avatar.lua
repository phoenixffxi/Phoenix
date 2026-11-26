-----------------------------------
-- Avatar base damage is (level + 2) / 2, through a 50% base damage multiplier.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/globals/pets/avatar.lua'

describe('Era avatars', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('halves avatar base damage', function()
        player:spawnPet(xi.petId.IFRIT)
        local pet = player:getPet()

        assert(pet, 'Ifrit did not spawn')
        assert(pet:getMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER) == 50, string.format('expected a 50%% base damage multiplier, got %d', pet:getMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER)))

        player:despawnPet()
    end)
end)
