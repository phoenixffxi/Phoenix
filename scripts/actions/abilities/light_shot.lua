-----------------------------------
-- Ability: Light Shot
-- Consumes a Light Card to enhance light-based debuffs. Additional effect: Light-based Sleep
-- Dia Effect: Defense Down Effect +5% and DoT + 1
-----------------------------------
---@type TAbility
local abilityObject = {}

local diaInfo =
{
    [1] = 10,
    [3] = 15,
    [5] = 20,
    [7] = 25,
    [9] = 30,
}

abilityObject.onAbilityCheck = function(player, target, ability)
    --ranged weapon/ammo: You do not have an appropriate ranged weapon equipped.
    --no card: <name> cannot perform that action.
    if
        player:getWeaponSkillType(xi.slot.RANGED) ~= xi.skill.MARKSMANSHIP or
        player:getWeaponSkillType(xi.slot.AMMO) ~= xi.skill.MARKSMANSHIP
    then
        return 216, 0
    end

    if
        player:hasItem(xi.item.LIGHT_CARD, 0) or
        player:hasItem(xi.item.TRUMP_CARD, 0)
    then
        return 0, 0
    else
        return 71, 0
    end
end

abilityObject.onUseAbility = function(player, target, ability, action)
    action:setRecast(math.max(0, action:getRecast() - player:getMod(xi.mod.QUICK_DRAW_RECAST)))
    local duration = 60
    local bonusAcc = player:getStat(xi.mod.AGI) / 2 + player:getMerit(xi.merit.QUICK_DRAW_ACCURACY) + player:getMod(xi.mod.QUICK_DRAW_MACC)
    local resist   = xi.combat.magicHitRate.calculateResistRate(player, target, 0, 0, 0, xi.element.LIGHT, 0, 0, bonusAcc)

    if resist < 0.5 then
        ability:setMsg(xi.msg.basic.JA_MISS_2) -- resist message
        return xi.effect.SLEEP_I
    end

    if target:addStatusEffect(xi.effect.SLEEP_I, { power = 1, duration = math.floor(duration * resist), origin = player }) then
        ability:setMsg(xi.msg.basic.JA_ENFEEB_IS)
    else
        ability:setMsg(xi.msg.basic.JA_NO_EFFECT_2)
    end

    local _ = player:delItem(xi.item.LIGHT_CARD, 1) or player:delItem(xi.item.TRUMP_CARD, 1)
    target:updateClaim(player)

    -- Boost dia effect
    local dia = target:getStatusEffect(xi.effect.DIA)
    if not dia then
        return xi.effect.SLEEP_I
    end

    local diaOwner    = dia:getOriginID()
    local diaPower    = dia:getPower()
    local diaSubpower = dia:getSubPower()
    local diaTier     = dia:getTier()
    local startTime   = dia:getStartTime()

    -- Already boosted
    if diaSubpower > diaInfo[diaTier] then
        return xi.effect.SLEEP_I
    end

    diaPower    = diaPower + 1
    diaSubpower = diaSubpower + math.floor(100 * 28 / 1024) -- TODO: Change ATTP, DEFP and similar mods from base 100 to base 10k

    target:delStatusEffectSilent(xi.effect.DIA)
    target:addStatusEffect(xi.effect.DIA, { power = diaPower, duration = dia:getDuration(), origin = player, tick = dia:getTick(), subType = dia:getSubType(), subPower = diaSubpower, tier = diaTier })

    local newEffect = target:getStatusEffect(xi.effect.DIA)
    if newEffect then
        newEffect:setStartTime(startTime)
        newEffect:setOriginID(diaOwner)
    end

    return xi.effect.SLEEP_I
end

return abilityObject
