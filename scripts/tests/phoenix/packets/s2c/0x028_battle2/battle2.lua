-----------------------------------
-- Phoenix versions of the BATTLE2 cases tools/ci/xi_test_skips.txt leaves out.
-- Old-school Dynamis (phoenix/data/zones/dynamis_*) spawns its mobs on entry rather than at zone load,
-- and can eject a test player mid-fight, so the guard and parry cases fight Qufim Island's Giants instead.
-- The player is level 75 with era weapon skills, and era jug pets use Sic instead of Ready
-- (era/lua/globals/pets/jug.lua). Expected packets are upstream's wherever the action is the same.
-----------------------------------
local ph           = require('scripts.tests.packets.s2c.0x028_battle2.placeholders')
local basicAttacks = require('scripts.tests.packets.s2c.0x028_battle2.basic_attacks')
local magic        = require('scripts.tests.packets.s2c.0x028_battle2.magic')
local mobskills    = require('scripts.tests.packets.s2c.0x028_battle2.mobskills')

-- Upstream's expected packet with its top-level fields replaced.
local function withFields(expected, fields)
    local copy = {}
    for key, value in pairs(expected) do
        copy[key] = value
    end

    for key, value in pairs(fields) do
        copy[key] = value
    end

    return copy
end

-- Same comparison as packets/s2c/0x028_battle2/base.lua.
local function diffPacket(actual, expected, prefix, phValues)
    local diffs = {}

    for key, expectedValue in pairs(expected) do
        local actualValue = actual[key]
        local fieldName   = prefix .. '.' .. key

        if type(expectedValue) == 'table' then
            if type(actualValue) ~= 'table' then
                table.insert(diffs, fieldName .. ': expected table, got ' .. type(actualValue))
            else
                for _, diff in ipairs(diffPacket(actualValue, expectedValue, fieldName, phValues)) do
                    table.insert(diffs, diff)
                end
            end
        elseif expectedValue == ph.TEST_CHAR then
            if actualValue ~= phValues.charId then
                table.insert(diffs, fieldName .. ': ' .. tostring(actualValue) .. ' != ' .. tostring(phValues.charId))
            end
        elseif expectedValue == ph.TEST_MOB then
            if actualValue ~= phValues.mobId then
                table.insert(diffs, fieldName .. ': ' .. tostring(actualValue) .. ' != ' .. tostring(phValues.mobId))
            end
        elseif actualValue ~= expectedValue then
            table.insert(diffs, fieldName .. ': ' .. tostring(actualValue) .. ' != ' .. tostring(expectedValue))
        end
    end

    return diffs
end

-- Spawns the first mob of that name in the player's zone and stands the player next to it.
local function spawnNamed(player, name)
    local mob = player.entities:get(name)
    mob:respawn()
    player.entities:moveTo(mob)
    return mob
end

