-----------------------------------
-- Timed NM Respawn Persistence
-- Keeps the remaining respawn window of open world timed NMs across a map
-- server restart. Boot spawns every down NM fresh, so a restart hands out
-- free pops.
--
-- Each NM saves its remaining window to a server variable when it goes down.
-- At the next boot its onMobInitialize override registers that time again,
-- and the boot spawn pass skips mobs with a pending respawn. A held NM never
-- appears and pops through the normal engine path when the window ends.
--
-- The engine registers a despawning mob's respawn before any Lua despawn
-- hook runs, so getRespawnTime() in the save listener is already the final
-- window. Nothing in here invents or rerolls a timer.
--
-- Covers open world NMs with a window of an hour or more. Quest, mission,
-- battlefield, lottery, spawn slot, popped, dynamic and instanced content is
-- out.
--
-- Plenty of NMs roll a window in onMobInitialize as well. That roll is a boot
-- convention, not the respawn timer, so it does not decide anything here. What
-- counts is the window the despawn handler sets. The hold runs after super, so
-- it replaces whatever the boot rolled.
--
-- One thing this does not fix. An NM that registers a respawn in its own
-- initialize never boot spawns, so a restart while it is up loses it for a
-- fresh window. That is how the base server already behaves and nothing here
-- makes it worse.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('pxi_timed_nm_respawn_persistence')

-- server_variables.name is varchar(50). The prefix plus the longest mob name
-- below is 33 characters.
local varPrefix = '[PXI][TNM]'

local function deadlineOf(name)
    return GetServerVariable(varPrefix .. name)
end

local function saveDeadline(name, remaining)
    SetServerVariable(varPrefix .. name, GetSystemTime() + remaining)
end

local function clearDeadline(name)
    SetServerVariable(varPrefix .. name, 0)
end

-----------------------------------
-- Single entity NMs
-----------------------------------

-- A deadline only exists while the NM is down. Spawning clears it, so a
-- stale value can never hold a living NM down. Spawning also puts the boot
-- window back. setRespawnTime overwrites what the zone data loaded, and an
-- NM whose script never rolls its own window would keep the shortened one on
-- every later death.
local function watchNM(mob, name, baseWindow)
    mob:addListener('DESPAWN', 'PXI_TNM_DESPAWN', function(mobArg)
        local remaining = mobArg:getRespawnTime()
        if remaining > 0 then
            saveDeadline(name, remaining)
        end
    end)

    mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
        clearDeadline(name)

        if baseWindow > 0 then
            mobArg:setRespawnTime(baseWindow)
        end
    end)
end

-- Runs during initialization, so the registration lands before the boot
-- spawn pass. An expired deadline needs nothing. The mob boot spawns
-- normally and the spawn listener clears the leftover variable.
local function holdNM(mob, name)
    local remaining = deadlineOf(name) - GetSystemTime()
    if remaining > 0 then
        mob:setRespawnTime(remaining)
    end
end

-- The era module already persists Roc, Morbolger, Capricious Cassie,
-- Bloodsucker, Juggler Hecatomb and Manipulator through its own variables and
-- its zone init runs last, so it stays authoritative for them. They are listed
-- anyway. Both sides save the same window, and these keep working if that
-- module is ever gated off.

