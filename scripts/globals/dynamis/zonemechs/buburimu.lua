-- Dynamis Buburimu Mob Information and Mechanics
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- -----------------
-- Apoc Beast Code
-- -----------------
local paths =
{
    {
        -- West Side
        -- It must start at the top
        -- Go to the end
        -- Reverse back to the start
        { x = -227, y = -21, z = 99  }, -- Starting point
        { x = -236, y = -21, z = 100 },
        { x = -254, y = -21, z = 99  },
        { x = -272, y = -21, z = 100 },
        { x = -285, y = -21, z = 98  },
        { x = -295, y = -21, z = 93  },
        { x = -299, y = -21, z = 80  },
        { x = -300, y = -20, z = 55  },
        { x = -300, y = -21, z = 35  },
        { x = -310, y = -21, z = 22  },
        { x = -336, y = -21, z = 21  },
        { x = -361, y = -22, z = 17  },
        { x = -378, y = -25, z = 18  },
        { x = -397, y = -29, z = 20  },
        { x = -433, y = -29, z = 20  },
        { x = -449, y = -29, z = 22  },
        { x = -458, y = -30, z = 31  },
        { x = -461, y = -30, z = 46  },
        { x = -470, y = -29, z = 57  },
        { x = -493, y = -29, z = 58  },
        { x = -513, y = -30, z = 61  },
        { x = -536, y = -31, z = 75  }, -- End point
    },
    {
        -- East to crossroads 1
        -- If it hits crossraods 1
        -- It can either go south or east to crossroads 2
        { x = -227, y = -21, z = 99  }, -- Starting point
        { x = -210, y = -21, z = 99  },
        { x = -188, y = -21, z = 100 },
        { x = -163, y = -21, z = 100 },
        { x = -149, y = -21, z = 96  },
        { x = -141, y = -22, z = 88  },
        { x = -138, y = -22, z = 72  },
        { x = -130, y = -21, z = 64  },
        { x = -115, y = -21, z = 60  },
        { x = -101, y = -18, z = 57  },
        { x =  -82, y = -13, z = 59  },
        { x =  -64, y = -12, z = 59  },
        { x =  -51, y = -13, z = 61  },
        { x =  -32, y = -13, z = 60  },
        { x =  -23, y = -13, z = 58  }, -- Crossroads 1
    },
    {
        -- South of crossroads 1
        -- It must hit the end and come back
        { x = -23, y = -13, z = 58  }, -- Crossroads 1
        { x = -20, y = -13, z = 43  },
        { x = -20, y = -14, z = 32  },
        { x = -18, y = -12, z = 16  },
        { x = -20, y = -13, z = -4  },
        { x = -23, y =  -9, z = -20  },
        { x = -19, y =  -6, z = -47  },
        { x = -11, y =  -5, z = -57  },
        { x =   1, y =  -6, z = -60  },
        { x =  12, y =  -5, z = -64  },
        { x =  19, y =  -6, z = -72  },
        { x =  21, y =  -6, z = -87  },
        { x =  27, y =  -5, z = -95  },
        { x =  39, y =  -6, z = -100  },
        { x =  51, y =  -4, z = -100  },
        { x =  64, y =  -1, z = -102  },
        { x =  77, y =   2, z = -101  },
        { x =  97, y =   3, z = -101  },
        { x = 123, y =   2, z = -100  }, -- End near entrance
    },
    {
        -- East of Crossroads 1 to Crossroads 2
        -- It can either go north or south from here
        { x = -23, y = -13, z = 58  }, -- Crossroads 1
        { x =  -3, y = -14, z = 60  },
        { x =  15, y = -13, z = 59  },
        { x =  24, y = -13, z = 62  },
        { x =  43, y = -14, z = 60  },
        { x =  58, y = -10, z = 58  },
        { x =  74, y =  -6, z = 59  },
        { x =  87, y =  -6, z = 59  },
        { x =  95, y =  -6, z = 52  },
        { x =  98, y =  -6, z = 43  },
        { x = 101, y =  -6, z = 32  },
        { x = 107, y =  -5, z = 25  },
        { x = 116, y =  -6, z = 21  },
        { x = 127, y =  -6, z = 20  },
        { x = 138, y =  -5, z = 19  },
        { x = 150, y =  -5, z = 21  },
        { x = 163, y =  -6, z = 19  },
        { x = 175, y =  -5, z = 19  },
        { x = 185, y =  -5, z = 21  },
        { x = 197, y =  -6, z = 20  },
        { x = 210, y =  -6, z = 21  },
        { x = 217, y =  -5, z = 20  },
        { x = 231, y =  -6, z = 19  },
        { x = 243, y =  -6, z = 20  },
        { x = 256, y =  -3, z = 22  },
        { x = 268, y =   1, z = 22  },
        { x = 281, y =   2, z = 20  },
        { x = 297, y =   3, z = 17  }, -- Crossroads 2
    },
    {
        -- Crossraods 2 -> North
        -- It must return back to crossroads 2
        -- It can either go back west or go south
        { x = 297, y = 3, z = 17 }, -- Crossroads 2
        { x = 299, y = 2, z = 29 },
        { x = 301, y = 2, z = 46 },
        { x = 302, y = 3, z = 54 },
        { x = 299, y = 3, z = 65 },
        { x = 300, y = 2, z = 80 },
        { x = 302, y = 2, z = 100 }, -- End
    },
    {
        -- Crossroads 2 -> South
        -- It must go to the end and reverse back to crossroads 2
        { x = 297, y = 3, z = 17 }, -- Crossroads 2
        { x = 301, y = 2, z = 10 },
        { x = 300, y = 2, z = 2 },
        { x = 298, y = 3, z = -12 },
        { x = 302, y = 3, z = -25 },
        { x = 300, y = 2, z = -38 },
        { x = 303, y = 2, z = -51 },
        { x = 310, y = 3, z = -57 },
        { x = 320, y = 2, z = -59 },
        { x = 336, y = 3, z = -59 },
        { x = 345, y = 3, z = -62 },
        { x = 357, y = 2, z = -60 },
        { x = 366, y = 2, z = -61 },
        { x = 374, y = 3, z = -67 },
        { x = 378, y = 2, z = -72 },
        { x = 380, y = 2, z = -79 },
        { x = 379, y = 3, z = -90 },
        { x = 380, y = 3, z = -98 },
        { x = 382, y = 3, z = -104 },
        { x = 380, y = 2, z = -114 },
        { x = 381, y = 2, z = -126 },
        { x = 381, y = 3, z = -134 },
        { x = 378, y = 3, z = -145 },
        { x = 380, y = 2, z = -157 },
        { x = 379, y = 2, z = -167 },
        { x = 380, y = 3, z = -177 },
        { x = 381, y = 2, z = -192 },
        { x = 380, y = 2, z = -200 },
        { x = 382, y = 2, z = -208 },
        { x = 386, y = 3, z = -214 },
        { x = 392, y = 2, z = -218 },
        { x = 397, y = 2, z = -219 },
        { x = 408, y = 2, z = -221 },
        { x = 423, y = 3, z = -219 },
        { x = 434, y = 2, z = -220 },
        { x = 445, y = 2, z = -221 },
        { x = 456, y = 3, z = -221 },
        { x = 466, y = 2, z = -219 },
        { x = 487, y = 2, z = -222 },
        { x = 497, y = 3, z = -228 },
        { x = 499, y = 2, z = -235 },
        { x = 501, y = 2, z = -246 },
        { x = 505, y = 3, z = -253 },
        { x = 511, y = 3, z = -258 },
        { x = 517, y = 2, z = -259 },
        { x = 528, y = 2, z = -260 },
        { x = 538, y = 2, z = -262 }, -- End
    }
}

