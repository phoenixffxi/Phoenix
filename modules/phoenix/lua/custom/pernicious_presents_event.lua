-----------------------------------
-- Pernicious Presents: Twinkling Treant world event
-- Treants spawn in 12 outdoor zones. Outpost teleportation is disabled until every treant is defeated.
--
-- Participation: talk to a Moogle in an event zone for a menu to select whether or not to get level capped
-----------------------------------
require('modules/module_utils')
require('scripts/globals/conquest')
-----------------------------------
local m = Module:new('pernicious_presents_event')

xi.treantEvent = {}

xi.treantEvent.capSubType  = 0x1EAF -- Pick a random treant subtype for the event
xi.treantEvent.capDuration = 3600
local swapInterval         = 3660 -- Move roughly once an hour

xi.treantEvent.zones =
{
    [xi.zone.WEST_RONFAURE] =
    {
        zone    = 'West Ronfaure',
        cap     = 20,
        level   = 25,
        hp      = 200000,
        treant  =
        {
            { x = -205.957, y = -29.763, z = -78.954,  rot = 140 }, -- 1
            { x = -651.218, y = -27.000, z = 19.501,   rot = 249 }, -- 2
            { x = -63.5152, y = -0.439,  z = -451.992, rot = 116 }, -- 3
        },
        moogles =
        {
            { x = -228.045, y = -34.087, z = -47.449, rot = 26 }, -- 1
            { x = -605.174, y = -30.271, z =  44.911, rot = 71 }, -- 2
            { x = -159.469, y = -60.000, z = 287.445, rot = 95 }, -- 3
        },
    },

    [xi.zone.EAST_RONFAURE] =
    {
        zone    = 'East Ronfaure',
        cap     = 20,
        level   = 25,
        hp      = 200000,
        treant  =
        {
            { x = 348.8329, y = -49.2264, z =  104.0485, rot =   0 }, -- 1
            { x = 510.9347, y =  -9.4044, z = -410.2809, rot =   0 }, -- 2
            { x = 210.6801, y =  -10.015, z = -388.7771, rot =   0 }, -- 3
        },
        moogles =
        {
            { x = 336.1743, y = -49.9909, z =  124.0939, rot = 156 }, -- 1
            { x = 503.1357, y =  -8.1068, z = -384.1399, rot = 217 }, -- 2
            { x = 231.1312, y =  -9.4103, z = -409.1042, rot =  54 }, -- 3
        },
    },

    [xi.zone.NORTH_GUSTABERG] =
    {
        zone    = 'North Gustaberg',
        cap     = 20,
        level   = 25,
        hp      = 200000,
        treant  =
        {
            { x =  -45.3841, y =    0.25, z = 72.8555, rot =   0 }, -- 1
            { x = -152.6474, y = -0.4538, z = 395.392, rot =   0 }, -- 2
            { x = -468.3202, y = 50.1887, z = 37.7089, rot =   0 }, -- 3
        },
        moogles =
        {
            { x =  -78.7028, y =       0, z =  57.9805, rot =  69 }, -- 1
            { x = -115.5085, y =  -0.325, z = 382.3555, rot =  33 }, -- 2
            { x = -453.1328, y = 49.3021, z =  -7.3679, rot =  34 }, -- 3
        },
    },

    [xi.zone.SOUTH_GUSTABERG] =
    {
        zone    = 'South Gustaberg',
        cap     = 20,
        level   = 25,
        hp      = 200000,
        treant  =
        {
            { x =  90.8989, y =  0.1961, z = -244.5567, rot =   0 }, -- 1
            { x = 519.6724, y =  -0.011, z = -554.0604, rot =   0 }, -- 2
            { x = 412.5963, y = -0.8352, z = -290.2584, rot =   0 }, -- 3
        },
        moogles =
        {
            { x = 118.4951, y = 0.6231, z = -230.9585, rot = 207 }, -- 1
            { x = 525.4673, y = 0.1763, z = -519.8473, rot = 238 }, -- 2
            { x = 396.0378, y = 0.0355, z = -315.3413, rot = 144 }, -- 3
        },
    },

    [xi.zone.WEST_SARUTABARUTA] =
    {
        zone    = 'West Sarutabaruta',
        cap     = 20,
        level   = 25,
        hp      = 200000,
        treant  =
        {
            { x = 319.9714, y = -11.6672, z = 193.2803, rot =   0 }, -- 1
            { x =  28.3662, y =  -16.044, z = 292.6938, rot =   0 }, -- 2
            { x = -85.7474, y =  -4.1501, z = 364.6013, rot =   0 }, -- 3
        },
        moogles =
        {
            { x = 314.6287, y =  -6.6926, z =  144.1943, rot =  10 }, -- 1
            { x =   6.1309, y = -13.0928, z =  294.4963, rot = 124 }, -- 2
            { x =  59.5851, y =  -5.3952, z = -380.7835, rot =  64 }, -- 3
        },
    },

    [xi.zone.EAST_SARUTABARUTA] =
    {
        zone    = 'East Sarutabaruta',
        cap     = 20,
        level   = 25,
        hp      = 200000,
        treant  =
        {
            { x =    89.411, y =  -4.7825, z = -414.9001, rot =   0 }, -- 1
            { x = -330.8143, y =  -1.7949, z =  -66.5058, rot =   0 }, -- 2
            { x =  163.5024, y = -12.1748, z =  193.2294, rot =   0 }, -- 3
        },
        moogles =
        {
            { x =   62.1872, y =  -5.1149, z = -414.7411, rot = 184 }, -- 1
            { x = -284.9077, y =   -4.851, z =  -64.6169, rot = 255 }, -- 2
            { x =    174.25, y = -13.0394, z =  165.5737, rot =  80 }, -- 3
        },
    },

    [xi.zone.JUGNER_FOREST] =
    {
        zone    = 'Jugner Forest',
        cap     = 30,
        level   = 35,
        hp      = 300000,
        treant  =
        {
            { x = -122.952, y =      0, z = -164.9595, rot =   0 }, -- 1
            { x =  78.4619, y =      0, z =  -78.1213, rot =   0 }, -- 2
            { x = 401.1706, y = 0.6885, z =    94.929, rot =   0 }, -- 3
        },
        moogles =
        {
            { x = 151.3835, y = 0.0958, z = -166.062, rot = 123 }, -- 1
            { x =  80.3824, y =      0, z =  -41.223, rot = 199 }, -- 2
            { x = 379.2048, y = 0.2721, z = 101.5312, rot = 137 }, -- 3
        },
    },

    [xi.zone.PASHHOW_MARSHLANDS] =
    {
        zone    = 'Pashhow Marshlands',
        cap     = 30,
        level   = 35,
        hp      = 300000,
        treant  =
        {
            { x =  396.2914, y =      25, z = 387.4296, rot =   0 }, -- 1
            { x = -387.1429, y = 24.8061, z = 483.6978, rot =   0 }, -- 2
            { x =  151.6733, y =      25, z =  31.2594, rot =   0 }, -- 3
        },
        moogles =
        {
            { x =  383.9823, y =      25, z = 409.7735, rot = 186 }, -- 1
            { x = -350.4578, y =      25, z = 461.5094, rot =   2 }, -- 2
            { x =  183.5526, y = 24.0119, z =  57.9245, rot = 114 }, -- 3
        },
    },

    [xi.zone.MERIPHATAUD_MOUNTAINS] =
    {
        zone    = 'Meriphataud Mountains',
        cap     = 30,
        level   = 35,
        hp      = 300000,
        treant  =
        {
            { x =  463.9538, y = -24.051, z = 187.5342, rot =   0 }, -- 1
            { x =   33.7662, y = -7.7388, z =  90.5541, rot =   0 }, -- 2
            { x = -168.2296, y = 24.2104, z = -196.443, rot =   0 }, -- 3
        },
        moogles =
        {
            { x =  456.0388, y = -23.7437, z =  145.6183, rot =  83 }, -- 1
            { x =   28.5316, y =  -5.9451, z =  134.5061, rot = 166 }, -- 2
            { x = -216.2384, y =  13.9647, z = -176.0528, rot = 140 }, -- 3
        },
    },

    [xi.zone.BEAUCEDINE_GLACIER] =
    {
        zone    = 'Beaucedine Glacier',
        cap     = 50,
        level   = 55,
        hp      = 400000,
        treant  =
        {
            { x = 179.8336, y = -19.0094, z =  203.0641, rot =   0 }, -- 1
            { x = 215.8067, y = -19.8066, z = -128.6225, rot =   0 }, -- 2
            { x = 273.0769, y =  20.1451, z =  401.1451, rot =   0 }, -- 3
        },
        moogles =
        {
            { x = 168.8212, y = -19.9241, z =  168.1093, rot = 104 }, -- 1
            { x = 186.9835, y =  -19.936, z = -107.3674, rot = 150 }, -- 2
            { x = 300.8779, y =   20.495, z =  414.1097, rot =   0 }, -- 3
        },
    },

    [xi.zone.EASTERN_ALTEPA_DESERT] =
    {
        zone    = 'Eastern Altepa Desert',
        cap     = 50,
        level   = 55,
        hp      = 400000,
        treant  =
        {
            { x = 124.9664, y = -7.7153, z =  309.2755, rot =   0 }, -- 1
            { x = -11.4912, y = -15.628, z =   42.5899, rot =   0 }, -- 2
            { x =  87.4273, y =  8.1992, z = -326.9167, rot =   0 }, -- 3
        },
        moogles =
        {
            { x = 143.6906, y = -15.4587, z =  295.6949, rot =  25 }, -- 1
            { x = -40.3955, y =      -16, z =   35.8946, rot =  96 }, -- 2
            { x = 116.6125, y =        8, z = -322.4949, rot = 251 }, -- 3
        },
    },

    [xi.zone.YUHTUNGA_JUNGLE] =
    {
        zone    = 'Yuhtunga Jungle',
        cap     = 50,
        level   = 55,
        hp      = 400000,
        treant  =
        {
            { x =  329.8498, y = 4.3914, z =  201.4311, rot =   0 }, -- 1
            { x = -160.8417, y =      0, z = -398.1059, rot =   0 }, -- 2
            { x = -602.3797, y =      0, z =  -38.5479, rot =   0 }, -- 3
        },
        moogles =
        {
            { x =  301.9791, y = 4.1053, z =  189.7003, rot = 136 }, -- 1
            { x = -206.7464, y = 0.2805, z = -405.5575, rot = 188 }, -- 2
            { x = -608.1036, y = 0.0721, z =  -70.9248, rot =  37 }, -- 3
        },
    },
}