-- { zone script folder, { mob file names } }
local timedNMs =
{
    { 'Arrapago_Reef',          { 'Lamie_No9' } },
    { 'Attohwa_Chasm',          { 'Tiamat', 'Xolotl' } },
    { 'Batallia_Downs',         { 'Ahtu', 'Weeping_Willow' } },
    { 'Bostaunieux_Oubliette',  { 'Bloodsucker_NM', 'Drexerion_the_Condemned', 'Phanduron_the_Condemned' } },
    { 'Caedarva_Mire',          { 'Aynu-kaysey' } },
    { 'Cape_Teriggan',          { 'Kreutzet' } },
    { 'Castle_Zvahl_Baileys',   { 'Duke_Haborym', 'Grand_Duke_Batym', 'Marquis_Allocen', 'Marquis_Amon' } },
    { 'Den_of_Rancor',          { 'Tonberry_Pontifex' } },
    { 'Eastern_Altepa_Desert',  { 'Cactrot_Rapido' } },
    { 'FeiYin',                 { 'Capricious_Cassie' } },
    { 'Garlaige_Citadel',       { 'Old_Two-Wings', 'Serket', 'Skewer_Sam' } },
    { 'Gusgen_Mines',           { 'Juggler_Hecatomb' } }, -- Held so claim shield cannot cancel the era module's boot depop.
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
    { 'Temple_of_Uggalepih',    { 'Manipulator' } }, -- Held so claim shield cannot cancel the era module's boot depop.
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

-- TODO: add the Besieged stronghold NMs once Besieged goes in. They are
-- disabled today, so their overrides error at startup. Lamie No.7 and
-- Merrow No.5 have no script file either, so they also need the table path
-- created with xi.module.ensureTable before the override is declared.
--   Arrapago Reef  Lamie_No7, Medusa, Merrow_No5
--   Halvung        Dorgerwor_the_Astute
--   Mamook         Darting_Kachaal_Ja, Dragonscaled_Bugaal_Ja,
--                  Gulool_Ja_Ja, Hundredfaced_Hapool_Ja
--
-- Hundredfaced Hapool Ja needs a guard when it comes back. Its four Utsusemi
-- clones spawn under the same name and run the same handler, so only the
-- entity matching zones[xi.zone.MAMOOK].mob.HUNDRED_FACE_HAPOOL_JA should be
-- given a window.

-- TODO: add the WotG NMs when that content is turned on. Their templates are
-- content: wotg, so the entities do not exist today and declaring the
-- overrides now leaves an unapplied override error at every boot.
--   Arrapago Reef          Euryale
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

for _, entry in ipairs(timedNMs) do
    local zoneName = entry[1]

    for _, mobName in ipairs(entry[2]) do
        m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobInitialize', zoneName, mobName), function(mob)
            super(mob)

            -- The full window, read before the hold can shorten it. For an NM
            -- that rolled its own in super this is that roll, which its next
            -- despawn overwrites anyway.
            watchNM(mob, mobName, GetMobRespawnTime(mob:getID()))
            holdNM(mob, mobName)
        end)
    end
end

-----------------------------------
-- Cerberus (Mount Zhayolm)
-- The zone hands him a fresh 12 to 36 hours at every boot, and zone init runs
-- after every mob initialize, so it lands on top of the hold. Put the saved
-- window back once the zone has had its say. Nothing saved leaves the zone's
-- roll alone.
-----------------------------------
m:addOverride('xi.zones.Mount_Zhayolm.Zone.onInitialize', function(zone)
    super(zone)

    local remaining = deadlineOf('Cerberus') - GetSystemTime()
    if remaining > 0 then
        GetMobByID(zones[xi.zone.MOUNT_ZHAYOLM].mob.CERBERUS):setRespawnTime(remaining)
    end
end)

-----------------------------------
-- Odqan (Misareaux Coast)
-- Two entities share one window. A despawn picks the next of the pair, marks
-- it with the canSpawn local var and hands it the timer. The pop arrives in
-- any weather, same as the base roll. Fog only drives the zone weather
-- handler's flags. Local vars die with the restart, so the pick is saved
-- alongside the window.
-----------------------------------
local odqanVar         = 'Odqan'
local odqanPickVar     = 'Odqan_Next'
local odqanTwinHoldVar = '[PXI][TNM]twinHold'

m:addOverride('xi.zones.Misareaux_Coast.mobs.Odqan.onMobDespawn', function(mob)
    super(mob)

    -- super just picked the next of the pair and gave it the window.
    for _, id in ipairs(zones[xi.zone.MISAREAUX_COAST].mob.ODQAN) do
        local odqan = GetMobByID(id)
        if odqan then
            if odqan:getLocalVar('canSpawn') == 1 then
                local remaining = odqan:getRespawnTime()
                if remaining > 0 then
                    saveDeadline(odqanVar, remaining)
                    SetServerVariable(varPrefix .. odqanPickVar, id)
                end
            end

            -- A real pair roll has happened, so any boot hold is done. A
            -- roll that picked the held twin already replaced the hold with
            -- its setRespawnTime. Otherwise unregister it.
            if odqan:getLocalVar(odqanTwinHoldVar) == 1 then
                odqan:setLocalVar(odqanTwinHoldVar, 0)

                if odqan:getLocalVar('canSpawn') == 0 then
                    odqan:setRespawnTime(0)
                end
            end
        end
    end
end)

