set @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
set @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
set @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

drop schema if exists `blog`;

create schema if not exists `blog` default character set utf8mb4 collate utf8mb4_general_ci;

use `blog`;

drop table if exists `blog`.`SECTION`;

create table if not exists `blog`.`SECTION`(
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Number` INT UNSIGNED NULL,
    `Name` VARCHAR( 45 ) NULL,
    `Text` TEXT NULL,
    `Image` VARCHAR( 45 ) NULL,
    primary key( `Id` )
    ) engine = InnoDB;

drop table if exists `blog`.`USER`;

create table if not exists `blog`.`USER`(
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Email` VARCHAR( 45 ) NULL,
    `Pseudonym` VARCHAR( 45 ) NULL,
    `Password` VARCHAR( 45 ) NULL,
    `ItIsAdministrator` TINYINT UNSIGNED NULL,
    primary key( `Id` )
    ) engine = InnoDB;

drop table if exists `blog`.`ARTICLE`;

create table if not exists `blog`.`ARTICLE`(
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `SectionId` INT UNSIGNED NULL,
    `UserId` INT UNSIGNED NULL,
    `Title` TEXT NULL,
    `Text` TEXT NULL,
    `Image` VARCHAR( 45 ) NULL,
    `Date` DATE NULL,
    primary key( `Id` ),
    index `fk_article_section_1_idx`( `SectionId` ASC ),
    index `fk_article_user_2_idx`( `UserId` ASC ),
    constraint `fk_article_section_1`
    foreign key( `SectionId` )
    references `blog`.`SECTION`( `Id` )
        on delete set null
        on update no action,
    constraint `fk_article_user_2`
    foreign key( `UserId` )
    references `blog`.`USER`( `Id` )
        on delete set null
        on update no action
    ) engine = InnoDB;

drop table if exists `blog`.`COMMENT`;

create table if not exists `blog`.`COMMENT`(
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ArticleId` INT UNSIGNED NULL,
    `UserId` INT UNSIGNED NULL,
    `Text` TEXT NULL,
    `DateTime` DATETIME NULL,
    primary key( `Id` ),
    index `fk_comment_article_1_idx`( `ArticleId` ASC ),
    index `fk_comment_user_2_idx`( `UserId` ASC ),
    constraint `fk_comment_article_1`
    foreign key( `ArticleId` )
    references `blog`.`ARTICLE`( `Id` )
        on delete set null
        on update no action,
    constraint `fk_comment_user_2`
    foreign key( `UserId` )
    references `blog`.`USER`( `Id` )
        on delete set null
        on update no action
    ) engine = InnoDB;

drop table if exists `blog`.`SUBSCRIBER`;

create table if not exists `blog`.`SUBSCRIBER`(
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Email` VARCHAR( 45 ) NULL,
    primary key( `Id` )
    ) engine = InnoDB;

set SQL_MODE=@OLD_SQL_MODE;
set FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
set UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;