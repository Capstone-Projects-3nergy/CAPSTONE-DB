-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema capstone
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema capstone
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `capstone` DEFAULT CHARACTER SET utf8mb3 ;
USE `capstone` ;

-- -----------------------------------------------------
-- Table `capstone`.`companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `capstone`.`companies` (
  `company_id` INT NOT NULL,
  `company_name` VARCHAR(30) NOT NULL,
  `tracking_url` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`company_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `capstone`.`dorms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `capstone`.`dorms` (
  `dorm_id` INT NOT NULL,
  `dorm_name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(80) NOT NULL,
  `phone_number` VARCHAR(20) NULL DEFAULT NULL,
  `dorm_type` VARCHAR(15) NOT NULL,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`dorm_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `capstone`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `capstone`.`users` (
  `user_id` INT NOT NULL,
  `firebase_uid` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL,
  `first_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `phone_number` VARCHAR(15) NULL DEFAULT NULL,
  `profile_image_url` VARCHAR(300) NULL DEFAULT NULL,
  `role` ENUM('RESIDENT', 'STAFF', 'ADMIN') NOT NULL,
  `status` ENUM('ACTIVE', 'INACTIVE') NULL DEFAULT NULL,
  `position` VARCHAR(45) NULL DEFAULT NULL,
  `line_id` VARCHAR(45) NULL DEFAULT NULL,
  `room_number` VARCHAR(45) NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `dorms_dorm_id` INT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_users_dorms1_idx` (`dorms_dorm_id` ASC) VISIBLE,
  UNIQUE INDEX `firebase_uid_UNIQUE` (`firebase_uid` ASC) VISIBLE,
  CONSTRAINT `fk_users_dorms1`
    FOREIGN KEY (`dorms_dorm_id`)
    REFERENCES `capstone`.`dorms` (`dorm_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `capstone`.`parcels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `capstone`.`parcels` (
  `parcel_id` INT NOT NULL,
  `tracking_number` VARCHAR(45) NOT NULL,
  `recipient_name` VARCHAR(45) NOT NULL,
  `status` ENUM('PENDING', 'RECEIVED', 'PICKED_UP') NULL DEFAULT NULL,
  `parcel_type` VARCHAR(45) NULL DEFAULT NULL,
  `image_url` VARCHAR(300) NULL DEFAULT NULL,
  `sender_name` VARCHAR(20) NULL DEFAULT NULL,
  `received_at` DATETIME NOT NULL,
  `picked_up_at` DATETIME NULL DEFAULT NULL,
  `updated_at` DATETIME NOT NULL,
  `companies_company_id` INT NOT NULL,
  `users_user_id` INT NOT NULL,
  PRIMARY KEY (`parcel_id`),
  INDEX `fk_parcels_companies1_idx` (`companies_company_id` ASC) VISIBLE,
  INDEX `fk_parcels_users1_idx` (`users_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_parcels_companies1`
    FOREIGN KEY (`companies_company_id`)
    REFERENCES `capstone`.`companies` (`company_id`),
  CONSTRAINT `fk_parcels_users1`
    FOREIGN KEY (`users_user_id`)
    REFERENCES `capstone`.`users` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `capstone`.`notification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `capstone`.`notification` (
  `notification_id` INT NOT NULL,
  `noti_title` VARCHAR(45) NOT NULL,
  `status` ENUM('PENDING', 'SENT', 'FAILED') NOT NULL,
  `notification_type` ENUM('EMAIL', 'LINE') NULL DEFAULT NULL,
  `noti_message` VARCHAR(300) NULL DEFAULT NULL,
  `sent_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `parcels_parcel_id` INT NOT NULL,
  `users_user_id` INT NOT NULL,
  PRIMARY KEY (`notification_id`),
  INDEX `fk_Notification_parcels1_idx` (`parcels_parcel_id` ASC) VISIBLE,
  INDEX `fk_notification_users1_idx` (`users_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_Notification_parcels1`
    FOREIGN KEY (`parcels_parcel_id`)
    REFERENCES `capstone`.`parcels` (`parcel_id`),
  CONSTRAINT `fk_notification_users1`
    FOREIGN KEY (`users_user_id`)
    REFERENCES `capstone`.`users` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `capstone`.`staff_dorms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `capstone`.`staff_dorms` (
  `dorm_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `created_at` DATETIME NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`dorm_id`, `user_id`),
  INDEX `fk_dorms_has_staff_dorms1_idx` (`dorm_id` ASC) VISIBLE,
  INDEX `fk_staff_dorms_users1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_dorms_has_staff_dorms1`
    FOREIGN KEY (`dorm_id`)
    REFERENCES `capstone`.`dorms` (`dorm_id`),
  CONSTRAINT `fk_staff_dorms_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `capstone`.`users` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
