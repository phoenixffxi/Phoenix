-----------------------------------
-- Queasyshroom (pre-WotG override)
-- Family: Funguar
-- Description: Deals physical damage to a single target. Additional Effect: Poison
-- Notes: This module reverses the changes found on the 09/08/2008 patch. https://www.bg-wiki.com/ffxi/Version_Update_(09/08/2008)
-- https://wiki.ffo.jp/html/3039.html 

-----------------------------------
require('modules/module_utils')
-----------------------------------

local moduleName = 'toau_queasyshroom'

local m = Module:new(moduleName)

-----------------------------------
-- Queasyshroom
-----------------------------------
m:addOverride('xi.actions.mobskills.queasyshroom.onMobWeaponSkill', function(mob, target, skill, action)
    local params = {}

    params.baseDamage     = mob:getWeaponDmg()
    params.numHits        = 1
    params.fTP            = { 1.5, 1.5, 1.5 }
    params.attackType     = xi.attackType.PHYSICAL
    params.damageType     = xi.damageType.PIERCING
    params.shadowBehavior  = xi.mobskills.shadowBehavior.NUMSHADOWS_1
    params.canCrit         = true
    params.criticalChance  = { 0.10, 0.20, 0.25 } -- TODO: Capture crit rate

    local info = xi.mobskills.mobPhysicalMove(mob, target, skill, action, params)

    if xi.mobskills.processDamage(mob, target, skill, action, info) then
        target:takeDamage(info.damage, mob, info.attackType, info.damageType)

        local power    = 3
        local duration = math.random(90, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, power, 3, duration)
    end

    skill:setFinalAnimationSub(1)

    return info.damage
end)

return m
