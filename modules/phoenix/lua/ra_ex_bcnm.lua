-----------------------------------
-- Replaces Unique Items in BCNM battles with RA/EX versions
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('ra_ex_bcnm')

-- TODO: Bring these item listings upstream to item.lua
local phxItems = {
    PEACOCK_AMULET = 15515,
    SHIKAREE_RING  = 15551,
    VELOCIOUS_BELT = 15899,
}

local battlefieldInfo = {
    { bcnm = xi.battlefield.id.PETRIFYING_PAIR,             pool = 2, from = xi.item.LEAPING_BOOTS,   to = xi.item.BOUNDING_BOOTS  },
    { bcnm = xi.battlefield.id.BROTHERS_D_AURPHE,           pool = 2, from = xi.item.CROSS_COUNTERS,  to = xi.item.RETALIATORS     },
    { bcnm = xi.battlefield.id.BROTHERS_D_AURPHE,           pool = 5, from = xi.item.EURYTOS_BOW,     to = xi.item.VALIS_BOW       },
    { bcnm = xi.battlefield.id.DIVINE_PUNISHERS,            pool = 2, from = xi.item.OCHIUDOS_KOTE,   to = xi.item.OCHIMUSHA_KOTE  },
    { bcnm = xi.battlefield.id.DIVINE_PUNISHERS,            pool = 2, from = xi.item.FUMA_KYAHAN,     to = xi.item.SARUTOBI_KYAHAN },
    { bcnm = xi.battlefield.id.UP_IN_ARMS,                  pool = 8, from = xi.item.KRAKEN_CLUB,     to = xi.item.OCTAVE_CLUB     },
    { bcnm = xi.battlefield.id.DROPPING_LIKE_FLIES,         pool = 4, from = xi.item.EMPEROR_HAIRPIN, to = xi.item.EMPRESS_HAIRPIN },
    { bcnm = xi.battlefield.id.UNDER_OBSERVATION,           pool = 1, from = xi.item.PEACOCK_CHARM,   to = phxItems.PEACOCK_AMULET },
    { bcnm = xi.battlefield.id.EARLY_BIRD_CATCHES_THE_WYRM, pool = 4, from = xi.item.SPEED_BELT,      to = phxItems.VELOCIOUS_BELT },
    { bcnm = xi.battlefield.id.HORNS_OF_WAR,                pool = 4, from = xi.item.HEALING_STAFF,   to = xi.item.DRYAD_STAFF     },
    { bcnm = xi.battlefield.id.HILLS_ARE_ALIVE,             pool = 4, from = xi.item.STRIDER_BOOTS,   to = xi.item.TROTTER_BOOTS   },
    { bcnm = xi.battlefield.id.ROYAL_JELLY,                 pool = 2, from = xi.item.ARCHERS_RING,    to = phxItems.SHIKAREE_RING  },
}

m:addOverride('xi.server.onServerStart', function()
    super()

    -- Override BCNM loot drops with RA/EX loot versions
    for _, replacement in ipairs(battlefieldInfo) do
        local battlefield = xi.battlefield.contents[replacement.bcnm]
        if battlefield and battlefield.loot and battlefield.loot[replacement.pool] then
            for _, lootEntry in ipairs(battlefield.loot[replacement.pool]) do
                if lootEntry.itemId == replacement.from then
                    lootEntry.itemId = replacement.to
                    break
                end
            end
        end
    end
end)

return m
