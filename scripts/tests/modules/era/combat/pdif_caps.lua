-----------------------------------
-- Base game pDIF caps: 2 for melee, 3 for ranged, and the 0.375 margin added after the cap.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era pDIF caps', function()
    local function expectRatioCaps(wRatio, finalCap, expectedLower, expectedUpper)
        local lower, upper = xi.combat.physical.wRatioCapPC(wRatio, finalCap)
        assert(lower == expectedLower, string.format('ratio %.2f cap %.2f: expected lower %.3f, got %s', wRatio, finalCap, expectedLower, tostring(lower)))
        assert(upper == expectedUpper, string.format('ratio %.2f cap %.2f: expected upper %.3f, got %s', wRatio, finalCap, expectedUpper, tostring(upper)))
    end

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/combat/pdif_caps.lua')
    end)

    it('caps a sword at a pDIF of 2', function()
        local cap = xi.combat.physical.pDifWeaponCapTable[xi.skill.SWORD]
        assert(cap == 2, string.format('expected 2, got %s', tostring(cap)))
    end)

    it('adds 0.375 after capping a high ratio', function()
        expectRatioCaps(3, 2, 1.625, 2.375)
    end)

    describe('every cap #exhaustive', function()
        it('sets every weapon skill cap', function()
            local expected =
            {
                [xi.skill.HAND_TO_HAND    ] = 2,
                [xi.skill.DAGGER          ] = 2,
                [xi.skill.SWORD           ] = 2,
                [xi.skill.GREAT_SWORD     ] = 2,
                [xi.skill.AXE             ] = 2,
                [xi.skill.GREAT_AXE       ] = 2,
                [xi.skill.SCYTHE          ] = 2,
                [xi.skill.POLEARM         ] = 2,
                [xi.skill.KATANA          ] = 2,
                [xi.skill.GREAT_KATANA    ] = 2,
                [xi.skill.CLUB            ] = 2,
                [xi.skill.STAFF           ] = 2,
                [xi.skill.AUTOMATON_MELEE ] = 2,
                [xi.skill.AUTOMATON_RANGED] = 3,
                [xi.skill.AUTOMATON_MAGIC ] = 2,
                [xi.skill.ARCHERY         ] = 3,
                [xi.skill.MARKSMANSHIP    ] = 3,
                [xi.skill.THROWING        ] = 3,
                [xi.skill.BLUE_MAGIC      ] = 2,
            }

            for skill, cap in pairs(expected) do
                local live = xi.combat.physical.pDifWeaponCapTable[skill]
                assert(live == cap, string.format('skill %d: expected %d, got %s', skill, cap, tostring(live)))
            end
        end)

        it('caps the upper bound from a ratio of 1.5', function()
            local _, upper = xi.combat.physical.wRatioCapPC(1.8, 1.5)
            assert(upper == 1.875, string.format('expected upper 1.875, got %s', tostring(upper)))
        end)

        it('caps the lower bound from a ratio of 2.44', function()
            expectRatioCaps(2.5, 2, 1.625, 2.375)
        end)
    end)
end)
