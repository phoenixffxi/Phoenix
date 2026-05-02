-----------------------------------
-- Dynamis-Tavnazia
-- Primary Source of Information: https://enedin.be/dyna/html/zone/tav.htm
-----------------------------------
local zoneID = xi.zone.DYNAMIS_TAVNAZIA
xi = xi or { }
xi.dynamis = xi.dynamis or { }

-- Main spawn table for all 150 statues
xi.dynamis.spawnTable = xi.dynamis.spawnTable or { }
xi.dynamis.spawnTable[zoneID] =
{
    -- ID = { # to spawn, force spawn mobs }
    [16949249] = { 0, false }, -- (001-Nightmare Bugard(15)) |
    [16949250] = { 0, false }, -- (002-Nightmare Worm) |
    [16949255] = { 0, false }, -- (003-Nightmare Antlion(30)) |
    [16949269] = { 2, false }, -- (004-Nightmare Hornet (×3)) |
    [16949272] = { 2, false }, -- (005-Nightmare Hornet (×3)) |
    [16949293] = { 3, false }, -- (006-H) | WAR, RNG, RNG
    [16949302] = { 3, false }, -- (007-H) | DRK, BST, SMN
    [16949308] = { 5, false }, -- (008-H) | WHM, BLM, THF, PLD, DRG
    [16949297] = { 4, false }, -- (009-H) | MNK, BRD, SAM, NIN
    [16949275] = { 2, false }, -- (010-Nightmare Hornet (×3)) |
    [16949278] = { 2, false }, -- (011-Nightmare Hornet (×3)) |
    [16949315] = { 3, false }, -- (012-H) | WHM, BLM, RNG
    [16949326] = { 4, false }, -- (013-H) | WAR, MNK, THF, SAM
    [16949331] = { 5, false }, -- (014-H) | PLD, DRK, BRD, RNG, NIN
    [16949319] = { 3, false }, -- (015-H) | BST, DRG, SMN
    [16949381] = { 2, false }, -- (016-Nightmare Leech (×2)) |
    [16949384] = { 2, false }, -- (017-Nightmare Leech (×2)) |
    [16949387] = { 1, false }, -- (018-Nightmare Leech (×3)) |
    [16949389] = { 1, false }, -- (019-Nightmare Leech (×3)) |
    [16949401] = { 2, false }, -- (020-Nightmare Leech (×2)) |
    [16949404] = { 2, false }, -- (021-Nightmare Leech (×2)) |
    [16949407] = { 1, false }, -- (022-Nightmare Leech (×3)) |
    [16949409] = { 1, false }, -- (023-Nightmare Leech (×3)) |
    [16949421] = { 2, false }, -- (024-Nightmare Makara (×2)) |
    [16949424] = { 2, false }, -- (025-Nightmare Makara (×2)) |
    [16949427] = { 1, false }, -- (026-Nightmare Makara (×3)) |
    [16949429] = { 1, false }, -- (027-Nightmare Makara (×3)) |
    [16949441] = { 2, false }, -- (028-Nightmare Makara (×2)) |
    [16949444] = { 2, false }, -- (029-Nightmare Makara (×2)) |
    [16949447] = { 1, false }, -- (030-Nightmare Makara (×3)) |
    [16949449] = { 1, false }, -- (031-Nightmare Makara (×3)) |
    [16949281] = { 2, false }, -- (032-Nightmare Hornet (×3)) |
    [16949284] = { 2, false }, -- (033-Nightmare Hornet (×3)) |
    [16949337] = { 4, false }, -- (034-H) | MNK, PLD, RNG, SMN
    [16949348] = { 3, false }, -- (035-H) | BLM, DRK, NIN
    [16949352] = { 4, false }, -- (036-H) | BST, BRD, SAM, DRG
    [16949343] = { 4, false }, -- (037-H) | WAR, WHM, RNG, THF
    [16949287] = { 2, false }, -- (038-Nightmare Hornet (×3)) |
    [16949290] = { 2, false }, -- (039-Nightmare Hornet (×3)) |
    [16949359] = { 4, false }, -- (040-H) | MNK, WHM, BRD, NIN
    [16949369] = { 4, false }, -- (041-H) | WAR, PLD, DRK, SAM
    [16949374] = { 4, false }, -- (042-H) | RNG, THF, BST, DRG
    [16949364] = { 3, false }, -- (043-H) | BLM, RNG, SMN
    [16949391] = { 2, false }, -- (044-Nightmare Leech (×2)) |
    [16949394] = { 2, false }, -- (045-Nightmare Leech (×2)) |
    [16949397] = { 1, false }, -- (046-Nightmare Leech (×3)) |
    [16949399] = { 1, false }, -- (047-Nightmare Leech (×3)) |
    [16949411] = { 2, false }, -- (048-Nightmare Leech (×2)) |
    [16949414] = { 2, false }, -- (049-Nightmare Leech (×2)) |
    [16949417] = { 1, false }, -- (050-Nightmare Leech (×3)) |
    [16949419] = { 1, false }, -- (051-Nightmare Leech (×3)) |
    [16949431] = { 2, false }, -- (052-Nightmare Makara (×2)) |
    [16949434] = { 2, false }, -- (053-Nightmare Makara (×2)) |
    [16949437] = { 1, false }, -- (054-Nightmare Makara (×3)) |
    [16949439] = { 1, false }, -- (055-Nightmare Makara (×3)) |
    [16949451] = { 2, false }, -- (056-Nightmare Makara (×2)) |
    [16949454] = { 2, false }, -- (057-Nightmare Makara (×2)) |
    [16949457] = { 1, false }, -- (058-Nightmare Makara (×3)) |
    [16949459] = { 1, false }, -- (059-Nightmare Makara (×3)) |
    [16949461] = { 2, false }, -- (060-Nightmare Hornet (×3)) |
    [16949464] = { 2, false }, -- (061-Nightmare Hornet (×3)) |
    [16949485] = { 3, false }, -- (062-D) | WAR, THF
    [16949495] = { 3, false }, -- (063-D) | RNG, SAM
    [16949489] = { 4, false }, -- (064-D) | BLM, BST, NIN
    [16949503] = { 4, false }, -- (065-D) | PLD, DRK, SMN
    [16949509] = { 4, false }, -- (066-D) | RNG, BRD, DRG
    [16949499] = { 3, false }, -- (067-D) | MNK, WHM
    [16949467] = { 2, false }, -- (068-Nightmare Hornet (×3)) |
    [16949470] = { 2, false }, -- (069-Nightmare Hornet (×3)) |
    [16949515] = { 4, false }, -- (070-D) | BLM, PLD, BRD, SMN
    [16949525] = { 3, false }, -- (071-D) | WAR, NIN, DRG
    [16949521] = { 3, false }, -- (072-D) |
    [16949534] = { 4, false }, -- (073-D) | WHM, THF, BST, SAM
    [16949540] = { 4, false }, -- (074-D) | MNK
    [16949530] = { 3, false }, -- (075-D) | RNG, DRK, RNG
    [16949611] = { 2, false }, -- (076-Nightmare Cluster (×3)) |
    [16949614] = { 2, false }, -- (077-Nightmare Cluster (×3)) |
    [16949641] = { 2, false }, -- (078-Nightmare Cluster (×3)) |
    [16949644] = { 2, false }, -- (079-Nightmare Cluster (×3)) |
    [16949623] = { 2, false }, -- (080-Nightmare Cluster (×3)) |
    [16949626] = { 2, false }, -- (081-Nightmare Cluster (×3)) |
    [16949629] = { 2, false }, -- (082-Nightmare Cluster (×3)) |
    [16949473] = { 2, false }, -- (083-Nightmare Hornet (×3)) |
    [16949476] = { 2, false }, -- (084-Nightmare Hornet (×3)) |
    [16949545] = { 4, false }, -- (085-D) | WAR, THF
    [16949557] = { 4, false }, -- (086-D) | RNG, SAM
    [16949550] = { 5, false }, -- (087-D) | BLM, BST, NIN
    [16949567] = { 5, false }, -- (088-D) | PLD, DRK, SMN
    [16949574] = { 5, false }, -- (089-D) | RNG, BRD, DRG
    [16949562] = { 4, false }, -- (090-D) | MNK, WHM
    [16949479] = { 2, false }, -- (091-Nightmare Hornet (×3)) |
    [16949482] = { 2, false }, -- (092-Nightmare Hornet (×3)) |
    [16949581] = { 3, false }, -- (093-D) |
    [16949592] = { 4, false }, -- (094-D) | WAR, WHM, BRD, RNG
    [16949585] = { 3, false }, -- (095-D) | BST, DRG, SMN
    [16949600] = { 3, false }, -- (096-D) | THF, SAM
    [16949604] = { 6, false }, -- (097-D) | MNK, RNG, PLD, DRK, NIN
    [16949597] = { 2, false }, -- (098-D) | BLM
    [16949617] = { 2, false }, -- (099-Nightmare Cluster (×3)) |
    [16949620] = { 2, false }, -- (100-Nightmare Cluster (×3)) |
    [16949647] = { 2, false }, -- (101-Nightmare Cluster (×3)) |
    [16949650] = { 2, false }, -- (102-Nightmare Cluster (×3)) |
    [16949632] = { 2, false }, -- (103-Nightmare Cluster (×3)) |
    [16949635] = { 2, false }, -- (104-Nightmare Cluster (×3)) |
    [16949638] = { 2, false }, -- (105-Nightmare Cluster (×3)) |
    [16949259] = { 0, false }, -- (106-Umbral Diabolos) |
    [16949260] = { 0, false }, -- (107-Umbral Diabolos) |
    [16949261] = { 0, false }, -- (108-Umbral Diabolos) |
    [16949262] = { 0, false }, -- (109-Umbral Diabolos) |
    [16949266] = { 0, false }, -- (110-Diabolos Club) |
    [16949264] = { 0, false }, -- (111-Diabolos Heart) |
    [16949263] = { 0, false }, -- (112-Diabolos Spade) |
    [16949265] = { 0, false }, -- (113-Diabolos Diamond) |
    [16949251] = { 0, false }, -- (Extra ID?) |
    [16949252] = { 0, false }, -- (Extra ID?) |
    [16949253] = { 0, false }, -- (Extra ID?) |
    [16949254] = { 0, false }, -- (Extra ID?) |
    [16949256] = { 0, false }, -- (Extra ID?) |
    [16949257] = { 0, false }, -- (Extra ID?) |
    [16949258] = { 0, false }, -- (Extra ID?) |
}

xi.dynamis.eyeColor = xi.dynamis.eyeColor or {}
xi.dynamis.eyeColor[zoneID] =
{
    -- Nothing
}

-- Wave spawn table for large waves
xi.dynamis.wave = xi.dynamis.wave or { }
xi.dynamis.wave[zoneID] =
{
    [1] = -- Spawns at start of the instance
    {
        16949249, -- ( 001 )-Nightmare Bugard(15)
        16949269, -- ( 004 )-Nightmare Hornet (×3)
        16949272, -- ( 005 )-Nightmare Hornet (×3)
        16949293, -- (006-H) Vanguard Eye
        16949302, -- (007-H) Vanguard Eye
        16949308, -- (008-H) Vanguard Eye
        16949297, -- (009-H) Vanguard Eye
        16949275, -- ( 010 )-Nightmare Hornet (×3)
        16949278, -- ( 011 )-Nightmare Hornet (×3)
        16949315, -- (012-H) Vanguard Eye
        16949326, -- (013-H) Vanguard Eye
        16949331, -- (014-H) Vanguard Eye
        16949319, -- (015-H) Vanguard Eye
        16949381, -- ( 016 )-Nightmare Leech (×2)
        16949384, -- ( 017 )-Nightmare Leech (×2)
        16949387, -- ( 018 )-Nightmare Leech (×3)
        16949389, -- ( 019 )-Nightmare Leech (×3)
        16949401, -- ( 020 )-Nightmare Leech (×2)
        16949404, -- ( 021 )-Nightmare Leech (×2)
        16949407, -- ( 022 )-Nightmare Leech (×3)
        16949409, -- ( 023 )-Nightmare Leech (×3)
        16949421, -- ( 024 )-Nightmare Makara (×2)
        16949424, -- ( 025 )-Nightmare Makara (×2)
        16949427, -- ( 026 )-Nightmare Makara (×3)
        16949429, -- ( 027 )-Nightmare Makara (×3)
        16949441, -- ( 028 )-Nightmare Makara (×2)
        16949444, -- ( 029 )-Nightmare Makara (×2)
        16949447, -- ( 030 )-Nightmare Makara (×3)
        16949449, -- ( 031 )-Nightmare Makara (×3)
        16949461, -- ( 060 )-Nightmare Hornet (×3)
        16949464, -- ( 061 )-Nightmare Hornet (×3)
        16949485, -- ( 062-D ) Vanguard Eye
        16949495, -- ( 063-D ) Vanguard Eye
        16949489, -- ( 064-D ) Vanguard Eye
        16949503, -- ( 065-D ) Vanguard Eye
        16949509, -- ( 066-D ) Vanguard Eye
        16949499, -- ( 067-D ) Vanguard Eye
        16949467, -- ( 068 )-Nightmare Hornet (×3)
        16949470, -- ( 069 )-Nightmare Hornet (×3)
        16949515, -- ( 070-D ) Vanguard Eye
        16949525, -- ( 071-D ) Vanguard Eye
        16949521, -- ( 072-D ) Vanguard Eye
        16949534, -- ( 073-D ) Vanguard Eye
        16949540, -- ( 074-D ) Vanguard Eye
        16949530, -- ( 075-D ) Vanguard Eye
        16949611, -- ( 076 )-Nightmare Cluster (×3)
        16949614, -- ( 077 )-Nightmare Cluster (×3)
        16949641, -- ( 078 )-Nightmare Cluster (×3)
        16949644, -- ( 079 )-Nightmare Cluster (×3)
        16949623, -- ( 080 )-Nightmare Cluster (×3)
        16949626, -- ( 081 )-Nightmare Cluster (×3)
        16949629, -- ( 082 )-Nightmare Cluster (×3)
        16949259, -- ( 106 )-Umbral Diabolos
        16949260, -- ( 107 )-Umbral Diabolos
        16949261, -- ( 108 )-Umbral Diabolos
        16949262, -- ( 109 )-Umbral Diabolos
    },
    [2] = -- Spawns on 1st QM click
    {
        16949281, -- ( 032 )-Nightmare Hornet (×3)
        16949284, -- ( 033 )-Nightmare Hornet (×3)
        16949337, -- ( 034-H )-Vanguard Eye
        16949348, -- ( 035-H )-Vanguard Eye
        16949352, -- ( 036-H )-Vanguard Eye
        16949343, -- ( 037-H )-Vanguard Eye
        16949287, -- ( 038 )-Nightmare Hornet (×3)
        16949290, -- ( 039 )-Nightmare Hornet (×3)
        16949359, -- ( 040-H )-Vanguard Eye
        16949369, -- ( 041-H )-Vanguard Eye
        16949374, -- ( 042-H )-Vanguard Eye
        16949364, -- ( 043-H )-Vanguard Eye
        16949391, -- ( 044 )-Nightmare Leech (×2)
        16949394, -- ( 045 )-Nightmare Leech (×2)
        16949397, -- ( 046 )-Nightmare Leech (×3)
        16949399, -- ( 047 )-Nightmare Leech (×3)
        16949411, -- ( 048 )-Nightmare Leech (×2)
        16949414, -- ( 049 )-Nightmare Leech (×2)
        16949417, -- ( 050 )-Nightmare Leech (×3)
        16949419, -- ( 051 )-Nightmare Leech (×3)
        16949431, -- ( 052 )-Nightmare Makara (×2)
        16949434, -- ( 053 )-Nightmare Makara (×2)
        16949437, -- ( 054 )-Nightmare Makara (×3)
        16949439, -- ( 055 )-Nightmare Makara (×3)
        16949451, -- ( 056 )-Nightmare Makara (×2)
        16949454, -- ( 057 )-Nightmare Makara (×2)
        16949457, -- ( 058 )-Nightmare Makara (×3)
        16949459, -- ( 059 )-Nightmare Makara (×3)
    },
    [3] = -- Spawns on 2nd QM click
    {
        16949473, -- ( 083 )-Nightmare Hornet (×3)
        16949476, -- ( 084 )-Nightmare Hornet (×3)
        16949545, -- ( 085-D ) Vanguard Eye
        16949557, -- ( 086-D ) Vanguard Eye
        16949550, -- ( 087-D ) Vanguard Eye
        16949567, -- ( 088-D ) Vanguard Eye
        16949574, -- ( 089-D ) Vanguard Eye
        16949562, -- ( 090-D ) Vanguard Eye
        16949479, -- ( 091 )-Nightmare Hornet (×3)
        16949482, -- ( 092 )-Nightmare Hornet (×3)
        16949581, -- ( 093-D ) Vanguard Eye
        16949592, -- ( 094-D ) Vanguard Eye
        16949585, -- ( 095-D ) Vanguard Eye
        16949600, -- ( 096-D ) Vanguard Eye
        16949604, -- ( 097-D ) Vanguard Eye
        16949597, -- ( 098-D ) Vanguard Eye
        16949617, -- ( 099 )-Nightmare Cluster (×3)
        16949620, -- ( 100 )-Nightmare Cluster (×3)
        16949647, -- ( 101 )-Nightmare Cluster (×3)
        16949650, -- ( 102 )-Nightmare Cluster (×3)
        16949632, -- ( 103 )-Nightmare Cluster (×3)
        16949635, -- ( 104 )-Nightmare Cluster (×3)
        16949638, -- ( 105 )-Nightmare Cluster (×3)
    }
}

xi.tav = xi.tav or { }
xi.tav.mobs =
{
    -- Boss
    NIGHTMARE_BUGARD  = 16949249,
    NIGHTMARE_ANTLION = 16949255,
    NIGHTMARE_WORM    = 16949250,
    -- Vanguard Eyes
    VANGUARD_EYE_9  = 16949297,
    VANGUARD_EYE_15 = 16949319,
    VANGUARD_EYE_67 = 16949499,
    VANGUARD_EYE_75 = 16949530,
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.tav.mobs.NIGHTMARE_BUGARD]  = '[DYNA]BugardKilled',
    [xi.tav.mobs.NIGHTMARE_ANTLION] = '[DYNA]AntlionKilled',
    [xi.tav.mobs.NIGHTMARE_WORM]    = '[DYNA]WormKilled',
    [xi.tav.mobs.VANGUARD_EYE_9]    = '[DYNA]VE9Killed',
    [xi.tav.mobs.VANGUARD_EYE_15]   = '[DYNA]VE15Killed',
    [xi.tav.mobs.VANGUARD_EYE_67]   = '[DYNA]VE67Killed',
    [xi.tav.mobs.VANGUARD_EYE_75]   = '[DYNA]VE75Killed',
}

