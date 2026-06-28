-----------------------------------
-- Leaf Dagger (pre-WotG override)
-- Family: Mandragora
-- Description: Deals piercing damage to a single target. Additional Effect: Poison
-- Notes: This module reverses the changes found on the 09/08/2008 patch.
-- Poison potency is flat 1/tick (no level scaling), duration is 115-180 seconds,
-- vs. the modern level-scaled potency / flat 90-second duration.
-- TODO: Should be subject to ranged penalties.
-----------------------------------
require('modules/module_utils')
-----------------------------------

local moduleName = 'toau_leaf_dagger'

if xi.module.isContentEnabled('TOAU') then
    return { name = moduleName }
end

local m = Module:new(moduleName)

-----------------------------------
-- Leaf Dagger
-----------------------------------
m:addOverride('xi.actions.mobskills.leaf_dagger.onMobWeaponSkill', function(mob, target, skill, action)
    local params = {}

    params.baseDamage     = mob:getWeaponDmg()
    params.numHits        = 1
    params.fTP            = { 2.0, 2.0, 2.0 }
    params.attackType     = xi.attackType.PHYSICAL
    params.damageType     = xi.damageType.PIERCING
    params.shadowBehavior = xi.mobskills.shadowBehavior.NUMSHADOWS_1
    params.skipParry      = true
    params.skipGuard      = true
    params.skipBlock      = true

    local info = xi.mobskills.mobRangedMove(mob, target, skill, action, params)

    if xi.mobskills.processDamage(mob, target, skill, action, info) then
        target:takeDamage(info.damage, mob, info.attackType, info.damageType)

        local power    = 1
        local duration = math.random(115, 180)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, power, 3, duration)
    end

    return info.damage
end)

return m