local testSuites =
{
    ['Basic Attacks'] =
    {
        ['Guarded hits'] =
        {
            test = function(player, mob)
                player:changeJob(xi.job.BRD)
                player:setLevel(75)
                player:setMod(xi.mod.ACC, 1000)
                player:addItem(xi.item.BRONZE_DAGGER)
                player:equipItem(xi.item.BRONZE_DAGGER, nil, xi.slot.MAIN)
                local mnkMob = spawnNamed(player, 'Giant_Ascetic')
                stub('xi.combat.physical.isGuarded', true)
                mnkMob:setMod(xi.mod.ADDITIVE_GUARD, 100)
                mnkMob:updateEnmity(player)

                player.actions:engage(mnkMob)
                for _ = 1, 20 do
                    xi.test.world:tickEntity(player)
                    xi.test.world:skipTime(10)
                end
            end,

            expected = basicAttacks['Guarded hits'].expected,
        },

        ['Parried hits'] =
        {
            test = function(player, mob)
                stub('xi.combat.physical.isParried', true)
                player:changeJob(xi.job.BRD)
                player:setLevel(75)
                player:setMod(xi.mod.ACC, 1000)
                player:addItem(xi.item.BRONZE_DAGGER)
                player:equipItem(xi.item.BRONZE_DAGGER, nil, xi.slot.MAIN)
                local warMob = spawnNamed(player, 'Giant_Ranger')
                player.actions:engage(warMob)
                warMob:updateEnmity(player)

                for _ = 1, 20 do
                    xi.test.world:tickEntity(player)
                    xi.test.world:skipTime(10)
                end

                warMob:disengage()
            end,

            expected = basicAttacks['Parried hits'].expected,
        },
    },

    ['Beastmaster'] =
    {
        ['Jug Pet Sic'] =
        {
            test = function(player, mob)
                stub('xi.mobskills.mobPhysicalMove', { damage = 1, hitsLanded = 1, isCritical = false })
                player:changeJob(xi.job.BST)
                player:spawnPet(xi.petId.COLDBLOOD_COMO)
                local pet = player:getPet()
                assert(pet)

                -- Auto-attacks could kill the level 28 Clipper before the move resolves.
                pet:setAutoAttackEnabled(false)

                pet:engage(mob:getTargID())
                pet:setTP(1000)
                xi.test.world:tickEntity(pet)
                xi.test.world:skipTime(5)
                player.actions:useAbility(player, xi.jobAbility.SIC)

                -- Sic picks a random move, and some take longer to ready than others.
                for _ = 1, 10 do
                    xi.test.world:skipTime(1)
                    xi.test.world:tickEntity(pet)
                    xi.test.world:tickEntity(mob)
                end
            end,

            expected =
            {
                {
                    m_uID   = ph.TEST_CHAR,
                    trg_sum = 1,
                    res_sum = 0,
                    cmd_no  = xi.action.category.JOBABILITY_FINISH,
                    cmd_arg = xi.jobAbility.SIC,
                    info    = 0,
                },
                -- Some era eft moves target the pet itself, so the target is not checked.
                {
                    trg_sum = 1,
                    res_sum = 0,
                    cmd_no  = xi.action.category.MOBABILITY_FINISH,
                    info    = 0,
                },
            },
        },
    },

    -- Era Fast Cast tiers leave Stoneskin's 30 second recast at 27 (info), not 25.
    ['Magic #magic'] =
    {
        ['Stoneskin Self (Hit)'] =
        {
            test = function(player, mob)
                player:changeJob(xi.job.RDM)
                player:setLevel(75)
                player:addSpell(xi.magic.spell.STONESKIN)
                player.actions:useSpell(player, xi.magic.spell.STONESKIN)
                xi.test.world:skipTime(10)
            end,

            expected = withFields(magic['Stoneskin Self (Hit)'].expected, { info = 27 }),
        },

        ['Stoneskin Self (Miss)'] =
        {
            test = function(player, mob)
                player:changeJob(xi.job.RDM)
                player:setLevel(75)
                player:addSpell(xi.magic.spell.STONESKIN)
                player.actions:useSpell(player, xi.magic.spell.STONESKIN)
                xi.test.world:skipTime(10)
                xi.test.world:skipTime(30)
                player.actions:useSpell(player, xi.magic.spell.STONESKIN)
                xi.test.world:skipTime(10)
            end,

            expected = withFields(magic['Stoneskin Self (Miss)'].expected, { info = 27 }),
        },
    },

    ['Mobskills'] =
    {
        ['Mob buffing self + ally (MobSkillFinish)'] =
        {
            test = function(player, mob)
                player:gotoZone(xi.zone.DYNAMIS_SAN_DORIA)
                local thfMob = spawnNamed(player, 'Vanguard_Pillager')

                -- Old-school Dynamis has no other mob up, so bring a second Pillager to its side.
                local pos  = thfMob:getPos()
                local ally = player.entities:get(player:getZone():queryEntitiesByName('Vanguard_Pillager')[2]:getID())
                ally:setSpawn(pos.x + 1, pos.y, pos.z)
                ally:respawn()

                thfMob:useMobAbility(xi.mobSkill.HOWL, thfMob, 0)
                xi.test.world:tickEntity(thfMob)
                xi.test.world:skipTime(10)
                xi.test.world:skipTime(10)
            end,

            expected = mobskills['Mob buffing self + ally (MobSkillFinish)'].expected,
        },

        ['Sweep no valid target in range'] =
        {
            test = function(player, mob)
                player:gotoZone(xi.zone.DYNAMIS_WINDURST)
                local yagudo = spawnNamed(player, 'Vanguard_Sentinel')
                yagudo:updateEnmity(player)
                yagudo:addTP(3000)
                yagudo:useMobAbility(xi.mobSkill.SWEEP, player, 5, true)
                -- Move player far away so Sweep has no targets in range
                player.actions:move(yagudo:getXPos() + 25, yagudo:getYPos(), yagudo:getZPos())
                xi.test.world:tickEntity(yagudo)
                xi.test.world:skipTime(10)
            end,

            expected = mobskills['Sweep no valid target in range'].expected,
        },
    },

    ['Weaponskills #ws'] =
    {
        ['Guarded WS'] =
        {
            test = function(player, mob)
                stub('xi.combat.physicalHitRate.getPhysicalHitRate', 1)
                player:changeJob(xi.job.THF)
                player:setLevel(75)
                player:setSkillLevel(xi.skill.DAGGER, 2000) -- Dancing Edge needs 200
                player:addItem(xi.item.BRONZE_DAGGER)
                player:equipItem(xi.item.BRONZE_DAGGER, nil, xi.slot.MAIN)
                player:setTP(3000)
                local mnkMob = spawnNamed(player, 'Giant_Ascetic')
                stub('xi.combat.physical.isGuarded', true)
                mnkMob:setMod(xi.mod.ADDITIVE_GUARD, 100)

                player.actions:engage(mnkMob)
                mnkMob:updateEnmity(player)
                xi.test.world:tickEntity(player)
                xi.test.world:skipTime(1)
                player.actions:useWeaponskill(mnkMob, xi.weaponskill.DANCING_EDGE)
                xi.test.world:skipTime(3)
                mnkMob:disengage()
            end,

            expected =
            {
                m_uID   = ph.TEST_CHAR,
                trg_sum = 1,
                res_sum = 0,
                cmd_no  = xi.action.category.WEAPONSKILL_FINISH,
                cmd_arg = xi.weaponskill.DANCING_EDGE,
                info    = 0,
                target  =
                {
                    {
                        result_sum = 1,
                        result     =
                        {
                            {
                                miss      = xi.action.resolution.GUARD,
                                kind      = 3,
                                sub_kind  = 38, -- Dancing Edge animation (data/weapon_skills.yaml)
                                message   = xi.msg.basic.DAMAGE,
                                bit       = 0,
                                has_proc  = false,
                                has_react = false,
                            },
                        },
                    },
                },
            },
        },
    },
}

