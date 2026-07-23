-----------------------------------
-- Module: Damage Spell Adjustments
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('damage_spell_adjustments')

local damageColumn =
{
    BONUS_MACC = 2,
}

-----------------------------------
-- Revert AM2 magic accuracy to pre RoV values, plus merit-based magic burst and magic accuracy.
-- Source: https://forum.square-enix.com/ffxi/threads/55525-June.-10-2019-%28JST%29-Version-Update
-----------------------------------
local meritBySpell =
{
    [xi.magic.spell.FLARE_II  ] = xi.merit.FLARE_II,
    [xi.magic.spell.FREEZE_II ] = xi.merit.FREEZE_II,
    [xi.magic.spell.TORNADO_II] = xi.merit.TORNADO_II,
    [xi.magic.spell.QUAKE_II  ] = xi.merit.QUAKE_II,
    [xi.magic.spell.BURST_II  ] = xi.merit.BURST_II,
    [xi.magic.spell.FLOOD_II  ] = xi.merit.FLOOD_II,
}

-- Revert magic accuracy for BLM AM2 to pre RoV values.
for spellId in pairs(meritBySpell) do
    xi.spells.damage.pTable[spellId][damageColumn.BONUS_MACC] = 0
end

m:addOverride('xi.spells.damage.calculateIfMagicBurstBonus', function(caster, target, spellId, skillType, spellElement)
    local magicBurstBonus = super(caster, target, spellId, skillType, spellElement)
    local merit           = meritBySpell[spellId]

    if merit then
        local rank = caster:getMerit(merit)

        if rank > 1 then
            magicBurstBonus = magicBurstBonus + (rank - 1) * 0.03
        end
    end

    return magicBurstBonus
end)

-- Apply magic accuracy merit mod for spell calculations and remove it afterward.
m:addOverride('xi.spells.damage.useDamageSpell', function(caster, target, spell)
    local merit     = meritBySpell[spell:getID()]
    local maccBonus = 0

    if merit then
        local rank = caster:getMerit(merit)

        if rank > 1 then
            maccBonus = (rank - 1) * 5
        end
    end

    if maccBonus > 0 then
        caster:addMod(xi.mod.MACC, maccBonus)
    end

    local damage = super(caster, target, spell)

    if maccBonus > 0 then
        caster:delMod(xi.mod.MACC, maccBonus)
    end

    return damage
end)

return m
