--
-- Guild Shop Persistence Module
--
-- One row per shop item, written by the guild_shop_persistence C++ module so
-- the Lua guild shop system (scripts/globals/guild_shops.lua) keeps its stock
-- and day-locked prices across restarts.
--
-- `shop` is the canonical shop NPC name.
-- `last_roll` is the Vana'diel day the shop's prices were locked.
--
-- Note: This table preserves existing data during database updates.
--       The table structure will only be created if it doesn't exist.
--       A schema change therefore needs a tools/migrations entry.
--

CREATE TABLE IF NOT EXISTS `guild_shop_state` (
  `shop` varchar(32) NOT NULL,
  `itemid` smallint(5) unsigned NOT NULL,
  `stock` smallint(5) unsigned NOT NULL DEFAULT 0,
  `buy_price` int(10) unsigned NOT NULL DEFAULT 0,
  `sell_price` int(10) unsigned NOT NULL DEFAULT 0,
  `offered` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `last_roll` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`shop`,`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
