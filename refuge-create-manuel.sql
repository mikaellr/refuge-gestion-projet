CREATE DATABASE IF NOT EXISTS `refuge`;

USE `refuge`;

DROP TABLE IF EXISTS `refuge_contact_requests`;
DROP TABLE IF EXISTS `refuge_animals`;
DROP TABLE IF EXISTS `refuge_races`;
DROP TABLE IF EXISTS `refuge_species`;
DROP TABLE IF EXISTS `refuge_colors`;
DROP TABLE IF EXISTS `refuge_users`;
DROP TABLE IF EXISTS `refuge_roles`;

CREATE TABLE `refuge_roles` (
  `id` INT UNSIGNED NOT NULL PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `refuge_users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) UNIQUE NOT NULL,
  `phone` VARCHAR(255) DEFAULT NULL,
  `hash` VARCHAR(255) NOT NULL,
  `salt` VARCHAR(255) NOT NULL,
  `fk_role` INT UNSIGNED NOT NULL,
  KEY `FKpemcxfh7pbce60kt5ew67vr8` (`fk_role`),
  CONSTRAINT `FKpemcxfh7pbce60kt5ew67vr8` FOREIGN KEY (`fk_role`) REFERENCES `refuge_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `refuge_species` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `refuge_races` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(55) DEFAULT NULL,
  `fk_species` INT UNSIGNED NOT NULL,
  UNIQUE(`name`, `fk_species`),
  KEY `FKbt7rljikniuv7nhpan9hq7yl0` (`fk_species`),
  CONSTRAINT `FKbt7rljikniuv7nhpan9hq7yl0` FOREIGN KEY (`fk_species`) REFERENCES `refuge_species` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `refuge_colors` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `refuge_animals` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) DEFAULT NULL,
  `description` VARCHAR(255) DEFAULT NULL,
  `birthYear` INT UNSIGNED DEFAULT NULL,
  `sex` CHAR(1) NOT NULL,
  `sterilized` BOOLEAN NOT NULL,
  `adoptable` BOOLEAN NOT NULL,
  `photo` MEDIUMBLOB DEFAULT NULL,
  `photoContentType` VARCHAR(255) DEFAULT NULL,
  `photoContentLength` INT UNSIGNED DEFAULT NULL,
  `fk_species` INT UNSIGNED NOT NULL,
  `fk_race` INT UNSIGNED DEFAULT NULL,
  `fk_color` INT UNSIGNED DEFAULT NULL,
  KEY `FK86gmxk28fbbvlhwimehul9r5k` (`fk_color`),
  KEY `FKdbi5sacy1cpgcy3tdw8ii3vwg` (`fk_race`),
  KEY `FKanmoe18quwvrg4epx9skjk6sg` (`fk_species`),
  CONSTRAINT `FK86gmxk28fbbvlhwimehul9r5k` FOREIGN KEY (`fk_color`) REFERENCES `refuge_colors` (`id`),
  CONSTRAINT `FKanmoe18quwvrg4epx9skjk6sg` FOREIGN KEY (`fk_species`) REFERENCES `refuge_species` (`id`),
  CONSTRAINT `FKdbi5sacy1cpgcy3tdw8ii3vwg` FOREIGN KEY (`fk_race`) REFERENCES `refuge_races` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `refuge_contact_requests` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `firstName` VARCHAR(255) DEFAULT NULL,
  `lastName` VARCHAR(255) DEFAULT NULL,
  `email` VARCHAR(255) DEFAULT NULL,
  `phone` VARCHAR(255) DEFAULT NULL,
  `message` VARCHAR(255) DEFAULT NULL,
  `date` DATETIME(6) NOT NULL,
  `treated` BOOLEAN NOT NULL,
  `fk_species` INT UNSIGNED NOT NULL,
  KEY `FK1g38erxr6m54g5r8argdubkxg` (`fk_species`),
  CONSTRAINT `FK1g38erxr6m54g5r8argdubkxg` FOREIGN KEY (`fk_species`) REFERENCES `refuge_animals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
