-----------------------------------
-- Timed NM Respawn Persistence
-- Keeps the remaining respawn window of open world timed NMs across a map
-- server restart. A respawn timer lives in memory and dies with the map
-- process. Without this, a boot spawns every NM that was down and hands
-- out free pops.
--
-- Each NM gets an onMobInitialize override. It adds a DESPAWN listener
-- that saves the end of the window to a server variable. Server variables
-- live in the database, so the restart does not clear them. The value
-- stored is system time plus the time left, so downtime counts against the
-- window. DESPAWN listeners run after onMobDespawn, so the base script and
-- the era module have already rolled the new window. The number saved is
-- the one players wait out. A SPAWN listener clears the variable, so a
-- stale deadline never holds a living NM down.
--
-- The override then hands the time left to setRespawnTime. That has to
-- happen inside onMobInitialize. The boot spawn pass runs straight after
-- it and skips any mob that already has a respawn pending. That skip is
-- what keeps the NM down.
--
-- A window that ran out during the downtime comes back as one minute, not
-- zero. The spawn handler ticks every 30 seconds and pops anything due in
-- the next 15. Either way the NM is up in a wave or two. The floor is
-- there because setRespawnTime sets the window for good, not just the next
-- pop. A shorter value would still be the window at the NM's next death. A
-- spawn wave landing inside the three second death fade would pop the NM
-- again. Its despawn hooks never run, so nothing is saved and the short
-- window stays.
--
-- The generic table below is a curated list of open world NMs with a
-- window of an hour or more. Quest, mission, battlefield, lottery, spawn
-- slot, popped, dynamic and instanced content is out.
--
-- One case is not fixed, and it is a restart while the NM is alive.
-- Nothing is saved for a living NM. Spawning deletes its row, because a mob
-- that is up has no window left to wait out. So a restart at that moment
-- finds nothing to restore.
--
-- Most NM scripts roll themselves a fresh window in onMobInitialize. The
-- hold runs after super, so normally it replaces that roll with the saved
-- remainder. With nothing saved the roll stands, and the NM comes back down
-- owing the whole window again. Ash Dragon is the worst of them at up to
-- five days.
--
-- The base server loses it the same way, so nothing here made it worse.
-- Covering it would mean saving that the NM was alive and spawning it back
-- at boot, which is a different job from holding a window.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('pxi_timed_nm_respawn_persistence')

-- server_variables.name is varchar(50). The prefix plus the longest key
-- below is 33 characters.
local varPrefix = '[PXI][TNM]'

