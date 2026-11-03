-- Indexes for the admin economy API. dbtool imports module SQL on every update, so each must be idempotent.
-- IF NOT EXISTS matches on name only: changing an index's columns needs a new name.

CREATE INDEX IF NOT EXISTS `idx_gil_item`
    ON `audit_gil` (`itemid`, `source`, `date`);

CREATE INDEX IF NOT EXISTS `idx_vendor_date_popular`
    ON `audit_vendor` (`date`, `npcid`, `seller`, `quantity`, `direction`, `applied_gil`, `npc_name`);

CREATE INDEX IF NOT EXISTS `idx_gil_char_date`
    ON `audit_gil` (`charid`, `date`, `source`, `itemid`, `delta`);

CREATE INDEX IF NOT EXISTS `idx_vendor_direction_date_item`
    ON `audit_vendor` (`direction`, `date`, `itemid`, `quantity`, `applied_gil`);

CREATE INDEX IF NOT EXISTS `idx_ah_price_stats`
    ON `auction_house` (`itemid`, `stack`, `sell_date`, `id`, `sale`);

CREATE INDEX IF NOT EXISTS `idx_dbox_receiver_date`
    ON `audit_dbox` (`receiver`, `date`);
