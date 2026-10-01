--
-- Gil Economy Ledger Module
--
-- One row per observed gil balance change, written by the gil_audit C++ module.
--
-- `balance_after` is authoritative (post-clamp, as sent to the client).
-- `delta` is the movement the module saw, NULL when it had no earlier balance for the character.
-- Summing `delta` per character and comparing to char_inventory shows gil that moved unobserved:
-- disabled categories, offline edits, or the server running with the module off.
--
-- Fuller detail for some paths lives in the audit table that owns them:
--   VendorBuy/Sell  audit_vendor    quantity, npc name, prices
--   BazaarBuy/Sell  audit_bazaar    both parties (counterparty is left 0 here)
--   AuctionBid      auction_house   the listing the bid won
--   PlayerTrade     audit_trade     every traded item (gil is itemid 65535)
--   DeliveryBox     audit_dbox      sender and receiver names
--
-- A movement the core later undoes (a refund when the other half of a bazaar or AH purchase fails)
-- shows as a second row that cancels the first; the balance stays right, the row count does not mean sales.
--
-- Schema changes need a tools/migrations entry: dbtool only creates this table when it does not exist.
--
-- Note: This table preserves existing data during database updates.
--       The table structure will only be created if it doesn't exist.
--

CREATE TABLE IF NOT EXISTS `audit_gil` (
  `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `txn_tag`       int(10)    unsigned NOT NULL DEFAULT 0,  -- random per map process, so txn_id is unique across processes and restarts
  `txn_seq`       int(10)    unsigned NOT NULL DEFAULT 0,  -- counts up within the process
  `txn_id`        bigint(20) unsigned GENERATED ALWAYS AS ((`txn_tag` << 32) | `txn_seq`) VIRTUAL, -- groups the legs of one transaction, 0 = standalone
  `charid`        int(10)    unsigned NOT NULL,
  `balance_after` int(10)    unsigned NOT NULL,
  `delta`         int(11)             DEFAULT NULL,        -- NULL = no earlier balance seen for this character
  `source`        varchar(24)         NOT NULL DEFAULT 'Unknown', -- GilSource name from gil_audit.cpp
  `counterparty`  int(10)    unsigned NOT NULL DEFAULT 0,  -- who was on the far side: charid, NPC id or mob id
  `itemid`        smallint(5) unsigned NOT NULL DEFAULT 0, -- item sold, for AH proceeds
  `source_detail` varchar(160)        NOT NULL DEFAULT '', -- lua helper or packet name
  `zoneid`        smallint(5) unsigned NOT NULL DEFAULT 0,
  `date`          int(10)    unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_gil_char_id`     (`charid`, `id`),
  KEY `idx_gil_txn`         (`txn_id`),
  KEY `idx_gil_source_date` (`source`, `date`),
  KEY `idx_gil_counter`     (`counterparty`, `date`),
  KEY `idx_gil_date`        (`date`),
  KEY `idx_gil_date_activity` (`date`, `charid`, `source`, `delta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
