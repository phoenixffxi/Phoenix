-----------------------------------
-- Era mission battlefields: restores the level caps on Rank 2, Rank 5 and CoP mission fights.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era mission level caps', function()
    local function expectLevelCap(battlefieldId, expected)
        local content = xi.battlefield.contents[battlefieldId]
        assert(content, string.format('battlefield %d is not loaded', battlefieldId))
        assert(content.levelCap == expected, string.format('battlefield %d: expected cap %d, got %s', battlefieldId, expected, tostring(content.levelCap)))
    end

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/battlefields/mission_level_caps.lua')
    end)

    it('caps Rank 2 at 25 and Rank 5 at 50', function()
        expectLevelCap(xi.battlefield.id.RANK_2_MISSION, 25)
        expectLevelCap(xi.battlefield.id.RANK_5_MISSION, 50)
    end)

    describe('every battlefield #exhaustive', function()
        it('caps every mission battlefield', function()
            local expected =
            {
                [xi.battlefield.id.RANK_2_MISSION                      ] = 25,
                [xi.battlefield.id.RANK_2_MISSION_1                    ] = 25,
                [xi.battlefield.id.RANK_2_MISSION_2                    ] = 25,
                [xi.battlefield.id.RANK_5_MISSION                      ] = 50,
                [xi.battlefield.id.ANCIENT_FLAMES_BECKON_SPIRE_OF_HOLLA] = 30,
                [xi.battlefield.id.ANCIENT_FLAMES_BECKON_SPIRE_OF_DEM  ] = 30,
                [xi.battlefield.id.ANCIENT_FLAMES_BECKON_SPIRE_OF_MEA  ] = 30,
                [xi.battlefield.id.DARKNESS_NAMED                      ] = 40,
                [xi.battlefield.id.ANCIENT_VOWS                        ] = 40,
                [xi.battlefield.id.SAVAGE                              ] = 50,
                [xi.battlefield.id.DESIRES_OF_EMPTINESS                ] = 50,
                [xi.battlefield.id.HEAD_WIND                           ] = 50,
                [xi.battlefield.id.ONE_TO_BE_FEARED                    ] = 60,
                [xi.battlefield.id.FLAMES_FOR_THE_DEAD                 ] = 60,
                [xi.battlefield.id.CENTURY_OF_HARDSHIP                 ] = 60,
                [xi.battlefield.id.WARRIORS_PATH                       ] = 75,
                [xi.battlefield.id.WHEN_ANGELS_FALL                    ] = 75,
                [xi.battlefield.id.DAWN                                ] = 75,
            }

            for battlefieldId, cap in pairs(expected) do
                expectLevelCap(battlefieldId, cap)
            end
        end)
    end)
end)