local reverseFlag = bit.bor(xi.path.flag.COORDS, xi.path.flag.REVERSE)
local forwardFlag = xi.path.flag.COORDS

local function checkPathDistance(mob, point)
    return mob:checkDistance(unpack(point))
end

local function isNearPoint(mob, point)
    return checkPathDistance(mob, point) < 5
end

local function pathThrough(mob, pathIndex, reverse)
    local flags = reverse and reverseFlag or forwardFlag
    mob:pathThrough(paths[pathIndex], flags)
end

local function setNextPath(mob)
    local path1First = xi.path.first(paths[1])
    local path1Last  = xi.path.last(paths[1])
    local path2Last  = xi.path.last(paths[2])
    local path3Last  = xi.path.last(paths[3])
    local path4Last  = xi.path.last(paths[4])
    local path5Last  = xi.path.last(paths[5])
    local path6Last  = xi.path.last(paths[6])

    -- If it hits the end of path 1, needs to path back
    if isNearPoint(mob, path1Last) then
        pathThrough(mob, 1, true)
    -- If it hits the end of path 2 or the end of path 1
    -- Pick 1 or 2
    elseif isNearPoint(mob, path1First) then
        local pathToUse = math.random(1, 2)
        pathThrough(mob, pathToUse, false)
    -- If it hits the end of path 2, pick path 2 or 3
    elseif isNearPoint(mob, path2Last) then
        local pathToUse = math.random(2, 4)
        pathThrough(mob, pathToUse, pathToUse == 2)
    -- If it hits the end of path 3, it must reverse back on path 3
    elseif isNearPoint(mob, path3Last) then
        pathThrough(mob, 3, true)
    -- If it hits the end of path 4, it can pick path 4, 5, or 6
    elseif isNearPoint(mob, path4Last) then
        local pathToUse = math.random(4, 6)
        pathThrough(mob, pathToUse, pathToUse == 4)
    -- If it hits the end of path 5, it must reverse back on path 5
    elseif isNearPoint(mob, path5Last) then
        pathThrough(mob, 5, true)
    -- If it hits the end of path 6, it must reverse back on path 6
    elseif isNearPoint(mob, path6Last) then
        pathThrough(mob, 6, true)
    end

    -- If it deaggros we need to find a path
    if not mob:isFollowingPath() then
        local mobPos = mob:getPos()
        if mobPos.x < -240 then
            pathThrough(mob, 1, false)
        elseif mobPos.x < -120 then
            pathThrough(mob, 2, false)
        elseif mobPos.x < 20 then
            pathThrough(mob, 2, true)
        elseif mobPos.x < 150 then
            pathThrough(mob, 4, false)
        else
            pathThrough(mob, 1, false)
        end
    end
