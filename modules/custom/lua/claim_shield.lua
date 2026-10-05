-----------------------------------
-- Claim Shield
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('claim_shield')

local claimshieldTime = 5000 -- Milliseconds.

-- Entries may be a mob name or { name = 'Mob_Name', time = milliseconds }.
local shieldedEntities =
{
    ['AlTaieu'] =
    {
        'Omyovra',
        'Ulyovra',
    },

    ['Arrapago_Reef'] =
    {
        'Lamia_No19',
    },

    ['Attohwa_Chasm'] =
    {
        'Citipati',
        'Tiamat',
        'Xolotl',
        'Ambusher_Antlion',
    },

    ['Aydeewa_Subterrane'] =
    {
        'Bluestreak_Gyugyuroon',
    },

    ['Batallia_Downs'] =
    {
        'Lumber_Jack',
        'Ahtu',
        'Tottering_Toby',
        'Weeping_Willow',
    },

    ['Beadeaux'] =
    {
        'GaBhu_Unvanquished',
        'BiGho_Headtaker',
        'DaDha_Hundredmask',
        'DeVyu_Headhunter',
        'GeDha_Evileye',
        'GoBhu_Gascon',
        'ZoKhu_Blackcloud',
    },

    ['Beaucedine_Glacier'] =
    {
        'Nue',
        'Gargantua',
        'Kirata',
    },

    ['Bhaflau_Thickets'] =
    {
        'Emergent_Elm',
    },

    ['Bibiki_Bay'] =
    {
        'Intulo',
        'Serra',
    },

    ['Bostaunieux_Oubliette'] =
    {
        'Bloodsucker_NM',
        'Drexerion_the_Condemned',
        'Phanduron_the_Condemned',
        'Sewer_Syrup',
        'Arioch',
        'Manes',
        'Shii',
    },

    ['Buburimu_Peninsula'] =
    {
        'Buburimboo',
        'Helldiver',
    },

    ['Caedarva_Mire'] =
    {
        'Khimaira',
        'Peallaidh',
        'Zikko',
    },

    ['Cape_Teriggan'] =
    {
        'Kreutzet',
        'Frostmane',
    },

    ['Carpenters_Landing'] =
    {
        'Orctrap',
    },

    ['Castle_Oztroja'] =
    {
        'Mee_Deggi_the_Punisher',
        'Quu_Domi_the_Gallant',
        'Tzee_Xicu_the_Manifest',
        'Moo_Ouzi_the_Swiftblade',
        'Yaa_Haqa_the_Profane',
        'Yagudo_Avatar',
        'Yagudo_High_Priest',
        'Yagudo_Templar',
    },

    ['Castle_Zvahl_Baileys'] =
    {
        'Duke_Haborym',
        'Grand_Duke_Batym',
        'Marquis_Allocen',
        'Marquis_Amon',
    },

    ['Castle_Zvahl_Keep'] =
    {
        'Baron_Vapula',
        'Baronet_Romwe',
        'Count_Bifrons',
        'Viscount_Morax',
    },

    ['Crawlers_Nest'] =
    {
        'Demonic_Tiphia',
    },

    ['Dangruf_Wadi'] =
    {
        'Geyser_Lizard',
    },

    ['Davoi'] =
    {
        'Blubbery_Bulge',
        'Dirtyhanded_Gochakzuk',
        'Hawkeyed_Dnatbat',
        'Poisonhand_Gnadgad',
        'Steelbiter_Gudrud',
        'Tigerbane_Bakdak',
    },

    ['Den_of_Rancor'] =
    {
        'Friar_Rush',
        'Tonberry_Decapitator',
        'Tonberry_Tracker',
        'Bistre-hearted_Malberry',
        'Carmine-tailed_Janberry',
        'Celeste-eyed_Tozberry',
        'Ogama',
        'Sozu_Bliberry',
        'Tawny-fingered_Mugberry',
        'Tonberry_Pontifex',
    },

    ['East_Ronfaure'] =
    {
        'Bigmouth_Billy',
        'Swamfisk',
    },

    ['East_Sarutabaruta'] =
    {
        'Spiny_Spipi',
        'Sharp-Eared_Ropipi',
    },

    ['Eastern_Altepa_Desert'] =
    {
        'Centurio_XII-I',
        'Cactrot_Rapido',
        'Dune_Widow',
    },

    ['FeiYin'] =
    {
        'Capricious_Cassie',
        'Eastern_Shadow',
        'Northern_Shadow',
        'Southern_Shadow',
        'Western_Shadow',
        'Goliath',
    },

    ['Fort_Ghelsba'] =
    {
        'Hundredscar_Hajwaj',
        'Orcish_Panzer',
    },

    ['Garlaige_Citadel'] =
    {
        'Serket',
        'Old_Two-Wings',
        'Skewer_Sam',
    },

    ['Giddeus'] =
    {
        'Hoo_Mjuu_the_Torrent',
        'Eyy_Mon_the_Ironbreaker',
        'Juu_Duzu_the_Whirlwind',
        'Vuu_Puqu_the_Beguiler',
        'Zhuu_Buxu_the_Silent',
    },

    ['Gusgen_Mines'] =
    {
        'Asphyxiated_Amsel',
        'Burned_Bergmann',
        'Crushed_Krause',
        'Juggler_Hecatomb',
        'Pulverized_Pfeffer',
        'Smothered_Schmidt',
        'Wounded_Wurfel',
    },

    ['Gustav_Tunnel'] =
    {
        'Amikiri',
        'Bune',
        'Baobhan_Sith',
        'Goblinsavior_Heronox',
        'Taxim',
        'Ungur',
        'Wyvernpoacher_Drachlox',
    },

    ['Ifrits_Cauldron'] =
    {
        'Ash_Dragon',
        'Foreseer_Oramix',
        'Lindwurm',
        'Tyrannic_Tunnok',
        'Vouivre',
    },

    ['Inner_Horutoto_Ruins'] =
    {
        'Maltha',
        -- 'Slendlix_Spindlethumb', Disabled until WotG
    },

    ['Jugner_Forest'] =
    {
        'King_Arthro',
        'Panzer_Percival',
        'Fradubio',
        'Fraelissa',
        'Meteormauler_Zhagtegg',
    },

    ['King_Ranperres_Tomb'] =
    {
        'Vrtra',
        'Cemetery_Cherry',
        'Spook',
    },

    ['Konschtat_Highlands'] =
    {
        'Steelfleece_Baldarich',
        'Stray_Mary',
        'Bendigeit_Vran',
        'Haty',
        'Rampaging_Ram',
    },

    ['Korroloka_Tunnel'] =
    {
        'Cargo_Crab_Colin',
        'Dame_Blanche',
        'Falcatus_Aranei',
    },

    ['Kuftal_Tunnel'] =
    {
        'Amemet',
        'Yowie',
        'Arachne',
        'Bloodthirster_Madkix',
        'Guivre',
        'Pelican',
        'Sabotender_Mariachi',
    },

    ['La_Theine_Plateau'] =
    {
        'Bloodtear_Baldurf',
        'Lumbering_Lambert',
        'Tumbling_Truffle',
    },

    ['Labyrinth_of_Onzozo'] =
    {
        'Lord_of_Onzozo',
        'Mysticmaker_Profblix',
        'Ose',
        'Hellion',
        'Narasimha',
        'Peg_Powler',
        'Soulstealer_Skullnix',
    },

    ['Lower_Delkfutts_Tower'] =
    {
        'Epialtes',
        'Eurymedon',
        'Hippolytos',
    },

    ['Lufaise_Meadows'] =
    {
        'Padfoot',
        'Megalobugard',
        'Colorful_Leshy',
        'Defoliate_Leshy',
    },

    ['Mamook'] =
    {
        'Zizzy_Zillah',
    },

    ['Maze_of_Shakhrami'] =
    {
        'Argus',
        'Leech_King',
    },

    ['Meriphataud_Mountains'] =
    {
        'Coo_Keja_the_Unseen',
        'Daggerclaw_Dracos',
        'Waraxe_Beak',
    },

    ['Middle_Delkfutts_Tower'] =
    {
        'Eurytos',
        'Ogygos',
        'Ophion',
        'Polybotes',
        'Rhoikos',
        'Rhoitos',
    },

    ['Misareaux_Coast'] =
    {
        'Upyri',
        'Odqan',
    },

    ['Monastic_Cavern'] =
    {
        'Overlord_Bakgodek',
        'Orcish_Hexspinner',
        'Orcish_Overlord',
        'Orcish_Warlord',
    },

    ['Mount_Zhayolm'] =
    {
        'Cerberus',
        'Energetic_Eruca',
    },

    ['Newton_Movalpolos'] =
    {
        'Swashstox_Beadblinker',
    },

    ['North_Gustaberg'] =
    {
        'Maighdean_Uaine',
        'Stinging_Sophie',
    },

    ['Oldton_Movalpolos'] =
    {
        'Bugbear_Strongman',
    },

    ['Ordelles_Caves'] =
    {
        'Morbolger',
    },

    ['Outer_Horutoto_Ruins'] =
    {
        'Bomb_King',
        'Doppelganger_Dio',
        'Doppelganger_Gog',
    },

    ['Palborough_Mines'] =
    {
        'BuGhi_Howlblade',
        'NoMho_Crimsonarmor',
        'ZiGhi_Boneeater',
    },

    ['Pashhow_Marshlands'] =
    {
        'Bloodpool_Vorax',
        'BoWho_Warmonger',
        'Jolly_Green',
    },

    ['Phanauet_Channel'] =
    {
        'Stubborn_Dredvodd',
        'Vodyanoi',
    },

    ['Phomiuna_Aqueducts'] =
    {
        'Eba',
        'Mahisha',
        'Tres_Duendes',
    },

    ['Promyvion-Dem'] =
    {
        'Satiator',
    },

    ['Promyvion-Holla'] =
    {
        'Cerebrator',
    },

    ['Promyvion-Mea'] =
    {
        'Coveter',
    },

    ['PsoXja'] =
    {
        'Gyre-Carlin',
    },

    ['Qufim_Island'] =
    {
        'Dosetsu_Tree',
        'Trickster_Kinetix',
    },

    ['Quicksand_Caves'] =
    {
        'Centurio_X-I',
        'Sabotender_Bailarina',
        'Antican_Consul',
        'Antican_Legatus',
        'Antican_Magister',
        'Antican_Praefectus',
        'Antican_Praetor',
        'Antican_Proconsul',
        'Antican_Tribunus',
        'Diamond_Daig',
        'Hastatus_XI-XII',
        'Nussknacker',
        'Proconsul_XII',
        'Sabotender_Bailarin',
        'Sagittarius_X-XIII',
        'Triarius_X-XV',
    },

    ['Qulun_Dome'] =
    {
        'ZaDha_Adamantking',
        'Adaman_Quadav',
        'Diamond_Quadav',
        'Ruby_Quadav',
    },

    ['Ranguemont_Pass'] =
    {
        'Taisaijin',
    },

    ['Riverne-Site_A01'] =
    {
        'Carmine_Dobsonfly',
        'Aiatar',
        'Heliodromos',
    },

    ['Riverne-Site_B01'] =
    {
        'Boroka',
    },

    ['Rolanberry_Fields'] =
    {
        -- 'Eldritch_Edge',
        'Simurgh',
        'Black_Triple_Stars',
        'Drooling_Daisy',
        'Silk_Caterpillar',
    },

    ['Rolanberry_Fields_[S]'] =
    {
        -- 'Lamina',
    },

    ['RoMaeve'] =
    {
        'Shikigami_Weapon',
        'Nightmare_Vase',
    },

    ['Sacrarium'] =
    {
        'Elel',
    },

    ['Sauromugue_Champaign'] =
    {
        -- 'Blighting_Brand',
        'Roc',
        'Deadly_Dodo',
    },

    ['Sauromugue_Champaign_[S]'] =
    {
        -- 'Hyakinthos',
    },

    ['Sea_Serpent_Grotto'] =
    {
        'Charybdis',
        'Fyuu_the_Seabellow',
        'Novv_the_Whitehearted',
        'Sea_Hog',
        'Abyss_Sahagin',
        'Coral_Sahagin',
        'Denn_the_Orcavoiced',
        'Masan',
        'Mouu_the_Waverider',
        'Namtar',
        'Ocean_Sahagin',
        'Pahh_the_Gullcaller',
        'Qull_the_Shellbuster',
        'Seww_the_Squidlimbed',
        'Voll_the_Sharkfinned',
        'Worr_the_Clawfisted',
        'Wuur_the_Sandcomber',
        'Yarr_the_Pearleyed',
        'Zuug_the_Shoreleaper',
    },

    ['South_Gustaberg'] =
    {
        'Leaping_Lizzy',
        'Carnero',
    },

    ['Tahrongi_Canyon'] =
    {
        'Serpopard_Ishtar',
    },

    ['Temple_of_Uggalepih'] =
    {
        'Sozu_Sarberry',
        'Sozu_Terberry',
        'Bonze_Marberry',
        'Flauros',
        'Manipulator',
        'Tonberry_Kinq',
    },

    ['The_Boyahda_Tree'] =
    {
        'Voluptuous_Vivian',
        'Ancient_Goobbue',
        'Aquarius',
        'Ellyllon',
        'Leshonki',
        'Unut',
    },

    ['The_Eldieme_Necropolis'] =
    {
        'Cwn_Cyrff',
    },

    ['The_Garden_of_RuHmet'] =
    {
        'Ixaern_DRG',
    },

    ['The_Sanctuary_of_ZiTah'] =
    {
        'Noble_Mold',
        'Keeper_of_Halidom',
    },

    ['The_Shrine_of_RuAvitau'] =
    {
        'Faust',
        'Mother_Globe',
    },

    ['Toraimarai_Canal'] =
    {
        'Oni_Carcass',
    },

    ['Uleguerand_Range'] =
    {
        'Jormungand',
        'Bonnacon',
        'Father_Frost',
        'Mountain_Worm_NM',
        'Snow_Maiden',
    },

    ['Upper_Delkfutts_Tower'] =
    {
        'Enkelados',
        'Ixtab',
        'Mimas',
        'Porphyrion',
    },

    ['Valkurm_Dunes'] =
    {
        'Valkurm_Emperor',
        'Golden_Bat',
    },

    ['VeLugannon_Palace'] =
    {
        'Zipacna',
        'Steam_Cleaner',
    },

    ['Wajaom_Woodlands'] =
    {
        'Hydra',
        'Jaded_Jody',
        'Zoraal_Jas_Pkuucha',
    },

    ['West_Ronfaure'] =
    {
        'Fungus_Beetle',
        'Jaggedy-Eared_Jack',
    },

    ['West_Sarutabaruta'] =
    {
        'Nunyenunc',
        'Tom_Tit_Tat',
    },

    ['Western_Altepa_Desert'] =
    {
        'King_Vinegarroon',
        'Cactuar_Cantautor',
        'Celphie',
    },

    ['Xarcabard'] =
    {
        'Biast',
        'Boreal_Coeurl',
        'Boreal_Hound',
        'Boreal_Tiger',
        'Ereshkigal',
        'Shadow_Eye',
    },

    ['Yhoator_Jungle'] =
    {
        'Bright-handed_Kunberry',
        'Bisque-heeled_Sunberry',
        'Woodland_Sage',
    },

    ['Yughott_Grotto'] =
    {
        'Ashmaker_Gotblut',
    },

    ['Yuhtunga_Jungle'] =
    {
        'Rose_Garden',
        'Voluptuous_Vilma',
        'Meww_the_Turtlerider',
        'Mischievous_Micholas',
    },
}

