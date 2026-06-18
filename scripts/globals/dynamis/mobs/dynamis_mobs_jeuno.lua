-----------------------------------
--                            Dynamis-Jeuno
--    Primary Source of Information: https://enedin.be/dyna/html/zone/jeu.htm
-----------------------------------
local zoneID = xi.zone.DYNAMIS_JEUNO
xi = xi or { }
xi.dynamis = xi.dynamis or { }

-- Main spawn table for all 150 statues
xi.dynamis.spawnTable = xi.dynamis.spawnTable or { }
xi.dynamis.spawnTable[zoneID] =
{
    -- ID = { # to spawn }
    [17547265] = { 2 }, -- (001-G/R) | WAR, MNK
    [17547268] = { 2 }, -- (002-G/R(30)) | RDM, BRD
    [17547346] = { 3 }, -- (003-G/R) | PLD, DRK, Wyrmwix Snakespecs
    [17547351] = { 0 }, -- (004-G/R(30)) |
    [17547352] = { 2 }, -- (005-G/R(HP)) | THF, NIN
    [17547362] = { 0 }, -- (006-G/R) |
    [17547359] = { 0 }, -- (007-G/R) |
    [17547360] = { 1 }, -- (008-G/R) | BRD
    [17547355] = { 2 }, -- (009-G/R(MP)) | MNK, BST
    [17547363] = { 4 }, -- (010-G/R) | WAR, WHM, SMN, Hermitrix Toothrot
    [17547369] = { 2 }, -- (011-G/R(HP)) | RDM, SAM
    [17547372] = { 0 }, -- (012-G/R(MP)) |
    [17547373] = { 2 }, -- (013-G/R) | MNK, MNK
    [17547376] = { 1 }, -- (014-G/R) | NIN
    [17547378] = { 2 }, -- (015-G/R) | RDM, BST
    [17547382] = { 2 }, -- (016-G/R(HP)) | PLD, DRK
    [17547393] = { 1 }, -- (017-G/R(MP)) | WHM
    [17547385] = { 6 }, -- (018-G/R) | BLM, RNG, RNG, RNG, RNG, Morgmox Moldnoggin
    [17547398] = { 2 }, -- (019-G/R) | THF, DRG
    [17547395] = { 2 }, -- (020-G/R) | WAR, BRD
    [17547427] = { 1 }, -- (021-G/R) | DRG
    [17547437] = { 0 }, -- (022-G/R) |
    [17547441] = { 2 }, -- (023-G/R(HP)) | SMN, Humnox Drumbelly
    [17547438] = { 2 }, -- (024-G/R(MP)) | WAR, WHM
    [17547430] = { 2 }, -- (025-G/R(MP)) | THF, BST
    [17547434] = { 2 }, -- (026-G/R(HP)) | DRK, Buffrix Eargone
    [17547425] = { 1 }, -- (027-G/R) | NIN
    [17547423] = { 1 }, -- (028-G/R) | SAM
    [17547414] = { 6 }, -- (029-G/R(30)) | MNK, WHM, BLM, RDM, THF, Sparkspox Sweatbrow
    [17547411] = { 1 }, -- (030-G/R(MP)) | BST
    [17547421] = { 1 }, -- (031-G/R(HP)) | BRD
    [17547402] = { 1 }, -- (032-G/R) | SMN
    [17547409] = { 1 }, -- (033-G/R) | NIN
    [17547405] = { 2 }, -- (034-G/R) | SAM, DRG
    [17547449] = { 2 }, -- (035-G/R) | WAR, THF
    [17547445] = { 1 }, -- (036-G/R) | BLM
    [17547447] = { 1 }, -- (037-G/R) | BRD
    [17547459] = { 2 }, -- (038-G/R) | PLD, DRK
    [17547452] = { 3 }, -- (039-G/R(MP)) | SMN, SMN, SMN
    [17547462] = { 1 }, -- (040-G/R(HP)) | Elixmix Hooknose
    [17547464] = { 0 }, -- (041-G/R) |
    [17547466] = { 2 }, -- (042-G/R) | MNK, RDM
    [17547469] = { 3 }, -- (043-G/R) | NIN, NIN, Trailblix Goatmug
    [17547474] = { 0 }, -- (044-G/S(MP)) |
    [17547498] = { 6 }, -- (045-G/R(30)) | WHM, RDM, PLD, DRK, BRD, Bandrix Rockjaw
    [17547505] = { 1 }, -- (046-G/R) | BST
    [17547508] = { 1 }, -- (047-G/R) | BST
    [17547517] = { 1 }, -- (048-G/R) | SAM
    [17547511] = { 3 }, -- (049-G/R) | RNG, RNG, Lurklox Dhalmelneck
    [17547519] = { 1 }, -- (050-G/R) | DRG
    [17547529] = { 1 }, -- (051-G/R) | WAR
    [17547533] = { 1 }, -- (052-G/R) | BLM
    [17547524] = { 1 }, -- (053-G/R) | SMN
    [17547527] = { 1 }, -- (054-G/R) | MNK
    [17547531] = { 1 }, -- (055-G/R) | BLM
    [17547536] = { 0 }, -- (056-G/R(MP)) |
    [17547535] = { 0 }, -- (057-G/R(HP)) |
    [17547522] = { 1 }, -- (058-G/R) | NIN
    [17547540] = { 2 }, -- (059-G/R) | DRG, DRG
    [17547547] = { 1 }, -- (060-G/R) | RDM
    [17547545] = { 1 }, -- (061-G/R) | PLD
    [17547553] = { 3 }, -- (062-G/R(MP)) | BRD, SAM, Ticktox Beadyeyes
    [17547549] = { 3 }, -- (063-G/R(HP)) | WAR, WHM, THF
    [17547557] = { 0 }, -- (064-G/S(MP)) |
    [17547515] = { 1 }, -- (065-G/R(HP)) | PLD
    [17547537] = { 2 }, -- (066-G/R) | WHM, BLM
    [17547305] = { 2 }, -- (067-G/R(MP)) | MNK, BLM
    [17547302] = { 2 }, -- (068-G/R(HP)) | WAR, WHM
    [17547282] = { 1 }, -- (069-G/R) | SMN
    [17547280] = { 1 }, -- (070-G/R) | BLM
    [17547277] = { 1 }, -- (071-G/R) | BST
    [17547285] = { 1 }, -- (072-G/R) | DRG
    [17547297] = { 3 }, -- (073-G/R) | RNG, SMN, Gabblox Magpietongue
    [17547292] = { 3 }, -- (074-G/R) | THF, DRG, Tufflix Loglimbs
    [17547288] = { 3 }, -- (075-G/R) | WHM, NIN, Cloktix Longnail
    [17547274] = { 2 }, -- (076-G/R(MP)) | SAM, NIN
    [17547271] = { 2 }, -- (077-G/R(HP)) | DRK, RNG
    [17547560] = { 1 }, -- (078-G/R(MP)) | DRK
    [17547558] = { 1 }, -- (079-G/R(HP)) | PLD
    [17547570] = { 1 }, -- (080-G/R(HP)) | RNG
    [17547562] = { 1 }, -- (081-G/R(MP)) | NIN
    [17547572] = { 1 }, -- (082-G/R(MP)) | BRD
    [17547564] = { 1 }, -- (083-G/R(HP)) | WHM
    [17547566] = { 1 }, -- (084-G/R(HP)) | SAM
    [17547568] = { 1 }, -- (085-G/R(MP)) | WAR
    [17547574] = { 5 }, -- (086-G/R) | BLM, BLM, BLM, THF, Karashix Swollenskull
    [17547580] = { 5 }, -- (087-G/R) | PLD, DRK, BRD, RNG, Rutrix Hamgams
    [17547587] = { 4 }, -- (088-G/R) | SAM, DRG, SMN, Snypestix Eaglebeak
    [17547496] = { 1 }, -- (089-G/R) | RDM
    [17547495] = { 0 }, -- (090-G/R) |
    [17547493] = { 1 }, -- (091-G/R) | RDM
    [17547480] = { 1 }, -- (092-G/R) | SAM
    [17547489] = { 1 }, -- (093-G/R(HP)) | WAR
    [17547491] = { 1 }, -- (094-G/R(MP)) | MNK
    [17547482] = { 3 }, -- (095-G/R(MP)) | SMN, SMN, Mortilox Wartpaws
    [17547477] = { 1 }, -- (096-G/R) | DRG
    [17547475] = { 1 }, -- (097-G/R) | BLM
    [17547309] = { 0 }, -- (098-G/R) |
    [17547308] = { 0 }, -- (099-G/R) |
    [17547310] = { 0 }, -- (100-G/R) |
    [17547339] = { 0 }, -- (101-G/R(MP)) |
    [17547338] = { 0 }, -- (102-G/R(HP)) |
    [17547335] = { 2 }, -- (103-G/R) | THF, BRD
    [17547332] = { 2 }, -- (104-G/R) | THF, BRD
    [17547327] = { 3 }, -- (105-G/R) | BLM, DRG, Jabkix Pigeonpecs
    [17547322] = { 3 }, -- (106-G/R) | RDM, SMN, Wasabix Callusdigit
    [17547317] = { 3 }, -- (107-G/R) | WHM, BST, Smeltix Thickhide
    [17547344] = { 1 }, -- (108-G/R) | SAM
    [17547342] = { 1 }, -- (109-G/R) | PLD
    [17547340] = { 1 }, -- (110-G/R) | DRK
    [17547311] = { 2 }, -- (111-G/R) | RDM, PLD
    [17547314] = { 2 }, -- (112-G/R) | BLM, RNG
    [17547627] = { 0 }, -- (113-Replica NM (Goblin Golem)(30)) |
    [17547612] = { 4 }, -- (114-G/R) | BLM, RDM, RNG, SMN
    [17547606] = { 4 }, -- (115-G/R) | WAR, DRK, BST, BRD
    [17547594] = { 4 }, -- (116-G/R) | MNK, WHM, BST, SAM
    [17547600] = { 4 }, -- (117-G/R) | THF, PLD, NIN, DRG
    [17547619] = { 0 }, -- (118-G/R(MP)) |
    [17547618] = { 0 }, -- (119-G/R(HP)) |
    [17547620] = { 6 }, -- (120-G/R) | WAR, WHM, BLM, RDM, THF, Kikklix Longlegs
    [17547666] = { 3 }, -- (121-G/R) | WAR, BLM, DRG
    [17547675] = { 3 }, -- (122-G/R(MP)) | MNK, THF, SMN
    [17547671] = { 2 }, -- (123-G/R(HP)) | BST, SAM
    [17547680] = { 5 }, -- (124-G/R) | PLD, BST, BRD, RNG, Tymexox Ninefingers
    [17547687] = { 6 }, -- (125-G/R) | RNG, RNG, NIN, NIN, NIN, Slystix Megapeepers
    [17547694] = { 2 }, -- (126-G/R(HP)) | WHM, DRK
    [17547697] = { 2 }, -- (127-G/R(MP)) | RDM, DRG
    [17547704] = { 2 }, -- (128-G/R(HP)) | RDM, SMN
    [17547701] = { 2 }, -- (129-G/R(MP)) | WHM, DRK
    [17547708] = { 2 }, -- (130-G/R) | BST, SAM
    [17547712] = { 2 }, -- (131-G/R) | BLM, BST
    [17547716] = { 2 }, -- (132-G/R) | MNK, BST
    [17547735] = { 6 }, -- (133-G/R) | WAR, BLM, DRK, RNG, SMN, Bootrix Jaggedelbow
    [17547720] = { 6 }, -- (134-G/R) | THF, BRD, SAM, SAM, DRG, Anvilix Sootwrists
    [17547654] = { 6 }, -- (135-G/R) | WAR, MNK, WHM, BLM, RDM, Mobpix Mucousmouth
    [17547651] = { 1 }, -- (136-G/R) | SMN
    [17547648] = { 1 }, -- (137-G/R) | DRG
    [17547645] = { 1 }, -- (138-G/R) | BST
    [17547661] = { 4 }, -- (139-G/R) | PLD, PLD, PLD, BRD
    [17547631] = { 2 }, -- (140-G/R) | WAR, SAM
    [17547628] = { 2 }, -- (141-G/R) | MNK, THF
    [17547640] = { 4 }, -- (142-G/R) | DRK, RNG, NIN, Scruffix Shaggychest
    [17547637] = { 2 }, -- (143-G/R) | RDM, BRD
    [17547634] = { 2 }, -- (144-G/R) | WHM, BLM
    [17547755] = { 6 }, -- (145-G/R) | RDM, PLD, DRK, BRD, NIN, Blazox Boneybod
    [17547768] = { 6 }, -- (146-G/R) | WAR, MNK, MNK, WHM, RNG, Eremix Snottynostril
    [17547763] = { 2 }, -- (147-G/R) | DRG, SMN
    [17547749] = { 5 }, -- (148-G/R) | WHM, BLM, BRD, NIN, Jabbrox Grannyguise
    [17547743] = { 5 }, -- (149-G/R) | WAR, MNK, THF, SAM, Prowlox Barrelbelly
    [17547728] = { 6 }, -- (150-G/R(MP)) | RDM, THF, PLD, BRD, NIN, Distilix Stickytoes
}

xi.dynamis.eyeColor = xi.dynamis.eyeColor or {}
xi.dynamis.eyeColor[zoneID] =
{
    [17547352] = xi.dynamis.eye.BLUE , -- (005-G/R(HP)) | THF, NIN
    [17547355] = xi.dynamis.eye.GREEN, -- (009-G/R(MP)) | MNK, BST
    [17547369] = xi.dynamis.eye.BLUE , -- (011-G/R(HP)) | RDM, SAM
    [17547372] = xi.dynamis.eye.GREEN, -- (012-G/R(MP)) |
    [17547382] = xi.dynamis.eye.BLUE , -- (016-G/R(HP)) | PLD, DRK
    [17547393] = xi.dynamis.eye.GREEN, -- (017-G/R(MP)) | WHM
    [17547441] = xi.dynamis.eye.BLUE ,  -- (023-G/R(HP)) | SMN, Humnox Drumbelly
    [17547438] = xi.dynamis.eye.GREEN, -- (024-G/R(MP)) | WAR, WHM
    [17547430] = xi.dynamis.eye.GREEN, -- (025-G/R(MP)) | THF, BST
    [17547434] = xi.dynamis.eye.BLUE , -- (026-G/R(HP)) | DRK, Buffrix Eargone
    [17547411] = xi.dynamis.eye.GREEN, -- (030-G/R(MP)) | BST
    [17547421] = xi.dynamis.eye.BLUE , -- (031-G/R(HP)) | BRD
    [17547452] = xi.dynamis.eye.GREEN, -- (039-G/R(MP)) | SMN, SMN, SMN
    [17547462] = xi.dynamis.eye.BLUE , -- (040-G/R(HP)) | Elixmix Hooknose
    [17547474] = xi.dynamis.eye.GREEN, -- (044-G/S(MP)) |
    [17547536] = xi.dynamis.eye.GREEN, -- (056-G/R(MP)) |
    [17547535] = xi.dynamis.eye.BLUE , -- (057-G/R(HP)) |
    [17547553] = xi.dynamis.eye.GREEN, -- (062-G/R(MP)) | BRD, SAM, Ticktox Beadyeyes
    [17547549] = xi.dynamis.eye.BLUE , -- (063-G/R(HP)) | WAR, WHM, THF
    [17547515] = xi.dynamis.eye.BLUE , -- (065-G/R(HP)) | PLD
    [17547305] = xi.dynamis.eye.GREEN, -- (067-G/R(MP)) | MNK, BLM
    [17547302] = xi.dynamis.eye.BLUE , -- (068-G/R(HP)) | WAR, WHM
    [17547274] = xi.dynamis.eye.GREEN, -- (076-G/R(MP)) | SAM, NIN
    [17547271] = xi.dynamis.eye.BLUE , -- (077-G/R(HP)) | DRK, RNG
    [17547560] = xi.dynamis.eye.GREEN, -- (078-G/R(MP)) | DRK
    [17547558] = xi.dynamis.eye.BLUE , -- (079-G/R(HP)) | PLD
    [17547570] = xi.dynamis.eye.BLUE , -- (080-G/R(HP)) | RNG
    [17547562] = xi.dynamis.eye.GREEN, -- (081-G/R(MP)) | NIN
    [17547572] = xi.dynamis.eye.GREEN, -- (082-G/R(MP)) | BRD
    [17547564] = xi.dynamis.eye.BLUE , -- (083-G/R(HP)) | WHM
    [17547566] = xi.dynamis.eye.BLUE , -- (084-G/R(HP)) | SAM
    [17547568] = xi.dynamis.eye.GREEN, -- (085-G/R(MP)) | WAR
    [17547489] = xi.dynamis.eye.BLUE , -- (093-G/R(HP)) | WAR
    [17547491] = xi.dynamis.eye.GREEN, -- (094-G/R(MP)) | MNK
    [17547482] = xi.dynamis.eye.GREEN, -- (095-G/R(MP)) | SMN, SMN, Mortilox Wartpaws
    [17547339] = xi.dynamis.eye.GREEN, -- (101-G/R(MP)) |
    [17547338] = xi.dynamis.eye.BLUE , -- (102-G/R(HP)) |
    [17547606] = xi.dynamis.eye.BLUE,  -- (115-G/R) | WAR, DRK, BST, BRD
    [17547594] = xi.dynamis.eye.GREEN, -- (116-G/R) MP| MNK, WHM, BST, SAM
    [17547619] = xi.dynamis.eye.GREEN, -- (118-G/R(MP)) |
    [17547618] = xi.dynamis.eye.BLUE , -- (119-G/R(HP)) |
    [17547675] = xi.dynamis.eye.GREEN, -- (122-G/R(MP)) | MNK, THF, SMN
    [17547671] = xi.dynamis.eye.BLUE , -- (123-G/R(HP)) | BST, SAM
    [17547694] = xi.dynamis.eye.BLUE , -- (126-G/R(HP)) | WHM, DRK
    [17547697] = xi.dynamis.eye.GREEN, -- (127-G/R(MP)) | RDM, DRG
    [17547704] = xi.dynamis.eye.BLUE , -- (128-G/R(HP)) | RDM, SMN
    [17547701] = xi.dynamis.eye.GREEN, -- (129-G/R(MP)) | WHM, DRK
    [17547728] = xi.dynamis.eye.GREEN, -- (150-G/R(MP)) | RDM, THF, PLD, BRD, NIN, Distilix Stickytoes
}

-- Wave spawn table for large waves
xi.dynamis.wave = xi.dynamis.wave or { }
xi.dynamis.wave[zoneID] =
{
    [1] = -- Spawns at start of the instance
    {
        17547265, -- (001-G/R)  Goblin Replica
        17547268, -- (002-G/R)  Goblin Replica
        17547346, -- (003-G/R)  Goblin Replica
        17547351, -- (004-G/R)  Goblin Replica
        17547352, -- (005-G/R)  Goblin Replica
        17547362, -- (006-G/R)  Goblin Replica
        17547359, -- (007-G/R)  Goblin Replica
        17547360, -- (008-G/R)  Goblin Replica
        17547355, -- (009-G/R)  Goblin Replica
        17547363, -- (010-G/R)  Goblin Replica
        17547369, -- (011-G/R)  Goblin Replica
        17547372, -- (012-G/R)  Goblin Replica
        17547373, -- (013-G/R)  Goblin Replica
        17547376, -- (014-G/R)  Goblin Replica
        17547378, -- (015-G/R)  Goblin Replica
        17547382, -- (016-G/R)  Goblin Replica
        17547393, -- (017-G/R)  Goblin Replica
        17547385, -- (018-G/R)  Goblin Replica
        17547398, -- (019-G/R)  Goblin Replica
        17547395, -- (020-G/R)  Goblin Replica
        17547427, -- (021-G/R)  Goblin Replica
        17547437, -- (022-G/R)  Goblin Replica
        17547441, -- (023-G/R)  Goblin Replica
        17547438, -- (024-G/R)  Goblin Replica
        17547430, -- (025-G/R)  Goblin Replica
        17547434, -- (026-G/R)  Goblin Replica
        17547425, -- (027-G/R)  Goblin Replica
        17547423, -- (028-G/R)  Goblin Replica
        17547414, -- (029-G/R)  Goblin Replica
        17547411, -- (030-G/R)  Goblin Replica
        17547421, -- (031-G/R)  Goblin Replica
        17547402, -- (032-G/R)  Goblin Replica
        17547409, -- (033-G/R)  Goblin Replica
        17547405, -- (034-G/R)  Goblin Replica
        17547449, -- (035-G/R)  Goblin Replica
        17547445, -- (036-G/R)  Goblin Replica
        17547447, -- (037-G/R)  Goblin Replica
        17547459, -- (038-G/R)  Goblin Replica
        17547452, -- (039-G/R)  Goblin Replica
        17547462, -- (040-G/R)  Goblin Replica
        17547464, -- (041-G/R)  Goblin Replica
        17547466, -- (042-G/R)  Goblin Replica
        17547469, -- (043-G/R)  Goblin Replica
        17547474, -- (044-G/S)  Goblin Replica
        17547498, -- (045-G/R)  Goblin Replica
        17547505, -- (046-G/R)  Goblin Replica
        17547508, -- (047-G/R)  Goblin Replica
        17547517, -- (048-G/R)  Goblin Replica
        17547511, -- (049-G/R)  Goblin Replica
        17547519, -- (050-G/R)  Goblin Replica
        17547529, -- (051-G/R)  Goblin Replica
        17547533, -- (052-G/R)  Goblin Replica
        17547524, -- (053-G/R)  Goblin Replica
        17547527, -- (054-G/R)  Goblin Replica
        17547531, -- (055-G/R)  Goblin Replica
        17547536, -- (056-G/R)  Goblin Replica
        17547535, -- (057-G/R)  Goblin Replica
        17547522, -- (058-G/R)  Goblin Replica
        17547540, -- (059-G/R)  Goblin Replica
        17547547, -- (060-G/R)  Goblin Replica
        17547545, -- (061-G/R)  Goblin Replica
        17547553, -- (062-G/R)  Goblin Replica
        17547549, -- (063-G/R)  Goblin Replica
        17547557, -- (064-G/S)  Goblin Replica
        17547515, -- (065-G/R)  Goblin Replica
        17547537, -- (066-G/R)  Goblin Replica
        17547305, -- (067-G/R)  Goblin Replica
        17547302, -- (068-G/R)  Goblin Replica
        17547282, -- (069-G/R)  Goblin Replica
        17547280, -- (070-G/R)  Goblin Replica
        17547277, -- (071-G/R)  Goblin Replica
        17547285, -- (072-G/R)  Goblin Replica
        17547297, -- (073-G/R)  Goblin Replica
        17547292, -- (074-G/R)  Goblin Replica
        17547288, -- (075-G/R)  Goblin Replica
        17547274, -- (076-G/R)  Goblin Replica
        17547271, -- (077-G/R)  Goblin Replica
    },
    [2] = -- Spawns 101-112 when 98,99 and 100 all are killed
    {
        17547339, -- (101-G/R)  Goblin Replica
        17547338, -- (102-G/R)  Goblin Replica
        17547335, -- (103-G/R)  Goblin Replica
        17547332, -- (104-G/R)  Goblin Replica
        17547327, -- (105-G/R)  Goblin Replica
        17547322, -- (106-G/R)  Goblin Replica
        17547317, -- (107-G/R)  Goblin Replica
        17547344, -- (108-G/R)  Goblin Replica
        17547342, -- (109-G/R)  Goblin Replica
        17547340, -- (110-G/R)  Goblin Replica
        17547311, -- (111-G/R)  Goblin Replica
        17547314, -- (112-G/R)  Goblin Replica
    },
    [3] = -- Spawns 89-97 when 44 is killed
    {
        17547496, -- (089-G/R)  Goblin Replica
        17547495, -- (090-G/R)  Goblin Replica
        17547493, -- (091-G/R)  Goblin Replica
        17547480, -- (092-G/R)  Goblin Replica
        17547489, -- (093-G/R)  Goblin Replica
        17547491, -- (094-G/R)  Goblin Replica
        17547482, -- (095-G/R)  Goblin Replica
        17547477, -- (096-G/R)  Goblin Replica
        17547475, -- (097-G/R)  Goblin Replica
    },
    [4] = -- Spawns 78-89 and 113 (Megaboss) when 64 is killed
    {
        17547560, -- (078-G/R)  Goblin Replica
        17547558, -- (079-G/R)  Goblin Replica
        17547570, -- (080-G/R)  Goblin Replica
        17547562, -- (081-G/R)  Goblin Replica
        17547572, -- (082-G/R)  Goblin Replica
        17547564, -- (083-G/R)  Goblin Replica
        17547566, -- (084-G/R)  Goblin Replica
        17547568, -- (085-G/R)  Goblin Replica
        17547574, -- (086-G/R)  Goblin Replica
        17547580, -- (087-G/R)  Goblin Replica
        17547587, -- (088-G/R)  Goblin Replica
        17547627, -- (  113  )  Goblin Golem
        17547612, -- (114-G/R)  Goblin Replica
        17547606, -- (115-G/R)  Goblin Replica
        17547594, -- (116-G/R)  Goblin Replica
        17547600, -- (117-G/R)  Goblin Replica
        17547619, -- (118-G/R)  Goblin Replica
        17547618, -- (119-G/R)  Goblin Replica
        17547620, -- (120-G/R)  Goblin Replica
    },
    [5] = -- Spawns 121-150 when Megaboss killed
    {
        17547666, -- (121-G/R) Goblin Replica
        17547675, -- (122-G/R) Goblin Replica
        17547671, -- (123-G/R) Goblin Replica
        17547680, -- (124-G/R) Goblin Replica
        17547687, -- (125-G/R) Goblin Replica
        17547694, -- (126-G/R) Goblin Replica
        17547697, -- (127-G/R) Goblin Replica
        17547704, -- (128-G/R) Goblin Replica
        17547701, -- (129-G/R) Goblin Replica
        17547708, -- (130-G/R) Goblin Replica
        17547712, -- (131-G/R) Goblin Replica
        17547716, -- (132-G/R) Goblin Replica
        17547735, -- (133-G/R) Goblin Replica
        17547720, -- (134-G/R) Goblin Replica
        17547654, -- (135-G/R) Goblin Replica
        17547651, -- (136-G/R) Goblin Replica
        17547648, -- (137-G/R) Goblin Replica
        17547645, -- (138-G/R) Goblin Replica
        17547661, -- (139-G/R) Goblin Replica
        17547631, -- (140-G/R) Goblin Replica
        17547628, -- (141-G/R) Goblin Replica
        17547640, -- (142-G/R) Goblin Replica
        17547637, -- (143-G/R) Goblin Replica
        17547634, -- (144-G/R) Goblin Replica
        17547755, -- (145-G/R) Goblin Replica
        17547768, -- (146-G/R) Goblin Replica
        17547763, -- (147-G/R) Goblin Replica
        17547749, -- (148-G/R) Goblin Replica
        17547743, -- (149-G/R) Goblin Replica
        17547728, -- (150-G/R) Goblin Replica
    }
}

xi.jeuno = xi.jeuno or { }
xi.jeuno.mobs =
{
    -- Statues
    GOBLIN_STATUE_44   = 17547474,
    GOBLIN_STATUE_64   = 17547557,
    GOBLIN_REPLICA_73  = 17547297,
    GOBLIN_REPLICA_98  = 17547309,
    GOBLIN_STATUE_99   = 17547308,
    GOBLIN_REPLICA_100 = 17547310,
    -- Boss
    GOBLIN_GOLEM = 17547627,
    -- Time Extensions
    GOBLIN_REPLICA_2   = 17547268, -- 2
    GOBLIN_REPLICA_4   = 17547351, -- 4
    GOBLIN_REPLICA_29  = 17547414, -- 29
    GOBLIN_REPLICA_45  = 17547498, -- 45
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.jeuno.mobs.GOBLIN_STATUE_44]   = '[DYNA]44Killed',
    [xi.jeuno.mobs.GOBLIN_STATUE_64]   = '[DYNA]64Killed',
    [xi.jeuno.mobs.GOBLIN_REPLICA_73]  = '[DYNA]73Killed',
    [xi.jeuno.mobs.GOBLIN_REPLICA_98]  = '[DYNA]98Killed',
    [xi.jeuno.mobs.GOBLIN_STATUE_99]   = '[DYNA]99Killed',
    [xi.jeuno.mobs.GOBLIN_REPLICA_100] = '[DYNA]100Killed',
    [xi.jeuno.mobs.GOBLIN_GOLEM]       = '[DYNA]MegaBossKilled',
}

