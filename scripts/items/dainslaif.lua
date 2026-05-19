-----------------------------------
-- ID: 17651
-- Item: Dainslaif
-- Additional effect: en-drain
-----------------------------------
---@type TItem
local itemObject = {}

itemObject.onItemAdditionalEffect = function(attacker, defender, baseAttackDamage, item)
    local pTable =
    {
        chance          = 22, -- Observed rate is 21% which is close to (0.22 * .95) = 21%~ (resist roll failure)
        basePower       = 72,
        attackType      = xi.attackType.PHYSICAL,
        physicalElement = xi.damageType.SLASHING,
        magicalElement  = xi.element.DARK,
        canResist       = true,
        lowestResist    = 0.5,
        limitUndead     = true,
        drainHP         = true,
        animation       = xi.subEffect.DARKNESS_DAMAGE,
    }

    return xi.combat.action.executeAddEffectDamage(attacker, defender, pTable)
end

return itemObject
