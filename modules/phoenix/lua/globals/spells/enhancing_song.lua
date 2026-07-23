-----------------------------------
-- Module: Enhancing Song Adjustments
-----------------------------------
require('modules/module_utils')
-----------------------------------
local moduleName = 'enhancing_song_adjustments'

local songColumn =
{
    MERIT_ID          = 5,
    POWER_BASE        = 7,
    SKILL_REQUIREMENT = 8,
    POWER_CAP         = 9,
    MULTIPLIER        = 10,
    DIVISOR           = 11,
}

-- Foe Sirvente / Adventurer's Dirge: Add Merit support.
-- Source: https://forum.square-enix.com/ffxi/threads/55899-September.-10-2019-%28JST%29-Version-Update?p=619588&viewfull=1#post619588
-- Carol / Madrigal / Mambo / March / Minne / Minuet / Prelude: Revert power caps and multipliers.
-- Source: https://forum.square-enix.com/ffxi/threads/52095-Feb.-10-2017-%28JST%29-Version-Update
local songAdjustments =
{
    -- Emnity Songs
    { spell = xi.magic.spell.FOE_SIRVENTE,      merit = xi.merit.FOE_SIRVENTE,      powerBase = 0 },
    { spell = xi.magic.spell.ADVENTURERS_DIRGE, merit = xi.merit.ADVENTURERS_DIRGE, powerBase = 5 },

    -- Carol
    { spell = xi.magic.spell.FIRE_CAROL,      powerCap = 50, multiplier = 5 },
    { spell = xi.magic.spell.ICE_CAROL,       powerCap = 50, multiplier = 5 },
    { spell = xi.magic.spell.WIND_CAROL,      powerCap = 50, multiplier = 5 },
    { spell = xi.magic.spell.EARTH_CAROL,     powerCap = 50, multiplier = 5 },
    { spell = xi.magic.spell.LIGHTNING_CAROL, powerCap = 50, multiplier = 5 },
    { spell = xi.magic.spell.WATER_CAROL,     powerCap = 50, multiplier = 5 },
    { spell = xi.magic.spell.LIGHT_CAROL,     powerCap = 50, multiplier = 5 },
    { spell = xi.magic.spell.DARK_CAROL,      powerCap = 50, multiplier = 5 },

    -- Madrigal
    { spell = xi.magic.spell.SWORD_MADRIGAL, powerCap = 15, multiplier = 2, divisor = 23.25, skillRequirement = 40 },
    { spell = xi.magic.spell.BLADE_MADRIGAL, powerCap = 30, multiplier = 2 },

    -- Mambo
    { spell = xi.magic.spell.SHEEPFOE_MAMBO,  powerCap = 15, multiplier = 2.5 },
    { spell = xi.magic.spell.DRAGONFOE_MAMBO, powerCap = 23, multiplier = 2.5 },

    -- March
    { spell = xi.magic.spell.ADVANCING_MARCH, powerCap = 64, multiplier = 16 },
    { spell = xi.magic.spell.VICTORY_MARCH,   powerCap = 96, powerBase = 53 },

    -- Minne
    { spell = xi.magic.spell.KNIGHTS_MINNE,     powerCap = 13, multiplier = 2.5, divisor = 15, powerBase = 5  },
    { spell = xi.magic.spell.KNIGHTS_MINNE_II,  powerCap = 27, multiplier = 2.5, divisor = 15, powerBase = 6  },
    { spell = xi.magic.spell.KNIGHTS_MINNE_III, powerCap = 40, multiplier = 2.5, divisor = 15, powerBase = 10 },
    { spell = xi.magic.spell.KNIGHTS_MINNE_IV,  powerCap = 48, multiplier = 2.5, divisor = 15, powerBase = 12 },

    -- Minuet
    { spell = xi.magic.spell.VALOR_MINUET,     powerCap = 16, multiplier = 2.5, divisor = 6 },
    { spell = xi.magic.spell.VALOR_MINUET_II,  powerCap = 32, multiplier = 2.5, divisor = 6,  skillRequirement = 85 },
    { spell = xi.magic.spell.VALOR_MINUET_III, powerCap = 48, multiplier = 2.5, divisor = 6 },
    { spell = xi.magic.spell.VALOR_MINUET_IV,  powerCap = 56, multiplier = 2.5, divisor = 15, powerBase = 29 },

    -- Prelude
    { spell = xi.magic.spell.HUNTERS_PRELUDE, powerCap = 15, multiplier = 2 },
    { spell = xi.magic.spell.ARCHERS_PRELUDE, powerCap = 30, multiplier = 2 },
}

for _, entry in ipairs(songAdjustments) do
    local row = xi.spells.enhancing.songPTable[entry.spell]

    if entry.merit then
        row[songColumn.MERIT_ID] = entry.merit
    end

    if entry.powerBase then
        row[songColumn.POWER_BASE] = entry.powerBase
    end

    if entry.skillRequirement then
        row[songColumn.SKILL_REQUIREMENT] = entry.skillRequirement
    end

    if entry.powerCap then
        row[songColumn.POWER_CAP] = entry.powerCap
    end

    if entry.multiplier then
        row[songColumn.MULTIPLIER] = entry.multiplier
    end

    if entry.divisor then
        row[songColumn.DIVISOR] = entry.divisor
    end
end

return { name = moduleName }