xi.treantEvent.cityTeleporters =
{
    [xi.zone.NORTHERN_SAN_DORIA] = 17723597, -- Jeanvirgaud
    [xi.zone.BASTOK_MINES      ] = 17735859, -- Conrad
    [xi.zone.PORT_WINDURST     ] = 17760439, -- Rottata
}

local function getRestrictionCap(entity)
    local restriction = entity:getStatusEffect(xi.effect.LEVEL_RESTRICTION)

    if
        restriction and
        restriction:getSubType() == xi.treantEvent.capSubType
    then
        return restriction
    end

    return nil
end

-- A zone lists either one treant position or several; the moogles stay put beside every spot
xi.treantEvent.spots = function(entry)
    if entry.treant.x then
        return { entry.treant }
    end

    return entry.treant
end

xi.treantEvent.currentSpot = function(zoneId, entry)
    local spots = xi.treantEvent.spots(entry)
    local index = GetServerVariable('[TreantEvent]Spot_' .. zoneId)

    if
        index < 1 or
        index > #spots
    then
        index = 1
    end

    return spots[index], index
end

local function moveToNextSpot(mob, zoneId, entry)
    local spots = xi.treantEvent.spots(entry)
    if #spots < 2 then
        return
    end

    local _, index = xi.treantEvent.currentSpot(zoneId, entry)
    local nextIndex = index % #spots + 1
    local pos       = spots[nextIndex]

    SetServerVariable('[TreantEvent]Spot_' .. zoneId, nextIndex)

    mob:setSpawn(pos.x, pos.y, pos.z, pos.rot)
    mob:setPos(pos.x, pos.y, pos.z, pos.rot)

    for _, member in pairs(mob:getZone():getPlayers()) do
        member:printToPlayer(string.format('The Twinkling Treant of %s has uprooted itself and wandered elsewhere, kupo!', entry.zone), xi.msg.channel.SYSTEM_3)
    end
