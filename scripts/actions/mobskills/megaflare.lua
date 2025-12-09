-----------------------------------
-- Megaflare
-- Family: Bahamut
-- Description: Deals heavy Fire damage to enemies within a fan-shaped area.
-- Notes: Used by Bahamut every 10% of its HP (except at 10%), but can use at will when under 10%.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    local mobhp = mob:getHPP()

    -- TODO: Handle this in mobscripts?
    if
        mobhp <= 10 and
        mob:getLocalVar('GigaFlare') ~= 0 -- make sure Gigaflare has happened first - don't want a random Megaflare to block it.
    then
        mob:setLocalVar('MegaFlareQueue', 1) -- set up Megaflare for being called by the script again.
    end

    return 1
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl()
    params.fTP             = { 10, 10, 10 }
    params.element         = xi.element.FIRE
    params.dStatMultiplier = 1.5

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, params)

    -- Targets that are not the primary target take 300 less damage.
    if
        target:getID() ~= skill:getPrimaryTargetID() and
        info.damage > 0 -- Damage was not nullified or absorbed.
    then
        info.damage = math.max(0, info.damage - 300)
    end

    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    end

    -- TODO: Handle this in mob scripts instead.
    mob:setLocalVar('MegaFlareQueue', mob:getLocalVar('MegaFlareQueue') - 1)
    mob:setLocalVar('FlareWait', 0) -- reset the variables for Megaflare.
    mob:setLocalVar('tauntShown', 0)
    mob:setMobAbilityEnabled(true) -- re-enable the other actions on success
    mob:setMagicCastingEnabled(true)
    mob:setAutoAttackEnabled(true)

    if bit.band(mob:getBehavior(), xi.behavior.NO_TURN) == 0 then -- re-enable noturn
        mob:setBehavior(bit.bor(mob:getBehavior(), xi.behavior.NO_TURN))
    end

    return damage
end

return mobskillObject
