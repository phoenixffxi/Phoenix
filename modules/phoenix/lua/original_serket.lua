-----------------------------------
-- Changes Serkets Model & TP Skill Animations to its original 2004 version
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('original_serket')

local skillAnimations =
{
    [xi.mobSkill.VENOM_STING_1 ] = 104,
    [xi.mobSkill.VENOM_STORM_1 ] = 107,
    [xi.mobSkill.VENOM_BREATH_1] = 101,
    [xi.mobSkill.CRITICAL_BITE ] = 103,
    [xi.mobSkill.EARTHBREAKER_1] = 108,
    [xi.mobSkill.STASIS        ] = 106,
    [xi.mobSkill.EVASION       ] = 109,
}

m:addOverride('xi.zones.Garlaige_Citadel.mobs.Serket.onMobInitialize', function(mob)
    super(mob)
    mob:setModelId(285)

    mob:addListener('WEAPONSKILL_USE', 'SERKET_WEAPONSKILL_USE', function(mobArg, target, skill, tp, action, damage)
        local targetId = target and target:getID() or nil
        if
            targetId == nil or
            skill == nil
        then
            return
        end

        local animationId = skillAnimations[skill:getID()]
        if animationId then
            action:setAnimation(targetId, animationId)
        end
    end)
end)

return m