end

-- Clears all 2hr status effects before applying the next one, then restores auto-attack/abilities
-- Must be called before useMobAbility, otherwise effects stack (e.g. Chainspell + Manafont spamming -ga 3s)
local function apocRemoveAdditionalEffects(mob)
    local statusEffects =
    {
        xi.effect.MIGHTY_STRIKES,
        xi.effect.HUNDRED_FISTS,
        xi.effect.MANAFONT,
        xi.effect.CHAINSPELL,
        xi.effect.PERFECT_DODGE,
        xi.effect.INVINCIBLE,
        xi.effect.BLOOD_WEAPON,
        xi.effect.SOUL_VOICE,
        xi.effect.MEIKYO_SHISUI,
        xi.effect.ASTRAL_FLOW,
    }

    for _, effect in pairs(statusEffects) do
        if mob:hasStatusEffect(effect) then
            mob:delStatusEffect(effect)
        end
    end

    mob:setAutoAttackEnabled(true)
    mob:setMobAbilityEnabled(mob:getLocalVar('abilitiesEnabled') == 1)
    mob:clearActionQueue()
end

local apocAbilities = -- Setup 2hr Lockouts
{
    { '[DYNA]BloodspillerKilled' , xi.mobSkill.MIGHTY_STRIKES_1 }, -- WAR
    { '[DYNA]HamfistKilled'      , xi.mobSkill.HUNDRED_FISTS_1  }, -- MNK
    { '[DYNA]FleshfeasterKilled' , xi.mobSkill.BENEDICTION_1    }, -- WHM
    { '[DYNA]FlamecallerKilled'  , xi.mobSkill.MANAFONT_1       }, -- BLM
    { '[DYNA]GosspixKilled'      , xi.mobSkill.CHAINSPELL_1     }, -- RDM
    { '[DYNA]BodysnatcherKilled' , xi.mobSkill.PERFECT_DODGE_1  }, -- THF
    { '[DYNA]IroncladKilled'     , xi.mobSkill.INVINCIBLE_1     }, -- PLD
    { '[DYNA]ShamblixKilled'     , xi.mobSkill.BLOOD_WEAPON_1   }, -- DRK
    { '[DYNA]WoodnixKilled'      , xi.mobSkill.CHARM            }, -- BST
    { '[DYNA]MelomanicKilled'    , xi.mobSkill.SOUL_VOICE_1     }, -- BRD
    { '[DYNA]LynceanKilled'      , xi.mobSkill.EES_GOBLIN       }, -- RNG
    { '[DYNA]LevinbladeKilled'   , xi.mobSkill.MEIKYO_SHISUI_1  }, -- SAM
    { '[DYNA]FleetfootKilled'    , xi.mobSkill.MIJIN_GAKURE_1   }, -- NIN
    { '[DYNA]ElvaanstickerKilled', xi.mobSkill.CALL_WYVERN_1    }, -- DRG
    { '[DYNA]BibliophageKilled'  , xi.mobSkill.ASTRAL_FLOW_1    }, -- SMN
}