-----------------------------------
-- Single entity NMs
-- Each NM here owns its own window, so the hold is straightforward. A
-- DESPAWN listener writes the time left to a server variable. The
-- initialize override registers that time again at the next boot.
--
-- The era module rerolls the window at initialize for Roc, Morbolger,
-- Capricious Cassie, Simurgh, Bloodsucker, Juggler Hecatomb and Manipulator.
-- It loads before this module, so its reroll runs inside the super call
-- below. The hold then lands on top of the rerolled window.
-----------------------------------
local timedNMs =
{
    -- { zone script folder, { mob file names } }
    { 'Arrapago_Reef',          { 'Lamia_No19', 'Lamie_No9' } },
    { 'Attohwa_Chasm',          { 'Tiamat', 'Xolotl' } },
    { 'Batallia_Downs',         { 'Ahtu', 'Weeping_Willow' } },
    { 'Bostaunieux_Oubliette',  { 'Bloodsucker_NM', 'Drexerion_the_Condemned', 'Phanduron_the_Condemned' } },
    { 'Caedarva_Mire',          { 'Khimaira' } }, -- The zone reschedules him at boot. See the section below.
    { 'Cape_Teriggan',          { 'Kreutzet' } },
    { 'Castle_Zvahl_Baileys',   { 'Duke_Haborym', 'Grand_Duke_Batym', 'Marquis_Allocen', 'Marquis_Amon' } },
    { 'Den_of_Rancor',          { 'Tonberry_Pontifex' } },
    { 'Eastern_Altepa_Desert',  { 'Cactrot_Rapido', 'Centurio_XII-I' } },
    { 'FeiYin',                 { 'Capricious_Cassie' } },
    { 'Garlaige_Citadel',       { 'Old_Two-Wings', 'Serket', 'Skewer_Sam' } },
    { 'Gusgen_Mines',           { 'Juggler_Hecatomb' } },
    { 'Gustav_Tunnel',          { 'Bune' } },
    { 'Ifrits_Cauldron',        { 'Ash_Dragon' } },
    { 'Inner_Horutoto_Ruins',   { 'Maltha' } },
    { 'Jugner_Forest',          { 'Fraelissa', 'Meteormauler_Zhagtegg' } },
    { 'King_Ranperres_Tomb',    { 'Vrtra' } },
    { 'Kuftal_Tunnel',          { 'Guivre' } },
    { 'Labyrinth_of_Onzozo',    { 'Mysticmaker_Profblix' } },
    { 'Meriphataud_Mountains',  { 'Coo_Keja_the_Unseen', 'Waraxe_Beak' } },
    { 'Misareaux_Coast',        { 'Upyri' } },
    { 'Mount_Zhayolm',          { 'Cerberus' } }, -- The zone reschedules him at boot. See the section below.
    { 'Ordelles_Caves',         { 'Morbolger' } },
    { 'Palborough_Mines',       { 'NoMho_Crimsonarmor' } },
    { 'Pashhow_Marshlands',     { 'BoWho_Warmonger' } },
    { 'Phomiuna_Aqueducts',     { 'Tres_Duendes' } },
    { 'Promyvion-Dem',          { 'Satiator' } },
    { 'Promyvion-Holla',        { 'Cerebrator' } },
    { 'Promyvion-Mea',          { 'Coveter' } },
    { 'Quicksand_Caves',        { 'Antican_Consul', 'Proconsul_XII' } },
    { 'Riverne-Site_B01',       { 'Boroka' } },
    { 'RoMaeve',                { 'Shikigami_Weapon' } },
    { 'Rolanberry_Fields',      { 'Simurgh' } },
    { 'Sauromugue_Champaign',   { 'Roc' } },
    { 'Sea_Serpent_Grotto',     { 'Ocean_Sahagin' } },
    { 'Temple_of_Uggalepih',    { 'Manipulator' } },
    { 'The_Boyahda_Tree',       { 'Ancient_Goobbue' } },
    { 'The_Eldieme_Necropolis', { 'Anemone' } },
    { 'The_Shrine_of_RuAvitau', { 'Faust', 'Mother_Globe' } },
    { 'Toraimarai_Canal',       { 'Oni_Carcass' } },
    { 'Uleguerand_Range',       { 'Jormungand', 'Mountain_Worm_NM' } },
    { 'VeLugannon_Palace',      { 'Zipacna' } },
    { 'Wajaom_Woodlands',       { 'Hydra' } },
    { 'Western_Altepa_Desert',  { 'King_Vinegarroon' } },
    { 'Yhoator_Jungle',         { 'Bisque-heeled_Sunberry', 'Bright-handed_Kunberry', 'Woodland_Sage' } },
    { 'Yuhtunga_Jungle',        { 'Meww_the_Turtlerider' } },
}

-- TODO: add the Besieged stronghold NMs once Besieged goes in. They are live
-- open world spawns today and stay out until that system exists. Lamie No.7
-- and Merrow No.5 have no script file, so they also need the table path
-- created with xi.module.ensureTable before the override is declared.
--   Arrapago Reef  Lamie_No7, Medusa, Merrow_No5
--   Halvung        Dorgerwor_the_Astute
--   Mamook         Darting_Kachaal_Ja, Dragonscaled_Bugaal_Ja,
--                  Gulool_Ja_Ja, Hundredfaced_Hapool_Ja
--
-- Hundredfaced Hapool Ja needs a guard. Its four Utsusemi clones spawn under
-- the same name and run the same handler. Only the entity matching
-- zones[xi.zone.MAMOOK].mob.HUNDRED_FACE_HAPOOL_JA gets a window.