-- Adds claim shield and sets the mob up to collect entries.
local startClaimShield = function(mob, shieldTime)
    mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.UNCLAIMABLE)
    mob:setUnkillable(true)
    mob:setCallForHelpBlocked(true)
    mob:stun(shieldTime)
end

-- Collects all unique entries from the mobs enmity list and returns them as a table.
local collectEntries = function(mob)
    local entries     = {}
    local seenPlayers = {}

    for _, enmityEntry in pairs(mob:getEnmityList()) do
        local entity = enmityEntry.entity
        local player = entity:isPC() and entity or entity:getMaster()

        if player and player:isPC() then
            local playerId = player:getID()
            if not seenPlayers[playerId] then
                seenPlayers[playerId] = true
                entries[#entries + 1] = player
            end
        end
    end

    return entries
end

-- Removes claim shield.
local endClaimShield = function(mob)
    mob:setUnkillable(false)
    mob:setCallForHelpBlocked(false)
    mob:setHP(mob:getMaxHP())

    local mobId = mob:getID()
    for _, effect in ipairs(mob:getStatusEffects()) do
        if effect:getOriginID() ~= mobId then
            mob:delStatusEffectSilent(effect:getEffectType())
        end
    end
end

-- Selects a winner, awards claim, notifies entrants, and clears enmity for losing entrants.
local resolveLottery = function(mob, entries)
    mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.EXCLUSIVE)

    for _, enmityEntry in pairs(mob:getEnmityList()) do
        local entity = enmityEntry.entity
        if entity then
            if not entity:isPC() then
                entity:disengage()
            end

            mob:resetEnmity(entity)
        end
    end

    mob:resetAI()
    mob:disengage()

    local entrantCount = #entries
    local claimWinner  = utils.randomEntry(entries)
    if not claimWinner then
        return
    end

    local alliance       = claimWinner:getAlliance()
    local winningMembers = {}
    local winnerPrefix   = #alliance == 1 and 'You have' or 'Your group has'
    local winnerMessage  = string.format('%s won the lottery for %s! (out of %i players)', winnerPrefix, mob:getPacketName(), entrantCount)

    for _, member in pairs(alliance) do
        winningMembers[member:getID()] = true
    end

    mob:updateClaim(claimWinner)
    mob:addEnmity(claimWinner, 1, 1)

    for _, member in pairs(alliance) do
        member:printToPlayer(winnerMessage, xi.msg.channel.SYSTEM_3, '')
    end

    for _, entrant in ipairs(entries) do
        if not winningMembers[entrant:getID()] then
            local loserAlliance = entrant:getAlliance()
            local loserPrefix   = #loserAlliance == 1 and 'You were' or 'Your group was'
            local loserMessage  = string.format('%s not successful in the lottery for %s. (out of %i players)', loserPrefix, mob:getPacketName(), entrantCount)
            entrant:printToPlayer(loserMessage, xi.msg.channel.SYSTEM_3, '')
        end
    end
end

-- Adds Claim Shield listener on spawn.
local addClaimshield = function(mob, shieldTime)
    mob:addListener('SPAWN', string.format('%s_CS_SPAWN', mob:getPacketName()), function(mobArg)
        print(string.format('Applying Claimshield to %s for %ims', mobArg:getPacketName(), shieldTime))
        mob:setPriorityRender(true) -- Make sure the mob is visible to all players
        startClaimShield(mobArg, shieldTime)

        mobArg:timer(shieldTime, function(mobArgTwo)
            local entries = collectEntries(mobArgTwo)

            endClaimShield(mobArgTwo)
            resolveLottery(mobArgTwo, entries)
        end)
    end)
end

for zoneName, entities in pairs(shieldedEntities) do
    for _, entity in ipairs(entities) do
        local mobName    = type(entity) == 'table' and entity.name or entity
        local shieldTime = type(entity) == 'table' and entity.time or claimshieldTime

        m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobInitialize', zoneName, mobName), function(mob)
            addClaimshield(mob, shieldTime)
            super(mob)
        end)
    end
end
