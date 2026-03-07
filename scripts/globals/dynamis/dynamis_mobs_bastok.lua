-----------------------------------
--                            Dynamis-Bastok
--    Primary Source of Information: https://enedin.be/dyna/html/zone/bas.htm
-- Secondary Source of Information: http://www.dynamisbums.com/strategy/bas.html
-----------------------------------
local zoneID = xi.zone.DYNAMIS_BASTOK
xi = xi or { }
xi.dynamis = xi.dynamis or { }
xi.dynamis.wave = xi.dynamis.wave or { }
xi.dynamis.aggro = xi.dynamis.aggro or { }
xi.dynamis.paths = xi.dynamis.paths or { }
xi.dynamis.spawnTable = xi.dynamis.spawnTable or { }
xi.dynamis.nmDeathActions = xi.dynamis.nmDeathActions or { }
xi.dynamis.timeExtension = xi.dynamis.timeExtension or { }
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.spawnCheck    = xi.dynamis.spawnCheck or {}
xi.bastok = xi.bastok or { }

-- Main spawn table for all 150 statues
xi.dynamis.spawnTable[zoneID] =
{
    -- ID = { # to spawn, eye color, force spawn mobs }
    -- Q = Serjeant Tombstone
    [17539424] = { 2, xi.dynamis.eye.RED   }, -- (1-Q) | WHM
    [17539427] = { 2, xi.dynamis.eye.RED   }, -- (2-Q) |
    [17539430] = { 2, xi.dynamis.eye.RED   }, -- (3-Q) | PLD, WHM
    [17539346] = { 2, xi.dynamis.eye.RED   }, -- (4-Q) | DRG, THF, WHM
    [17539342] = { 2, xi.dynamis.eye.RED   }, -- (5-Q) | MNK, MNK, DRK
    [17539409] = { 2, xi.dynamis.eye.RED   }, -- (6-Q) | WHM, WAR, RNG, MNK, BLM, RNG
    [17539414] = { 2, xi.dynamis.eye.BLUE  }, -- (7-Q) |
    [17539419] = { 2, xi.dynamis.eye.BLUE  }, -- (8-Q) |
    [17539357] = { 2, xi.dynamis.eye.RED   }, -- (9-Q) | DRK, BRD
    [17539363] = { 2, xi.dynamis.eye.RED   }, -- (10-Q) | WAR, NIN
    [17539373] = { 3, xi.dynamis.eye.RED   }, -- (11-Q) | PLD, NIN
    [17539352] = { 3, xi.dynamis.eye.RED   }, -- (12-Q) |
    [17539360] = { 2, xi.dynamis.eye.RED   }, -- (13-Q) |
    [17539349] = { 2, xi.dynamis.eye.RED   }, -- (14-Q) | PLD, MNK, BLM
    [17539372] = { 0, xi.dynamis.eye.RED   }, -- (15-Q) | DRK, MNK, BLM
    [17539370] = { 1, xi.dynamis.eye.RED   }, -- (16-Q) | DRG, BLM
    [17539369] = { 0, xi.dynamis.eye.RED   }, -- (17-Q) | WAR, BRD
    [17539367] = { 1, xi.dynamis.eye.RED   }, -- (18-Q) | PLD, NIN
    [17539366] = { 0, xi.dynamis.eye.RED   }, -- (19-Q) | DRK, THF
    [17539381] = { 3, xi.dynamis.eye.RED   }, -- (20-Q) |
    [17539377] = { 2, xi.dynamis.eye.RED   }, -- (21-Q) | NIN
    [17539433] = { 2, xi.dynamis.eye.RED   }, -- (22-Q) | PLD, DRK, BST
    [17539436] = { 2, xi.dynamis.eye.RED   }, -- (23-Q) | RNG, RNG
    [17539399] = { 2, xi.dynamis.eye.RED   }, -- (24-Q) | RNG
    [17539402] = { 2, xi.dynamis.eye.BLUE  }, -- (25-Q) | DRG, THF
    [17539405] = { 0, xi.dynamis.eye.GREEN }, -- (26-Q) | DRK
    [17539406] = { 2, xi.dynamis.eye.RED   }, -- (27-Q) |
    [17539385] = { 0, xi.dynamis.eye.RED   }, -- (28-Q) |
    [17539386] = { 2, xi.dynamis.eye.RED   }, -- (29-Q) |
    [17539389] = { 2, xi.dynamis.eye.RED   }, -- (30-Q) |
    [17539392] = { 2, xi.dynamis.eye.GREEN }, -- (31-Q) | WHM
    [17539395] = { 3, xi.dynamis.eye.RED   }, -- (32-Q) |
    [17539331] = { 2, xi.dynamis.eye.RED   }, -- (33-Q) | WAR, THF, RDM
    [17539446] = { 2, xi.dynamis.eye.RED, 1 }, -- (34-Q) | PLD, BLM
    [17539334] = { 3, xi.dynamis.eye.RED   }, -- (35-Q) | DRK, MNK, BRD
    [17539280] = { 3, xi.dynamis.eye.RED   }, -- (36-Q) | WAR, MNK, WHM
    [17539338] = { 3, xi.dynamis.eye.RED   }, -- (37-Q) | PLD, MNK, WHM
    [17539229] = { 0, xi.dynamis.eye.GREEN }, -- (38-Q) | DRK, MNK, WHM
    [17539228] = { 0, xi.dynamis.eye.BLUE  }, -- (39-Q) | DRG, MNK, WHM
    [17539194] = { 1, xi.dynamis.eye.RED   }, -- (40-Q) | WAR, THF
    [17539227] = { 0, xi.dynamis.eye.BLUE  }, -- (41-Q) | WHM  **MAP HAS THEM SWAPPED THIS IS CORRECT
    [17539230] = { 3, xi.dynamis.eye.RED, 1 }, -- (42-Q) | SMN  **MAP HAS THEM SWAPPED THIS IS CORRECT
    [17539328] = { 2, xi.dynamis.eye.RED   }, -- (43-Q) |
    [17539325] = { 2, xi.dynamis.eye.RED   }, -- (44-Q) |
    [17539321] = { 3, xi.dynamis.eye.RED   }, -- (45-Q) |
    [17539317] = { 3, xi.dynamis.eye.RED   }, -- (46-Q) | BST, BST
    [17539309] = { 3, xi.dynamis.eye.RED   }, -- (47-Q) |
    [17539313] = { 3, xi.dynamis.eye.RED   }, -- (48-Q) |
    [17539307] = { 1, xi.dynamis.eye.RED   }, -- (49-Q) |
    [17539259] = { 2, xi.dynamis.eye.RED   }, -- (50-Q) | BST, BST
    [17539302] = { 3, xi.dynamis.eye.RED   }, -- (51-Q) |
    [17539298] = { 3, xi.dynamis.eye.RED   }, -- (52-Q) |
    [17539294] = { 2, xi.dynamis.eye.RED, 1 }, -- (53-Q) |
    [17539297] = { 0, xi.dynamis.eye.RED   }, -- (54-Q) | BST, BST
    [17539290] = { 2, xi.dynamis.eye.RED   }, -- (55-Q) |
    [17539284] = { 1, xi.dynamis.eye.RED   }, -- (56-Q) |
    [17539287] = { 1, xi.dynamis.eye.RED   }, -- (57-Q) |
    [17539171] = { 3, xi.dynamis.eye.RED   }, -- (58-Q) | BST, BST
    [17539188] = { 2, xi.dynamis.eye.RED   }, -- (59-Q) | NIN, RDM
    [17539179] = { 3, xi.dynamis.eye.RED   }, -- (60-Q) | PLD, THF
    [17539175] = { 3, xi.dynamis.eye.RED   }, -- (61-Q) | THF, BLM
    [17539191] = { 2, xi.dynamis.eye.RED, 1 }, -- (62-Q) | NIN, BRD
    [17539183] = { 3, xi.dynamis.eye.RED   }, -- (63-Q) | DRG
    [17539134] = { 3, xi.dynamis.eye.RED   }, -- (64-Q) | DRK, BRD
    [17539167] = { 3, xi.dynamis.eye.RED   }, -- (65-Q) | PLD, RDM
    [17539159] = { 3, xi.dynamis.eye.RED   }, -- (66-Q) | WAR, BRD
    [17539158] = { 0, xi.dynamis.eye.RED   }, -- (67-Q) | RDM
    [17539163] = { 3, xi.dynamis.eye.RED   }, -- (68-Q) | DRG, MNK
    [17539155] = { 2, xi.dynamis.eye.RED, 1 }, -- (69-Q) | NIN, BLM
    [17539139] = { 2, xi.dynamis.eye.RED   }, -- (70-Q) | DRG, RDM
    [17539142] = { 1, xi.dynamis.eye.RED   }, -- (71-Q) | PLD, BLM
    [17539144] = { 2, xi.dynamis.eye.RED   }, -- (72-Q) |
    [17539148] = { 2, xi.dynamis.eye.RED   }, -- (73-Q) | PLD, MNK, RDM
    [17539154] = { 0, xi.dynamis.eye.RED   }, -- (74-Q) | SMN
    [17539125] = { 2, xi.dynamis.eye.RED   }, -- (75-Q) | SMN
    [17539122] = { 2, xi.dynamis.eye.RED   }, -- (76-Q) | WHM
    [17539118] = { 2, xi.dynamis.eye.RED   }, -- (77-Q) | WHM
    [17539110] = { 3, xi.dynamis.eye.RED   }, -- (78-Q) |
    [17539114] = { 3, xi.dynamis.eye.RED   }, -- (79-Q) | DRK, BRD
    [17539109] = { 0, xi.dynamis.eye.RED   }, -- (80-Q) | DRG, NIN, RDM
    [17539108] = { 0, xi.dynamis.eye.GREEN }, -- (81-Q) | NIN
    [17539132] = { 1, xi.dynamis.eye.BLUE  }, -- (82-Q) | DRK, MNK, RDM
    [17539105] = { 2, xi.dynamis.eye.RED   }, -- (83-Q) | PLD, THF, BLM
    [17539097] = { 0, xi.dynamis.eye.RED   }, -- (84-Q) | WAR, RDM
    [17539096] = { 0, xi.dynamis.eye.BLUE  }, -- (85-Q) | WAR, MNK, RDM
    [17539102] = { 2, xi.dynamis.eye.RED   }, -- (86-Q) | DRK, THF
    [17539098] = { 3, xi.dynamis.eye.RED   }, -- (87-Q) | BLM
    [17539085] = { 3, xi.dynamis.eye.RED   }, -- (88-Q) | WAR, THF
    [17539089] = { 6, xi.dynamis.eye.RED   }, -- (89-Q) | PLD, MNK, BRD
    [17539077] = { 2, xi.dynamis.eye.RED   }, -- (90-Q) | PLD, NIN, RDM
    [17539073] = { 2, xi.dynamis.eye.RED   }, -- (91-Q) | DRG, BRD
    [17539076] = { 0, xi.dynamis.eye.BLUE  }, -- (92-Q) | WAR, THF
    [17539080] = { 3, xi.dynamis.eye.RED   }, -- (93-Q) | DRK, BLM
    [17539279] = { 0, xi.dynamis.eye.BLUE  }, -- (94-Q) | DRG, BRD
    [17539240] = { 2, xi.dynamis.eye.RED   }, -- (95-Q) | BRD
    [17539237] = { 2, xi.dynamis.eye.RED   }, -- (96-Q) | NIN, WHM
    [17539243] = { 2, xi.dynamis.eye.RED   }, -- (97-Q) | BRD
    [17539246] = { 2, xi.dynamis.eye.RED   }, -- (98-Q) |
    [17539253] = { 2, xi.dynamis.eye.RED   }, -- (99-Q) | THF
    [17539256] = { 2, xi.dynamis.eye.RED   }, -- (100-Q) |
    [17539249] = { 2, xi.dynamis.eye.RED   }, -- (101-Q) | RDM
    [17539439] = { 1, xi.dynamis.eye.RED   }, -- (102-Q) |
    [17539444] = { 0, xi.dynamis.eye.RED   }, -- (103-Q) | WAR, NIN, BLM
    [17539442] = { 0, xi.dynamis.eye.GREEN }, -- (104-Q) | DRG, RDM
    [17539262] = { 2, xi.dynamis.eye.RED   }, -- (105-Q) | DRK, NIN, BLM
    [17539269] = { 2, xi.dynamis.eye.RED   }, -- (106-Q) |
    [17539265] = { 2, xi.dynamis.eye.RED   }, -- (107-Q) | NIN, PLD
    [17539272] = { 2, xi.dynamis.eye.RED   }, -- (108-Q) | WAR
    [17539276] = { 2, xi.dynamis.eye.RED   }, -- (109-Q) | BRD, BLM
    [17539449] = { 5, xi.dynamis.eye.RED, 1 }, -- (110-Q) | DRK, NIN, WHM
    [17539461] = { 5, xi.dynamis.eye.RED, 1 }, -- (111-Q) | RNG, MNK
    [17539471] = { 3, xi.dynamis.eye.BLUE  }, -- (112-Q) | WAR, WHM
    [17539475] = { 3, xi.dynamis.eye.RED   }, -- (113-Q) |
    [17539479] = { 3, xi.dynamis.eye.GREEN }, -- (114-Q) | THF, RDM
    [17539483] = { 3, xi.dynamis.eye.RED   }, -- (115-Q) | BST, BST
    [17539487] = { 3, xi.dynamis.eye.BLUE  }, -- (116-Q) | BST, BST
    [17539506] = { 3, xi.dynamis.eye.RED   }, -- (117-Q) | BST, BST
    [17539501] = { 4, xi.dynamis.eye.RED   }, -- (118-Q) | NIN, BLM
    [17539496] = { 4, xi.dynamis.eye.BLUE  }, -- (119-Q) | BRD
    [17539491] = { 4, xi.dynamis.eye.BLUE  }, -- (120-Q) | WAR, RDM
    [17539525] = { 3, xi.dynamis.eye.GREEN }, -- (121-Q) | DRK, BRD
    [17539532] = { 4, xi.dynamis.eye.BLUE  }, -- (122-Q) | BLM
    [17539537] = { 4, xi.dynamis.eye.RED   }, -- (123-Q) | THF
    [17539542] = { 3, xi.dynamis.eye.BLUE  }, -- (124-Q) |
    [17539546] = { 3, xi.dynamis.eye.GREEN }, -- (125-Q) |
    [17539513] = { 3, xi.dynamis.eye.RED   }, -- (126-Q) |
    [17539517] = { 3, xi.dynamis.eye.GREEN }, -- (127-Q) |
    [17539521] = { 3, xi.dynamis.eye.RED   }, -- (128-Q) |
    [17539554] = { 2, xi.dynamis.eye.GREEN }, -- (129-Q) | WHM
    [17539550] = { 2, xi.dynamis.eye.RED   }, -- (130-Q) |
    [17539559] = { 2, xi.dynamis.eye.RED   }, -- (131-Q) |
    [17539563] = { 3, xi.dynamis.eye.BLUE  }, -- (132-Q) |
    [17539594] = { 3, xi.dynamis.eye.BLUE  }, -- (133-Q) |
    [17539567] = { 2, xi.dynamis.eye.RED   }, -- (134-Q) | WAR, WAR, WAR
    [17539591] = { 2, xi.dynamis.eye.RED   }, -- (135-Q) | BLM, BLM, BLM
    [17539598] = { 3, xi.dynamis.eye.RED   }, -- (136-Q) | MNK, MNK, MNK
    [17539603] = { 3, xi.dynamis.eye.RED   }, -- (137-Q) | DRK, DRK, DRK
    [17539570] = { 2, xi.dynamis.eye.BLUE  }, -- (138-Q) | RNG, RNG, RNG
    [17539588] = { 2, xi.dynamis.eye.BLUE  }, -- (139-Q) | PLD, PLD, PLD, PLD
    [17539573] = { 3, xi.dynamis.eye.RED   }, -- (140-Q) | WHM, WHM, WHM, WHM
    [17539584] = { 3, xi.dynamis.eye.RED   }, -- (141-Q) | THF, THF, THF, THF
    [17539577] = { 3, xi.dynamis.eye.RED   }, -- (142-Q) | DRG, DRG, DRG
}

xi.bastok.mobs =
{
    -- Statues
    ADAMANTKING_EFFIGY_001 = 17539424,
    ADAMANTKING_EFFIGY_019 = 17539366,
    ADAMANTKING_EFFIGY_041 = 17539227,
    VANGUARD_CONSTABLE_89  = 17539090,
    VANGUARD_VINDICATOR_89 = 17539091,
    VANGUARD_MILITANT_89   = 17539093,
    -- NMs
    GUNHI_NOONDOZER        = 17539291,
    KODHO_CANNONBALL       = 17539156,
    GIPHA_MANAMEISTER      = 17539295,
    ZEVHO_FALLSPLITTER     = 17539074,
    -- Boss
    GUDHA_EFFIGY           = 17539449,
}

-- Wave spawn table for large waves
xi.dynamis.wave[zoneID] =
{
    [1] = -- Spawns at start of the instance
    {
        17539424, -- (001-Q) Adamantking Effigy
        17539427, -- (002-Q) Adamantking Effigy
        17539430, -- (003-Q) Adamantking Effigy
        17539346, -- (004-Q) Adamantking Effigy
        17539342, -- (005-Q) Adamantking Effigy
        17539409, -- (006-Q) Adamantking Effigy
        17539414, -- (007-Q) Adamantking Effigy
        17539419, -- (008-Q) Adamantking Effigy
        17539357, -- (009-Q) Adamantking Effigy
        17539363, -- (010-Q) Adamantking Effigy
        17539373, -- (011-Q) Adamantking Effigy
        17539352, -- (012-Q) Adamantking Effigy
        17539360, -- (013-Q) Adamantking Effigy
        17539349, -- (014-Q) Adamantking Effigy
        17539372, -- (015-Q) Adamantking Effigy
        17539370, -- (016-Q) Adamantking Effigy
        17539369, -- (017-Q) Adamantking Effigy
        17539367, -- (018-Q) Adamantking Effigy
        17539366, -- (019-Q) Adamantking Effigy
        17539381, -- (020-Q) Adamantking Effigy
        17539377, -- (021-Q) Adamantking Effigy
        17539433, -- (022-Q) Adamantking Effigy
        17539436, -- (023-Q) Adamantking Effigy
        17539399, -- (024-Q) Adamantking Effigy
        17539402, -- (025-Q) Adamantking Effigy
        17539406, -- (027-Q) Adamantking Effigy
        17539385, -- (028-Q) Adamantking Effigy
        17539395, -- (032-Q) Adamantking Effigy
        17539331, -- (033-Q) Adamantking Effigy
        17539446, -- (034-Q) Adamantking Effigy
        17539334, -- (035-Q) Adamantking Effigy
        17539280, -- (036-Q) Adamantking Effigy
        17539338, -- (037-Q) Adamantking Effigy
        17539229, -- (038-Q) Adamantking Effigy
        17539228, -- (039-Q) Adamantking Effigy
        17539194, -- (040-Q) Adamantking Effigy
        17539227, -- (041-Q) Adamantking Effigy
        17539230, -- (042-Q) Adamantking Effigy
        17539328, -- (043-Q) Adamantking Effigy
        17539325, -- (044-Q) Adamantking Effigy
        17539321, -- (045-Q) Adamantking Effigy
        17539317, -- (046-Q) Adamantking Effigy
        17539309, -- (047-Q) Adamantking Effigy
        17539313, -- (048-Q) Adamantking Effigy
        17539307, -- (049-Q) Adamantking Effigy
        17539259, -- (050-Q) Adamantking Effigy
        17539302, -- (051-Q) Adamantking Effigy
        17539298, -- (052-Q) Adamantking Effigy
        17539294, -- (053-Q) Adamantking Effigy
        17539290, -- (055-Q) Adamantking Effigy
        17539284, -- (056-Q) Adamantking Effigy
        17539287, -- (057-Q) Adamantking Effigy
        17539171, -- (058-Q) Adamantking Effigy
        17539188, -- (059-Q) Adamantking Effigy
        17539179, -- (060-Q) Adamantking Effigy
        17539175, -- (061-Q) Adamantking Effigy
        17539191, -- (062-Q) Adamantking Effigy
        17539183, -- (063-Q) Adamantking Effigy
        17539134, -- (064-Q) Adamantking Effigy
        17539167, -- (065-Q) Adamantking Effigy
        17539159, -- (066-Q) Adamantking Effigy
        17539158, -- (067-Q) Adamantking Effigy
        17539163, -- (068-Q) Adamantking Effigy
        17539155, -- (069-Q) Adamantking Effigy
        17539139, -- (070-Q) Adamantking Effigy
        17539142, -- (071-Q) Adamantking Effigy
        17539144, -- (072-Q) Adamantking Effigy
        17539148, -- (073-Q) Adamantking Effigy
        17539154, -- (074-Q) Adamantking Effigy
        17539125, -- (075-Q) Adamantking Effigy
        17539122, -- (076-Q) Adamantking Effigy
        17539118, -- (077-Q) Adamantking Effigy
        17539110, -- (078-Q) Adamantking Effigy
        17539114, -- (079-Q) Adamantking Effigy
        17539109, -- (080-Q) Adamantking Effigy
        17539108, -- (081-Q) Adamantking Effigy
        17539132, -- (082-Q) Adamantking Effigy
        17539105, -- (083-Q) Adamantking Effigy
        17539097, -- (084-Q) Adamantking Effigy
        17539096, -- (085-Q) Adamantking Effigy
        17539102, -- (086-Q) Adamantking Effigy
        17539098, -- (087-Q) Adamantking Effigy
        17539085, -- (088-Q) Adamantking Effigy
        17539077, -- (090-Q) Adamantking Effigy
        17539073, -- (091-Q) Adamantking Effigy
        17539080, -- (093-Q) Adamantking Effigy
        17539279, -- (094-Q) Adamantking Effigy
        17539240, -- (095-Q) Adamantking Effigy
        17539237, -- (096-Q) Adamantking Effigy
        17539243, -- (097-Q) Adamantking Effigy
        17539246, -- (098-Q) Adamantking Effigy
        17539253, -- (099-Q) Adamantking Effigy
        17539256, -- (100-Q) Adamantking Effigy
        17539249, -- (101-Q) Adamantking Effigy
        17539439, -- (102-Q) Adamantking Effigy
        17539444, -- (103-Q) Adamantking Effigy
        17539442, -- (104-Q) Adamantking Effigy
        17539262, -- (105-Q) Adamantking Effigy
        17539269, -- (106-Q) Adamantking Effigy
        17539265, -- (107-Q) Adamantking Effigy
        17539272, -- (108-Q) Adamantking Effigy
        17539276, -- (109-Q) Adamantking Effigy
    },
    [2] = -- Wave 2 spawns when Overlord's Tombstone (Mega Boss) is defeated
    {
        17539471, -- (112-Q) Adamantking Effigy
        17539475, -- (113-Q) Adamantking Effigy
        17539479, -- (114-Q) Adamantking Effigy
        17539483, -- (115-Q) Adamantking Effigy
        17539487, -- (116-Q) Adamantking Effigy
        17539506, -- (117-Q) Adamantking Effigy
        17539501, -- (118-Q) Adamantking Effigy
        17539496, -- (119-Q) Adamantking Effigy
        17539491, -- (120-Q) Adamantking Effigy
        17539525, -- (121-Q) Adamantking Effigy
        17539532, -- (122-Q) Adamantking Effigy
        17539537, -- (123-Q) Adamantking Effigy
        17539542, -- (124-Q) Adamantking Effigy
        17539546, -- (125-Q) Adamantking Effigy
        17539513, -- (126-Q) Adamantking Effigy
        17539517, -- (127-Q) Adamantking Effigy
        17539521, -- (128-Q) Adamantking Effigy
        17539554, -- (129-Q) Adamantking Effigy
        17539550, -- (130-Q) Adamantking Effigy
        17539559, -- (131-Q) Adamantking Effigy
        17539563, -- (132-Q) Adamantking Effigy
        17539594, -- (133-Q) Adamantking Effigy
        17539567, -- (134-Q) Adamantking Effigy
        17539591, -- (135-Q) Adamantking Effigy
        17539598, -- (136-Q) Adamantking Effigy
        17539603, -- (137-Q) Adamantking Effigy
        17539570, -- (138-Q) Adamantking Effigy
        17539588, -- (139-Q) Adamantking Effigy
        17539573, -- (140-Q) Adamantking Effigy
        17539584, -- (141-Q) Adamantking Effigy
        17539577, -- (142-Q) Adamantking Effigy
    },
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.bastok.mobs.GUDHA_EFFIGY]       = '[DynaBastok]MegaBossKilled',
    [xi.bastok.mobs.KODHO_CANNONBALL]   = '[DynaBastok]KoDhoKilled',
    [xi.bastok.mobs.GIPHA_MANAMEISTER]  = '[DynaBastok]GiPhaKilled',
    [xi.bastok.mobs.ZEVHO_FALLSPLITTER] = '[DynaBastok]ZeVhoKilled',
}

