-----------------------------------
--                            Dynamis-Xarcabard
--    Primary Source of Information: https://enedin.be/dyna/html/zone/xar.htm
-----------------------------------
local zoneID = xi.zone.DYNAMIS_XARCABARD
xi = xi or { }
xi.dynamis = xi.dynamis or { }

-- Main spawn table for all 150 statues
xi.dynamis.spawnTable = xi.dynamis.spawnTable or { }
xi.dynamis.spawnTable[zoneID] =
{
    -- ID = { # to spawn, eye color, force spawn mobs }
    -- MP = green HP = blue
    [17330212] = { 2, xi.dynamis.eye.RED      }, -- (001-D) | SAM, SAM
    [17330223] = { 2, xi.dynamis.eye.RED      }, -- (002-D) | SMN, SMN
    [17330218] = { 2, xi.dynamis.eye.RED      }, -- (003-D) | DRG, DRG
    [17330215] = { 2, xi.dynamis.eye.RED      }, -- (004-D) | NIN, NIN
    [17330228] = { 0, xi.dynamis.eye.RED      }, -- (005-G) |
    [17330263] = { 3, xi.dynamis.eye.RED      }, -- (006-D) | BST, BST, BST
    [17330257] = { 3, xi.dynamis.eye.RED      }, -- (007-D) | PLD, DRG, DRG
    [17330253] = { 3, xi.dynamis.eye.RED      }, -- (008-D) | DRK, DRK, PLD
    [17330249] = { 3, xi.dynamis.eye.RED      }, -- (009-D) | DRK, DRK, PLD
    [17330270] = { 0, xi.dynamis.eye.RED      }, -- (010-O(30)) |
    [17330505] = { 6, xi.dynamis.eye.RED      }, -- (011-D) | WAR, MNK, THF, RNG, BLM, WHM
    [17330512] = { 0, xi.dynamis.eye.RED      }, -- (012-Q) |
    [17330498] = { 6, xi.dynamis.eye.RED      }, -- (013-D) | WAR, MNK, THF, RNG, BLM, WHM
    [17330422] = { 2, xi.dynamis.eye.RED      }, -- (014-D) | PLD, RNG
    [17330419] = { 2, xi.dynamis.eye.RED      }, -- (015-D) | MNK, WHM
    [17330425] = { 2, xi.dynamis.eye.RED      }, -- (016-D) | PLD, RNG
    [17330276] = { 4, xi.dynamis.eye.RED      }, -- (017-D) | NIN, NIN, NIN, BRD
    [17330281] = { 4, xi.dynamis.eye.RED      }, -- (018-D) | WAR, WAR, WAR, BRD
    [17330271] = { 4, xi.dynamis.eye.RED      }, -- (019-D) | SAM, SAM, SAM, BRD
    [17330382] = { 3, xi.dynamis.eye.RED      }, -- (020-D) | SAM, SAM, RNG
    [17330375] = { 2, xi.dynamis.eye.RED      }, -- (021-D) | NIN, THF
    [17330378] = { 3, xi.dynamis.eye.RED      }, -- (022-D) | SAM, SAM, RNG
    [17330368] = { 3, xi.dynamis.eye.RED      }, -- (023-D) | NIN, THF, THF
    [17330372] = { 2, xi.dynamis.eye.RED      }, -- (024-D) | NIN, THF
    [17330364] = { 3, xi.dynamis.eye.RED      }, -- (025-D) | NIN, THF, THF
    [17330308] = { 2, xi.dynamis.eye.RED      }, -- (026-D) | DRG, DRG
    [17330303] = { 2, xi.dynamis.eye.RED      }, -- (027-D) | BST, BST
    [17330313] = { 2, xi.dynamis.eye.RED      }, -- (028-D) | SMN, SMN
    [17330177] = { 2, xi.dynamis.eye.RED      }, -- (029-D) | WAR, WAR
    [17330180] = { 2, xi.dynamis.eye.RED      }, -- (030-D) | MNK, MNK
    [17330183] = { 2, xi.dynamis.eye.RED      }, -- (031-D) | WHM, WHM
    [17330186] = { 2, xi.dynamis.eye.RED      }, -- (032-D) | BLM, BLM
    [17330189] = { 2, xi.dynamis.eye.RED      }, -- (033-D) | RNG, RNG
    [17330192] = { 2, xi.dynamis.eye.RED      }, -- (034-D) | THF, THF
    [17330554] = { 0, xi.dynamis.eye.RED      }, -- (035-D) |
    [17330557] = { 0, xi.dynamis.eye.RED      }, -- (036-D) |
    [17330556] = { 0, xi.dynamis.eye.RED      }, -- (037-D) |
    [17330555] = { 0, xi.dynamis.eye.RED      }, -- (038-D) |
    [17330550] = { 0, xi.dynamis.eye.RED      }, -- (039-D) |
    [17330553] = { 0, xi.dynamis.eye.RED      }, -- (040-D) |
    [17330552] = { 0, xi.dynamis.eye.RED      }, -- (041-D) |
    [17330551] = { 0, xi.dynamis.eye.RED      }, -- (042-D) |
    [17330558] = { 0, xi.dynamis.eye.RED      }, -- (043-Y(30)) |
    [17330361] = { 2, xi.dynamis.eye.RED      }, -- (044-D) | BLM, RNG
    [17330352] = { 2, xi.dynamis.eye.RED      }, -- (045-D) | BLM, RNG
    [17330358] = { 2, xi.dynamis.eye.RED      }, -- (046-D) | BLM, RNG
    [17330355] = { 2, xi.dynamis.eye.RED      }, -- (047-D) | BLM, RNG
    [17330436] = { 4, xi.dynamis.eye.RED      }, -- (048-D) | BST, BST, WHM, BRD
    [17330450] = { 3, xi.dynamis.eye.RED      }, -- (049-D) | MNK, NIN, SMN
    [17330443] = { 4, xi.dynamis.eye.RED      }, -- (050-D) | BST, BST, WHM, BRD
    [17330455] = { 3, xi.dynamis.eye.RED      }, -- (051-D) | MNK, NIN, SMN
    [17330460] = { 0, xi.dynamis.eye.BLUE     }, -- (052-Y(HP)) |
    [17330527] = { 4, xi.dynamis.eye.RED      }, -- (053-D) | SAM, DRG, NIN, SMN
    [17330513] = { 5, xi.dynamis.eye.RED      }, -- (054-D) | PLD, DRK, BST, RNG, BRD
    [17330534] = { 4, xi.dynamis.eye.RED      }, -- (055-D) | SAM, DRG, NIN, SMN
    [17330520] = { 5, xi.dynamis.eye.RED      }, -- (056-D) | PLD, DRK, BST, RNG, BRD
    [17330404] = { 3, xi.dynamis.eye.RED      }, -- (057-D) | SAM, DRG, RNG
    [17330395] = { 3, xi.dynamis.eye.RED      }, -- (058-D) | PLD, THF, SMN
    [17330400] = { 3, xi.dynamis.eye.RED      }, -- (059-D) | DRK, NIN, BLM
    [17330409] = { 0, xi.dynamis.eye.RED      }, -- (060-O(30)) |
    [17330229] = { 3, xi.dynamis.eye.RED      }, -- (061-D) | WAR, MNK, WHM
    [17330237] = { 3, xi.dynamis.eye.RED      }, -- (062-D) | THF, THF, BLM
    [17330245] = { 3, xi.dynamis.eye.RED      }, -- (063-D) | RNG, RNG, RNG
    [17330241] = { 3, xi.dynamis.eye.RED      }, -- (064-D) | THF, THF, BLM
    [17330233] = { 3, xi.dynamis.eye.RED      }, -- (065-D) | WAR, MNK, WHM
    [17330488] = { 4, xi.dynamis.eye.RED      }, -- (066-D) | DRK, DRK, DRK, BLM
    [17330493] = { 4, xi.dynamis.eye.RED      }, -- (067-D) | SAM, SAM, SAM, BLM
    [17330293] = { 2, xi.dynamis.eye.RED      }, -- (068-D) | BLM, WHM
    [17330299] = { 2, xi.dynamis.eye.RED      }, -- (069-D) | PLD, PLD
    [17330296] = { 2, xi.dynamis.eye.RED      }, -- (070-D) | PLD, PLD
    [17330286] = { 3, xi.dynamis.eye.RED      }, -- (071-D) | MNK, MNK, MNK
    [17330290] = { 2, xi.dynamis.eye.RED      }, -- (072-D) | BLM, WHM
    [17330302] = { 0, xi.dynamis.eye.GREEN    }, -- (073-Y(MP)) |
    [17330339] = { 2, xi.dynamis.eye.RED      }, -- (074-D) | DRG, DRG
    [17330334] = { 2, xi.dynamis.eye.RED      }, -- (075-D) | BST, BST
    [17330344] = { 3, xi.dynamis.eye.RED      }, -- (076-D) | SMN, SMN, SMN
    [17330351] = { 0, xi.dynamis.eye.GREEN    }, -- (077-O(MP)) |
    [17330201] = { 2, xi.dynamis.eye.RED      }, -- (078-D) | BST, BST
    [17330198] = { 2, xi.dynamis.eye.RED      }, -- (079-D) | DRK, DRK
    [17330209] = { 2, xi.dynamis.eye.RED      }, -- (080-D) | RNG, RNG
    [17330195] = { 2, xi.dynamis.eye.RED      }, -- (081-D) | PLD, PLD
    [17330206] = { 2, xi.dynamis.eye.RED      }, -- (082-D) | BRD, BRD
    [17330461] = { 3, xi.dynamis.eye.RED      }, -- (083-D) | WAR, WAR, RNG
    [17330469] = { 2, xi.dynamis.eye.RED      }, -- (084-D) | BLM, BLM
    [17330465] = { 3, xi.dynamis.eye.RED      }, -- (085-D) | WAR, WAR, RNG
    [17330541] = { 2, xi.dynamis.eye.RED      }, -- (086-D) | MNK, THF
    [17330544] = { 2, xi.dynamis.eye.RED      }, -- (087-D) | MNK, THF
    [17330547] = { 2, xi.dynamis.eye.RED      }, -- (088-D) | WHM, WHM
    [17330580] = { 3, xi.dynamis.eye.RED      }, -- (089-D) | WAR, WAR, BRD
    [17330588] = { 3, xi.dynamis.eye.RED      }, -- (090-D) | MNK, MNK, BRD
    [17330584] = { 3, xi.dynamis.eye.RED      }, -- (091-D) | WAR, WAR, BRD
    [17330592] = { 3, xi.dynamis.eye.RED      }, -- (092-D) | MNK, MNK, BRD
    [17330607] = { 2, xi.dynamis.eye.RED      }, -- (093-D) | RNG, RNG
    [17330603] = { 3, xi.dynamis.eye.RED      }, -- (094-D) | SAM, SAM, SAM
    [17330600] = { 2, xi.dynamis.eye.RED      }, -- (095-D) | RNG, RNG
    [17330596] = { 3, xi.dynamis.eye.RED      }, -- (096-D) | THF, THF, THF
    [17330386] = { 3, xi.dynamis.eye.RED      }, -- (097-D) | WAR, RNG, BRD
    [17330390] = { 3, xi.dynamis.eye.RED      }, -- (098-D) | MNK, BST, WHM
    [17330413] = { 2, xi.dynamis.eye.RED      }, -- (099-D) | MNK, BRD
    [17330410] = { 2, xi.dynamis.eye.RED      }, -- (100-D) | WAR, BRD
    [17330416] = { 2, xi.dynamis.eye.RED      }, -- (101-D) | WAR, WHM
    [17330326] = { 3, xi.dynamis.eye.RED      }, -- (102-D) | RNG, WHM, BRD
    [17330330] = { 3, xi.dynamis.eye.RED      }, -- (103-D) | RNG, WHM, BRD
    [17330318] = { 3, xi.dynamis.eye.RED      }, -- (104-D) | DRK, DRK, BRD
    [17330322] = { 3, xi.dynamis.eye.RED      }, -- (105-D) | DRK, DRK, BRD
    [17330639] = { 2, xi.dynamis.eye.RED      }, -- (106-D) | PLD, PLD
    [17330631] = { 3, xi.dynamis.eye.RED      }, -- (107-D) | NIN, NIN, RNG
    [17330635] = { 3, xi.dynamis.eye.RED      }, -- (108-D) | NIN, NIN, RNG
    [17330642] = { 3, xi.dynamis.eye.RED      }, -- (109-D) | DRG, DRG, DRG
    [17330659] = { 2, xi.dynamis.eye.RED      }, -- (110-D) | SMN, SMN
    [17330649] = { 2, xi.dynamis.eye.RED      }, -- (111-D) | BST, BST
    [17330671] = { 0, xi.dynamis.eye.BLUE     }, -- (112-Q(HP)) |
    [17330654] = { 2, xi.dynamis.eye.RED      }, -- (113-D) | BST, BST
    [17330664] = { 3, xi.dynamis.eye.RED      }, -- (114-D) | SMN, SMN, SMN
    [17330428] = { 2, xi.dynamis.eye.RED      }, -- (115-D) | DRG, RNG
    [17330432] = { 2, xi.dynamis.eye.RED      }, -- (116-D) | DRG, RNG
    [17330472] = { 2, xi.dynamis.eye.RED      }, -- (117-D) | PLD, SMN
    [17330476] = { 2, xi.dynamis.eye.RED      }, -- (118-D) | PLD, SMN
    [17330484] = { 3, xi.dynamis.eye.RED      }, -- (119-D) | RNG, RNG, RNG
    [17330480] = { 2, xi.dynamis.eye.RED      }, -- (120-D) | PLD, SMN
    [17330572] = { 1, xi.dynamis.eye.RED      }, -- (121-D) | RNG
    [17330574] = { 2, xi.dynamis.eye.RED      }, -- (122-D) | NIN, NIN
    [17330577] = { 1, xi.dynamis.eye.RED      }, -- (123-D) | RNG
    [17330563] = { 3, xi.dynamis.eye.RED      }, -- (124-D) | DRG, DRG, RNG
    [17330559] = { 3, xi.dynamis.eye.RED      }, -- (125-D) | SAM, SAM, RNG
    [17330569] = { 2, xi.dynamis.eye.RED      }, -- (126-D) | DRK, DRK
    [17330676] = { 1, xi.dynamis.eye.RED, 1   }, -- (127-D) |
    [17330672] = { 1, xi.dynamis.eye.RED, 1   }, -- (128-D) |
    [17330674] = { 1, xi.dynamis.eye.RED, 1   }, -- (129-D) |
    [17330683] = { 1, xi.dynamis.eye.RED, 1   }, -- (130-D) |
    [17330678] = { 1, xi.dynamis.eye.RED, 1   }, -- (131-D) |
    [17330680] = { 1, xi.dynamis.eye.RED, 1   }, -- (132-D) |
    [17330694] = { 1, xi.dynamis.eye.RED, 1   }, -- (133-D) |
    [17330692] = { 1, xi.dynamis.eye.RED, 1   }, -- (134-D) |
    [17330696] = { 1, xi.dynamis.eye.RED, 1   }, -- (135-D) |
    [17330687] = { 1, xi.dynamis.eye.RED, 1   }, -- (136-D) |
    [17330685] = { 1, xi.dynamis.eye.RED, 1   }, -- (137-D) |
    [17330689] = { 1, xi.dynamis.eye.RED, 1   }, -- (138-D) |
    [17330700] = { 1, xi.dynamis.eye.RED, 1   }, -- (139-D) |
    [17330698] = { 1, xi.dynamis.eye.RED, 1   }, -- (140-D) |
    [17330703] = { 1, xi.dynamis.eye.RED, 1   }, -- (141-D) |
    [17330579] = { 0, xi.dynamis.eye.BLUE     }, -- (142-Q(HP)) |
    [17330705] = { 0, xi.dynamis.eye.RED      }, -- (143-G(30)) |
    [17330615] = { 2, xi.dynamis.eye.RED      }, -- (144-D) | BLM, WHM
    [17330621] = { 2, xi.dynamis.eye.RED      }, -- (145-D) | BLM, WHM
    [17330627] = { 2, xi.dynamis.eye.RED      }, -- (146-D) | BLM, WHM
    [17330610] = { 2, xi.dynamis.eye.RED      }, -- (147-D) | DRG, DRG
    [17330618] = { 2, xi.dynamis.eye.RED      }, -- (148-D) | DRK, DRK
    [17330624] = { 2, xi.dynamis.eye.RED      }, -- (149-D) | PLD, PLD
    [17330630] = { 0, xi.dynamis.eye.RED      }, -- (150-G(30)) |
    [17330777] = { 5, xi.dynamis.eye.RED      }, -- (151-Animated Hammer) |
    [17330714] = { 5, xi.dynamis.eye.RED      }, -- (152-Animated Dagger) |
    [17330812] = { 5, xi.dynamis.eye.RED      }, -- (153-Animated Shield) |
    [17330728] = { 5, xi.dynamis.eye.RED      }, -- (154-Animated Claymore) |
    [17330798] = { 5, xi.dynamis.eye.RED      }, -- (155-Animated Gun) |
    [17330791] = { 5, xi.dynamis.eye.RED      }, -- (156-Animated Longbow) |
    [17330770] = { 5, xi.dynamis.eye.RED      }, -- (157-Animated Tachi) |
    [17330735] = { 5, xi.dynamis.eye.RED      }, -- (158-Animated Tabar) |
    [17330784] = { 5, xi.dynamis.eye.RED      }, -- (159-Animated Staff) |
    [17330749] = { 5, xi.dynamis.eye.RED      }, -- (160-Animated Spear) |
    [17330763] = { 5, xi.dynamis.eye.RED      }, -- (161-Animated Kunai) |
    [17330707] = { 5, xi.dynamis.eye.RED      }, -- (162-Animated Knuckles) |
    [17330742] = { 5, xi.dynamis.eye.RED      }, -- (163-Animated Great Axe) |
    [17330805] = { 5, xi.dynamis.eye.RED      }, -- (164-Animated Horn) |
    [17330721] = { 5, xi.dynamis.eye.RED      }, -- (165-Animated Longsword) |
    [17330756] = { 5, xi.dynamis.eye.RED      }, -- (166-Animated Scythe) |
    [17330818] = { 0, xi.dynamis.eye.RED      }, -- (167-Vanguard Dragon) |
    [17330819] = { 0, xi.dynamis.eye.RED      }, -- (168-Vanguard Dragon) |
    [17330820] = { 0, xi.dynamis.eye.RED      }, -- (169-Vanguard Dragon) |
    [17330821] = { 0, xi.dynamis.eye.RED      }, -- (170-Vanguard Dragon) |
    [17330822] = { 0, xi.dynamis.eye.RED      }, -- (171-Vanguard Dragon) |
    [17330823] = { 0, xi.dynamis.eye.RED      }, -- (172-Vanguard Dragon) |
    [17330824] = { 0, xi.dynamis.eye.RED      }, -- (173-Vanguard Dragon) |
    [17330825] = { 0, xi.dynamis.eye.RED      }, -- (174-Vanguard Dragon) |
    [17330826] = { 0, xi.dynamis.eye.RED      }, -- (175-Vanguard Dragon) |
    [17330827] = { 0, xi.dynamis.eye.RED      }, -- (176-Vanguard Dragon) |
    [17330829] = { 0, xi.dynamis.eye.RED      }, -- (177-Shadow Dragon NM (Yang)) |
    [17330828] = { 0, xi.dynamis.eye.RED      }, -- (178-Shadow Dragon NM (Ying)) |
    [17330830] = { 0, xi.dynamis.eye.RED      }, -- (179-Dynamis Lord) |
}

-- Wave spawn table for large waves
xi.dynamis.wave = xi.dynamis.wave or { }
xi.dynamis.wave[zoneID] =
{
    [1] = -- Spawns at start of the instance
    {
        17330212, -- (001-D)  Vanguard Eye
        17330223, -- (002-D)  Vanguard Eye
        17330218, -- (003-D)  Vanguard Eye
        17330215, -- (004-D)  Vanguard Eye
        17330228, -- (005-G)  Statue Prototype
        17330263, -- (006-D)  Vanguard Eye
        17330257, -- (007-D)  Vanguard Eye
        17330253, -- (008-D)  Vanguard Eye
        17330249, -- (009-D)  Vanguard Eye
        17330270, -- (010-O)  Tombstone Prototype
        17330505, -- (011-D)  Vanguard Eye
        17330512, -- (012-Q)  Effigy Prototype
        17330498, -- (013-D)  Vanguard Eye
        17330422, -- (014-D)  Vanguard Eye
        17330419, -- (015-D)  Vanguard Eye
        17330425, -- (016-D)  Vanguard Eye
        17330276, -- (017-D)  Vanguard Eye
        17330281, -- (018-D)  Vanguard Eye
        17330271, -- (019-D)  Vanguard Eye
        17330382, -- (020-D)  Vanguard Eye
        17330375, -- (021-D)  Vanguard Eye
        17330378, -- (022-D)  Vanguard Eye
        17330368, -- (023-D)  Vanguard Eye
        17330372, -- (024-D)  Vanguard Eye
        17330364, -- (025-D)  Vanguard Eye
        17330308, -- (026-D)  Vanguard Eye
        17330303, -- (027-D)  Vanguard Eye
        17330313, -- (028-D)  Vanguard Eye
        17330177, -- (029-D)  Vanguard Eye
        17330180, -- (030-D)  Vanguard Eye
        17330183, -- (031-D)  Vanguard Eye
        17330186, -- (032-D)  Vanguard Eye
        17330189, -- (033-D)  Vanguard Eye
        17330192, -- (034-D)  Vanguard Eye
        17330554, -- (035-D)  Vanguard Eye
        17330550, -- (039-D)  Vanguard Eye
        17330361, -- (044-D)  Vanguard Eye
        17330352, -- (045-D)  Vanguard Eye
        17330358, -- (046-D)  Vanguard Eye
        17330355, -- (047-D)  Vanguard Eye
        17330436, -- (048-D)  Vanguard Eye
        17330450, -- (049-D)  Vanguard Eye
        17330443, -- (050-D)  Vanguard Eye
        17330455, -- (051-D)  Vanguard Eye
        17330460, -- (052-Y)  Icon Prototype
        17330527, -- (053-D)  Vanguard Eye
        17330513, -- (054-D)  Vanguard Eye
        17330534, -- (055-D)  Vanguard Eye
        17330520, -- (056-D)  Vanguard Eye
        17330404, -- (057-D)  Vanguard Eye
        17330395, -- (058-D)  Vanguard Eye
        17330400, -- (059-D)  Vanguard Eye
        17330229, -- (061-D)  Vanguard Eye
        17330237, -- (062-D)  Vanguard Eye
        17330245, -- (063-D)  Vanguard Eye
        17330241, -- (064-D)  Vanguard Eye
        17330233, -- (065-D)  Vanguard Eye
        17330488, -- (066-D)  Vanguard Eye
        17330493, -- (067-D)  Vanguard Eye
        17330293, -- (068-D)  Vanguard Eye
        17330299, -- (069-D)  Vanguard Eye
        17330296, -- (070-D)  Vanguard Eye
        17330286, -- (071-D)  Vanguard Eye
        17330290, -- (072-D)  Vanguard Eye
        17330302, -- (073-Y)  Icon Prototype
        17330339, -- (074-D)  Vanguard Eye
        17330334, -- (075-D)  Vanguard Eye
        17330344, -- (076-D)  Vanguard Eye
        17330351, -- (077-O)  Tombstone Prototype
        17330201, -- (078-D)  Vanguard Eye
        17330198, -- (079-D)  Vanguard Eye
        17330209, -- (080-D)  Vanguard Eye
        17330195, -- (081-D)  Vanguard Eye
        17330206, -- (082-D)  Vanguard Eye
        17330461, -- (083-D)  Vanguard Eye
        17330469, -- (084-D)  Vanguard Eye
        17330465, -- (085-D)  Vanguard Eye
        17330541, -- (086-D)  Vanguard Eye
        17330544, -- (087-D)  Vanguard Eye
        17330547, -- (088-D)  Vanguard Eye
        17330580, -- (089-D)  Vanguard Eye
        17330588, -- (090-D)  Vanguard Eye
        17330584, -- (091-D)  Vanguard Eye
        17330592, -- (092-D)  Vanguard Eye
        17330607, -- (093-D)  Vanguard Eye
        17330603, -- (094-D)  Vanguard Eye
        17330600, -- (095-D)  Vanguard Eye
        17330596, -- (096-D)  Vanguard Eye
        17330386, -- (097-D)  Vanguard Eye
        17330390, -- (098-D)  Vanguard Eye
        17330413, -- (099-D)  Vanguard Eye
        17330410, -- (100-D)  Vanguard Eye
        17330416, -- (101-D)  Vanguard Eye
        17330326, -- (102-D)  Vanguard Eye
        17330330, -- (103-D)  Vanguard Eye
        17330318, -- (104-D)  Vanguard Eye
        17330322, -- (105-D)  Vanguard Eye
        17330639, -- (106-D)  Vanguard Eye
        17330631, -- (107-D)  Vanguard Eye
        17330635, -- (108-D)  Vanguard Eye
        17330642, -- (109-D)  Vanguard Eye
        17330659, -- (110-D)  Vanguard Eye
        17330649, -- (111-D)  Vanguard Eye
        17330671, -- (112-Q)  Effigy Prototype
        17330654, -- (113-D)  Vanguard Eye
        17330664, -- (114-D)  Vanguard Eye
        17330428, -- (115-D)  Vanguard Eye
        17330432, -- (116-D)  Vanguard Eye
        17330472, -- (117-D)  Vanguard Eye
        17330476, -- (118-D)  Vanguard Eye
        17330484, -- (119-D)  Vanguard Eye
        17330480, -- (120-D)  Vanguard Eye
        17330572, -- (121-D)  Vanguard Eye
        17330574, -- (122-D)  Vanguard Eye
        17330577, -- (123-D)  Vanguard Eye
        17330563, -- (124-D)  Vanguard Eye
        17330559, -- (125-D)  Vanguard Eye
        17330569, -- (126-D)  Vanguard Eye
        17330676, -- (127-D)  Vanguard Eye
        17330672, -- (128-D)  Vanguard Eye
        17330674, -- (129-D)  Vanguard Eye
        17330683, -- (130-D)  Vanguard Eye
        17330678, -- (131-D)  Vanguard Eye
        17330680, -- (132-D)  Vanguard Eye
        17330694, -- (133-D)  Vanguard Eye
        17330692, -- (134-D)  Vanguard Eye
        17330696, -- (135-D)  Vanguard Eye
        17330687, -- (136-D)  Vanguard Eye
        17330685, -- (137-D)  Vanguard Eye
        17330689, -- (138-D)  Vanguard Eye
        17330700, -- (139-D)  Vanguard Eye
        17330698, -- (140-D)  Vanguard Eye
        17330703, -- (141-D)  Vanguard Eye
    },
    [2] = -- Demon NMs spawn Animated Weapons, Vanguard Dragons, Ying, Yang
    {
        17330579, -- (142-Q) Effigy Prototype
        17330705, -- (143-G) Statue Prototype
        17330615, -- (144-D) Vanguard Eye
        17330621, -- (145-D) Vanguard Eye
        17330627, -- (146-D) Vanguard Eye
        17330610, -- (147-D) Vanguard Eye
        17330618, -- (148-D) Vanguard Eye
        17330624, -- (149-D) Vanguard Eye
        17330777, -- Animated Hammer
        17330714, -- Animated Dagger
        17330812, -- Animated Shield
        17330728, -- Animated Claymore
        17330798, -- Animated Gun
        17330791, -- Animated Longbow
        17330770, -- Animated Tachi
        17330735, -- Animated Tabar
        17330784, -- Animated Staff
        17330749, -- Animated Spear
        17330763, -- Animated Kunai
        17330707, -- Animated Knuckles
        17330742, -- Animated Great Axe
        17330805, -- Animated Horn
        17330721, -- Animated Longsword
        17330756, -- Animated Scythe
        17330818, -- Vanguard Dragon
        17330819, -- Vanguard Dragon
        17330820, -- Vanguard Dragon
        17330821, -- Vanguard Dragon
        17330822, -- Vanguard Dragon
        17330823, -- Vanguard Dragon
        17330824, -- Vanguard Dragon
        17330825, -- Vanguard Dragon
        17330826, -- Vanguard Dragon
        17330827, -- Vanguard Dragon
        17330829, -- Shadow Dragon NM (Yang)
        17330828, -- Shadow Dragon NM (Ying)
    },
}

xi.xarc = xi.xarc or { }
xi.xarc.mobs =
{
    -- Statues
    VANGUARD_EYE_35     = 17330554,
    VANGUARD_EYE_39     = 17330550,
    VANGUARD_EYE_58     = 17330395,
    VANGUARD_EYE_144    = 17330615,
    VANGUARD_EYE_145    = 17330621,
    VANGUARD_EYE_146    = 17330627,
    VANGUARD_EYE_147    = 17330610,
    VANGUARD_EYE_148    = 17330618,
    VANGUARD_EYE_149    = 17330624,

    -- TEs
    VANGUARD_EYE_10     = 17330270,
    VANGUARD_EYE_43     = 17330558,
    VANGUARD_EYE_60     = 17330409,
    VANGUARD_EYE_143    = 17330705,
    VANGUARD_EYE_150    = 17330630,

    -- NMs
    MARQUIS_DECARABIA   = 17330677,
    COUNT_ZAEBOS        = 17330673,
    DUKE_BERITH         = 17330675,
    PRINCE_SEERE        = 17330684,
    DUKE_GOMORY         = 17330679,
    MARQUIS_ANDRAS      = 17330681,
    MARQUIS_GAMYGYN     = 17330695,
    DUKE_SCOX           = 17330693,
    MARQUIS_ORIAS       = 17330697,
    COUNT_RUAM          = 17330688,
    MARQUIS_SABNAK      = 17330686,
    MARQUIS_NEBIROS     = 17330690,
    KING_ZAGAN          = 17330701,
    COUNT_VINE          = 17330699,
    MARQUIS_CIMERIES    = 17330704,
    YING                = 17330828,
    YANG                = 17330829,
    DYNAMIS_LORD        = 17330830,
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.xarc.mobs.VANGUARD_EYE_35]      = '[DYNA]35Killed',
    [xi.xarc.mobs.VANGUARD_EYE_39]      = '[DYNA]39Killed',
    [xi.xarc.mobs.VANGUARD_EYE_58]      = '[DYNA]58Killed',
    [xi.xarc.mobs.VANGUARD_EYE_144]     = '[DYNA]144Killed',
    [xi.xarc.mobs.VANGUARD_EYE_145]     = '[DYNA]145Killed',
    [xi.xarc.mobs.VANGUARD_EYE_146]     = '[DYNA]146Killed',
    [xi.xarc.mobs.VANGUARD_EYE_147]     = '[DYNA]147Killed',
    [xi.xarc.mobs.VANGUARD_EYE_148]     = '[DYNA]148Killed',
    [xi.xarc.mobs.VANGUARD_EYE_149]     = '[DYNA]149Killed',
    [xi.xarc.mobs.MARQUIS_DECARABIA]    = '[DYNA]Marquis',
    [xi.xarc.mobs.COUNT_ZAEBOS]         = '[DYNA]Zaebos',
    [xi.xarc.mobs.DUKE_BERITH]          = '[DYNA]Berith',
    [xi.xarc.mobs.PRINCE_SEERE]         = '[DYNA]Seere',
    [xi.xarc.mobs.DUKE_GOMORY]          = '[DYNA]Gomory',
    [xi.xarc.mobs.MARQUIS_ANDRAS]       = '[DYNA]Andras',
    [xi.xarc.mobs.MARQUIS_GAMYGYN]      = '[DYNA]Gamygyn',
    [xi.xarc.mobs.DUKE_SCOX]            = '[DYNA]Scox',
    [xi.xarc.mobs.MARQUIS_ORIAS]        = '[DYNA]Orias',
    [xi.xarc.mobs.COUNT_RUAM]           = '[DYNA]Ruam',
    [xi.xarc.mobs.MARQUIS_SABNAK]       = '[DYNA]Sabnak',
    [xi.xarc.mobs.MARQUIS_NEBIROS]      = '[DYNA]Nebiros',
    [xi.xarc.mobs.KING_ZAGAN]           = '[DYNA]Zagan',
    [xi.xarc.mobs.COUNT_VINE]           = '[DYNA]Vine',
    [xi.xarc.mobs.MARQUIS_CIMERIES]     = '[DYNA]Cimeries',
    [xi.xarc.mobs.YING]                 = '[DYNA]Ying',
    [xi.xarc.mobs.YANG]                 = '[DYNA]Yang',
    [xi.xarc.mobs.DYNAMIS_LORD]         = '[DYNA]DynamisLord',
}

