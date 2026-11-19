-----------------------------------
-- Pre-RoV spells: lower Dia and Bio down values, one minute Dread Spikes and Drain II HP boost,
-- and 90s Absorb-STAT effects that decay every 10s.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

-- Reads go to the real spell; setters are dropped so the shared spell object is left as it was.
local function spellDouble(spellId)
    local spell = GetSpell(spellId)
    assert(spell, string.format('no spell %d', spellId))

    return setmetatable({}, {
        __index = function(_, key)
            if string.find(key, '^set') then
                return function()
                end
            end

            return function(_, ...)
                return spell[key](spell, ...)
            end
        end,
    })
end

describe('Era spell adjustments', function()
    local caster
    local target

    -- Casts a Dia or Bio spell script without its damage and returns the effect's sub power and stat change.
    local function castDownSpell(family, spellName, spellId, effectId, mod)
        target:delStatusEffect(xi.effect.DIA)
        target:delStatusEffect(xi.effect.BIO)
        local before = target:getMod(mod)

        xi.actions.spells[family][spellName].onSpellCast(caster, target, GetSpell(spellId))

        local effect = target:getStatusEffect(effectId)
        assert(effect, string.format('%s applied no effect', spellName))

        local subPower = effect:getSubPower()
        local change   = target:getMod(mod) - before
        target:delStatusEffect(effectId)

        return subPower, change
    end

    local function expectDownValue(family, spellName, spellId, effectId, mod, expected)
        local subPower, change = castDownSpell(family, spellName, spellId, effectId, mod)
        assert(subPower == expected, string.format('%s: expected sub power %d, got %d', spellName, expected, subPower))
        assert(change == -expected, string.format('%s: expected %+d, got %+d', spellName, -expected, change))
    end

    setup(function()
        caster = xi.test.world:spawnPlayer({ job = xi.job.DRK, level = 75 })
        target = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
    end)

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/actions/spells/spell_adjustments.lua', {
            targets =
            {
                'xi.actions.spells.black.absorb-str.onSpellCast',
                'xi.actions.spells.black.absorb-dex.onSpellCast',
                'xi.actions.spells.black.absorb-vit.onSpellCast',
                'xi.actions.spells.black.absorb-agi.onSpellCast',
                'xi.actions.spells.black.absorb-int.onSpellCast',
                'xi.actions.spells.black.absorb-mnd.onSpellCast',
                'xi.actions.spells.black.absorb-chr.onSpellCast',
                'xi.actions.spells.black.absorb-acc.onSpellCast',
            },
        })
    end)

    it('lowers defense by 5% with Dia', function()
        stub('xi.spells.damage.useDamageSpell', 0)
        expectDownValue('white', 'dia', xi.magic.spell.DIA, xi.effect.DIA, xi.mod.DEFP, 5)
    end)

    it('gives Dread Spikes a one minute duration', function()
        caster:delStatusEffect(xi.effect.DREAD_SPIKES)
        caster:addStatusEffect(xi.effect.DREAD_SPIKES, { power = 100, duration = 180, origin = caster })

        local spikes = caster:getStatusEffect(xi.effect.DREAD_SPIKES)
        assert(spikes, 'Dread Spikes was not applied')
        assert(spikes:getDuration() == 60000, string.format('expected 60000 ms, got %d', spikes:getDuration()))
        caster:delStatusEffect(xi.effect.DREAD_SPIKES)
    end)

    describe('every spell #exhaustive', function()
        it('lowers defense by 10% with Dia II, 15% with Dia III and 5% with Diaga', function()
            stub('xi.spells.damage.useDamageSpell', 0)
            expectDownValue('white', 'dia_ii', xi.magic.spell.DIA_II, xi.effect.DIA, xi.mod.DEFP, 10)
            expectDownValue('white', 'dia_iii', xi.magic.spell.DIA_III, xi.effect.DIA, xi.mod.DEFP, 15)
            expectDownValue('white', 'diaga', xi.magic.spell.DIAGA, xi.effect.DIA, xi.mod.DEFP, 5)
        end)

        it('lowers attack by 5% with Bio, 10% with Bio II and 15% with Bio III', function()
            stub('xi.spells.damage.useDamageSpell', 0)
            expectDownValue('black', 'bio', xi.magic.spell.BIO, xi.effect.BIO, xi.mod.ATTP, 5)
            expectDownValue('black', 'bio_ii', xi.magic.spell.BIO_II, xi.effect.BIO, xi.mod.ATTP, 10)
            expectDownValue('black', 'bio_iii', xi.magic.spell.BIO_III, xi.effect.BIO, xi.mod.ATTP, 15)
        end)

        it('gives every Absorb-STAT 90s effects that tick every 10s', function()
            stub('xi.combat.magicHitRate.calculateResistRate', 1)

            local absorbSpells =
            {
                { 'absorb-str', xi.magic.spell.ABSORB_STR, xi.effect.STR_BOOST,      xi.effect.STR_DOWN      },
                { 'absorb-dex', xi.magic.spell.ABSORB_DEX, xi.effect.DEX_BOOST,      xi.effect.DEX_DOWN      },
                { 'absorb-vit', xi.magic.spell.ABSORB_VIT, xi.effect.VIT_BOOST,      xi.effect.VIT_DOWN      },
                { 'absorb-agi', xi.magic.spell.ABSORB_AGI, xi.effect.AGI_BOOST,      xi.effect.AGI_DOWN      },
                { 'absorb-int', xi.magic.spell.ABSORB_INT, xi.effect.INT_BOOST,      xi.effect.INT_DOWN      },
                { 'absorb-mnd', xi.magic.spell.ABSORB_MND, xi.effect.MND_BOOST,      xi.effect.MND_DOWN      },
                { 'absorb-chr', xi.magic.spell.ABSORB_CHR, xi.effect.CHR_BOOST,      xi.effect.CHR_DOWN      },
                { 'absorb-acc', xi.magic.spell.ABSORB_ACC, xi.effect.ACCURACY_BOOST, xi.effect.ACCURACY_DOWN },
            }

            for _, entry in ipairs(absorbSpells) do
                xi.actions.spells.black[entry[1]].onSpellCast(caster, target, spellDouble(entry[2]))

                for _, applied in ipairs({ { caster, entry[3] }, { target, entry[4] } }) do
                    local effect = applied[1]:getStatusEffect(applied[2])
                    assert(effect, string.format('%s applied no effect %d', entry[1], applied[2]))
                    assert(effect:getDuration() == 90000, string.format('%s: effect %d expected 90000 ms, got %d', entry[1], applied[2], effect:getDuration()))
                    assert(effect:getTick() == 10000, string.format('%s: effect %d expected a 10000 ms tick, got %d', entry[1], applied[2], effect:getTick()))
                    applied[1]:delStatusEffect(applied[2])
                end
            end
        end)

        it('gives the Drain II HP boost a one minute duration', function()
            stub('xi.combat.magicHitRate.calculateResistRate', 1)
            caster:delStatusEffect(xi.effect.MAX_HP_BOOST)
            caster:setHP(caster:getMaxHP())

            xi.actions.spells.black.drain_ii.onSpellCast(caster, target, GetSpell(xi.magic.spell.DRAIN_II))
            target:setHP(target:getMaxHP())

            local boost = caster:getStatusEffect(xi.effect.MAX_HP_BOOST)
            assert(boost, 'Drain II gave no HP boost')
            assert(boost:getDuration() == 60000, string.format('expected 60000 ms, got %d', boost:getDuration()))
            caster:delStatusEffect(xi.effect.MAX_HP_BOOST)
        end)
    end)
end)