end

-- Runs from the roam and disengage hooks only, so a fight always finishes before the treant moves
local function swapWhenDue(mob, zoneId, entry)
    if
        mob:getLocalVar('[TreantEvent]NextSwap') > GetSystemTime() or
        mob:getZone():getLocalVar('[TreantEvent]MobId') ~= mob:getID()
    then
        return
    end

    mob:setLocalVar('[TreantEvent]NextSwap', GetSystemTime() + swapInterval)
    moveToNextSpot(mob, zoneId, entry)
end

xi.treantEvent.onGateRejected = function(player)
    if player:getLocalVar('[TreantEvent]GateNotice') > GetSystemTime() then
        return
    end

    player:setLocalVar('[TreantEvent]GateNotice', GetSystemTime() + 10)
    player:printToPlayer('Only those who hold the right may face the Twinkling Treant. Speak with a Festive Moogle to join the fight, kupo!', xi.msg.channel.SYSTEM_3)
end

local function countRemaining()
    local remaining = 0

    for zoneId, _ in pairs(xi.treantEvent.zones) do
        if GetServerVariable('[TreantEvent]Dead_' .. zoneId) == 0 then
            remaining = remaining + 1
        end
    end

    return remaining
end

xi.treantEvent.setTeleporterStatus = function(zoneId, status)
    local npcId = xi.treantEvent.cityTeleporters[zoneId]

    if
        not npcId or
        not GetZone(zoneId)
    then
        return
    end

    local npc = GetNPCByID(npcId)
    if npc then
        npc:setStatus(status)
    end
