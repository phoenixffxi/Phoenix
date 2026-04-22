-----------------------------------
-- Claim Shield
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('claim_shield')

local claimshieldTime = 7500

-- NOTE: These names are as they are as filenames.
-- Example: Behemoth's Dominion => Behemoths_Dominion
-- Example: King Behemoth       => King_Behemoth
-- { zone name, mob name }
-- Format:
local nmsToShield =
{
    { 'Attohwa_Chasm', 'Citipati' },
    { 'Attohwa_Chasm', 'Tiamat' },
    { 'Attohwa_Chasm', 'Xolotl' },
    { 'Batallia_Downs', 'Lumber_Jack' },
    { 'Beadeaux', 'GaBhu_Unvanquished' },
    { 'Beaucedine_Glacier', 'Nue' },
    { 'Bibiki_Bay', 'Intulo' },
    { 'Bostaunieux_Oubliette', 'Bloodsucker_NM' },
    { 'Bostaunieux_Oubliette', 'Drexerion_the_Condemned' },
    { 'Bostaunieux_Oubliette', 'Phanduron_the_Condemned' },
    { 'Bostaunieux_Oubliette', 'Sewer_Syrup' },
    { 'Caedarva_Mire', 'Khimaira' },
    { 'Cape_Teriggan', 'Kreutzet' },
    { 'Castle_Oztroja', 'Mee_Deggi_the_Punisher' },
    { 'Castle_Oztroja', 'Quu_Domi_the_Gallant' },
    { 'Castle_Oztroja', 'Tzee_Xicu_the_Manifest' },
    { 'Castle_Zvahl_Baileys', 'Duke_Haborym' },
    { 'Castle_Zvahl_Baileys', 'Grand_Duke_Batym' },
    { 'Castle_Zvahl_Baileys', 'Marquis_Allocen' },
    { 'Castle_Zvahl_Baileys', 'Marquis_Amon' },
    { 'Crawlers_Nest', 'Demonic_Tiphia' },
    { 'Den_of_Rancor', 'Friar_Rush' },
    { 'Den_of_Rancor', 'Tonberry_Decapitator' },
    { 'Den_of_Rancor', 'Tonberry_Tracker' },
    { 'East_Sarutabaruta', 'Spiny_Spipi' },
    { 'Eastern_Altepa_Desert', 'Centurio_XII-I' },
    { 'FeiYin', 'Capricious_Cassie' },
    { 'FeiYin', 'Eastern_Shadow' },
    { 'FeiYin', 'Northern_Shadow' },
    { 'FeiYin', 'Southern_Shadow' },
    { 'FeiYin', 'Western_Shadow' },
    { 'Garlaige_Citadel', 'Serket' },
    { 'Giddeus', 'Hoo_Mjuu_the_Torrent' },
    { 'Gustav_Tunnel', 'Amikiri' },
    { 'Gustav_Tunnel', 'Bune' },
    { 'Jugner_Forest', 'King_Arthro' },
    { 'Jugner_Forest', 'Panzer_Percival' },
    { 'King_Ranperres_Tomb', 'Vrtra' },
    { 'King_Ranperres_Tomb', 'Cemetery_Cherry' },
    { 'Konschtat_Highlands', 'Steelfleece_Baldarich' },
    { 'Konschtat_Highlands', 'Stray_Mary' },
    { 'Korroloka_Tunnel', 'Cargo_Crab_Colin' },
    { 'Kuftal_Tunnel', 'Amemet' },
    { 'Kuftal_Tunnel', 'Yowie' },
    { 'La_Theine_Plateau', 'Bloodtear_Baldurf' },
    { 'Labyrinth_of_Onzozo', 'Lord_of_Onzozo' },
    { 'Labyrinth_of_Onzozo', 'Mysticmaker_Profblix' },
    { 'Labyrinth_of_Onzozo', 'Ose' },
    { 'Lufaise_Meadows', 'Padfoot' },
    { 'Lufaise_Meadows', 'Megalobugard' },
    { 'Maze_of_Shakhrami', 'Argus' },
    { 'Maze_of_Shakhrami', 'Leech_King' },
    { 'Misareaux_Coast', 'Upyri' },
    { 'Misareaux_Coast', 'Odqan' },
    { 'Monastic_Cavern', 'Overlord_Bakgodek' },
    { 'Mount_Zhayolm', 'Cerberus' },
    { 'Ordelles_Caves', 'Morbolger' },
    { 'Promyvion-Dem', 'Satiator' },
    { 'Quicksand_Caves', 'Centurio_X-I' },
    { 'Quicksand_Caves', 'Sabotender_Bailarina' },
    { 'Qulun_Dome', 'ZaDha_Adamantking' },
    { 'Riverne-Site_A01', 'Carmine_Dobsonfly' },
    { 'Riverne-Site_B01', 'Boroka' },
    { 'Rolanberry_Fields', 'Eldritch_Edge' },
    { 'Rolanberry_Fields', 'Simurgh' },
    { 'Rolanberry_Fields_[S]', 'Lamina' },
    { 'RoMaeve', 'Shikigami_Weapon' },
    { 'Sacrarium', 'Elel' },
    { 'Sauromugue_Champaign', 'Blighting_Brand' },
    { 'Sauromugue_Champaign', 'Roc' },
    { 'Sauromugue_Champaign_[S]', 'Hyakinthos' },
    { 'Sea_Serpent_Grotto', 'Charybdis' },
    { 'Sea_Serpent_Grotto', 'Fyuu_the_Seabellow' },
    { 'Sea_Serpent_Grotto', 'Novv_the_Whitehearted' },
    { 'Sea_Serpent_Grotto', 'Sea_Hog' },
    { 'South_Gustaberg', 'Leaping_Lizzy' },
    { 'South_Gustaberg', 'Carnero' },
    { 'Temple_of_Uggalepih', 'Sozu_Sarberry' },
    { 'Temple_of_Uggalepih', 'Sozu_Terberry' },
    { 'The_Boyahda_Tree', 'Voluptuous_Vivian' },
    { 'The_Boyahda_Tree', 'Ancient_Goobbue' },
    { 'The_Sanctuary_of_ZiTah', 'Noble_Mold' },
    { 'The_Shrine_of_RuAvitau', 'Faust' },
    { 'The_Shrine_of_RuAvitau', 'Mother_Globe' },
    { 'Uleguerand_Range', 'Jormungand' },
    { 'Uleguerand_Range', 'Bonnacon' },
    { 'Upper_Delkfutts_Tower', 'Pallas' },
    { 'Valkurm_Dunes', 'Valkurm_Emperor' },
    { 'VeLugannon_Palace', 'Zipacna' },
    { 'Wajaom_Woodlands', 'Hydra' },
    { 'Wajaom_Woodlands', 'Jaded_Jody' },
    { 'Wajaom_Woodlands', 'Zoraal_Jas_Pkuucha' },
    { 'Western_Altepa_Desert', 'King_Vinegarroon' },
    { 'Xarcabard', 'Biast' },
    { 'Yhoator_Jungle', 'Bright-handed_Kunberry' },
    { 'Yuhtunga_Jungle', 'Rose_Garden' },
    { 'Yuhtunga_Jungle', 'Voluptuous_Vilma' },
}

