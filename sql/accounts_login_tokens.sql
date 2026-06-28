-- Single-use, short-TTL game-launch tokens.
--
-- Minted by an external auth service for an already-authenticated session and
-- consumed once by xi_connect's LOGIN_ATTEMPT. Stands in for BOTH password and
-- OTP at boot (a trust token only bypasses OTP). Single-use + TTL are enforced
-- in code, not the schema; only the SHA-256 hash is stored.
CREATE TABLE IF NOT EXISTS `accounts_login_tokens` (
  `token` CHAR(64) NOT NULL,
  `accid` INT UNSIGNED NOT NULL,
  `expires` DATETIME NOT NULL,
  PRIMARY KEY (`token`),
  INDEX `idx_accid` (`accid`),
  INDEX `idx_expires` (`expires`),
  CONSTRAINT `fk_login_accid` FOREIGN KEY (`accid`) REFERENCES `accounts`(`id`) ON DELETE CASCADE
);