xi.dynamis.spawnCheck[zoneID] =
{
    {
        -- Spawn the Mega Boss if all 3 NMs died
        requiredVars    = { '[DynaBastok]KoDhoKilled', '[DynaBastok]GiPhaKilled', '[DynaBastok]ZeVhoKilled', },
        spawn           = { xi.bastok.mobs.GUDHA_EFFIGY },
        spawnedVar      = '[DynaBastok]MegaBossSpawned',
    },
    {
        -- Spawn mobs when the Mega Boss is killed
        requiredVars    = { '[DynaBastok]MegaBossKilled' },
        spawn           = xi.dynamis.wave[zoneID][2],
        spawnedVar      = '[DynaBastok]Wave2Spawned',
    },
}

--Specific Statues
xi.dynamis.aggro[zoneID] =
{
    nonAggressive =
    {
        -- Nothing
    },
    aggressive =
    {
        [17539402] = { 17539405 }, -- Statue 25 spawns 26
        [17539385] = { 17539386, 17539389, 17539392 }, -- 28 spawns 29, 30, 31
        [17539085] = { 17539089 }, -- 88 spawns 89
        [xi.bastok.mobs.GUDHA_EFFIGY] = { 17539461 }, -- Spawns 1 statue
    },
}

-- Pathing table
xi.dynamis.paths[zoneID] =
{
    [17539409] = { { 40,    0,   -85 },  {   40,    1,  -96 }                      }, -- W1 Choc C
    [17539357] = { { 20,    0,   -79 },  {   16,   -3,  -64 }                      }, -- W1 AH EE
    [17539373] = { {  7,    0,  -100 },  {    5,    0,  -79 }                      }, -- W1 W of Choc
    [17539352] = { {  0,    0,   -79 },  {   0,    -3,  -64 }                      }, -- W1 AH C
    [17539349] = { { -20,    0,  -79 },  {  -16,   -3,  -64 }                      }, -- W1 AH WW
    [17539377] = { { -24,    0, -100 },  {  -24,    0,  -79 }                      }, -- W1 W of Choc
    [17539402] = { { -10,   -1, -114 },  {  -25,   -1, -114 }                      }, -- W1 S.Gate S
    [17539395] = { { -32,    0,  -38 },  {  -45,    0,  -38 }                      }, -- W1 W of AH (C)
    [17539446] = { { -44,    0,  -29 },  {  -42,    0,   -9 }                      }, -- W1 W of AH (NW)
    [17539334] = { {  3,    0,   -25 },  {  -12,    0,  -25 }                      }, -- W1 AH N.Alley C
    [17539309] = { {   31,    7,  -2 },  {    4,    7,   -2 }                      }, -- W1 O.St. NE
    [17539307] = { {   31,    7,   5 },  {   31,    3,   16 }                      }, -- W1 O.St. CW S.Well Base
    [17539259] = { {   31,    0,  24 },  {   31,    2,   18 }                      }, -- W1 O.St. CW S.Well#2
    [17539171] = { { -78,    0,    4 },  {  -70,    0,    9 }                      }, -- W1 Under Bridge NE
    [17539188] = { { -70,    0,    0 },  {  -78,    0,    0 }                      }, -- W1 Under Bridge E
    [17539179] = { { -78,    0,   -4 },  {  -70,    0,   -9 }                      }, -- W1 Under Bridge SE
    [17539175] = { { -94,    0,    9 },  {  -87,    0,    4 }                      }, -- W1 Under Bridge NW
    [17539191] = { { -94,    0,    0 },  {  -86,    0,    0 }                      }, -- W1 Under Bridge W
    [17539183] = { { -94,    0,   -9 },  {  -87,    0,   -4 }                      }, -- W1 Under Bridge SW
    [17539139] = { { -108,   -8, -60 },  { -108,   -0,  -35 }, { -108,   0,  -14 } }, -- W1 Depot Ramp Base
    [17539142] = { { -102,   -8, -60 },  {  -60,    0,  -60 }                      }, -- W1 Depot Ramp Top
    [17539125] = { { -128, -1.6,   4 },  { -128,    0,   -6 }                      }, -- W1 Zer N.Ramp (SW)
    [17539122] = { { -132,    0,  -6 },  { -132, -1.6,    4 }                      }, -- W1 Zer N.Ramp (NW)
    [17539439] = { {   36,    0,   8 },  {   21,    0,    8 }                      }, -- W1 O.St. CW Enc.#3
    [17539442] = { {   74,    0,   8 },  {   60,    0,    8 }                      }, -- W1 O.St. CW Enc.#4
}

xi.dynamis.timeExtension[zoneID] =
{
    [xi.bastok.mobs.ADAMANTKING_EFFIGY_001] = 20,
    [xi.bastok.mobs.ADAMANTKING_EFFIGY_019] = 20,
    [xi.bastok.mobs.ADAMANTKING_EFFIGY_041] = 20,
    [xi.bastok.mobs.GUDHA_EFFIGY]           = 30,
    [xi.bastok.mobs.GUNHI_NOONDOZER]        = 30,
    [xi.bastok.mobs.VANGUARD_CONSTABLE_89]  = 10,
    [xi.bastok.mobs.VANGUARD_VINDICATOR_89] = 10,
    [xi.bastok.mobs.VANGUARD_MILITANT_89]   = 10,
}