-- Find the position of a target entity in a table,
-- only if they have matching ids
local tableFindPosByID = function(t, target)
    for index, entity in ipairs(t) do
        if entity:getID() == target:getID() then
            return index
        end
    end

    return nil
end

-- Using entity ids: dedupe a table in-place
local dedupeByID = function(t)
    local seen = {}
    for index, entity in ipairs(t) do
        if seen[entity:getID()] then
            table.remove(t, index)
        else
            seen[entity:getID()] = true
        end
    end
end

-- Called when the claimshield period ends
local timerFunc = function(mob)
    local enmityList = mob:getEnmityList()

    -- Filter so that pets will only count as a single entry along
    -- with their masters
    local entries = {}
    for _, v in pairs(enmityList) do
        local entity = v['entity']
        local master = entity:getMaster()
        if
            not entity:isPC() and
            master and
            master:isPC()
        then
            table.insert(entries, master)
        else
            table.insert(entries, entity)
        end
    end

    -- Remove duplicates from entries table caused by pets or other shenanigans
    dedupeByID(entries)

    local numEntries = #entries

    mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.EXCLUSIVE)
    mob:setUnkillable(false)
    mob:setCallForHelpBlocked(false)

    mob:resetAI()
    mob:setHP(mob:getMaxHP())
    mob:delStatusEffectsByFlag(0xFFFF) -- Delete all effects with all flags

    -- Select a winner
    local claimWinner = utils.randomEntry(entries)
    if claimWinner then
        mob:updateClaim(claimWinner)

        -- Message winner and their party/alliance that they've won
        local alliance = claimWinner:getAlliance()
        for _, member in pairs(alliance) do
            local str = string.format('Your group has won the lottery for %s! (out of %i players)', mob:getPacketName(), numEntries)
            if #alliance == 1 then
                str = string.format('You have won the lottery for %s! (out of %i players)', mob:getPacketName(), numEntries)
            end

            member:printToPlayer(str, xi.msg.channel.SYSTEM_3, '')

            -- Remove from entries table
            local pos = tableFindPosByID(entries, member)
            if pos then
                table.remove(entries, pos)
            end
        end

        -- Everyone left in the entries table isn't part of the winning group, message them and
        -- clear them from the enmity list
        for _, member in pairs(entries) do
            local str = string.format('Your group was not successful in the lottery for %s. (out of %i players)', mob:getPacketName(), numEntries)
            if #alliance == 1 then
                str = string.format('Your were not successful in the lottery for %s. (out of %i players)', mob:getPacketName(), numEntries)
            end

            member:printToPlayer(str, xi.msg.channel.SYSTEM_3, '')
            mob:clearEnmityForEntity(member)
        end
    end
end

-- Called on entity onMobSpawn, sets up timerFunc
local listenerFunc = function(mob)
    print(string.format('Applying Claimshield to %s for %ims', mob:getPacketName(), claimshieldTime))

    mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.UNCLAIMABLE)
    mob:setUnkillable(true)
    mob:setCallForHelpBlocked(true)
    mob:stun(claimshieldTime)

    mob:timer(claimshieldTime, timerFunc)
end

-- Main entrypoint of each override
local overrideFunc = function(mob)
    mob:addListener('SPAWN', string.format('%s_CS_SPAWN', mob:getPacketName()), listenerFunc)

    -- Call original onMobInitialize
    super(mob)
end

-- NOTE: At the time we iterate over these entries, the Lua zone and mob objects won't be ready,
--     : so we deal with everything as strings for now.
for _, entry in pairs(nmsToShield) do
    m:addOverride(string.format('xi.zones.%s.mobs.%s.onMobInitialize', entry[1], entry[2]), overrideFunc)
end

return m