end

xi.treantEvent.spawnMoogles = function(zone, zoneId, entry)
    for i, pos in ipairs(entry.moogles) do
        local npc = zone:insertDynamicEntity({
            objtype    = xi.objType.NPC,
            name       = string.format('Treant_Moogle_%i', i),
            packetName = 'Festive Moogle',
            look       = 82,
            x          = pos.x,
            y          = pos.y,
            z          = pos.z,
            rotation   = pos.rot,
            releaseIdOnDisappear = false,

            onTrigger = function(player, npc)
                npc:facePlayer(player, true)

                local speaker     = npc:getPacketName()
                local restriction = player:getStatusEffect(xi.effect.LEVEL_RESTRICTION)

                if
                    restriction and
                    restriction:getSubType() ~= xi.treantEvent.capSubType
                then
                    player:printToPlayer('You are already bound by another engagement, kupo. Settle that business first!', xi.msg.channel.SAY, speaker)
                    return
                end

                if restriction then
                    local pet = player:getPet()
                    if pet then
                        pet:delStatusEffect(xi.effect.LEVEL_RESTRICTION)
                    end

                    player:delStatusEffect(xi.effect.LEVEL_RESTRICTION)
                    player:printToPlayer('Your participation is withdrawn, kupo. Come back if you change your mind!', xi.msg.channel.SAY, speaker)

                    return
                end

                player:printToPlayer('Hello hello, kupo! I can help you join in the fight to defeat the pernicious Twinkling Treants!', xi.msg.channel.SAY, speaker)

                player:customMenu({
                    title   = string.format('Join the fight at level %i?', entry.cap),
                    options =
                    {
                        {
                            'Yes, kupo!',
                            function(playerArg)
                                if GetServerVariable('[TreantEvent]Dead_' .. zoneId) ~= 0 then
                                    playerArg:printToPlayer('The Twinkling Treant here has already fallen, kupo!', xi.msg.channel.SAY, speaker)
                                    return
                                end

                                playerArg:addStatusEffect(xi.effect.LEVEL_RESTRICTION, {
                                    power    = entry.cap,
                                    subPower = 1, -- exp for other kills uses real level
                                    subType  = xi.treantEvent.capSubType,
                                    duration = xi.treantEvent.capDuration,
                                    origin   = playerArg,
                                    flag     = xi.effectFlag.ON_ZONE,
                                })

                                -- pets summoned after the grant inherit the effect,
                                -- an existing pet needs it added directly
                                local pet = playerArg:getPet()
                                if pet then
                                    pet:addStatusEffect(xi.effect.LEVEL_RESTRICTION, {
                                        power    = entry.cap,
                                        duration = xi.treantEvent.capDuration,
                                        origin   = pet,
                                    })
                                end

                                playerArg:printToPlayer(string.format('You now hold the right to face the Twinkling Treant, kupo! Your level is restricted to %i for the next %i minutes.', entry.cap, math.floor(xi.treantEvent.capDuration / 60)), xi.msg.channel.SAY, speaker)
                                playerArg:printToPlayer('The restriction also ends if you speak with me again, leave the zone, or fall in battle, kupo!', xi.msg.channel.SAY, speaker)
                            end,
                        },
                        {
                            'Not yet.',
                            function(playerArg)
                                playerArg:printToPlayer('Come back when you are ready, kupo!', xi.msg.channel.SAY, speaker)
                            end,
                        },
                    },
                })
            end,
        })

        if npc then
            zone:setLocalVar('[TreantEvent]MoogleId' .. i, npc:getID())
        end
    end
