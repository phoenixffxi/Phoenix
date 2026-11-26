-----------------------------------
-- Era bard songs: Foe Sirvente and Adventurer's Dirge come from merits only, and pre-2017 caps,
-- multipliers and skill steps for Carol, Madrigal, Mambo, March, Minne, Minuet and Prelude.
-- A data patch on the song parameter table, so there is no override to check.
-----------------------------------
---@diagnostic disable: undefined-field
local ffi = require('ffi')

-- Raises a merit through the client's merit menu packet, from the player's Mog House.
local function raiseMerit(player, merit, ranks)
    for _ = 1, ranks do
        local packet = ffi.new('uint8_t[12]')
        packet[4] = 3 -- edit mode
        packet[5] = 1 -- raise
        packet[6] = bit.band(bit.rshift(merit, 1), 0xFF)
        packet[7] = bit.rshift(merit, 9)
        player.packets:send(0x0BE, packet, ffi.sizeof(packet))
    end
end

describe('Phoenix enhancing songs', function()
    local player

    -- entry: { spellId, tier, effectId, singing skill, instrument boost, expected power }
    local function expectPower(singer, entry)
        singer:setMod(xi.mod.SINGING, entry[4])
        singer:setSkillLevel(xi.skill.SINGING, 0)
        assert(singer:getSkillLevel(xi.skill.SINGING) == entry[4], string.format('singing skill is %d, expected %d', singer:getSkillLevel(xi.skill.SINGING), entry[4]))

        local power = xi.spells.enhancing.calculateSongPower(singer, singer, GetSpell(entry[1]), entry[1], entry[2], entry[3], entry[5], true)
        assert(power == entry[6], string.format('spell %d at skill %d, boost %d: expected %d, got %s', entry[1], entry[4], entry[5], entry[6], tostring(power)))
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.BRD, level = 75 })
    end)

    it('gives Foe Sirvente no potency without merits', function()
        expectPower(player, { xi.magic.spell.FOE_SIRVENTE, 1, xi.effect.SIRVENTE, 300, 0, 0 })
    end)

    it('caps Fire Carol at 40 and adds 5 per instrument boost', function()
        expectPower(player, { xi.magic.spell.FIRE_CAROL, 1, xi.effect.CAROL, 999, 1, 45 })
    end)

    describe('every song #exhaustive', function()
        it('gives Adventurer\'s Dirge no potency without merits', function()
            expectPower(player, { xi.magic.spell.ADVENTURERS_DIRGE, 1, xi.effect.DIRGE, 300, 0, 0 })
        end)

        it('caps every song and applies its instrument multiplier', function()
            local capped =
            {
                { xi.magic.spell.ICE_CAROL,         1, xi.effect.CAROL,    999, 1,  45 },
                { xi.magic.spell.WIND_CAROL,        1, xi.effect.CAROL,    999, 1,  45 },
                { xi.magic.spell.EARTH_CAROL,       1, xi.effect.CAROL,    999, 1,  45 },
                { xi.magic.spell.LIGHTNING_CAROL,   1, xi.effect.CAROL,    999, 1,  45 },
                { xi.magic.spell.WATER_CAROL,       1, xi.effect.CAROL,    999, 1,  45 },
                { xi.magic.spell.LIGHT_CAROL,       1, xi.effect.CAROL,    999, 1,  45 },
                { xi.magic.spell.DARK_CAROL,        1, xi.effect.CAROL,    999, 1,  45 },
                { xi.magic.spell.SWORD_MADRIGAL,    1, xi.effect.MADRIGAL, 999, 1,  17 },
                { xi.magic.spell.BLADE_MADRIGAL,    2, xi.effect.MADRIGAL, 999, 1,  32 },
                { xi.magic.spell.SHEEPFOE_MAMBO,    1, xi.effect.MAMBO,    999, 1,  17 },
                { xi.magic.spell.DRAGONFOE_MAMBO,   2, xi.effect.MAMBO,    999, 1,  25 },
                { xi.magic.spell.ADVANCING_MARCH,   1, xi.effect.MARCH,    999, 1,  80 },
                { xi.magic.spell.VICTORY_MARCH,     2, xi.effect.MARCH,    999, 1, 112 },
                { xi.magic.spell.KNIGHTS_MINNE,     1, xi.effect.MINNE,    999, 1,  15 },
                { xi.magic.spell.KNIGHTS_MINNE_II,  2, xi.effect.MINNE,    999, 1,  29 },
                { xi.magic.spell.KNIGHTS_MINNE_III, 3, xi.effect.MINNE,    999, 1,  42 },
                { xi.magic.spell.KNIGHTS_MINNE_IV,  4, xi.effect.MINNE,    999, 1,  50 },
                { xi.magic.spell.VALOR_MINUET,      1, xi.effect.MINUET,   999, 1,  18 },
                { xi.magic.spell.VALOR_MINUET_II,   2, xi.effect.MINUET,   999, 1,  34 },
                { xi.magic.spell.VALOR_MINUET_III,  3, xi.effect.MINUET,   999, 1,  50 },
                { xi.magic.spell.VALOR_MINUET_IV,   4, xi.effect.MINUET,   999, 1,  58 },
                { xi.magic.spell.HUNTERS_PRELUDE,   1, xi.effect.PRELUDE,  999, 1,  17 },
                { xi.magic.spell.ARCHERS_PRELUDE,   2, xi.effect.PRELUDE,  999, 1,  32 },
            }

            for _, entry in ipairs(capped) do
                expectPower(player, entry)
            end
        end)

        it('starts Victory March, the Minnes and Valor Minuet IV from their era base', function()
            local bases =
            {
                { xi.magic.spell.VICTORY_MARCH,     2, xi.effect.MARCH,  0, 0, 53 },
                { xi.magic.spell.KNIGHTS_MINNE,     1, xi.effect.MINNE,  0, 0,  5 },
                { xi.magic.spell.KNIGHTS_MINNE_II,  2, xi.effect.MINNE,  0, 0,  6 },
                { xi.magic.spell.KNIGHTS_MINNE_III, 3, xi.effect.MINNE,  0, 0, 10 },
                { xi.magic.spell.KNIGHTS_MINNE_IV,  4, xi.effect.MINNE,  0, 0, 12 },
                { xi.magic.spell.VALOR_MINUET_IV,   4, xi.effect.MINUET, 0, 0, 29 },
            }

            for _, entry in ipairs(bases) do
                expectPower(player, entry)
            end
        end)

        it('steps Sword Madrigal, Knight\'s Minne and the first two Minuets by their era skill divisors', function()
            local steps =
            {
                { xi.magic.spell.SWORD_MADRIGAL,  1, xi.effect.MADRIGAL, 140, 0,  9 },
                { xi.magic.spell.KNIGHTS_MINNE,   1, xi.effect.MINNE,    100, 0, 11 },
                { xi.magic.spell.VALOR_MINUET,    1, xi.effect.MINUET,   110, 0, 15 },
                { xi.magic.spell.VALOR_MINUET_II, 2, xi.effect.MINUET,   145, 0, 20 },
            }

            for _, entry in ipairs(steps) do
                expectPower(player, entry)
            end
        end)

        it('gives Foe Sirvente 5 and Adventurer\'s Dirge 3 per merit rank', function()
            local bard = xi.test.world:spawnPlayer({ zone = xi.zone.WINDURST_WOODS, job = xi.job.BRD, level = 75 })
            bard:gotoMogHouse(xi.zone.WINDURST_WOODS)
            if bard:isInEvent() then
                bard.events:finish()
            end

            bard:setMerits(30)
            raiseMerit(bard, xi.merit.FOE_SIRVENTE, 2)
            raiseMerit(bard, xi.merit.ADVENTURERS_DIRGE, 3)

            expectPower(bard, { xi.magic.spell.FOE_SIRVENTE, 1, xi.effect.SIRVENTE, 300, 0, 10 })
            expectPower(bard, { xi.magic.spell.ADVENTURERS_DIRGE, 1, xi.effect.DIRGE, 300, 0, 9 })
        end)
    end)
end)