xi.dynamis.spawnCheck = xi.dynamis.spawnCheck or {}
xi.dynamis.spawnCheck[zoneID] =
{
    {
        -- 35 and 39 spawn 43
        requiredVars    = { '[DYNA]35Killed', '[DYNA]39Killed' },
        spawn           = { xi.xarc.mobs.VANGUARD_EYE_43 },
        spawnedVar      = '[DYNA]43Spawned',
    },
    {
        -- 58 spawns 60
        requiredVars    = { '[DYNA]58Killed' },
        spawn           = { xi.xarc.mobs.VANGUARD_EYE_60 },
        spawnedVar      = '[DYNA]60Spawned',
    },
    {
        -- 144 to 149 spawns 150
        requiredVars    = { '[DYNA]144Killed', '[DYNA]145Killed', '[DYNA]146Killed', '[DYNA]147Killed', '[DYNA]148Killed', '[DYNA]149Killed' },
        spawn           = { xi.xarc.mobs.VANGUARD_EYE_150 },
        spawnedVar      = '[DYNA]150Spawned',
    },
    {
        -- ying and yang spawn dynamis lord
        -- TODO: make spawn if they die at the same time
        requiredVars    = { '[DYNA]Ying', '[DYNA]Yang' },
        spawn           = { xi.xarc.mobs.DYNAMIS_LORD },
        spawnedVar      = '[DYNA]DynamisLordSpawned',
    },
    {
        -- Killing all generals spawns a lot of shit
        requiredVars    = { '[DYNA]Marquis', '[DYNA]Zaebos', '[DYNA]Berith', '[DYNA]Seere', '[DYNA]Gomory', '[DYNA]Andras', '[DYNA]Gamygyn', '[DYNA]Scox', '[DYNA]Orias', '[DYNA]Ruam', '[DYNA]Sabnak', '[DYNA]Nebiros', '[DYNA]Zagan', '[DYNA]Vine', '[DYNA]Cimeries' },
        spawn           = xi.dynamis.wave[zoneID][2],
        spawnedVar      = '[DYNA]Wave2Spawned',
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
        [17330554] = { 17330555, 17330556, 17330557 }, -- 35 spawns 36, 37, 38
        [17330550] = { 17330551, 17330552, 17330553 }, -- 39 spawns 40, 41, 42
    },
}

-- Pathing table
-- TODO: figure out what paths because apparently some do

xi.dynamis.timeExtension = xi.dynamis.timeExtension or { }
xi.dynamis.timeExtension[zoneID] =
{
    [xi.xarc.mobs.VANGUARD_EYE_10]  = 30, -- Tombstone Prototype
    [xi.xarc.mobs.VANGUARD_EYE_43]  = 30, -- Icon Prototype
    [xi.xarc.mobs.VANGUARD_EYE_60]  = 30, -- Tombstone Prototype
    [xi.xarc.mobs.VANGUARD_EYE_143] = 30, -- Statue Prototype
    [xi.xarc.mobs.VANGUARD_EYE_150] = 30, -- Statue Prototype
}
