-----------------------------------
-- Barrage
-- Family : Humanoid Job Ability
-- Description : Allows the next ranged attack to fire multiple shots at once.
-- Number of shots fired is determined by the power of the effect.
-- 4 shots at Lv. 30, 5 shots at Lv. 60, 6 shots at Lv. 75 and 7 shots at Lv. 90.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(mob, target, skill, action)
    action:setCategory(xi.action.category.JOBABILITY_FINISH)

    local level = mob:getMainLvl()
    local projectileCount
    if level >= 90 then
        projectileCount = 7
    elseif level >= 75 then
        projectileCount = 6
    elseif level >= 60 then
        projectileCount = 5
    elseif level >= 30 then
        projectileCount = 4
    else
        projectileCount = 3
    end

    mob:addStatusEffect(xi.effect.BARRAGE, { power = projectileCount, duration = 60, origin = mob })

    skill:setMsg(xi.msg.basic.USES)

    return xi.effect.BARRAGE
end

return mobskillObject
