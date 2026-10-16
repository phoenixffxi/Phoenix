-- Indexes for the admin economy API. dbtool imports module SQL on every update, so each must be idempotent.
-- IF NOT EXISTS matches on name only: changing an index's columns needs a new name.

CREATE INDEX IF NOT EXISTS `idx_gil_item`
    ON `audit_gil` (`itemid`, `source`, `date`);

CREATE INDEX IF NOT EXISTS `idx_vendor_date_popular`
    ON `audit_vendor` (`date`, `npcid`, `seller`, `quantity`, `direction`, `applied_gil`, `npc_name`);
