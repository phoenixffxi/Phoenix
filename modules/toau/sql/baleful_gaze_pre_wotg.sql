-----------------------------------
-- pre-WotG Baleful Gaze (Lizard) Module
-- This module reverses the changes to the Lizard family's Baleful Gaze prepare time found on the 09/08/2008 patch.
-- https://wiki.ffo.jp/html/11687.html (Mentions the prepare time being dramatically increased in the 09/08/2008 patch)
----------------------------------- 

UPDATE `mob_skills` SET `mob_prepare_time` = 1800 WHERE `mob_skill_name` = 'baleful_gaze_lizard'; 
