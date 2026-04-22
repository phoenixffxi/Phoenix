-- ------------------------------------------------------
-- Item Usable Changes that require a DAT edit to change
-- ------------------------------------------------------

-- 24 Hour cooldown and 30 second use delay on Warp Cudgel
UPDATE `item_usable` SET reuseDelay = 86400, useDelay = 30 WHERE `name` = "warp_cudgel"; -- 24 hour cooldown, 30 second use delay
