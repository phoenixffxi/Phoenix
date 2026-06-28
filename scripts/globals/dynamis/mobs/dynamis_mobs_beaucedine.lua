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
    -- ID = { # to spawn }
    -- MP = green HP = blue
    [17326084] = { 2 }, -- (001-Q) | WHM
    [17326087] = { 2 }, -- (002-O) | WAR, BLM
    [17326081] = { 2 }, -- (003-Y) | THF, RNG
    [17326090] = { 2 }, -- (004-G) | DRK, BRD
    [17326101] = { 2 }, -- (005-Y(HP)) | NIN, RDM
    [17326097] = { 2 }, -- (006-Q) | BST, PLD
    [17326093] = { 2 }, -- (007-O) | MNK, DRG
    [17326104] = { 2 }, -- (008-G(MP)) | SMN, THF
    [17326112] = { 1 }, -- (009-Y) | PLD
    [17326108] = { 3 }, -- (010-Y(15)) | WHM, RDM
    [17326114] = { 1 }, -- (011-Y) | DRK
    [17326120] = { 2 }, -- (012-Y(MP)) | SAM, SMN
    [17326116] = { 2 }, -- (013-Y(HP)) | WAR, BST
    [17326133] = { 2 }, -- (014-Y) | BLM
    [17326124] = { 2 }, -- (015-Y) | MNK
    [17326137] = { 1 }, -- (016-Y) | PLD
    [17326130] = { 2 }, -- (017-Y) | DRK
    [17326128] = { 1 }, -- (018-Y(HP)) | RDM
    [17326139] = { 2 }, -- (019-Y(MP)) | WAR
    [17326142] = { 2 }, -- (020-Y(15)) | NIN
    [17326146] = { 3 }, -- (021-Y) | SAM, THF
    [17326153] = { 2 }, -- (022-Y(MP)) | RNG, NIN
    [17326150] = { 2 }, -- (023-Y(HP)) | BLM, RDM
    [17326177] = { 4 }, -- (024-Replica NM (Dynamis Icon)) |
    [17326174] = { 2 }, -- (025-Y(MP)) | THF, SAM
    [17326167] = { 2 }, -- (026-Y) | WAR
    [17326160] = { 2 }, -- (027-Y(MP)) | SMN, RDM
    [17326156] = { 2 }, -- (028-Y(HP)) | WHM, BST
    [17326164] = { 2 }, -- (029-Y) | PLD
    [17326170] = { 2 }, -- (030-Y(HP)) | DRG, MNK
    [17326182] = { 2 }, -- (031-G(15)) | BST
    [17326189] = { 2 }, -- (032-G) | RDM, SAM
    [17326186] = { 2 }, -- (033-G) | WHM, RNG
    [17326192] = { 2 }, -- (034-G) | NIN
    [17326195] = { 2 }, -- (035-G) | WAR
    [17326198] = { 1 }, -- (036-G) | DRK
    [17326200] = { 2 }, -- (037-G(HP)) | PLD, SAM
    [17326203] = { 2 }, -- (038-G(MP)) | DRG, WHM
    [17326231] = { 2 }, -- (039-G) | WAR, WHM
    [17326237] = { 2 }, -- (040-G(MP)) | BLM
    [17326234] = { 2 }, -- (041-G(HP)) | PLD
    [17326244] = { 2 }, -- (042-G) | RNG
    [17326241] = { 2 }, -- (043-G) | BRD, MNK
    [17326247] = { 2 }, -- (044-G(HP)) | SMN, DRG
    [17326252] = { 2 }, -- (045-G(MP)) | BST, PLD
    [17326256] = { 2 }, -- (046-G(15)) | THF
    [17326225] = { 4 }, -- (047-Replica NM (Dynamis Statue)) |
    [17326207] = { 1 }, -- (048-G) | BLM
    [17326214] = { 2 }, -- (049-G(MP)) | NIN, DRK
    [17326209] = { 1 }, -- (050-G) | THF
    [17326211] = { 2 }, -- (051-G(HP)) | MNK, RDM
    [17326217] = { 2 }, -- (052-G(MP)) | SAM
    [17326221] = { 2 }, -- (053-G(HP)) | DRG
    [17326265] = { 2 }, -- (054-Q) | RNG
    [17326262] = { 2 }, -- (055-Q) | NIN
    [17326259] = { 2 }, -- (056-Q(HP)) | WAR, RDM
    [17326268] = { 2 }, -- (057-Q(MP)) | BRD, DRG
    [17326300] = { 2 }, -- (058-Q) | BLM
    [17326303] = { 1 }, -- (059-Q(HP)) | DRK
    [17326305] = { 2 }, -- (060-Q) | BST
    [17326309] = { 1 }, -- (061-Q(MP)) | WAR
    [17326311] = { 2 }, -- (062-Q) |
    [17326314] = { 3 }, -- (063-Q(15)) | THF, RNG
    [17326323] = { 2 }, -- (064-Q) | WHM, BLM
    [17326319] = { 2 }, -- (065-Q(HP)) | SMN, MNK
    [17326331] = { 2 }, -- (066-Q(15)) | WAR
    [17326326] = { 2 }, -- (067-Q(MP)) | DRG, BST
    [17326272] = { 4 }, -- (068-Replica NM (Dynamis Effigy)) |
    [17326298] = { 1 }, -- (069-Q) | MNK
    [17326295] = { 2 }, -- (070-Q(HP)) | THF, DRK
    [17326293] = { 1 }, -- (071-Q) | PLD
    [17326289] = { 2 }, -- (072-Q(MP)) | NIN
    [17326287] = { 1 }, -- (073-Q) | RNG
    [17326284] = { 2 }, -- (074-Q(HP)) | RDM, BRD
    [17326282] = { 1 }, -- (075-Q) | WAR
    [17326278] = { 2 }, -- (076-Q(MP)) | SMN
    [17326362] = { 2 }, -- (077-O) | WHM, RNG
    [17326365] = { 2 }, -- (078-O(HP)) | NIN, SAM
    [17326368] = { 2 }, -- (079-O) | BST
    [17326373] = { 2 }, -- (080-O(MP)) | BRD, PLD
    [17326376] = { 2 }, -- (081-O) | WAR, RDM
    [17326385] = { 2 }, -- (082-O(MP)) | DRG
    [17326382] = { 2 }, -- (083-O(15)) | MNK
    [17326379] = { 2 }, -- (084-O(HP)) | RNG
    [17326389] = { 2 }, -- (085-O) | WHM, RDM
    [17326392] = { 2 }, -- (086-O(HP)) | SMN
    [17326396] = { 2 }, -- (087-O(15)) | BST
    [17326400] = { 2 }, -- (088-O(MP)) | NIN
    [17326403] = { 2 }, -- (089-O) | SAM, DRK
    [17326334] = { 4 }, -- (090-Replica NM (Dynamis Tombstone)) |
    [17326340] = { 2 }, -- (091-O(HP)) | THF
    [17326344] = { 1 }, -- (092-O) | RNG
    [17326346] = { 1 }, -- (093-O) | BLM
    [17326348] = { 2 }, -- (094-O(MP)) | PLD, BRD
    [17326358] = { 2 }, -- (095-O(HP)) | SMN, THF
    [17326356] = { 1 }, -- (096-O) | NIN
    [17326354] = { 1 }, -- (097-O) | DRK
    [17326351] = { 2 }, -- (098-O(MP)) | MNK
    [17326406] = { 1 }, -- (099-O) | BLM
    [17326408] = { 1 }, -- (100-Q) | SMN
    [17326411] = { 1 }, -- (101-Y) | RDM
    [17326413] = { 1 }, -- (102-G) | MNK
    [17326415] = { 2 }, -- (103-Q(HP)) |
    [17326418] = { 2 }, -- (104-G(MP)) |
    [17326421] = { 2 }, -- (105-O(HP)) |
    [17326424] = { 2 }, -- (106-Y(MP)) |
    [17326427] = { 3 }, -- (107-H) | MNK, BRD, RNG
    [17326456] = { 1 }, -- (108-H) | MNK
    [17326467] = { 1 }, -- (109-H) | THF
    [17326465] = { 1 }, -- (110-H) | RNG
    [17326458] = { 1 }, -- (111-H) | BST
    [17326452] = { 2 }, -- (112-H) | BST, WAR
    [17326450] = { 1 }, -- (113-H) | DRK
    [17326443] = { 2 }, -- (114-H) | RNG, SAM
    [17326440] = { 2 }, -- (115-H) | WAR, RNG
    [17326436] = { 2 }, -- (116-H) | DRG, PLD
    [17326433] = { 2 }, -- (117-H) | BLM, NIN
    [17326431] = { 1 }, -- (118-H) | WHM
    [17326446] = { 2 }, -- (119-H) | THF, SMN
    [17326461] = { 2 }, -- (120-H(15)) | SMN, WHM
    [17326472] = { 1 }, -- (121-H) | BLM
    [17326469] = { 1 }, -- (122-H) | DRG
    [17326474] = { 1 }, -- (123-H) | DRK
    [17326476] = { 1 }, -- (124-H) | PLD
    [17326478] = { 2 }, -- (125-H) | BRD, WAR
    [17326481] = { 1 }, -- (126-H) | WHM
    [17326483] = { 1 }, -- (127-H) | BST
    [17326486] = { 2 }, -- (128-H) | SMN, PLD
    [17326490] = { 1 }, -- (129-H) | BRD
    [17326492] = { 1 }, -- (130-H) | RNG
    [17326494] = { 2 }, -- (131-H) | NIN, BLM
    [17326497] = { 1 }, -- (132-H) | MNK
    [17326499] = { 1 }, -- (133-H) | RNG
    [17326505] = { 1 }, -- (134-H) | SAM
    [17326507] = { 1 }, -- (135-H) | DRK
    [17326501] = { 2 }, -- (136-H) | DRG, THF
    [17326509] = { 2 }, -- (137-H) | WHM, MNK
    [17326512] = { 1 }, -- (138-H) | BST
    [17326515] = { 1 }, -- (139-H) | NIN
    [17326517] = { 1 }, -- (140-H) | BLM
    [17326519] = { 1 }, -- (141-H) | SMN
    [17326522] = { 1 }, -- (142-H) | DRG
    [17326525] = { 1 }, -- (143-H) | SAM
    [17326527] = { 1 }, -- (144-H) | RNG
    [17326529] = { 1 }, -- (145-H) | PLD
    [17326531] = { 1 }, -- (146-H) | WAR
    [17326536] = { 2 }, -- (147-H(15)) | RNG, THF
    [17326533] = { 2 }, -- (148-H) | PLD, BRD
    [17326539] = { 1 }, -- (149-H) | DRG
    [17326542] = { 2 }, -- (150-H) | BRD, RNG
    [17326545] = { 1 }, -- (151-H) | BLM
    [17326547] = { 1 }, -- (152-H) | NIN
    [17326549] = { 0 }, -- (153-H) |
    [17326550] = { 1 }, -- (154-H) | BST
    [17326553] = { 1 }, -- (155-H) | SMN
    [17326556] = { 2 }, -- (156-H) | MNK, DRK
    [17326559] = { 5 }, -- (157-H) | RNG, SAM, WHM, THF, NIN, RNG, RNG, PLD, PLD
    [17326586] = { 7 }, -- (158-Attest. NM (Dagourmarche) (DRG+SMN+BST)) |
    [17326601] = { 6 }, -- (159-Attest. NM (Quiebitiel) (BLM+WHM+BRD)) |
    [17326565] = { 6 }, -- (160-Attest. NM (Goublefaupe) (RDM+PLD+WAR)) |
    [17326579] = { 6 }, -- (161-Attest. NM (Mildaunegeux) (MNK+NIN+THF)) |
    [17326572] = { 6 }, -- (162-Attest. NM (Velosareon) (DRK+SAM+RNG)) |
    [17326608] = { 4 }, -- (163-Ahriman NM (Angra Mainyu)) |
}

