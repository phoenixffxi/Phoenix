-----------------------------------
--                            Dynamis-Valk
--    Primary Source of Information: https://enedin.be/dyna/html/zone/val.htm
-----------------------------------
local zoneID = xi.zone.DYNAMIS_VALKURM
xi = xi or { }
xi.dynamis = xi.dynamis or { }

-- Main spawn table for all 150 statues
xi.dynamis.spawnTable = xi.dynamis.spawnTable or { }
xi.dynamis.spawnTable[zoneID] =
{
    -- ID = { # to spawn }
    [16937267] = { 3 }, -- (001-Y) | WHM, NIN, MNK
    [16937275] = { 3 }, -- (002-Y) | RDM, BST, DRK
    [16937271] = { 3 }, -- (003-Y) | PLD, BLM, SAM
    [16937263] = { 3 }, -- (004-Y) | WAR, RNG, RDM
    [16937005] = { 0 }, -- (005-Funguar NM (Fairy Ring)) |
    [16937292] = { 3 }, -- (006-G(HP)) | BRD, BST, DRK
    [16937288] = { 3 }, -- (007-G(MP)) | PLD, BLM, SAM
    [16937284] = { 3 }, -- (008-G) | WHM, NIN, MNK
    [16937280] = { 3 }, -- (009-G) | WAR, RNG, RDM
    [16937001] = { 2 }, -- (010-Flytrap NMs (Dragontrap ×3)) |
    [16937237] = { 3 }, -- (011-O) | PLD, BLM, SAM
    [16937229] = { 3 }, -- (012-O) | WAR, RNG, RDM
    [16937241] = { 3 }, -- (013-O) | BST, BRD, DRK
    [16937233] = { 3 }, -- (014-O) | WHM, NIN, MNK
    [16937000] = { 0 }, -- (015-Treant NM (Stcemqestcint)) |
    [16937250] = { 3 }, -- (016-Q(HP)) | WHM, NIN, MNK
    [16937246] = { 3 }, -- (017-Q) | WAR, RNG, RDM
    [16937254] = { 3 }, -- (018-Q) | PLD, BLM
    [16937258] = { 3 }, -- (019-Q) | BRD, BST, DRK
    [16937004] = { 0 }, -- (020-Goobbue NM (Nant'ina)) |
    [16937006] = { 0 }, -- (021-Nightmare Fly) |
    [16937007] = { 0 }, -- (022-Nightmare Fly) |
    [16937008] = { 0 }, -- (023-Nightmare Fly) |
    [16936961] = { 2 }, -- (024-NM (Cirrate Christelle)
    [16936982] = { 3 }, -- (025-G) | THF, DRG, SMN
    [16936976] = { 3 }, -- (026-Y) | THF, DRG, SMN
    [16936970] = { 3 }, -- (027-Q) | THF, DRG, SMN
    [16936964] = { 3 }, -- (028-O) | THF, DRG, SMN
    [16936991] = { 2 }, -- (029-Nightmare Manticore (×3)) |
    [16936994] = { 2 }, -- (030-Nightmare Hippogryph (×3)) |
    [16936988] = { 2 }, -- (031-Nightmare Sabotender (×3)) |
    [16936997] = { 2 }, -- (032-Nightmare Sheep (×3)) |
    [16937343] = { 3 }, -- (033-Y) | WAR, RNG, RDM
    [16937347] = { 3 }, -- (034-Y) | WHM, NIN, MNK
    [16937351] = { 3 }, -- (035-Y) | PLD, BLM, SAM
    [16937355] = { 3 }, -- (036-Y) | RDM, BST, DRK
    [16937360] = { 3 }, -- (037-Y) | THF, DRG, SMN
    [16937366] = { 3 }, -- (038-G) | WAR, RNG, RDM
    [16937370] = { 3 }, -- (039-G) | WHM, NIN, MNK
    [16937374] = { 3 }, -- (040-G) | PLD, BLM, SAM
    [16937378] = { 3 }, -- (041-G) | BRD, BST, DRK
    [16937383] = { 3 }, -- (042-G) | THF, DRG, SMN
    [16937297] = { 3 }, -- (043-O) | WAR, RNG, RDM
    [16937301] = { 3 }, -- (044-O) | WHM, NIN, MNK
    [16937305] = { 3 }, -- (045-O) | PLD, BLM, SAM
    [16937309] = { 3 }, -- (046-O) | BST, BRD, DRK
    [16937314] = { 3 }, -- (047-O) | THF, DRG, SMN
    [16937320] = { 3 }, -- (048-Q) | WAR, RNG, RDM
    [16937324] = { 3 }, -- (049-Q) | WHM, NIN, MNK
    [16937328] = { 3 }, -- (050-Q) | PLD, BLM
    [16937332] = { 3 }, -- (051-Q) | BRD, BST, DRK
    [16937337] = { 3 }, -- (052-Q) | THF, DRG, SMN
    [16937009] = { 2 }, -- (053-Nightmare Sabotender (×3)) |
    [16937012] = { 2 }, -- (054-Nightmare Sabotender (×3)) |
    [16937015] = { 2 }, -- (055-Nightmare Sabotender (×3)) |
    [16937018] = { 2 }, -- (056-Nightmare Sabotender (×3)) |
    [16937021] = { 2 }, -- (057-Nightmare Sabotender (×3)) |
    [16937024] = { 2 }, -- (058-Nightmare Sabotender (×3)) |
    [16937027] = { 2 }, -- (059-Nightmare Hippogryph (×3)) |
    [16937030] = { 2 }, -- (060-Nightmare Hippogryph (×3)) |
    [16937033] = { 2 }, -- (061-Nightmare Hippogryph (×3)) |
    [16937036] = { 2 }, -- (062-Nightmare Hippogryph (×3)) |
    [16937039] = { 2 }, -- (063-Nightmare Hippogryph (×3)) |
    [16937042] = { 2 }, -- (064-Nightmare Hippogryph (×3)) |
    [16937138] = { 2 }, -- (065-Nightmare Hippogryph (×3)) |
    [16937141] = { 2 }, -- (066-Nightmare Hippogryph (×3)) |
    [16937144] = { 2 }, -- (067-Nightmare Hippogryph (×3)) |
    [16937147] = { 2 }, -- (068-Nightmare Hippogryph (×3)) |
    [16937150] = { 2 }, -- (069-Nightmare Hippogryph (×3)) |
    [16937153] = { 2 }, -- (070-Nightmare Hippogryph (×3)) |
    [16937156] = { 2 }, -- (071-Nightmare Hippogryph (×3)) |
    [16937159] = { 2 }, -- (072-Nightmare Hippogryph (×3)) |
    [16937162] = { 2 }, -- (073-Nightmare Hippogryph (×3)) |
    [16937081] = { 2 }, -- (074-Nightmare Sabotender (×3)) |
    [16937084] = { 2 }, -- (075-Nightmare Sabotender (×3)) |
    [16937087] = { 2 }, -- (076-Nightmare Sabotender (×3)) |
    [16937090] = { 2 }, -- (077-Nightmare Sabotender (×3)) |
    [16937093] = { 2 }, -- (078-Nightmare Sabotender (×3)) |
    [16937096] = { 2 }, -- (079-Nightmare Sabotender (×3)) |
    [16937099] = { 2 }, -- (080-Nightmare Sabotender (×3)) |
    [16937102] = { 2 }, -- (081-Nightmare Sabotender (×3)) |
    [16937105] = { 2 }, -- (082-Nightmare Sabotender (×3)) |
    [16937193] = { 2 }, -- (083-Nightmare Sabotender (×3)) |
    [16937196] = { 2 }, -- (084-Nightmare Hippogryph (×3)) |
    [16937199] = { 2 }, -- (085-Nightmare Hippogryph (×3)) |
    [16937202] = { 2 }, -- (086-Nightmare Hippogryph (×3)) |
    [16937063] = { 2 }, -- (087-Nightmare Sheep (×3)) |
    [16937066] = { 2 }, -- (088-Nightmare Sheep (×3)) |
    [16937069] = { 2 }, -- (089-Nightmare Sheep (×3)) |
    [16937072] = { 2 }, -- (090-Nightmare Sheep (×3)) |
    [16937075] = { 2 }, -- (091-Nightmare Sheep (×3)) |
    [16937078] = { 2 }, -- (092-Nightmare Sheep (×3)) |
    [16937165] = { 1 }, -- (093-Nightmare Sheep (×2)) |
    [16937167] = { 1 }, -- (094-Nightmare Sheep (×2)) |
    [16937169] = { 1 }, -- (095-Nightmare Sheep (×2)) |
    [16937171] = { 1 }, -- (096-Nightmare Sheep (×2)) |
    [16937173] = { 1 }, -- (097-Nightmare Sheep (×2)) |
    [16937175] = { 1 }, -- (098-Nightmare Sheep (×2)) |
    [16937177] = { 1 }, -- (099-Nightmare Sheep (×2)) |
    [16937179] = { 1 }, -- (100-Nightmare Sheep (×2)) |
    [16937181] = { 1 }, -- (101-Nightmare Sheep (×2)) |
    [16937183] = { 1 }, -- (102-Nightmare Sheep (×2)) |
    [16937185] = { 1 }, -- (103-Nightmare Sheep (×2)) |
    [16937187] = { 1 }, -- (104-Nightmare Sheep (×2)) |
    [16937189] = { 1 }, -- (105-Nightmare Sheep (×2)) |
    [16937191] = { 1 }, -- (106-Nightmare Sheep (×2)) |
    [16937220] = { 2 }, -- (107-Nightmare Sheep (×3)) |
    [16937223] = { 2 }, -- (108-Nightmare Sheep (×3)) |
    [16937226] = { 2 }, -- (109-Nightmare Sheep (×3)) |
    [16937045] = { 2 }, -- (110-Nightmare Manticore (×3)) |
    [16937048] = { 2 }, -- (111-Nightmare Manticore (×3)) |
    [16937051] = { 2 }, -- (112-Nightmare Manticore (×3)) |
    [16937054] = { 2 }, -- (113-Nightmare Manticore (×3)) |
    [16937057] = { 2 }, -- (114-Nightmare Manticore (×3)) |
    [16937060] = { 2 }, -- (115-Nightmare Manticore (×3)) |
    [16937108] = { 2 }, -- (116-Nightmare Manticore (×3)) |
    [16937111] = { 2 }, -- (117-Nightmare Manticore (×3)) |
    [16937114] = { 2 }, -- (118-Nightmare Manticore (×3)) |
    [16937126] = { 3 }, -- (119-Nightmare Manticore (×4)) |
    [16937117] = { 2 }, -- (120-Nightmare Manticore (×3)) |
    [16937120] = { 2 }, -- (121-Nightmare Manticore (×3)) |
    [16937123] = { 2 }, -- (122-Nightmare Manticore (×3)) |
    [16937130] = { 3 }, -- (123-Nightmare Manticore (×4)) |
    [16937134] = { 3 }, -- (124-Nightmare Manticore (×4)) |
    [16937208] = { 2 }, -- (125-Nightmare Manticore (×3)) |
    [16937211] = { 2 }, -- (126-Nightmare Manticore (×3)) |
    [16937214] = { 2 }, -- (127-Nightmare Manticore (×3)) |
    [16937205] = { 2 }, -- (128-Nightmare Sabotender (×3)) |
    [16937217] = { 2 }, -- (129-Nightmare Sabotender (×3)) |
}

xi.dynamis.eyeColor = xi.dynamis.eyeColor or {}
xi.dynamis.eyeColor[zoneID] =
{
    [16937292] = xi.dynamis.eye.BLUE , -- (006-G(HP)) | BRD, BST, DRK
    [16937288] = xi.dynamis.eye.GREEN, -- (007-G(MP)) | PLD, BLM, SAM
    [16937250] = xi.dynamis.eye.BLUE , -- (016-Q(HP)) | WHM, NIN, MNK
}

-- Wave spawn table for large waves
xi.dynamis.wave = xi.dynamis.wave or { }
xi.dynamis.wave[zoneID] =
{
    [1] = -- Spawns at start of the instance
    {
        16937267, -- (001-Y) Manifest Icon
        16937275, -- (002-Y) Manifest Icon
        16937271, -- (003-Y) Manifest Icon
        16937263, -- (004-Y) Manifest Icon
        16937005, -- ( 005 ) Fairy Ring
        16937292, -- (006-G) Goblin Replica
        16937288, -- (007-G) Goblin Replica
        16937284, -- (008-G) Goblin Replica
        16937280, -- (009-G) Goblin Replica
        16937001, -- ( 010 ) Flytrap NMs
        16937237, -- (011-O) Serjeant Tombstone
        16937229, -- (012-O) Serjeant Tombstone
        16937241, -- (013-O) Serjeant Tombstone
        16937233, -- (014-O) Serjeant Tombstone
        16937000, -- ( 015 ) Stcemqestcint
        16937250, -- (016-Q) Adamantking Effigy
        16937246, -- (017-Q) Adamantking Effigy
        16937254, -- (018-Q) Adamantking Effigy
        16937258, -- (019-Q) Adamantking Effigy
        16937004, -- ( 020 ) Nant'ina
        16937006, -- ( 021 ) Nightmare Flys - Recover subjobs
        16937007, -- ( 022 ) Nightmare Flys - Recover subjobs
        16937008, -- ( 023 ) Nightmare Flys - Recover subjobs
        16936961, -- ( 024 ) Cirrate Christelle
        16937009, -- ( 053 ) Nightmare Sabotender (x3)
        16937012, -- ( 054 ) Nightmare Sabotender (x3)
        16937015, -- ( 055 ) Nightmare Sabotender (x3)
        16937018, -- ( 056 ) Nightmare Sabotender (x3)
        16937021, -- ( 057 ) Nightmare Sabotender (x3)
        16937024, -- ( 058 ) Nightmare Sabotender (x3)
        16937027, -- ( 059 ) Nightmare Hippogryph (×3)
        16937030, -- ( 060 ) Nightmare Hippogryph (×3)
        16937033, -- ( 061 ) Nightmare Hippogryph (×3)
        16937036, -- ( 062 ) Nightmare Hippogryph (×3)
        16937039, -- ( 063 ) Nightmare Hippogryph (×3)
        16937042, -- ( 064 ) Nightmare Hippogryph (×3)
        16937138, -- ( 065 ) Nightmare Hippogryph (×3)
        16937141, -- ( 066 ) Nightmare Hippogryph (×3)
        16937144, -- ( 067 ) Nightmare Hippogryph (×3)
        16937147, -- ( 068 ) Nightmare Hippogryph (×3)
        16937150, -- ( 069 ) Nightmare Hippogryph (×3)
        16937153, -- ( 070 ) Nightmare Hippogryph (×3)
        16937156, -- ( 071 ) Nightmare Hippogryph (×3)
        16937159, -- ( 072 ) Nightmare Hippogryph (×3)
        16937162, -- ( 073 ) Nightmare Hippogryph (×3)
        16937081, -- ( 074 ) Nightmare Sabotender (×3)
        16937084, -- ( 075 ) Nightmare Sabotender (×3)
        16937087, -- ( 076 ) Nightmare Sabotender (×3)
        16937090, -- ( 077 ) Nightmare Sabotender (×3)
        16937093, -- ( 078 ) Nightmare Sabotender (×3)
        16937096, -- ( 079 ) Nightmare Sabotender (×3)
        16937099, -- ( 080 ) Nightmare Sabotender (×3)
        16937102, -- ( 081 ) Nightmare Sabotender (×3)
        16937105, -- ( 082 ) Nightmare Sabotender (×3)
        16937193, -- ( 083 ) Nightmare Sabotender (×3)
        16937196, -- ( 084 ) Nightmare Hippogryph (×3)
        16937199, -- ( 085 ) Nightmare Hippogryph (×3)
        16937202, -- ( 086 ) Nightmare Hippogryph (×3)
        16937063, -- ( 087 ) Nightmare Sheep (×3)
        16937066, -- ( 088 ) Nightmare Sheep (×3)
        16937069, -- ( 089 ) Nightmare Sheep (×3)
        16937072, -- ( 090 ) Nightmare Sheep (×3)
        16937075, -- ( 091 ) Nightmare Sheep (×3)
        16937078, -- ( 092 ) Nightmare Sheep (×3)
        16937165, -- ( 093 ) Nightmare Sheep (×2)
        16937167, -- ( 094 ) Nightmare Sheep (×2)
        16937169, -- ( 095 ) Nightmare Sheep (×2)
        16937171, -- ( 096 ) Nightmare Sheep (×2)
        16937173, -- ( 097 ) Nightmare Sheep (×2)
        16937175, -- ( 098 ) Nightmare Sheep (×2)
        16937177, -- ( 099 ) Nightmare Sheep (×2)
        16937179, -- ( 100 ) Nightmare Sheep (×2)
        16937181, -- ( 101 ) Nightmare Sheep (×2)
        16937183, -- ( 102 ) Nightmare Sheep (×2)
        16937185, -- ( 103 ) Nightmare Sheep (×2)
        16937187, -- ( 104 ) Nightmare Sheep (×2)
        16937189, -- ( 105 ) Nightmare Sheep (×2)
        16937191, -- ( 106 ) Nightmare Sheep (×2)
        16937220, -- ( 107 ) Nightmare Sheep (×3)
        16937223, -- ( 108 ) Nightmare Sheep (×3)
        16937226, -- ( 109 ) Nightmare Sheep (×3)
        16937045, -- ( 110 ) Nightmare Manticore (×3)
        16937048, -- ( 111 ) Nightmare Manticore (×3)
        16937051, -- ( 112 ) Nightmare Manticore (×3)
        16937054, -- ( 113 ) Nightmare Manticore (×3)
        16937057, -- ( 114 ) Nightmare Manticore (×3)
        16937060, -- ( 115 ) Nightmare Manticore (×3)
        16937108, -- ( 116 ) Nightmare Manticore (×3)
        16937111, -- ( 117 ) Nightmare Manticore (×3)
        16937114, -- ( 118 ) Nightmare Manticore (×3)
        16937126, -- ( 119 ) Nightmare Manticore (×4)
        16937117, -- ( 120 ) Nightmare Manticore (×3)
        16937120, -- ( 121 ) Nightmare Manticore (×3)
        16937123, -- ( 122 ) Nightmare Manticore (×3)
        16937130, -- ( 123 ) Nightmare Manticore (×4)
        16937134, -- ( 124 ) Nightmare Manticore (×4)
        16937208, -- ( 125 ) Nightmare Manticore (×3)
        16937211, -- ( 126 ) Nightmare Manticore (×3)
        16937214, -- ( 127 ) Nightmare Manticore (×3)
        16937205, -- ( 128 ) Nightmare Sabotender (×3)
        16937217, -- ( 129 ) Nightmare Sabotender (×3)
    },
    [2] = -- Demon NMs spawn Animated Weapons, Vanguard Dragons, Ying, Yang
    {
        16936991, -- ( 029 ) Nightmare Manticore (×3)
        16936994, -- ( 030 ) Nightmare Hippogryph (×3)
        16936988, -- ( 031 ) Nightmare Sabotender (×3)
        16936997, -- ( 032 ) Nightmare Sheep (×3)
        16937343, -- (033-Y) Manifest Icon
        16937347, -- (034-Y) Manifest Icon
        16937351, -- (035-Y) Manifest Icon
        16937355, -- (036-Y) Manifest Icon
        16937360, -- (037-Y) Manifest Icon
        16937366, -- (038-G) Goblin Replica
        16937370, -- (039-G) Goblin Replica
        16937374, -- (040-G) Goblin Replica
        16937378, -- (041-G) Goblin Replica
        16937383, -- (042-G) Goblin Replica
        16937297, -- (043-O) Serjeant Tombstone
        16937301, -- (044-O) Serjeant Tombstone
        16937305, -- (045-O) Serjeant Tombstone
        16937309, -- (046-O) Serjeant Tombstone
        16937314, -- (047-O) Serjeant Tombstone
        16937320, -- (048-Q) Adamantking Effigy
        16937324, -- (049-Q) Adamantking Effigy
        16937328, -- (050-Q) Adamantking Effigy
        16937332, -- (051-Q) Adamantking Effigy
        16937337, -- (052-Q) Adamantking Effigy
    },
}

xi.valk = xi.valk or { }
xi.valk.mobs =
{
    -- Statues
    CIRRATE_CHRISTELLE = 16936961,
    NIGHTMARE_FLY_1    = 16937006,
    NIGHTMARE_FLY_2    = 16937007,
    NIGHTMARE_FLY_3    = 16937008,
}

-- Vars for death wave actions
xi.dynamis.deathVarByMob = xi.dynamis.deathVarByMob or {}
xi.dynamis.deathVarByMob[zoneID] =
{
    [xi.valk.mobs.CIRRATE_CHRISTELLE] = '[DYNA]CirrateChristelleKilled',
    [xi.valk.mobs.NIGHTMARE_FLY_1]    = '[DYNA]NightmareFly1Killed',
    [xi.valk.mobs.NIGHTMARE_FLY_2]    = '[DYNA]NightmareFly2Killed',
    [xi.valk.mobs.NIGHTMARE_FLY_3]    = '[DYNA]NightmareFly3Killed',
}

xi.dynamis.spawnCheck = xi.dynamis.spawnCheck or {}
xi.dynamis.spawnCheck[zoneID] =
{
    {
        -- megaboss spawns statues around it
        requiredVars    = { '[DYNA]CirrateChristelleKilled' },
        spawn           = xi.dynamis.wave[zoneID][2],
        spawnedVar      = '[DYNA]Wave2Spawned',
    },
}

xi.dynamis.stationary = xi.dynamis.stationary or { }
xi.dynamis.stationary[zoneID] =
{
    16936988,
    16936991,
    16936994,
    16936997,
}

--Specific Statues
xi.dynamis.aggro = xi.dynamis.aggro or { }
xi.dynamis.aggro[zoneID] =
{
    nonAggressive =
    {
        [xi.valk.mobs.CIRRATE_CHRISTELLE] = { 16936982, 16936976, 16936970, 16936964 },
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
    [16937229] = { { 796.009,  -7.72, 310.373  }, { 795.313, -7.913, 273.160    } },
    [16937233] = { { 795.862,  -7.34, 305.276  }, { 795.257, -8.034, 268.135    } },
    [16937237] = { { 803.902,  -7.92, 268.616  }, { 803.659, -0.8, 284.024      } },
    [16937241] = { { 803.809,  -8.005, 274.661 }, { 80.464, -7.251, 296.649     } },
    [16937246] = { { 640.000, 0.989, -143.000  }, { 639.528, 0, -197.641        } },
    [16937250] = { { 646.257, 0.112, -197.641  }, { 645, 0.683, -143.202        } },
    [16937254] = { { 740.798, -9.912, -185.072 }, { 739, -7.503, -213.696       } },
    [16937258] = { { 738.623, -7.402, -217.971 }, { 739.518, -9.687, -254.952   } },
    [16937280] = { { -580.277, -15.611, 216.310 }, { -580.828, -17.664, 188.838 } },
    [16937284] = { { -578.775, -17.678, 246.000 }, { -578.241, -15.522, 219.982 } },
    [16937288] = { { -560.678, -15.562, 347.579 }, { -560.856, -16, 316.226 } },
    [16937292] = { { -555.866, -16.012, 316.248 }, { -554.910, -15.661, 347.434 } },
    [16937297] = { { -2.000, 7.905, 124.000     }, { -6, -7.905, 118    } },
    [16937301] = { { 6.000, -7.902, 124.000     }, { 10, 7.701, 118     } },
    [16937305] = { { 2.000, -7.801, 128.000     }, { 2, -8.001, 116     } },
    [16937309] = { { 0.000, -7.701, 130.000     }, { -12, -8.068, 130   } },
    [16937314] = { { 16.000, -7.880, 130.000    }, { 4, 7.702, 130      } },
    [16937320] = { { 16.000, -8.126, 108.000    }, { 10,  -7.816, 102   } },
    [16937324] = { { 16.000, -7.897, 112.000    }, { 10, -7.701, 118    } },
    [16937328] = { { 8.000, -7.814, 110.000     }, { 20, -7.942, 110    } },
    [16937332] = { { 22.000, -7.105, 124.000    }, { 22, -7.910, 112    } },
    [16937337] = { { 22.000, -7.958, 108.000    }, { 22, -8, 96         } },
    [16937343] = { { 4.000, -7.216, 96.000      }, { 10, -7.818, 102    } },
    [16937347] = { { 0.000, -7.205, 96.000      }, { -6,  -7.322, 102   } },
    [16937351] = { { 2.000, -7.205, 104.000     }, { 2, -7.602, 92      } },
    [16937355] = { { 4.000, -7.707, 90.000      }, { 16, -8.313, 90     } },
    [16937360] = { { -12.000, -7.210, 90.000    }, { 0, -7.7, 90        } },
    [16937366] = { { -12.000, -8.125, 108.000   }, { -6, -7.322, 102    } },
    [16937370] = { { -12.000, -8.141, 112.000   }, { -6, -7.904, 118    } },
    [16937374] = { { -4.000, -7.700, 110.000    }, { -16, -7.879, 110   } },
    [16937378] = { { -18.000, -8.005, 96.000    }, { -18, -7.841, 108   } },
    [16937383] = { { -18.000, -7.628, 112.000   }, { -18, -7.483, 124   } },
}

xi.dynamis.timeExtension = xi.dynamis.timeExtension or { }
xi.dynamis.timeExtension[zoneID] =
{
    [xi.valk.mobs.CIRRATE_CHRISTELLE]  = 60, -- Boss
}