-- TODO: add the WotG NMs when that content is turned on. Their templates
-- carry the wotg content tag, so the entities do not exist today. The
-- overrides would error at every boot. This is not a full list.
--   Arrapago Reef          Euryale
--   Caedarva Mire          Aynu-kaysey
--   Eastern Altepa Desert  Sabotender_Corrido
--   FeiYin                 Jenglot, Sluagh
--   Fort Ghelsba           Kegpaunch_Doshgnosh
--   Garlaige Citadel       Frogamander
--   Halvung                Copper_Borer
--   King Ranperres Tomb    Ankou
--   Korroloka Tunnel       Thoon
--   Lower Delkfutts Tower  Tyrant
--   Maze of Shakhrami      Gloombound_Lurker
--   Newton Movalpolos      Sword_Sorcerer_Solisoq
--   Oldton Movalpolos      Bugbear_Muscleman
--   Rolanberry Fields      Ravenous_Crawler
--   Sanctuary of ZiTah     Bastet, Huwasi
--   Toraimarai Canal       Brazen_Bones
--   West Ronfaure          Amanita
--   Yhoator Jungle         Acolnahuacatl

-- TODO: Padfoot (Lufaise Meadows). Five entities share one 21 to 24 hour
-- window. The zone force spawns all five after the boot spawn pass, so a hold
-- cannot survive. The only way back down is a boot depop, and claim shield's
-- resolve timer cancels a pending despawn. Needs a claim shield change first.

for _, entry in ipairs(timedNMs) do
    local zoneName = entry[1]

    for _, mobName in ipairs(entry[2]) do
        m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobInitialize', zoneName, mobName), function(mob)
            super(mob)

            local mobId = mob:getID()

            -- Two Anemones run this one script as separate entities. The mob
            -- id goes in the variable name so one save cannot overwrite the
            -- other.
            local varName = varPrefix .. (mobName == 'Anemone' and (mobName .. mobId) or mobName)

            -- A copy of the mob's normal window. The hold at the bottom of
            -- this function calls setRespawnTime, which changes the window
            -- for good. The copy has to come first. If super rolled its own
            -- window, that roll is what gets copied.
            local baseWindow = GetMobRespawnTime(mobId)

            mob:addListener('DESPAWN', 'PXI_TNM_DESPAWN', function(mobArg)
                local remaining = mobArg:getRespawnTime()
                if remaining > 0 then
                    SetServerVariable(varName, GetSystemTime() + remaining)
                end
            end)

            -- Spawning clears the saved deadline, so a stale one cannot hold
            -- the NM down again. It also puts the normal window back. The
            -- held time is only the leftover from the restart. An NM whose
            -- script never rolls a fresh window would keep it for good.
            mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
                SetServerVariable(varName, 0)

                if baseWindow > 0 then
                    mobArg:setRespawnTime(baseWindow)
                end
            end)

            -- The hold goes on here. Zone load runs onMobInitialize for every
            -- mob, then makes a spawn pass that skips anything with a respawn
            -- already registered. That skip is what keeps the NM down for the
            -- rest of its window.
            local deadline = GetServerVariable(varName)
            if deadline > 0 then
                mob:setRespawnTime(math.max(deadline - GetSystemTime(), 60))
            end
        end)
    end
end

-----------------------------------
-- Zone rescheduled NMs
-- These two zones roll their NM a fresh 12 to 36 hour window inside
-- Zone.onInitialize. That runs after every mob has been through
-- onMobInitialize, so a hold placed there gets overwritten. These two take
-- their hold in the zone override instead, right after super rolls. With
-- nothing saved the override does nothing and the zone's roll stands.
-----------------------------------
local zoneRescheduledNMs =
{
    -- { zone script folder, zone enum, id key, mob file name }
    { 'Mount_Zhayolm', xi.zone.MOUNT_ZHAYOLM, 'CERBERUS', 'Cerberus' },
    { 'Caedarva_Mire', xi.zone.CAEDARVA_MIRE, 'KHIMAIRA', 'Khimaira' },
}

for _, entry in ipairs(zoneRescheduledNMs) do
    local zoneName = entry[1]
    local zoneId   = entry[2]
    local idKey    = entry[3]
    local mobName  = entry[4]

    m:addOverride(string.format('xi.zones.%s.Zone.onInitialize', zoneName), function(zone)
        super(zone)

        -- Overwrite the zone's roll with what is left of the saved window. A
        -- deadline that ran out while the server was down clamps to the 60
        -- second floor, so the NM pops about a minute after the zone loads.
        local deadline = GetServerVariable(varPrefix .. mobName)
        if deadline > 0 then
            GetMobByID(zones[zoneId].mob[idKey]):setRespawnTime(math.max(deadline - GetSystemTime(), 60))
        end
    end)
