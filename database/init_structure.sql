-- MySQL Script generated by MySQL Workbench
-- Tue Sep 17 15:02:58 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema askc
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema askc
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `askc` ;
USE `askc` ;

-- -----------------------------------------------------
-- Table `Competition`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Competition` ;

CREATE TABLE IF NOT EXISTS `Competition` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `choosen_formula_id` INT UNSIGNED NOT NULL,
  `date` DATE NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `place` VARCHAR(255) NULL DEFAULT NULL,
  `owner` VARCHAR(45) NULL DEFAULT NULL,
  `type` VARCHAR(10) NOT NULL,
  `locked` TINYINT UNSIGNED NULL DEFAULT 0,
  `locked_fighter_list` TINYINT UNSIGNED NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `deleted_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `choosen_formula_id_idx` (`choosen_formula_id` ASC),
  CONSTRAINT `choosen_formula_id`
    FOREIGN KEY (`choosen_formula_id`)
    REFERENCES `Formula` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CompetitionFighter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CompetitionFighter` ;

CREATE TABLE IF NOT EXISTS `CompetitionFighter` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `license` VARCHAR(16) NOT NULL,
  `competition_id` INT UNSIGNED NOT NULL,
  `birthdate` DATE NOT NULL,
  `grade` VARCHAR(15) NULL DEFAULT NULL,
  `club` VARCHAR(255) NULL DEFAULT NULL,
  `team` VARCHAR(60) NULL DEFAULT NULL,
  `is_present` TINYINT UNSIGNED NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `deleted_at` DATETIME NOT NULL,
  INDEX `Competition_id_idx` (`competition_id` ASC),
  UNIQUE INDEX `license_UNIQUE` (`license` ASC),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  CONSTRAINT `competition_fighter_id_competition`
    FOREIGN KEY (`competition_id`)
    REFERENCES `Competition` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CompetitionFormula`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CompetitionFormula` ;

CREATE TABLE IF NOT EXISTS `CompetitionFormula` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `competition_id` INT UNSIGNED NOT NULL,
  `element_id` INT UNSIGNED NOT NULL,
  `element_type` VARCHAR(100) NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `deleted_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idCompetitionFormula_UNIQUE` (`id` ASC),
  INDEX `idCompetition_idx` (`competition_id` ASC),
  CONSTRAINT `competition_formula_id_competition`
    FOREIGN KEY (`competition_id`)
    REFERENCES `Competition` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CompetitionPool`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CompetitionPool` ;

CREATE TABLE IF NOT EXISTS `CompetitionPool` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `competition_id` INT UNSIGNED NOT NULL,
  `number_of_qualified_fighter` INT UNSIGNED NOT NULL DEFAULT 1,
  `number_of_pool` INT UNSIGNED NULL DEFAULT 0,
  `number_of_player_per_pool` INT UNSIGNED NULL DEFAULT 0,
  `dismiss_favorite` TINYINT UNSIGNED NULL DEFAULT 0,
  `locked` TINYINT UNSIGNED NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `deleted_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idCompetitionPool_UNIQUE` (`id` ASC),
  INDEX `idCompetition_idx` (`competition_id` ASC),
  CONSTRAINT `competition_pool_id_competition`
    FOREIGN KEY (`competition_id`)
    REFERENCES `Competition` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CompetitionTree`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CompetitionTree` ;

CREATE TABLE IF NOT EXISTS `CompetitionTree` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `competition_id` INT UNSIGNED NOT NULL,
  `dismiss_favorite` TINYINT UNSIGNED NULL DEFAULT 0,
  `third_place_match` TINYINT UNSIGNED NULL DEFAULT 0,
  `locked` TINYINT UNSIGNED NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `deleted_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idCompetitionTree_UNIQUE` (`id` ASC),
  INDEX `idCompetition_idx` (`competition_id` ASC),
  CONSTRAINT `competition_tree_id_competition`
    FOREIGN KEY (`competition_id`)
    REFERENCES `Competition` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Formula`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Formula` ;

CREATE TABLE IF NOT EXISTS `Formula` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `component_list` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
