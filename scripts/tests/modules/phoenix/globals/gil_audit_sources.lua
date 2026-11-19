-----------------------------------
-- The scripted gil helpers tell the gil audit why gil is about to move, then retire the reason once they return.
-- Sources are the GilSource values in modules/phoenix/cpp/gil_audit.cpp: 1 mob drop, 12 script, 13 GM command.
-----------------------------------
-- luacheck: globals __gilAuditSetReason __gilAuditRetireReason
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Phoenix gil audit sources', function()
    local player

    setup(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.THF, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/phoenix/lua/globals/gil_audit_sources.lua')
    end)

    it('labels gil from npcUtil.giveCurrency as scripted and retires the label', function()
        local setReason    = spy('__gilAuditSetReason')
        local retireReason = spy('__gilAuditRetireReason')
        npcUtil.giveCurrency(player, 'gil', 100)

        setReason:called(1)
        setReason:calledWith(player:getID(), 12, 'npcUtil.giveCurrency', 0)
        retireReason:called(1)
    end)

    describe('every gil source #exhaustive', function()
        it('labels only gil, not other currencies', function()
            local setReason = spy('__gilAuditSetReason')
            npcUtil.giveCurrency(player, 'bayld', 10)
            npcUtil.giveCurrency(player, 'gil', 10)

            setReason:called(1)
        end)

        it('labels the npcUtil reward and completion helpers only when they pay gil', function()
            local setReason = spy('__gilAuditSetReason')
            npcUtil.giveReward(player, { title = xi.title.NEW_ADVENTURER })
            setReason:called(0)

            npcUtil.giveReward(player, { gil = 10 })
            npcUtil.completeQuest(player, xi.questLog.SANDORIA, xi.quest.id.sandoria.ROSEL_THE_ARMORER, { gil = 10 })
            npcUtil.completeMission(player, xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.BAT_HUNT, { gil = 10 })

            setReason:called(3)
            setReason:calledWith(player:getID(), 12, 'npcUtil.giveReward', 0)
            setReason:calledWith(player:getID(), 12, 'npcUtil.completeQuest', 0)
            setReason:calledWith(player:getID(), 12, 'npcUtil.completeMission', 0)
        end)

        it('labels starting gil at character creation', function()
            local setReason  = spy('__gilAuditSetReason')
            local newcomer   = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, new = true })

            setReason:calledWith(newcomer:getID(), 12, 'starting_gil', 0)
        end)

        it('labels a mob drop for the killer only, with the mob as counterparty', function()
            local mob       = player.entities:get('Wild_Rabbit')
            local setReason = spy('__gilAuditSetReason')
            xi.mob.onMobDeathEx(mob, player, false, false)
            setReason:called(0)

            xi.mob.onMobDeathEx(mob, player, true, false)
            setReason:called(1)
            setReason:calledWith(player:getID(), 1, 'mob_drop', mob:getID())
        end)

        it('labels Mug as a mob drop from its target', function()
            local mob          = player.entities:get('Wild_Rabbit')
            local setReason    = spy('__gilAuditSetReason')
            local retireReason = spy('__gilAuditRetireReason')
            -- Stands in for the ability and the action, which Mug only reports its result through
            local reporter     =
            {
                setMsg       = function()
                end,

                setAnimation = function()
                end,
            }

            xi.job_utils.thief.useMug(player, mob, reporter, reporter)

            setReason:calledWith(player:getID(), 1, 'mug', mob:getID())
            retireReason:called(1)
        end)

        it('labels chocobo rentals and regime rewards as scripted', function()
            local setReason = spy('__gilAuditSetReason')
            xi.rentalChocobo.renterOnEventFinish(player, 0, 1, 1)
            xi.regime.checkRegime(player, player.entities:get('Wild_Rabbit'), 1, 1, xi.regime.type.FIELDS)

            setReason:calledWith(player:getID(), 12, 'chocobo_rental', 0)
            setReason:calledWith(player:getID(), 12, 'regime_reward', 0)
        end)

        it('labels the GM gil commands with the moved gil on the target and the GM as counterparty', function()
            local target    = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
            local setReason = spy('__gilAuditSetReason')
            player:setGMLevel(4)
            xi.commands.givegil.onTrigger(player, 100)
            xi.commands.givegil.onTrigger(player, 100, target:getName())
            xi.commands.takegil.onTrigger(player, 50, target:getName())
            xi.commands.setgil.onTrigger(player, 1000)
            player:setGMLevel(0)

            setReason:called(4)
            setReason:calledWith(player:getID(), 13, 'givegil', player:getID())
            setReason:calledWith(target:getID(), 13, 'givegil', player:getID())
            setReason:calledWith(target:getID(), 13, 'takegil', player:getID())
            setReason:calledWith(player:getID(), 13, 'setgil', 0)
        end)
    end)
end)