end

-----------------------------------
-- Shared pairs
-- Two NMs share one window. The despawn handler of the one that died rolls
-- which twin comes back next and hands it the window. The loser only gets a
-- DisallowRespawn flag. That flag does not cancel the respawn the engine
-- already registered for the twin that just died, so both can sit pending at
-- once. Clearing both timers before super leaves one pending entry after the
-- roll. That entry is the pick. Its deadline and its id go to server
-- variables. Zone.onInitialize rolls the pair again at every boot. It runs
-- after every mob initialize, so the boot hold goes in the zone override.
-----------------------------------
local sharedPairs =
{
    -- { zone script folder, zone enum, { mob file name, id key }, { mob file name, id key } }
    { 'Maze_of_Shakhrami',  xi.zone.MAZE_OF_SHAKHRAMI,  { 'Argus', 'ARGUS' }, { 'Leech_King', 'LEECH_KING' } },
    { 'Phomiuna_Aqueducts', xi.zone.PHOMIUNA_AQUEDUCTS, { 'Eba', 'EBA' },     { 'Mahisha', 'MAHISHA' } },
}

for _, pair in ipairs(sharedPairs) do
    local zoneName = pair[1]
    local zoneId   = pair[2]
    local nameA    = pair[3][1]
    local keyA     = pair[3][2]
    local nameB    = pair[4][1]
    local keyB     = pair[4][2]
    local idA      = zones[zoneId].mob[keyA]
    local idB      = zones[zoneId].mob[keyB]
    local pairVar  = varPrefix .. nameA .. '_' .. nameB
    local pickVar  = pairVar .. '_Next'

    for _, mobName in ipairs({ nameA, nameB }) do
        m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobDespawn', zoneName, mobName), function(mob)
            -- Clear both pending respawns, including the one the engine
            -- registered for the twin that just died. super then rolls and
            -- hands the winner a window. One timer is left running, and it
            -- is the pick.
            GetMobByID(idA):setRespawnTime(0)
            GetMobByID(idB):setRespawnTime(0)

            super(mob)

            for _, id in ipairs({ idA, idB }) do
                local remaining = GetMobByID(id):getRespawnTime()
                if remaining > 0 then
                    SetServerVariable(pairVar, GetSystemTime() + remaining)
                    SetServerVariable(pickVar, id)
                end
            end
        end)

        m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobInitialize', zoneName, mobName), function(mob)
            super(mob)

            -- The saved window belongs to the pick. If the other twin spawns
            -- for any reason, clearing the variable would throw away a
            -- window that is still counting down.
            mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
                if mobArg:getID() == GetServerVariable(pickVar) then
                    SetServerVariable(pairVar, 0)
                end
            end)
        end)
    end

    m:addOverride(string.format('xi.zones.%s.Zone.onInitialize', zoneName), function(zone)
        super(zone)

        -- With nothing saved there is no window to hold, so the pair roll
        -- super just made stands.
        local deadline = GetServerVariable(pairVar)
        if deadline == 0 then
            return
        end

        -- The saved id has to name one of the twins. Anything else is not
        -- usable, so clear both variables and let the next despawn write a
        -- fresh pair.
        local nextId = GetServerVariable(pickVar)
        if nextId ~= idA and nextId ~= idB then
            SetServerVariable(pairVar, 0)
            SetServerVariable(pickVar, 0)
            return
        end

        -- The zone's roll may have landed on the other twin, so unregister
        -- it. Then reroll the pick's spawn point and hand it what is left of
        -- the saved window.
        GetMobByID(nextId == idA and idB or idA):setRespawnTime(0)
        xi.mob.updateNMSpawnPoint(nextId)
        GetMobByID(nextId):setRespawnTime(math.max(deadline - GetSystemTime(), 60))
    end)
end

