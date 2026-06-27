-----------------------------------
-- Final Sting (pre-2013 override)
-- Family: Bee
-- Description: Deals unaspected damage proportional to mob's current HP.
-- Notes: This module reverses the changes found on the 04/29/2013 patch. https://wiki.ffo.jp/html/28857.html (wasn't in the NA patch notes, only the JP)
-- https://wiki.ffo.jp/html/6140.html
-- https://forum.square-enix.com/ffxi/threads/31553-レイヴについて?p=422397&viewfull=1#post422397 (discussion from SE community rep confirming the HP threshhold wasn't changed from 1/3rd)
-----------------------------------
require('modules/module_utils')
-----------------------------------

local moduleName = 'toau_final_sting'

local m = Module:new(moduleName)

-----------------------------------
-- Final Sting
-----------------------------------
m:addOverride('xi.actions.mobskills.final_sting.onMobSkillCheck', function(target, mob, skill)
    if mob:getHPP() <= 33 then
        return 0
    end

    return 1
end)

m:addOverride('xi.actions.mobskills.final_sting.onMobWeaponSkill', function(mob, target, skill, action)
    local params = {}

    params.baseDamage           = skill:getMobHP()
    params.fTP                  = { 1.0, 1.0, 1.0 }
    params.element              = xi.element.NONE
    params.attackType           = xi.attackType.MAGICAL
    params.damageType           = xi.damageType.NONE
    params.shadowBehavior       = xi.mobskills.shadowBehavior.IGNORE_SHADOWS
    params.skipDamageAdjustment = true
    params.skipMagicBonusDiff   = true

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, action, params)

    if xi.mobskills.processDamage(mob, target, skill, action, info) then
        target:takeDamage(info.damage, mob, info.attackType, info.damageType)
    end

    return info.damage
end)

return m
