-----------------------------------
-- Jug pets get their species' mob skill list on spawn, so Sic picks the right skills.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/globals/pets/jug.lua'

describe('Era jug pets', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.BST, level = 75 })
    end)

    after_each(function()
        player:despawnPet()
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('gives a Sheep Familiar the sheep skill list', function()
        player:spawnPet(xi.petId.SHEEP_FAMILIAR)
        local pet = player:getPet()

        assert(pet, 'the Sheep Familiar did not spawn')
        assert(pet:getMobMod(xi.mobMod.SKILL_LIST) == 737, string.format('expected skill list 737, got %d', pet:getMobMod(xi.mobMod.SKILL_LIST)))
    end)

    describe('every jug species #exhaustive', function()
        it('gives each familiar its species skill list', function()
            local skillLists =
            {
                { xi.petId.HARE_FAMILIAR,    733 },
                { xi.petId.FLOWERPOT_BILL,   734 },
                { xi.petId.TIGER_FAMILIAR,   735 },
                { xi.petId.LIZARD_FAMILIAR,  736 },
                { xi.petId.CRAB_FAMILIAR,    738 },
                { xi.petId.AMIGO_SABOTENDER, 739 },
                { xi.petId.FUNGUAR_FAMILIAR, 740 },
                { xi.petId.BEETLE_FAMILIAR,  741 },
                { xi.petId.MAYFLY_FAMILIAR,  742 },
                { xi.petId.ANTLION_FAMILIAR, 743 },
                { xi.petId.FLYTRAP_FAMILIAR, 744 },
                { xi.petId.EFT_FAMILIAR,     745 },
                { xi.petId.MITE_FAMILIAR,    746 },
            }

            for _, entry in ipairs(skillLists) do
                player:despawnPet()
                player:spawnPet(entry[1])
                local pet = player:getPet()

                assert(pet, string.format('pet %d did not spawn', entry[1]))
                assert(pet:getMobMod(xi.mobMod.SKILL_LIST) == entry[2], string.format('pet %d: expected skill list %d, got %d', entry[1], entry[2], pet:getMobMod(xi.mobMod.SKILL_LIST)))
            end
        end)
    end)
end)