-- xi.dynamis.spawnCheck = xi.dynamis.spawnCheck or {}
-- xi.dynamis.spawnCheck[zoneID] =
-- {
-- }
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
xi.dynamis.paths = xi.dynamis.paths or { }
xi.dynamis.paths[zoneID] =
{
    [16949269] = { { -26.358, -21.970,  26.411 }, { -40.109,  22.232,  40.212 } },
    [16949272] = { { -48.085, -22.051,  43.469 }, { -63.012, -22.030,  43.799 } },
    [16949275] = { { -27.114, -22.075, -26.941 }, { -37.896, -22.169, -37.871 } },
    [16949278] = { { -44.921, -22.026, -43.388 }, { -63.904, -22.028, -43.865 } },
    [16949381] = { { -75.824, -20.000,  65.710 }, { -88.177, -19.960,  66.990 } },
    [16949384] = { { -88.107, -19.820,  64.570 }, { -88.060, -15.290,  49.790 } },
    [16949387] = { { -88.119, -14.540,  47.740 }, { -87.790, -14.000,  36.530 } },
    [16949389] = { { -86.376, -13.760,  36.240 }, { -77.850, -10.890,  28.930 } },
    [16949401] = { { -74.000, -11.140,  16.160 }, { -73.760, -11.080,   8.890 } },
    [16949404] = { { -74.090, -11.090,   7.780 }, { -74.100, -11.910,   2.040 } },
    [16949407] = { { -87.310, -12.640,   8.620 }, { -87.680, -13.360,   1.440 } },
    [16949409] = { { -89.580, -12.710,   6.760 }, { -79.120, -11.340,   7.710 } },
    [16949421] = { { -88.660, -20.060, -70.820 }, { -77.180, -20.000, -68.710 } },
    [16949424] = { { -89.360, -20.120, -69.050 }, { -88.007, -15.330, -49.930 } },
    [16949427] = { { -87.690, -14.420, -47.040 }, { -86.760, -13.870, -36.380 } },
    [16949429] = { { -84.038, -12.900, -34.330 }, { -74.280, -10.790, -23.860 } },
    [16949441] = { { -73.840, -10.860, -22.940 }, { -73.969, -11.141, -13.271 } },
    [16949444] = { { -74.120, -11.120,  -9.120 }, { -73.910, -11.860,  -1.560 } },
    [16949447] = { { -87.100, -12.550,  -8.090 }, { -87.680, -13.360,  -1.240 } },
    [16949449] = { { -90.970, -13.040,  -7.250 }, { -78.840, -11.230,  -7.360 } },
    [16949281] = { { -26.358, -21.970,  26.411 }, { -40.109,  22.232,  40.212 } },
    [16949284] = { { -48.085, -22.051,  43.469 }, { -63.012, -22.030,  43.799 } },
    [16949287] = { { -27.114, -22.075, -26.941 }, { -37.896, -22.169, -37.871 } },
    [16949290] = { { -44.921, -22.026, -43.388 }, { -63.904, -22.028, -43.865 } },
    [16949391] = { { -75.824, -20.000,  65.710 }, { -88.177, -19.960,  66.990 } },
    [16949394] = { { -88.107, -19.820,  64.570 }, { -88.060, -15.290,  49.790 } },
    [16949397] = { { -88.119, -14.540,  47.740 }, { -87.790, -14.000,  36.530 } },
    [16949399] = { { -86.376, -13.760,  36.240 }, { -77.850, -10.890,  28.930 } },
    [16949451] = { { -73.840, -10.860, -22.940 }, { -73.969, -11.141, -13.271 } },
    [16949454] = { { -74.120, -11.120,  -9.120 }, { -73.910, -11.860,  -1.560 } },
    [16949457] = { { -87.100, -12.550,  -8.090 }, { -87.680, -13.360,  -1.240 } },
    [16949459] = { { -90.970, -13.040,  -7.250 }, { -78.840, -11.230,  -7.360 } },
    [16949461] = { {  26.645, -36.030,  26.800 }, {  40.232, -36.240,  40.010 } },
    [16949464] = { {  46.020, -36.010,  43.650 }, {  61.500, -36.010,  43.960 } },
    [16949467] = { {  26.180, -35.920, -25.990 }, {  40.670, -36.200, -40.540 } },
    [16949470] = { {  47.430, -36.060, -43.240 }, {  62.500, -36.010, -43.900 } },
    [16949611] = { {  86.830, -33.930,  65.520 }, {  87.790, -28.300,  46.230 } },
    [16949614] = { {  88.140, -28.000,  39.440 }, {  73.930, -24.820,  24.320 } },
    [16949641] = { {  87.680, -33.720, -60.550 }, {  88.100, -28.000, -42.120 } },
    [16949644] = { {  87.560, -28.000, -37.520 }, {  74.640, -24.830, -24.880 } },
    [16949623] = { {  73.950, -25.050,  21.390 }, {  73.930, -24.790,   7.950 } },
    [16949626] = { {  70.230, -25.000,   4.810 }, {  70.230, -25.000,  -4.230 } },
    [16949629] = { {  74.000, -25.000, -21.020 }, {  73.810, -24.790,  -6.640 } },
    [16949473] = { {  26.645, -36.030,  26.800 }, {  40.232, -36.240,  40.010 } },
    [16949476] = { {  46.020, -36.010,  43.650 }, {  61.500, -36.010,  43.960 } },
    [16949479] = { {  26.180, -35.920, -25.990 }, {  40.670, -36.200, -40.540 } },
    [16949482] = { {  47.430, -36.060, -43.240 }, {  62.500, -36.010, -43.900 } },
}

xi.dynamis.timeExtension = xi.dynamis.timeExtension or { }
xi.dynamis.timeExtension[zoneID] =
{
    [xi.tav.mobs.NIGHTMARE_BUGARD]  = 15,
    [xi.tav.mobs.NIGHTMARE_ANTLION] = 30,
}
