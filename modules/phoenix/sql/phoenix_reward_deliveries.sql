-- Durable reward receipts must survive database updates and character retirement.
CREATE TABLE IF NOT EXISTS `phoenix_reward_deliveries` (
  `claim_id` varchar(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `program_key` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `platform_user_id` varchar(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `character_id` int unsigned NOT NULL,
  `account_id` int unsigned NOT NULL,
  `bundle_hash` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `delivered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`claim_id`),
  UNIQUE KEY `reward_delivery_program_user_idx` (`program_key`, `platform_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
