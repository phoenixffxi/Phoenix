-- Module for missing mob_groups for the ERA DATS
-- NOTE: THIS REQUIRED DAT EDITS OR IT WILL NOT WORK AND EVERYTHING WILL BE NAMED WRONG
-- https://github.com/phoenixffxi/Era-DATs

-- Uleguerand_Range (Zone 5)
UPDATE `mob_groups` SET `content_tag` = NULL WHERE `zoneid` = 5 AND `groupid` = 38;

-- Bhaflau Thickets (Zone 52)
INSERT INTO `mob_groups` VALUES (200,5648,52,'Wivre',300,0,242,0,0,0,NULL);

-- Zeruhn_Mines (Zone 172)
INSERT INTO `mob_groups` VALUES (200,4053,172,'Tunnel_Worm',300,0,2496,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (201,3165,172,'Leech',300,0,963,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (202,2763,172,'Mouse_Bat',300,0,19,0,0,0,NULL);


-- Inner Horutoto Ruins (Zone 192)
INSERT INTO `mob_groups` VALUES (200,382,192,'Beady_Beetle',300,0,249,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (201,372,192,'Bat_Battalion',300,0,241,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (202,1643,192,'Goblin_Butcher',300,0,1032,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (203,1635,192,'Goblin_Ambusher',300,0,1018,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (204,1738,192,'Goblin_Tinkerer',300,0,1035,0,0,0,NULL);

-- King Ranperre's Tomb (Zone 190)
INSERT INTO `mob_groups` VALUES (200,3946,190,'Tomb_Worm',660,0,428,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (201,6456,190,'Dire_Bat',660,0,234,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (202,871,190,'Cutlass_Scorpion',660,0,549,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (203,244,190,'Armet_Beetle',660,0,670,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (204,1073,190,'Thousand_Eyes',960,0,315,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (205,1898,190,'Hati',960,0,1278,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (206,1514,190,'Lemures',960,0,1506,0,0,0,NULL);

-- Dangruf_Wadi (Zone 191)
INSERT INTO `mob_groups` VALUES (200,6415,191,'Giant_Grub',300,0,2496,0,0,0,NULL);
INSERT INTO `mob_groups` VALUES (201,1666,191,'Goblin_Gambler',300,0,1084,0,0,0,NULL);

-- Ranguemont Pass (Zone 166)
INSERT INTO `mob_groups` VALUES (200,1715,166,'Goblin_Smithy',720,0,1162,0,0,0,NULL);

-- Crawlers Nest (Zone 197)
UPDATE `mob_groups` SET `content_tag` = NULL WHERE `zoneid` = 197 AND `groupid` IN (16, 17, 18, 19);