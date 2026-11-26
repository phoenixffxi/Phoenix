-----------------------------------
-- Inside the Belly: Zaldon takes only the launch fish, and his hints name no later additions.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local hintTiers =
{
    {
        skill   = 45,
        eventId = 163,
        fish    = { xi.item.ZAFMLUG_BASS, xi.item.GIANT_DONKO_1, xi.item.BHEFHEL_MARLIN_1, xi.item.JUNGLE_CATFISH, xi.item.SILVER_SHARK },
    },
    {
        skill   = 60,
        eventId = 164,
        fish    = { xi.item.JUNGLE_CATFISH, xi.item.EMPEROR_FISH, xi.item.SILVER_SHARK, xi.item.TAKITARO, xi.item.SEA_ZOMBIE, xi.item.GIANT_CHIRAI },
    },
    {
        skill   = 80,
        eventId = 165,
        fish    = { xi.item.TAKITARO, xi.item.SEA_ZOMBIE, xi.item.TITANICTUS, xi.item.CAVE_CHERAX, xi.item.TRICORN, xi.item.RYUGU_TITAN, xi.item.LIK, xi.item.GUGRUSAURUS },
    },
}

-- One fish from each later batch of trade options.
local laterFish =
{
    xi.item.MEGALODON,
    xi.item.GUGRU_TUNA_1,
    xi.item.ABAIA,
    xi.item.SORYU,
}

local function assertHint(action, tier)
    assert(action.id == tier.eventId, string.format('expected hint event %d, got %s', tier.eventId, tostring(action.id)))
    assert(#action.options == #tier.fish, string.format('event %d lists %d fish, expected %d', tier.eventId, #action.options, #tier.fish))

    for idx, itemId in ipairs(tier.fish) do
        assert(action.options[idx] == itemId, string.format('event %d slot %d lists %s, expected %d', tier.eventId, idx, tostring(action.options[idx]), itemId))
    end
end

describe('Era Inside the Belly', function()
    local quest
    local player

    setup(function()
        quest  = moduleTest.container('scripts/quests/otherAreas/Inside_the_Belly')
        player = xi.test.world:spawnPlayer({ zone = xi.zone.SELBINA })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/quests/otherareas/inside_the_belly.lua')
    end)

    it('hints Jungle Catfish instead of the 2009 Bladefish at skill 40', function()
        stub('xi.crafting.getTotalSkill', hintTiers[1].skill)

        assertHint(quest.sections[2][xi.zone.SELBINA]['Zaldon'].onTrigger(player, nil), hintTiers[1])
    end)

    describe('trade list #exhaustive', function()
        local skill = 45

        before_each(function()
            xi.test.world:setSetting('map.FISHING_ENABLE', true)
            stub('xi.crafting.getTotalSkill', function()
                return skill
            end)
        end)

        it('lists only launch fish in every hint tier, before and after completion', function()
            for _, sectionIdx in ipairs({ 2, 3 }) do
                local zaldon = quest.sections[sectionIdx][xi.zone.SELBINA]['Zaldon']

                for _, tier in ipairs(hintTiers) do
                    skill = tier.skill
                    assertHint(zaldon.onTrigger(player, nil), tier)
                end
            end

            skill = 45
        end)

        it('keeps every later fish while the quest is open', function()
            player:addQuest(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.INSIDE_THE_BELLY)

            for _, itemId in ipairs(laterFish) do
                player:addItem(itemId)
                player.actions:tradeNpc('Zaldon', { itemId })

                player.events:expectNotInEvent()
                player.assert:hasItem(itemId)
                player:delItem(itemId, 1)
            end
        end)

        it('keeps every later fish after the quest', function()
            player:completeQuest(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.INSIDE_THE_BELLY)

            for _, itemId in ipairs(laterFish) do
                player:addItem(itemId)
                player.actions:tradeNpc('Zaldon', { itemId })

                player.events:expectNotInEvent()
                player.assert:hasItem(itemId)
                player:delItem(itemId, 1)
            end
        end)
    end)
end)
