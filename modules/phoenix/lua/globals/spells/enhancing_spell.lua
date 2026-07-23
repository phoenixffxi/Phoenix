-----------------------------------
-- Module: Enhancing Spell Adjustments
-----------------------------------
require('modules/module_utils')
-----------------------------------
local moduleName = 'enhancing_spell_adjustments'

if xi.module.isContentEnabled('ROV') then
    return { name = moduleName }
end

local spellColumn =
{
    EFFECT_LEVEL     = 3, -- xi.spells.enhancing (core) column.EFFECT_LEVEL
    POWER_BASE       = 4, -- xi.spells.enhancing (core) column.EFFECT_POWER
    EFFECT_COMPOSURE = 6, -- xi.spells.enhancing (core) column.EFFECT_COMPOSURE
}

-- Protect / Shell: Revert power caps.
-- Source: https://forum.square-enix.com/ffxi/threads/55360-May.-10-2019-%28JST%29-Version-Update?p=615387&viewfull=1#post615387
local spellAdjustments =
{
    -- Emnity Songs
    { spell = xi.magic.spell.PROTECT,       powerBase = 15   },
    { spell = xi.magic.spell.PROTECT_II,    powerBase = 25   },
    { spell = xi.magic.spell.PROTECT_III,   powerBase = 40   },
    { spell = xi.magic.spell.PROTECT_IV,    powerBase = 55   },
    { spell = xi.magic.spell.PROTECT_V,     powerBase = 70   },
    { spell = xi.magic.spell.PROTECTRA,     powerBase = 15   },
    { spell = xi.magic.spell.PROTECTRA_II,  powerBase = 25   },
    { spell = xi.magic.spell.PROTECTRA_III, powerBase = 40   },
    { spell = xi.magic.spell.PROTECTRA_IV,  powerBase = 55   },
    { spell = xi.magic.spell.PROTECTRA_V,   powerBase = 70   },
    { spell = xi.magic.spell.SHELL,         powerBase = 937  },
    { spell = xi.magic.spell.SHELL_II,      powerBase = 1406 },
    { spell = xi.magic.spell.SHELL_III,     powerBase = 1875 },
    { spell = xi.magic.spell.SHELL_IV,      powerBase = 2187 },
    { spell = xi.magic.spell.SHELL_V,       powerBase = 2421 },
    { spell = xi.magic.spell.SHELLRA,       powerBase = 937  },
    { spell = xi.magic.spell.SHELLRA_II,    powerBase = 1406 },
    { spell = xi.magic.spell.SHELLRA_III,   powerBase = 1875 },
    { spell = xi.magic.spell.SHELLRA_IV,    powerBase = 2187 },
    { spell = xi.magic.spell.SHELLRA_V,     powerBase = 2421 },
}

for _, entry in ipairs(spellAdjustments) do
    local row = xi.spells.enhancing.spellPTable[entry.spell]

    if entry.powerBase then
        row[spellColumn.POWER_BASE] = entry.powerBase
    end
end

local m = Module:new(moduleName)

-- Deodorize / Sneak / Invisible: Revert base duration to a random 30s-300s.
m:addOverride('xi.spells.enhancing.calculateEnhancingDuration', function(caster, target, spell, spellId, spellGroup, spellEffect)
    if
        not (spellEffect == xi.effect.DEODORIZE or
        spellEffect == xi.effect.INVISIBLE or
        spellEffect == xi.effect.SNEAK)
    then
        return super(caster, target, spell, spellId, spellGroup, spellEffect)
    end

    local spellLevel   = xi.spells.enhancing.spellPTable[spellId][spellColumn.EFFECT_LEVEL]
    local targetLevel  = target:getMainLvl()

    -- Reverted base duration.
    local duration = math.random(30, 300)

    -- Gear durations (e.g. Skulker's Cape).
    if spellEffect == xi.effect.INVISIBLE then
        duration = duration + target:getMod(xi.mod.INVISIBLE_DURATION)
    elseif spellEffect == xi.effect.SNEAK then
        duration = duration + target:getMod(xi.mod.SNEAK_DURATION)
    end

    -- Composure.
    if
        caster:hasStatusEffect(xi.effect.COMPOSURE) and
        caster:getID() == target:getID()
    then
        duration = duration * 3
    end

    -- Level penalty to duration.
    if targetLevel < spellLevel then
        duration = duration * targetLevel / spellLevel
    end

    return duration
end)

-----------------------------------
-- Merits: Protectra V / Shellra V (power), Phalanx II (power and duration).
-- Source: https://forum.square-enix.com/ffxi/threads/55360-May.-10-2019-%28JST%29-Version-Update?p=615387&viewfull=1#post615387
-----------------------------------
local meritBonusBySpell =
{
    [xi.magic.spell.PROTECTRA_V] = { merit = xi.merit.PROTECTRA_V, defense         = 2  },
    [xi.magic.spell.SHELLRA_V  ] = { merit = xi.merit.SHELLRA_V,   magicDmgTaken   = 80 },
    [xi.magic.spell.PHALANX_II ] = { merit = xi.merit.PHALANX_II,  damageReduction = 3, duration = 30 },
}

m:addOverride('xi.spells.enhancing.calculateEnhancingFinalPower', function(caster, target, spell, basePower, spellGroup, tier, spellEffect)
    local finalPower = super(caster, target, spell, basePower, spellGroup, tier, spellEffect)
    local entry      = meritBonusBySpell[spell:getID()]

    if entry then
        local rank = caster:getMerit(entry.merit)

        if rank > 1 then
            local power = (entry.defense or 0) + (entry.magicDmgTaken or 0) + (entry.damageReduction or 0)
            finalPower = finalPower + (rank - 1) * power
        end
    end

    return finalPower
end)

m:addOverride('xi.spells.enhancing.calculateEnhancingDuration', function(caster, target, spell, spellId, spellGroup, spellEffect)
    local duration = super(caster, target, spell, spellId, spellGroup, spellEffect)
    local entry    = meritBonusBySpell[spellId]

    if entry and entry.duration then
        local rank = caster:getMerit(entry.merit)

        if rank > 1 then
            duration = duration + (rank - 1) * entry.duration
        end
    end

    return duration
end)

return m