-----------------------------------
-- Beastmen kings
-- Each NQ is the placeholder for a king. NQ deaths count toward him through
-- a [PH] counter server variable. The base despawn then does one of two
-- things. Either it reschedules the NQ and bumps the counter, or it schedules
-- the king and leaves the counter alone. Nothing else says which one got the
-- window, so the counter is read before super and compared after.
--
-- Orcish Overlord and Diamond Quadav share their script with quest copies of
-- the NM. A copy runs a window of its own off the base initialize roll, but
-- it never counts toward the king, so the NQ despawn and initialize overrides
-- drop out on any id but the real pair.
-----------------------------------
local kings =
{
    -- { zone script folder, zone enum, NQ id key, NQ file name, HQ file name, HQ id offset, [PH] counter }
    { 'Castle_Oztroja',  xi.zone.CASTLE_OZTROJA,  'YAGUDO_AVATAR',   'Yagudo_Avatar',   'Tzee_Xicu_the_Manifest', 3, '[PH]Tzee_Xicu_the_Manifest' },
    { 'Monastic_Cavern', xi.zone.MONASTIC_CAVERN, 'ORCISH_OVERLORD', 'Orcish_Overlord', 'Overlord_Bakgodek',      1, '[PH]Overlord_Bakgodek' },
    { 'Qulun_Dome',      xi.zone.QULUN_DOME,      'DIAMOND_QUADAV',  'Diamond_Quadav',  'ZaDha_Adamantking',      1, '[PH]Za_Dha_Adamantking' },
}

for _, king in ipairs(kings) do
    local zoneName   = king[1]
    local zoneId     = king[2]
    local nqKey      = king[3]
    local nqName     = king[4]
    local hqName     = king[5]
    local hqOffset   = king[6]
    local counterVar = king[7]
    local nqId       = zones[zoneId].mob[nqKey]
    local pairVar    = varPrefix .. nqName
    local pickVar    = pairVar .. '_Next'

    m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobDespawn', zoneName, nqName), function(mob)
        -- super bumps the counter when the NQ keeps the window. Read the old
        -- value first. After super there is nothing left to compare against.
        local before = GetServerVariable(counterVar)

        super(mob)

        if mob:getID() ~= nqId then
            return
        end

        -- A counter that did not move means super scheduled the king instead
        -- of the placeholder, so the king is the id holding the window.
        local pickId    = GetServerVariable(counterVar) == before and (nqId + hqOffset) or nqId
        local remaining = GetMobByID(pickId):getRespawnTime()
        if remaining > 0 then
            SetServerVariable(pairVar, GetSystemTime() + remaining)
            SetServerVariable(pickVar, pickId)
        end
    end)

    m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobDespawn', zoneName, hqName), function(mob)
        super(mob)

        -- A king death resets the counter and hands the window back to the
        -- placeholder. There is no pick to work out. super has already
        -- scheduled the NQ.
        local remaining = GetMobByID(nqId):getRespawnTime()
        if remaining > 0 then
            SetServerVariable(pairVar, GetSystemTime() + remaining)
            SetServerVariable(pickVar, nqId)
        end
    end)

    for _, mobName in ipairs({ nqName, hqName }) do
        m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobInitialize', zoneName, mobName), function(mob)
            super(mob)

            local mobId = mob:getID()
            local hqId  = nqId + hqOffset

            if mobId ~= nqId and mobId ~= hqId then
                return
            end

            -- Both ids run this listener. Only the id the despawn picked
            -- clears the deadline, so a pop of the other one cannot throw
            -- away a window that is still running.
            mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
                if mobArg:getID() == GetServerVariable(pickVar) then
                    SetServerVariable(pairVar, 0)
                end
            end)

            local deadline = GetServerVariable(pairVar)
            if deadline == 0 then
                return
            end

            -- The pick has to be one of these two ids. A stale one would
            -- send both of them to the unregister branch below and neither
            -- would respawn, so drop the pick and the window with it.
            local nextId = GetServerVariable(pickVar)
            if nextId ~= nqId and nextId ~= hqId then
                SetServerVariable(pairVar, 0)
                SetServerVariable(pickVar, 0)
                return
            end

            -- The pick moves to a fresh spawn point and takes what is left
            -- of the saved window. The other one is unregistered. If that is
            -- the placeholder, this also drops the window its own initialize
            -- rolled. It stays down until the pick dies and schedules it
            -- again.
            if mobId == nextId then
                xi.mob.updateNMSpawnPoint(mob)
                mob:setRespawnTime(math.max(deadline - GetSystemTime(), 60))
            else
                mob:setRespawnTime(0)
            end
        end)
    end
