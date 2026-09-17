-----------------------------------
-- Module: Damage Ninjutsu Adjustments
-- Revert the San ninjutsu merits to a per-rank MATT/MACC bonus applied for the cast.
-- Source: https://forum.square-enix.com/ffxi/threads/55648-July.-8-2019-%28JST%29-Version-Update
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('damage_ninjutsu_adjustments')

local sanSpellOverrides =
{
    { path = 'xi.actions.spells.ninjutsu.katon_san.onSpellCast',  merit = xi.merit.KATON_SAN  },
    { path = 'xi.actions.spells.ninjutsu.hyoton_san.onSpellCast', merit = xi.merit.HYOTON_SAN },
    { path = 'xi.actions.spells.ninjutsu.huton_san.onSpellCast',  merit = xi.merit.HUTON_SAN  },
    { path = 'xi.actions.spells.ninjutsu.doton_san.onSpellCast',  merit = xi.merit.DOTON_SAN  },
    { path = 'xi.actions.spells.ninjutsu.raiton_san.onSpellCast', merit = xi.merit.RAITON_SAN },
    { path = 'xi.actions.spells.ninjutsu.suiton_san.onSpellCast', merit = xi.merit.SUITON_SAN },
}

for _, entry in ipairs(sanSpellOverrides) do
    m:addOverride(entry.path, function(caster, target, spell)
        local meritBonus = caster:getMerit(entry.merit)

        if meritBonus > 0 then
            caster:addMod(xi.mod.MATT, meritBonus)
            caster:addMod(xi.mod.MACC, meritBonus)
        end

        local damage = super(caster, target, spell)

        if meritBonus > 0 then
            caster:delMod(xi.mod.MATT, meritBonus)
            caster:delMod(xi.mod.MACC, meritBonus)
        end

        return damage
    end)
end

return m
