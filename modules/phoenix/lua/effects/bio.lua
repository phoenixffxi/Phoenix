-----------------------------------
-- Module: Bio III: DoT duration scales directly with merit rank.
-- Source: https://forum.square-enix.com/ffxi/threads/55751-August.-6-2019-%28JST%29-Version-Update
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('bio_effect_adjustments')

m:addOverride('xi.effects.bio.onEffectGain', function(target, effect)
    super(target, effect)

    if effect:getTier() == 6 then
        local caster = GetPlayerByID(effect:getOriginID())

        if caster then
            effect:setDuration(caster:getMerit(xi.merit.BIO_III) * 30 * 1000)
        end
    end
end)

return m
