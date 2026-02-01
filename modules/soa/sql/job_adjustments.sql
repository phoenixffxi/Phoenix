------------------------------------
-- Seekers of Adoulin Job SQL Adjustments
-- This module reverts relevant SQL tables for jobs to their pre-SoA values
------------------------------------

------------------------------------
-- Dark Knight
-- Source: https://www.bg-wiki.com/ffxi/Version_Update_(04/29/2013)
------------------------------------

-- Desperate Blows: Revert job trait to be merit unlocked
UPDATE traits SET meritid = 2502, level = 75 WHERE name = 'desperate blows';

------------------------------------
-- Beastmaster
-- Source: https://www.bg-wiki.com/ffxi/Version_Update_(04/29/2013)
------------------------------------

-- Sic: Revert recast from 1 1/2 min to 2 min
UPDATE abilities SET recastTime = 120 WHERE name = 'sic';

-- Ready: Revert charge recast from 30 to 60 seconds
UPDATE abilities SET recastTime = 60 WHERE name = 'ready';

-- Sic merit: Revert value from 2 to 4 seconds per level
UPDATE merits SET value = 4 WHERE name = 'sic_recast';
