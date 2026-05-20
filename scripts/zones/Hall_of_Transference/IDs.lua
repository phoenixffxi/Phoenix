-----------------------------------
-- Area: Hall_of_Transference
-----------------------------------
zones = zones or {}

zones[xi.zone.HALL_OF_TRANSFERENCE] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 6385, -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 6393, -- Obtained: <item>.
        GIL_OBTAINED                  = 6394, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396, -- Obtained key item: <keyitem>.
        CARRIED_OVER_POINTS           = 7004, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026, -- Your party is unable to participate because certain members' levels are restricted.
        NO_RESPONSE_OFFSET            = 7266, -- There is no response.
        DOOR_FIRMLY_SHUT              = 7267, -- The door is firmly shut.
        YOU_MUST_MOVE_CLOSER          = 7268, -- You must move closer to inspect the device.
    },
    mob =
    {
    },
    npc =
    {
    },
}

return zones[xi.zone.HALL_OF_TRANSFERENCE]
