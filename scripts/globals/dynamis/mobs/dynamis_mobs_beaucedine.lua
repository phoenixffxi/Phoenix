-----------------------------------
--                            Dynamis-Beaucedine
--    Primary Source of Information: https://enedin.be/dyna/html/zone/bea.htm
-----------------------------------
local zoneID = xi.zone.DYNAMIS_BEAUCEDINE
xi = xi or { }
xi.dynamis = xi.dynamis or { }

-- Main spawn table for all 150 statues
xi.dynamis.spawnTable = xi.dynamis.spawnTable or { }
xi.dynamis.spawnTable[zoneID] =
{
    -- ID = { # to spawn, eye color, force spawn mobs }
    -- MP = green HP = blue
    [17326084] = { 2, xi.dynamis.eye.RED      }, -- (001-Q) | WHM
    [17326087] = { 2, xi.dynamis.eye.RED      }, -- (002-O) | WAR, BLM
    [17326081] = { 2, xi.dynamis.eye.RED      }, -- (003-Y) | THF, RNG
    [17326090] = { 2, xi.dynamis.eye.RED      }, -- (004-G) | DRK, BRD
    [17326101] = { 2, xi.dynamis.eye.BLUE     }, -- (005-Y(HP)) | NIN, RDM
    [17326097] = { 2, xi.dynamis.eye.RED      }, -- (006-Q) | BST, PLD
    [17326093] = { 2, xi.dynamis.eye.RED      }, -- (007-O) | MNK, DRG
    [17326104] = { 2, xi.dynamis.eye.GREEN    }, -- (008-G(MP)) | SMN, THF
    [17326112] = { 1, xi.dynamis.eye.RED      }, -- (009-Y) | PLD
    [17326108] = { 3, xi.dynamis.eye.RED      }, -- (010-Y(15)) | WHM, RDM
    [17326114] = { 1, xi.dynamis.eye.RED      }, -- (011-Y) | DRK
    [17326120] = { 2, xi.dynamis.eye.GREEN    }, -- (012-Y(MP)) | SAM, SMN
    [17326116] = { 2, xi.dynamis.eye.BLUE     }, -- (013-Y(HP)) | WAR, BST
    [17326133] = { 2, xi.dynamis.eye.RED      }, -- (014-Y) | BLM
    [17326124] = { 2, xi.dynamis.eye.RED      }, -- (015-Y) | MNK
    [17326137] = { 1, xi.dynamis.eye.RED      }, -- (016-Y) | PLD
    [17326130] = { 2, xi.dynamis.eye.RED      }, -- (017-Y) | DRK
    [17326128] = { 1, xi.dynamis.eye.BLUE     }, -- (018-Y(HP)) | RDM
    [17326139] = { 2, xi.dynamis.eye.GREEN    }, -- (019-Y(MP)) | WAR
    [17326142] = { 2, xi.dynamis.eye.RED      }, -- (020-Y(15)) | NIN
    [17326146] = { 3, xi.dynamis.eye.RED      }, -- (021-Y) | SAM, THF
    [17326153] = { 2, xi.dynamis.eye.GREEN    }, -- (022-Y(MP)) | RNG, NIN
    [17326150] = { 2, xi.dynamis.eye.BLUE     }, -- (023-Y(HP)) | BLM, RDM
    [17326177] = { 4, xi.dynamis.eye.RED      }, -- (024-Replica NM (Dynamis Icon)) |
    [17326174] = { 2, xi.dynamis.eye.GREEN    }, -- (025-Y(MP)) | THF, SAM
    [17326167] = { 2, xi.dynamis.eye.RED      }, -- (026-Y) | WAR
    [17326160] = { 2, xi.dynamis.eye.GREEN    }, -- (027-Y(MP)) | SMN, RDM
    [17326156] = { 2, xi.dynamis.eye.BLUE     }, -- (028-Y(HP)) | WHM, BST
    [17326164] = { 2, xi.dynamis.eye.RED      }, -- (029-Y) | PLD
    [17326170] = { 2, xi.dynamis.eye.BLUE     }, -- (030-Y(HP)) | DRG, MNK
    [17326182] = { 2, xi.dynamis.eye.RED      }, -- (031-G(15)) | BST
    [17326189] = { 2, xi.dynamis.eye.RED      }, -- (032-G) | RDM, SAM
    [17326186] = { 2, xi.dynamis.eye.RED      }, -- (033-G) | WHM, RNG
    [17326192] = { 2, xi.dynamis.eye.RED      }, -- (034-G) | NIN
    [17326195] = { 2, xi.dynamis.eye.RED      }, -- (035-G) | WAR
    [17326198] = { 1, xi.dynamis.eye.RED      }, -- (036-G) | DRK
    [17326200] = { 2, xi.dynamis.eye.BLUE     }, -- (037-G(HP)) | PLD, SAM
    [17326203] = { 2, xi.dynamis.eye.GREEN    }, -- (038-G(MP)) | DRG, WHM
    [17326231] = { 2, xi.dynamis.eye.RED      }, -- (039-G) | WAR, WHM
    [17326237] = { 2, xi.dynamis.eye.GREEN    }, -- (040-G(MP)) | BLM
    [17326234] = { 2, xi.dynamis.eye.BLUE     }, -- (041-G(HP)) | PLD
    [17326244] = { 2, xi.dynamis.eye.RED      }, -- (042-G) | RNG
    [17326241] = { 2, xi.dynamis.eye.RED      }, -- (043-G) | BRD, MNK
    [17326247] = { 2, xi.dynamis.eye.BLUE     }, -- (044-G(HP)) | SMN, DRG
    [17326252] = { 2, xi.dynamis.eye.GREEN    }, -- (045-G(MP)) | BST, PLD
    [17326256] = { 2, xi.dynamis.eye.RED      }, -- (046-G(15)) | THF
    [17326225] = { 4, xi.dynamis.eye.RED      }, -- (047-Replica NM (Dynamis Statue)) |
    [17326207] = { 1, xi.dynamis.eye.RED      }, -- (048-G) | BLM
    [17326214] = { 2, xi.dynamis.eye.GREEN    }, -- (049-G(MP)) | NIN, DRK
    [17326209] = { 1, xi.dynamis.eye.RED      }, -- (050-G) | THF
    [17326211] = { 2, xi.dynamis.eye.BLUE     }, -- (051-G(HP)) | MNK, RDM
    [17326217] = { 2, xi.dynamis.eye.GREEN    }, -- (052-G(MP)) | SAM
    [17326221] = { 2, xi.dynamis.eye.BLUE     }, -- (053-G(HP)) | DRG
    [17326265] = { 2, xi.dynamis.eye.RED      }, -- (054-Q) | RNG
    [17326262] = { 2, xi.dynamis.eye.RED      }, -- (055-Q) | NIN
    [17326259] = { 2, xi.dynamis.eye.BLUE     }, -- (056-Q(HP)) | WAR, RDM
    [17326268] = { 2, xi.dynamis.eye.GREEN    }, -- (057-Q(MP)) | BRD, DRG
    [17326300] = { 2, xi.dynamis.eye.RED      }, -- (058-Q) | BLM
    [17326303] = { 1, xi.dynamis.eye.BLUE     }, -- (059-Q(HP)) | DRK
    [17326305] = { 2, xi.dynamis.eye.RED      }, -- (060-Q) | BST
    [17326309] = { 1, xi.dynamis.eye.GREEN    }, -- (061-Q(MP)) | WAR
    [17326311] = { 2, xi.dynamis.eye.RED      }, -- (062-Q) |
    [17326314] = { 3, xi.dynamis.eye.RED      }, -- (063-Q(15)) | THF, RNG
    [17326323] = { 2, xi.dynamis.eye.RED      }, -- (064-Q) | WHM, BLM
    [17326319] = { 2, xi.dynamis.eye.BLUE     }, -- (065-Q(HP)) | SMN, MNK
    [17326331] = { 2, xi.dynamis.eye.RED      }, -- (066-Q(15)) | WAR
    [17326326] = { 2, xi.dynamis.eye.GREEN    }, -- (067-Q(MP)) | DRG, BST
    [17326272] = { 4, xi.dynamis.eye.RED      }, -- (068-Replica NM (Dynamis Effigy)) |
    [17326298] = { 1, xi.dynamis.eye.RED      }, -- (069-Q) | MNK
    [17326295] = { 2, xi.dynamis.eye.BLUE     }, -- (070-Q(HP)) | THF, DRK
    [17326293] = { 1, xi.dynamis.eye.RED      }, -- (071-Q) | PLD
    [17326289] = { 2, xi.dynamis.eye.GREEN    }, -- (072-Q(MP)) | NIN
    [17326287] = { 1, xi.dynamis.eye.RED      }, -- (073-Q) | RNG
    [17326284] = { 2, xi.dynamis.eye.BLUE     }, -- (074-Q(HP)) | RDM, BRD
    [17326282] = { 1, xi.dynamis.eye.RED      }, -- (075-Q) | WAR
    [17326278] = { 2, xi.dynamis.eye.GREEN    }, -- (076-Q(MP)) | SMN
    [17326362] = { 2, xi.dynamis.eye.RED      }, -- (077-O) | WHM, RNG
    [17326365] = { 2, xi.dynamis.eye.BLUE     }, -- (078-O(HP)) | NIN, SAM
    [17326368] = { 2, xi.dynamis.eye.RED      }, -- (079-O) | BST
    [17326373] = { 2, xi.dynamis.eye.GREEN    }, -- (080-O(MP)) | BRD, PLD
    [17326376] = { 2, xi.dynamis.eye.RED      }, -- (081-O) | WAR, RDM
    [17326385] = { 2, xi.dynamis.eye.GREEN    }, -- (082-O(MP)) | DRG
    [17326382] = { 2, xi.dynamis.eye.RED      }, -- (083-O(15)) | MNK
    [17326379] = { 2, xi.dynamis.eye.BLUE     }, -- (084-O(HP)) | RNG
    [17326389] = { 2, xi.dynamis.eye.RED      }, -- (085-O) | WHM, RDM
    [17326392] = { 2, xi.dynamis.eye.BLUE     }, -- (086-O(HP)) | SMN
    [17326396] = { 2, xi.dynamis.eye.RED      }, -- (087-O(15)) | BST
    [17326400] = { 2, xi.dynamis.eye.GREEN    }, -- (088-O(MP)) | NIN
    [17326403] = { 2, xi.dynamis.eye.RED      }, -- (089-O) | SAM, DRK
    [17326334] = { 4, xi.dynamis.eye.RED      }, -- (090-Replica NM (Dynamis Tombstone)) |
    [17326340] = { 2, xi.dynamis.eye.BLUE     }, -- (091-O(HP)) | THF
    [17326344] = { 1, xi.dynamis.eye.RED      }, -- (092-O) | RNG
    [17326346] = { 1, xi.dynamis.eye.RED      }, -- (093-O) | BLM
    [17326348] = { 2, xi.dynamis.eye.GREEN    }, -- (094-O(MP)) | PLD, BRD
    [17326358] = { 2, xi.dynamis.eye.BLUE     }, -- (095-O(HP)) | SMN, THF
    [17326356] = { 1, xi.dynamis.eye.RED      }, -- (096-O) | NIN
    [17326354] = { 1, xi.dynamis.eye.RED      }, -- (097-O) | DRK
    [17326351] = { 2, xi.dynamis.eye.GREEN    }, -- (098-O(MP)) | MNK
    [17326406] = { 1, xi.dynamis.eye.RED      }, -- (099-O) | BLM
    [17326408] = { 1, xi.dynamis.eye.RED      }, -- (100-Q) | SMN
    [17326411] = { 1, xi.dynamis.eye.RED      }, -- (101-Y) | RDM
    [17326413] = { 1, xi.dynamis.eye.RED      }, -- (102-G) | MNK
    [17326415] = { 2, xi.dynamis.eye.BLUE     }, -- (103-Q(HP)) |
    [17326418] = { 2, xi.dynamis.eye.GREEN    }, -- (104-G(MP)) |
    [17326421] = { 2, xi.dynamis.eye.BLUE     }, -- (105-O(HP)) |
    [17326424] = { 2, xi.dynamis.eye.GREEN    }, -- (106-Y(MP)) |
    [17326427] = { 3, xi.dynamis.eye.RED      }, -- (107-H) | MNK, BRD, RNG
    [17326456] = { 1, xi.dynamis.eye.RED      }, -- (108-H) | MNK
    [17326467] = { 1, xi.dynamis.eye.RED      }, -- (109-H) | THF
    [17326465] = { 1, xi.dynamis.eye.RED      }, -- (110-H) | RNG
    [17326458] = { 1, xi.dynamis.eye.RED      }, -- (111-H) | BST
    [17326452] = { 2, xi.dynamis.eye.RED      }, -- (112-H) | BST, WAR
    [17326450] = { 1, xi.dynamis.eye.RED      }, -- (113-H) | DRK
    [17326443] = { 2, xi.dynamis.eye.RED      }, -- (114-H) | RNG, SAM
    [17326440] = { 2, xi.dynamis.eye.RED      }, -- (115-H) | WAR, RNG
    [17326436] = { 2, xi.dynamis.eye.RED      }, -- (116-H) | DRG, PLD
    [17326433] = { 2, xi.dynamis.eye.RED      }, -- (117-H) | BLM, NIN
    [17326431] = { 1, xi.dynamis.eye.RED      }, -- (118-H) | WHM
    [17326446] = { 2, xi.dynamis.eye.RED      }, -- (119-H) | THF, SMN
    [17326461] = { 2, xi.dynamis.eye.RED      }, -- (120-H(15)) | SMN, WHM
    [17326472] = { 1, xi.dynamis.eye.RED      }, -- (121-H) | BLM
    [17326469] = { 1, xi.dynamis.eye.RED      }, -- (122-H) | DRG
    [17326474] = { 1, xi.dynamis.eye.RED      }, -- (123-H) | DRK
    [17326476] = { 1, xi.dynamis.eye.RED      }, -- (124-H) | PLD
    [17326478] = { 2, xi.dynamis.eye.RED      }, -- (125-H) | BRD, WAR
    [17326481] = { 1, xi.dynamis.eye.RED      }, -- (126-H) | WHM
    [17326483] = { 1, xi.dynamis.eye.RED      }, -- (127-H) | BST
    [17326486] = { 2, xi.dynamis.eye.RED      }, -- (128-H) | SMN, PLD
    [17326490] = { 1, xi.dynamis.eye.RED      }, -- (129-H) | BRD
    [17326492] = { 1, xi.dynamis.eye.RED      }, -- (130-H) | RNG
    [17326494] = { 2, xi.dynamis.eye.RED      }, -- (131-H) | NIN, BLM
    [17326497] = { 1, xi.dynamis.eye.RED      }, -- (132-H) | MNK
    [17326499] = { 1, xi.dynamis.eye.RED      }, -- (133-H) | RNG
    [17326505] = { 1, xi.dynamis.eye.RED      }, -- (134-H) | SAM
    [17326507] = { 1, xi.dynamis.eye.RED      }, -- (135-H) | DRK
    [17326501] = { 2, xi.dynamis.eye.RED      }, -- (136-H) | DRG, THF
    [17326509] = { 2, xi.dynamis.eye.RED      }, -- (137-H) | WHM, MNK
    [17326512] = { 1, xi.dynamis.eye.RED      }, -- (138-H) | BST
    [17326515] = { 1, xi.dynamis.eye.RED      }, -- (139-H) | NIN
    [17326517] = { 1, xi.dynamis.eye.RED      }, -- (140-H) | BLM
    [17326519] = { 1, xi.dynamis.eye.RED      }, -- (141-H) | SMN
    [17326522] = { 1, xi.dynamis.eye.RED      }, -- (142-H) | DRG
    [17326525] = { 1, xi.dynamis.eye.RED      }, -- (143-H) | SAM
    [17326527] = { 1, xi.dynamis.eye.RED      }, -- (144-H) | RNG
    [17326529] = { 1, xi.dynamis.eye.RED      }, -- (145-H) | PLD
    [17326531] = { 1, xi.dynamis.eye.RED      }, -- (146-H) | WAR
    [17326536] = { 2, xi.dynamis.eye.RED      }, -- (147-H(15)) | RNG, THF
    [17326533] = { 2, xi.dynamis.eye.RED      }, -- (148-H) | PLD, BRD
    [17326539] = { 1, xi.dynamis.eye.RED      }, -- (149-H) | DRG
    [17326542] = { 2, xi.dynamis.eye.RED      }, -- (150-H) | BRD, RNG
    [17326545] = { 1, xi.dynamis.eye.RED      }, -- (151-H) | BLM
    [17326547] = { 1, xi.dynamis.eye.RED      }, -- (152-H) | NIN
    [17326549] = { 0, xi.dynamis.eye.RED      }, -- (153-H) |
    [17326550] = { 1, xi.dynamis.eye.RED      }, -- (154-H) | BST
    [17326553] = { 1, xi.dynamis.eye.RED      }, -- (155-H) | SMN
    [17326556] = { 2, xi.dynamis.eye.RED      }, -- (156-H) | MNK, DRK
    [17326559] = { 5, xi.dynamis.eye.RED      }, -- (157-H) | RNG, SAM, WHM, THF, NIN, RNG, RNG, PLD, PLD
    [17326586] = { 6, xi.dynamis.eye.RED      }, -- (158-Attest. NM (Dagourmarche) (DRG+SMN+BST)) |
    [17326601] = { 6, xi.dynamis.eye.RED      }, -- (159-Attest. NM (Quiebitiel) (BLM+WHM+BRD)) |
    [17326565] = { 6, xi.dynamis.eye.RED      }, -- (160-Attest. NM (Goublefaupe) (RDM+PLD+WAR)) |
    [17326579] = { 6, xi.dynamis.eye.RED      }, -- (161-Attest. NM (Mildaunegeux) (MNK+NIN+THF)) |
    [17326572] = { 6, xi.dynamis.eye.RED      }, -- (162-Attest. NM (Velosareon) (DRK+SAM+RNG)) |
    [17326608] = { 4, xi.dynamis.eye.RED      }, -- (163-Ahriman NM (Angra Mainyu)) |
}

-- Wave spawn table for large waves
xi.dynamis.wave = xi.dynamis.wave or { }
xi.dynamis.wave[zoneID] =
{
    [1] = -- Spawns at start of the instance
    {
        17326081, -- (003-Y)   Avatar Icon
        17326084, -- (001-Q)   Adamantking Effigy
        17326087, -- (002-O)   Serjeant Tombstone
        17326090, -- (004-G)   Goblin Replica
        17326093, -- (007-O)   Serjeant Tombstone
        17326097, -- (006-Q)   Adamantking Effigy
        17326101, -- (005-Y)   Avatar Icon
        17326104, -- (008-G)   Goblin Replica
        17326108, -- (010-Y)   Avatar Icon
        17326112, -- (009-Y)   Avatar Icon
        17326114, -- (011-Y)   Avatar Icon
        17326116, -- (013-Y)   Avatar Icon
        17326120, -- (012-Y)   Avatar Icon
        17326124, -- (015-Y)   Avatar Icon
        17326137, -- (016-Y)   Avatar Icon
        17326130, -- (017-Y)   Avatar Icon
        17326133, -- (014-Y)   Avatar Icon
        17326128, -- (018-Y)   Avatar Icon
        17326139, -- (019-Y)   Avatar Icon
        17326142, -- (020-Y)   Avatar Icon
        17326146, -- (021-Y)   Avatar Icon
        17326150, -- (023-Y)   Avatar Icon
        17326153, -- (022-Y)   Avatar Icon
        17326156, -- (028-Y)   Avatar Icon
        17326160, -- (027-Y)   Avatar Icon
        17326164, -- (029-Y)   Avatar Icon
        17326167, -- (026-Y)   Avatar Icon
        17326170, -- (030-Y)   Avatar Icon
        17326174, -- (025-Y)   Avatar Icon
        17326177, -- (024- )   Dynamis Icon
        17326182, -- (031-G)   Goblin Statue
        17326186, -- (033-G)   Goblin Statue
        17326189, -- (032-G)   Goblin Statue
        17326192, -- (034-G)   Goblin Statue
        17326195, -- (035-G)   Goblin Statue
        17326198, -- (036-G)   Goblin Statue
        17326200, -- (037-G)   Goblin Statue
        17326203, -- (038-G)   Goblin Statue
        17326207, -- (048-G)   Goblin Statue
        17326209, -- (050-G)   Goblin Statue
        17326211, -- (051-G)   Goblin Statue
        17326214, -- (049-G)   Goblin Statue
        17326217, -- (052-G)   Goblin Statue
        17326221, -- (053-G)   Goblin Statue
        17326225, -- (047- )   Dynamis Statue
        17326231, -- (039-G)   Goblin Statue
        17326234, -- (041-G)   Goblin Statue
        17326237, -- (040-G)   Goblin Statue
        17326241, -- (043-G)   Goblin Statue
        17326244, -- (042-G)   Goblin Statue
        17326247, -- (044-G)   Goblin Statue
        17326252, -- (045-G)   Goblin Statue
        17326256, -- (046-G)   Goblin Statue
        17326259, -- (056-Q)   Adamantking Effigy
        17326265, -- (054-Q)   Adamantking Effigy
        17326262, -- (055-Q)   Adamantking Effigy
        17326268, -- (057-Q)   Adamantking Effigy
        17326272, -- (068- )   Dynamis Effigy
        17326278, -- (076-Q)   Adamantking Effigy
        17326282, -- (075-Q)   Adamantking Effigy
        17326284, -- (074-Q)   Adamantking Effigy
        17326287, -- (073-Q)   Adamantking Effigy
        17326289, -- (072-Q)   Adamantking Effigy
        17326293, -- (071-Q)   Adamantking Effigy
        17326295, -- (070-Q)   Adamantking Effigy
        17326298, -- (069-Q)   Adamantking Effigy
        17326300, -- (058-Q)   Adamantking Effigy
        17326303, -- (059-Q)   Adamantking Effigy
        17326305, -- (060-Q)   Adamantking Effigy
        17326309, -- (061-Q)   Adamantking Effigy
        17326311, -- (062-Q)   Adamantking Effigy
        17326314, -- (063-Q)   Adamantking Effigy
        17326319, -- (065-Q)   Adamantking Effigy
        17326323, -- (064-Q)   Adamantking Effigy
        17326326, -- (067-Q)   Adamantking Effigy
        17326331, -- (066-Q)   Adamantking Effigy
        17326334, -- (090- )   Dynamis Tombstone
        17326340, -- (091-O)   Serjeant Tombstone
        17326344, -- (092-O)   Serjeant Tombstone
        17326346, -- (093-O)   Serjeant Tombstone
        17326348, -- (094-O)   Serjeant Tombstone
        17326351, -- (098-O)   Serjeant Tombstone
        17326354, -- (097-O)   Serjeant Tombstone
        17326356, -- (096-O)   Serjeant Tombstone
        17326358, -- (095-O)   Serjeant Tombstone
        17326362, -- (077-O)   Serjeant Tombstone
        17326365, -- (078-O)   Serjeant Tombstone
        17326368, -- (079-O)   Serjeant Tombstone
        17326373, -- (080-O)   Serjeant Tombstone
        17326376, -- (081-O)   Serjeant Tombstone
        17326379, -- (084-O)   Serjeant Tombstone
        17326382, -- (083-O)   Serjeant Tombstone
        17326385, -- (082-O)   Serjeant Tombstone
        17326389, -- (085-O)   Serjeant Tombstone
        17326392, -- (086-O)   Serjeant Tombstone
        17326396, -- (087-O)   Serjeant Tombstone
        17326400, -- (088-O)   Serjeant Tombstone
        17326403, -- (089-O)   Serjeant Tombstone
        17326406, -- (099-O)   Serjeant Tombstone
        17326408, -- (100-Q)   Adanantking Effigy
        17326411, -- (101-Y)   Avatar Icon
        17326413, -- (102-G)   Goblin Replica
        17326415, -- (103-Q)   Adamantking Effigy
        17326418, -- (104-G)   Goblin Replica
        17326421, -- (105-O)   Serjeant Tombstone
        17326424, -- (106-Y)   Avatar Icon
        17326427, -- (107-H)   Vanguard Eye
        17326431, -- (118-H)   Vanguard Eye
        17326433, -- (117-H)   Vanguard Eye
        17326436, -- (116-H)   Vanguard Eye
        17326440, -- (115-H)   Vanguard Eye
        17326443, -- (114-H)   Vanguard Eye
        17326446, -- (119-H)   Vanguard Eye
        17326450, -- (113-H)   Vanguard Eye
        17326452, -- (112-H)   Vanguard Eye
        17326456, -- (108-H)   Vanguard Eye
        17326458, -- (111-H)   Vanguard Eye
        17326465, -- (110-H)   Vanguard Eye
        17326467, -- (109-H)   Vanguard Eye
        17326469, -- (122-H)   Vanguard Eye
        17326472, -- (121-H)   Vanguard Eye
        17326474, -- (123-H)   Vanguard Eye
        17326476, -- (124-H)   Vanguard Eye
        17326478, -- (125-H)   Vanguard Eye
        17326481, -- (126-H)   Vanguard Eye
        17326483, -- (127-H)   Vanguard Eye
        17326486, -- (128-H)   Vanguard Eye
        17326490, -- (129-H)   Vanguard Eye
        17326492, -- (130-H)   Vanguard Eye
        17326494, -- (131-H)   Vanguard Eye
        17326497, -- (132-H)   Vanguard Eye
        17326499, -- (133-H)   Vanguard Eye
        17326501, -- (136-H)   Vanguard Eye
        17326505, -- (134-H)   Vanguard Eye
        17326507, -- (135-H)   Vanguard Eye
        17326509, -- (137-H)   Vanguard Eye
        17326512, -- (138-H)   Vanguard Eye
        17326515, -- (139-H)   Vanguard Eye
        17326517, -- (140-H)   Vanguard Eye
        17326519, -- (141-H)   Vanguard Eye
        17326522, -- (142-H)   Vanguard Eye
        17326525, -- (143-H)   Vanguard Eye
        17326527, -- (144-H)   Vanguard Eye
        17326529, -- (145-H)   Vanguard Eye
        17326531, -- (146-H)   Vanguard Eye
        17326533, -- (148-H)   Vanguard Eye
        17326536, -- (147-H)   Vanguard Eye
        17326539, -- (149-H)   Vanguard Eye
        17326542, -- (150-H)   Vanguard Eye
        17326545, -- (151-H)   Vanguard Eye
        17326547, -- (152-H)   Vanguard Eye
        17326549, -- (153-H)   Vanguard Eye
        17326550, -- (154-H)   Vanguard Eye
        17326553, -- (155-H)   Vanguard Eye
        17326556, -- (156-H)   Vanguard Eye
        17326559, -- (157-H)   Vanguard Eye
        17326608, -- (163- )   Angra Mainyu
    },
    [2] = -- Spawns paper NMs
    {
        17326565, -- ( 160 ) Attest. NM (Goublefaupe)
        17326601, -- ( 159 ) Attest. NM (Quiebitiel)
        17326579, -- ( 161 ) Attest. NM (Mildaunegeux)
        17326572, -- ( 162 ) Attest. NM (Velosareon)
        17326586, -- ( 158 ) Attest. NM (Dagourmarche)
    },
}

xi.beauc = xi.beauc or { }
xi.beauc.mobs =
{
    -- Statues
    VANGUARD_EYE_157        = 17326559,
    -- TEs
    AVATAR_ICON_10          = 17326108,
    AVATAR_ICON_20          = 17326142,
    GOBLIN_STATUE_31        = 17326182,
    GOBLIN_STATUE_46        = 17326256,
    ADAMANTKING_EFFIGY_63   = 17326314,
    ADAMANTKING_EFFIGY_66   = 17326331,
    SERJEANT_TOMBSTONE_83   = 17326382,
    SERJEANT_TOMBSTONE_87   = 17326396,
    VANGUARD_EYE_120        = 17326461,
    VANGUARD_EYE_147        = 17326536,
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.beauc.mobs.VANGUARD_EYE_157] = '[DYNA]157Killed',
}