describe('BATTLE2', function()
    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local mob

    before_each(function()
        xi.test.world:setSeed(1)

        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75, zone = xi.zone.QUFIM_ISLAND })

        -- The Clipper spawns at level 28 or 29; pin it like base.lua does.
        mob = player.entities:get(17293357)
        mob:setLevelRange(28, 28)
        mob:setSpawn(10.7, -20.4, -88.1)
        mob:respawn()
        mob.assert:isAlive()
        player.entities:moveTo(mob)
        mob:updateEnmity(player)
    end)

    -- Sorted like base.lua, so the cases run in the same order every time.
    local suiteNames = {}
    for suiteName in pairs(testSuites) do
        table.insert(suiteNames, suiteName)
    end

    table.sort(suiteNames)

    for _, suiteName in ipairs(suiteNames) do
        local suite     = testSuites[suiteName]
        local caseNames = {}
        for caseName in pairs(suite) do
            table.insert(caseNames, caseName)
        end

        table.sort(caseNames)

        describe(suiteName, function()
            for _, caseName in ipairs(caseNames) do
                local case = suite[caseName]
                it(caseName, function()
                    case.test(player, mob)
                    xi.test.world:tickEntity(player)
                    xi.test.world:tickEntity(mob)

                    local expectedPackets = case.expected[1] and case.expected or { case.expected }
                    local received        = player.packets:actionPackets()
                    local phValues        = { charId = player:getID(), mobId = mob:getID() }
                    local unmatched       = {}

                    for index, expectedPacket in ipairs(expectedPackets) do
                        local closest = nil
                        for _, action in pairs(received) do
                            local diffs = diffPacket(action, expectedPacket, 'action', phValues)
                            if closest == nil or #diffs < #closest then
                                closest = diffs
                            end
                        end

                        if closest == nil or #closest > 0 then
                            table.insert(unmatched, index)
                            print('Expected #' .. tostring(index) .. ' closest diffs: ' .. (closest and table.concat(closest, '; ') or 'no packets'))
                        end
                    end

                    assert(#unmatched == 0, 'Could not match expected BATTLE2 packet(s): ' .. table.concat(unmatched, ', '))
                end)
            end
        end)
    end
end)