local apocWeaponskillLockouts =
{
    { xi.bubu.mobs.STIHI,        '[DYNA]StihiKilled',       642 }, -- Flame Breath
    { xi.bubu.mobs.VISHAP,       '[DYNA]VishapKilled',      643 }, -- Poison Breath
    { xi.bubu.mobs.JURIK,        '[DYNA]JurikKilled',       644 }, -- Wind Breath
    { xi.bubu.mobs.BARONG,       '[DYNA]BarongKilled',      645 }, -- Body Slam
    { xi.bubu.mobs.TARASCA,      '[DYNA]TarascaKilled',     646 }, -- Heavy Stomp
    { xi.bubu.mobs.ALKHLA,       '[DYNA]AlkhlaKilled',      647 }, -- Chaos Blade
    { xi.bubu.mobs.BASILIC,      '[DYNA]BasilicKilled',     648 }, -- Petro Eyes
    { xi.bubu.mobs.AITVARAS,     '[DYNA]AitvarasKilled',    649 }, -- Voidsong
    { xi.bubu.mobs.KOSCHEI,      '[DYNA]KoscheiKilled',     650 }, -- Thornsong
    { xi.bubu.mobs.STOLLEN_WURM, '[DYNA]StollenWurmKilled', 651 }, -- Lodesong
}

-- Returns the subset of apocAbilities whose lockout NM has not been killed yet
local function getAvailable2hrs(mob)
    local list = {}
    for _, entry in ipairs(apocAbilities) do
        if mob:getZone():getLocalVar(entry[1]) ~= 1 then
            table.insert(list, entry[2])
        end
    end

    return list
end

xi.dynamis.onApocSpawn = function(mob)
    mob:addImmunity(xi.immunity.GRAVITY)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.SILENCE)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)

    mob:setMod(xi.mod.DARK_RES_RANK, 11)
    mob:setMod(xi.mod.BIND_RES_RANK, 9)

    mob:setMod(xi.mod.REGAIN, 50)  -- 'minor level of regain'
    mob:setMod(xi.mod.REFRESH, 250)
    mob:setMod(xi.mod.MACC, 200)
    mob:setMod(xi.mod.MATT, 50)
    mob:setMod(xi.mod.FASTCAST, 50)

    mob:setMobMod(xi.mobMod.MAGIC_COOL, 15)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)

    mob:setBaseSpeed(78)
    mob:setDelay(150)

    mob:setBehavior(bit.bor(mob:getBehavior(), xi.behavior.NO_TURN))

    -- Start pathing
    local pickPath = math.random(1, 2)
    mob:pathThrough(paths[pickPath], xi.path.flag.COORDS)
    mob:setPos(-227, -21, 99) -- Just in case
    mob:setLocalVar('currentPath', 1) -- Skip regular roam code
