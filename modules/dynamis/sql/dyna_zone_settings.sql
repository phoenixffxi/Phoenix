--------------------------------------
-- Dynamis Zone Settings
--------------------------------------

-- Dynamis Zones
UPDATE `zone_settings` SET `misc` = `misc` | 256 WHERE `name` LIKE "Dynamis%" AND `name` NOT LIKE "Dynamis_%_[D]" AND ((`misc` & 256) = 0); -- Adds zonewide loot pool if it does not have it
UPDATE `zone_settings` SET `misc` = `misc` & ~8 WHERE (name = "Dynamis-San_dOria" OR name = "Dynamis-Windurst" OR name = "Dynamis-Bastok" OR name = "Dynamis-Jeuno" OR name = "Dynamis-Tavnazia") AND (`misc` & 8) = 8; -- Removes Mazurka from zone
