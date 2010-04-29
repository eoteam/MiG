
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `mig`;

CREATE SCHEMA `mig` DEFAULT CHARACTER SET latin1 ;
# Dump of table comments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `authorname` varchar(100) NOT NULL,
  `authoremail` varchar(255) NOT NULL,
  `comment` mediumtext NOT NULL,
  `statusid` int(11) NOT NULL,
  `createdate` bigint(20) NOT NULL,
  `deleted` int(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentid` (`contentid`),
  KEY `comments_contentid_fk` (`contentid`),
  KEY `comments_statusid_fk` (`statusid`),
  CONSTRAINT `comments_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comments_statusid_fk` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `config`;

CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `system` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table content
# ------------------------------------------------------------

DROP TABLE IF EXISTS `content`;

CREATE TABLE `content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(11) NOT NULL,
  `templateid` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `migtitle` varchar(255) NOT NULL,
  `color` varchar(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `permalink` varchar(50) NOT NULL,
  `shortdescription` text NOT NULL,
  `shortdescription2` mediumtext NOT NULL,
  `description` longtext NOT NULL,
  `description2` longtext NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT '0',
  `statusid` int(11) NOT NULL,
  `customfield1` mediumtext NOT NULL,
  `customfield2` mediumtext NOT NULL,
  `customfield3` mediumtext NOT NULL,
  `customfield4` mediumtext NOT NULL,
  `customfield5` mediumtext NOT NULL,
  `customfield6` mediumtext NOT NULL,
  `customfield7` mediumtext NOT NULL,
  `customfield8` mediumtext NOT NULL,
  `customfield9` mediumtext NOT NULL,
  `customfield10` mediumtext NOT NULL,
  `customfield11` mediumtext NOT NULL,
  `customfield12` mediumtext NOT NULL,
  `containerpath` text NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` bigint(20) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` bigint(20) NOT NULL,
  `deleted` int(1) NOT NULL,
  `is_fixed` int(1) NOT NULL,
  `search_exclude` int(1) NOT NULL,
  `can_have_children` int(1) NOT NULL,
  `displayorder` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentid` (`parentid`),
  KEY `content_template_fk` (`templateid`),
  KEY `content_parent_content_fk` (`parentid`),
  KEY `content_status_fk` (`statusid`),
  CONSTRAINT `content_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `content_status_fk` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_template_fk` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table content_content
# ------------------------------------------------------------

DROP TABLE IF EXISTS `content_content`;

CREATE TABLE `content_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `contentid2` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`,`contentid2`),
  KEY `content_content_contentid_fk` (`contentid`),
  KEY `content_content_contentid2_fk` (`contentid2`),
  CONSTRAINT `content_content_contentid2_fk` FOREIGN KEY (`contentid2`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_content_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table content_customfields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `content_customfields`;

CREATE TABLE `content_customfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `fieldname` varchar(255) NOT NULL,
  `data` mediumtext NOT NULL,
  `typeid` int(11) NOT NULL,
  `displayorder` int(4) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `content_customfields_contentid_fk` (`contentid`),
  CONSTRAINT `content_customfields_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table content_media
# ------------------------------------------------------------

DROP TABLE IF EXISTS `content_media`;

CREATE TABLE `content_media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `mediaid` int(11) NOT NULL,
  `usage_type` varchar(255) NOT NULL,
  `credits` mediumtext NOT NULL,
  `caption` varchar(255) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` bigint(20) NOT NULL,
  `displayorder` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `mediaid` (`mediaid`),
  KEY `content_media_contentid_fk` (`contentid`),
  KEY `content_media_mediaid_fk` (`mediaid`),
  CONSTRAINT `content_media_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_media_mediaid_fk` FOREIGN KEY (`mediaid`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table content_terms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `content_terms`;

CREATE TABLE `content_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `termid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `tagid` (`termid`),
  KEY `content_terms_contentid_fk` (`contentid`),
  KEY `content_terms_termid_fk` (`termid`),
  CONSTRAINT `content_terms_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_terms_termid_fk` FOREIGN KEY (`termid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table content_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `content_users`;

CREATE TABLE `content_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `userid` (`userid`),
  KEY `content_users_userid_fk` (`userid`),
  KEY `content_users_contentid_fk` (`contentid`),
  CONSTRAINT `content_users_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_users_userid_fk` FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table customfieldgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `customfieldgroups`;

CREATE TABLE `customfieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table customfields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `customfields`;

CREATE TABLE `customfields` (
  `id` int(4) NOT NULL,
  `typeid` int(11) NOT NULL,
  `groupid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `displayname` varchar(255) NOT NULL,
  `options` text NOT NULL,
  `defaultvalue` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `customfield_type_fk` (`typeid`),
  KEY `customfield_group_fk` (`groupid`),
  CONSTRAINT `customfield_group_fk` FOREIGN KEY (`groupid`) REFERENCES `customfieldgroups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `customfield_type_fk` FOREIGN KEY (`typeid`) REFERENCES `customfieldtypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table customfieldtypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `customfieldtypes`;

CREATE TABLE `customfieldtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldtype` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table fonts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fonts`;

CREATE TABLE `fonts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `device` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table media
# ------------------------------------------------------------

DROP TABLE IF EXISTS `media`;

CREATE TABLE `media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `mimetypeid` int(11) NOT NULL,
  `size` int(11) NOT NULL,
  `playtime` float NOT NULL,
  `path` varchar(255) NOT NULL,
  `thumb` varchar(255) NOT NULL,
  `video_proxy` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `compiled` int(1) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` bigint(20) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `media_mimetype_fk` (`mimetypeid`),
  CONSTRAINT `media_ibfk_1` FOREIGN KEY (`mimetypeid`) REFERENCES `mimetypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table media_terms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `media_terms`;

CREATE TABLE `media_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mediaid` int(11) NOT NULL,
  `termid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mediaid` (`mediaid`),
  KEY `termid` (`termid`),
  KEY `media_terms_mediaid_fk` (`mediaid`),
  KEY `media_terms_termid_fk` (`termid`),
  CONSTRAINT `media_terms_mediaid_fk` FOREIGN KEY (`mediaid`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `media_terms_termid_fk` FOREIGN KEY (`termid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table mimetypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mimetypes`;

CREATE TABLE `mimetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `extensions` varchar(255) NOT NULL,
  `view` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table permgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `permgroups`;

CREATE TABLE `permgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permgroup` varchar(255) NOT NULL,
  `displayorder` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table perms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `perms`;

CREATE TABLE `perms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permgroupid` int(11) NOT NULL,
  `perm` varchar(255) NOT NULL,
  `permtext` text NOT NULL,
  `displayorder` int(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `permgroupid` (`permgroupid`),
  KEY `perms_permgroupid_fk` (`permgroupid`),
  CONSTRAINT `perms_permgroupid_fk` FOREIGN KEY (`permgroupid`) REFERENCES `permgroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table statuses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `statuses`;

CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) NOT NULL,
  `displayorder` int(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table template_customfields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `template_customfields`;

CREATE TABLE `template_customfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `templateid` int(11) NOT NULL,
  `customfieldid` int(11) NOT NULL,
  `fieldid` int(11) NOT NULL COMMENT 'The customfield(x) number',
  `displayorder` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templateid` (`templateid`),
  KEY `customfieldid` (`customfieldid`),
  KEY `template_customfields_templateid_fk` (`templateid`),
  KEY `template_customfields_customfieldid_fk` (`customfieldid`),
  CONSTRAINT `template_customfields_customfieldid_fk` FOREIGN KEY (`customfieldid`) REFERENCES `customfields` (`typeid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_customfields_templateid_fk` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `templates`;

CREATE TABLE `templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `classname` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentid` (`parentid`),
  KEY `template_parent_template_fk` (`parentid`),
  CONSTRAINT `templates_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `templates` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table term_taxonomy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `term_taxonomy`;

CREATE TABLE `term_taxonomy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(11) NOT NULL,
  `termid` int(11) NOT NULL,
  `taxonomy` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `color` int(11) NOT NULL,
  `date1` bigint(20) NOT NULL,
  `date2` bigint(20) NOT NULL,
  `displayorder` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `termid` (`termid`),
  KEY `parentid` (`parentid`),
  KEY `term_taxonomy_termid_fk` (`termid`),
  KEY `term_taxonomy_parent_term_taxonomy_fk` (`parentid`),
  CONSTRAINT `term_taxonomy_parent_term_taxonomy_fk` FOREIGN KEY (`parentid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `term_taxonomy_termid_fk` FOREIGN KEY (`termid`) REFERENCES `terms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table terms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `terms`;

CREATE TABLE `terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usergroupid` int(11) NOT NULL,
  `firstname` varchar(255) CHARACTER SET latin1 NOT NULL,
  `lastname` varchar(255) CHARACTER SET latin1 NOT NULL,
  `username` varchar(255) CHARACTER SET latin1 NOT NULL,
  `email` varchar(255) CHARACTER SET latin1 NOT NULL,
  `address` varchar(255) CHARACTER SET latin1 NOT NULL,
  `address2` varchar(255) CHARACTER SET latin1 NOT NULL,
  `city` varchar(100) CHARACTER SET latin1 NOT NULL,
  `state` varchar(4) CHARACTER SET latin1 NOT NULL,
  `country` varchar(100) CHARACTER SET latin1 NOT NULL,
  `zip` varchar(12) NOT NULL,
  `phone` varchar(20) CHARACTER SET latin1 NOT NULL,
  `ship_firstname` varchar(100) NOT NULL,
  `ship_lastname` varchar(100) NOT NULL,
  `ship_address` varchar(255) NOT NULL,
  `ship_address2` varchar(255) NOT NULL,
  `ship_city` varchar(100) NOT NULL,
  `ship_state` varchar(50) NOT NULL,
  `ship_zip` varchar(20) NOT NULL,
  `ship_country` varchar(10) NOT NULL,
  `ship_phone` varchar(20) NOT NULL,
  `mobile` varchar(20) CHARACTER SET latin1 NOT NULL,
  `fax` varchar(20) CHARACTER SET latin1 NOT NULL,
  `dateofbirth` int(11) NOT NULL,
  `password` varchar(255) CHARACTER SET latin1 NOT NULL,
  `lastlogin` int(11) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `active` int(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usergroupid` (`usergroupid`),
  KEY `user_usergroup_fk` (`usergroupid`),
  CONSTRAINT `user_usergroup_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table user_notes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_notes`;

CREATE TABLE `user_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `createdate` bigint(20) NOT NULL,
  `modifieddate` bigint(20) NOT NULL,
  `deleted` int(1) NOT NULL,
  KEY `id` (`id`),
  KEY `user_notes_userid_fk` (`userid`),
  CONSTRAINT `user_notes_userid_fk` FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table user_usercategories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_usercategories`;

CREATE TABLE `user_usercategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  KEY `categoryid` (`categoryid`),
  KEY `user_usercategories_userid_fk` (`userid`),
  KEY `user_usercategories_categoryid_fk` (`categoryid`),
  CONSTRAINT `userusercategories_categoryid_fk` FOREIGN KEY (`categoryid`) REFERENCES `usercategories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userusercategories_userid_fk` FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table usercategories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `usercategories`;

CREATE TABLE `usercategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usergroupid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usercategories_usergroupid_fk` (`usergroupid`),
  CONSTRAINT `usercategories_usergroupid_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table usergroup_perms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `usergroup_perms`;

CREATE TABLE `usergroup_perms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usergroupid` int(11) NOT NULL,
  `permid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usergroupid` (`usergroupid`),
  KEY `permid` (`permid`),
  KEY `usergroup_id` (`usergroupid`),
  KEY `usergroup_perms_usergroupid_fk` (`usergroupid`),
  KEY `usergroup_perms_permid_fk` (`permid`),
  CONSTRAINT `usergroup_perms_permid_fk` FOREIGN KEY (`permid`) REFERENCES `perms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usergroup_perms_usergroupid_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `usergroups`;

CREATE TABLE `usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(11) NOT NULL,
  `usergroup` varchar(255) CHARACTER SET latin1 NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentid` (`parentid`),
  KEY `usergroups_parent_usergroups_fk` (`parentid`),
  CONSTRAINT `usergroups_parent_usergroups_fk` FOREIGN KEY (`parentid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;