xi.dynamis.spawnCheck = xi.dynamis.spawnCheck or {}
xi.dynamis.spawnCheck[zoneID] =
{
    {
        -- Spawns 98-100 when 73 is killed
        requiredVars    = { '[DYNA]73Killed' },
        spawn           = { xi.jeuno.mobs.GOBLIN_REPLICA_98, xi.jeuno.mobs.GOBLIN_STATUE_99, xi.jeuno.mobs.GOBLIN_REPLICA_100 },
        spawnedVar      = '[DYNA]Wave6Spawned',
    },
    {
        -- Spawns 101-112 when 98,99 and 100 all are killed
        requiredVars    = { '[DYNA]98Killed', '[DYNA]99Killed', '[DYNA]100Killed' },
        spawn           = xi.dynamis.wave[zoneID][2],
        spawnedVar      = '[DYNA]Wave2Spawned',
    },
    {
        -- Spawns 89-97 when 44 is killed
        requiredVars    = { '[DYNA]44Killed' },
        spawn           = xi.dynamis.wave[zoneID][3],
        spawnedVar      = '[DYNA]Wave3Spawned',
    },
    {
        -- Spawns 78-89, 113 (Megaboss) and 114-120 when 64 is killed
        requiredVars    = { '[DYNA]64Killed' },
        spawn           = xi.dynamis.wave[zoneID][4],
        spawnedVar      = '[DYNA]Wave4Spawned',
    },
    {
        -- Spawns 121-150 when Megaboss killed
        requiredVars    = { '[DYNA]MegaBossKilled' },
        spawn           = xi.dynamis.wave[zoneID][5],
        spawnedVar      = '[DYNA]Wave5Spawned',
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

xi.dynamis.lineSpawns = xi.dynamis.lineSpawns or { }
xi.dynamis.lineSpawns[zoneID] =
{
    -- Statue ID = { behind = { first mob distance, second mob distance } }, { side = { left distance, right distance } }, or { { xOffset, yOffset, zOffset }, ... }
    -- Mobs with DB spawn position 1.000, 1.000, 1.000 default to spawning on top of the statue.
    -- lineSpawns below is only for explicit positioning exceptions.
    [17547395] = { behind = { -3, -6 } }, -- Mobs spawn in front
    [17547398] = { behind = { -3, -6 } }, -- Mobs spawn in front
}

-- Pathing table
xi.dynamis.paths = xi.dynamis.paths or { }
xi.dynamis.paths[zoneID] =
{
    [17547268] = { {  38, 9, -52  }, {  22, 9,  -52 },                  }, -- Dyna Entrance
    [17547351] = { {  42, 0, -20  }, {  28, 0,  -20 },                  }, -- Dyna Entrance Top of Stairs
    [17547359] = { {  30, 0, -7   }, {  30, 0,  -46 },                  }, -- E Upper Level C
    [17547360] = { {  27, 0, -7   }, {  27, 0,  -46 },                  }, -- E Upper Level W
    [17547362] = { {  33, 0, -7   }, {  33, 0,  -46 },                  }, -- E Upper Level E
    [17547395] = { {  -9, 0, -71  }, { -31, 0,  -71 },                  },
    [17547398] = { {  -9, 0, -77  }, { -31, 0,  -77 },                  },
    [17547302] = { {   2, 9, -27  }, {   2, 9,  -35 },                  }, -- Fountain Stairs E
    [17547305] = { {  -2, 9, -27  }, {  -2, 9,  -35 },                  }, -- Fountain Stairs W
    [17547280] = { {  -7, 9, -49  }, {  -7, 9,  -35 },                  }, -- Fountain W
    [17547277] = { {   9, 9, -51  }, {  -7, 9,  -51 },                  }, -- Fountain S
    [17547282] = { {  -5, 9, -37  }, {   5, 9,  -37 },                  }, -- Fountain N
    [17547285] = { {   7, 9, -35  }, {   7, 9,  -49 },                  }, -- Fountain E
    [17547511] = { {   0, -5, 61  }, {   0, 0,   51 }, {  0, 2,   44 }, }, -- Palace Stairs
    [17547393] = { {   1, 0, -69  }, {   1, 0,  -85 },                  }, -- Near Mega Boss
    [17547427] = { { -26, 0, -67  }, { -26, 0,  -43 },                  }, -- W Upper Level
    [17547437] = { { -37, 0, -63  }, { -37, 0,  -41 },                  }, -- W Upper Level
    [17547425] = { { -34, 0, -36  }, { -34, 3,  -14 },                  }, -- W Upper Level Stairs W
    [17547423] = { { -26, 3, -14  }, { -26, 0,  -38 },                  }, -- W Upper Level Stairs E
    [17547421] = { { -18, 3,  -2  }, { -36, 3,   -2 },                  }, -- N Upper Level N
    [17547411] = { { -18, 3, -10  }, { -36, 3,  -10 },                  }, -- N Upper Level S
    [17547402] = { { 4, 3, -6     }, { -24, 3,   -6 },                  }, -- N Upper Level C
    [17547449] = { { -56, 6, -6   }, { -68, 6,   -6 },                  }, -- AH C
    [17547445] = { { -68.3, 6, 3.4 }, { -56, 6, -4.1 },                 }, -- AH N
    [17547447] = { { -66.8, 6, -15.9 }, { -56, 6, -7.8 },               }, -- AH S
    [17547464] = { { -41, 8, -23  }, { -41, 8,  -16 },                  }, -- AH Stairs
    [17547466] = { { -54, 12, -22 }, { -61, 12, -31 },                  }, -- AH Lower Platform
    [17547508] = { { 12, 2,  40   }, { 12, 2,   68  },                  }, -- Palace Interior E
    [17547505] = { { -12, 2,  40  }, { -12, 2,   68 },                  }, -- Palace Interior W
    [17547522] = { { -12, 2,  72  }, { 12, 2,   72  },                  }, -- Palace Rear
    [17547540] = { { 0, 2,  96    }, { 0, 2,   76   },                  }, -- Near Maat
    [17547376] = { { 30, 0, -74   }, { 12, 0,  -74  },                  }, -- S Upper Level
    [17547558] = { { 2, 2,  72    }, { 10, 2,   72  },                  }, -- Palace Repop N #1
    [17547560] = { { -2, 2,  72   }, { -12, 2,   72 },                  }, -- Palace Repop N #2
    [17547562] = { { 12, 2,  68   }, { 12, 2,   56  },                  }, -- Palace Repop E #1
    [17547564] = { { 12, 2,  54   }, { 12, 2,   42  },                  }, -- Palace Repop E #2
    [17547570] = { { -12, 2,  68  }, { -12, 2,   56 },                  }, -- Palace Repop W #1
    [17547572] = { { -12, 2,  54  }, { -12, 2,   42 },                  }, -- Palace Repop W #2
    [17547568] = { { 12, 2,  40   }, { 5, 2,    40  },                  }, -- Palace Repop S #1
    [17547566] = { { -12, 2,  40  }, { -5, 2,    40 },                  }, -- Palace Repop S #2
    [17547344] = { { 18, 9, -36   }, { 11, 9,  -36  },                  }, -- 2nd Wave Fountain E Door
    [17547342] = { { -20, 9, -50  }, { -11, 9,  -50 },                  }, -- 2nd Wave Fountain W Door
    [17547340] = { { 4, 9, -64    }, { 4, 9,  -55   },                  }, -- 2nd Wave Fountain S Door
    [17547311] = { { 17, 9, -51   }, { 29, 9,  -51  },                  }, -- 3rd Wave Dyna Entrance N
    [17547314] = { { 21, 9, -54   }, { 42, 9,  -54  },                  }, -- 3rd Wave Dyna Entrance S
    [17547477] = { { -56, 6, -15  }, { -65, 6,  -15 },                  }, -- AH Repop S
    [17547480] = { { -56, 6, -12  }, { -56, 6,    0 },                  }, -- AH Repop C
    [17547475] = { { -41, 8, -23  }, { -41, 8,  -16 },                  }, -- AH Repop Stairs
    [17547680] = { { -26, 0, -36  }, { -34, 0,  -36 },                  }, -- Upper Level W Repop N
    [17547675] = { { -38, 0, -40  }, { -38, 0,  -62 },                  }, -- Upper Level W Repop W
    [17547671] = { { -28, 0, -62  }, { -28, 0,  -44 },                  }, -- Upper Level W Repop E
    [17547666] = { { -34, 0, -64  }, { -26, 0,  -64 },                  }, -- Upper Level W Repop S
    -- Cool looking walking patterns
    [17547594] = { { 5, 0, -76 }, { 12, 0, -76 }, }, -- Near Mega Boss #1
    [17547600] = { { 4, 0, -77 }, {  4, 0, -84 }, }, -- Near Mega Boss #2
    [17547606] = { { 3, 0, -76 }, { -4, 0, -76 }, }, -- Near Mega Boss #3
    [17547612] = { { 4, 0, -75 }, {  4, 0, -68 }, }, -- Near Mega Boss #4

    [17547694] = { { -31, 3, -9   }, { -34, 3,  -12 },                  }, -- Repop Upper Level N #1
    [17547697] = { { -27, 3, -9   }, { -24, 3,  -12 },                  }, -- Repop Upper Level N #2
    [17547701] = { { -27, 3, -5   }, { -24, 3,   -2 },                  }, -- Repop Upper Level N #3
    [17547704] = { { -31, 3, -5   }, { -34, 3,   -2 },                  }, -- Repop Upper Level N #4
    [17547716] = { {  -8, 3, -10  }, { -8, 3,   -2  },                  }, -- Repop Upper Level NC #1
    [17547712] = { { -12, 3, -2   }, { -12, 3,  -10 },                  }, -- Repop Upper Level NC #2
    [17547708] = { { -15, 3, -10  }, { -15, 3,   -2 },                  }, -- Repop Upper Level NC #3
    [17547369] = { { 32.9, 0, -44.9 }, { 32.9, 0, -70 },                },
}

xi.dynamis.timeExtension = xi.dynamis.timeExtension or { }
xi.dynamis.timeExtension[zoneID] =
{
    [xi.jeuno.mobs.GOBLIN_REPLICA_2]  =  30,
    [xi.jeuno.mobs.GOBLIN_REPLICA_4]  =  30,
    [xi.jeuno.mobs.GOBLIN_REPLICA_29] =  30,
    [xi.jeuno.mobs.GOBLIN_REPLICA_45] =  30,
    [xi.jeuno.mobs.GOBLIN_GOLEM]      =  30,
}
