-----------------------------------
-- Loads the core EXP calculation with every Phoenix EXP module in an isolated
-- Lua environment, so the server's population, variables and clock are mocked.
-----------------------------------
describe('Module: phoenix custom exp', function()
    local rateVar = '[SyncPenalty]RatePerLevel'

    local function fixture()
        local state =
        {
            online     = 0,
            hour       = 1,
            serverVars = {},
        }

        local testXi =
        {
            effect        = xi.effect,
            mod           = xi.mod,
            mobMod        = xi.mobMod,
            mobDifficulty = xi.mobDifficulty,
            objType       = xi.objType,
            region        = xi.region,
            zone          = xi.zone,
            keyItem       = xi.keyItem,
            server        = {},
            player        = {},
            effects       = { level_sync = {} },
            zones         = { GM_Home = { Zone = {} } },
            besieged      =
            {
                getAstralCandescence = function()
                    return 1
                end,
            },
        }

        local env = setmetatable({ xi = testXi }, { __index = _G })
        env.require = function()
        end

        env.GetOnlinePlayerCount = function()
            return state.online
        end

        env.GetServerVariable = function(name)
            return state.serverVars[name] or 0
        end

        env.SetServerVariable = function(name, value)
            state.serverVars[name] = value
        end

        env.VanadielHour = function()
            return state.hour
        end

        for _, path in ipairs(
            {
                'modules/module_utils.lua',
                'scripts/globals/experience_points.lua',
                'modules/phoenix/lua/custom/exp_penalties.lua',
                'modules/phoenix/lua/custom/level_sync_penalty.lua',
                'modules/phoenix/lua/globals/disable_sanction_bonuses.lua',
            })
        do
            setfenv(assert(loadfile(path)), env)()
        end

        for _, module in ipairs(testXi.module.registry) do
            assert(module.enabled, module.name)
            for _, override in ipairs(module.overrides) do
                local parts = {}
                for part in override.name:gmatch('[^.]+') do
                    table.insert(parts, part)
                end

                local target = env
                for index = 1, #parts - 1 do
                    target = assert(target[parts[index]], override.name)
                end

                -- Mirrors the loader, which stubs a missing target before applying the override
                local leaf = parts[#parts]
                if target[leaf] == nil then
                    target[leaf] = setfenv(function()
                    end, env)
                end

                env.applyOverride(target, leaf, override.func)
            end
        end

        return testXi, state, env
    end

    local function newPlayer(actualLevel, syncLevel)
        local player =
        {
            actualLevel = actualLevel,
            syncLevel   = syncLevel,
            objType     = xi.objType.PC,
            mods        = {},
            localVars   = {},
            effects     = {},
            listeners   = {},
        }

        function player:getObjType()
            return self.objType
        end

        function player:getMainJob()
            return xi.job.WAR
        end

        function player:getJobLevel()
            return self.actualLevel
        end

        function player:getMainLvl()
            return self.syncLevel
        end

        function player:getZoneID()
            return xi.zone.VALKURM_DUNES
        end

        function player:hasKeyItem()
            return false
        end

        function player:getMod(mod)
            return self.mods[mod] or 0
        end

        function player:addMod(mod, value)
            self.mods[mod] = self:getMod(mod) + value
        end

        function player:delMod(mod, value)
            self.mods[mod] = self:getMod(mod) - value
        end

        function player:getLocalVar(name)
            return self.localVars[name] or 0
        end

        function player:setLocalVar(name, value)
            self.localVars[name] = value
        end

        function player:getStatusEffect(effect)
            return self.effects[effect]
        end

        function player:hasStatusEffect(effect)
            return self.effects[effect] ~= nil
        end

        function player:delStatusEffect(effect)
            self.effects[effect] = nil
        end

        function player:addListener(event, name, func)
            self.listeners[name] = { event = event, func = func }
        end

        function player:removeListener(name)
            self.listeners[name] = nil
        end

        return player
    end

    local function newMob()
        return
        {
            getMobMod = function()
                return 0
            end,

            getMod = function()
                return 0
            end,

            getMainLvl = function()
                return 30
            end,

            getMaster = function()
                return nil
            end,
        }
    end

    local function expData(regionId)
        return
        {
            baseExp            = 200,
            memberLevel        = 30,
            highestMemberLevel = 30,
            memberTNL          = 5800,
            highestMemberTNL   = 5800,
            partySize          = 1,
            regionId           = regionId,
            mobDifficulty      = xi.mobDifficulty.EVEN_MATCH,
            chainNumber        = 1,
            chainActive        = false,
        }
    end

    local function setRate(testXi, state, online)
        state.online = online
        testXi.server.onServerStart()
    end

    local function sync(testXi, player)
        player.effects[xi.effect.LEVEL_SYNC] = {}
        testXi.effects.level_sync.onEffectGain(player, player.effects[xi.effect.LEVEL_SYNC])
    end

    local function unsync(testXi, player)
        testXi.effects.level_sync.onEffectLose(player, player.effects[xi.effect.LEVEL_SYNC])
        player.effects[xi.effect.LEVEL_SYNC] = nil
    end

    local function awardExp(player)
        for _, listener in pairs(player.listeners) do
            if listener.event == 'EXPERIENCE_POINTS' then
                listener.func(player, newMob(), 100)
            end
        end
    end

    local function expBonus(player)
        return player:getMod(xi.mod.EXP_BONUS)
    end

    describe('population rate', function()
        it('picks the per-level rate from the population tiers at server start', function()
            local testXi, state = fixture()
            local tiers =
            {
                { online = 0,    rate = 0 },
                { online = 499,  rate = 0 },
                { online = 500,  rate = 15 },
                { online = 999,  rate = 15 },
                { online = 1000, rate = 20 },
                { online = 1999, rate = 20 },
                { online = 2000, rate = 25 },
                { online = 9000, rate = 25 },
            }

            for _, tier in ipairs(tiers) do
                setRate(testXi, state, tier.online)
                assert(state.serverVars[rateVar] == tier.rate, string.format('%d online gave %d', tier.online, state.serverVars[rateVar]))
            end
        end)

        it('refreshes the rate only on Vanadiel hours 0 and 12', function()
            local testXi, state = fixture()
            setRate(testXi, state, 0)
            state.online = 2500

            for hour = 1, 11 do
                state.hour = hour
                testXi.zones.GM_Home.Zone.onGameHour({})
                assert(state.serverVars[rateVar] == 0, string.format('refreshed at hour %d', hour))
            end

            state.hour = 12
            testXi.zones.GM_Home.Zone.onGameHour({})
            assert(state.serverVars[rateVar] == 25)

            state.online = 0
            state.hour   = 13
            testXi.zones.GM_Home.Zone.onGameHour({})
            assert(state.serverVars[rateVar] == 25)

            state.hour = 0
            testXi.zones.GM_Home.Zone.onGameHour({})
            assert(state.serverVars[rateVar] == 0)
        end)

        it('leaves the rate alone when the population binding is missing', function()
            local testXi, state, env = fixture()
            setRate(testXi, state, 1500)
            env.GetOnlinePlayerCount = false
            testXi.server.onServerStart()
            assert(state.serverVars[rateVar] == 20)
        end)
    end)

    describe('level sync penalty', function()
        it('scales with levels above the sync target and floors the result', function()
            local cases =
            {
                { actual = 75, synced = 65, online = 2500, penalty = 0 },
                { actual = 75, synced = 64, online = 600,  penalty = 16 },
                { actual = 75, synced = 55, online = 1500, penalty = 40 },
                { actual = 75, synced = 30, online = 2500, penalty = 50 },
                { actual = 75, synced = 30, online = 100,  penalty = 0 },
            }

            for _, case in ipairs(cases) do
                local testXi, state = fixture()
                setRate(testXi, state, case.online)
                local player = newPlayer(case.actual, case.synced)
                sync(testXi, player)
                assert(expBonus(player) == -case.penalty, string.format('%d synced to %d at %d online gave %d', case.actual, case.synced, case.online, expBonus(player)))
                assert(player:getLocalVar('[SyncPenalty]Amount') == case.penalty)
            end
        end)

        it('ignores entities that are not players', function()
            local testXi, state = fixture()
            setRate(testXi, state, 2500)
            local trust   = newPlayer(75, 30)
            trust.objType = xi.objType.TRUST
            sync(testXi, trust)
            assert(expBonus(trust) == 0)
            assert(next(trust.listeners) == nil)
        end)

        it('picks up a population rise mid sync after the next EXP award', function()
            local testXi, state = fixture()
            setRate(testXi, state, 100)
            local player = newPlayer(75, 40)
            sync(testXi, player)
            assert(expBonus(player) == 0)

            state.online = 2500
            state.hour   = 12
            testXi.zones.GM_Home.Zone.onGameHour({})
            assert(expBonus(player) == 0)

            awardExp(player)
            assert(expBonus(player) == -50)

            awardExp(player)
            assert(expBonus(player) == -50)
        end)

        it('drops the penalty mid sync when the population falls', function()
            local testXi, state = fixture()
            setRate(testXi, state, 1500)
            local player = newPlayer(75, 55)
            sync(testXi, player)
            assert(expBonus(player) == -40)

            state.online = 100
            state.hour   = 0
            testXi.zones.GM_Home.Zone.onGameHour({})
            awardExp(player)
            assert(expBonus(player) == 0)
        end)

        it('recalculates without stacking when the real job levels up', function()
            local testXi, state = fixture()
            setRate(testXi, state, 600)
            local player = newPlayer(74, 63)
            sync(testXi, player)
            assert(expBonus(player) == -16)

            player.actualLevel = 75
            testXi.player.onPlayerLevelUp(player)
            assert(expBonus(player) == -18)
        end)

        it('restores the mod and stops refreshing once sync ends', function()
            local testXi, state = fixture()
            setRate(testXi, state, 2500)
            local player = newPlayer(75, 30)
            player:addMod(xi.mod.EXP_BONUS, 10)
            sync(testXi, player)
            assert(expBonus(player) == -40)

            unsync(testXi, player)
            assert(expBonus(player) == 10)
            assert(player:getLocalVar('[SyncPenalty]Amount') == 0)
            assert(next(player.listeners) == nil)

            awardExp(player)
            assert(expBonus(player) == 10)
        end)

        it('reduces the EXP the core calculation awards', function()
            local testXi, state = fixture()
            setRate(testXi, state, 600)
            local player = newPlayer(50, 30)
            local mob    = newMob()

            local base = testXi.experiencePoints.calculate(player, mob, expData(xi.region.VALDEAUNIA)).exp

            sync(testXi, player)
            assert(expBonus(player) == -30)

            local penalized = testXi.experiencePoints.calculate(player, mob, expData(xi.region.VALDEAUNIA)).exp
            assert(penalized == base + math.floor(base * -30 / 100), string.format('base %d penalized %d', base, penalized))
        end)
    end)

    describe('sanction', function()
        it('grants no EXP bonus inside Aht Urhgan under Astral Candescence', function()
            local testXi = fixture()
            local player = newPlayer(30, 30)
            local mob    = newMob()

            local base = testXi.experiencePoints.calculate(player, mob, expData(xi.region.WEST_AHT_URHGAN)).exp

            player.effects[xi.effect.SANCTION] = {}
            assert(testXi.experiencePoints.getSanctionBonus(player, xi.region.WEST_AHT_URHGAN) == 0)
            assert(testXi.experiencePoints.calculate(player, mob, expData(xi.region.WEST_AHT_URHGAN)).exp == base)
        end)
    end)
end)
