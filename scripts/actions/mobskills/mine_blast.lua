-----------------------------------
-- Mine Blast
-- Family: Mines (Qiqirn Mine / Goblin Mine)
-- Description: AOE: Varies. 16' for Goblin Bombs in [S].
-- TODO: Behavior of mines varies, we may eventually want to split up to multiple files once captures are made.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 100, 100, 100 } -- TODO: Capture fTPs. (Varies by mob)
    params.element    = xi.element.FIRE

    -- TODO: Cheese Hoarder Gigiroon Mines

    -- TODO: Qiqirn Mines

    -- TODO: Goblin mines in [S] zones

    -- TODO: Excavation Duty Assault

    -- TODO: Blifnix Oilycheek's Goblin Mines

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    end

    -- TODO: Move this to a mob mixin that utilizes a listener. If noone is hit by the skill, this condition will never be reached.
    -- mob:entityAnimationPacket('mai1') -- Animation: Mine jumps up and explodes.
    -- mob:setHP(0)

    return damage
end

return mobskillObject
