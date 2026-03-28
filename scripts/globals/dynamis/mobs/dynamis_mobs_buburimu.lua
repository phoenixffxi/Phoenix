-----------------------------------
-- Dynamis-Buburimu
-- Primary Source of Information: https://enedin.be/dyna/html/zone/bub.htm
-----------------------------------
local zoneID = xi.zone.DYNAMIS_BUBURIMU
xi = xi or { }
xi.dynamis = xi.dynamis or { }

-- Main spawn table for all 150 statues
xi.dynamis.spawnTable = xi.dynamis.spawnTable or { }
xi.dynamis.spawnTable[zoneID] =
{
    -- ID = { # to spawn, force spawn mobs }
    [16941136] = { 4, false }, -- (001-O) | RDM, THF, BRD
    [16941131] = { 2, false }, -- (002-O(MP)) | SMN, BST
    [16941126] = { 4, false }, -- (003-O) | WAR, WHM, NIN
    [16941124] = { 1, false }, -- (004-O) | SAM
    [16941118] = { 1, false }, -- (005-O) | BLM
    [16941111] = { 4, false }, -- (006-O) | DRG, BST, WAR
    [16941122] = { 1, false }, -- (007-O) | DRK
    [16941120] = { 1, false }, -- (008-O) | RDM
    [16941109] = { 1, false }, -- (009-O(HP)) | PLD
    [16941106] = { 2, false }, -- (010-O(MP)) | NIN, WHM
    [16941101] = { 4, false }, -- (011-O) | MNK, MNK, RNG
    [16941097] = { 2, false }, -- (012-O(MP)) | SMN, BRD
    [16941095] = { 1, false }, -- (013-O(HP)) | THF
    [16941077] = { 1, false }, -- (014-G) | BRD
    [16941071] = { 4, false }, -- (015-G) | THF, PLD, DRG
    [16941087] = { 2, false }, -- (016-G) | NIN, BST
    [16941091] = { 2, false }, -- (017-G) | SMN, SAM
    [16941079] = { 4, false }, -- (018-G) | RNG, DRK, WHM
    [16941085] = { 1, false }, -- (019-G) | BLM
    [16941069] = { 1, false }, -- (020-G(MP)) | BLM
    [16941057] = { 4, false }, -- (021-G) | MNK, WAR, SAM
    [16941064] = { 1, false }, -- (022-G(HP)) | SMN
    [16941062] = { 1, false }, -- (023-G(HP)) | NIN
    [16941067] = { 1, false }, -- (024-G(MP)) | RDM
    [16941142] = { 4, false }, -- (025-Q) | WAR, BST, BST
    [16941149] = { 2, false }, -- (026-Q) | BLM, BLM
    [16941152] = { 2, false }, -- (027-Q) | DRK, DRK
    [16941169] = { 4, false }, -- (028-Q) | PLD, NIN, NIN
    [16941174] = { 2, false }, -- (029-Q) | BRD, BRD
    [16941177] = { 2, false }, -- (030-Q) | DRG, DRG
    [16941155] = { 2, false }, -- (031-Q) | RDM, RDM
    [16941163] = { 2, false }, -- (032-Q) |
    [16941158] = { 4, false }, -- (033-Q) | WHM, MNK, MNK
    [16941166] = { 2, false }, -- (034-Q(MP)) | PLD, PLD
    [16941192] = { 2, false }, -- (035-Q) | BLM, BLM
    [16941187] = { 2, false }, -- (036-Q) | SMN, SMN
    [16941182] = { 4, false }, -- (037-Q) | THF, RNG, RNG
    [16941203] = { 2, false }, -- (038-Y(MP)) | MNK, SAM
    [16941200] = { 2, false }, -- (039-Y(HP)) | MNK, SAM
    [16941195] = { 4, false }, -- (040-Y) | WAR, RNG, DRK
    [16941212] = { 2, false }, -- (041-Y(HP)) | BST, DRG
    [16941217] = { 2, false }, -- (042-Y) | SMN, RDM
    [16941206] = { 4, false }, -- (043-Y) | WHM, BLM, RDM
    [16941221] = { 2, false }, -- (044-Y(MP)) | SMN, RDM
    [16941225] = { 2, false }, -- (045-Y(HP)) | BST, DRG
    [16941230] = { 2, false }, -- (046-Y) | DRK, DRK
    [16941233] = { 2, false }, -- (047-Y) | THF, WAR
    [16941236] = { 4, false }, -- (048-Y) | NIN, NIN, NIN
    [16941241] = { 2, false }, -- (049-Y) | THF, RNG
    [16941244] = { 4, false }, -- (050-Y) | RDM, PLD, PLD
    [16941254] = { 0, false }, -- (051-Shadow Dragon NM (Alkhla)) |
    [16941249] = { 0, false }, -- (052-Shadow Dragon NM (Stihi)) |
    [16941255] = { 0, false }, -- (053-Shadow Dragon NM (Basilic)) |
    [16941251] = { 0, false }, -- (054-Shadow Dragon NM (Jurik)) |
    [16941252] = { 0, false }, -- (055-Shadow Dragon NM (Barong)) |
    [16941253] = { 0, false }, -- (056-Shadow Dragon NM (Tarasca)) |
    [16941258] = { 0, false }, -- (057-Shadow Dragon NM (Stollen-wurm)) |
    [16941257] = { 0, false }, -- (058-Shadow Dragon NM (Koschei)) |
    [16941256] = { 0, false }, -- (059-Shadow Dragon NM (Aitvaras)) |
    [16941250] = { 0, false }, -- (060-Shadow Dragon NM (Vishap)) |
    [16941259] = { 0, false }, -- (061-Shadow Dragon NM (Apocalyptic Beast)(60)) |
    [16941266] = { 2, false }, -- (062-Nightmare Crab (×2)) |
    [16941268] = { 2, false }, -- (063-Nightmare Crab (×2)) |
    [16941270] = { 2, false }, -- (064-Nightmare Crab (×2)) |
    [16941272] = { 2, false }, -- (065-Nightmare Crab (×2)) |
    [16941274] = { 2, false }, -- (066-Nightmare Crab (×2)) |
    [16941276] = { 2, false }, -- (067-Nightmare Crab (×2)) |
    [16941278] = { 2, false }, -- (068-Nightmare Crab (×2)) |
    [16941280] = { 2, false }, -- (069-Nightmare Crab (×2)) |
    [16941282] = { 2, false }, -- (070-Nightmare Crab (×2)) |
    [16941284] = { 2, false }, -- (071-Nightmare Crab (×2)) |
    [16941469] = { 2, false }, -- (072-Nightmare Eft (×2)) |
    [16941471] = { 2, false }, -- (073-Nightmare Eft (×2)) |
    [16941473] = { 2, false }, -- (074-Nightmare Eft (×2)) |
    [16941475] = { 2, false }, -- (075-Nightmare Eft (×2)) |
    [16941477] = { 2, false }, -- (076-Nightmare Eft (×2)) |
    [16941479] = { 2, false }, -- (077-Nightmare Eft (×2)) |
    [16941481] = { 2, false }, -- (078-Nightmare Eft (×2)) |
    [16941483] = { 2, false }, -- (079-Nightmare Eft (×2)) |
    [16941485] = { 2, false }, -- (080-Nightmare Eft (×2)) |
    [16941487] = { 2, false }, -- (081-Nightmare Eft (×2)) |
    [16941355] = { 2, false }, -- (082-Nightmare Bunny (×2)) |
    [16941357] = { 2, false }, -- (083-Nightmare Bunny (×2)) |
    [16941359] = { 2, false }, -- (084-Nightmare Bunny (×2)) |
    [16941361] = { 2, false }, -- (085-Nightmare Bunny (×2)) |
    [16941363] = { 2, false }, -- (086-Nightmare Bunny (×2)) |
    [16941365] = { 2, false }, -- (087-Nightmare Bunny (×2)) |
    [16941367] = { 2, false }, -- (088-Nightmare Bunny (×2)) |
    [16941369] = { 2, false }, -- (089-Nightmare Bunny (×2)) |
    [16941371] = { 2, false }, -- (090-Nightmare Bunny (×2)) |
    [16941373] = { 2, false }, -- (091-Nightmare Bunny (×2)) |
    [16941399] = { 4, false }, -- (092-Nightmare Cockatrice (×4)) |
    [16941403] = { 4, false }, -- (093-Nightmare Cockatrice (×4)) |
    [16941407] = { 4, false }, -- (094-Nightmare Cockatrice (×4)) |
    [16941411] = { 4, false }, -- (095-Nightmare Cockatrice (×4)) |
    [16941415] = { 4, false }, -- (096-Nightmare Cockatrice (×4)) |
    [16941375] = { 3, false }, -- (097-Nightmare Mandragora (×3)) |
    [16941378] = { 3, false }, -- (098-Nightmare Mandragora (×3)) |
    [16941381] = { 3, false }, -- (099-Nightmare Mandragora (×3)) |
    [16941384] = { 3, false }, -- (100-Nightmare Mandragora (×3)) |
    [16941387] = { 3, false }, -- (101-Nightmare Mandragora (×3)) |
    [16941390] = { 3, false }, -- (102-Nightmare Mandragora (×3)) |
    [16941393] = { 3, false }, -- (103-Nightmare Mandragora (×3)) |
    [16941396] = { 3, false }, -- (104-Nightmare Mandragora (×3)) |
    [16941419] = { 2, false }, -- (105-Nightmare Raven (×2)) |
    [16941421] = { 2, false }, -- (106-Nightmare Raven (×2)) |
    [16941423] = { 2, false }, -- (107-Nightmare Raven (×2)) |
    [16941425] = { 2, false }, -- (108-Nightmare Raven (×2)) |
    [16941427] = { 2, false }, -- (109-Nightmare Raven (×2)) |
    [16941429] = { 2, false }, -- (110-Nightmare Raven (×2)) |
    [16941431] = { 2, false }, -- (111-Nightmare Raven (×2)) |
    [16941433] = { 2, false }, -- (112-Nightmare Raven (×2)) |
    [16941435] = { 2, false }, -- (113-Nightmare Raven (×2)) |
    [16941437] = { 2, false }, -- (114-Nightmare Raven (×2)) |
    [16941439] = { 2, false }, -- (115-Nightmare Raven (×2)) |
    [16941441] = { 2, false }, -- (116-Nightmare Raven (×2)) |
    [16941443] = { 2, false }, -- (117-Nightmare Raven (×2)) |
    [16941286] = { 2, false }, -- (118-Nightmare Dhalmel (×2)) |
    [16941288] = { 2, false }, -- (119-Nightmare Dhalmel (×2)) |
    [16941290] = { 2, false }, -- (120-Nightmare Dhalmel (×2)) |
    [16941292] = { 2, false }, -- (121-Nightmare Dhalmel (×2)) |
    [16941294] = { 2, false }, -- (122-Nightmare Dhalmel (×2)) |
    [16941296] = { 2, false }, -- (123-Nightmare Dhalmel (×2)) |
    [16941298] = { 2, false }, -- (124-Nightmare Dhalmel (×2)) |
    [16941300] = { 3, false }, -- (125-Nightmare Dhalmel (×3)) |
    [16941303] = { 3, false }, -- (126-Nightmare Dhalmel (×3)) |
    [16941306] = { 3, false }, -- (127-Nightmare Dhalmel (×3)) |
    [16941309] = { 3, false }, -- (128-Nightmare Dhalmel (×3)) |
    [16941445] = { 2, false }, -- (129-Nightmare Crawler (×2)) |
    [16941447] = { 2, false }, -- (130-Nightmare Crawler (×2)) |
    [16941449] = { 2, false }, -- (131-Nightmare Crawler (×2)) |
    [16941451] = { 3, false }, -- (132-Nightmare Crawler (×3)) |
    [16941454] = { 3, false }, -- (133-Nightmare Crawler (×3)) |
    [16941457] = { 2, false }, -- (134-Nightmare Crawler (×2)) |
    [16941459] = { 2, false }, -- (135-Nightmare Crawler (×2)) |
    [16941461] = { 2, false }, -- (136-Nightmare Crawler (×2)) |
    [16941463] = { 3, false }, -- (137-Nightmare Crawler (×3)) |
    [16941466] = { 3, false }, -- (138-Nightmare Crawler (×3)) |
    [16941312] = { 2, false }, -- (139-Nightmare Uragnite (×2)) |
    [16941314] = { 2, false }, -- (140-Nightmare Uragnite (×2)) |
    [16941316] = { 2, false }, -- (141-Nightmare Uragnite (×2)) |
    [16941318] = { 2, false }, -- (142-Nightmare Uragnite (×2)) |
    [16941320] = { 2, false }, -- (143-Nightmare Uragnite (×2)) |
    [16941322] = { 3, false }, -- (144-Nightmare Uragnite (×3)) |
    [16941325] = { 3, false }, -- (145-Nightmare Uragnite (×3)) |
    [16941328] = { 3, false }, -- (146-Nightmare Uragnite (×3)) |
    [16941331] = { 3, false }, -- (147-Nightmare Uragnite (×3)) |
    [16941334] = { 4, false }, -- (148-Nightmare Scorpion (×4)) |
    [16941338] = { 4, false }, -- (149-Nightmare Scorpion (×4)) |
    [16941342] = { 4, false }, -- (150-Nightmare Scorpion (×4)) |
    [16941346] = { 4, false }, -- (151-Nightmare Scorpion (×4)) |
    [16941350] = { 5, false }, -- (152-Nightmare Scorpion (×5)) |
}

xi.dynamis.eyeColor = xi.dynamis.eyeColor or {}
xi.dynamis.eyeColor[zoneID] =
{
    [16941131] = xi.dynamis.eye.GREEN, -- (002-O(MP))
    [16941109] = xi.dynamis.eye.BLUE,  -- (009-O(HP))
    [16941106] = xi.dynamis.eye.GREEN, -- (010-O(MP))
    [16941097] = xi.dynamis.eye.GREEN, -- (012-O(MP))
    [16941095] = xi.dynamis.eye.BLUE,  -- (013-O(HP))
    [16941069] = xi.dynamis.eye.GREEN, -- (020-O(MP))
    [16941064] = xi.dynamis.eye.BLUE,  -- (022-O(HP))
    [16941062] = xi.dynamis.eye.BLUE,  -- (023-O(HP))
    [16941067] = xi.dynamis.eye.GREEN, -- (024-O(MP))
    [16941166] = xi.dynamis.eye.GREEN, -- (034-O(MP))
    [16941203] = xi.dynamis.eye.GREEN, -- (038-O(MP))
    [16941200] = xi.dynamis.eye.BLUE,  -- (039-O(HP))
    [16941212] = xi.dynamis.eye.BLUE,  -- (041-O(HP))
    [16941221] = xi.dynamis.eye.GREEN, -- (044-O(MP))
    [16941225] = xi.dynamis.eye.BLUE,  -- (045-O(HP))
}

-- Wave spawn table for large waves
xi.dynamis.wave = xi.dynamis.wave or { }
xi.dynamis.wave[zoneID] =
{
    [1] = -- Spawns at start of the instance
    {
        16941259, -- (061)      Apocalyptic Beast
        16941249, -- (052)      Stihi
        16941254, -- (051)      Alklha
        16941255, -- (053)      Basilic
        16941251, -- (054)      Jurik
        16941252, -- (055)      Barong
        16941253, -- (056)      Tarasca
        16941258, -- (057)      Stollenwurm
        16941257, -- (058)      Koschei
        16941256, -- (059)      Aitvaras
        16941250, -- (060)      Vishap
        16941136, -- (001-O)    Serjeant Tombstone
        16941131, -- (002-O)    Serjeant Tombstone
        16941126, -- (003-O)    Serjeant Tombstone
        16941124, -- (004-O)    Serjeant Tombstone
        16941118, -- (005-O)    Serjeant Tombstone
        16941111, -- (006-O)    Serjeant Tombstone
        16941122, -- (007-O)    Serjeant Tombstone
        16941120, -- (008-O)    Serjeant Tombstone
        16941109, -- (009-O)    Serjeant Tombstone
        16941106, -- (010-O)    Serjeant Tombstone
        16941101, -- (011-O)    Serjeant Tombstone
        16941097, -- (012-O)    Serjeant Tombstone
        16941095, -- (013-O)    Serjeant Tombstone
        16941077, -- (014-G)    Goblin Replica
        16941071, -- (015-G)    Goblin Replica
        16941087, -- (016-G)    Goblin Replica
        16941091, -- (017-G)    Goblin Replica
        16941079, -- (018-G)    Goblin Replica
        16941085, -- (019-G)    Goblin Replica
        16941069, -- (020-G)    Goblin Replica
        16941057, -- (021-G)    Goblin Replica
        16941064, -- (022-G)    Goblin Replica
        16941062, -- (023-G)    Goblin Replica
        16941067, -- (024-G)    Goblin Replica
        16941142, -- (025-Q)    Adamantking Effigy
        16941149, -- (026-Q)    Adamantking Effigy
        16941152, -- (027-Q)    Adamantking Effigy
        16941169, -- (028-Q)    Adamantking Effigy
        16941174, -- (029-Q)    Adamantking Effigy
        16941177, -- (030-Q)    Adamantking Effigy
        16941155, -- (031-Q)    Adamantking Effigy
        16941163, -- (032-Q)    Adamantking Effigy
        16941158, -- (033-Q)    Adamantking Effigy
        16941166, -- (034-Q)    Adamantking Effigy
        16941192, -- (035-Q)    Adamantking Effigy
        16941187, -- (036-Q)    Adamantking Effigy
        16941182, -- (037-Q)    Adamantking Effigy
        16941203, -- (038-Y)    Manifest Icon
        16941200, -- (039-Y)    Manifest Icon
        16941195, -- (040-Y)    Manifest Icon
        16941212, -- (041-Y)    Manifest Icon
        16941217, -- (042-Y)    Manifest Icon
        16941206, -- (043-Y)    Manifest Icon
        16941221, -- (044-Y)    Manifest Icon
        16941225, -- (045-Y)    Manifest Icon
        16941230, -- (046-Y)    Manifest Icon
        16941233, -- (047-Y)    Manifest Icon
        16941236, -- (048-Y)    Manifest Icon
        16941241, -- (049-Y)    Manifest Icon
        16941244, -- (050-Y)    Manifest Icon
    },
    [2] = -- Demon NMs spawn Animated Weapons, Vanguard Dragons, Ying, Yang
    {
        16941266, -- 062-Nightmare Crab (×2)
        16941268, -- 063-Nightmare Crab (×2)
        16941270, -- 064-Nightmare Crab (×2)
        16941272, -- 065-Nightmare Crab (×2)
        16941274, -- 066-Nightmare Crab (×2)
        16941276, -- 067-Nightmare Crab (×2)
        16941278, -- 068-Nightmare Crab (×2)
        16941280, -- 069-Nightmare Crab (×2)
        16941282, -- 070-Nightmare Crab (×2)
        16941284, -- 071-Nightmare Crab (×2)
        16941469, -- 072-Nightmare Eft (×2)
        16941471, -- 073-Nightmare Eft (×2)
        16941473, -- 074-Nightmare Eft (×2)
        16941475, -- 075-Nightmare Eft (×2)
        16941477, -- 076-Nightmare Eft (×2)
        16941479, -- 077-Nightmare Eft (×2)
        16941481, -- 078-Nightmare Eft (×2)
        16941483, -- 079-Nightmare Eft (×2)
        16941485, -- 080-Nightmare Eft (×2)
        16941487, -- 081-Nightmare Eft (×2)
        16941355, -- 082-Nightmare Bunny (×2)
        16941357, -- 083-Nightmare Bunny (×2)
        16941359, -- 084-Nightmare Bunny (×2)
        16941361, -- 085-Nightmare Bunny (×2)
        16941363, -- 086-Nightmare Bunny (×2)
        16941365, -- 087-Nightmare Bunny (×2)
        16941367, -- 088-Nightmare Bunny (×2)
        16941369, -- 089-Nightmare Bunny (×2)
        16941371, -- 090-Nightmare Bunny (×2)
        16941373, -- 091-Nightmare Bunny (×2)
        16941399, -- 092-Nightmare Cockatrice (×4)
        16941403, -- 093-Nightmare Cockatrice (×4)
        16941407, -- 094-Nightmare Cockatrice (×4)
        16941411, -- 095-Nightmare Cockatrice (×4)
        16941415, -- 096-Nightmare Cockatrice (×4)
        16941375, -- 097-Nightmare Mandragora (×3)
        16941378, -- 098-Nightmare Mandragora (×3)
        16941381, -- 099-Nightmare Mandragora (×3)
        16941384, -- 100-Nightmare Mandragora (×3)
        16941387, -- 101-Nightmare Mandragora (×3)
        16941390, -- 102-Nightmare Mandragora (×3)
        16941393, -- 103-Nightmare Mandragora (×3)
        16941396, -- 104-Nightmare Mandragora (×3)
        16941419, -- 105-Nightmare Raven (×2)
        16941421, -- 106-Nightmare Raven (×2)
        16941423, -- 107-Nightmare Raven (×2)
        16941425, -- 108-Nightmare Raven (×2)
        16941427, -- 109-Nightmare Raven (×2)
        16941429, -- 110-Nightmare Raven (×2)
        16941431, -- 111-Nightmare Raven (×2)
        16941433, -- 112-Nightmare Raven (×2)
        16941435, -- 113-Nightmare Raven (×2)
        16941437, -- 114-Nightmare Raven (×2)
        16941439, -- 115-Nightmare Raven (×2)
        16941441, -- 116-Nightmare Raven (×2)
        16941443, -- 117-Nightmare Raven (×2)
        16941286, -- 118-Nightmare Dhalmel (×2)
        16941288, -- 119-Nightmare Dhalmel (×2)
        16941290, -- 120-Nightmare Dhalmel (×2)
        16941292, -- 121-Nightmare Dhalmel (×2)
        16941294, -- 122-Nightmare Dhalmel (×2)
        16941296, -- 123-Nightmare Dhalmel (×2)
        16941298, -- 124-Nightmare Dhalmel (×2)
        16941300, -- 125-Nightmare Dhalmel (×3)
        16941303, -- 126-Nightmare Dhalmel (×3)
        16941306, -- 127-Nightmare Dhalmel (×3)
        16941309, -- 128-Nightmare Dhalmel (×3)
        16941445, -- 129-Nightmare Crawler (×2)
        16941447, -- 130-Nightmare Crawler (×2)
        16941449, -- 131-Nightmare Crawler (×2)
        16941451, -- 132-Nightmare Crawler (×3)
        16941454, -- 133-Nightmare Crawler (×3)
        16941457, -- 134-Nightmare Crawler (×2)
        16941459, -- 135-Nightmare Crawler (×2)
        16941461, -- 136-Nightmare Crawler (×2)
        16941463, -- 137-Nightmare Crawler (×3)
        16941466, -- 138-Nightmare Crawler (×3)
        16941312, -- 139-Nightmare Uragnite (×2)
        16941314, -- 140-Nightmare Uragnite (×2)
        16941316, -- 141-Nightmare Uragnite (×2)
        16941318, -- 142-Nightmare Uragnite (×2)
        16941320, -- 143-Nightmare Uragnite (×2)
        16941322, -- 144-Nightmare Uragnite (×3)
        16941325, -- 145-Nightmare Uragnite (×3)
        16941328, -- 146-Nightmare Uragnite (×3)
        16941331, -- 147-Nightmare Uragnite (×3)
        16941334, -- 148-Nightmare Scorpion (×4)
        16941338, -- 149-Nightmare Scorpion (×4)
        16941342, -- 150-Nightmare Scorpion (×4)
        16941346, -- 151-Nightmare Scorpion (×4)
        16941350, -- 152-Nightmare Scorpion (×5)
    }
}

xi.bubu = xi.bubu or { }
xi.bubu.mobs =
{
    -- Boss
    APOCALYPTIC_BEAST = 16941259,
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.bubu.mobs.APOCALYPTIC_BEAST] = '[DYNA]MegaBossKilled',
}

xi.dynamis.spawnCheck = xi.dynamis.spawnCheck or {}
xi.dynamis.spawnCheck[zoneID] =
{
    {
        -- megaboss spawns statues around it
        requiredVars    = { '[DYNA]MegaBossKilled' },
        spawn           = xi.dynamis.wave[zoneID][2],
        spawnedVar      = '[DYNA]BossWaveSpawned',
    },
}

--Specific Statues
xi.dynamis.aggro = xi.dynamis.aggro or { }
xi.dynamis.aggro[zoneID] =
{
    nonAggressive =
    {
        -- Nothing
    },
    aggressive =
    {
        -- Nothing
    },
}

-- Pathing table
-- TODO: figure out what paths because apparently some do

xi.dynamis.timeExtension = xi.dynamis.timeExtension or { }
xi.dynamis.timeExtension[zoneID] =
{
    [xi.bubu.mobs.APOCALYPTIC_BEAST]  = 60, -- Boss
}
