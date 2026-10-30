-- ------------------------------------------------------------
-- These furnishings provide no Moghancement or elemental aura.
-- ------------------------------------------------------------
UPDATE `item_furnishing` SET `moghancement` = 0, `aura` = 0 WHERE `itemid` = 193; -- Adventuring Certificate (we need to remove this when the adventurer appreciation campaign happens)
UPDATE `item_furnishing` SET `moghancement` = 0, `aura` = 0 WHERE `itemid` = 264; -- Stuffed Chocobo
UPDATE `item_furnishing` SET `moghancement` = 0, `aura` = 0 WHERE `itemid` = 269; -- Shadow Lord Statue
UPDATE `item_furnishing` SET `moghancement` = 0, `aura` = 0 WHERE `itemid` = 320; -- Harpsichord