end

local function setMoogleStatus(zone, entry, status)
    for i = 1, #entry.moogles do
        local moogle = GetNPCByID(zone:getLocalVar('[TreantEvent]MoogleId' .. i))
        if moogle then
            moogle:setStatus(status)
        end
    end
end

local function clearZone(zone, entry)
    setMoogleStatus(zone, entry, xi.status.DISAPPEAR)

    zone:setLocalVar('[TreantEvent]MobId', 0)

    for _, member in pairs(zone:getPlayers()) do
        if getRestrictionCap(member) then
            local pet = member:getPet()
            if pet then
                pet:delStatusEffect(xi.effect.LEVEL_RESTRICTION)
            end

            member:delStatusEffect(xi.effect.LEVEL_RESTRICTION)
        end
    end
end

xi.treantEvent.spawnTreant = function(zone, zoneId, entry)
    local spot = xi.treantEvent.currentSpot(zoneId, entry)

    local mob = zone:insertDynamicEntity({
        objtype     = xi.objType.MOB,
        name        = 'Twinkling_Treant',
        packetName  = 'TwinklingTreant',
        x           = spot.x,
        y           = spot.y,
        z           = spot.z,
        rotation    = spot.rot,
        groupId     = 200,
        groupZoneId = 100,
        minLevel    = entry.level,
        maxLevel    = entry.level,
        releaseIdOnDisappear  = true,
        specialSpawnAnimation = true,

        onMobSpawn = function(mob)
            mob:setMaxHP(entry.hp)

            local savedHP = GetServerVariable('[TreantEvent]HP_' .. zoneId)
            if savedHP > 0 then
                mob:setHP(savedHP)
            else
                mob:setHP(entry.hp)
            end

            mob:setDropID(0)
            mob:setMobMod(xi.mobMod.NO_REST, 1)
            mob:setMobMod(xi.mobMod.NO_DROPS, 1)
            mob:setMobMod(xi.mobMod.NO_AGGRO, 1)
            mob:setMobMod(xi.mobMod.NO_SPELL_COST, 1)
            mob:setMobMod(xi.mobMod.EXP_BONUS, -100)
            mob:setMobMod(xi.mobMod.GIL_MAX, -1)
            mob:setMobMod(xi.mobMod.CHARMABLE, 0)
            mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.NON_EXCLUSIVE)
            mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
            mob:setMobMod(xi.mobMod.NO_LINK, 1)
            mob:setMobMod(xi.mobMod.ONE_WAY_LINKING, 1)
            mob:setCallForHelpBlocked(true)

            -- Read by the treant_gate C++ module to refuse actions from players without this cap
            mob:setLocalVar('[TreantEvent]CapSubType', xi.treantEvent.capSubType)
            mob:setLocalVar('[TreantEvent]NextSwap', GetSystemTime() + swapInterval)
        end,

        onMobMobskillChoose = function(mob, target)
            local skills =
            {
                xi.mobSkill.DRILL_BRANCH,
                xi.mobSkill.PINECONE_BOMB,
                xi.mobSkill.ENTANGLE_DRAIN,
                1026, -- arbor_storm
            }

            return skills[math.randomInt(1, #skills)]
        end,

        -- the placeholder spell list only carries a buff, so leave the idle
        -- cast alone and force sleepga in combat
        onMobSpellChoose = function(mob, target)
            return xi.magic.spell.SLEEPGA
        end,

        -- Crash insurance: persist mob HP once per minute while engaged
        onMobFight = function(mob, target)
            if mob:getLocalVar('[TreantEvent]NextHPSave') > GetSystemTime() then
                return
            end

            mob:setLocalVar('[TreantEvent]NextHPSave', GetSystemTime() + 60)
            SetServerVariable('[TreantEvent]HP_' .. zoneId, mob:getHP())
        end,

        onMobDisengage = function(mob)
            SetServerVariable('[TreantEvent]HP_' .. zoneId, mob:getHP())
            swapWhenDue(mob, zoneId, entry)
        end,

        onMobRoam = function(mob)
            swapWhenDue(mob, zoneId, entry)
        end,

        -- On death: Hide moogles, wipe level restriction, announce death
        onMobDeath = function(mob, player, optParams)
            if
                not optParams.isKiller and
                not optParams.noKiller
            then
                return
            end

            if GetServerVariable('[TreantEvent]Dead_' .. zoneId) ~= 0 then
                return
            end

            SetServerVariable('[TreantEvent]Dead_' .. zoneId, GetSystemTime())
            SetServerVariable('[TreantEvent]HP_' .. zoneId, 0)

            local treantZone = mob:getZone()

            clearZone(treantZone, entry)

            local announcer = player or treantZone:getPlayers()[1]

            local remaining = countRemaining()

            if remaining > 0 then
                if announcer then
                    local message = string.format("The Twinkling Treant of %s has fallen, kupo! Only %i remain across Vana'diel!", entry.zone, remaining)

                    if remaining == 1 then
                        message = string.format("The Twinkling Treant of %s has fallen! Just ONE treant remains... we're almost there, kupo!", entry.zone)
                    end

                    announcer:printToArea(message, xi.msg.channel.SYSTEM_3, xi.msg.area.SYSTEM, '', false)
                end

                return
            end

            SetServerVariable('[TreantEvent]Complete', GetSystemTime())

            if announcer then
                announcer:printToArea('The last Twinkling Treant has fallen, kupo! Outpost teleportation services have been restored across Vana\'diel!', xi.msg.channel.SYSTEM_3, xi.msg.area.SYSTEM, '', false)
            end

            for cityZoneId in pairs(xi.treantEvent.cityTeleporters) do
                SendLuaFuncStringToZone(zoneId, cityZoneId, string.format('xi.treantEvent.setTeleporterStatus(%i, %i)', cityZoneId, xi.status.NORMAL))
            end
        end,
    })

    if not mob then
        return
    end

    mob:setSpawn(spot.x, spot.y, spot.z, spot.rot)
    mob:spawn()
    zone:setLocalVar('[TreantEvent]MobId', mob:getID())
end

xi.treantEvent.startZone = function(zoneId)
    local zone  = GetZone(zoneId)
    local entry = xi.treantEvent.zones[zoneId]

    if
        not zone or
        not entry or
        GetServerVariable('[TreantEvent]Dead_' .. zoneId) ~= 0
    then
        return
    end

    if zone:getLocalVar('[TreantEvent]MoogleId1') == 0 then
        xi.treantEvent.spawnMoogles(zone, zoneId, entry)
    else
        setMoogleStatus(zone, entry, xi.status.NORMAL)
    end

    local mobId = zone:getLocalVar('[TreantEvent]MobId')
    if mobId ~= 0 then
        local existing = GetMobByID(mobId)
        if
            existing and
            existing:isSpawned()
        then
            return
        end
    end

    xi.treantEvent.spawnTreant(zone, zoneId, entry)
end

xi.treantEvent.resetZone = function(zoneId)
    local zone  = GetZone(zoneId)
    local entry = xi.treantEvent.zones[zoneId]

    if
        not zone or
        not entry
    then
        return
    end

    local mobId = zone:getLocalVar('[TreantEvent]MobId')
    if mobId ~= 0 then
        local mob = GetMobByID(mobId)
        if mob then
            DespawnMob(mobId, zone)
        end
    end

    clearZone(zone, entry)
end

m:addOverride('xi.server.onServerStart', function()
    super()

    -- Inactive until launched with !treants start
    if GetServerVariable('[TreantEvent]Started') == 0 then
        return
    end

    for zoneId in pairs(xi.treantEvent.zones) do
        xi.treantEvent.startZone(zoneId)
    end

    -- Hide the city outpost teleporter NPCs while the event runs
    if GetServerVariable('[TreantEvent]Complete') == 0 then
        for zoneId in pairs(xi.treantEvent.cityTeleporters) do
            xi.treantEvent.setTeleporterStatus(zoneId, xi.status.DISAPPEAR)
        end
    end
end)

-- Effects restored on login rerun this, so the exemption and its listeners survive a relog
m:addOverride('xi.effects.level_restriction.onEffectGain', function(target, effect)
    super(target, effect)

    if
        target:getObjType() ~= xi.objType.PC or
        effect:getSubType() ~= xi.treantEvent.capSubType
    then
        return
    end

    effect:delEffectFlag(xi.effectFlag.HIDE_TIMER)
    effect:addMod(xi.mod.EXPERIENCE_RETAINED, 100)
    target:setLocalVar('[TreantEvent]LastHitByTreant', 0)

    target:addListener('TAKE_DAMAGE', '[TreantEvent]TAKE_DAMAGE', function(player, amount, attacker)
        local byTreant = 0

        if
            attacker and
            attacker:getID() == player:getZone():getLocalVar('[TreantEvent]MobId')
        then
            byTreant = 1
        end

        player:setLocalVar('[TreantEvent]LastHitByTreant', byTreant)
    end)

    -- Core charges EXP for the death right after this fires, so a kill by anything but the treant forfeits the exemption here
    target:addListener('DEATH', '[TreantEvent]DEATH', function(player)
        if player:getLocalVar('[TreantEvent]LastHitByTreant') == 1 then
            return
        end

        local cap = getRestrictionCap(player)
        if cap then
            cap:addMod(xi.mod.EXPERIENCE_RETAINED, -100)
        end
    end)
end)

m:addOverride('xi.effects.level_restriction.onEffectLose', function(target, effect)
    super(target, effect)

    if
        target:getObjType() ~= xi.objType.PC or
        effect:getSubType() ~= xi.treantEvent.capSubType
    then
        return
    end

    target:removeListener('[TreantEvent]TAKE_DAMAGE')
    target:removeListener('[TreantEvent]DEATH')

    -- An engaged player keeps swinging without new action packets, so the gate cannot catch a lapse mid-fight
    local zone = target:getZone()
    if not zone then
        return
    end

    local treantId = zone:getLocalVar('[TreantEvent]MobId')

    for _, fighter in pairs({ target, target:getPet() }) do
        local battleTarget = fighter:getTarget()
        if
            battleTarget and
            battleTarget:getID() == treantId
        then
            fighter:disengage()
        end
    end

    if effect:getTimeRemaining() == 0 then
        target:printToPlayer('Your right to face the Twinkling Treant has lapsed, kupo. Speak with a Festive Moogle to rejoin the fight!', xi.msg.channel.SYSTEM_3)
    end
end)

m:addOverride('xi.player.onPlayerDeath', function(player)
    super(player)

    if not getRestrictionCap(player) then
        return
    end

    player:delStatusEffect(xi.effect.LEVEL_RESTRICTION)
    player:printToPlayer('Your right to face the Twinkling Treant ends with your defeat, kupo. Speak with a Festive Moogle to rejoin the fight!', xi.msg.channel.SYSTEM_3)
end)

-- Forcibly only show the vendor menu while outposts are disabled
m:addOverride('xi.conquest.vendorOnTrigger', function(player, vendorRegion, vendorEvent)
    if
        GetServerVariable('[TreantEvent]Complete') == 0 and
        GetServerVariable('[TreantEvent]Started') ~= 0
    then
        local pNation = player:getNation()
        local owner   = GetRegionOwner(vendorRegion)
        local nation  = 0

        if owner == pNation then
            nation = 1
        elseif xi.conquest.areAllies(pNation, owner) then
            nation = 2
        end

        player:startEvent(vendorEvent, nation, 0, 0, 0, player:getCP(), 0, 0, 0)
        return
    end

    super(player, vendorRegion, vendorEvent)
end)

m:addOverride('xi.conquest.vendorOnEventFinish', function(player, option, vendorRegion)
    if
        GetServerVariable('[TreantEvent]Complete') == 0 and
        GetServerVariable('[TreantEvent]Started') ~= 0 and
        option == 1
    then
        xi.shop.outpost(player)

        return
    end

    super(player, option, vendorRegion)
end)

return m
