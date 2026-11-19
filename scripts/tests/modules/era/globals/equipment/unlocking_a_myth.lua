-----------------------------------
-- Pre-2014 Unlocking a Myth: Vigil weapons need 250 to 16000 weapon skill points by Nyzul floor cleared.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era Unlocking a Myth', function()
    local player
    local weapons =
    {
        'brave_blade',
        'burning_fists',
        'dancing_dagger',
        'death_sickle',
        'double_axe',
        'elder_staff',
        'inferno_claws',
        'killer_bow',
        'mages_staff',
        'main_gauche',
        'quicksilver',
        'radiant_lance',
        'sasuke_katana',
        'scepter_staff',
        'sturdy_axe',
        'swordbreaker',
        'vorpal_sword',
        'werebuster',
        'wightslayer',
        'windslicer',
    }

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.MNK, level = 75 })
        player:addItem(xi.item.BURNING_FISTS)
    end)

    after_each(function()
        player:setCharVar('NyzulFloorProgress', 0)
    end)

    it('applies its overrides', function()
        local equipTargets = {}
        for _, weaponName in ipairs(weapons) do
            table.insert(equipTargets, string.format('xi.items.%s.onItemEquip', weaponName))
        end

        moduleTest.assertOverridesApplied('modules/era/lua/globals/equipment/unlocking_a_myth.lua', { targets = equipTargets, newTargets = equipTargets })
    end)

    it('needs 16000 points with no Nyzul floor cleared', function()
        local points = xi.equipment.vigilWeaponRequiredWsPoints(player)
        assert(points == 16000, string.format('expected 16000, got %s', tostring(points)))
    end)

    it('sets the requirement on a Vigil weapon when it is equipped', function()
        player:equipItem(xi.item.BURNING_FISTS, nil, xi.slot.MAIN)

        local weapon = player:getEquippedItem(xi.slot.MAIN)
        assert(weapon and weapon:getID() == xi.item.BURNING_FISTS, 'Burning Fists did not equip')
        assert(weapon:getWeaponskillPointsNeeded() == 16000, string.format('expected 16000, got %d', weapon:getWeaponskillPointsNeeded()))
    end)

    describe('every floor and weapon #exhaustive', function()
        it('scales the requirement by Nyzul floor cleared', function()
            local expected =
            {
                [  1] = 13760,
                [ 19] =  8000,
                [ 20] =  7040,
                [ 40] =  3520,
                [ 59] =  2000,
                [ 60] =  1760,
                [ 80] =   880,
                [ 99] =   500,
                [100] =   250,
            }

            for floor, points in pairs(expected) do
                player:setCharVar('NyzulFloorProgress', floor)
                local live = xi.equipment.vigilWeaponRequiredWsPoints(player)
                assert(live == points, string.format('floor %d: expected %d, got %s', floor, points, tostring(live)))
            end
        end)

        it('sets the requirement on every Vigil weapon', function()
            player:setCharVar('NyzulFloorProgress', 45)
            local item = player:findItem(xi.item.BURNING_FISTS)

            for _, weaponName in ipairs(weapons) do
                item:setWeaponskillPointsNeeded(0)
                xi.items[weaponName].onItemEquip(player, item)
                assert(item:getWeaponskillPointsNeeded() == 3120, string.format('%s: expected 3120, got %d', weaponName, item:getWeaponskillPointsNeeded()))
            end
        end)
    end)
end)
