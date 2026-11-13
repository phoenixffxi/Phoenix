-----------------------------------
-- Automaton attachments as they were before Abyssea: era modifier values, and attachments that
-- consume their maneuvers instead of adding burden.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

local modulePath = 'modules/era/lua/actions/abilities/pets/automaton/attachments.lua'

-- The last listener registered for this event in the log.
local function listenerFor(trace, event)
    local listener
    for _, args in ipairs(moduleTest.callsTo(trace, 'pet:addListener')) do
        if args[1] == event then
            listener = args[3]
        end
    end

    assert(listener, string.format('no %s listener was added', event))

    return listener
end

local attachments = xi.actions.abilities.pets.attachments
local abilities   = xi.actions.abilities.pets.automaton

describe('Era automaton attachments', function()
    it('applies its overrides', function()
        moduleTest.assertOverridesApplied(modulePath)
    end)

    it('gives Strobe its era enmity values', function()
        local strobe = xi.automaton.attachmentModifiers['strobe'][1]

        assert(strobe.modifier == xi.mod.ENMITY, string.format('expected an enmity modifier, got %s', strobe.modifier))
        assert(strobe.values[1] == 5 and strobe.values[2] == 15 and strobe.values[3] == 25 and strobe.values[4] == 40, string.format('expected 5 / 15 / 25 / 40, got %s / %s / %s / %s', strobe.values[1], strobe.values[2], strobe.values[3], strobe.values[4]))
    end)

    it('cuts an analyzed skill by 10% plus 10% per Earth Maneuver', function()
        local trace  = {}
        local master = moduleTest.standIn(trace, 'master', { countEffect = 1, hasStatusEffect = false })
        local actor  = moduleTest.standIn(trace, 'automaton', { getMod = 1, getID = 2, getMaster = master, getLocalVar = 100 })
        local damage = utils.handleAutomatonAutoAnalyzer(actor, moduleTest.standIn(trace, 'skill', { getID = 100 }), 1000)

        assert(damage == 800, string.format('expected 800 damage, got %s', damage))
    end)

    describe('every changed attachment #exhaustive', function()
        it('sets the era attachment modifier values', function()
            local modifiers = xi.automaton.attachmentModifiers

            assert(modifiers['armor_plate'][1].modifier == xi.mod.DEFP, 'Armor Plate: expected a defense bonus')
            assert(modifiers['armor_plate_ii'][1].values[4] == 35, 'Armor Plate II: expected 35% defense at 3 maneuvers')
            assert(modifiers['turbo_charger'][1].modifier == xi.mod.HASTE_GEAR, 'Turbo Charger: expected gear haste')
            assert(modifiers['drum_magazine'][2].modifier == xi.mod.RACC and modifiers['drum_magazine'][2].values[4] == -75, 'Drum Magazine: expected -75 ranged accuracy at 3 maneuvers')
            assert(modifiers['tactical_processor'][2].modifier == xi.mod.OVERLOAD_THRESH, 'Tactical Processor: expected burden')
            assert(modifiers['mana_booster'][1].modifier == xi.mod.AUTO_MAGIC_COOLDOWN, 'Mana Booster: expected a magic cooldown reduction')
            assert(modifiers['inhibitor'][1].values[4] == 20, 'Inhibitor: expected 20 Store TP at 3 maneuvers')
            assert(modifiers['heatsink'][1].values[4] == 1, 'Heatsink: expected 1 burden decay at 3 maneuvers')
            assert(modifiers['steam_jacket'][1].values[4] == 60, 'Steam Jacket: expected 60 at 3 maneuvers')
            assert(modifiers['volt_gun'][1].values[4] == 0, 'Volt Gun: expected no potency scaling')
            assert(xi.automaton.repairKit.data['auto-repair_kit_ii'].regenMultiplier[4] == 0.8, 'Auto-Repair Kit II: expected 0.8 regen multiplier at 3 maneuvers')
            assert(xi.automaton.manaTank.data['mana_tank'].refreshMultiplier[4] == 0, 'Mana Tank: expected no level scaling')
            assert(xi.automaton.manaTank.data['mana_tank_ii'].refreshMultiplier[4] == 0, 'Mana Tank II: expected no level scaling')
        end)

        it('consumes every Fire Maneuver when a weapon skill lands with Flame Holder', function()
            local trace = {}
            stub('xi.automaton.onAttachmentEquip', function()
            end)

            attachments.flame_holder.onEquip(moduleTest.standIn(trace, 'pet', {}), nil)

            local master = moduleTest.standIn(trace, 'master', { countEffect = 2 })
            listenerFor(trace, 'WEAPONSKILL_STATE_EXIT')(moduleTest.standIn(trace, 'automaton', { getMaster = master }), xi.mobSkill.DAZE_AUTOMATON, true)

            local removed = moduleTest.callsTo(trace, 'master:delStatusEffectSilent')
            assert(#removed == 2, string.format('expected two maneuvers removed, got %d', #removed))
            assert(removed[1][1] == xi.effect.FIRE_MANEUVER, string.format('expected Fire Maneuver removed, got %s', removed[1][1]))
            assert(#moduleTest.callsTo(trace, 'master:addBurden') == 0, 'expected no burden')
        end)

        it('consumes every Ice Maneuver when an elemental spell is cast with Ice Maker', function()
            local trace = {}
            stub('xi.automaton.onAttachmentEquip', function()
            end)

            attachments.ice_maker.onEquip(moduleTest.standIn(trace, 'pet', {}), nil)

            local master = moduleTest.standIn(trace, 'master', { countEffect = 3 })
            local spell  = moduleTest.standIn(trace, 'spell', { getID = xi.magic.spell.BLIZZARD_III })
            listenerFor(trace, 'MAGIC_USE')(moduleTest.standIn(trace, 'automaton', { getMaster = master }), nil, spell, nil)

            local removed = moduleTest.callsTo(trace, 'master:delStatusEffectSilent')
            assert(#removed == 3, string.format('expected three maneuvers removed, got %d', #removed))
            assert(removed[1][1] == xi.effect.ICE_MANEUVER, string.format('expected Ice Maneuver removed, got %s', removed[1][1]))
            assert(#moduleTest.callsTo(trace, 'master:addBurden') == 0, 'expected no burden')
        end)

        it('gives Blink from Replicator and consumes the Wind Maneuvers', function()
            local trace  = {}
            local master = moduleTest.standIn(trace, 'master', { countEffect = 2, hasStatusEffect = false })
            local target = moduleTest.standIn(trace, 'target', { addStatusEffect = true })

            abilities.replicator.onAutomatonAbility(target, moduleTest.standIn(trace, 'automaton', {}), moduleTest.standIn(trace, 'skill', { getID = 0 }), master, nil)

            local effects = moduleTest.callsTo(trace, 'target:addStatusEffect')
            assert(#effects == 1, string.format('expected one effect, got %d', #effects))
            assert(effects[1][1] == xi.effect.BLINK, string.format('expected Blink, got %s', effects[1][1]))
            assert(effects[1][2].power == 3, string.format('expected 3 shadows, got %s', effects[1][2].power))
            assert(#moduleTest.callsTo(trace, 'master:delStatusEffectSilent') == 2, 'expected both Wind Maneuvers removed')
        end)

        it('gives a flat 100 Stoneskin from Shock Absorber', function()
            local trace  = {}
            local target = moduleTest.standIn(trace, 'target', { addStatusEffect = true })
            local master = moduleTest.standIn(trace, 'master', { countEffect = 3 })

            abilities.shock_absorber.onAutomatonAbility(target, moduleTest.standIn(trace, 'automaton', { getSkillLevel = 200, hasAttachmentSet = true }), moduleTest.standIn(trace, 'skill', { getID = 0 }), master, nil)

            local effects = moduleTest.callsTo(trace, 'target:addStatusEffect')
            assert(#effects == 1, string.format('expected one effect, got %d', #effects))
            assert(effects[1][1] == xi.effect.STONESKIN, string.format('expected Stoneskin, got %s', effects[1][1]))
            assert(effects[1][2].power == 100, string.format('expected 100 Stoneskin, got %s', effects[1][2].power))
        end)

        it('gives Shield Bash with Hammermill no guaranteed hit and an Overdrive-aware Slow', function()
            local trace = {}
            local captured
            stub('xi.mobskills.mobPhysicalMove', function(_, _, _, _, params)
                captured = params

                return { damage = 0, hybridDamage = 0, hitsLanded = 1, attackType = params.attackType, damageType = params.damageType }
            end)

            stub('xi.mobskills.processDamage', true)
            stub('xi.mobskills.mobStatusEffectMove', function()
            end)

            stub('xi.combat.action.executeMobskillStatusEffect', function(_, _, _, effectData)
                table.insert(trace, { name = 'executeMobskillStatusEffect', args = { effectData } })
            end)

            local automaton = moduleTest.standIn(trace, 'automaton', {
                getWeaponDmg     = 41,
                hasAttachmentSet = true,
                getMod           = function(modId)
                    if modId == xi.mod.AUTO_SHIELD_BASH_SLOW then
                        return 1
                    end

                    return 0
                end,
            })

            local master = moduleTest.standIn(trace, 'master', {
                countEffect     = 1,
                hasStatusEffect = function(effectId)
                    return effectId == xi.effect.OVERDRIVE
                end,
            })

            abilities.shield_bash.onAutomatonAbility(moduleTest.standIn(trace, 'target', {}), automaton, moduleTest.standIn(trace, 'skill', { getID = 0 }), master, nil)

            assert(captured, 'Shield Bash passed no params')
            assert(captured.guaranteedFirstHit == nil, 'expected no guaranteed first hit')

            local slows = moduleTest.callsTo(trace, 'executeMobskillStatusEffect')
            assert(#slows == 1, string.format('expected one Slow, got %d', #slows))
            assert(slows[1][1][1].tier == 6, string.format('expected tier 6 Slow under Overdrive, got %s', slows[1][1][1].tier))
        end)

        it('makes Analyzer remember one skill and ignore maneuvers', function()
            local trace = {}
            local hooks = 0
            stub('xi.automaton.onAttachmentEquip', function()
            end)

            stub('xi.automaton.onManeuverGain', function()
                hooks = hooks + 1
            end)

            stub('xi.automaton.onManeuverLose', function()
                hooks = hooks + 1
            end)

            stub('xi.automaton.updateAttachmentModifier', function()
                hooks = hooks + 1
            end)

            attachments.analyzer.onEquip(moduleTest.standIn(trace, 'pet', {}), nil)
            assert(#moduleTest.callsTo(trace, 'pet:setLocalVar') == 1, string.format('expected one remembered skill reset, got %d', #moduleTest.callsTo(trace, 'pet:setLocalVar')))

            local target = moduleTest.standIn(trace, 'target', { getMod = 3, getLocalVar = 0 })
            listenerFor(trace, 'WEAPONSKILL_TAKE')(nil, target, moduleTest.standIn(trace, 'skill', { getID = 100 }), 1000, nil)

            local remembered = moduleTest.callsTo(trace, 'target:setLocalVar')
            assert(#remembered == 1, string.format('expected one remembered skill, got %d', #remembered))
            assert(remembered[1][1] == 'analyzedSkill1' and remembered[1][2] == 100, 'expected skill 100 in the first slot')

            attachments.analyzer.onManeuverGain(nil, nil, 1)
            attachments.analyzer.onManeuverLose(nil, nil, 0)
            attachments.analyzer.onUpdate(nil, nil, 1)
            assert(hooks == 0, string.format('expected the maneuver hooks to do nothing, got %d calls', hooks))
        end)

        it('consumes every maneuver with Eraser', function()
            local trace  = {}
            local master = moduleTest.standIn(trace, 'master', { countEffect = 2, hasStatusEffect = false })
            local target = moduleTest.standIn(trace, 'target', { hasStatusEffect = true })

            local removed = abilities.eraser.onAutomatonAbility(target, moduleTest.standIn(trace, 'automaton', {}), moduleTest.standIn(trace, 'skill', { getID = 0 }), master, nil)
            assert(removed == 2, string.format('expected two effects removed, got %s', removed))

            local darkRemoved = 0
            for _, args in ipairs(moduleTest.callsTo(trace, 'master:delStatusEffectSilent')) do
                if args[1] == xi.effect.DARK_MANEUVER then
                    darkRemoved = darkRemoved + 1
                end
            end

            assert(darkRemoved == 2, string.format('expected both Dark Maneuvers removed, got %d', darkRemoved))
            assert(#moduleTest.callsTo(trace, 'master:addBurden') == 0, 'expected no burden')
        end)

        it('needs a Dark Maneuver for Economizer and consumes them for MP', function()
            local trace         = {}
            local darkManeuvers = 0
            local master        = moduleTest.standIn(trace, 'master', {
                countEffect = function()
                    return darkManeuvers
                end,
            })

            local automaton = moduleTest.standIn(trace, 'automaton', {
                hasRecast = false,
                getMaster = master,
                getMaxMP  = 100,
                getMPP    = 10,
                addMP     = function(amount)
                    return amount
                end,
            })

            attachments.economizer.onEquip(moduleTest.standIn(trace, 'pet', {}))
            listenerFor(trace, 'AUTOMATON_ATTACHMENT_CHECK')(automaton, nil)
            assert(#moduleTest.callsTo(trace, 'automaton:useMobAbility') == 0, 'expected no Economizer without a Dark Maneuver')

            darkManeuvers = 2
            local recovered = abilities.economizer.onAutomatonAbility(nil, automaton, moduleTest.standIn(trace, 'skill', { getID = 0 }), master, nil)
            assert(recovered == 40, string.format('expected 40 MP, got %s', recovered))
            assert(#moduleTest.callsTo(trace, 'master:delStatusEffectSilent') == 2, 'expected both Dark Maneuvers removed')
            assert(#moduleTest.callsTo(trace, 'master:addBurden') == 0, 'expected no burden')
        end)
    end)
end)