end

-----------------------------------
-- Local var windows
-- These NMs keep their window in a local var instead of the engine respawn
-- timer. The script writes the end of the window into the var. A zone
-- handler checks the clock against it before rolling a spawn. A restart
-- wipes local vars, so the handler reads no cooldown left and pops the NM on
-- its next roll. Save the var when the NM goes down and put it back after
-- super at the next boot. Dosetsu Tree's window comes from the era module,
-- the rest from their base scripts. No 60 second floor here. The handler
-- treats a deadline that already passed as due.
-----------------------------------
local localVarNMs =
{
    -- { zone script folder, mob file name, local var }
    { 'Caedarva_Mire',    'Zikko',             'cooldown' },
    { 'Manaclipper',      'Zoredonite',        'respawn' },
    { 'Phanauet_Channel', 'Stubborn_Dredvodd', 'cooldown' },
    { 'Phanauet_Channel', 'Vodyanoi',          'respawn' },
    { 'Qufim_Island',     'Dosetsu_Tree',      'respawn' },
    { 'Sacrarium',        'Elel',              'cooldown' },
}

for _, entry in ipairs(localVarNMs) do
    local zoneName = entry[1]
    local mobName  = entry[2]
    local localVar = entry[3]
    local varName  = varPrefix .. mobName

    m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobInitialize', zoneName, mobName), function(mob)
        super(mob)

        mob:addListener('DESPAWN', 'PXI_TNM_DESPAWN', function(mobArg)
            SetServerVariable(varName, mobArg:getLocalVar(localVar))
        end)

        -- This runs after the script's own onMobSpawn. Stubborn Dredvodd and
        -- Vodyanoi set their next window there, so saving here catches the
        -- fresh value. The other four set theirs on death or despawn. Their
        -- var is empty or already past due, so the write changes nothing.
        mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
            SetServerVariable(varName, mobArg:getLocalVar(localVar))
        end)

        local deadline = GetServerVariable(varName)
        if deadline > 0 then
            mob:setLocalVar(localVar, deadline)
        end
    end)
end

-----------------------------------
-- King Vinegarroon (Western Altepa Desert)
-- He is in the generic list above, so a restart brings his window back. Only
-- the zone weather handler ever lets him pop. It allows him on a sand storm,
-- and on a coin flip during a dust storm. Any other weather disallows him.
-- Boot does fire that handler once, after zone init. It cannot help here.
-- Its allow branch only runs when the respawn time is zero, and a restored
-- window is not zero, so the handler passes him over without allowing or
-- disallowing anything. Meanwhile the boot spawn pass has already re-allowed
-- him, because it re-allows any scripted mob holding a pending respawn. His
-- held window would then end on a spawn wave and pop him with no weather
-- roll. Zone init runs after that pass, so disallow him there and let the
-- handler decide from the next weather change on.
-----------------------------------
m:addOverride('xi.zones.Western_Altepa_Desert.Zone.onInitialize', function(zone)
    super(zone)

    DisallowRespawn(zones[xi.zone.WESTERN_ALTEPA_DESERT].mob.KING_VINEGARROON, true)
end)

-----------------------------------
-- Odqan (Misareaux Coast)
-- Two entities share one window. The base despawn rolls which of the pair
-- comes back. It marks that one with the canSpawn local var and gives it a
-- 2 to 5 hour timer. Local vars die at a restart, so the pick is saved next
-- to the deadline. Fog does not hold the pop off. The zone weather handler
-- only runs when the weather turns to fog. All it does there is pick which
-- twin is allowed. A held pop arrives in any weather, same as the base roll.
-- He despawns himself at the next weather change that is not fog.
-----------------------------------
local odqanIds         = zones[xi.zone.MISAREAUX_COAST].mob.ODQAN
local odqanVar         = varPrefix .. 'Odqan'
local odqanPickVar     = odqanVar .. '_Next'
local odqanTwinHoldVar = varPrefix .. 'twinHold'

