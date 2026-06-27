-----------------------------------
-- Poison Breath (pre-WotG override)
-- Family: Crawler
-- Description: Deals Water damage to enemies within a fan-shaped area originating from the caster. Additional Effect: Poison.
-- Notes: This module reverses the changes found on the 09/08/2008 patch. https://www.bg-wiki.com/ffxi/Version_Update_(09/08/2008)
-- https://web.archive.org/web/20070000000000*/https://wiki.ffo.jp/html/3052.html
-----------------------------------
require('modules/module_utils')
-----------------------------------

local moduleName = 'toau_poison_breath_crawler'

local m = Module:new(moduleName)

-----------------------------------
-- Poison Breath
-----------------------------------
m:addOverride('xi.actions.mobskills.poison_breath_crawler.onMobWeaponSkill', function(mob, target, skill, action)
    local params = {}

    params.percentMultipier = 0.103
    params.damageCap        = 405
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

        local power    = 1
        local duration = math.random(200, 300)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, power, 3, duration)
    end

    return info.damage
end)

return m