xi.dynamis.spawnCheck = xi.dynamis.spawnCheck or {}
xi.dynamis.spawnCheck[zoneID] =
{
    {
        -- Spawns paper NMs after killing 157 Vanguard Eye
        requiredVars    = { '[DYNA]157Killed' },
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
        [17326433] = { 17326461 }, -- (117-H) | BLM Vanguard Eye aggros (120-H(15)) | SMN, WHM Vanguard Eye
    },
    aggressive =
    {
        -- Nothing
    },
}

-- Pathing table
-- No mobs path in this zone

xi.dynamis.timeExtension = xi.dynamis.timeExtension or { }
xi.dynamis.timeExtension[zoneID] =
{
    [xi.beauc.mobs.AVATAR_ICON_10]        = 15, -- (010-Y) Avatar Icon
    [xi.beauc.mobs.AVATAR_ICON_20]        = 15, -- (020-Y) Avatar Icon
    [xi.beauc.mobs.GOBLIN_STATUE_31]      = 15, -- (031-G) Goblin Statue
    [xi.beauc.mobs.GOBLIN_STATUE_46]      = 15, -- (046-G) Goblin Statue
    [xi.beauc.mobs.ADAMANTKING_EFFIGY_63] = 15, -- (063-Q) Adamantking Effigy
    [xi.beauc.mobs.ADAMANTKING_EFFIGY_66] = 15, -- (066-Q) Adamantking Effigy
    [xi.beauc.mobs.SERJEANT_TOMBSTONE_83] = 15, -- (083-O) Serjeant Tombstone
    [xi.beauc.mobs.SERJEANT_TOMBSTONE_87] = 15, -- (087-O) Serjeant Tombstone
    [xi.beauc.mobs.VANGUARD_EYE_120]      = 15, -- (120-H) Vanguard Eye
    [xi.beauc.mobs.VANGUARD_EYE_147]      = 15, -- (147-H) Vanguard Eye
}