m:addOverride('xi.zones.Misareaux_Coast.mobs.Odqan.onMobInitialize', function(mob)
    super(mob)

    local baseWindow = GetMobRespawnTime(mob:getID())

    mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
        -- The base roll leaves the losing twin's old registration alive, so
        -- its ghost pop can arrive while the real pick still holds the
        -- window. Only the pick's spawn consumes the saved deadline.
        if mobArg:getID() == GetServerVariable(varPrefix .. odqanPickVar) then
            clearDeadline(odqanVar)
        end

        if baseWindow > 0 then
            mobArg:setRespawnTime(baseWindow)
        end
    end)

    local odqanIds = zones[xi.zone.MISAREAUX_COAST].mob.ODQAN
    local deadline = deadlineOf(odqanVar)
    local nextId   = GetServerVariable(varPrefix .. odqanPickVar)

    -- Nothing usable saved. Both copies boot spawn, same as the base server,
    -- and the spawn listeners clean the variables up.
    if deadline == 0 or (nextId ~= odqanIds[1] and nextId ~= odqanIds[2]) then
        return
    end

    local remaining = deadline - GetSystemTime()

    if mob:getID() == nextId then
        mob:setLocalVar('canSpawn', 1)

        -- An ended window needs nothing. The pick boot spawns normally.
        if remaining > 0 then
            -- Registered before the boot spawn pass, so the pick stays down
            -- and pops through the engine when the window ends.
            mob:setRespawnTime(remaining)
        end
    else
        -- Holds the twin through the boot spawn pass. The engine reassigns
        -- the allow flag right after every onMobInitialize returns, so
        -- DisallowRespawn does not survive to the spawn loop. A registration
        -- does. The week never matures. The next pair roll replaces or drops
        -- it, and Odqan despawns on every non fog weather change.
        mob:setLocalVar('canSpawn', 0)
        mob:setLocalVar(odqanTwinHoldVar, 1)
        mob:setRespawnTime(604800)
    end
end)

-----------------------------------
-- Carmine Dobsonfly (Riverne - Site A01)
-- Ten flies share one window. Each stays down as it dies and the group only
-- rolls a new window once the last one is dead, so one cohort deadline is
-- saved rather than ten timers. Every held fly registers the same remaining
-- time and the group pops together. A restart mid hunt, before the group
-- window rolls, revives the dead flies the same way it always has.
-----------------------------------
local dobsonflyVar = 'Carmine_Dobsonfly'

m:addOverride('xi.zones.Riverne-Site_A01.mobs.Carmine_Dobsonfly.onMobDespawn', function(mob)
    super(mob)

    -- The group only gets a window once the last of the ten is dead.
    local offset = zones[xi.zone.RIVERNE_SITE_A01].mob.CARMINE_DOBSONFLY_OFFSET
    for id = offset, offset + 9 do
        local fly = GetMobByID(id)
        if fly and fly:isAlive() then
            return
        end
    end

    local remaining = mob:getRespawnTime()
    if remaining > 0 then
        saveDeadline(dobsonflyVar, remaining)
    end
end)

m:addOverride('xi.zones.Riverne-Site_A01.mobs.Carmine_Dobsonfly.onMobInitialize', function(mob)
    super(mob)

    -- Nothing but this window holds an early kill down until the full clear.
    -- A shortened leftover would pop dead flies back mid hunt, so the boot
    -- value comes back on every spawn.
    local baseWindow = GetMobRespawnTime(mob:getID())

    mob:addListener('SPAWN', 'PXI_TNM_SPAWN', function(mobArg)
        clearDeadline(dobsonflyVar)

        if baseWindow > 0 then
            mobArg:setRespawnTime(baseWindow)
        end
    end)

    holdNM(mob, dobsonflyVar)
end)

-----------------------------------
-- Lumber Jack (Batallia Downs)
-- Weeping Willow persists through the generic list, but her window is really
-- Lumber Jack's to set. His despawn gives her 21 to 24 hours on a kill and 30
-- minutes on an idle despawn, overwriting what her own death registered, so
-- the deadline is saved again once he decides. His up flag is kept so a
-- restart during his short lifetime brings him back.
-----------------------------------
local lumberJackUpVar = varPrefix .. 'Lumber_Jack_Up'

m:addOverride('xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobInitialize', function(mob)
    super(mob)

    -- The boot spawn pass leaves scripted mobs down, but it re-allows one
    -- that registered a respawn here, so a short timer brings him back.
    if GetServerVariable(lumberJackUpVar) == 1 then
        mob:setRespawnTime(1)
    end
end)

m:addOverride('xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobSpawn', function(mob)
    super(mob)

    SetServerVariable(lumberJackUpVar, 1)

    -- Drop the boot repop timer now that he is up. Left armed, his despawn
    -- would register it again and a spawn wave landing during the fade would
    -- pop him right back.
    mob:setRespawnTime(0)
end)

m:addOverride('xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobDespawn', function(mob)
    super(mob)

    -- super just set the Willow's real window, so the deadline her own death
    -- saved is stale
    local willow = GetMobByID(mob:getID() - 6)
    if willow then
        local remaining = willow:getRespawnTime()
        if remaining > 0 then
            saveDeadline('Weeping_Willow', remaining)
        end
    end

    SetServerVariable(lumberJackUpVar, 0)
end)
