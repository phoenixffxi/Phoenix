CREATE TABLE IF NOT EXISTS `ticket_attachments` (
    `id` VARCHAR(36) NOT NULL,
    `ticket_id` INT UNSIGNED NOT NULL,
    `object_key` VARCHAR(128) NOT NULL,
    `original_filename` VARCHAR(255) NOT NULL,
    `content_type` ENUM('image/png', 'image/jpeg', 'image/webp', 'video/mp4') NOT NULL,
    `size_bytes` INT UNSIGNED NOT NULL,
    `status` ENUM('pending', 'finalizing', 'ready') NOT NULL DEFAULT 'pending',
    `created_at` INT UNSIGNED NOT NULL,
    `completed_at` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_ticket_attachments_object_key` (`object_key`),
    KEY `idx_ticket_attachments_ticket_status` (`ticket_id`, `status`),
    CONSTRAINT `fk_ticket_attachments_ticket`
        FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `ticket_attachments`
    MODIFY `status` ENUM('pending', 'finalizing', 'ready') NOT NULL DEFAULT 'pending';