m:addOverride('xi.zones.Misareaux_Coast.mobs.Odqan.onMobDespawn', function(mob)
    super(mob)

    -- super just rolled the next of the pair and started its window. The
    -- winner carries the canSpawn flag, so save that one's deadline. A roll
    -- that lands on a twin already up saves nothing, since setRespawnTime
    -- does not register a spawned mob. Both twins are up after a boot with
    -- nothing saved, and after a ghost pop of the loser.
    for _, id in ipairs(odqanIds) do
        local odqan = GetMobByID(id)
        if odqan then
            local isPick    = odqan:getLocalVar('canSpawn') == 1
            local remaining = odqan:getRespawnTime()

            if isPick and remaining > 0 then
                SetServerVariable(odqanVar, GetSystemTime() + remaining)
                SetServerVariable(odqanPickVar, id)
            end

            -- This twin was parked on a week long respawn at boot. A real
            -- roll has now happened, so that hold is no longer needed. If
            -- the roll picked this twin, super's setRespawnTime already
            -- replaced the week. If it picked the other one, drop the week
            -- here so it never fires.
            if odqan:getLocalVar(odqanTwinHoldVar) == 1 then
                odqan:setLocalVar(odqanTwinHoldVar, 0)

                if not isPick then
                    odqan:setRespawnTime(0)
                end
            end
        end
    end
end)

m:addOverride('xi.zones.Misareaux_Coast.mobs.Odqan.onMobInitialize', function(mob)
    super(mob)

    local mobId = mob:getID()

    -- The mob's own respawn window, read before the hold below overwrites
    -- it. The SPAWN listener puts this value back.
    local baseWindow = GetMobRespawnTime(mobId)

    mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
        -- The base roll only re-times the winner. The loser keeps whatever
        -- registration it had from an earlier cycle and can still ghost pop
        -- on its own. Clearing on any spawn would throw away the window the
        -- real pick is still holding. Only the pick's spawn clears it.
        if mobArg:getID() == GetServerVariable(odqanPickVar) then
            SetServerVariable(odqanVar, 0)
        end

        if baseWindow > 0 then
            mobArg:setRespawnTime(baseWindow)
        end
    end)

    local deadline = GetServerVariable(odqanVar)
    local nextId   = GetServerVariable(odqanPickVar)

    -- Nothing usable was saved, so leave both entities alone. They boot
    -- spawn the way the base server does, and the next real despawn roll
    -- writes fresh values.
    if
        deadline == 0 or
        (nextId ~= odqanIds[1] and nextId ~= odqanIds[2])
    then
        return
    end

    local remaining = deadline - GetSystemTime()

    -- The pick takes the saved remainder and stays down until that window
    -- ends. The boot spawn pass skips any mob that already holds a pending
    -- respawn. The twin has to stay down too, and no flag can do that.
    -- DisallowRespawn and setRespawnTime(0) both block by clearing the allow
    -- flag. The engine reassigns that flag right after onMobInitialize
    -- returns. A pending respawn is the one thing the boot pass honors, so
    -- the twin holds a week. The despawn override above drops that week at
    -- the next real roll.
    if mobId == nextId then
        mob:setLocalVar('canSpawn', 1)

        if remaining > 0 then
            mob:setRespawnTime(remaining)
        end
    else
        mob:setLocalVar('canSpawn', 0)
        mob:setLocalVar(odqanTwinHoldVar, 1)
        mob:setRespawnTime(604800)
    end
end)

-----------------------------------
-- Carmine Dobsonfly (Riverne - Site A01)
-- A dead fly stays down until all ten are dead. The tenth death rolls one
-- 21 to 24 hour window and hands the same value to all ten. They come back
-- as a group, so there is one deadline to save instead of ten timers. Every
-- fly gets the same remainder at the next boot and pops together.
--
-- A restart before the tenth fly dies has no window to save. The dead flies
-- boot spawn, same as the base server.
-----------------------------------
local dobsonflyVar = varPrefix .. 'Carmine_Dobsonfly'

