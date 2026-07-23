-----------------------------------
-- Module: Enhancing Ninjutsu Adjustments
-----------------------------------
require('modules/module_utils')
-----------------------------------
local moduleName = 'enhancing_ninjutsu_adjustments'

local ninjutsuColumn =
{
    EFFECT_DURATION = 4,
}

-- Detection Spells: Revert durations.
-- Source: https://forum.square-enix.com/ffxi/threads/39564-Jan-21-2014-%28JST%29-Version-Update
xi.spells.enhancing.ninjutsuPTable[xi.magic.spell.TONKO_ICHI ][ninjutsuColumn.EFFECT_DURATION] = 180
xi.spells.enhancing.ninjutsuPTable[xi.magic.spell.TONKO_NI   ][ninjutsuColumn.EFFECT_DURATION] = 300
xi.spells.enhancing.ninjutsuPTable[xi.magic.spell.MONOMI_ICHI][ninjutsuColumn.EFFECT_DURATION] = 180

return { name = moduleName }
