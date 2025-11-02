-- -----------------------------------------------------
-- Cleaned & Fixed MySQL Schema for "capstone"
-- Compatible with Spring Boot + JPA
-- Version: 2.0 with Sample Data
-- -----------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema: capstone
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `capstone`;
CREATE SCHEMA `capstone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `capstone`;

-- -----------------------------------------------------
-- Table `companies`
-- -----------------------------------------------------
CREATE TABLE `companies` (
  `company_id` INT NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(100) NOT NULL,
  `tracking_url` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `dorms`
-- -----------------------------------------------------
CREATE TABLE `dorms` (
  `dorm_id` INT NOT NULL AUTO_INCREMENT,
  `dorm_name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(20) NULL DEFAULT NULL,
  `dorm_type` ENUM('Female_Dormitory','Male_Dormitory') NOT NULL,
  `email` VARCHAR(128) NULL DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dorm_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE TABLE `users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `firebase_uid` VARCHAR(45) NULL DEFAULT NULL,
  `email` VARCHAR(128) NOT NULL,
  `first_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `phone_number` VARCHAR(15) NULL DEFAULT NULL,
  `profile_image_url` VARCHAR(300) NULL DEFAULT NULL,
  `role` ENUM('RESIDENT', 'STAFF', 'ADMIN') NOT NULL,
  `status` ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
  `position` VARCHAR(45) NULL DEFAULT NULL,
  `line_id` VARCHAR(45) NULL DEFAULT NULL,
  `room_number` VARCHAR(45) NULL DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dorm_id` INT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_users_email` (`email`),
  UNIQUE KEY `uk_users_firebase_uid` (`firebase_uid`),
  INDEX `idx_users_dorm` (`dorm_id`),
  CONSTRAINT `fk_users_dorm`
    FOREIGN KEY (`dorm_id`)
    REFERENCES `dorms` (`dorm_id`)
    ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `parcels`
