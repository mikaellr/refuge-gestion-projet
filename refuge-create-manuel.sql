CREATE DATABASE IF NOT EXISTS `refuge`;

USE `refuge`;

DROP TABLE IF EXISTS `contact_requests`;
DROP TABLE IF EXISTS `animals`;
DROP TABLE IF EXISTS `races`;
DROP TABLE IF EXISTS `species`;
DROP TABLE IF EXISTS `colors`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `uk__roles__name` UNIQUE KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(40) DEFAULT NULL,
  `hash` VARCHAR(255) NOT NULL,
  `salt` VARCHAR(255) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  `fk_role` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `uk__users__email` UNIQUE KEY (`email`),
  CONSTRAINT `fk__users__fk_role` FOREIGN KEY (`fk_role`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `species` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `uk__species__name` UNIQUE KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `races` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) DEFAULT NULL,
  `fk_species` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `uk__races__name__fk_species` UNIQUE KEY (`name`, `fk_species`),
  CONSTRAINT `fk__races__fk_species` FOREIGN KEY (`fk_species`) REFERENCES `species` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `colors` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `uk__colors__name` UNIQUE KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `animals` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) DEFAULT NULL,
  `description` VARCHAR(255) DEFAULT NULL,
  `birth_year` INT UNSIGNED DEFAULT NULL,
  `sex` CHAR(1) NOT NULL,
  `sterilized` BOOLEAN NOT NULL,
  `adoptable` BOOLEAN NOT NULL,
  `photo_content` MEDIUMBLOB DEFAULT NULL,
  `photo_content_type` VARCHAR(255) DEFAULT NULL,
  `photo_content_length` INT UNSIGNED DEFAULT NULL,
  `fk_species` INT UNSIGNED NOT NULL,
  `fk_race` INT UNSIGNED DEFAULT NULL,
  `fk_color` INT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk__animals__fk_color` FOREIGN KEY (`fk_color`) REFERENCES `colors` (`id`),
  CONSTRAINT `fk__animals__fk_species` FOREIGN KEY (`fk_species`) REFERENCES `species` (`id`),
  CONSTRAINT `fk__animals__fk_race` FOREIGN KEY (`fk_race`) REFERENCES `races` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `contact_requests` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) DEFAULT NULL,
  `last_name` VARCHAR(255) DEFAULT NULL,
  `email` VARCHAR(255) DEFAULT NULL,
  `phone` VARCHAR(255) DEFAULT NULL,
  `message` VARCHAR(255) DEFAULT NULL,
  `date` DATETIME(6) NOT NULL,
  `treated` BOOLEAN NOT NULL,
  `fk_animal` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk__contact_requests__fk_species` FOREIGN KEY (`fk_animal`) REFERENCES `animals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE OR REPLACE VIEW v_animals AS SELECT 
    an.id AS id, an.name AS name, an.description, an.birth_year, an.sex, an.sterilized, an.adoptable, an.photo_content_type, an.photo_content_length, 
    sp.name AS species_name,
    ra.name AS race_name,
    co.name AS color_name,
    COUNT(cr.message) AS contact_requests_number
    FROM animals AS an
    LEFT OUTER JOIN species AS sp ON an.fk_species=sp.id
    LEFT OUTER JOIN races AS ra ON an.fk_race=ra.id
    LEFT OUTER JOIN colors AS co ON an.fk_color=co.id
    LEFT OUTER JOIN contact_requests AS cr ON an.id=cr.fk_animal
    GROUP BY an.id
    ;
    
CREATE OR REPLACE VIEW v_users AS SELECT 
    us.id AS id, us.first_name, us.last_name, us.email, us.phone, us.salt, us.hash, us.active,
    ro.name AS role_name
    FROM users AS us LEFT OUTER JOIN roles AS ro ON us.fk_role=ro.id;
    
    