m:addOverride('xi.zones.Riverne-Site_A01.mobs.Carmine_Dobsonfly.onMobDespawn', function(mob)
    super(mob)

    -- super only rolls the group window once the tenth fly is down. Repeat
    -- that check here. With a fly still up there is nothing to save yet.
    local offset = zones[xi.zone.RIVERNE_SITE_A01].mob.CARMINE_DOBSONFLY_OFFSET
    for id = offset, offset + 9 do
        if GetMobByID(id):isAlive() then
            return
        end
    end

    local remaining = mob:getRespawnTime()
    if remaining > 0 then
        SetServerVariable(dobsonflyVar, GetSystemTime() + remaining)
    end
end)

m:addOverride('xi.zones.Riverne-Site_A01.mobs.Carmine_Dobsonfly.onMobInitialize', function(mob)
    super(mob)

    -- A fly's own long window is the only thing keeping an early kill down
    -- until the full clear. The hold at the bottom overwrites that window
    -- with the saved remainder. A fly killed on the short value would pop
    -- back mid hunt. Read the boot window now and put it back on every spawn.
    local baseWindow = GetMobRespawnTime(mob:getID())

    mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
        SetServerVariable(dobsonflyVar, 0)

        if baseWindow > 0 then
            mobArg:setRespawnTime(baseWindow)
        end
    end)

    local deadline = GetServerVariable(dobsonflyVar)
    if deadline > 0 then
        mob:setRespawnTime(math.max(deadline - GetSystemTime(), 60))
    end
end)

-----------------------------------
-- Lumber Jack (Batallia Downs)
-- Weeping Willow's despawn spawns Lumber Jack where she fell. His own
-- despawn is what gives her a real window. 21 to 24 hours if he was killed,
-- 30 minutes if he idled out. She is in the generic list, so her despawn
-- already saved a deadline. His despawn saves the new one over it.
--
-- A server variable tracks whether he is up, since a restart wipes local
-- vars. It brings him back after a restart during his ten minute life.
-----------------------------------
local lumberJackUpVar = varPrefix .. 'Lumber_Jack_Up'
local willowVar       = varPrefix .. 'Weeping_Willow'

m:addOverride('xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobInitialize', function(mob)
    super(mob)

    if GetServerVariable(lumberJackUpVar) == 0 then
        return
    end

    -- The boot spawn pass leaves scripted mobs down, but re-allows one that
    -- registered a respawn during initialize. A one second window puts him on
    -- the next spawn wave. Bring him back only if the Willow has longer left
    -- than his ten minute idle life plus two 30 second spawn waves. Any
    -- closer and his idle despawn lands right around her pop and resets her
    -- window to 30 minutes. Drop the flag and leave him down instead.
    if GetServerVariable(willowVar) - GetSystemTime() > mob:getMobMod(xi.mobMod.IDLE_DESPAWN) + 60 then
        mob:setRespawnTime(1)
    else
        SetServerVariable(lumberJackUpVar, 0)
    end
end)

m:addOverride('xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobDeath', function(mob, player, optParams)
    super(mob, player, optParams)

    -- Clear the up flag here, not just in the despawn override. His despawn
    -- hook runs about 18 seconds after the kill. A restart in that gap would
    -- bring him back with a fresh drop pool.
    SetServerVariable(lumberJackUpVar, 0)
end)

m:addOverride('xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobSpawn', function(mob)
    super(mob)

    SetServerVariable(lumberJackUpVar, 1)

    -- setRespawnTime is permanent, so a boot pop still carries the one
    -- second from the gate above. His next despawn would register a respawn
    -- from that value before any Lua runs. A spawn wave during the three
    -- second fade would pop him right back. Clear it. Only the Willow's
    -- despawn pops him.
    mob:setRespawnTime(0)
end)

m:addOverride('xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobDespawn', function(mob)
    super(mob)

    -- super just handed the Willow her real window, 21 to 24 hours or 30
    -- minutes. That makes the deadline her own despawn saved stale. Save the
    -- new one over it. She sits six IDs below him, the offset his script uses.
    local remaining = GetMobByID(mob:getID() - 6):getRespawnTime()
    if remaining > 0 then
        SetServerVariable(willowVar, GetSystemTime() + remaining)
    end

    SetServerVariable(lumberJackUpVar, 0)
end)