end

xi.dynamis.onApocEngage = function(mob, target)
    mob:setLocalVar('next2hrTime', GetSystemTime() + 5) -- First 2hr fires 5 seconds after engage
    mob:setLocalVar('2hrIndex', 0)

    -- If all dragon NMs have been defeated, weapon skills are disabled for this fight
    local defeatedDragons = 0
    for _, entry in ipairs(apocWeaponskillLockouts) do
        if mob:getZone():getLocalVar(entry[2]) == 1 then
            defeatedDragons = defeatedDragons + 1
        end
    end

    local abilitiesEnabled = defeatedDragons < #apocWeaponskillLockouts
    mob:setLocalVar('abilitiesEnabled', abilitiesEnabled and 1 or 0)
    if not abilitiesEnabled then
        mob:setMobAbilityEnabled(false)
    end
end

xi.dynamis.onApocFight = function(mob, target)
    -- Cycle through 2hr abilities in order, skipping any locked out by NM kills
    if mob:getLocalVar('next2hrTime') <= GetSystemTime() then
        local available2hrs = getAvailable2hrs(mob)
        if #available2hrs > 0 then
            local index = mob:getLocalVar('2hrIndex') % #available2hrs + 1
            apocRemoveAdditionalEffects(mob)
            mob:useMobAbility(available2hrs[index])
            mob:setLocalVar('2hrIndex', index)
            mob:setLocalVar('next2hrTime', GetSystemTime() + math.random(30, 45))
        end
    end

    -- Magic is only enabled during 2hr effects (Manafont, Chainspell, Soul Voice)
    local magicActive =
        mob:hasStatusEffect(xi.effect.MANAFONT) or
        mob:hasStatusEffect(xi.effect.CHAINSPELL) or
        mob:hasStatusEffect(xi.effect.SOUL_VOICE)

    mob:setMagicCastingEnabled(magicActive)
end

