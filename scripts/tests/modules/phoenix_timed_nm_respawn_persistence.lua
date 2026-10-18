-- Loads the real module and mob scripts with isolated engine bindings.
describe('Module: timed NM persistence', function()
    local function equal(actual, expected, message)
        assert(actual == expected, (message or 'unexpected value') .. ': expected ' .. tostring(expected) .. ', got ' .. tostring(actual))
    end

    local function enum()
        return setmetatable({},
        {
            __index = function(_, key)
                return key
            end,
        })
    end

    local function newWorld(stored, clock)
        local w = { vars = stored or {}, now = clock or 2000000, mobs = {}, order = {}, writes = {}, moved = {} }
        local env = setmetatable({}, { __index = _G })
        local xi =
        {
            zone = enum(), zones = {}, mod = enum(), mobMod = enum(), immunity = enum(),
            weather = enum(), element = enum(), effect = enum(), title = enum(), mobSkill = enum(),
            settings = { main = { NM_LOTTERY_CHANCE = 1, NM_LOTTERY_COOLDOWN = 1 } },
            mob = {}, pet = {}, hunts = {},
        }
        env.xi = xi
        env.zones = setmetatable({},
        {
            __index = function(t, key)
                local ids =
                {
                    mob = setmetatable({ ODQAN = { 1001, 1002 } },
                    {
                        __index = function()
                            return 1000
                        end,
                    }),
                    npc = enum(), text = enum(),
                }
                rawset(t, key, ids)
                return ids
            end,
        })
        env.require = function()
        end

        xi.pet.setMobPet = function()
        end

        xi.hunts.checkHunt = function()
        end

        xi.mob.updateNMSpawnPoint = function(mob)
            table.insert(w.moved, type(mob) == 'number' and mob or mob:getID())
        end

        env.math = setmetatable(
        {
            randomInt = function(low, high)
                return w.roll and w.roll(low, high) or low
            end,
        }, { __index = math })
        env.GetSystemTime = function()
            return w.now
        end

        env.VanadielHour = function()
            return 12
        end

        env.GetServerVariable = function(key)
            return w.vars[key] or 0
        end

        env.SetServerVariable = function(key, value)
            assert(#key <= 50, 'server variable key exceeds database column')
            w.vars[key] = value
            table.insert(w.writes, { key = key, value = value })
        end

        env.GetMobByID = function(id)
            return w.mobs[id]
        end

        env.GetNPCByID = function()
            return nil
        end

        env.GetMobRespawnTime = function(id)
            return assert(w.mobs[id], 'unknown mob ' .. tostring(id)).base
        end

        env.DisallowRespawn = function(id, disallow)
            assert(w.mobs[id]).allowed = not disallow
        end

        env.SpawnMob = function(id)
            local mob = assert(w.mobs[id])
            w.spawn(mob)
            return mob
        end

        env.DespawnMob = function(id)
            w.despawn(assert(w.mobs[id]))
        end

        local methods = {}
        function methods:getID()
            return self.id
        end

        function methods:getName()
            return self.name
        end

        function methods:getZoneName()
            return self.zone
        end

        function methods:getLocalVar(key)
            return self.vars[key] or 0
        end

        function methods:setLocalVar(key, value)
            self.vars[key] = value
        end

        function methods:setMod(key, value)
            self.mods[key] = value
        end

        function methods:addMod(key, value)
            self.mods[key] = (self.mods[key] or 0) + value
        end

        function methods:setMobMod(key, value)
            self.mods[key] = value
        end

        function methods:getMobMod(key)
            return self.mods[key] or 0
        end

        function methods:addImmunity(key)
            self.immunities[key] = true
        end

        function methods:isSpawned()
            return self.spawned
        end

        function methods:isAlive()
            return self.spawned and not self.dead
        end

        function methods:isEngaged()
            return false
        end

        function methods:spawn()
            w.spawn(self)
        end

        function methods:despawn()
            w.despawn(self)
        end

        function methods:getWeather()
            return self.weather
        end

        function methods:setMagicCastingEnabled(enabled)
            self.magic = enabled
        end

        function methods:setSpawn(x, y, z)
            self.position = { x, y, z }
        end

        function methods:getXPos()
            return self.position[1]
        end

        function methods:getYPos()
            return self.position[2]
        end

        function methods:getZPos()
            return self.position[3]
        end

        function methods:hideName(hidden)
            self.hidden = hidden
        end

        function methods:setUntargetable(value)
            self.untargetable = value
        end

        function methods:setAnimationSub(value)
            self.animation = value
        end

        function methods:stun(duration)
            self.stunDuration = duration
        end

        function methods:timer(delay, callback)
            table.insert(self.timers, { delay, callback })
        end

        function methods:getRespawnTime()
            return self.pending and math.max(0, self.pending - w.now) or 0
        end

        function methods:setRespawnTime(seconds)
            self.base = seconds
            self.allowed = seconds > 0
            if seconds == 0 then
                self.pending = nil
            elseif not self.spawned then
                self.pending = w.now + seconds
            end
        end

        function methods:removeListener(name)
            if self.triggerDepth > 0 then
                self.deferred[name] = true
                return
            end

            for _, list in pairs(self.listeners) do
                for index = #list, 1, -1 do
                    if list[index].name == name then
                        table.remove(list, index)
                    end
                end
            end
        end

        function methods:addListener(event, name, callback)
            self:removeListener(name)
            self.listeners[event] = self.listeners[event] or {}
            table.insert(self.listeners[event], { name = name, callback = callback })
        end

        w.env, w.xi = env, xi
        w.setIds = function(zone, ids)
            env.zones[zone].mob = ids
        end

        w.addMob = function(zone, name, id, base, scripted)
            xi.zones[zone] = xi.zones[zone] or { mobs = {}, Zone = {} }
            local mob = setmetatable(
            {
                id = id, name = name, zone = zone, base = base, scripted = scripted ~= false,
                vars = {}, mods = {}, immunities = {}, listeners = {}, deferred = {}, timers = {},
                position = { 1, 2, 3 }, triggerDepth = 0, spawned = false, allowed = false, spawns = 0,
            }, { __index = methods })
            w.mobs[id] = mob
            table.insert(w.order, mob)
            return mob
        end

        w.loadMob = function(zone, name)
            xi.zones[zone].mobs[name] = setfenv(assert(loadfile('scripts/zones/' .. zone .. '/mobs/' .. name .. '.lua')), env)()
        end

        w.setZoneHandler = function(zone, name, callback)
            xi.zones[zone] = xi.zones[zone] or { mobs = {}, Zone = {} }
            xi.zones[zone].Zone[name] = setfenv(callback, env)
        end

        w.applyModule = function(earlierModule)
            setfenv(assert(loadfile('modules/module_utils.lua')), env)()
            if earlierModule then
                setfenv(assert(loadfile(earlierModule)), env)()
            end

            setfenv(assert(loadfile('modules/phoenix/lua/custom/pxi_timed_nm_respawn_persistence.lua')), env)()
            w.overrides = {}
            for _, module in ipairs(xi.module.registry) do
                for _, override in ipairs(module.overrides) do
                    table.insert(w.overrides, override)
                    local zone, name, handler = override.name:match('^xi%.zones%.([^.]+)%.mobs%.([^.]+)%.([^.]+)$')
                    local target = zone and xi.zones[zone] and xi.zones[zone].mobs[name]
                    if not zone then
                        zone, handler = override.name:match('^xi%.zones%.([^.]+)%.Zone%.([^.]+)$')
                        target = zone and xi.zones[zone] and xi.zones[zone].Zone
                    end

                    if
                        target and
                        module.enabled and
                        (override.enabled == nil or override.enabled)
                    then
                        target[handler] = target[handler] or setfenv(function()
                        end, env)

                        env.applyOverride(target, handler, override.func)
                    end
                end
            end
        end

        w.call = function(mob, handler, ...)
            if handler == 'onMobDeath' then
                mob.dead = true
            end

            local callback = xi.zones[mob.zone].mobs[mob.name][handler]
            if callback then
                return callback(mob, ...)
            end
        end

        w.trigger = function(mob, event, ...)
            mob.triggerDepth = mob.triggerDepth + 1
            for _, listener in ipairs(mob.listeners[event] or {}) do
                listener.callback(mob, ...)
            end

            mob.triggerDepth = mob.triggerDepth - 1
            if mob.triggerDepth == 0 then
                for name in pairs(mob.deferred) do
                    mob:removeListener(name)
                end

                mob.deferred = {}
            end
        end

        w.spawn = function(mob)
            -- Direct spawns leave registrations intact; the scheduler removes its batch first.
            mob.spawned, mob.dead, mob.vars = true, false, {}
            mob.spawns = mob.spawns + 1
            w.trigger(mob, 'PRESPAWN')
            w.call(mob, 'onMobSpawn')
            w.trigger(mob, 'SPAWN')
        end

        w.despawn = function(mob)
            mob.dead = true
            if mob.allowed then
                mob.pending = w.now + mob.base
            end

            w.now = w.now + 3
            mob.spawned = false
            w.call(mob, 'onMobDespawn')
            w.trigger(mob, 'DESPAWN')
        end

        w.initialize = function(order)
            for _, mob in ipairs(order or w.order) do
                w.call(mob, 'onMobInitialize')
                mob.allowed = not mob.scripted
            end

            for _, mob in ipairs(w.order) do
                if mob.pending and mob.base > 0 then
                    mob.allowed = true
                end
            end
        end

        w.boot = function(order)
            w.initialize(order)
            for _, mob in ipairs(w.order) do
                if not mob.pending and mob.allowed then
                    w.spawn(mob)
                end
            end

            for _, zone in pairs(xi.zones) do
                if zone.Zone.onInitialize then
                    zone.Zone.onInitialize({})
                end
            end
        end

        w.tick = function()
            local due = {}
            for _, mob in ipairs(w.order) do
                if mob.pending and mob.allowed and mob.pending <= w.now + 15 then
                    mob.pending = nil
                    table.insert(due, mob)
                end
            end

            for _, mob in ipairs(due) do
                w.spawn(mob)
            end
        end

        return w
    end

    it('registers every supported target once and leaves spawn-slot pairs alone', function()
        local w = newWorld()
        w.applyModule()

        local expected =
        {
            -- Single entity windows.
            'xi.zones.Arrapago_Reef.mobs.Lamia_No19.onMobInitialize',
            'xi.zones.Attohwa_Chasm.mobs.Tiamat.onMobInitialize',
            'xi.zones.Attohwa_Chasm.mobs.Xolotl.onMobInitialize',
            'xi.zones.Batallia_Downs.mobs.Ahtu.onMobInitialize',
            'xi.zones.Batallia_Downs.mobs.Weeping_Willow.onMobInitialize',
            'xi.zones.Bostaunieux_Oubliette.mobs.Bloodsucker_NM.onMobInitialize',
            'xi.zones.Bostaunieux_Oubliette.mobs.Drexerion_the_Condemned.onMobInitialize',
            'xi.zones.Bostaunieux_Oubliette.mobs.Phanduron_the_Condemned.onMobInitialize',
            'xi.zones.Caedarva_Mire.mobs.Khimaira.onMobInitialize',
            'xi.zones.Cape_Teriggan.mobs.Kreutzet.onMobInitialize',
            'xi.zones.Castle_Zvahl_Baileys.mobs.Duke_Haborym.onMobInitialize',
            'xi.zones.Castle_Zvahl_Baileys.mobs.Grand_Duke_Batym.onMobInitialize',
            'xi.zones.Castle_Zvahl_Baileys.mobs.Marquis_Allocen.onMobInitialize',
            'xi.zones.Castle_Zvahl_Baileys.mobs.Marquis_Amon.onMobInitialize',
            'xi.zones.Den_of_Rancor.mobs.Tonberry_Pontifex.onMobInitialize',
            'xi.zones.Eastern_Altepa_Desert.mobs.Cactrot_Rapido.onMobInitialize',
            'xi.zones.Eastern_Altepa_Desert.mobs.Centurio_XII-I.onMobInitialize',
            'xi.zones.FeiYin.mobs.Capricious_Cassie.onMobInitialize',
            'xi.zones.Garlaige_Citadel.mobs.Old_Two-Wings.onMobInitialize',
            'xi.zones.Garlaige_Citadel.mobs.Serket.onMobInitialize',
            'xi.zones.Garlaige_Citadel.mobs.Skewer_Sam.onMobInitialize',
            'xi.zones.Gusgen_Mines.mobs.Juggler_Hecatomb.onMobInitialize',
            'xi.zones.Gustav_Tunnel.mobs.Bune.onMobInitialize',
            'xi.zones.Ifrits_Cauldron.mobs.Ash_Dragon.onMobInitialize',
            'xi.zones.Inner_Horutoto_Ruins.mobs.Maltha.onMobInitialize',
            'xi.zones.Jugner_Forest.mobs.Meteormauler_Zhagtegg.onMobInitialize',
            'xi.zones.King_Ranperres_Tomb.mobs.Vrtra.onMobInitialize',
            'xi.zones.Kuftal_Tunnel.mobs.Guivre.onMobInitialize',
            'xi.zones.Labyrinth_of_Onzozo.mobs.Mysticmaker_Profblix.onMobInitialize',
            'xi.zones.Meriphataud_Mountains.mobs.Coo_Keja_the_Unseen.onMobInitialize',
            'xi.zones.Meriphataud_Mountains.mobs.Waraxe_Beak.onMobInitialize',
            'xi.zones.Misareaux_Coast.mobs.Upyri.onMobInitialize',
            'xi.zones.Mount_Zhayolm.mobs.Cerberus.onMobInitialize',
            'xi.zones.Ordelles_Caves.mobs.Morbolger.onMobInitialize',
            'xi.zones.Palborough_Mines.mobs.NoMho_Crimsonarmor.onMobInitialize',
            'xi.zones.Pashhow_Marshlands.mobs.BoWho_Warmonger.onMobInitialize',
            'xi.zones.Phomiuna_Aqueducts.mobs.Tres_Duendes.onMobInitialize',
            'xi.zones.Promyvion-Dem.mobs.Satiator.onMobInitialize',
            'xi.zones.Promyvion-Holla.mobs.Cerebrator.onMobInitialize',
            'xi.zones.Promyvion-Mea.mobs.Coveter.onMobInitialize',
            'xi.zones.Quicksand_Caves.mobs.Antican_Consul.onMobInitialize',
            'xi.zones.Quicksand_Caves.mobs.Proconsul_XII.onMobInitialize',
            'xi.zones.Riverne-Site_B01.mobs.Boroka.onMobInitialize',
            'xi.zones.RoMaeve.mobs.Shikigami_Weapon.onMobInitialize',
            'xi.zones.Rolanberry_Fields.mobs.Simurgh.onMobInitialize',
            'xi.zones.Sauromugue_Champaign.mobs.Roc.onMobInitialize',
            'xi.zones.Sea_Serpent_Grotto.mobs.Ocean_Sahagin.onMobInitialize',
            'xi.zones.Temple_of_Uggalepih.mobs.Manipulator.onMobInitialize',
            'xi.zones.The_Boyahda_Tree.mobs.Ancient_Goobbue.onMobInitialize',
            'xi.zones.The_Eldieme_Necropolis.mobs.Anemone.onMobInitialize',
            'xi.zones.The_Shrine_of_RuAvitau.mobs.Faust.onMobInitialize',
            'xi.zones.The_Shrine_of_RuAvitau.mobs.Mother_Globe.onMobInitialize',
            'xi.zones.Toraimarai_Canal.mobs.Oni_Carcass.onMobInitialize',
            'xi.zones.Uleguerand_Range.mobs.Jormungand.onMobInitialize',
            'xi.zones.Uleguerand_Range.mobs.Mountain_Worm_NM.onMobInitialize',
            'xi.zones.VeLugannon_Palace.mobs.Zipacna.onMobInitialize',
            'xi.zones.Wajaom_Woodlands.mobs.Hydra.onMobInitialize',
            'xi.zones.Western_Altepa_Desert.mobs.King_Vinegarroon.onMobInitialize',
            'xi.zones.Yhoator_Jungle.mobs.Bisque-heeled_Sunberry.onMobInitialize',
            'xi.zones.Yhoator_Jungle.mobs.Bright-handed_Kunberry.onMobInitialize',
            'xi.zones.Yhoator_Jungle.mobs.Woodland_Sage.onMobInitialize',
            'xi.zones.Yuhtunga_Jungle.mobs.Meww_the_Turtlerider.onMobInitialize',

            -- Zone rolls replace the mob's boot timer.
            'xi.zones.Mount_Zhayolm.Zone.onInitialize',
            'xi.zones.Caedarva_Mire.Zone.onInitialize',

            -- Shared pairs.
            'xi.zones.Maze_of_Shakhrami.mobs.Argus.onMobDespawn',
            'xi.zones.Maze_of_Shakhrami.mobs.Argus.onMobInitialize',
            'xi.zones.Maze_of_Shakhrami.mobs.Leech_King.onMobDespawn',
            'xi.zones.Maze_of_Shakhrami.mobs.Leech_King.onMobInitialize',
            'xi.zones.Maze_of_Shakhrami.Zone.onInitialize',
            'xi.zones.Phomiuna_Aqueducts.mobs.Eba.onMobDespawn',
            'xi.zones.Phomiuna_Aqueducts.mobs.Eba.onMobInitialize',
            'xi.zones.Phomiuna_Aqueducts.mobs.Mahisha.onMobDespawn',
            'xi.zones.Phomiuna_Aqueducts.mobs.Mahisha.onMobInitialize',
            'xi.zones.Phomiuna_Aqueducts.Zone.onInitialize',

            -- Beastmen kings.
            'xi.zones.Castle_Oztroja.mobs.Yagudo_Avatar.onMobDespawn',
            'xi.zones.Castle_Oztroja.mobs.Tzee_Xicu_the_Manifest.onMobDespawn',
            'xi.zones.Castle_Oztroja.mobs.Yagudo_Avatar.onMobInitialize',
            'xi.zones.Castle_Oztroja.mobs.Tzee_Xicu_the_Manifest.onMobInitialize',
            'xi.zones.Monastic_Cavern.mobs.Orcish_Overlord.onMobDespawn',
            'xi.zones.Monastic_Cavern.mobs.Overlord_Bakgodek.onMobDespawn',
            'xi.zones.Monastic_Cavern.mobs.Orcish_Overlord.onMobInitialize',
            'xi.zones.Monastic_Cavern.mobs.Overlord_Bakgodek.onMobInitialize',
            'xi.zones.Qulun_Dome.mobs.Diamond_Quadav.onMobDespawn',
            'xi.zones.Qulun_Dome.mobs.ZaDha_Adamantking.onMobDespawn',
            'xi.zones.Qulun_Dome.mobs.Diamond_Quadav.onMobInitialize',
            'xi.zones.Qulun_Dome.mobs.ZaDha_Adamantking.onMobInitialize',

            -- Local variable windows.
            'xi.zones.Caedarva_Mire.mobs.Zikko.onMobInitialize',
            'xi.zones.Manaclipper.mobs.Zoredonite.onMobInitialize',
            'xi.zones.Phanauet_Channel.mobs.Stubborn_Dredvodd.onMobInitialize',
            'xi.zones.Phanauet_Channel.mobs.Vodyanoi.onMobInitialize',
            'xi.zones.Qufim_Island.mobs.Dosetsu_Tree.onMobInitialize',
            'xi.zones.Sacrarium.mobs.Elel.onMobInitialize',

            -- Weather, twin and group windows.
            'xi.zones.Western_Altepa_Desert.Zone.onInitialize',
            'xi.zones.Misareaux_Coast.mobs.Odqan.onMobDespawn',
            'xi.zones.Misareaux_Coast.mobs.Odqan.onMobInitialize',
            'xi.zones.Riverne-Site_A01.mobs.Carmine_Dobsonfly.onMobDespawn',
            'xi.zones.Riverne-Site_A01.mobs.Carmine_Dobsonfly.onMobInitialize',
            'xi.zones.Jugner_Forest.mobs.King_Arthro.onMobDespawn',
            'xi.zones.Jugner_Forest.mobs.King_Arthro.onMobInitialize',

            -- Lumber Jack also keeps his alive state.
            'xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobInitialize',
            'xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobDeath',
            'xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobSpawn',
            'xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobDespawn',
        }

        local expectedSet = {}
        for _, name in ipairs(expected) do
            equal(expectedSet[name], nil, 'duplicate expected target ' .. name)
            expectedSet[name] = true
        end

        local actual = {}
        for _, override in ipairs(w.overrides) do
            local name = override.name
            equal(name:find('%.mobs%.Fraelissa%.'), nil, 'Fraelissa uses a spawn slot')
            equal(name:find('%.mobs%.Fradubio%.'), nil, 'Fradubio uses a spawn slot')
            equal(actual[name], nil, 'duplicate registered target ' .. name)
            equal(expectedSet[name], true, 'unexpected registered target ' .. name)
            actual[name] = true
        end

        for _, name in ipairs(expected) do
            equal(actual[name], true, 'missing registered target ' .. name)
        end

        equal(#expected, 103, 'supported target manifest')
        equal(#w.overrides, #expected, 'registered target count')
    end)

    describe('Single timed NMs', function()
        local key = '[PXI][TNM]Simurgh'

        local function simurghWorld(saved, now, era)
            local w = newWorld(saved, now)
            w.nm = w.addMob('Rolanberry_Fields', 'Simurgh', 17248462, 3600)
            w.loadMob('Rolanberry_Fields', 'Simurgh')
            if era then
                w.xi.settings.main.RESTRICT_CONTENT = 1
                w.xi.settings.main.ENABLE_SOA = 0
                w.xi.settings.main.ENABLE_WOTG = 0
            end

            w.applyModule(era and 'modules/era/lua/globals/old_nm_respawn_timers.lua' or nil)
            return w
        end

        it('keeps the base initialization without a save', function()
            local w = simurghWorld()
            w.boot()
            equal(w.nm:getRespawnTime(), 3600)
            assert(not w.nm:isSpawned())
            assert(w.nm.immunities.DARK_SLEEP, 'base initialize was skipped')
            equal(#w.writes, 0)
        end)

        for _, remainder in ipairs({ -100, 0, 1, 59, 60, 61, 1800 }) do
            it('restores a saved timer with ' .. remainder .. ' seconds left', function()
                local w = simurghWorld({ [key] = 2000000 + remainder })
                w.boot()
                equal(w.nm:getRespawnTime(), math.max(remainder, 60))
                assert(not w.nm:isSpawned())
                w.now = w.nm.pending
                w.tick()
                assert(w.nm:isSpawned())
                equal(w.vars[key], 0)
                equal(w.nm.base, 3600, 'the restored remainder became permanent')
                w.roll = function(low, high)
                    return high
                end

                w.despawn(w.nm)
                equal(w.vars[key], w.now + 7200, 'save ran before the base despawn roll')
            end)
        end

        it('counts downtime through repeated restarts and retains the alive restart policy', function()
            local vars = { [key] = 2003600 }
            local w
            for _, now in ipairs({ 2000000, 2000600, 2001800 }) do
                w = simurghWorld(vars, now)
                w.boot()
                equal(w.nm.pending, 2003600)
                vars = w.vars
            end

            w.now = 2003600
            w.tick()
            w = simurghWorld(w.vars, w.now + 10)
            w.boot()
            equal(w.nm:getRespawnTime(), 3600)
            assert(not w.nm:isSpawned())
        end)

        it('saves after the era override and restores the era interval on spawn', function()
            local w = simurghWorld({ [key] = 2000600 }, nil, true)
            w.boot()
            equal(w.nm:getRespawnTime(), 600, 'era initialize overwrote the saved remainder')
            w.now = w.nm.pending
            w.tick()
            equal(w.nm.base, 75600)
            w.roll = function(low, high)
                return high
            end

            w.despawn(w.nm)
            equal(w.vars[key], w.now + 86400, 'base interval overwrote the era roll')
        end)

        it('restores the full interval even when the base script never rerolls on despawn', function()
            local w = simurghWorld({ [key] = 2000600 })
            w.xi.zones.Rolanberry_Fields.mobs.Simurgh.onMobDespawn = nil
            w.boot()
            w.now = w.nm.pending
            w.tick()
            local diedAt = w.now
            w.despawn(w.nm)
            equal(w.nm.pending, diedAt + 3600)
            equal(w.vars[key], diedAt + 3600, 'the fade changed the persisted deadline')
        end)

        it('does not invent a deadline when no respawn was scheduled', function()
            local w = simurghWorld()
            w.initialize()
            w.nm:setRespawnTime(0)
            w.trigger(w.nm, 'DESPAWN')
            equal(#w.writes, 0)
        end)

        it('keeps the two Anemone deadlines separate', function()
            local w = newWorld({ ['[PXI][TNM]Anemone17576259'] = 2000300, ['[PXI][TNM]Anemone17576260'] = 2000900 })
            local first  = w.addMob('The_Eldieme_Necropolis', 'Anemone', 17576259, 64800)
            local second = w.addMob('The_Eldieme_Necropolis', 'Anemone', 17576260, 64800)
            w.loadMob('The_Eldieme_Necropolis', 'Anemone')
            w.applyModule()
            w.boot()
            equal(first:getRespawnTime(), 300)
            equal(second:getRespawnTime(), 900)
            w.now = first.pending
            w.tick()
            equal(w.vars['[PXI][TNM]Anemone17576259'], 0)
            equal(w.vars['[PXI][TNM]Anemone17576260'], 2000900)
            w.despawn(first)
            equal(w.vars['[PXI][TNM]Anemone17576259'], w.now + 64800)
            equal(second.pending, 2000900)
        end)
    end)

    describe('Zone rescheduled NMs', function()
        local rows =
        {
            { 'Mount_Zhayolm', 'MOUNT_ZHAYOLM', 'Cerberus', 'CERBERUS', 17027458 },
            { 'Caedarva_Mire', 'CAEDARVA_MIRE', 'Khimaira', 'KHIMAIRA', 17101162 },
        }
        for _, row in ipairs(rows) do
            for _, remainder in ipairs({ 0, -10, 300 }) do
                it(row[3] .. ' handles the zone boot reroll with saved remainder ' .. remainder, function()
                    local key = '[PXI][TNM]' .. row[3]
                    local w = newWorld(remainder ~= 0 and { [key] = 2000000 + remainder } or {})
                    w.setIds(row[2], { [row[4]] = row[5] })
                    local mob = w.addMob(row[1], row[3], row[5], 172800)
                    w.loadMob(row[1], row[3])
                    local called = 0
                    w.setZoneHandler(row[1], 'onInitialize', function()
                        called = called + 1
                        mob:setRespawnTime(43200)
                    end)

                    w.applyModule()
                    w.boot()
                    equal(called, 1, 'base zone initialize was skipped')
                    equal(mob:getRespawnTime(), remainder == 0 and 43200 or math.max(remainder, 60))
                    assert(not mob:isSpawned())
                end)
            end
        end
    end)

    describe('Local-variable deadlines', function()
        local rows =
        {
            { 'Caedarva_Mire', 'Zikko', 'cooldown', 'despawn', 3600 },
            { 'Manaclipper', 'Zoredonite', 'respawn', 'death', 43200 },
            { 'Phanauet_Channel', 'Stubborn_Dredvodd', 'cooldown', 'spawn', 75600 },
            { 'Phanauet_Channel', 'Vodyanoi', 'respawn', 'spawn', 75600 },
            { 'Qufim_Island', 'Dosetsu_Tree', 'respawn', 'despawn', 3600 },
            { 'Sacrarium', 'Elel', 'cooldown', 'death', 7200 },
        }
        for index, row in ipairs(rows) do
            for _, remainder in ipairs({ -100, 10, 3600 }) do
                it(row[2] .. ' restores absolute local time with remainder ' .. remainder .. ' without a respawn floor', function()
                    local key = '[PXI][TNM]' .. row[2]
                    local w = newWorld({ [key] = 2000000 + remainder })
                    local mob = w.addMob(row[1], row[2], 10000 + index, 0)
                    w.loadMob(row[1], row[2])
                    w.applyModule()
                    w.initialize()
                    equal(mob:getLocalVar(row[3]), 2000000 + remainder)
                    equal(mob:getRespawnTime(), 0)
                    assert(not mob:isSpawned())
                    equal(#w.writes, 0)
                end)
            end

            it(row[2] .. ' saves its actual ' .. row[4] .. ' window and restores it after restart', function()
                local key = '[PXI][TNM]' .. row[2]
                local w = newWorld()
                local mob = w.addMob(row[1], row[2], 10000 + index, 0)
                w.loadMob(row[1], row[2])
                w.applyModule()
                w.initialize()
                w.spawn(mob)
                local expected = w.now + row[5]
                if row[4] == 'spawn' then
                    equal(w.vars[key], expected, 'spawn-set cooldown was not saved immediately')
                else
                    equal(w.vars[key], 0, 'old local state survived the spawn reset')
                end

                if row[4] == 'death' then
                    w.call(mob, 'onMobDeath', nil, { isKiller = true })
                end

                w.despawn(mob)
                if row[4] == 'despawn' then
                    expected = w.now + row[5]
                end

                equal(w.vars[key], expected)
                local restored = newWorld(w.vars, w.now + 600)
                local returned = restored.addMob(row[1], row[2], 10000 + index, 0)
                restored.loadMob(row[1], row[2])
                restored.applyModule()
                restored.initialize()
                equal(returned:getLocalVar(row[3]), expected)
            end)
        end

        it('restores Dosetsu over the era initialize and saves the era despawn window', function()
            local key = '[PXI][TNM]Dosetsu_Tree'
            local w = newWorld({ [key] = 2000300 })
            local mob = w.addMob('Qufim_Island', 'Dosetsu_Tree', 17293336, 0)
            w.loadMob('Qufim_Island', 'Dosetsu_Tree')
            w.xi.settings.main.RESTRICT_CONTENT = 1
            w.xi.settings.main.ENABLE_SOA = 0
            w.xi.settings.main.ENABLE_WOTG = 0
            w.applyModule('modules/era/lua/globals/old_nm_respawn_timers.lua')
            w.initialize()
            equal(mob:getLocalVar('respawn'), 2000300)
            w.spawn(mob)
            w.despawn(mob)
            equal(w.vars[key], w.now + 75600)
        end)
    end)

    describe('Weather gate and spawn-slot exclusions', function()
        it('keeps King Vinegarroon down until weather permits his restored timer', function()
            local key = '[PXI][TNM]King_Vinegarroon'
            local w = newWorld({ [key] = 2000300 })
            w.setIds('WESTERN_ALTEPA_DESERT', { KING_VINEGARROON = 17289604 })
            local mob = w.addMob('Western_Altepa_Desert', 'King_Vinegarroon', 17289604, 75600)
            w.loadMob('Western_Altepa_Desert', 'King_Vinegarroon')
            -- Load the real weather handler; unrelated zone NPC setup is not part of this fixture.
            w.xi.zones.Western_Altepa_Desert.Zone = setfenv(assert(loadfile('scripts/zones/Western_Altepa_Desert/Zone.lua')), w.env)()
            w.setZoneHandler('Western_Altepa_Desert', 'onInitialize', function()
                w.env.DisallowRespawn(mob:getID(), false)
            end)

            w.applyModule()
            w.boot()
            equal(mob:getRespawnTime(), 300)
            assert(not mob.allowed)
            local weather = w.xi.zones.Western_Altepa_Desert.Zone.onZoneWeatherChange
            weather(w.xi.weather.SAND_STORM)
            assert(not mob.allowed, 'early weather bypassed the remaining hold')
            w.now = 2000300
            w.tick()
            assert(not mob:isSpawned())
            weather(w.xi.weather.SAND_STORM)
            w.tick()
            assert(mob:isSpawned())
            equal(w.vars[key], 0)
            equal(mob.base, 75600)
        end)

        it('leaves Fraelissa and Fradubio to their spawn slot instead of restoring retired Lua state', function()
            local w = newWorld({ ['[PXI][TNM]Fraelissa'] = 2000300, ['[PXI][TNM]Fraelissa_Next'] = 17203448 })
            w.setIds('JUGNER_FOREST', { FRAELISSA = 17203447, FRADUBIO = 17203448, KING_ARTHRO = 17203216 })
            local ph = w.addMob('Jugner_Forest', 'Fraelissa', 17203447, 3600)
            local nm = w.addMob('Jugner_Forest', 'Fradubio', 17203448, 0)
            w.loadMob('Jugner_Forest', 'Fraelissa')
            w.loadMob('Jugner_Forest', 'Fradubio')
            w.applyModule()
            w.initialize()
            equal(ph:getRespawnTime(), 3600)
            equal(nm:getRespawnTime(), 0)
            w.spawn(ph)
            w.despawn(ph)
            equal(#w.writes, 0, 'the module wrote obsolete lottery persistence')
            assert(not nm:isSpawned())
            equal(w.vars['[PXI][TNM]Fraelissa'], 2000300)
        end)
    end)

    local sharedPairRows =
    {
        { 'Maze_of_Shakhrami', 'MAZE_OF_SHAKHRAMI', 'Argus', 'ARGUS', 17588674, 'Leech_King', 'LEECH_KING', 17588685, 3600, { 1, 1 } },
        { 'Phomiuna_Aqueducts', 'PHOMIUNA_AQUEDUCTS', 'Eba', 'EBA', 16887953, 'Mahisha', 'MAHISHA', 16887885, 28800, { 2, 1 } },
    }

    local function pairWorld(row, stored, clock, useEraTimers)
        local world = newWorld(stored, clock)
        world.setIds(row[2], { [row[4]] = row[5], [row[7]] = row[8] })
        local first  = world.addMob(row[1], row[3], row[5], 0)
        local second = world.addMob(row[1], row[6], row[8], 0)
        world.loadMob(row[1], row[3])
        world.loadMob(row[1], row[6])

        -- A controlled zone roll lets either saved selection replace the boot choice.
        world.setZoneHandler(row[1], 'onInitialize', function()
            world.env.DisallowRespawn(first:getID(), true)
            world.env.DisallowRespawn(second:getID(), false)
            second:setRespawnTime(900)
        end)

        if useEraTimers then
            world.xi.settings.main.RESTRICT_CONTENT = 1
            world.xi.settings.main.ENABLE_SOA = 0
            world.xi.settings.main.ENABLE_WOTG = 0
        end

        world.applyModule(useEraTimers and 'modules/era/lua/globals/old_nm_respawn_timers.lua' or nil)
        return world, first, second
    end

    for _, row in ipairs(sharedPairRows) do
        local pairVar = '[PXI][TNM]' .. row[3] .. '_' .. row[6]
        local pickVar = pairVar .. '_Next'

        it(row[3] .. '/' .. row[6] .. ' keeps the zone roll without a save', function()
            local world, first, second = pairWorld(row)
            world.boot()
            equal(first:getRespawnTime(), 0)
            equal(second:getRespawnTime(), 900)
            equal(world.env.GetServerVariable(pairVar), 0)
        end)

        for source = 1, 2 do
            for _, roll in ipairs({ 1, 100 }) do
                it(row[3] .. '/' .. row[6] .. ' saves source ' .. source .. ' roll ' .. roll .. ' and cancels stale timers', function()
                    local world, first, second = pairWorld(row)
                    local mobs = { first, second }
                    world.initialize()
                    world.spawn(mobs[source])
                    mobs[3 - source]:setRespawnTime(500)
                    world.roll = function(low, high)
                        if low == 1 and high == 100 then
                            return roll
                        end

                        return low
                    end

                    world.despawn(mobs[source])
                    local selected = roll == 1 and row[10][source] or 3 - row[10][source]
                    local winner   = mobs[selected]
                    equal(world.vars[pickVar], winner:getID())
                    equal(winner:getRespawnTime(), row[9])
                    equal(world.vars[pairVar], world.now + row[9])
                    equal(mobs[3 - selected]:getRespawnTime(), 0, 'the losing timer survived the roll')
                end)
            end
        end

        for selected = 1, 2 do
            for _, remaining in ipairs({ 240, -10 }) do
                it(row[3] .. '/' .. row[6] .. ' restores selection ' .. selected .. ' with remainder ' .. remaining, function()
                    local deadline = 2000000 + remaining
                    local saved = { [pairVar] = deadline, [pickVar] = selected == 1 and row[5] or row[8] }
                    local world, first, second = pairWorld(row, saved, 2000000)
                    world.boot()
                    local mobs   = { first, second }
                    local winner = mobs[selected]
                    local loser  = mobs[3 - selected]
                    equal(winner:getRespawnTime(), math.max(remaining, 60))
                    equal(loser:getRespawnTime(), 0)
                    equal(world.vars[pairVar], deadline)

                    world.trigger(loser, 'SPAWN')
                    equal(world.vars[pairVar], deadline, 'the unselected spawn cleared the saved winner')
                    world.now = world.now + math.max(remaining, 60)
                    world.tick()
                    equal(winner:isSpawned(), true)
                    equal(loser:isSpawned(), false)
                    equal(world.vars[pairVar], 0)
                end)
            end
        end

        it(row[3] .. '/' .. row[6] .. ' counts downtime over repeated restarts', function()
            local saved = { [pairVar] = 2000900, [pickVar] = row[5] }
            for _, clock in ipairs({ 2000000, 2000300, 2000700 }) do
                local world, first, second = pairWorld(row, saved, clock)
                world.boot()
                equal(first:getRespawnTime(), 2000900 - clock)
                equal(second:getRespawnTime(), 0)
                equal(world.vars[pairVar], 2000900)
                saved = world.vars
            end
        end)

        for _, selection in ipairs({ 0, -1 }) do
            it(row[3] .. '/' .. row[6] .. ' discards invalid selection ' .. selection .. ' and keeps the zone roll', function()
                local world, first, second = pairWorld(row, { [pairVar] = 2000900, [pickVar] = selection }, 2000000)
                world.boot()
                equal(world.vars[pairVar], 0)
                equal(world.vars[pickVar], 0)
                equal(first:getRespawnTime(), 0)
                equal(second:getRespawnTime(), 900)
            end)
        end
    end

    for source = 1, 2 do
        for _, window in ipairs({ 64800, 108000 }) do
            it('Argus/Leech King saves era source ' .. source .. ' window ' .. window .. ' over the next boot roll', function()
                local row = sharedPairRows[1]
                local pairVar = '[PXI][TNM]Argus_Leech_King'
                local pickVar = pairVar .. '_Next'
                local world, first, second = pairWorld(row, nil, nil, true)
                local mobs = { first, second }
                local selected = window == 64800 and 1 or 2
                world.roll = function(low, high)
                    return selected == 1 and low or high
                end

                world.initialize()
                world.spawn(mobs[source])
                world.despawn(mobs[source])
                local deadline = world.now + window
                equal(world.vars[pairVar], deadline)
                equal(world.vars[pickVar], mobs[selected]:getID())
                equal(mobs[selected]:getRespawnTime(), window)
                equal(mobs[3 - selected]:getRespawnTime(), 0)

                local restored, returnedFirst, returnedSecond = pairWorld(row, world.vars, world.now + 600, true)
                restored.roll = function(low, high)
                    return selected == 1 and high or low
                end

                restored.boot()
                local returned = { returnedFirst, returnedSecond }
                equal(returned[selected]:getRespawnTime(), window - 600)
                equal(returned[3 - selected]:getRespawnTime(), 0, 'the era zone roll survived restoration')
                equal(restored.vars[pairVar], deadline)
                equal(restored.vars[pickVar], mobs[selected]:getID())
            end)
        end
    end

    local beastmenKingRows =
    {
        { 'Castle_Oztroja', 'CASTLE_OZTROJA', 'Yagudo_Avatar', 'YAGUDO_AVATAR', 17396134, 'Tzee_Xicu_the_Manifest', 3, 'Tzee_Xicu_the_Manifest', 900 },
        { 'Monastic_Cavern', 'MONASTIC_CAVERN', 'Orcish_Overlord', 'ORCISH_OVERLORD', 17391802, 'Overlord_Bakgodek', 1, 'Overlord_Bakgodek', 77400, 17391806 },
        { 'Qulun_Dome', 'QULUN_DOME', 'Diamond_Quadav', 'DIAMOND_QUADAV', 17383442, 'ZaDha_Adamantking', 1, 'Za_Dha_Adamantking', 77400, 17383444 },
    }

    local function kingWorld(row, stored, clock, withQuestCopy)
        local world = newWorld(stored, clock)
        world.setIds(row[2], { [row[4]] = row[5], UNDERSTANDING_OVERLORD_OFFSET = row[10] or row[5] + 20 })
        local nq = world.addMob(row[1], row[3], row[5], 75600)
        local hq = world.addMob(row[1], row[6], row[5] + row[7], 0)
        local questCopy
        if withQuestCopy then
            questCopy = world.addMob(row[1], row[3], row[10], 75600)
        end

        world.loadMob(row[1], row[3])
        world.loadMob(row[1], row[6])
        world.applyModule()
        return world, nq, hq, questCopy
    end

    for _, row in ipairs(beastmenKingRows) do
        local pairVar    = '[PXI][TNM]' .. row[3]
        local pickVar    = pairVar .. '_Next'
        local counterVar = '[PH]' .. row[8]
        local popVar     = '[POP]' .. row[8]

        it(row[3] .. ' keeps its actual initialize roll without a save', function()
            local world, nq, hq = kingWorld(row)
            world.initialize()
            equal(nq:getRespawnTime(), row[9])
            equal(hq:getRespawnTime(), 0)
            equal(world.env.GetServerVariable(pairVar), 0)
        end)

        for _, kills in ipairs({ 0, 6 }) do
            it(row[3] .. ' persists the real NQ roll with prior kill count ' .. kills, function()
                local world, nq, hq = kingWorld(row, { [counterVar] = kills }, 2000000)
                world.initialize()
                world.spawn(nq)
                world.despawn(nq)
                local winner = kills == 6 and hq or nq
                equal(world.vars[pickVar], winner:getID())
                equal(world.vars[pairVar], world.now + 77400)
                equal(winner:getRespawnTime(), 77400)
                equal(world.vars[counterVar], kills == 6 and 6 or 1)
            end)
        end

        it(row[3] .. ' keeps the NQ when the HQ cooldown blocks a winning roll', function()
            local world, nq = kingWorld(row, { [counterVar] = 6, [popVar] = 2000900 }, 2000000)
            world.initialize()
            world.spawn(nq)
            world.despawn(nq)
            equal(world.vars[pickVar], nq:getID())
            equal(world.vars[counterVar], 7)
            equal(world.vars[pairVar], world.now + nq:getRespawnTime())
        end)

        it(row[6] .. ' saves the NQ return and preserves the base counter reset and cooldown', function()
            local world, nq, hq = kingWorld(row, { [counterVar] = 6 }, 2000000)
            world.initialize()
            nq:setRespawnTime(0)
            world.spawn(hq)
            world.despawn(hq)
            equal(world.vars[pickVar], nq:getID())
            equal(world.vars[pairVar], world.now + 75600)
            equal(nq:getRespawnTime(), 75600)
            equal(world.vars[counterVar], 0)
            equal(world.vars[popVar], world.now + 259200)
        end)

        for _, selected in ipairs({ 'nq', 'hq' }) do
            for _, reverse in ipairs({ false, true }) do
                it(row[3] .. ' restores ' .. selected .. ' with reverse initialize order ' .. tostring(reverse), function()
                    local selectedId = row[5] + (selected == 'hq' and row[7] or 0)
                    local saved = { [pairVar] = 2000900, [pickVar] = selectedId, [counterVar] = 4 }
                    local world, nq, hq = kingWorld(row, saved, 2000000)
                    world.initialize(reverse and { hq, nq } or { nq, hq })
                    local winner = selected == 'nq' and nq or hq
                    local loser  = selected == 'nq' and hq or nq
                    equal(winner:getRespawnTime(), 900)
                    equal(loser:getRespawnTime(), 0)
                    equal(world.vars[counterVar], 4)
                    world.trigger(loser, 'SPAWN')
                    equal(world.vars[pairVar], 2000900)
                    world.now = 2000900
                    world.tick()
                    equal(winner:isSpawned(), true)
                    equal(loser:isSpawned(), false)
                    equal(world.vars[pairVar], 0)
                end)
            end

            it(row[3] .. ' floors an expired ' .. selected .. ' save and retains it over restart', function()
                local selectedId = row[5] + (selected == 'hq' and row[7] or 0)
                local saved = { [pairVar] = 1999990, [pickVar] = selectedId }
                for _, clock in ipairs({ 2000000, 2000030 }) do
                    local world, nq, hq = kingWorld(row, saved, clock)
                    world.initialize()
                    equal((selected == 'nq' and nq or hq):getRespawnTime(), 60)
                    equal((selected == 'nq' and hq or nq):getRespawnTime(), 0)
                    equal(world.vars[pairVar], 1999990)
                    saved = world.vars
                end
            end)
        end

        for _, selection in ipairs({ 0, -1 }) do
            it(row[3] .. ' drops invalid selection ' .. selection .. ' before canceling timers', function()
                local world, nq, hq = kingWorld(row, { [pairVar] = 2000900, [pickVar] = selection }, 2000000)
                world.initialize()
                equal(world.vars[pairVar], 0)
                equal(world.vars[pickVar], 0)
                equal(nq:getRespawnTime(), row[9])
                equal(hq:getRespawnTime(), 0)
            end)
        end

        if row[10] then
            it(row[3] .. ' quest copy leaves the persistent selection and counter alone', function()
                local saved = { [pairVar] = 2000900, [pickVar] = row[5], [counterVar] = 4 }
                local world, nq, hq, questCopy = kingWorld(row, saved, 2000000, true)
                world.initialize({ questCopy, hq, nq })
                equal(questCopy:getRespawnTime(), row[9], 'quest copy inherited the restored remainder')
                equal(nq:getRespawnTime(), 900)
                world.spawn(questCopy)
                equal(world.vars[pairVar], 2000900, 'quest spawn cleared the real NM save')
                world.despawn(questCopy)
                equal(world.vars[pairVar], 2000900)
                equal(world.vars[pickVar], row[5])
                equal(world.vars[counterVar], 4)
            end)
        end
    end

    describe('Odqan twins', function()
        local deadlineVar = '[PXI][TNM]Odqan'
        local pickVar     = '[PXI][TNM]Odqan_Next'
        local holdVar     = '[PXI][TNM]twinHold'
        local ids         = { 16879737, 16879758 }

        local function odqanWorld(stored, now)
            local w = newWorld(stored, now or 2000000)
            w.setIds('MISAREAUX_COAST', { ODQAN = ids })
            w.twins = {}
            for _, id in ipairs(ids) do
                table.insert(w.twins, w.addMob('Misareaux_Coast', 'Odqan', id, 7200, false))
            end

            w.loadMob('Misareaux_Coast', 'Odqan')
            w.applyModule()
            return w
        end

        it('keeps both normal boot spawns when no selection was saved', function()
            local w = odqanWorld()
            w.boot()
            for _, mob in ipairs(w.twins) do
                assert(mob:isSpawned())
                equal(mob.base, 7200)
            end

            equal(w.vars[deadlineVar] or 0, 0)
        end)

        it('ignores a saved selection that is not either twin', function()
            local w = odqanWorld({ [deadlineVar] = 2003600, [pickVar] = 99 })
            w.boot()
            for _, mob in ipairs(w.twins) do
                assert(mob:isSpawned())
                equal(mob.base, 7200)
                equal(mob:getLocalVar(holdVar), 0)
            end
        end)

        for selected = 1, 2 do
            it('restores twin ' .. selected .. ' across repeated restarts and clears only its spawn', function()
                local w = odqanWorld({ [deadlineVar] = 2003600, [pickVar] = ids[selected] })
                w.boot()
                w = odqanWorld(w.vars, w.now + 600)
                w.boot()
                w = odqanWorld(w.vars, w.now + 900)
                w.boot()
                local winner = w.twins[selected]
                local loser  = w.twins[3 - selected]
                equal(winner.pending, 2003600)
                equal(winner:getLocalVar('canSpawn'), 1)
                equal(loser:getRespawnTime(), 604800)
                equal(loser:getLocalVar(holdVar), 1)
                assert(not winner:isSpawned() and not loser:isSpawned())
                w.spawn(loser)
                equal(w.vars[deadlineVar], 2003600, 'losing twin cleared the selected deadline')
                equal(loser.base, 7200)
                w.now = 2003600
                w.tick()
                assert(winner:isSpawned())
                equal(winner.base, 7200, 'restored remainder replaced the normal interval')
                equal(w.vars[deadlineVar], 0)
                equal(w.vars[pickVar], ids[selected])
            end)

            it('boot spawns expired twin ' .. selected .. ' while retaining the other hold', function()
                local w = odqanWorld({ [deadlineVar] = 1999900, [pickVar] = ids[selected] })
                w.boot()
                assert(w.twins[selected]:isSpawned())
                assert(not w.twins[3 - selected]:isSpawned())
                equal(w.twins[selected].base, 7200)
                equal(w.twins[3 - selected]:getRespawnTime(), 604800)
                equal(w.vars[deadlineVar], 0)
            end)

            it('replaces or cancels the week hold when the next roll selects twin ' .. selected, function()
                local w = odqanWorld({ [deadlineVar] = 2003600, [pickVar] = ids[1] })
                w.boot()
                w.now = 2003600
                w.tick()
                w.roll = function(low, high)
                    if low == 1 and high == 2 then
                        return selected == 1 and 2 or 1
                    end

                    return low == 7200 and 12000 or low
                end

                w.despawn(w.twins[1])
                equal(w.vars[pickVar], ids[selected])
                equal(w.vars[deadlineVar], w.now + 12000)
                equal(w.twins[selected]:getRespawnTime(), 12000)
                equal(w.twins[2]:getLocalVar(holdVar), 0)
                if selected == 1 then
                    equal(w.twins[2].base, 0)
                    assert(not w.twins[2].pending and not w.twins[2].allowed)
                else
                    equal(w.twins[2].base, 12000, 'winner kept the week hold')
                end
            end)
        end

        it('does not save a fresh selection that is already alive', function()
            local w = odqanWorld()
            w.boot()
            w.despawn(w.twins[1])
            equal(w.twins[2]:getLocalVar('canSpawn'), 1)
            assert(w.twins[2]:isSpawned())
            equal(w.vars[deadlineVar] or 0, 0)
        end)
    end)

    describe('Carmine Dobsonfly cohort', function()
        local deadlineVar = '[PXI][TNM]Carmine_Dobsonfly'
        local firstId     = 16900230

        local function dobsonflyWorld(stored, now)
            local w = newWorld(stored, now or 2000000)
            w.setIds('RIVERNE_SITE_A01', { CARMINE_DOBSONFLY_OFFSET = firstId })
            w.flies = {}
            for id = firstId, firstId + 9 do
                table.insert(w.flies, w.addMob('Riverne-Site_A01', 'Carmine_Dobsonfly', id, 86400, false))
            end

            w.loadMob('Riverne-Site_A01', 'Carmine_Dobsonfly')
            w.applyModule()
            return w
        end

        it('boot spawns all ten without a saved deadline', function()
            local w = dobsonflyWorld()
            w.boot()
            for _, fly in ipairs(w.flies) do
                assert(fly:isSpawned())
                equal(fly.base, 86400)
                equal(fly:getMobMod(w.xi.mobMod.SUPERLINK), firstId)
            end

            equal(w.vars[deadlineVar], 0)
        end)

        it('does not save a partial clear and boots the missing flies normally', function()
            local w = dobsonflyWorld()
            w.boot()
            for index = 1, 9 do
                w.despawn(w.flies[index])
                equal(w.vars[deadlineVar] or 0, 0)
            end

            assert(w.flies[10]:isAlive())
            w = dobsonflyWorld(w.vars, w.now + 900)
            w.boot()
            for _, fly in ipairs(w.flies) do
                assert(fly:isSpawned())
                equal(fly.base, 86400)
            end
        end)

        it('saves only the full clear and restores the shared deadline through repeated restarts', function()
            local w = dobsonflyWorld()
            w.boot()
            w.roll = function(low)
                return low == 75600 and 81000 or low
            end

            for _, fly in ipairs(w.flies) do
                w.despawn(fly)
            end

            local deadline = w.now + 81000
            equal(w.vars[deadlineVar], deadline)
            for _, fly in ipairs(w.flies) do
                equal(fly.pending, deadline)
            end

            w = dobsonflyWorld(w.vars, w.now + 600)
            w.boot()
            w = dobsonflyWorld(w.vars, w.now + 1200)
            w.boot()
            for _, fly in ipairs(w.flies) do
                equal(fly.pending, deadline)
                assert(not fly:isSpawned())
            end

            w.now = deadline
            w.tick()
            equal(w.vars[deadlineVar], 0)
            for _, fly in ipairs(w.flies) do
                assert(fly:isSpawned())
                equal(fly.base, 86400, 'shared-key clearing lost a fly normal interval')
            end
        end)

        it('floors an expired cohort and leaves a partial-clear respawn at its normal interval', function()
            local w = dobsonflyWorld({ [deadlineVar] = 1999900 })
            w.boot()
            for _, fly in ipairs(w.flies) do
                equal(fly:getRespawnTime(), 60)
                assert(not fly:isSpawned())
            end

            w.now = w.now + 60
            w.tick()
            local diedAt = w.now
            w.despawn(w.flies[1])
            equal(w.flies[1].pending, diedAt + 86400)
            equal(w.vars[deadlineVar], 0)
        end)

        it('saves a later full-clear roll after restoring an earlier cohort', function()
            local w = dobsonflyWorld({ [deadlineVar] = 2003600 })
            w.boot()
            w.now = 2003600
            w.tick()
            w.roll = function(low)
                return low == 75600 and 79200 or low
            end

            for _, fly in ipairs(w.flies) do
                w.despawn(fly)
            end

            equal(w.vars[deadlineVar], w.now + 79200)
            for _, fly in ipairs(w.flies) do
                equal(fly:getRespawnTime(), 79200)
            end
        end)
    end)

    describe('Lumber Jack and Weeping Willow', function()
        local willowVar = '[PXI][TNM]Weeping_Willow'
        local aliveVar  = '[PXI][TNM]Lumber_Jack_Up'

        local function lumberWorld(stored, now)
            local w = newWorld(stored, now or 2000000)
            w.setIds('BATALLIA_DOWNS', { WEEPING_WILLOW = 17207302, LUMBER_JACK = 17207308 })
            w.willow = w.addMob('Batallia_Downs', 'Weeping_Willow', 17207302, 86400, false)
            w.lumber = w.addMob('Batallia_Downs', 'Lumber_Jack', 17207308, 0, true)
            w.loadMob('Batallia_Downs', 'Weeping_Willow')
            w.loadMob('Batallia_Downs', 'Lumber_Jack')
            w.applyModule()
            return w
        end

        it('keeps the ordinary Willow boot and starts Lumber Jack from her actual despawn', function()
            local w = lumberWorld()
            w.boot()
            assert(w.willow:isSpawned() and not w.lumber:isSpawned())
            equal(w.lumber:getMobMod(w.xi.mobMod.IDLE_DESPAWN), 600)
            w.despawn(w.willow)
            assert(w.lumber:isSpawned())
            equal(w.vars[aliveVar], 1)
            equal(w.vars[willowVar], w.willow.pending)
            equal(w.willow:getRespawnTime(), 86397)
            equal(w.lumber.base, 0)
            assert(not w.lumber.pending and not w.lumber.allowed)
        end)

        it('restores a live Lumber Jack once across repeated restarts with enough Willow time left', function()
            local w = lumberWorld({ [aliveVar] = 1, [willowVar] = 2003600 })
            w.boot()
            w.tick()
            assert(w.lumber:isSpawned() and not w.willow:isSpawned())
            equal(w.lumber.base, 0)
            assert(not w.lumber.pending and not w.lumber.allowed)
            w = lumberWorld(w.vars, w.now + 300)
            w.boot()
            w.tick()
            assert(w.lumber:isSpawned())
            equal(w.vars[aliveVar], 1)
            equal(w.willow.pending, 2003600)
            equal(w.lumber.base, 0)
            assert(not w.lumber.pending and not w.lumber.allowed)
        end)

        for _, remaining in ipairs({ -1, 659, 660, 661 }) do
            it('checks the alive restore boundary with ' .. remaining .. ' seconds left on Willow', function()
                local w = lumberWorld({ [aliveVar] = 1, [willowVar] = 2000000 + remaining })
                w.boot()
                w.tick()
                equal(w.lumber:isSpawned(), remaining > 660)
                equal(w.vars[aliveVar], remaining > 660 and 1 or 0)
                equal(w.lumber.base, 0)
                assert(not w.lumber.pending)
            end)
        end

        it('clears the alive save on death before the delayed despawn runs', function()
            local w = lumberWorld({ [aliveVar] = 1, [willowVar] = 2003600 })
            w.boot()
            w.tick()
            w.call(w.lumber, 'onMobDeath', {}, {})
            equal(w.lumber:getLocalVar('death'), 1)
            equal(w.vars[aliveVar], 0)
            equal(w.vars[willowVar], 2003600, 'death should not yet reroll Willow')
            w = lumberWorld(w.vars, w.now + 1)
            w.boot()
            w.tick()
            assert(not w.lumber:isSpawned() and not w.lumber.pending)
        end)

        for _, killed in ipairs({ false, true }) do
            it('replaces Willow saved time after Lumber Jack ' .. (killed and 'dies' or 'idle despawns'), function()
                local w = lumberWorld({ [aliveVar] = 1, [willowVar] = 2003600 })
                local spawnCount = 0
                w.lumber:addListener('SPAWN', 'TEST_LUMBER_SPAWNS', function()
                    spawnCount = spawnCount + 1
                end)

                w.boot()
                w.tick()
                w.roll = function(low)
                    return low == 75600 and 81000 or low
                end

                if killed then
                    w.call(w.lumber, 'onMobDeath', {}, {})
                else
                    w.now = w.now + 600
                end

                w.despawn(w.lumber)
                equal(w.willow:getRespawnTime(), killed and 81000 or 1800)
                equal(w.vars[willowVar], w.willow.pending)
                equal(w.vars[aliveVar], 0)
                equal(w.lumber.base, 0)
                assert(not w.lumber.pending and not w.lumber.allowed)
                w.now = w.now + 60
                w.tick()
                equal(spawnCount, 1, 'restored one-second timer spawned Lumber Jack twice')
                assert(not w.lumber:isSpawned())
                local deadline = w.willow.pending
                w = lumberWorld(w.vars, w.now + 120)
                w.boot()
                equal(w.willow.pending, deadline)
                assert(not w.lumber:isSpawned())
            end)
        end
    end)

    describe('King Arthro', function()
        local kingArthroId = 17203216
        local deadlineVar = '[PXI][TNM]King_Arthro'
        local windowVar   = deadlineVar .. '_Window'

        local function newKingWorld(stored, clock)
            local w = newWorld(stored, clock)
            w.crabs = {}
            w.setIds('JUGNER_FOREST', { KING_ARTHRO = kingArthroId })
            for id = kingArthroId - 10, kingArthroId do
                local mob = w.addMob('Jugner_Forest', id == kingArthroId and 'King_Arthro' or 'Knight_Crab', id, 0)
                if id == kingArthroId then
                    w.king = mob
                else
                    table.insert(w.crabs, mob)
                end
            end

            w.loadMob('Jugner_Forest', 'Knight_Crab')
            w.loadMob('Jugner_Forest', 'King_Arthro')
            w.rollValue = 0
            local boot = w.boot
            w.boot = function(reverse)
                local order = {}
                for index = 0, 10 do
                    table.insert(order, w.mobs[reverse and kingArthroId - index or kingArthroId - 10 + index])
                end

                boot(order)
            end

            w.spawnCrabs = function()
                w.now = assert(w.crabs[1].pending)
                w.tick()
                for _, crab in ipairs(w.crabs) do
                    assert(crab.spawned, 'crab cohort did not return')
                end

                assert(not w.king.spawned, 'King Arthro spawned before the crab clear')
            end

            w.clearCrabs = function()
                for index, crab in ipairs(w.crabs) do
                    w.despawn(crab)
                    equal(w.king.spawned, index == 10, 'King Arthro requires all ten crab despawns')
                end

                equal(w.king.spawns, 1, 'full clear must spawn King Arthro once')
            end

            w.roll = function(low, high)
                if low == 0 and high == 6 then
                    return w.rollValue
                end

                return low
            end

            w.applyModule()
            return w
        end

        it('keeps the normal boot roll when nothing was saved', function()
            local state = newKingWorld()
            state.rollValue = 6
            state.boot()
            for _, crab in ipairs(state.crabs) do
                equal(crab:getRespawnTime(), 11700)
                assert(crab.allowed and not crab.spawned)
            end

            assert(not state.king.allowed and not state.king.pending and not state.king.spawned)
            equal(state.vars[deadlineVar] or 0, 0)
            equal(state.vars[windowVar] or 0, 0)
            assert(state.king.immunities.DARK_SLEEP, 'base initialize did not run')
        end)

        it('keeps restored scripted crabs enabled regardless of initialize order', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 81300 })
            state.boot(true)
            for _, crab in ipairs(state.crabs) do
                equal(crab:getRespawnTime(), 3600)
                assert(crab.allowed and not crab.spawned)
            end
        end)

        it('saves and clears a normal cycle without a restart', function()
            local state = newKingWorld()
            state.boot()
            state.spawnCrabs()
            state.clearCrabs()
            state.rollValue = 4
            state.king:despawn()
            equal(state.vars[windowVar], 83100)
            equal(state.vars[deadlineVar], state.now + 83100)
            for _, crab in ipairs(state.crabs) do
                equal(crab:getRespawnTime(), 83100)
            end

            state.spawnCrabs()
            equal(state.vars[deadlineVar], 0)
            equal(state.vars[windowVar], 0)
            for _, crab in ipairs(state.crabs) do
                equal(crab.base, 83100)
            end
        end)

        for roll = 0, 6 do
            it('saves the actual base-script death interval for roll ' .. roll, function()
                local state = newKingWorld()
                state.boot()
                state.env.SpawnMob(kingArthroId)
                state.rollValue = roll
                state.writes = {}
                state.king:despawn()
                local interval = 75900 + roll * 1800
                equal(state.vars[windowVar], interval)
                equal(state.vars[deadlineVar], state.now + interval)
                equal(state.writes[1].key, windowVar, 'save the interval before its deadline')
                equal(state.writes[2].key, deadlineVar)
                for _, crab in ipairs(state.crabs) do
                    equal(crab.base, interval)
                    equal(crab.pending, state.vars[deadlineVar])
                end
            end)
        end

        it('counts downtime across repeated restarts without changing the saved interval', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 84900 })
            state.rollValue = 6
            state.boot()
            state = newKingWorld(state.vars, state.now + 600)
            state.boot()
            state = newKingWorld(state.vars, state.now + 900)
            state.boot()
            for _, crab in ipairs(state.crabs) do
                equal(crab.pending, 2003600)
                equal(crab:getRespawnTime(), 2100)
            end

            equal(state.vars[windowVar], 84900)
            equal(state.vars[deadlineVar], 2003600)
        end)

        for _, remainder in ipairs({ -600, 0, 1, 59, 60, 61 }) do
            it('applies the 60-second floor with ' .. remainder .. ' seconds left', function()
                local state = newKingWorld({ [deadlineVar] = 2000000 + remainder, [windowVar] = 75900 })
                state.boot()
                for _, crab in ipairs(state.crabs) do
                    equal(crab:getRespawnTime(), math.max(remainder, 60))
                    assert(not crab.spawned)
                end

                state.now = state.crabs[1].pending - 16
                state.tick()
                assert(not state.crabs[1].spawned, 'spawn wave ran before its window')
                state.now = state.now + 1
                state.tick()
                for _, crab in ipairs(state.crabs) do
                    assert(crab.spawned, 'due cohort did not spawn in its wave')
                    equal(crab.base, 75900)
                end
            end)
        end

        it('restores every full interval after the first spawn clears the shared save', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 86700 })
            state.boot()
            local checkedFirstSpawn = false
            state.crabs[2]:addListener('PRESPAWN', 'TEST_FIRST_CRAB_CLEARED_SAVE', function()
                checkedFirstSpawn = true
                equal(state.vars[deadlineVar], 0)
                equal(state.vars[windowVar], 0)
            end)

            state.spawnCrabs()
            assert(checkedFirstSpawn, 'second crab prespawn check did not run')
            for _, crab in ipairs(state.crabs) do
                equal(crab.base, 86700)
                assert(not crab.pending)
                equal(crab:getLocalVar('[rage]timer'), 300, 'base Knight Crab spawn did not run')
            end
        end)

        it('uses the original full interval when only one restored crab dies', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 81300 })
            state.boot()
            state.spawnCrabs()
            local crab = state.crabs[1]
            local diedAt = state.now
            crab:despawn()
            equal(crab.pending, diedAt + 81300)
            equal(state.king:getLocalVar('[POP]King_Arthro'), 1)
            assert(not state.king.spawned)
            state.now = crab.pending
            state.tick()
            equal(state.king:getLocalVar('[POP]King_Arthro'), 0, 'returning crab must undo its earlier count')
        end)

        it('leaves a different roll intact after the restored cohort clears', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 86700 })
            state.boot()
            state.spawnCrabs()
            state.clearCrabs()
            for _, crab in ipairs(state.crabs) do
                equal(crab.base, 0)
                assert(not crab.pending and not crab.allowed)
            end

            state.rollValue = 1
            state.king:despawn()
            equal(state.vars[windowVar], 77700)
            state.spawnCrabs()
            for _, crab in ipairs(state.crabs) do
                equal(crab.base, 77700, 'old restore callback overwrote the new roll')
            end

            equal(state.vars[deadlineVar], 0)
            equal(state.vars[windowVar], 0)
        end)

        it('cancels held crabs and their restore callbacks when King Arthro is spawned directly', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 86700 })
            state.boot()
            state.env.SpawnMob(kingArthroId)
            equal(state.vars[deadlineVar], 0)
            equal(state.vars[windowVar], 0)
            for _, crab in ipairs(state.crabs) do
                assert(not crab.pending and not crab.allowed and not crab.spawned)
            end

            state.now = 2003700
            state.tick()
            for _, crab in ipairs(state.crabs) do
                assert(not crab.spawned, 'canceled crab timer still fired')
            end

            state.rollValue = 2
            state.king:despawn()
            state.spawnCrabs()
            for _, crab in ipairs(state.crabs) do
                equal(crab.base, 79500, 'unused restore callback survived King Arthro spawn')
            end
        end)

        it('removes a restored crab pending registration when it is spawned directly', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 81300 })
            state.boot()
            local crab = state.crabs[1]
            state.env.SpawnMob(crab.id)
            equal(crab.base, 81300)
            assert(not crab.pending, 'forced spawn retained its old timer')
            state.now = 2003600
            state.tick()
            equal(crab.spawns, 1, 'old timer spawned the held crab a second time')
            for _, otherCrab in ipairs(state.crabs) do
                equal(otherCrab.base, 81300)
            end
        end)

        it('keeps partial-clear restart behavior without persisting the kill count', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 83100 })
            state.boot()
            state.spawnCrabs()
            state.crabs[1]:despawn()
            state.crabs[2]:despawn()
            equal(state.king:getLocalVar('[POP]King_Arthro'), 2)
            state = newKingWorld(state.vars, state.now + 100)
            state.rollValue = 3
            state.boot()
            equal(state.king:getLocalVar('[POP]King_Arthro'), 0)
            assert(not state.king.spawned)
            for _, crab in ipairs(state.crabs) do
                equal(crab:getRespawnTime(), 6300)
                assert(not crab.spawned)
            end
        end)

        it('keeps base restart behavior while King Arthro is alive', function()
            local state = newKingWorld({ [deadlineVar] = 2003600, [windowVar] = 83100 })
            state.boot()
            state.spawnCrabs()
            state.clearCrabs()
            state = newKingWorld(state.vars, state.now + 100)
            state.boot()
            assert(not state.king.spawned and not state.king.pending and not state.king.allowed)
            for _, crab in ipairs(state.crabs) do
                equal(crab:getRespawnTime(), 900)
            end
        end)

        for _, saved in ipairs(
        {
            { name = 'deadline without interval', vars = { [deadlineVar] = 2003600 } },
            { name = 'interval without deadline', vars = { [windowVar] = 83100 } },
            { name = 'negative interval', vars = { [deadlineVar] = 2003600, [windowVar] = -1 } },
            { name = 'negative deadline', vars = { [deadlineVar] = -1, [windowVar] = 83100 } },
        }) do
            it('keeps the boot roll and clears an invalid save on spawn: ' .. saved.name, function()
                local state = newKingWorld(saved.vars)
                state.rollValue = 2
                state.boot()
                for _, crab in ipairs(state.crabs) do
                    equal(crab:getRespawnTime(), 4500)
                    equal(crab.base, 4500)
                end

                state.spawnCrabs()
                equal(state.vars[deadlineVar] or 0, 0)
                equal(state.vars[windowVar] or 0, 0)
            end)
        end
    end)
end)
