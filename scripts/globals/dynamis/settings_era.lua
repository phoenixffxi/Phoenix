-----------------------------------
--    Dynamis Settings/Config    --
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- Core settings
xi.dynamis.settings =
{
    MIN_LEVEL               = 65,
    RESERVATION_TIMEOUT     = 180, -- seconds before auto-cleanup if no players enter
    REENTRY_DAYS            = 3,
    DEFAULT_TIME_LIMIT      = 3600, -- 60 minutes default
    TAVNAZIA_TIME_LIMIT     = 900, -- 15 minutes for Tavnazia
}

-- Messages for hourglass trade states
xi.dynamis.hourglassTradeResult =
{
    NEW        = 1,
    REGISTERED = 2,
    INVALID    = 3,
}

-- Dreamlands zones (CoP expansion)
xi.dynamis.dreamlandsZones =
{
    [xi.zone.DYNAMIS_BUBURIMU]  = true,
    [xi.zone.DYNAMIS_QUFIM]     = true,
    [xi.zone.DYNAMIS_VALKURM]   = true,
    [xi.zone.DYNAMIS_TAVNAZIA]  = true,
}

-- Status effects preserved when entering dreamlands
xi.dynamis.preservedStatusEffects =
{
    [xi.effect.RERAISE]        = true,
    [xi.effect.SIGIL]          = true,
    [xi.effect.SIGNET]         = true,
    [xi.effect.SANCTION]       = true,
    [xi.effect.SJ_RESTRICTION] = true,
    [xi.effect.FOOD]           = true,
    [xi.effect.BATTLEFIELD]    = true,
    [xi.effect.DEDICATION]     = true,
}
