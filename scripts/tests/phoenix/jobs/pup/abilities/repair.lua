-----------------------------------
-- Phoenix version of the jobs/pup/abilities/repair.lua healing case.
-- era/lua/globals/job_utils/puppetmaster.lua drops Repair's burst heal, so the oil heals through Regen
-- (10 HP a tick for 30 seconds for a plain Automaton Oil).
-----------------------------------
describe('Repair', function()
    it('heals the automaton with an oil at or below the synced level', function()
        local player     = xi.test.world:spawnPlayer({ job = xi.job.PUP, level = 75, zone = xi.zone.SOUTHERN_SAN_DORIA })
        local syncTarget = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 20, zone = xi.zone.SOUTHERN_SAN_DORIA })

        player:unlockAttachment(xi.item.HARLEQUIN_FRAME)
        player:unlockAttachment(xi.item.HARLEQUIN_HEAD)
        player:addItem(xi.item.CAN_OF_AUTOMATON_OIL, 12)
        player:equipItem(xi.item.CAN_OF_AUTOMATON_OIL)

        player.actions:inviteToParty(syncTarget)
        syncTarget.actions:acceptPartyInvite()
        player.actions:setLevelSync(syncTarget)
        assert(player:getMainLvl() == 20, string.format('expected sync to 20, level=%d', player:getMainLvl()))

        player:spawnPet(xi.petId.AUTOMATON)
        local pet = player:getPet()
        assert(pet)

        pet:setHP(1)
        player.actions:useAbility(player, xi.jobAbility.REPAIR)
        xi.test.world:tick()

        assert(pet:hasStatusEffect(xi.effect.REGEN), 'expected repair to apply Regen')
        assert(player:getItemCount(xi.item.CAN_OF_AUTOMATON_OIL) == 11, 'expected one oil consumed')

        xi.test.world:skipTime(6)
        xi.test.world:tickEntity(pet)
        assert(pet:getHP() > 1, string.format('expected Regen to heal, pet HP=%d', pet:getHP()))
    end)
end)
