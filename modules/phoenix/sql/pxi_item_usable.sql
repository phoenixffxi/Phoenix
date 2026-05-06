-- ------------------------------------------------------
-- Item Usable Changes that require a DAT edit to change
-- ------------------------------------------------------
-- Structure
-- itemid
-- name
-- validTargets
-- activation
-- animation
-- animationTime
-- maxCharges
-- useDelay
-- reuseDelay
-- aoe

-- 24 Hour cooldown and 30 second use delay on Warp Cudgel
UPDATE `item_usable` SET reuseDelay = 86400, useDelay = 30 WHERE `name` = "warp_cudgel"; -- 24 hour cooldown, 30 second use delay

-- 16 Hour cooldown and 15 second use delay on all three Exp Bands
UPDATE `item_usable` SET reuseDelay = 57600, useDelay = 15 WHERE `name` = "chariot_band"; -- 16 hour cooldown, 15 second use delay
UPDATE `item_usable` SET reuseDelay = 57600, useDelay = 15 WHERE `name` = "empress_band"; -- 16 hour cooldown, 15 second use delay
UPDATE `item_usable` SET reuseDelay = 57600, useDelay = 15 WHERE `name` = "emperor_band"; -- 16 hour cooldown, 15 second use delay