-- Picks the spell list based on two hour effect
xi.dynamis.onApocSpellChoose = function(mob, target, spellId)
    local apocSpellList =
    {
        -- Manafont
        {
            [1] = { xi.magic.spell.FIRAGA_III,   target, false, xi.action.type.DAMAGE_TARGET, nil, 0, 100 },
            [2] = { xi.magic.spell.BLIZZAGA_III, target, false, xi.action.type.DAMAGE_TARGET, nil, 0, 100 },
            [3] = { xi.magic.spell.AEROGA_III,   target, false, xi.action.type.DAMAGE_TARGET, nil, 0, 100 },
            [4] = { xi.magic.spell.STONEGA_III,  target, false, xi.action.type.DAMAGE_TARGET, nil, 0, 100 },
            [5] = { xi.magic.spell.THUNDAGA_III, target, false, xi.action.type.DAMAGE_TARGET, nil, 0, 100 },
            [6] = { xi.magic.spell.WATERGA_III,  target, false, xi.action.type.DAMAGE_TARGET, nil, 0, 100 },
        },
        -- Chainspell
        {
            [1] = { xi.magic.spell.BLINDGA,    target, false, xi.action.type.ENFEEBLING_TARGET, xi.effect.BLINDNESS,     0, 100 },
            [2] = { xi.magic.spell.PARALYGA,   target, false, xi.action.type.ENFEEBLING_TARGET, xi.effect.PARALYSIS,     0, 100 },
            [3] = { xi.magic.spell.BINDGA,     target, false, xi.action.type.ENFEEBLING_TARGET, xi.effect.BIND,          0, 100 },
            [4] = { xi.magic.spell.BREAKGA,    target, false, xi.action.type.ENFEEBLING_TARGET, xi.effect.PETRIFICATION, 0, 100 },
            [5] = { xi.magic.spell.SLEEPGA_II, target, false, xi.action.type.ENFEEBLING_TARGET, xi.effect.SLEEP_I,       0, 100 },
            [6] = { xi.magic.spell.DEATH,      target, false, xi.action.type.DAMAGE_TARGET,     nil,                     0, 100 },
        },
        -- Soul Voice
        {
            { xi.magic.spell.HORDE_LULLABY,     target, false, xi.action.type.ENFEEBLING_TARGET,    xi.effect.SLEEP_I,  0, 100 },
            { xi.magic.spell.MAGIC_FINALE,      target, false, xi.action.type.NONE,                 nil,                0,  50 },
            { xi.magic.spell.VALOR_MINUET_IV,   mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.MINUET,   0, 100 },
            { xi.magic.spell.VICTORY_MARCH,     mob,    false, xi.action.type.ENHANCING_FORCE_SELF, xi.effect.MARCH,    0, 100 },
            { xi.magic.spell.BLADE_MADRIGAL,    target, false, xi.action.type.ENHANCING_TARGET,     xi.effect.MADRIGAL, 0,  50 },
            -- xi.magic.spell.MASSACRE_ELEGY
        },
    }

    local spellList = { }
    if mob:hasStatusEffect(xi.effect.MANAFONT) then
        spellList = apocSpellList[1]
    elseif mob:hasStatusEffect(xi.effect.CHAINSPELL) then
        spellList = apocSpellList[2]
    elseif mob:hasStatusEffect(xi.effect.SOUL_VOICE) then
        spellList = apocSpellList[3]
    else
        return nil -- No 2hr active
    end

    return spellList[math.random(1, #spellList)]
end

xi.dynamis.onApocMobskillChoose = function(mob, target, skillId)
    local available = {}
    for _, abilities in ipairs(apocWeaponskillLockouts) do
        if mob:getZone():getLocalVar(abilities[2]) ~= 1 then
            table.insert(available, abilities[3])
        end
    end

    if #available == 0 then
        return nil
    end

    return available[math.random(1, #available)]
end

xi.dynamis.onApocRoam = function(mob)
    if not mob:isFollowingPath() then
        setNextPath(mob)
    end
end

-- -----------------
-- Dragon NMs
-- -----------------
xi.dynamis.onSpawnBubuDragon = function(mob)
    local mobId = mob:getID()
    for _, entry in ipairs(apocWeaponskillLockouts) do
        if entry[1] == mobId then
            -- Setting special skill
            -- Dragons do auto attack. Cooldown is guessed
            mob:setMobMod(xi.mobMod.SPECIAL_SKILL, entry[3])
            mob:setMobMod(xi.mobMod.SPECIAL_COOL, 15)
            break
        end
    end

    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)

    mob:addImmunity(xi.immunity.GRAVITY)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.SILENCE)

    mob:setBaseSpeed(60) -- 34% movement speed

    mob:setBehavior(bit.bor(mob:getBehavior(), xi.behavior.NO_TURN))

    -- Values are approximated based on era accounts
    if mob:getID() == 16941256 then -- Aitvaras
        mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 200)
        mob:setMod(xi.mod.ATT, 550)
        mob:setMod(xi.mod.UDMGMAGIC, -4000) -- Capture shows reduced magic damage (estimated)
    end
end

xi.dynamis.onFightDragon = function(mob, target)
    if mob:getZone():getLocalVar('[DYNA]MegaBossKilled') == 1 then
        mob:setMobMod(xi.mobMod.NO_DROPS, 1)
        DespawnMob(mob:getID())
    end
end

xi.dynamis.onRoamDragon = function(mob)
    if mob:getZone():getLocalVar('[DYNA]MegaBossKilled') == 1 then
        mob:setMobMod(xi.mobMod.NO_DROPS, 1)
        DespawnMob(mob:getID())
    end
end
