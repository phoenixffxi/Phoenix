-----------------------------------
-- Changes Serkets Model & TP Skill Animations to its original 2004 version
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('original_serket')

m:addOverride('xi.zones.Garlaige_Citadel.mobs.Serket.onMobInitialize', function(mob)
    xi.mob.updateNMSpawnPoint(mob)
    mob:setRespawnTime(math.random(75600, 86400))
    mob:setMobMod(xi.mobMod.GIL_MIN, 20000)
    mob:setMobMod(xi.mobMod.GIL_MAX, 20000)
    mob:setMobMod(xi.mobMod.MAGIC_COOL, 60)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.POISON)
    mob:setModelId(285)

    mob:addListener('WEAPONSKILL_USE', 'SERKET_WEAPONSKILL_USE', function(mobArg, target, skillid, tp, action)
        local targetId = target and target:getID() or nil
        if targetId == nil then
            return
        end

        if skillid == xi.mobSkill.VENOM_STING_1 then
            action:setAnimation(targetId, 104)
        elseif skillid == xi.mobSkill.VENOM_STORM_1 then
            action:setAnimation(targetId, 107)
        elseif skillid == xi.mobSkill.VENOM_BREATH_1 then
            action:setAnimation(targetId, 101)
        elseif skillid == xi.mobSkill.CRITICAL_BITE then
            action:setAnimation(targetId, 103)
        elseif skillid == xi.mobSkill.EARTHBREAKER_1 then
            action:setAnimation(targetId, 108)
        elseif skillid == xi.mobSkill.STASIS then
            action:setAnimation(targetId, 106)
        elseif skillid == xi.mobSkill.EVASION then
            action:setAnimation(targetId, 109)
        end
    end)
end)

return m
