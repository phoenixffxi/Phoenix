-----------------------------------
-- Plague Breath (pre-WotG override)
-- Family: Lizard
-- Description: Deals water damage to enemies within a fan-shaped area originating from the caster. Additional Effect: Poison.
-- Notes: This module reverses the changes found on the 09/08/2008 patch. https://www.bg-wiki.com/ffxi/Version_Update_(09/08/2008)
-- https://wiki.ffo.jp/html/11687.html 
-----------------------------------
require('modules/module_utils')
-----------------------------------

local moduleName = 'toau_plague_breath'

local m = Module:new(moduleName)

-----------------------------------
-- Plague Breath
-----------------------------------
m:addOverride('xi.actions.mobskills.plague_breath.onMobWeaponSkill', function(mob, target, skill, action)
    local params = {}

    params.percentMultipier = 0.0625
    params.damageCap        = 500
    params.bonusDamage      = 0
    params.mAccuracyBonus   = { 0, 0, 0 }
    params.resistStat       = xi.mod.INT
    params.element          = xi.element.WATER
    params.attackType       = xi.attackType.BREATH
    params.damageType       = xi.damageType.WATER
    params.shadowBehavior   = xi.mobskills.shadowBehavior.IGNORE_SHADOWS

    local info = xi.mobskills.mobBreathMove(mob, target, skill, action, params)

    if xi.mobskills.processDamage(mob, target, skill, action, info) then
        target:takeDamage(info.damage, mob, info.attackType, info.damageType)

        local power    = 3
        local duration = math.random(90, 120)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, power, 3, duration)
    end

    return info.damage
end)

return m
