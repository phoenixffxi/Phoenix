-----------------------------------
-- Guild Master Rank Cap (Removes the prompt for players to go past Veteran Rank)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/hobbies/crafting/guild_master')
-----------------------------------
local m = Module:new('guild_master_rank_cap')

-- Set only while a guild master handles the player.
local capAtVeteran = false

local function setVeteranAsTopRank(func, player, npc, trade)
    capAtVeteran = true
    func(player, npc, trade)
    capAtVeteran = false
end

m:addOverride('xi.crafting.getCraftSkillCap', function(target, skillId)
    if
        capAtVeteran and
        target:getSkillRank(skillId) >= xi.craftRank.VETERAN
    then
        return 110
    end

    return super(target, skillId)
end)

m:addOverride('xi.crafting.guildMasterOnTrigger', function(player, npc)
    setVeteranAsTopRank(super, player, npc)
end)

m:addOverride('xi.crafting.guildMasterOnTrade', function(player, npc, trade)
    setVeteranAsTopRank(super, player, npc, trade)
end)

return m
