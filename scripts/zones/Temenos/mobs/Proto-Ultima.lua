-----------------------------------
-- Area: Temenos
--  Mob: Proto-Ultima
-----------------------------------
local ID = zones[xi.zone.TEMENOS]
-----------------------------------
---@type TMobEntity
local entity = {}

-----------------------------------
-- Draw In Handler
-----------------------------------
local function handleDrawIn(mob, target)
    local center = { x = -560.000, y = 5.000, z = -360.000 }

    -- Early return: Distance from center check & distance from target check.
    if
        target:checkDistance(center.x, center.y, center.z) <= 35 and
        mob:checkDistance(target) < 10
    then
        return
    end

    -----------------------------------
    -- Draw in the target to the mob
    -----------------------------------
    mob:drawIn(target, 0, 0, mob:getPos())
end

-----------------------------------
-- Helper function to cast Holy II on a random player in range.
-----------------------------------
local function castHoly(mob)
    local battlefield = mob:getBattlefield()
    if not battlefield then
        return
    end

    local players = battlefield:getPlayers()
    if not players then
        return
    end

    local holyTargets = {}

    for _, player in pairs(players) do
        local distance = player and mob:checkDistance(player)
        if player and player:isAlive() and distance and distance <= 20 then
            table.insert(holyTargets, player)
        end
    end

    if #holyTargets == 0 then
        return
    end

    mob:castSpell(xi.magic.spell.HOLY_II, holyTargets[math.random(1, #holyTargets)])
end

-----------------------------------
-- Message table for Citadel Buster
-----------------------------------
local countdownTable =
{
    [1] = { 30, ID.text.CITADEL_30 },
    [2] = { 20, ID.text.CITADEL_20 },
    [3] = { 10, ID.text.CITADEL_10 },
    [4] = {  5, ID.text.CITADEL_5  },
    [5] = {  4, ID.text.CITADEL_4  },
    [6] = {  3, ID.text.CITADEL_3  },
    [7] = {  2, ID.text.CITADEL_2  },
    [8] = {  1, ID.text.CITADEL_1  },
}

-----------------------------------
-- Skill lists for each phase. Proto-Ultima will use one of these skills at random, or a follow up Breath Attack if Nuclear Waste was used in the previous skill.
-----------------------------------
local skillTable =
{
    -- 100 - 80% HP
    [1] =
    {
        xi.mobSkill.WIRE_CUTTER,
        xi.mobSkill.CHEMICAL_BOMB,
        xi.mobSkill.ANTIMATTER,
    },

    -- 80 - 60% HP
    [2] =
    {
        xi.mobSkill.WIRE_CUTTER,
        xi.mobSkill.CHEMICAL_BOMB,
        xi.mobSkill.NUCLEAR_WASTE,
    },

    -- 60 - 40% HP
    [3] =
    {
        xi.mobSkill.EQUALIZER,
        xi.mobSkill.NUCLEAR_WASTE,
        xi.mobSkill.ANTIMATTER,
    },

    -- 40 - 20% HP
    [4] =
    {
        xi.mobSkill.EQUALIZER,
        xi.mobSkill.ANTIMATTER,
        xi.mobSkill.ARMOR_BUSTER,
        xi.mobSkill.MANA_SCREEN,
        xi.mobSkill.ENERGY_SCREEN,
    },
}

-- 20% - 0% HP
local finalPhaseSkills =
{
    [1] = xi.mobSkill.CITADEL_BUSTER,
    [2] = xi.mobSkill.ENERGY_SCREEN,
    [3] = xi.mobSkill.CITADEL_BUSTER,
    [4] = xi.mobSkill.MANA_SCREEN,
}

-- Follow up Breath Attacks to use after Nuclear Waste
local elementalBreaths =
{
    [1] = xi.mobSkill.FLAME_THROWER,
    [2] = xi.mobSkill.CRYO_JET,
    [3] = xi.mobSkill.TURBOFAN,
    [4] = xi.mobSkill.SMOKE_DISCHARGER,
    [5] = xi.mobSkill.HIGH_TENSION_DISCHARGER,
    [6] = xi.mobSkill.HYDRO_CANON
}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.SILENCE)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

entity.onMobSpawn = function(mob)
    mob:setMagicCastingEnabled(false)
    mob:setMobAbilityEnabled(true)
    mob:setAutoAttackEnabled(true)
    mob:setMod(xi.mod.REGAIN, 50)
    mob:setMod(xi.mod.UDMGMAGIC, -5000)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 250)
    mob:setMod(xi.mod.POWER_MULTIPLIER_SPELL, 100)
    mob:setLocalVar('phase', 1) -- Phase variable to determine which skill list to use.
    mob:setLocalVar('skillIndex', 1) -- Skill index variable for use in the final phase, which has a scripted skill rotation.
    mob:setLocalVar('nextSkillTime', 0) -- Variable to track when the mob should use its next skill in the final phase.
    mob:setLocalVar('nextHolyTime', 0) -- Variable to track when the mob should cast Holy II next.
    mob:setLocalVar('nextDetonateTime', 0) -- Variable to track when the Citadel Buster detonation will occur after being used in the final phase.
    mob:setLocalVar('messageText', 0) -- Variable to track which Citadel Buster countdown messages have been displayed, using bits to track each message.
    mob:setLocalVar('nuclearWasteUsed', 0) -- Variable to track if Nuclear Waste was used in the previous skill.
end

entity.onMobFight = function(mob, target)
    if target then
        handleDrawIn(mob, target)
    end

    if xi.combat.behavior.isEntityBusy(mob) then
        return
    end

    local hpp          = mob:getHPP()
    local phase        = mob:getLocalVar('phase')
    local currentTime  = GetSystemTime()
    local nextHolyTime = mob:getLocalVar('nextHolyTime')

    switch (phase): caseof
    {
        [1] = function()
            if hpp <= 80 then
                mob:useMobAbility(xi.mobSkill.DISSIPATION)
                mob:setLocalVar('phase', 2)
            end
        end,

        [2] = function()
            if hpp <= 60 then
                mob:useMobAbility(xi.mobSkill.DISSIPATION)
                mob:setLocalVar('phase', 3)
            end
        end,

        [3] = function()
            if currentTime >= nextHolyTime then
                castHoly(mob)
                mob:setLocalVar('nextHolyTime', currentTime + math.random(50, 60))
            end

            if hpp <= 40 then
                mob:useMobAbility(xi.mobSkill.DISSIPATION)
                mob:setLocalVar('phase', 4)
            end
        end,

        [4] = function()
            if currentTime >= nextHolyTime then
                castHoly(mob)
                mob:setLocalVar('nextHolyTime', currentTime + math.random(20, 30))
            end

            if hpp <= 20 then
                mob:useMobAbility(xi.mobSkill.DISSIPATION)
                mob:setLocalVar('phase', 5)
                mob:setLocalVar('nextSkillTime', currentTime + math.random(15, 30))
                mob:setMobAbilityEnabled(false)
            end
        end,

        [5] = function()
            local nextDetonateTime = mob:getLocalVar('nextDetonateTime')
            local messageText      = mob:getLocalVar('messageText')
            local skillIndex       = mob:getLocalVar('skillIndex')
            local nextSkillTime    = mob:getLocalVar('nextSkillTime')

            -- If it's time to cast Holy II, do so first, we can also cast Holy II during the Citadel Buster countdown.
            if currentTime >= nextHolyTime then
                castHoly(mob)
                mob:setLocalVar('nextHolyTime', currentTime + math.random(20, 30))
            end

            -- If Citadel Buster is counting down, prevent skill use and display messages at the appropriate intervals. Otherwise, use skills from the final phase skill list every 30 to 85 seconds.
            if nextDetonateTime ~= 0 then
                local timeRemaining = nextDetonateTime - currentTime

                for countdownIndex = 1, #countdownTable do
                    if
                        timeRemaining <= countdownTable[countdownIndex][1] and
                        not utils.mask.getBit(messageText, countdownIndex)
                    then
                        messageText = messageText + bit.lshift(1, countdownIndex)
                        mob:setLocalVar('messageText', messageText)
                        mob:messageText(mob, countdownTable[countdownIndex][2], false)
                        break
                    end
                end

                -- If the countdown has reached 0, reset variables and use Citadel Buster
                if currentTime >= nextDetonateTime then
                    mob:setLocalVar('nextDetonateTime', 0)
                    mob:setLocalVar('messageText', 0)
                    mob:setLocalVar('nextSkillTime', currentTime + math.random(30, 45))
                    mob:useMobAbility(xi.mobSkill.CITADEL_BUSTER)
                    mob:setMobMod(xi.mobMod.NO_MOVE, 0)
                    mob:setAutoAttackEnabled(true)
                end

                return
            end

            -- If it's not time to use the next skill in the rotation, do nothing.
            if currentTime < nextSkillTime then
                return
            end

            -- If the next skill in the rotation is Citadel Buster, set nextDetonateTime so that the countdown can begin. Otherwise, use the skill.
            local skillToUse = finalPhaseSkills[skillIndex]

            if skillToUse == xi.mobSkill.CITADEL_BUSTER then
                mob:setMobMod(xi.mobMod.NO_MOVE, 1)
                mob:setAutoAttackEnabled(false)
                mob:setLocalVar('nextDetonateTime', currentTime + 30)
                mob:setLocalVar('messageText', 0)
                return
            end

            -- Set the next skill time for 30 to 45 seconds in the future and use the skill.
            mob:setLocalVar('nextSkillTime', currentTime + math.random(30, 45))
            mob:useMobAbility(skillToUse)
        end,
    }
end

entity.onMobMobskillChoose = function(mob, target, skillId)
    local phase = mob:getLocalVar('phase')

    -- If we're in the final phase, skill use becomes scripted, so we return 0 here.
    if phase == 5 then
        return 0
    end

    local nuclearWasteUsed = mob:getLocalVar('nuclearWasteUsed')

    -- If Nuclear Waste was used in the previous skill, use a follow up Breath Attack. Otherwise, use a random skill from the current phase skill list.
    local phaseSkills = skillTable[phase]
    if nuclearWasteUsed == 1 then
        mob:setLocalVar('nuclearWasteUsed', 0)
        return elementalBreaths[math.random(1, #elementalBreaths)]
    end

    return phaseSkills[math.random(1, #phaseSkills)]
end

entity.onMobWeaponSkill = function(mob, target, skill, action)
    local skillId = skill:getID()
    local phase = mob:getLocalVar('phase')

    -- If Nuclear Waste was used, set a local variable so that the next skill will be a follow up Breath Attack
    if skillId == xi.mobSkill.NUCLEAR_WASTE then
        mob:setLocalVar('nuclearWasteUsed', 1)
    end

    -- If we're in the final phase, skill use becomes scripted, so we advance the skill index using modulo to loop back to the 1 if needed.
    if phase == 5 then
        local skillIndex = mob:getLocalVar('skillIndex')

        local expectedSkill = finalPhaseSkills[skillIndex]
        if skillId == expectedSkill then
            local nextIndex = (skillIndex % #finalPhaseSkills) + 1
            mob:setLocalVar('skillIndex', nextIndex)
        end
    end
end

entity.onMobDeath = function(mob, player, optParams)
    if player then
        player:addTitle(xi.title.TEMENOS_LIBERATOR)
    end
end

return entity
