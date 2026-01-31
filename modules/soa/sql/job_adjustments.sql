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
