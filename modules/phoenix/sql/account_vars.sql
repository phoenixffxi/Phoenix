--
-- Account Variables Module
--
-- Table structure for table `account_vars`
-- Similar to char_vars but stores variables at account level
-- Note: This table preserves existing data during database updates.
--       The table structure will only be created if it doesn't exist.
--

CREATE TABLE IF NOT EXISTS `account_vars` (
  `accountid` int(10) unsigned NOT NULL,
  `varname` varchar(30) NOT NULL,
  `value` int(11) NOT NULL,
  `expiry` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`accountid`,`varname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
