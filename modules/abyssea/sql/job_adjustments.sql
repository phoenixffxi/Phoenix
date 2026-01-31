------------------------------------
-- Abyssea Job SQL Adjustments
-- This module reverts relevant SQL tables for jobs to their pre-Abyssea values
-- Unless otherwise noted, all changes here are sourced from: https://www.bg-wiki.com/ffxi/Version_Update_(03/26/2012)
------------------------------------

------------------------------------
-- Warrior
------------------------------------

-- Warrior's Charge: Revert recast from 5 to 15 minutes
UPDATE abilities SET recastTime = 900 WHERE name = 'warriors_charge';

-- Warrior's Charge merit: Revert value to 150 seconds per level
UPDATE merits SET value = 150 WHERE name = 'warriors_charge';

------------------------------------
-- White Mage
------------------------------------

-- Martyr: Revert recast from 10 to 20 minutes
UPDATE abilities SET recastTime = 1200 WHERE name = 'martyr';

-- Devotion: Revert recast from 10 to 20 minutes
UPDATE abilities SET recastTime = 1200 WHERE name = 'devotion';

-- Martyr merit: Revert value to 150 seconds per level
UPDATE merits SET value = 150 WHERE name = 'martyr';

-- Devotion merit: Revert value to 150 seconds per level
UPDATE merits SET value = 150 WHERE name = 'devotion';

-- Animus Solace: Disable merit upgrades
UPDATE merits SET upgrade = 0 WHERE name = 'animus_solace';

-- Animus Misery: Disable merit upgrades
UPDATE merits SET upgrade = 0 WHERE name = 'animus_misery';

------------------------------------
-- WHM Spell Cast Times
-- Source: https://www.bg-wiki.com/ffxi/Version_Update_(02/13/2012)
------------------------------------

-- Esuna: Revert cast time from 1 to 3 seconds
UPDATE spell_list SET castTime = 3000 WHERE name = 'esuna';

-- Sacrifice: Revert cast time from 1 to 1.5 seconds
UPDATE spell_list SET castTime = 1500 WHERE name = 'sacrifice';

-- Blindna: Revert cast time from 1 to 3 seconds
UPDATE spell_list SET castTime = 3000 WHERE name = 'blindna';

-- Cursna: Revert cast time from 1 to 3 seconds
UPDATE spell_list SET castTime = 3000 WHERE name = 'cursna';

------------------------------------
-- Dark Knight
-- Source: https://www.bg-wiki.com/ffxi/Version_Update_(02/13/2012)
------------------------------------

-- Arcane Circle: Revert recast from 5 to 10 minutes
UPDATE abilities SET recastTime = 600 WHERE name = 'arcane_circle';

-- Arcane Circle merit: Revert value to 20 seconds per level
UPDATE merits SET value = 20 WHERE name = 'arcane_circle_recast';

-- Weapon Bash: Revert recast from 3 to 5 minutes
UPDATE abilities SET recastTime = 300 WHERE name = 'weapon_bash';

-- Weapon Bash merit: Revert value to 10 seconds per level
UPDATE merits SET value = 10 WHERE name = 'weapon_bash_recast';

-- Dark Seal: Revert recast from 5 to 15 minutes
-- Source: https://www.bg-wiki.com/ffxi/Version_Update_(03/26/2012)
UPDATE abilities SET recastTime = 900 WHERE name = 'dark_seal';

-- Dark Seal merit: Revert value to 150 seconds per level
UPDATE merits SET value = 150 WHERE name = 'dark_seal';

-- Diabolic Eye: Revert recast from 5 to 15 minutes
UPDATE abilities SET recastTime = 900 WHERE name = 'diabolic_eye';

-- Diabolic Eye merit: Revert value to 150 seconds per level
UPDATE merits SET value = 150 WHERE name = 'diabolic_eye';
