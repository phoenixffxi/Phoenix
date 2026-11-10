-----------------------------------
-- Era job abilities: pre-Abyssea powers and durations, merit recast cuts, Phantom Roll values
-- and spirit perpetuation.
-- Every job's overrides are checked, then one ability for each kind of change.
-- Covers: modules/era/lua/globals/job_utils/beastmaster.lua
-- Covers: modules/era/lua/globals/job_utils/corsair.lua
-- Covers: modules/era/lua/globals/job_utils/dark_knight.lua
-- Covers: modules/era/lua/globals/job_utils/dragoon.lua
-- Covers: modules/era/lua/globals/job_utils/monk.lua
-- Covers: modules/era/lua/globals/job_utils/ninja.lua
-- Covers: modules/era/lua/globals/job_utils/paladin.lua
-- Covers: modules/era/lua/globals/job_utils/ranger.lua
-- Covers: modules/era/lua/globals/job_utils/samurai.lua
-- Covers: modules/era/lua/globals/job_utils/summoner.lua
-- Covers: modules/era/lua/globals/job_utils/thief.lua
-- Covers: modules/era/lua/globals/job_utils/warrior.lua
-- Covers: modules/era/lua/globals/job_utils/white_mage.lua
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Stands in for the ability's action packet: keeps the recast it is given and ignores everything else.
local function fakeAction(recast)
    local action =
    {
        recast = recast,
    }

    function action:getRecast()
        return self.recast
    end

    function action:setRecast(value)
        self.recast = value
    end

    return setmetatable(action, {
        __index = function()
            return function()
            end
        end,
    })
end

describe('Era job abilities', function()
    it('applies the overrides of every job', function()
        moduleTest.assertCoveredOverridesApplied()
    end)

    it('gives Berserk a flat 25% attack at level 75', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })

        player.actions:useAbility(player, xi.jobAbility.BERSERK)
        xi.test.world:tick()

        player.assert
            :hasEffect(xi.effect.BERSERK)
            :hasModifier(xi.mod.ATTP, 25)
    end)

    it('gives Ancient Circle a one minute duration', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.DRG, level = 75 })

        player.actions:useAbility(player, xi.jobAbility.ANCIENT_CIRCLE)
        xi.test.world:tick()

        local effect = player:getStatusEffect(xi.effect.ANCIENT_CIRCLE)
        assert(effect, 'Ancient Circle gave no effect')
        assert(effect:getDuration() == 60000, string.format('expected 60000 ms, got %d', effect:getDuration()))
    end)

    -- Without merits the merit term is 0 - 150, so the recast grows by 150 s.
    it('heals twice the HP Martyr costs and sets its recast from merits', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.WHM, level = 75 })
        local ally   = xi.test.world:spawnPlayer({ job = xi.job.WHM, level = 75 })
        ally:setHP(1)

        local cost   = math.floor(player:getHP() * 0.25)
        local action = fakeAction(600)
        xi.job_utils.white_mage.useMartyr(player, ally, nil, action)

        assert(ally:getHP() - 1 == cost * 2, string.format('expected +%d HP, got %+d', cost * 2, ally:getHP() - 1))
        assert(action.recast == 750, string.format('expected recast 750, got %d', action.recast))
    end)

    it('uses the pre-Abyssea Ninja Roll powers and bonus', function()
        local powers   = { 4, 6, 8, 25, 10, 12, 14, 2, 17, 20, 30, 8 }
        local rollInfo = xi.job_utils.corsair.rollData[xi.jobAbility.NINJA_ROLL]

        assert(rollInfo.bonus == 10, string.format('expected bonus 10, got %d', rollInfo.bonus))
        for total, power in ipairs(powers) do
            assert(rollInfo.powers[total] == power, string.format('at %d: expected %d, got %s', total, power, tostring(rollInfo.powers[total])))
        end
    end)

    it('charges 18 MP a tick for a level 75 elemental spirit', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.SMN, level = 75 })

        player:spawnPet(xi.petId.FIRE_SPIRIT)
        local perpetuation = player:getMod(xi.mod.AVATAR_PERPETUATION)
        player:despawnPet()

        assert(perpetuation == 18, string.format('expected 18, got %d', perpetuation))
    end)
end)
