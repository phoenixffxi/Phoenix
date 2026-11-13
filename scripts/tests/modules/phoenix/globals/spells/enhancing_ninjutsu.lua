-----------------------------------
-- Era detection ninjutsu: Tonko: Ichi and Monomi: Ichi last 3 minutes, Tonko: Ni 5 minutes.
-- A data patch on the ninjutsu parameter table, so there is no override to check.
-----------------------------------

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

describe('Phoenix enhancing ninjutsu', function()
    local player

    local function expectDuration(spellId, effectId, expected)
        player:delStatusEffect(effectId)
        xi.spells.enhancing.useEnhancingNinjutsu(player, player, spellDouble(spellId))

        local effect = player:getStatusEffect(effectId)
        assert(effect, string.format('spell %d applied no effect', spellId))
        assert(effect:getDuration() == expected, string.format('spell %d: expected %d ms, got %d', spellId, expected, effect:getDuration()))
        player:delStatusEffect(effectId)
    end

    setup(function()
        player = xi.test.world:spawnPlayer({ job = xi.job.NIN, level = 75 })
    end)

    it('gives Tonko: Ichi a 3 minute Invisible', function()
        expectDuration(xi.magic.spell.TONKO_ICHI, xi.effect.INVISIBLE, 180000)
    end)

    describe('every detection spell #exhaustive', function()
        it('gives Tonko: Ni a 5 minute Invisible', function()
            expectDuration(xi.magic.spell.TONKO_NI, xi.effect.INVISIBLE, 300000)
        end)

        it('gives Monomi: Ichi a 3 minute Sneak', function()
            expectDuration(xi.magic.spell.MONOMI_ICHI, xi.effect.SNEAK, 180000)
        end)
    end)
end)
