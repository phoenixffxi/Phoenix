-----------------------------------
-- Area: Nashmau
-----------------------------------
zones = zones or {}

zones[xi.zone.NASHMAU] =
{
    text =
    {
        ASSIST_CHANNEL                = 6380,  -- You will be able to use the Assist Channel until #/#/# at #:# (JST).
        ITEM_CANNOT_BE_OBTAINED       = 6385,  -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_CANNOT_BE_OBTAINEDX      = 6389,  -- You cannot obtain the <item>. Try trading again after sorting your inventory.
        ITEM_OBTAINED                 = 6393,  -- Obtained: <item>.
        GIL_OBTAINED                  = 6394,  -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6396,  -- Obtained key item: <keyitem>.
        ITEM_OBTAINEDX                = 6402,  -- You obtain <number> <item>!
        CARRIED_OVER_POINTS           = 7004,  -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7005,  -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7006,  -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7026,  -- Your party is unable to participate because certain members' levels are restricted.
        FISHING_MESSAGE_OFFSET        = 7067,  -- You can't fish here.
        HOMEPOINT_SET                 = 7329,  -- Home point set!
        NOMAD_MOOGLE_DIALOG           = 7349,  -- I'm a traveling moogle, kupo. I help adventurers in the Outlands access items they have stored in a Mog House elsewhere, kupo.
        REGIME_CANCELED               = 7364,  -- Current training regime canceled.
        HUNT_ACCEPTED                 = 7382,  -- Hunt accepted!
        USE_SCYLDS                    = 7383,  -- You use <number> [scyld/scylds]. Scyld balance: <number>.
        HUNT_RECORDED                 = 7394,  -- You record your hunt.
        OBTAIN_SCYLDS                 = 7396,  -- You obtain <number> [scyld/scylds]! Current balance: <number> [scyld/scylds].
        HUNT_CANCELED                 = 7400,  -- Hunt canceled.
        JAJAROON_SHOP_DIALOG          = 10498, -- Hellooo. Yooo have caaard? Can do gaaame? Jajaroon have diiice.
        TSUTSUROON_SHOP_DIALOG        = 10508, -- What yooo want? Have katana, katana, and nin-nin...yooo want?
        MAMAROON_SHOP_DIALOG          = 10511, -- Welcome to maaagic shop. Lots of magics for yooo.
        POPOROON_SHOP_DIALOG          = 10513, -- Come, come. Buy aaarmor, looots of armor!
        WATAKHAMAZOM_SHOP_DIALOG      = 10514, -- Looking for some bows and bolts to strrrike fear into the hearts of your enemies? You can find 'em here!
        CHICHIROON_SHOP_DIALOG        = 10516, -- Howdy-hooo! I gots soooper rare dice for yooo.
        RARAROON_SHOP_CLOSED          = 10613, -- Rararoon want do visit to Alzadaal! Must have many triiinkets!
        RARAROON_SHOP_DIALOG          = 10614, -- Rararoon do visit to Alzadaal! Will trade many trinkets for jingly!
        SANCTION                      = 10792, -- You have received the Empire's Sanction.
        NENE_DELIVERY_DIALOG          = 10864, -- Yooo want to send gooods? Yooo want to send clink clink?
        NANA_DELIVERY_DIALOG          = 10865, -- Yooo send gooods. Yooo send clink clink.
        YOYOROON_SHOP_DIALOG          = 11824, -- Boooss, boooss! Yoyoroon bring yooo goood custooomer! Yoyoroon goood wooorker, nooo?
        PIPIROON_SHOP_DIALOG          = 11825, -- Yes? I'm a busy man. Make it quick.
        RETRIEVE_DIALOG_ID            = 11925, -- You retrieve <item> from the porter moogle's care.
        COMMON_SENSE_SURVIVAL         = 11964, -- It appears that you have arrived at a new survival guide provided by the Adventurers' Mutual Aid Network. Common sense dictates that you should now be able to teleport here from similar tomes throughout the world.
    },
    mob =
    {
    },
    npc =
    {
    },
}

return zones[xi.zone.NASHMAU]
