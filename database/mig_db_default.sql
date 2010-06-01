SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `mig`;

CREATE SCHEMA `mig` DEFAULT CHARACTER SET latin1 ;
USE `mig`;


DROP TABLE IF EXISTS `comments`;
DROP TABLE IF EXISTS `config`;
DROP TABLE IF EXISTS `content`;
DROP TABLE IF EXISTS `content_content`;
DROP TABLE IF EXISTS `content_customfields`;
DROP TABLE IF EXISTS `content_media`;
DROP TABLE IF EXISTS `content_terms`;
DROP TABLE IF EXISTS `content_users`;
DROP TABLE IF EXISTS `customfieldgroups`;
DROP TABLE IF EXISTS `customfields`;
DROP TABLE IF EXISTS `customfieldtypes`;
DROP TABLE IF EXISTS `fonts`;
DROP TABLE IF EXISTS `media`;
DROP TABLE IF EXISTS `media_terms`;
DROP TABLE IF EXISTS `mimetypes`;
DROP TABLE IF EXISTS `permgroups`;
DROP TABLE IF EXISTS `perms`;
DROP TABLE IF EXISTS `statuses`;
DROP TABLE IF EXISTS `template_customfields`;
DROP TABLE IF EXISTS `templates`;
DROP TABLE IF EXISTS `term_taxonomy`;
DROP TABLE IF EXISTS `terms`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `user_notes`;
DROP TABLE IF EXISTS `user_usercategories`;
DROP TABLE IF EXISTS `usercategories`;
DROP TABLE IF EXISTS `usergroup_perms`;
DROP TABLE IF EXISTS `usergroups`;


CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `authorname` varchar(100) NOT NULL,
  `authoremail` varchar(255) NOT NULL,
  `comment` mediumtext NOT NULL,
  `statusid` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `deleted` int(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentid` (`contentid`),
  KEY `comments_contentid_fk` (`contentid`),
  KEY `comments_statusid_fk` (`statusid`),
  CONSTRAINT `comments_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comments_statusid_fk` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `system` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;


CREATE TABLE `content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(11) NOT NULL,
  `templateid` int(11) NOT NULL,
  `migtitle` varchar(255) NOT NULL,
  `statusid` int(11) NOT NULL,
  `containerpath` text NOT NULL,
  `deleted` int(1) NOT NULL,
  `is_fixed` int(1) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `search_exclude` int(1) NOT NULL,
  `can_have_children` int(1) NOT NULL,
  `displayorder` int(4) NOT NULL,
  `customfield1` varchar(255) NOT NULL,
  `customfield2` varchar(255) NOT NULL,
  `customfield3` longtext NOT NULL,
  `customfield4` mediumtext NOT NULL,
  `customfield5` mediumtext NOT NULL,
  `customfield6` mediumtext NOT NULL,
  `customfield7` mediumtext NOT NULL,
  `customfield8` mediumtext NOT NULL,
  `customfield9` mediumtext NOT NULL,
  `customfield10` mediumtext NOT NULL,
  `customfield11` mediumtext NOT NULL,
  `customfield12` mediumtext NOT NULL,
  `customfield13` mediumtext NOT NULL,
  `customfield14` mediumtext NOT NULL,
  `customfield15` mediumtext NOT NULL,
  `customfield16` mediumtext NOT NULL,
  `customfield17` mediumtext NOT NULL,
  `customfield18` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentid` (`parentid`),
  KEY `content_template_fk` (`templateid`),
  KEY `content_parent_content_fk` (`parentid`),
  KEY `content_status_fk` (`statusid`),
  KEY `content_createdby_fk` (`createdby`),
  KEY `content_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `content_parent_content_fk` FOREIGN KEY (`parentid`) REFERENCES `content` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_status_fk` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_template_fk` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3  DEFAULT CHARSET=latin1;


CREATE TABLE `content_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `contentid2` int(11) NOT NULL,
  `desc` varchar(255) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,

  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`,`contentid2`),
  KEY `content_content_contentid_fk` (`contentid`),
  KEY `content_content_contentid2_fk` (`contentid2`),
  KEY `content_content_createdby_fk` (`createdby`),
  KEY `content_content_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `content_content_contentid2_fk` FOREIGN KEY (`contentid2`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_content_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_content_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_content_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `content_customfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `typeid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `displayname` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `defaultvalue` mediumtext NOT NULL,
  `options` text NOT NULL,
  `displayorder` int(4) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,

  PRIMARY KEY (`id`),
  KEY `content_customfields_contentid_fk` (`contentid`),
  KEY `content_customfields_typeid_fk` (`typeid`),
  KEY `content_customfields_createdby_fk` (`createdby`),
  KEY `content_customfields_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `content_customfields_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_customfields_typeid_fk` FOREIGN KEY (`typeid`) REFERENCES `customfieldtypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_customfields_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_customfields_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `content_media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `mediaid` int(11) NOT NULL,
  `usage_type` varchar(255) NOT NULL,
  `credits` mediumtext NOT NULL,
  `caption` varchar(255) NOT NULL,
  `displayorder` int(4) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `mediaid` (`mediaid`),
  KEY `content_media_contentid_fk` (`contentid`),
  KEY `content_media_mediaid_fk` (`mediaid`),
  KEY `content_media_createdby_fk` (`createdby`),
  KEY `content_media_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `content_media_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_media_mediaid_fk` FOREIGN KEY (`mediaid`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_media_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_media_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `content_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `termid` int(11) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `tagid` (`termid`),
  KEY `content_terms_contentid_fk` (`contentid`),
  KEY `content_terms_termid_fk` (`termid`),
  KEY `content_terms_createdby_fk` (`createdby`),
  CONSTRAINT `content_terms_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_terms_termid_fk` FOREIGN KEY (`termid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_terms_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `content_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `userid` (`userid`),
  KEY `content_users_userid_fk` (`userid`),
  KEY `content_users_contentid_fk` (`contentid`),
  KEY `content_users_createdby_fk` (`createdby`),
  CONSTRAINT `content_users_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_users_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `customfieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `customfieldgroups_createdby_fk` (`createdby`),
  KEY `customfieldgroups_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `customfieldgroups_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `customfieldgroups_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


CREATE TABLE `customfields` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `typeid` int(11) NOT NULL,
  `groupid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `displayname` varchar(255) NOT NULL,
  `options` text NOT NULL,
  `defaultvalue` text NOT NULL,
  `visible` int(1) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `customfield_type_fk` (`typeid`),
  KEY `customfield_group_fk` (`groupid`),
  KEY `customfields_createdby_fk` (`createdby`),
  KEY `customfields_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `customfield_group_fk` FOREIGN KEY (`groupid`) REFERENCES `customfieldgroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `customfield_type_fk` FOREIGN KEY (`typeid`) REFERENCES `customfieldtypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `customfields_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `customfields_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;


CREATE TABLE `customfieldtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `sqltypes` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;


CREATE TABLE `fonts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `device` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `mimetypeid` int(11) NOT NULL,
  `extension` varchar(255) NOT NULL,
  `size` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `playtime` float NOT NULL,
  `path` varchar(255) NOT NULL,
  `thumb` varchar(255) NOT NULL,
  `video_proxy` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` bigint(20) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `media_mimetype_fk` (`mimetypeid`),
  KEY `media_createdby_fk` (`createdby`),
  KEY `media_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `media_mimetype_fk` FOREIGN KEY (`mimetypeid`) REFERENCES `mimetypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `media_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `media_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;


CREATE TABLE `media_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mediaid` int(11) NOT NULL,
  `termid` int(11) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mediaid` (`mediaid`),
  KEY `termid` (`termid`),
  KEY `media_terms_mediaid_fk` (`mediaid`),
  KEY `media_terms_termid_fk` (`termid`),
  KEY `media_terms_createdby_fk` (`createdby`),
  CONSTRAINT `media_terms_mediaid_fk` FOREIGN KEY (`mediaid`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `media_terms_termid_fk` FOREIGN KEY (`termid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `media_terms_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `mimetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `extensions` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;


CREATE TABLE `permgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permgroup` varchar(255) NOT NULL,
  `displayorder` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


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


CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) NOT NULL,
  `displayorder` int(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;


CREATE TABLE `template_customfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `templateid` int(11) NOT NULL,
  `customfieldid` int(11) NOT NULL,
  `fieldid` int(11) NOT NULL COMMENT 'The customfield(x) number',
  `displayorder` int(4) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templateid` (`templateid`),
  KEY `customfieldid` (`customfieldid`),
  KEY `template_customfields_templateid_fk` (`templateid`),
  KEY `template_customfields_customfieldid_fk` (`customfieldid`),
  KEY `template_customfields_createdby_fk` (`createdby`),
  KEY `template_customfields_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `template_customfields_customfieldid_fk` FOREIGN KEY (`customfieldid`) REFERENCES `customfields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_customfields_templateid_fk` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_customfields_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `template_customfields_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


CREATE TABLE `templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `classname` varchar(255) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `template_createdby_fk` (`createdby`),
  KEY `template_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `template_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `template_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;


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
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `termid` (`termid`),
  KEY `parentid` (`parentid`),
  KEY `term_taxonomy_termid_fk` (`termid`),
  KEY `term_taxonomy_parent_term_taxonomy_fk` (`parentid`),
  KEY `term_taxonomy_createdby_fk` (`createdby`),
  KEY `term_taxonomy_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `term_taxonomy_parent_term_taxonomy_fk` FOREIGN KEY (`parentid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `term_taxonomy_termid_fk` FOREIGN KEY (`termid`) REFERENCES `terms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `term_taxonomy_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `term_taxonomy_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;


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
  `mobile` varchar(20) CHARACTER SET latin1 NOT NULL,
  `fax` varchar(20) CHARACTER SET latin1 NOT NULL,
  `dateofbirth` int(11) NOT NULL,
  `password` varchar(255) CHARACTER SET latin1 NOT NULL,
  `lastlogin` int(11) NOT NULL,
  `active` int(2) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usergroupid` (`usergroupid`),
  KEY `user_usergroup_fk` (`usergroupid`),
  KEY `user_createdby_fk` (`createdby`),
  KEY `user_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `user_usergroup_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


CREATE TABLE `user_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  `deleted` int(1) NOT NULL,
  KEY `id` (`id`),
  KEY `user_notes_userid_fk` (`userid`),
  CONSTRAINT `user_notes_userid_fk` FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `user_usercategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  KEY `categoryid` (`categoryid`),
  KEY `user_usercategories_userid_fk` (`userid`),
  KEY `user_usercategories_categoryid_fk` (`categoryid`),
  KEY `user_usercategories_createdby_fk` (`createdby`),
  CONSTRAINT `userusercategories_categoryid_fk` FOREIGN KEY (`categoryid`) REFERENCES `usercategories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userusercategories_userid_fk` FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_usercategories_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `usercategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usergroupid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usercategories_usergroupid_fk` (`usergroupid`),
  KEY `usercategories_createdby_fk` (`createdby`),
  KEY `usercategories_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `usercategories_usergroupid_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usercategories_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `usercategories_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `usergroup_perms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usergroupid` int(11) NOT NULL,
  `permid` int(11) NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usergroupid` (`usergroupid`),
  KEY `permid` (`permid`),
  KEY `usergroup_id` (`usergroupid`),
  KEY `usergroup_perms_usergroupid_fk` (`usergroupid`),
  KEY `usergroup_perms_permid_fk` (`permid`),
  KEY `usergroup_perms_createdby_fk` (`createdby`),
  CONSTRAINT `usergroup_perms_permid_fk` FOREIGN KEY (`permid`) REFERENCES `perms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usergroup_perms_usergroupid_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usergroup_perms_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(11) NOT NULL,
  `usergroup` varchar(255) CHARACTER SET latin1 NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentid` (`parentid`),
  KEY `usergroups_parent_usergroups_fk` (`parentid`),
  KEY `usergroups_createdby_fk` (`createdby`),
  KEY `usergroups_modifiedby_fk` (`modifiedby`),
  CONSTRAINT `usergroups_parent_usergroups_fk` FOREIGN KEY (`parentid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usergroups_createdby_fk` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `usergroups_modifiedby_fk` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;





LOCK TABLES `config` WRITE;
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (1, 'Media', 'ON', 0);
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (2, 'Users', 'ON', 0);
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (3, 'Fonts', 'OFF', 0);
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (4, 'Tags', 'ON', 0);
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (5, 'Contacts', 'OFF', 0);
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (7, 'Custom Fields', 'OFF', 0);
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (8, 'Events', 'OFF', 0);
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (9, 'configfile', 'xml/config.xml', 0);
INSERT INTO `config` (`id`, `name`, `value`, `system`) VALUES (10, 'prompt', 'New Deal Design', 0);
UNLOCK TABLES;


LOCK TABLES `content` WRITE;
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (1, 1, 1, 'Rootsss', 4, '', 0, 1, 1, 0, 0, 1, 1, 1, 0, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (2, 2, 2, 'FAQs', 4, 'FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs', 0, 1, 0, 0, 1269375147, 1, 1, 1, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
UNLOCK TABLES;


LOCK TABLES `customfieldtypes` WRITE;
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (1, 'binary', 'int(1)');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (2, 'select', 'varchar(10)');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (3, 'string', 'varchar(255)');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (4, 'html-text', 'longtext,mediumtext');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (5, 'multiple-select', 'varchar(255)');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (6, 'color', 'int(11)');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (7, 'text', 'longtext,mediumtext');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (8, 'date', 'bigint(20)');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (9, 'integer', 'int(11),bigint(20)');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (10, 'file-link', 'varch(255)');
INSERT INTO `customfieldtypes` (`id`, `type`, `sqltypes`) VALUES (11, 'multiple-select-with-order', 'varch(255)');
UNLOCK TABLES;


LOCK TABLES `mimetypes` WRITE;
INSERT INTO `mimetypes` (`id`, `name`, `extensions`) VALUES (1, 'images', 'jpg,jpeg, gif,png');
INSERT INTO `mimetypes` (`id`, `name`, `extensions`) VALUES (2, 'videos', 'flv,mov,mp4,m4v,f4v');
INSERT INTO `mimetypes` (`id`, `name`, `extensions`) VALUES (3, 'audio', 'mp3');
INSERT INTO `mimetypes` (`id`, `name`, `extensions`) VALUES (4, 'swf', '');
INSERT INTO `mimetypes` (`id`, `name`, `extensions`) VALUES (5, 'file', '');
INSERT INTO `mimetypes` (`id`, `name`, `extensions`) VALUES (6, 'youtube', '');
INSERT INTO `mimetypes` (`id`, `name`, `extensions`) VALUES (7, 'font', 'ttf,otf');
UNLOCK TABLES;


LOCK TABLES `statuses` WRITE;
INSERT INTO `statuses` (`id`, `status`, `displayorder`) VALUES (1, 'Draft', 0);
INSERT INTO `statuses` (`id`, `status`, `displayorder`) VALUES (2, 'Awaiting Approval', 0);
INSERT INTO `statuses` (`id`, `status`, `displayorder`) VALUES (3, 'Published (Internal Only)', 0);
INSERT INTO `statuses` (`id`, `status`, `displayorder`) VALUES (4, 'Published', 0);
UNLOCK TABLES;


LOCK TABLES `templates` WRITE;
INSERT INTO `templates` (`id`, `name`, `classname`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (1, 'Default', '', 1, 1267733775, 1, 1267733775);
INSERT INTO `templates` (`id`, `name`, `classname`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (2, 'FAQ', '', 1, 1267733775, 1, 1267733775);
UNLOCK TABLES;


LOCK TABLES `usergroups` WRITE;
INSERT INTO `usergroups` (`id`, `parentid`, `usergroup`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (1, 1, 'MiG Group', 1, 123421421, 1, 123421421);
INSERT INTO `usergroups` (`id`, `parentid`, `usergroup`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (2, 2, 'Front End Group', 1, 123421421, 1, 123421421);
INSERT INTO `usergroups` (`id`, `parentid`, `usergroup`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (3, 1, 'Administrator', 1, 123421421, 1, 123421421);
INSERT INTO `usergroups` (`id`, `parentid`, `usergroup`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (4, 1, 'Writer 1', 1, 123421421, 1, 123421421);
INSERT INTO `usergroups` (`id`, `parentid`, `usergroup`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (5, 1, 'Writer 2', 1, 123421421, 1, 123421421);
INSERT INTO `usergroups` (`id`, `parentid`, `usergroup`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (6, 1, 'Reader', 1, 123421421, 1, 123421421);
INSERT INTO `usergroups` (`id`, `parentid`, `usergroup`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (7, 2, 'Front End', 1, 123421421, 1, 123421421);
INSERT INTO `usergroups` (`id`, `parentid`, `usergroup`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (8, 1, 'MiG Admin', 1, 123421421, 1, 123421421);
UNLOCK TABLES;




SET FOREIGN_KEY_CHECKS = 1;