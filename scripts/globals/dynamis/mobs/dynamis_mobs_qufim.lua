-----------------------------------
-- Dynamis-Qufim
-- Primary Source of Information: https://enedin.be/dyna/html/zone/quf.htm
-----------------------------------
local zoneID = xi.zone.DYNAMIS_QUFIM
xi = xi or { }
xi.dynamis = xi.dynamis or { }

-- Main spawn table for all 150 statues
xi.dynamis.spawnTable = xi.dynamis.spawnTable or { }
xi.dynamis.spawnTable[zoneID] =
{
    -- ID = { # to spawn, force spawn mobs }
    [16945213] = { 3, false }, -- (001-Q) | MNK, BLM, THF
    [16945209] = { 3, false }, -- (002-Q) | WAR, RDM, NIN
    [16945218] = { 3, false }, -- (003-Q) | PLD, WHM
    [16945222] = { 2, false }, -- (004-Q) | BST, RNG
    [16945226] = { 3, false }, -- (005-Q) | DRK, NIN, DRG
    [16945231] = { 5, false }, -- (006-Q) | BST, RDM, PLD, RNG, BRD
    [16945238] = { 4, false }, -- (007-Q) | WAR, WHM, BLM, SMN
    [16945206] = { 2, false }, -- (008-Y) | DRK, SAM
    [16945201] = { 4, false }, -- (009-Y) | WAR, RDM, RDM, RNG
    [16945198] = { 1, false }, -- (010-Y) | SMN
    [16945194] = { 2, false }, -- (011-Y) | NIN, BST
    [16945193] = { 0, false }, -- (012-Y) |
    [16945189] = { 3, false }, -- (013-Y) | MNK, THF, WHM
    [16945182] = { 1, false }, -- (014-Y) | DRG
    [16945185] = { 3, false }, -- (015-Y) | PLD, BLM, SAM
    [16945153] = { 3, false }, -- (016-O) | MNK, WHM, NIN
    [16945157] = { 1, false }, -- (017-O) | PLD
    [16945159] = { 2, false }, -- (018-O) | BRD, DRG
    [16945165] = { 2, false }, -- (019-O) | RDM, BLM
    [16945163] = { 1, false }, -- (020-O) | DRK
    [16945168] = { 3, false }, -- (021-O) | THF, SMN, MNK
    [16945173] = { 1, false }, -- (022-O) | DRK
    [16945175] = { 0, false }, -- (023-O) |
    [16945176] = { 4, false }, -- (024-O) | WAR, SAM, RNG, BST
    [16945247] = { 3, false }, -- (025-G(HP)) | THF, SMN, BRD
    [16945252] = { 3, false }, -- (026-G(MP)) | MNK, DRG, NIN
    [16945244] = { 1, false }, -- (027-G(HP)) | BST
    [16945257] = { 4, false }, -- (028-G) | WAR, PLD, RDM, BLM
    [16945267] = { 1, false }, -- (029-G) | DRG
    [16945270] = { 1, false }, -- (030-G) | SMN
    [16945262] = { 4, false }, -- (031-G) | SAM, DRK, RNG, WHM
    [16945284] = { 3, false }, -- (032-G) | THF, RDM, SMN
    [16945293] = { 3, false }, -- (033-G) | BRD, DRG, NIN
    [16945311] = { 0, false }, -- (034-G(HP)) |
    [16945312] = { 0, false }, -- (035-G(MP)) |
    [16945316] = { 3, false }, -- (036-G) | WAR, BLM, BST
    [16945325] = { 3, false }, -- (037-G) | DRK, RNG, WHM
    [16945345] = { 0, false }, -- (038-G) |
    [16945346] = { 0, false }, -- (039-G) |
    [16945217] = { 0, false }, -- (040-Sea Monk NM (Scolopendra)) |
    [16945344] = { 0, false }, -- (041-Giant Bat NM (Stringes)) |
    [16945310] = { 0, false }, -- (042-Golem NM (Suttung)) |
    [16945352] = { 0, false }, -- (043-Water Elemental) |
    [16945347] = { 0, false }, -- (044-Fire Elemental) |
    [16945351] = { 0, false }, -- (045-Thunder Elemental) |
    [16945349] = { 0, false }, -- (046-Air Elemental) |
    [16945353] = { 0, false }, -- (047-Light Elemental) |
    [16945348] = { 0, false }, -- (048-Ice Elemental) |
    [16945350] = { 0, false }, -- (049-Earth Elemental) |
    [16945354] = { 0, false }, -- (050-Dark Elemental) |
    [16945321] = { 3, false }, -- (051-Nightmare Stirge (×4)) |
    [16945329] = { 3, false }, -- (052-Nightmare Stirge (×4)) |
    [16945340] = { 3, false }, -- (053-Nightmare Stirge (×4)) |
    [16945273] = { 3, false }, -- (054-Nightmare Snoll (×4)) |
    [16945277] = { 3, false }, -- (055-Nightmare Snoll (×4)) |
    [16945289] = { 3, false }, -- (056-Nightmare Snoll (×4)) |
    [16945298] = { 3, false }, -- (057-Nightmare Snoll (×4)) |
    [16945281] = { 2, false }, -- (058-Nightmare Roc (×3)) |
    [16945302] = { 3, false }, -- (059-Nightmare Snoll (×4)) |
    [16945306] = { 3, false }, -- (060-Nightmare Snoll (×4)) |
    [16945313] = { 2, false }, -- (061-Nightmare Roc (×3)) |
    [16945333] = { 2, false }, -- (062-Nightmare Stirge (×3)) |
    [16945336] = { 3, false }, -- (063-Nightmare Stirge (×4)) |
    [16945355] = { 0, false }, -- (064-Gigas NM (Antaeus)(60)) |
    [16945357] = { 4, false }, -- (065-G) | THF, BRD, MNK, RNG
    [16945362] = { 4, false }, -- (066-G) | MNK, WHM, PLD, SMN
    [16945368] = { 5, false }, -- (067-G) | SAM, BLM, RDM, MNK, WAR
    [16945374] = { 4, false }, -- (068-G) | PLD, DRK, WHM, BST
    [16945380] = { 4, false }, -- (069-G) | THF, BRD, SAM, DRG
    [16945386] = { 4, false }, -- (070-G) | WAR, NIN, RDM, BLM
    [16945391] = { 0, false }, -- (071-G) |
    [16945394] = { 0, false }, -- (072-G(HP)) |
    [16945392] = { 0, false }, -- (073-G) |
    [16945393] = { 0, false }, -- (074-G) |
    [16945356] = { 0, false }, -- (075-G) |
    [16945533] = { 2, false }, -- (076-Nightmare Weapon (×3)) |
    [16945536] = { 2, false }, -- (077-Nightmare Weapon (×3)) |
    [16945539] = { 2, false }, -- (078-Nightmare Weapon (×3)) |
    [16945542] = { 2, false }, -- (079-Nightmare Weapon (×3)) |
    [16945545] = { 2, false }, -- (080-Nightmare Weapon (×3)) |
    [16945548] = { 2, false }, -- (081-Nightmare Weapon (×3)) |
    [16945551] = { 2, false }, -- (082-Nightmare Weapon (×3)) |
    [16945554] = { 2, false }, -- (083-Nightmare Weapon (×3)) |
    [16945557] = { 2, false }, -- (084-Nightmare Weapon (×3)) |
    [16945560] = { 2, false }, -- (085-Nightmare Weapon (×3)) |
    [16945421] = { 1, false }, -- (086-Nightmare Kraken (×2)) |
    [16945423] = { 1, false }, -- (087-Nightmare Kraken (×2)) |
    [16945425] = { 1, false }, -- (088-Nightmare Kraken (×2)) |
    [16945427] = { 1, false }, -- (089-Nightmare Kraken (×2)) |
    [16945429] = { 1, false }, -- (090-Nightmare Kraken (×2)) |
    [16945431] = { 1, false }, -- (091-Nightmare Kraken (×2)) |
    [16945433] = { 1, false }, -- (092-Nightmare Kraken (×2)) |
    [16945435] = { 1, false }, -- (093-Nightmare Kraken (×2)) |
    [16945437] = { 1, false }, -- (094-Nightmare Kraken (×2)) |
    [16945439] = { 1, false }, -- (095-Nightmare Kraken (×2)) |
    [16945441] = { 1, false }, -- (096-Nightmare Kraken (×2)) |
    [16945443] = { 1, false }, -- (097-Nightmare Kraken (×2)) |
    [16945445] = { 2, false }, -- (098-Nightmare Kraken (×3)) |
    [16945501] = { 3, false }, -- (099-Nightmare Tiger (×4)) |
    [16945505] = { 3, false }, -- (100-Nightmare Tiger (×4)) |
    [16945509] = { 3, false }, -- (101-Nightmare Tiger (×4)) |
    [16945513] = { 4, false }, -- (102-Nightmare Tiger (×5)) |
    [16945518] = { 4, false }, -- (103-Nightmare Tiger (×5)) |
    [16945523] = { 4, false }, -- (104-Nightmare Tiger (×5)) |
    [16945528] = { 4, false }, -- (105-Nightmare Tiger (×5)) |
    [16945477] = { 1, false }, -- (106-Nightmare Raptor (×2)) |
    [16945479] = { 1, false }, -- (107-Nightmare Raptor (×2)) |
    [16945481] = { 1, false }, -- (108-Nightmare Raptor (×2)) |
    [16945483] = { 1, false }, -- (109-Nightmare Raptor (×2)) |
    [16945485] = { 1, false }, -- (110-Nightmare Raptor (×2)) |
    [16945487] = { 1, false }, -- (111-Nightmare Raptor (×2)) |
    [16945489] = { 1, false }, -- (112-Nightmare Raptor (×2)) |
    [16945491] = { 1, false }, -- (113-Nightmare Raptor (×2)) |
    [16945493] = { 1, false }, -- (114-Nightmare Raptor (×2)) |
    [16945495] = { 1, false }, -- (115-Nightmare Raptor (×2)) |
    [16945497] = { 1, false }, -- (116-Nightmare Raptor (×2)) |
    [16945499] = { 1, false }, -- (117-Nightmare Raptor (×2)) |
    [16945395] = { 1, false }, -- (118-Nightmare Diremite (×2)) |
    [16945397] = { 1, false }, -- (119-Nightmare Diremite (×2)) |
    [16945399] = { 1, false }, -- (120-Nightmare Diremite (×2)) |
    [16945401] = { 1, false }, -- (121-Nightmare Diremite (×2)) |
    [16945403] = { 1, false }, -- (122-Nightmare Diremite (×2)) |
    [16945405] = { 1, false }, -- (123-Nightmare Diremite (×2)) |
    [16945407] = { 1, false }, -- (124-Nightmare Diremite (×2)) |
    [16945409] = { 1, false }, -- (125-Nightmare Diremite (×2)) |
    [16945411] = { 1, false }, -- (126-Nightmare Diremite (×2)) |
    [16945413] = { 1, false }, -- (127-Nightmare Diremite (×2)) |
    [16945415] = { 1, false }, -- (128-Nightmare Diremite (×2)) |
    [16945417] = { 1, false }, -- (129-Nightmare Diremite (×2)) |
    [16945419] = { 1, false }, -- (130-Nightmare Diremite (×2)) |
    [16945448] = { 2, false }, -- (131-Nightmare Gaylas (×3)) |
    [16945451] = { 2, false }, -- (132-Nightmare Gaylas (×3)) |
    [16945454] = { 2, false }, -- (133-Nightmare Gaylas (×3)) |
    [16945457] = { 3, false }, -- (134-Nightmare Gaylas (×5)) |
    [16945461] = { 3, false }, -- (135-Nightmare Gaylas (×5)) |
    [16945465] = { 3, false }, -- (136-Nightmare Gaylas (×5)) |
    [16945469] = { 3, false }, -- (137-Nightmare Gaylas (×5)) |
    [16945473] = { 3, false }, -- (138-Nightmare Gaylas (×5)) |
}

xi.dynamis.eyeColor = xi.dynamis.eyeColor or {}
xi.dynamis.eyeColor[zoneID] =
{
    [16945247] = xi.dynamis.eye.BLUE,  -- 025-G(HP)
    [16945252] = xi.dynamis.eye.GREEN, -- 026-G(MP)
    [16945244] = xi.dynamis.eye.BLUE,  -- 027-G(HP)
    [16945311] = xi.dynamis.eye.BLUE,  -- 034-G(HP)
    [16945312] = xi.dynamis.eye.GREEN, -- 035-G(MP)
    [16945394] = xi.dynamis.eye.BLUE,  -- 072-G(HP)
}

-- Wave spawn table for large waves
xi.dynamis.wave = xi.dynamis.wave or { }
xi.dynamis.wave[zoneID] =
{
    [1] = -- Spawns at start of the instance
    {
        16945213, -- (001-Q) Adamantking Effigy
        16945209, -- (002-Q) Adamantking Effigy
        16945218, -- (003-Q) Adamantking Effigy
        16945222, -- (004-Q) Adamantking Effigy
        16945226, -- (005-Q) Adamantking Effigy
        16945231, -- (006-Q) Adamantking Effigy
        16945238, -- (007-Q) Adamantking Effigy
        16945206, -- (008-Y) Manifest Icon
        16945201, -- (009-Y) Manifest Icon
        16945198, -- (010-Y) Manifest Icon
        16945194, -- (011-Y) Manifest Icon
        16945193, -- (012-Y) Manifest Icon
        16945189, -- (013-Y) Manifest Icon
        16945182, -- (014-Y) Manifest Icon
        16945185, -- (015-Y) Manifest Icon
        16945153, -- (016-O) Serjeant Tombstone
        16945157, -- (017-O) Serjeant Tombstone
        16945159, -- (018-O) Serjeant Tombstone
        16945165, -- (019-O) Serjeant Tombstone
        16945163, -- (020-O) Serjeant Tombstone
        16945168, -- (021-O) Serjeant Tombstone
        16945173, -- (022-O) Serjeant Tombstone
        16945175, -- (023-O) Serjeant Tombstone
        16945176, -- (024-O) Serjeant Tombstone
        16945247, -- (025-G) Goblin Replica
        16945252, -- (026-G) Goblin Replica
        16945244, -- (027-G) Goblin Replica
        16945257, -- (028-G) Goblin Replica
        16945267, -- (029-G) Goblin Replica
        16945270, -- (030-G) Goblin Replica
        16945262, -- (031-G) Goblin Replica
        16945284, -- (032-G) Goblin Replica
        16945293, -- (033-G) Goblin Replica
        16945311, -- (034-G) Goblin Replica
        16945312, -- (035-G) Goblin Replica
        16945316, -- (036-G) Goblin Replica
        16945325, -- (037-G) Goblin Replica
        16945345, -- (038-G) Goblin Replica
        16945346, -- (039-G) Goblin Replica
        16945321, -- ( 051 ) Nightmare Stirge (×4)
        16945329, -- ( 052 ) Nightmare Stirge (×4)
        16945340, -- ( 053 ) Nightmare Stirge (×4)
        16945333, -- ( 062 ) Nightmare Stirge (×3)
        16945336, -- ( 063 ) Nightmare Stirge (×4)
        16945281, -- ( 058 ) Nightmare Roc (×3)
        16945313, -- ( 061 ) Nightmare Roc (×3)
        16945273, -- ( 054 ) Nightmare Snoll (×4)
        16945277, -- ( 055 ) Nightmare Snoll (×4)
        16945289, -- ( 056 ) Nightmare Snoll (×4)
        16945298, -- ( 057 ) Nightmare Snoll (×4)
        16945302, -- ( 059 ) Nightmare Snoll (×4)
        16945306, -- ( 060 ) Nightmare Snoll (×4)
        16945352, -- ( 043 ) Water Elemental
        16945217, -- ( 040 ) Scolopendra
        16945347, -- ( 044 ) Fire Elemental
        16945351, -- ( 045 ) Thunder Elemental
        16945344, -- ( 041 ) Stringes
        16945349, -- ( 046 ) Air Elemental
        16945353, -- ( 047 ) Light Elemental
        16945348, -- ( 048 ) Ice Elemental
        16945355, -- ( 064 ) Antaeus
        16945350, -- ( 049 ) Earth Elemental
        16945354, -- ( 050 ) Dark Elemental
        16945310, -- ( 042 ) Suttung
    },
    [2] = -- Demon NMs spawn Animated Weapons, Vanguard Dragons, Ying, Yang
    {
        16945533, --  ( 076 ) Nightmare Weapon (×3)
        16945536, --  ( 077 ) Nightmare Weapon (×3)
        16945539, --  ( 078 ) Nightmare Weapon (×3)
        16945542, --  ( 079 ) Nightmare Weapon (×3)
        16945545, --  ( 080 ) Nightmare Weapon (×3)
        16945548, --  ( 081 ) Nightmare Weapon (×3)
        16945551, --  ( 082 ) Nightmare Weapon (×3)
        16945554, --  ( 083 ) Nightmare Weapon (×3)
        16945557, --  ( 084 ) Nightmare Weapon (×3)
        16945560, --  ( 085 ) Nightmare Weapon (×3)
        16945421, --  ( 086 ) Nightmare Kraken (×2)
        16945423, --  ( 087 ) Nightmare Kraken (×2)
        16945425, --  ( 088 ) Nightmare Kraken (×2)
        16945427, --  ( 089 ) Nightmare Kraken (×2)
        16945429, --  ( 090 ) Nightmare Kraken (×2)
        16945431, --  ( 091 ) Nightmare Kraken (×2)
        16945433, --  ( 092 ) Nightmare Kraken (×2)
        16945435, --  ( 093 ) Nightmare Kraken (×2)
        16945437, --  ( 094 ) Nightmare Kraken (×2)
        16945439, --  ( 095 ) Nightmare Kraken (×2)
        16945441, --  ( 096 ) Nightmare Kraken (×2)
        16945443, --  ( 097 ) Nightmare Kraken (×2)
        16945445, --  ( 098 ) Nightmare Kraken (×3)
        16945501, --  ( 099 ) Nightmare Tiger (×4)
        16945505, --  ( 100 ) Nightmare Tiger (×4)
        16945509, --  ( 101 ) Nightmare Tiger (×4)
        16945513, --  ( 102 ) Nightmare Tiger (×5)
        16945518, --  ( 103 ) Nightmare Tiger (×5)
        16945523, --  ( 104 ) Nightmare Tiger (×5)
        16945528, --  ( 105 ) Nightmare Tiger (×5)
        16945477, --  ( 106 ) Nightmare Raptor (×2)
        16945479, --  ( 107 ) Nightmare Raptor (×2)
        16945481, --  ( 108 ) Nightmare Raptor (×2)
        16945483, --  ( 109 ) Nightmare Raptor (×2)
        16945485, --  ( 110 ) Nightmare Raptor (×2)
        16945487, --  ( 111 ) Nightmare Raptor (×2)
        16945489, --  ( 112 ) Nightmare Raptor (×2)
        16945491, --  ( 113 ) Nightmare Raptor (×2)
        16945493, --  ( 114 ) Nightmare Raptor (×2)
        16945495, --  ( 115 ) Nightmare Raptor (×2)
        16945497, --  ( 116 ) Nightmare Raptor (×2)
        16945499, --  ( 117 ) Nightmare Raptor (×2)
        16945395, --  ( 118 ) Nightmare Diremite (×2)
        16945397, --  ( 119 ) Nightmare Diremite (×2)
        16945399, --  ( 120 ) Nightmare Diremite (×2)
        16945401, --  ( 121 ) Nightmare Diremite (×2)
        16945403, --  ( 122 ) Nightmare Diremite (×2)
        16945405, --  ( 123 ) Nightmare Diremite (×2)
        16945407, --  ( 124 ) Nightmare Diremite (×2)
        16945409, --  ( 125 ) Nightmare Diremite (×2)
        16945411, --  ( 126 ) Nightmare Diremite (×2)
        16945413, --  ( 127 ) Nightmare Diremite (×2)
        16945415, --  ( 128 ) Nightmare Diremite (×2)
        16945417, --  ( 129 ) Nightmare Diremite (×2)
        16945419, --  ( 130 ) Nightmare Diremite (×2)
        16945448, --  ( 131 ) Nightmare Gaylas (×3)
        16945451, --  ( 132 ) Nightmare Gaylas (×3)
        16945454, --  ( 133 ) Nightmare Gaylas (×3)
        16945457, --  ( 134 ) Nightmare Gaylas (×4)
        16945461, --  ( 135 ) Nightmare Gaylas (×4)
        16945465, --  ( 136 ) Nightmare Gaylas (×4)
        16945469, --  ( 137 ) Nightmare Gaylas (×4)
        16945473, --  ( 138 ) Nightmare Gaylas (×4)
        16945357, --  (065-G) Goblin Replica
        16945362, --  (066-G) Goblin Replica
        16945368, --  (067-G) Goblin Replica
        16945374, --  (068-G) Goblin Replica
        16945380, --  (069-G) Goblin Replica
        16945386, --  (070-G) Goblin Replica
        16945391, --  (071-G) Goblin Replica
        16945394, --  (072-G) Goblin Replica
        16945392, --  (073-G) Goblin Replica
        16945393, --  (074-G) Goblin Replica
        16945356, --  (075-G) Goblin Replica
    }
}

xi.qufim = xi.qufim or { }
xi.qufim.mobs =
{
    -- Boss
    ANTAEUS = 16945355,
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.qufim.mobs.ANTAEUS] = '[DYNA]MegaBossKilled',
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
xi.dynamis.paths = xi.dynamis.paths or { }
xi.dynamis.paths[zoneID] =
{
    [16945157] = { { 100.096, -19.006, 81.388   }, { 125.315, -19.587, 66.469   } },
    [16945159] = { { 96.384, -19.275, 84.665    }, { 127.777, -19.640, 104.362  } },
    [16945163] = { { 72.36, -19.378, 179.824    }, { 95.395, -19.286, 155.916   } },
    [16945165] = { { 59.059, -20.296, 186.073   }, { 87.490, -20.103, 194.525   } },
    [16945168] = { { -7.148, -19.919, 230.398   }, { 8.060, -19.879, 229.487    } },
    [16945173] = { { -6.718, -19.812, 227.313   }, { -5.018, -19.872, 208.7     } },
    [16945175] = { { 1.03, -19.841, 232.797     }, { -0.795, -19.881, 246.408   } },
    [16945193] = { { 117.383, -20.041, -4.789   }, { 99.870, -20.936, -17.368   } },
    [16945194] = { { 63.832, -19.244, 4.471     }, { 87.708, -19.722, -9.589    } },
    [16945198] = { { 27.086, -20.173, -22.998   }, { 56.203, -20.025, -27.859   } },
    [16945206] = { { -14.937, -19.854, -18.099  }, { 6.358, -19.633, -20.329    } },
    [16945209] = { { -198.662, -19.52, 12.847   }, { -219.813, -20.226, 20.597  } },
    [16945213] = { { -225.816, -21.024, 22.599  }, { -244.606, -20.030, 28.865  } },
    [16945218] = { { -205.97, -19.841, 93.721   }, { -205.724, -20.087, 123.403 } },
    [16945222] = { { -194.525, -19.892, 146.923 }, { -192.957, -20.153, 118.109 } },
    [16945226] = { { -205.681, -19.95, 128.47   }, { -205.390, -20.071, 163.653 } },
    [16945244] = { { -226.755, -19.48, 319.433  }, { -205.611, -19.921, 319.019 } },
    [16945247] = { { -73.475, -19.583, 254.906  }, { -72.792, -20.158, 244.898  } },
    [16945252] = { { -73.933, -19.269, 258.862  }, { -74.608, -19.818, 268.879  } },
    [16945325] = { { 196.059, 20.23, -169.882   }, { 176.161, 20.798, -205.509  } },
}

xi.dynamis.timeExtension = xi.dynamis.timeExtension or { }
xi.dynamis.timeExtension[zoneID] =
{
    [xi.qufim.mobs.ANTAEUS]  = 60, -- Boss
}
