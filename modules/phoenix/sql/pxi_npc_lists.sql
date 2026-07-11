-- Module for Pheonix only changes
-- Changes in here should only be if LSB is correct and we need to change it

-- NPC Lists
-- Turn back on QMs for Kings
UPDATE `npc_list` SET `content_tag` = NULL WHERE `npcid` = 17408033 AND `name` = 'qm0'; -- Dragons Aery
UPDATE `npc_list` SET `content_tag` = NULL WHERE `npcid` = 17301543 AND `name` = 'qm0'; -- Valley of Sorrows
UPDATE `npc_list` SET `content_tag` = NULL WHERE `npcid` = 17297459 AND `name` = 'qm2'; -- Behemoths Dominion
