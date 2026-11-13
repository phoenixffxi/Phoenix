-----------------------------------
-- Pre-March 2012 testimonies: one battlefield entry wears a testimony out.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era testimony single use', function()
    local player
    local content

    -- Enters Shattering Stars (WAR) as its initiator and returns the testimony's wear.
    local function enterWithTestimony()
        local battlefield =
        {
            getID = function()
                return content.battlefieldId
            end,

            getInitiator = function()
                return player:getID()
            end,
        }

        content.onBattlefieldEnter(content, player, battlefield)

        return player:getWornUses(xi.item.WARRIORS_TESTIMONY)
    end

    setup(function()
        content = xi.battlefield.contents[xi.battlefield.id.SHATTERING_STARS_WAR]
    end)

    before_each(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
        player:addItem(xi.item.WARRIORS_TESTIMONY)
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/globals/testimony_single_use.lua')
    end)

    it('wears a new testimony out on the first entry', function()
        local wear = enterWithTestimony()
        assert(wear == 3, string.format('expected 3 of 3 uses worn, got %d', wear))
    end)

    describe('wear #exhaustive', function()
        it('wears a used testimony out on the next entry', function()
            player:incrementItemWear(xi.item.WARRIORS_TESTIMONY)

            local wear = enterWithTestimony()
            assert(wear == 3, string.format('expected 3 of 3 uses worn, got %d', wear))
        end)
    end)
end)
