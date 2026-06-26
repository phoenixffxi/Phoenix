-----------------------------------
-- Area: Temenos
--  Mob: Proto-Ultima
-----------------------------------
local ID = zones[xi.zone.TEMENOS]
-----------------------------------
---@type TMobEntity
local entity = {}

local arenaCenter = { x = -560.000, y = 5.000, z = -360.000 }

-- Draw in handler, doesn't let you get any further than the top of the ramps.
local function handleDrawIn(mob, target)
    local distanceToCenter = target:checkDistance(arenaCenter.x, arenaCenter.y, arenaCenter.z)
    local distanceToMob    = mob:checkDistance(target)

    if
        distanceToCenter <= 36 and
        distanceToMob < 10
    then
        return
    end

    local pos = mob:getPos()
    pos.y = pos.y + 3
    mob:drawIn(target, 0, 0, pos)
end

-- Handler to cast Holy on a random player within 20 yalms.
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

    for _, player in ipairs(players) do
        if player:isAlive() and mob:checkDistance(player) <= 20 then
            table.insert(holyTargets, player)
        end
    end

    if #holyTargets == 0 then
        return
    end

    mob:castSpell(xi.magic.spell.HOLY_II, holyTargets[math.random(1, #holyTargets)])
end

-- Table with the countdown times for Citadel Buster, uses a bitmask to track which messages have been sent.
local citadelBusterCountdown =
{
    [1] = 30,
    [2] = 20,
    [3] = 10,
    [4] =  5,
    [5] =  4,
    [6] =  3,
    [7] =  2,
    [8] =  1,
}

-- Skill list by phase - last phase is a scripted rotation, handled in onMobFight.
local skillTable =
{
    -- 100% - 80% HP
    [1] =
    {
        xi.mobSkill.WIRE_CUTTER,
        xi.mobSkill.CHEMICAL_BOMB,
        xi.mobSkill.ANTIMATTER,
    },

    -- 80% - 60% HP
    [2] =
    {
        xi.mobSkill.WIRE_CUTTER,
        xi.mobSkill.CHEMICAL_BOMB,
        xi.mobSkill.NUCLEAR_WASTE,
    },

    -- 60% - 40% HP
    [3] =
    {
        xi.mobSkill.EQUALIZER,
        xi.mobSkill.NUCLEAR_WASTE,
        xi.mobSkill.ANTIMATTER,
    },

    -- 40% - 20% HP
    [4] =
    {
        xi.mobSkill.EQUALIZER,
        xi.mobSkill.ANTIMATTER,
        xi.mobSkill.ARMOR_BUSTER,
        xi.mobSkill.MANA_SCREEN,
        xi.mobSkill.ENERGY_SCREEN,
    },
}

-- 20% - 0% HP: scripted rotation
local finalPhaseSkills =
{
    xi.mobSkill.CITADEL_BUSTER,
    xi.mobSkill.ENERGY_SCREEN,
    xi.mobSkill.CITADEL_BUSTER,
    xi.mobSkill.MANA_SCREEN,
}

-- Elemental breaths, used after Nuclear Waste.
local elementalBreaths =
{
    xi.mobSkill.FLAME_THROWER,
    xi.mobSkill.CRYO_JET,
    xi.mobSkill.TURBOFAN,
    xi.mobSkill.SMOKE_DISCHARGER,
    xi.mobSkill.HIGH_TENSION_DISCHARGER,
    xi.mobSkill.HYDRO_CANON,
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
    mob:setMod(xi.mod.UDMGMAGIC, -3000)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 250)
    mob:setMod(xi.mod.POWER_MULTIPLIER_SPELL, 100)
    mob:setLocalVar('phase', 1)
    mob:setLocalVar('skillIndex', 1)
    mob:setLocalVar('nextSkillTime', 0)
    mob:setLocalVar('nextHolyTime', 0)
    mob:setLocalVar('nextDetonateTime', 0)
    mob:setLocalVar('nuclearWasteUsed', 0)
end

entity.onMobFight = function(mob, target)
    if target then
        handleDrawIn(mob, target)
    end

    if xi.combat.behavior.isEntityBusy(mob) then
        return
    end

    local hpp         = mob:getHPP()
    local phase       = mob:getLocalVar('phase')
    local currentTime = GetSystemTime()

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
            if hpp <= 40 then
                mob:useMobAbility(xi.mobSkill.DISSIPATION)
                mob:setLocalVar('phase', 4)
                mob:setLocalVar('nextHolyTime', currentTime + math.random(20, 30))
            else
                local nextHolyTime = mob:getLocalVar('nextHolyTime')
                if currentTime >= nextHolyTime then
                    castHoly(mob)
                    mob:setLocalVar('nextHolyTime', currentTime + math.random(50, 60))
                end
            end
        end,

        [4] = function()
            if hpp <= 20 then
                mob:useMobAbility(xi.mobSkill.DISSIPATION)
                mob:setLocalVar('phase', 5)
                mob:setLocalVar('nextSkillTime', currentTime + math.random(15, 30))
            else
                local nextHolyTime = mob:getLocalVar('nextHolyTime')
                if currentTime >= nextHolyTime then
                    castHoly(mob)
                    mob:setLocalVar('nextHolyTime', currentTime + math.random(20, 30))
                end
            end
        end,

        [5] = function()
            local nextHolyTime = mob:getLocalVar('nextHolyTime')
            if currentTime >= nextHolyTime then
                castHoly(mob)
                mob:setLocalVar('nextHolyTime', currentTime + math.random(20, 30))
            end

            local nextDetonateTime = mob:getLocalVar('nextDetonateTime')

            if nextDetonateTime ~= 0 then
                local timeRemaining = nextDetonateTime - currentTime
                local citadelBit    = mob:getLocalVar('citadelBit')

                for i = 1, #citadelBusterCountdown do
                    if
                        timeRemaining <= citadelBusterCountdown[i] and
                        not utils.mask.getBit(citadelBit, i)
                    then
                        citadelBit = bit.bor(citadelBit, bit.lshift(1, i))
                        mob:setLocalVar('citadelBit', citadelBit)
                        mob:messageText(mob, ID.text.CITADEL_30 + i - 1, false)
                        break
                    end
                end

                if currentTime >= nextDetonateTime then
                    mob:setTP(0)
                    mob:setLocalVar('nextDetonateTime', 0)
                    mob:setLocalVar('nextSkillTime', currentTime + math.random(30, 45))
                    mob:useMobAbility(xi.mobSkill.CITADEL_BUSTER)
                    mob:setBaseSpeed(40)
                    mob:setAutoAttackEnabled(true)
                    mob:setMobAbilityEnabled(true)
                end

                return
            end

            local nextSkillTime = mob:getLocalVar('nextSkillTime')
            if currentTime < nextSkillTime then
                return
            end

            local skillIndex = mob:getLocalVar('skillIndex')
            local skillToUse = finalPhaseSkills[skillIndex]

            if skillToUse == xi.mobSkill.CITADEL_BUSTER then
                mob:setBaseSpeed(0)
                mob:setAutoAttackEnabled(false)
                mob:setMobAbilityEnabled(false)
                mob:setLocalVar('nextDetonateTime', currentTime + 30)
                mob:setLocalVar('citadelBit', 0)
                return
            end

            mob:setLocalVar('nextSkillTime', currentTime + math.random(30, 45))
            mob:useMobAbility(skillToUse)
        end,
    }
end

entity.onMobMobskillChoose = function(mob, target, skillId)
    local phase = mob:getLocalVar('phase')

    -- Armor Buster is the only non-scripted skill used in phase 5.
    if phase == 5 then
        return xi.mobSkill.ARMOR_BUSTER
    end

    local nuclearWasteUsed = mob:getLocalVar('nuclearWasteUsed')

    -- If Nuclear Waste was used, the next skill will be an elemental breath.
    if nuclearWasteUsed == 1 then
        mob:setLocalVar('nuclearWasteUsed', 0)
        return elementalBreaths[math.random(1, #elementalBreaths)]
    end

    -- Return a random skill from the skill table for the current phase.
    local phaseSkills = skillTable[phase]
    return phaseSkills[math.random(1, #phaseSkills)]
end

-- Tracks if Nuclear Waste was used, to determine if next ability should be a elemental breath.
-- During phase 5, tracks the skill scripted skill rotation, looping it back to 1 with modulo.
entity.onMobWeaponSkill = function(mob, target, skill, action)
    local skillId = skill:getID()

    if skillId == xi.mobSkill.NUCLEAR_WASTE then
        mob:setLocalVar('nuclearWasteUsed', 1)
    end

    if mob:getLocalVar('phase') == 5 then
        local skillIndex    = mob:getLocalVar('skillIndex')
        local expectedSkill = finalPhaseSkills[skillIndex]

        if skillId == expectedSkill then
            mob:setLocalVar('skillIndex', (skillIndex % #finalPhaseSkills) + 1)
        end
    end
end

entity.onMobDeath = function(mob, player, optParams)
    if player then
        player:addTitle(xi.title.TEMENOS_LIBERATOR)
    end
end

return entity