xi.dynamis.eyeColor = xi.dynamis.eyeColor or {}
xi.dynamis.eyeColor[zoneID] =
{
    [17326101] = xi.dynamis.eye.BLUE , -- (005-Y(HP)) | NIN, RDM
    [17326104] = xi.dynamis.eye.GREEN, -- (008-G(MP)) | SMN, THF
    [17326120] = xi.dynamis.eye.GREEN, -- (012-Y(MP)) | SAM, SMN
    [17326116] = xi.dynamis.eye.BLUE , -- (013-Y(HP)) | WAR, BST
    [17326128] = xi.dynamis.eye.BLUE , -- (018-Y(HP)) | RDM
    [17326139] = xi.dynamis.eye.GREEN, -- (019-Y(MP)) | WAR
    [17326153] = xi.dynamis.eye.GREEN, -- (022-Y(MP)) | RNG, NIN
    [17326150] = xi.dynamis.eye.BLUE , -- (023-Y(HP)) | BLM, RDM
    [17326174] = xi.dynamis.eye.GREEN, -- (025-Y(MP)) | THF, SAM
    [17326160] = xi.dynamis.eye.GREEN, -- (027-Y(MP)) | SMN, RDM
    [17326156] = xi.dynamis.eye.BLUE , -- (028-Y(HP)) | WHM, BST
    [17326170] = xi.dynamis.eye.BLUE , -- (030-Y(HP)) | DRG, MNK
    [17326200] = xi.dynamis.eye.BLUE , -- (037-G(HP)) | PLD, SAM
    [17326203] = xi.dynamis.eye.GREEN, -- (038-G(MP)) | DRG, WHM
    [17326237] = xi.dynamis.eye.GREEN, -- (040-G(MP)) | BLM
    [17326234] = xi.dynamis.eye.BLUE , -- (041-G(HP)) | PLD
    [17326247] = xi.dynamis.eye.BLUE , -- (044-G(HP)) | SMN, DRG
    [17326252] = xi.dynamis.eye.GREEN, -- (045-G(MP)) | BST, PLD
    [17326214] = xi.dynamis.eye.GREEN, -- (049-G(MP)) | NIN, DRK
    [17326211] = xi.dynamis.eye.BLUE , -- (051-G(HP)) | MNK, RDM
    [17326217] = xi.dynamis.eye.GREEN, -- (052-G(MP)) | SAM
    [17326221] = xi.dynamis.eye.BLUE , -- (053-G(HP)) | DRG
    [17326259] = xi.dynamis.eye.BLUE , -- (056-Q(HP)) | WAR, RDM
    [17326268] = xi.dynamis.eye.GREEN, -- (057-Q(MP)) | BRD, DRG
    [17326303] = xi.dynamis.eye.BLUE , -- (059-Q(HP)) | DRK
    [17326309] = xi.dynamis.eye.GREEN, -- (061-Q(MP)) | WAR
    [17326319] = xi.dynamis.eye.BLUE , -- (065-Q(HP)) | SMN, MNK
    [17326326] = xi.dynamis.eye.GREEN, -- (067-Q(MP)) | DRG, BST
    [17326295] = xi.dynamis.eye.BLUE , -- (070-Q(HP)) | THF, DRK
    [17326289] = xi.dynamis.eye.GREEN, -- (072-Q(MP)) | NIN
    [17326284] = xi.dynamis.eye.BLUE , -- (074-Q(HP)) | RDM, BRD
    [17326278] = xi.dynamis.eye.GREEN, -- (076-Q(MP)) | SMN
    [17326365] = xi.dynamis.eye.BLUE , -- (078-O(HP)) | NIN, SAM
    [17326373] = xi.dynamis.eye.GREEN, -- (080-O(MP)) | BRD, PLD
    [17326385] = xi.dynamis.eye.GREEN, -- (082-O(MP)) | DRG
    [17326379] = xi.dynamis.eye.BLUE , -- (084-O(HP)) | RNG
    [17326392] = xi.dynamis.eye.BLUE , -- (086-O(HP)) | SMN
    [17326400] = xi.dynamis.eye.GREEN, -- (088-O(MP)) | NIN
    [17326340] = xi.dynamis.eye.BLUE , -- (091-O(HP)) | THF
    [17326348] = xi.dynamis.eye.GREEN, -- (094-O(MP)) | PLD, BRD
    [17326358] = xi.dynamis.eye.BLUE , -- (095-O(HP)) | SMN, THF
    [17326351] = xi.dynamis.eye.GREEN, -- (098-O(MP)) | MNK
    [17326415] = xi.dynamis.eye.BLUE , -- (103-Q(HP)) |
    [17326418] = xi.dynamis.eye.GREEN, -- (104-G(MP)) |
    [17326421] = xi.dynamis.eye.BLUE , -- (105-O(HP)) |
    [17326424] = xi.dynamis.eye.GREEN, -- (106-Y(MP)) |
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
    VANGUARD_EYE_157      = 17326559,
    -- TEs
    AVATAR_ICON_10        = 17326108,
    AVATAR_ICON_20        = 17326142,
    GOBLIN_STATUE_31      = 17326182,
    GOBLIN_STATUE_46      = 17326256,
    ADAMANTKING_EFFIGY_63 = 17326314,
    ADAMANTKING_EFFIGY_66 = 17326331,
    SERJEANT_TOMBSTONE_83 = 17326382,
    SERJEANT_TOMBSTONE_87 = 17326396,
    VANGUARD_EYE_120      = 17326461,
    VANGUARD_EYE_138      = 17326512,
    VANGUARD_EYE_139      = 17326515,
    VANGUARD_EYE_140      = 17326517,
    VANGUARD_EYE_147      = 17326536,
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.beauc.mobs.VANGUARD_EYE_157] = '[DYNA]157Killed',
    [xi.beauc.mobs.VANGUARD_EYE_138] = '[DYNA]138Killed',
    [xi.beauc.mobs.VANGUARD_EYE_139] = '[DYNA]139Killed',
    [xi.beauc.mobs.VANGUARD_EYE_140] = '[DYNA]140Killed',
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
    {
        -- Spawns 147 after killing 138, 139 and 140
        requiredVars    = { '[DYNA]138Killed', '[DYNA]139Killed', '[DYNA]140Killed' },
        spawn           = { xi.beauc.mobs.VANGUARD_EYE_147 },
        spawnedVar      = '[DYNA]Eye147Spawned',
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

xi.dynamis.lineSpawns = xi.dynamis.lineSpawns or { }
xi.dynamis.lineSpawns[zoneID] =
{
    -- Statue ID = { behind = { first mob distance, second mob distance } }, { side = { left distance, right distance } }, { behindLine = { behind = dist, side = { left, right } } }, or { { xOffset, yOffset, zOffset }, ... }
    -- Mobs with DB spawn position 1.000, 1.000, 1.000 default to spawning on top of the statue.
    -- lineSpawns below is only for explicit positioning exceptions.
    -- Beauc
    [17326319] = { behindLine = { behind = 4, side = { -3, 3 } } },
    [17326323] = { behindLine = { behind = 4, side = { -3, 3 } } },
    [17326326] = { behindLine = { behind = 4, side = { -3, 3 } } },
    [17326400] = { behindLine = { behind = 4, side = { -3, 3 } } },
    [17326403] = { behindLine = { behind = 4, side = { -3, 3 } } },
    [17326225] = { behindLine = { behind = { 0, 0, -4, 4 }, side = { -4, 4, 0, 0 } } }, -- left, right, front, back
    [17326334] = { behind = { 3, -3 } },
    [17326156] = { side = { -3, 3 } },
    [17326160] = { side = { -3, 3 } },
    [17326164] = { side = { -3, 3 } },
    [17326167] = { side = { -3, 3 } },
    [17326170] = { side = { -3, 3 } },
    [17326174] = { side = { -3, 3 } },
    [17326234] = { side = { -3, 3 } },
    [17326237] = { side = { -3, 3 } },
    [17326259] = { side = { -3, 3 } },
    [17326262] = { side = { -3, 3 } },
    [17326265] = { side = { -3, 3 } },
    [17326268] = { side = { -3, 3 } },
    [17326278] = { side = { -3, 3 } },
    [17326284] = { side = { -3, 3 } },
    [17326289] = { side = { -3, 3 } },
    [17326295] = { side = { -3, 3 } },
}

-- Pathing table
xi.dynamis.paths = xi.dynamis.paths or { }
xi.dynamis.paths[zoneID] =
{
    [17326084] = { { -268.843, -39.81, -346.472  },  { -269.730, -39.536, -334.707 } },
    [17326087] = { { -252.616, -39.639, -343.885 },  { -252.737, -39.490, -333.490 } },
    [17326116] = { { -189.65, -39.684, -199.202  },  { -171.948, -39.609, -198.753 } },
    [17326120] = { { -189.125, -39.657, -242.405 },  { -169.731, -39.715, -242.868 } },
    [17326124] = { { -46.367, -39.8, -208.203    },  { -38.448, -39.112, -222.212  } },
    [17326128] = { { -33.759, -40.175, -192.528  },  { -21.320, -39.067, -203.528  } },
    [17326130] = { { -21.508, -39.158, -195.678  },  { -0.951, -40, -205.565       } },
    [17326133] = { { -59.362, -40.839, -220.58   },  { -44.618, -39.878, -232.896  } },
    [17326137] = { { -24.285, -39.233, -203.01   },  { -36.510, -39.619, -228.357  } },
    [17326139] = { { -16.308, -40.634, -209.9    },  { -29.690, -40.24, -233.764   } },
    [17326150] = { { 71.548, -39.778, -1.274     },  { 110.494, -39.726, -3.818    } },
    [17326153] = { { 108.571, -39.63, 2.688      },  { 72.193, -39.811, 3.396      } },
    [17326156] = { { 75.41, -39.594, 67.268      },  { 75.149, -39.958, 080.425    } },
    [17326160] = { { 62.529, -39.567, 67.238     },  { 62.667, -39.189, 75.497     } },
    [17326164] = { { 80.976, -39.647, 51.082     },  { 79.051, -39.833, 72.632     } },
    [17326167] = { { 60.227, -39.892, 58.18      },  { 60.097, -39.186, 72.584     } },
    [17326170] = { { 74.805, -40.012, 45.399     },  { 75.523, -39.084, 58.848     } },
    [17326174] = { { 62.302, -39.265, 46.365     },  { 66.063, -39.798, 58.586     } },

    [17326225] = { { 111.259, -59.764, -39.423   }, { 86.219, -59.826, -50.663   } },
    [17326234] = { { -0.035, -59.059, 58.85      }, { -1.071, -60, 82.957        } },
    [17326237] = { { 12.403, -58.719, 56.908     }, { 13.218, -60.5, 82.726      } },
    [17326244] = { { 54.59, -60.535, 172.663     }, { 66.643, -61.365, 183.916   } },
    [17326247] = { { 53.245, -59.48, 201.43      }, { 80.764, -60.191, 207.801   } },
    [17326252] = { { 89.569, -61.445, 213.12     }, { 84.661, -59.548, 179.275   } },
    [17326259] = { { 162.012, -19.868, 33.337    }, { 178.837, -19.261, 31.982   } },
    [17326262] = { { 157.455, -19.434, 13.707    }, { 156.461, -19.702, 30.013   } },
    [17326265] = { { 178.482, -19.443, 27.607    }, { 176.170, -19.713, 9.084    } },
    [17326268] = { { 175.727, -19.488, 6.526     }, { 159.885, -19.956, 4.891    } },
    [17326278] = { { 255.849, -19.911, -134.054  }, { 254.947, -19.309, -119.078 } },
    [17326282] = { { 264.428, -20.4, -137.671    }, { 279.198, -20, -121.934     } },
    [17326284] = { { 265.883, -20.294, -142.307  }, { 282.4652, -19.1, -141.97   } },
    [17326287] = { { 262.632, -20.332, -147.132  }, { 275.616, -19.982, -159.805 } },
    [17326289] = { { 257.884, -20.254, -150.355  }, { 258.651, -19.203, -165.714 } },
    [17326293] = { { 251.977, -20.346, -147.744  }, { 239.947, -20, -160.215     } },
    [17326295] = { { 250.247, -20.288, -143.267  }, { 235.142, -19.395, -143.501 } },
    [17326298] = { { 251.715, -19.987, -134.73   }, { 241.018, -20, -121.260     } },
    [17326303] = { { 75.001, -19.951, -201.926   }, { 74.857, -19.062, -220.057  } },
    [17326309] = { { 72.507, -19.985, -228.609   }, { 64.819, -19.286, -241.602  } },
    [17326319] = { { -65.838, -19.406, -284.057  }, { -42.905, -20, -278.967     } },
    [17326323] = { { -66.722, -19.395, -301.755  }, { -50.832, -18.994, -286.991 } },
    [17326326] = { { -83.282, -20, -315.874      }, { -77.060, -19.640, -291.230 } },
    [17326362] = { { -17.037, 0, -329.172        }, { -24.713, 0, -310.672       } },
    [17326365] = { { -26.591, 0, -307.135        }, { -43.486, 0.147, -302.004   } },
    [17326373] = { { -53.079, 0, -306.444        }, { -59.654, 0.272, -323.336   } },
    [17326376] = { { -59.854, 0.278, -327.988    }, { -64.879, 0, -342.191       } },
    [17326389] = { { 366.665, 0.132, -0.107      }, { 393.253, 0.091, -5.219     } },
    [17326392] = { { 388.371, 0.174, 6.023       }, { 375.195, 0.315, 8.720      } },
    [17326400] = { { 375.839, 0.6, 30.158        }, { 400.699, 0.326, 29.459     } },
    [17326403] = { { 374.503, 0.646, 40.071      }, { 399.685, 0, 40.787         } },
    [17326334] = { { 333.597, 0.556, -158.405    }, { 393.696, 0.114, -158.532  } },
    [17326452] = { { -110.021, -80.008, 146.218  }, { -91.121, -79.766, 145.619   } },
    [17326458] = { { -148.852, -80.437, 182.064  }, { -155.609, -79.827, 153.214  } },
    [17326469] = { { -43.419, -80.078, 74.469    }, { -77.771, -80.092, 74.189    } },
    [17326472] = { { -80.143, -79.859, 86.834    }, { -43.608, -79.882, 85.001    } },
    [17326476] = { { -33.085, -80.11, -16.742    }, { -58.382, -80.435, -28.899   } },
    [17326478] = { { -56.17, -79.715, -42.376    }, { -68.990, -79.695, -58.022   } },
    [17326481] = { { -73.277, -79.658, -58.937   }, { -80.375, -80, -60.288       } },
    [17326486] = { { -96.929, -80.319, -69.882   }, { -102.119, -78.825, -100.953 } },
    [17326539] = { { -245.539, -99.841, 11.312   }, { -234.149, -99.976, 8.3000   } },
    [17326542] = { { -248.258, -99.524, 22.19    }, { -232.685, -99.283, 17.696   } },
    [17326545] = { { -247.553, -99.953, 30.01    }, { -231.545, -99.357, 26.133   } },
    [17326241] = { { 36.86, -59.593, 172.164     }, { 40.168, -60.000, 200.929    } },
}

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