-- -----------------------------------------------------
CREATE TABLE `parcels` (
  `parcel_id` INT NOT NULL AUTO_INCREMENT,
  `tracking_number` VARCHAR(100) NOT NULL,
  `recipient_name` VARCHAR(100) NOT NULL,
  `status` ENUM('PENDING', 'RECEIVED', 'PICKED_UP') DEFAULT 'PENDING',
  `parcel_type` VARCHAR(45) NULL DEFAULT NULL,
  `image_url` VARCHAR(300) NULL DEFAULT NULL,
  `sender_name` VARCHAR(100) NULL DEFAULT NULL,
  `received_at` DATETIME NOT NULL,
  `picked_up_at` DATETIME NULL DEFAULT NULL,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `company_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`parcel_id`),
  INDEX `idx_parcel_company` (`company_id`),
  INDEX `idx_parcel_user` (`user_id`),
  INDEX `idx_parcel_tracking` (`tracking_number`),
  CONSTRAINT `fk_parcel_company`
    FOREIGN KEY (`company_id`)
    REFERENCES `companies` (`company_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_parcel_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `notification`
-- -----------------------------------------------------
CREATE TABLE `notification` (
  `notification_id` INT NOT NULL AUTO_INCREMENT,
  `noti_title` VARCHAR(100) NOT NULL,
  `status` ENUM('PENDING', 'SENT', 'FAILED') NOT NULL,
  `notification_type` ENUM('EMAIL', 'LINE') NULL DEFAULT NULL,
  `noti_message` VARCHAR(500) NULL DEFAULT NULL,
  `sent_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `parcel_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`notification_id`),
  INDEX `idx_notification_parcel` (`parcel_id`),
  INDEX `idx_notification_user` (`user_id`),
  CONSTRAINT `fk_notification_parcel`
    FOREIGN KEY (`parcel_id`)
    REFERENCES `parcels` (`parcel_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_notification_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `staff_dorms`
-- -----------------------------------------------------
CREATE TABLE `staff_dorms` (
  `dorm_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dorm_id`, `user_id`),
  INDEX `idx_staff_dorm_user` (`user_id`),
  CONSTRAINT `fk_staff_dorm_dorm`
    FOREIGN KEY (`dorm_id`)
    REFERENCES `dorms` (`dorm_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_staff_dorm_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Insert Sample Data
-- -----------------------------------------------------

-- ✅ Insert Companies
INSERT INTO `companies` (`company_name`, `tracking_url`) VALUES
('Thailand Post', 'https://track.thailandpost.co.th/?trackNumber='),
('Kerry Express', 'https://th.kerryexpress.com/en/track/?track='),
('Flash Express', 'https://flashexpress.com/tracking/?se='),
('J&T Express', 'https://www.jtexpress.co.th/index/query/gzquery.html?bills='),
('DHL Express', 'https://www.dhl.com/th-en/home/tracking.html?tracking-id='),
('FedEx', 'https://www.fedex.com/fedextrack/?tracknumbers=');

-- ✅ Insert Dorms (Female and Male)
INSERT INTO `dorms` (`dorm_name`, `address`, `phone_number`, `dorm_type`, `email`) VALUES
-- Female Dormitories
('KMUTT Female Dorm A', '126 Pracha Uthit Rd, Bang Mod, Thung Khru, Bangkok 10140', '02-470-8000', 'Female_Dormitory', 'female-dorm-a@kmutt.ac.th'),
('KMUTT Female Dorm B', '126 Pracha Uthit Rd, Bang Mod, Thung Khru, Bangkok 10140', '02-470-8001', 'Female_Dormitory', 'female-dorm-b@kmutt.ac.th'),
('KMUTT Female Dorm C', '126 Pracha Uthit Rd, Bang Mod, Thung Khru, Bangkok 10140', '02-470-8002', 'Female_Dormitory', 'female-dorm-c@kmutt.ac.th'),
('Dhammaraksa Residence Hall 2', '126 Pracha Uthit Rd, Bang Mod, Thung Khru, Bangkok 10140', '02-470-8003', 'Female_Dormitory', 'dhammaraksa2@kmutt.ac.th'),

-- Male Dormitories
('KMUTT Male Dorm A', '126 Pracha Uthit Rd, Bang Mod, Thung Khru, Bangkok 10140', '02-470-8100', 'Male_Dormitory', 'male-dorm-a@kmutt.ac.th'),
('KMUTT Male Dorm B', '126 Pracha Uthit Rd, Bang Mod, Thung Khru, Bangkok 10140', '02-470-8101', 'Male_Dormitory', 'male-dorm-b@kmutt.ac.th'),
('KMUTT Male Dorm C', '126 Pracha Uthit Rd, Bang Mod, Thung Khru, Bangkok 10140', '02-470-8102', 'Male_Dormitory', 'male-dorm-c@kmutt.ac.th'),
('Dhammaraksa Residence Hall 1', '126 Pracha Uthit Rd, Bang Mod, Thung Khru, Bangkok 10140', '02-470-8103', 'Male_Dormitory', 'dhammaraksa1@kmutt.ac.th');

-- ✅ Insert Sample Users (for testing)
-- Note: firebase_uid will be set on first login
INSERT INTO `users` (`email`, `first_name`, `last_name`, `role`, `status`, `dorm_id`, `room_number`) VALUES
-- Residents in Female Dorms
('alice.resident@kmutt.ac.th', 'Alice', 'Smith', 'RESIDENT', 'ACTIVE', 1, '101'),
('bob.resident@kmutt.ac.th', 'Bob', 'Johnson', 'RESIDENT', 'ACTIVE', 1, '102'),
('carol.resident@kmutt.ac.th', 'Carol', 'Williams', 'RESIDENT', 'ACTIVE', 2, '201'),

-- Residents in Male Dorms
('david.resident@kmutt.ac.th', 'David', 'Brown', 'RESIDENT', 'ACTIVE', 5, '301'),
('eva.resident@kmutt.ac.th', 'Eva', 'Davis', 'RESIDENT', 'ACTIVE', 6, '401');

-- ✅ Insert Sample Staff
INSERT INTO `users` (`email`, `first_name`, `last_name`, `role`, `status`, `position`) VALUES
('staff.admin@kmutt.ac.th', 'Admin', 'User', 'STAFF', 'ACTIVE', 'Parcel Manager'),
('staff.supervisor@kmutt.ac.th', 'Supervisor', 'Team', 'STAFF', 'ACTIVE', 'Dorm Supervisor');

-- ✅ Link Staff to Dorms (staff can manage multiple dorms)
INSERT INTO `staff_dorms` (`dorm_id`, `user_id`) VALUES
(1, 6), -- Admin manages Female Dorm A
(2, 6), -- Admin manages Female Dorm B
(5, 7), -- Supervisor manages Male Dorm A
(6, 7); -- Supervisor manages Male Dorm B

-- -----------------------------------------------------
-- Verification Queries
-- -----------------------------------------------------

-- Show all dorms
SELECT 'All Dorms:' as Info;
SELECT dorm_id, dorm_name, dorm_type FROM dorms ORDER BY dorm_type, dorm_id;

-- Show female dorms only
SELECT 'Female Dorms:' as Info;
SELECT dorm_id, dorm_name FROM dorms WHERE dorm_type = 'Female_Dormitory';

-- Show male dorms only
SELECT 'Male Dorms:' as Info;
SELECT dorm_id, dorm_name FROM dorms WHERE dorm_type = 'Male_Dormitory';

-- Show users with their dorms
SELECT 'Users and Dorms:' as Info;
SELECT 
    u.user_id, 
    u.email, 
    u.first_name, 
    u.last_name, 
    u.role, 
    u.room_number,
    d.dorm_name,
    d.dorm_type
FROM users u
LEFT JOIN dorms d ON u.dorm_id = d.dorm_id
ORDER BY u.role, u.user_id;

-- Show staff-dorm relationships
SELECT 'Staff-Dorm Assignments:' as Info;
SELECT 
    u.first_name,
    u.last_name,
    u.position,
    d.dorm_name,
    d.dorm_type
FROM staff_dorms sd
JOIN users u ON sd.user_id = u.user_id
JOIN dorms d ON sd.dorm_id = d.dorm_id
ORDER BY u.user_id, d.dorm_id;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

SELECT '✅ Database setup completed successfully!' as Status;