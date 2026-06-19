-----------------------------------
-- Avatar Global Functions
-----------------------------------
xi = xi or {}
xi.summon = xi.summon or {}

local trialSizeBattles = set{
    xi.battlefield.id.TRIAL_SIZE_TRIAL_BY_WIND,
    xi.battlefield.id.TRIAL_SIZE_TRIAL_BY_LIGHTNING,
    xi.battlefield.id.TRIAL_SIZE_TRIAL_BY_ICE,
    xi.battlefield.id.TRIAL_SIZE_TRIAL_BY_FIRE,
    xi.battlefield.id.TRIAL_SIZE_TRIAL_BY_EARTH,
    xi.battlefield.id.TRIAL_SIZE_TRIAL_BY_WATER,
}

-- Checks if the summoner is in a Trial Size Avatar Mini Fight (only carbuncle is allowed)
xi.summon.avatarMiniFightCheck = function(caster, spellID)
    local result = 0
    local effect = caster:getStatusEffect(xi.effect.BATTLEFIELD)
    if spellID ~= xi.magic.spell.CARBUNCLE and effect then
        local bcnmid = effect:getPower()
        if trialSizeBattles[bcnmid] then -- Mini Avatar Fights
            result = 40 -- Cannot use <spell> in this area.
        end
    end

    return result
end
