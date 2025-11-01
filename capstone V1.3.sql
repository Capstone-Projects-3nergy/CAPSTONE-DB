-- -----------------------------------------------------
-- Cleaned & Fixed MySQL Schema for "capstone"
-- Compatible with Spring Boot + JPA
-- -----------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema: capstone
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `capstone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `capstone`;

-- -----------------------------------------------------
-- Table `companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `companies` (
  `company_id` INT NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(100) NOT NULL,
  `tracking_url` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `dorms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorms` (
  `dorm_id` INT NOT NULL AUTO_INCREMENT,
  `dorm_name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(20) NULL DEFAULT NULL,
  `dorm_type` VARCHAR(20) NOT NULL,
  `email` VARCHAR(128) NULL DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dorm_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
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
  CONSTRAINT `fk_users_dorm`
    FOREIGN KEY (`dorm_id`)
    REFERENCES `dorms` (`dorm_id`)
    ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `parcels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parcels` (
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
CREATE TABLE IF NOT EXISTS `notification` (
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
CREATE TABLE IF NOT EXISTS `staff_dorms` (
  `dorm_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dorm_id`, `user_id`),
  CONSTRAINT `fk_staff_dorm_dorm`
    FOREIGN KEY (`dorm_id`)
    REFERENCES `dorms` (`dorm_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_staff_dorm_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
