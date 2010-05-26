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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;


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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;


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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;


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
) ENGINE=InnoDB AUTO_INCREMENT=538 DEFAULT CHARSET=latin1;


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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;


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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


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
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (3, 1, 1, 'Projects', 4, 'Root', 0, 1, 0, 0, 1269465079, 5, 1, 1, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (4, 1, 1, 'Posts', 4, 'Root', 0, 1, 0, 0, 1269465079, 5, 1, 1, 2, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (5, 1, 1, 'Awards', 4, 'Root', 0, 1, 0, 0, 1269969370, 6, 1, 1, 3, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (6, 1, 1, 'Media', 4, 'Root', 0, 1, 0, 0, 1269528892, 5, 1, 1, 4, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (7, 1, 1, 'Stream', 4, 'Root', 0, 1, 0, 0, 1270072016, 5, 1, 1, 5, '', 'newdealdesign,newdealstudio,gadiamit', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (8, 1, 1, 'About Us', 4, 'Root', 0, 1, 0, 0, 1270076546, 6, 1, 1, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (9, 1, 1, 'Contact', 4, 'Root', 0, 1, 0, 0, 1269548152, 5, 1, 1, 7, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (10, 3, 1, 'Fitbit Tracker', 4, 'Root<>Projects', 0, 0, 1, 1267733775, 1270076443, 6, 0, 0, 2, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (11, 3, 1, 'Dell Studio Hybrid', 4, 'Root<>Projects', 1, 0, 1, 1267733782, 1269960909, 5, 0, 0, 3, '1,3,2,4', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (12, 3, 1, 'Ogo', 4, 'Root<>Projects', 0, 0, 1, 1267733790, 1269960920, 5, 0, 0, 4, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (13, 3, 1, 'Tana Water Bar', 4, 'Root<>Projects', 1, 0, 1, 1267733775, 1268923510, 5, 0, 0, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (14, 5, 1, 'Red Dot 09', 4, 'Root<>Awards', 1, 0, 1, 1267733907, 1269632296, 6, 0, 0, 2, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (15, 5, 1, 'Index 09', 4, 'Root<>Awards', 1, 0, 1, 1267733912, 1269632324, 6, 0, 0, 3, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (16, 5, 1, 'Index Finalist 09', 4, 'Root<>Awards', 1, 0, 1, 1267733917, 1269632330, 6, 0, 0, 4, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (17, 5, 1, 'Award 4', 4, 'Root<>Awards', 1, 0, 1, 1268674034, 1269632346, 6, 0, 0, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (18, 4, 1, 'Fire, Agriculture, Design: How Human Creativity Built Society', 4, 'Root<>Posts', 0, 0, 1, 1267733885, 1269634962, 5, 0, 0, 7, 'Test Author', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (19, 4, 1, 'Apple may change the world&#8230; again.', 4, 'Root<>Posts', 0, 0, 1, 1267733893, 1269642124, 6, 0, 0, 8, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (20, 4, 1, 'Making sense of Design Thinking: Three definitions, two problems and one big question', 4, 'Root<>Posts', 0, 0, 1, 1267733899, 1269044089, 6, 0, 0, 9, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (138, 3, 1, 'raed', 4, 'Root<>Projects', 1, 0, 1, 1268928037, 1268937842, 5, 0, 0, 4, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (139, 3, 1, 'Better Place', 4, 'Root<>Projects', 0, 0, 6, 1269024866, 1269988503, 6, 0, 0, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (140, 3, 1, 'Memorex Clock', 4, 'Root<>Projects', 0, 0, 6, 1269027605, 1269563404, 6, 0, 0, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (141, 3, 1, 'Glide TV', 4, 'Root<>Projects', 0, 0, 6, 1269032892, 1269046255, 6, 0, 0, 7, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (142, 3, 1, 'Cocoon', 4, 'Root<>Projects', 0, 0, 6, 1269033310, 1269046255, 6, 0, 0, 8, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (143, 3, 1, 'Fujitsu Phones', 4, 'Root<>Projects', 0, 0, 6, 1269037352, 1269046255, 6, 0, 0, 9, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (144, 3, 1, 'Dell Latitude', 4, 'Root<>Projects', 0, 0, 6, 1269039248, 1269622692, 6, 0, 0, 10, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (145, 3, 1, 'Netgear', 4, 'Root<>Projects', 0, 0, 6, 1269040389, 1269046255, 6, 0, 0, 11, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (146, 4, 1, 'Dear Gadget Reviewers: You Don\\\'t Understand Beauty', 4, 'Root<>Posts', 0, 0, 6, 1269042460, 1269044089, 6, 0, 0, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (147, 4, 1, 'Team', 4, 'Root<>Posts', 1, 0, 6, 1269042927, 1269043262, 6, 0, 0, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (148, 4, 1, 'Looking at the Micro vs. the Macro in Design', 4, 'Root<>Posts', 0, 0, 6, 1269043323, 1269642183, 6, 0, 0, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (149, 4, 1, '\\"Shop Class as Soulcraft\\": A Book That Revels in Alternative Thinking for Designers', 4, 'Root<>Posts', 0, 0, 6, 1269043499, 1269044089, 6, 0, 0, 4, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (150, 4, 1, 'Body Computing Is a Glimmer of Hope in the Health-Care Chasm', 4, 'Root<>Posts', 0, 0, 6, 1269043664, 1269044089, 6, 0, 0, 3, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (151, 4, 1, 'In Defense of Slapping a Robot', 4, 'Root<>Posts', 0, 0, 6, 1269043884, 1269642214, 6, 0, 0, 2, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (152, 4, 1, 'How Should We Define \\"Design\\"?', 4, 'Root<>Posts', 0, 0, 6, 1269044089, 1269044230, 6, 0, 0, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (153, 3, 1, 'Sling Media', 4, 'Root<>Projects', 0, 0, 6, 1269044543, 1269046255, 6, 0, 0, 12, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (154, 3, 1, 'Logitech', 4, 'Root<>Projects', 0, 0, 6, 1269046254, 1269635596, 3, 0, 0, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (155, 5, 1, 'Red Dot', 4, 'Root<>Awards', 0, 0, 6, 1269632366, 1269989043, 6, 0, 0, 2, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (156, 5, 1, 'Index', 4, 'Root<>Awards', 0, 0, 6, 1269632635, 1269989043, 6, 0, 0, 3, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (157, 5, 1, 'Idea Gold', 4, 'Root<>Awards', 0, 0, 6, 1269632733, 1269989043, 6, 0, 0, 4, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (158, 5, 1, 'IDEA Silver', 4, 'Root<>Awards', 0, 0, 6, 1269633019, 1269989043, 6, 0, 0, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (159, 5, 1, 'IDEA Finalist-Medical', 4, 'Root<>Awards', 0, 0, 6, 1269633324, 1269989436, 6, 0, 0, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (160, 5, 1, 'ID Magazine Honorable Mention', 4, 'Root<>Awards', 0, 0, 6, 1269633400, 1269989043, 6, 0, 0, 7, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (161, 5, 1, 'Brit Insurance Design of the Year Finalist', 4, 'Root<>Awards', 0, 0, 6, 1269968498, 1269989043, 6, 0, 0, 8, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (162, 5, 1, 'Innovations Design and Engineering Awards Honorees', 4, 'Root<>Awards', 0, 0, 6, 1269969352, 1270076098, 6, 0, 0, 9, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (163, 5, 1, 'CES Innovation award / Best of Innovation', 4, 'Root<>Awards', 0, 0, 6, 1269969920, 1269989043, 6, 0, 0, 10, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` (`id`, `parentid`, `templateid`, `migtitle`, `statusid`, `containerpath`, `deleted`, `is_fixed`, `createdby`, `createdate`, `modifieddate`, `modifiedby`, `search_exclude`, `can_have_children`, `displayorder`, `customfield1`, `customfield2`, `customfield3`, `customfield4`, `customfield5`, `customfield6`, `customfield7`, `customfield8`, `customfield9`, `customfield10`, `customfield11`, `customfield12`, `customfield13`, `customfield14`, `customfield15`, `customfield16`, `customfield17`, `customfield18`) VALUES (164, 5, 1, 'IDEA Finalist-Recreation', 4, 'Root<>Awards', 0, 0, 6, 1269989043, 1269989043, 6, 0, 0, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
UNLOCK TABLES;


LOCK TABLES `content_content` WRITE;
UNLOCK TABLES;


LOCK TABLES `content_customfields` WRITE;
UNLOCK TABLES;


LOCK TABLES `content_media` WRITE;
INSERT INTO `content_media` (`id`, `contentid`, `mediaid`, `usage_type`, `credits`, `caption`, `displayorder`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (1, 14, 140, 'thumb', '', '', 0, 0, 0, 0, 0);
UNLOCK TABLES;


LOCK TABLES `content_terms` WRITE;
UNLOCK TABLES;


LOCK TABLES `content_users` WRITE;
UNLOCK TABLES;


LOCK TABLES `customfieldgroups` WRITE;
INSERT INTO `customfieldgroups` (`id`, `name`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (1, 'Default', 1, 1267733775, 1, 1267733775);
UNLOCK TABLES;


LOCK TABLES `customfields` WRITE;
INSERT INTO `customfields` (`id`, `typeid`, `groupid`, `name`, `displayname`, `options`, `defaultvalue`, `visible`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (1, 3, 1, 'title', 'Title', '', '', 1, 1, 1267733775, 1, 1267733775);
INSERT INTO `customfields` (`id`, `typeid`, `groupid`, `name`, `displayname`, `options`, `defaultvalue`, `visible`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (2, 3, 1, 'url', 'URL', '', '', 1, 1, 1267733775, 1, 1267733775);
INSERT INTO `customfields` (`id`, `typeid`, `groupid`, `name`, `displayname`, `options`, `defaultvalue`, `visible`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (3, 4, 1, 'description', 'Description', '', '', 1, 1, 1267733775, 1, 1267733775);
INSERT INTO `customfields` (`id`, `typeid`, `groupid`, `name`, `displayname`, `options`, `defaultvalue`, `visible`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (4, 4, 1, 'shortdescription', 'Short Description', '', '', 1, 1, 1267733775, 1, 1267733775);
INSERT INTO `customfields` (`id`, `typeid`, `groupid`, `name`, `displayname`, `options`, `defaultvalue`, `visible`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (5, 7, 1, 'description2', 'Unformatted Description', '', '', 0, 1, 1267733775, 1, 1267733775);
INSERT INTO `customfields` (`id`, `typeid`, `groupid`, `name`, `displayname`, `options`, `defaultvalue`, `visible`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (6, 7, 1, 'shortdescription2', 'Unformatted Short Description', '', '', 0, 1, 1267733775, 1, 1267733775);
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


LOCK TABLES `fonts` WRITE;
UNLOCK TABLES;


LOCK TABLES `media` WRITE;
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (139, 'Better_Place01.jpg', 1, 'jpg', 135372, 0, 0, 0, '/betterplace/', 'Better_Place01.jpg', '', '', 6, 1269560526, 6, 1269560526);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (140, 'Better_Place03.jpg', 1, 'jpg', 18715, 0, 0, 0, '/betterplace/', 'Better_Place03.jpg', '', '', 6, 1269560536, 6, 1269560536);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (141, 'Better_Place02.jpg', 1, 'jpg', 43500, 0, 0, 0, '/betterplace/', 'Better_Place02.jpg', '', '', 6, 1269560539, 6, 1269560539);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (142, 'Better_Place05.jpg', 1, 'jpg', 60893, 0, 0, 0, '/betterplace/', 'Better_Place05.jpg', '', '', 6, 1269560553, 6, 1269560553);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (143, 'Better_Place04.jpg', 1, 'jpg', 20474, 0, 0, 0, '/betterplace/', 'Better_Place04.jpg', '', '', 6, 1269560555, 6, 1269560555);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (145, 'Better_Place06.jpg', 1, 'jpg', 119085, 0, 0, 0, '/betterplace/', 'Better_Place06.jpg', '', '', 6, 1269560570, 6, 1269560570);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (146, 'Fitbit_05.jpg', 1, 'jpg', 97224, 0, 0, 0, '/fitbit/', 'Fitbit_05.jpg', '', '', 6, 1269561539, 6, 1269561539);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (147, 'Fitbit_06.jpg', 1, 'jpg', 64968, 0, 0, 0, '/fitbit/', 'Fitbit_06.jpg', '', '', 6, 1269561541, 6, 1269561541);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (148, 'Fitbit_04.jpg', 1, 'jpg', 366988, 0, 0, 0, '/fitbit/', 'Fitbit_04.jpg', '', '', 6, 1269561548, 6, 1269561548);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (149, 'Fitbit_01.jpg', 1, 'jpg', 71461, 0, 0, 0, '/fitbit/', 'Fitbit_01.jpg', '', '', 6, 1269561550, 6, 1269561550);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (150, 'Fitbit_02.jpg', 1, 'jpg', 52001, 0, 0, 0, '/fitbit/', 'Fitbit_02.jpg', '', '', 6, 1269561552, 6, 1269561552);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (151, 'Fitbit_03.jpg', 1, 'jpg', 54348, 0, 0, 0, '/fitbit/', 'Fitbit_03.jpg', '', '', 6, 1269561554, 6, 1269561554);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (152, 'Fitbit_thumb.jpg', 1, 'jpg', 4326, 0, 0, 0, '/fitbit/', 'Fitbit_thumb.jpg', '', '', 6, 1269561683, 6, 1269561683);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (153, 'BetterPlace_I_thumb.jpg', 1, 'jpg', 8894, 0, 0, 0, '/betterplace/', 'BetterPlace_I_thumb.jpg', '', '', 6, 1269561731, 6, 1269561731);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (154, 'DellBamboo_thumb.jpg', 1, 'jpg', 10525, 0, 0, 0, '/dellhybridstudio/', 'DellBamboo_thumb.jpg', '', '', 6, 1269562374, 6, 1269562374);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (155, 'dellhybrid01.jpg', 1, 'jpg', 72463, 0, 0, 0, '/dellhybridstudio/', 'dellhybrid01.jpg', '', '', 6, 1269562395, 6, 1269562395);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (156, 'dellhybrid02.jpg', 1, 'jpg', 247949, 0, 0, 0, '/dellhybridstudio/', 'dellhybrid02.jpg', '', '', 6, 1269562407, 6, 1269562407);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (157, 'dellhybrid03.jpg', 1, 'jpg', 128699, 0, 0, 0, '/dellhybridstudio/', 'dellhybrid03.jpg', '', '', 6, 1269562423, 6, 1269562423);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (158, 'dellhybrid04.jpg', 1, 'jpg', 64368, 0, 0, 0, '/dellhybridstudio/', 'dellhybrid04.jpg', '', '', 6, 1269562425, 6, 1269562425);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (159, 'dellhybrid05.jpg', 1, 'jpg', 70038, 0, 0, 0, '/dellhybridstudio/', 'dellhybrid05.jpg', '', '', 6, 1269562427, 6, 1269562427);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (168, 'Memorex_01.jpg', 1, 'jpg', 129002, 0, 0, 0, '/memorexclock/', 'Memorex_01.jpg', '', '', 6, 1269563275, 6, 1269563275);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (169, 'Memorex_02.jpg', 1, 'jpg', 122311, 0, 0, 0, '/memorexclock/', 'Memorex_02.jpg', '', '', 6, 1269563286, 6, 1269563286);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (170, 'Memorex_04.jpg', 1, 'jpg', 73133, 0, 0, 0, '/memorexclock/', 'Memorex_04.jpg', '', '', 6, 1269563296, 6, 1269563296);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (171, 'Memorex_03.jpg', 1, 'jpg', 36838, 0, 0, 0, '/memorexclock/', 'Memorex_03.jpg', '', '', 6, 1269563298, 6, 1269563298);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (172, 'Memorex_05.jpg', 1, 'jpg', 84822, 0, 0, 0, '/memorexclock/', 'Memorex_05.jpg', '', '', 6, 1269563308, 6, 1269563308);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (173, 'Memorex_thumb.jpg', 1, 'jpg', 6955, 0, 0, 0, '/memorexclock/', 'Memorex_thumb.jpg', '', '', 6, 1269563374, 6, 1269563374);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (174, 'glidetv03.jpg', 1, 'jpg', 52937, 0, 0, 0, '/glidetv/', 'glidetv03.jpg', '', '', 6, 1269564098, 6, 1269564098);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (175, 'glidetv01.jpg', 1, 'jpg', 73515, 0, 0, 0, '/glidetv/', 'glidetv01.jpg', '', '', 6, 1269564100, 6, 1269564100);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (176, 'glidetv02.jpg', 1, 'jpg', 65284, 0, 0, 0, '/glidetv/', 'glidetv02.jpg', '', '', 6, 1269564103, 6, 1269564103);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (177, 'glidetv06.jpg', 1, 'jpg', 61471, 0, 0, 0, '/glidetv/', 'glidetv06.jpg', '', '', 6, 1269564105, 6, 1269564105);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (178, 'glidetv04.jpg', 1, 'jpg', 122516, 0, 0, 0, '/glidetv/', 'glidetv04.jpg', '', '', 6, 1269564108, 6, 1269564108);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (179, 'glidetv05.jpg', 1, 'jpg', 63752, 0, 0, 0, '/glidetv/', 'glidetv05.jpg', '', '', 6, 1269564110, 6, 1269564110);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (180, 'glidetv_thumb.jpg', 1, 'jpg', 4727, 0, 0, 0, '/glidetv/', 'glidetv_thumb.jpg', '', '', 6, 1269564164, 6, 1269564164);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (181, 'fujitsu04.jpg', 1, 'jpg', 64007, 0, 0, 0, '/fujitsuphones/', 'fujitsu04.jpg', '', '', 6, 1269564595, 6, 1269564595);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (182, 'fujitsu02.jpg', 1, 'jpg', 53502, 0, 0, 0, '/fujitsuphones/', 'fujitsu02.jpg', '', '', 6, 1269564597, 6, 1269564597);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (183, 'fujitsu03.jpg', 1, 'jpg', 44813, 0, 0, 0, '/fujitsuphones/', 'fujitsu03.jpg', '', '', 6, 1269564599, 6, 1269564599);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (184, 'fujitsu05.jpg', 1, 'jpg', 45048, 0, 0, 0, '/fujitsuphones/', 'fujitsu05.jpg', '', '', 6, 1269564601, 6, 1269564601);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (185, 'fujitsu01.jpg', 1, 'jpg', 65204, 0, 0, 0, '/fujitsuphones/', 'fujitsu01.jpg', '', '', 6, 1269564603, 6, 1269564603);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (186, 'fujitsu06.jpg', 1, 'jpg', 38960, 0, 0, 0, '/fujitsuphones/', 'fujitsu06.jpg', '', '', 6, 1269564605, 6, 1269564605);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (187, 'fujitsu_thumb.jpg', 1, 'jpg', 4246, 0, 0, 0, '/fujitsuphones/', 'fujitsu_thumb.jpg', '', '', 6, 1269564616, 6, 1269564616);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (188, 'cocoon03.jpg', 1, 'jpg', 74919, 0, 0, 0, '/cocoon/', 'cocoon03.jpg', '', '', 6, 1269564968, 6, 1269564968);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (189, 'cocoon01.jpg', 1, 'jpg', 91876, 0, 0, 0, '/cocoon/', 'cocoon01.jpg', '', '', 6, 1269564970, 6, 1269564970);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (190, 'cocoon02.jpg', 1, 'jpg', 94448, 0, 0, 0, '/cocoon/', 'cocoon02.jpg', '', '', 6, 1269564973, 6, 1269564973);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (191, 'cocoon04.jpg', 1, 'jpg', 48378, 0, 0, 0, '/cocoon/', 'cocoon04.jpg', '', '', 6, 1269564975, 6, 1269564975);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (192, 'cocoon05.jpg', 1, 'jpg', 78970, 0, 0, 0, '/cocoon/', 'cocoon05.jpg', '', '', 6, 1269564977, 6, 1269564977);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (193, 'cocoon_family5_thumb.jpg', 1, 'jpg', 5842, 0, 0, 0, '/cocoon/', 'cocoon_family5_thumb.jpg', '', '', 6, 1269564988, 6, 1269564988);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (199, 'DellLat04.jpg', 1, 'jpg', 155624, 0, 0, 0, '/delllatitude/', 'DellLat04.jpg', '', '', 6, 1269622540, 6, 1269622540);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (200, 'DellLat02.jpg', 1, 'jpg', 87319, 0, 0, 0, '/delllatitude/', 'DellLat02.jpg', '', '', 6, 1269622543, 6, 1269622543);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (201, 'DellLat03.jpg', 1, 'jpg', 70650, 0, 0, 0, '/delllatitude/', 'DellLat03.jpg', '', '', 6, 1269622546, 6, 1269622546);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (202, 'DellLat01.jpg', 1, 'jpg', 61565, 0, 0, 0, '/delllatitude/', 'DellLat01.jpg', '', '', 6, 1269622548, 6, 1269622548);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (203, 'DellLat_thumb.jpg', 1, 'jpg', 4253, 0, 0, 0, '/delllatitude/', 'DellLat_thumb.jpg', '', '', 6, 1269622560, 6, 1269622560);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (204, 'Netgear_thumb.jpg', 1, 'jpg', 6435, 0, 0, 0, '/netgear/', 'Netgear_thumb.jpg', '', '', 6, 1269623235, 6, 1269623235);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (205, 'Netgear_01.jpg', 1, 'jpg', 33329, 0, 0, 0, '/netgear/', 'Netgear_01.jpg', '', '', 6, 1269623256, 6, 1269623256);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (206, 'Netgear_02.jpg', 1, 'jpg', 48931, 0, 0, 0, '/netgear/', 'Netgear_02.jpg', '', '', 6, 1269623258, 6, 1269623258);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (207, 'Netgear_03.jpg', 1, 'jpg', 58096, 0, 0, 0, '/netgear/', 'Netgear_03.jpg', '', '', 6, 1269623270, 6, 1269623270);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (208, 'Netgear_05.jpg', 1, 'jpg', 50163, 0, 0, 0, '/netgear/', 'Netgear_05.jpg', '', '', 6, 1269623283, 6, 1269623283);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (209, 'Netgear_04.jpg', 1, 'jpg', 58947, 0, 0, 0, '/netgear/', 'Netgear_04.jpg', '', '', 6, 1269623285, 6, 1269623285);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (210, 'Netgear_06.jpg', 1, 'jpg', 266954, 0, 0, 0, '/netgear/', 'Netgear_06.jpg', '', '', 6, 1269623325, 6, 1269623325);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (211, 'sling02.jpg', 1, 'jpg', 75185, 0, 0, 0, '/slingmedia/', 'sling02.jpg', '', '', 6, 1269623997, 6, 1269623997);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (212, 'sling01.jpg', 1, 'jpg', 83408, 0, 0, 0, '/slingmedia/', 'sling01.jpg', '', '', 6, 1269624000, 6, 1269624000);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (213, 'sling05.jpg', 1, 'jpg', 79241, 0, 0, 0, '/slingmedia/', 'sling05.jpg', '', '', 6, 1269624016, 6, 1269624016);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (214, 'sling03.jpg', 1, 'jpg', 55170, 0, 0, 0, '/slingmedia/', 'sling03.jpg', '', '', 6, 1269624019, 6, 1269624019);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (215, 'sling04.jpg', 1, 'jpg', 21475, 0, 0, 0, '/slingmedia/', 'sling04.jpg', '', '', 6, 1269624020, 6, 1269624020);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (216, 'sling06.jpg', 1, 'jpg', 106744, 0, 0, 0, '/slingmedia/', 'sling06.jpg', '', '', 6, 1269624037, 6, 1269624037);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (217, 'sling07.jpg', 1, 'jpg', 58766, 0, 0, 0, '/slingmedia/', 'sling07.jpg', '', '', 6, 1269624054, 6, 1269624054);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (218, 'sling08.jpg', 1, 'jpg', 74011, 0, 0, 0, '/slingmedia/', 'sling08.jpg', '', '', 6, 1269624056, 6, 1269624056);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (219, 'sling09.jpg', 1, 'jpg', 439709, 0, 0, 0, '/slingmedia/', 'sling09.jpg', '', '', 6, 1269624075, 6, 1269624075);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (220, 'sling_thumb.jpg', 1, 'jpg', 3931, 0, 0, 0, '/slingmedia/', 'sling_thumb.jpg', '', '', 6, 1269624089, 6, 1269624089);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (221, 'logitech01.jpg', 1, 'jpg', 133178, 0, 0, 0, '/Logitech/', 'logitech01.jpg', '', '', 6, 1269624689, 6, 1269624689);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (222, 'logitech02.jpg', 1, 'jpg', 172582, 0, 0, 0, '/Logitech/', 'logitech02.jpg', '', '', 6, 1269624702, 6, 1269624702);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (223, 'logitech03.jpg', 1, 'jpg', 418742, 0, 0, 0, '/Logitech/', 'logitech03.jpg', '', '', 6, 1269624717, 6, 1269624717);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (224, 'logitech04.jpg', 1, 'jpg', 164383, 0, 0, 0, '/Logitech/', 'logitech04.jpg', '', '', 6, 1269624738, 6, 1269624738);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (225, 'logitech05.jpg', 1, 'jpg', 190042, 0, 0, 0, '/Logitech/', 'logitech05.jpg', '', '', 6, 1269624750, 6, 1269624750);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (226, 'logitech06.jpg', 1, 'jpg', 256362, 0, 0, 0, '/Logitech/', 'logitech06.jpg', '', '', 6, 1269624763, 6, 1269624763);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (227, 'logitech_thumb.jpg', 1, 'jpg', 3237, 0, 0, 0, '/Logitech/', 'logitech_thumb.jpg', '', '', 6, 1269624785, 6, 1269624785);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (228, 'gadi.jpg', 1, 'jpg', 83703, 0, 0, 0, '/about/', 'gadi.jpg', '', '', 6, 1269626602, 6, 1269626602);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (229, '2010_IDMAG.jpg', 1, 'jpg', 175209, 0, 0, 0, '/about/', '2010_IDMAG.jpg', '', '', 6, 1269627436, 6, 1269627436);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (230, 'christmas09.jpg', 1, 'jpg', 170714, 0, 0, 0, '/about/', 'christmas09.jpg', '', '', 6, 1269627454, 6, 1269627454);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (231, 'clients_shirt.jpg', 1, 'jpg', 117112, 0, 0, 0, '/about/', 'clients_shirt.jpg', '', '', 6, 1269627464, 6, 1269627464);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (232, 'gadi2.jpg', 1, 'jpg', 107182, 0, 0, 0, '/about/', 'gadi2.jpg', '', '', 6, 1269627484, 6, 1269627484);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (233, 'ghettoblast.jpg', 1, 'jpg', 117250, 0, 0, 0, '/about/', 'ghettoblast.jpg', '', '', 6, 1269627487, 6, 1269627487);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (234, 'mexico02.jpg', 1, 'jpg', 193238, 0, 0, 0, '/about/', 'mexico02.jpg', '', '', 6, 1269627504, 6, 1269627504);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (235, 'mexico01.jpg', 1, 'jpg', 91345, 0, 0, 0, '/about/', 'mexico01.jpg', '', '', 6, 1269627506, 6, 1269627506);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (236, 'office_exterior.jpg', 1, 'jpg', 158229, 0, 0, 0, '/about/', 'office_exterior.jpg', '', '', 6, 1269627519, 6, 1269627519);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (237, 'studio_interior01.jpg', 1, 'jpg', 179945, 0, 0, 0, '/about/', 'studio_interior01.jpg', '', '', 6, 1269627533, 6, 1269627533);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (238, 'studio_interior03.jpg', 1, 'jpg', 131933, 0, 0, 0, '/about/', 'studio_interior03.jpg', '', '', 6, 1269627544, 6, 1269627544);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (239, 'studio_interior02.jpg', 1, 'jpg', 140192, 0, 0, 0, '/about/', 'studio_interior02.jpg', '', '', 6, 1269627547, 6, 1269627547);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (240, 'yoshi_draw.jpg', 1, 'jpg', 172762, 0, 0, 0, '/about/', 'yoshi_draw.jpg', '', '', 6, 1269627551, 6, 1269627551);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (241, 'rumble2_7.JPG', 1, 'JPG', 409600, 0, 0, 0, '/booboo/', 'rumble2_7.JPG', 'false', '', 1, 1274196, 1, 1274196);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (242, 'smh_blkisbeautiful_mark.png', 1, 'png', 16384, 0, 0, 0, '/booboo/', 'smh_blkisbeautiful_mark.png', 'false', '', 1, 1274206392, 1, 1274206392);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (243, 'ddc_water3.jpg', 1, 'jpg', 180224, 0, 0, 0, '/booboo/', 'ddc_water3.jpg', 'false', '', 1, 1274207032, 1, 1274207032);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (244, 'ddc_water9.jpg', 1, 'jpg', 307200, 0, 0, 0, '/booboo/', 'ddc_water9.jpg', 'false', '', 1, 1274207567, 1, 1274207567);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (245, 'ddc_water8.jpg', 1, 'jpg', 253952, 0, 0, 0, '/booboo/', 'ddc_water8.jpg', 'false', '', 1, 1274207667, 1, 1274207667);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (246, 'map.png', 1, 'png', 12288, 0, 0, 0, '/booboo/', 'map.png', 'false', '', 1, 1274209965, 1, 1274209965);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (247, 'MG_0085.jpg', 1, 'jpg', 258048, 0, 0, 0, '/booboo/', 'MG_0085.jpg', 'false', '', 1, 1274210351, 1, 1274210351);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (248, 'MG_0082.jpg', 1, 'jpg', 303104, 0, 0, 0, '/booboo/', 'MG_0082.jpg', 'false', '', 1, 1274210500, 1, 1274210500);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (256, 'DCM5_DesignCouncilMagazineIssue5-1.jpg', 1, 'jpg', 65536, 0, 0, 0, '/booboo/', 'DCM5_DesignCouncilMagazineIssue5-1.jpg', 'false', '', 1, 1274213764, 1, 1274213764);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (257, 'ddc_cover.jpg', 1, 'jpg', 167936, 0, 0, 0, '/booboo/', 'ddc_cover.jpg', 'false', '', 1, 1274213765, 1, 1274213765);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (258, 'ddc_water0.jpg', 1, 'jpg', 241664, 0, 0, 0, '/booboo/', 'ddc_water0.jpg', 'false', '', 1, 1274213767, 1, 1274213767);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (259, 'ddc_water4.jpg', 1, 'jpg', 196608, 0, 0, 0, '/booboo/', 'ddc_water4.jpg', 'false', '', 1, 1274213769, 1, 1274213769);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (260, 'ddc_water5.jpg', 1, 'jpg', 225280, 0, 0, 0, '/booboo/', 'ddc_water5.jpg', 'false', '', 1, 1274213770, 1, 1274213770);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (261, 'ddc_water6.jpg', 1, 'jpg', 212992, 0, 0, 0, '/booboo/', 'ddc_water6.jpg', 'false', '', 1, 1274213772, 1, 1274213772);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (262, 'As_we_get_older_we.jpg', 1, 'jpg', 65536, 0, 0, 0, '/booboo/', 'As_we_get_older_we.jpg', 'false', '', 1, 1274214214, 1, 1274214214);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (263, 'brankica_people.jpg', 1, 'jpg', 307200, 0, 0, 0, '/booboo/', 'brankica_people.jpg', 'false', '', 1, 1274214216, 1, 1274214216);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (264, 'chinatown-nyc-700793.JPG', 1, 'JPG', 90112, 0, 0, 0, '/booboo/', 'chinatown-nyc-700793.JPG', 'false', '', 1, 1274214217, 1, 1274214217);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (265, 'DCM5_DesignCouncilMagazineIssue5-1_1.jpg', 1, 'jpg', 65536, 0, 0, 0, '/booboo/', 'DCM5_DesignCouncilMagazineIssue5-1_1.jpg', 'false', '', 1, 1274214218, 1, 1274214218);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (266, 'I.D._ADR_Cover.gif', 5, 'gif', 77824, 0, 0, 0, '/booboo/', '', 'false', '', 1, 1274214219, 1, 1274214219);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (267, 'map2.png', 1, 'png', 53248, 0, 0, 0, '/booboo/', 'map2.png', 'false', '', 1, 1274214220, 1, 1274214220);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (268, 'map_map1.png', 1, 'png', 94208, 0, 0, 0, '/booboo/', 'map_map1.png', 'false', '', 1, 1274214221, 1, 1274214221);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (269, 'map_map_clean1.png', 1, 'png', 147456, 0, 0, 0, '/booboo/', 'map_map_clean1.png', 'false', '', 1, 1274214223, 1, 1274214223);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (270, 'Picture-1.png', 1, 'png', 81920, 0, 0, 0, '/booboo/', 'Picture-1.png', 'false', '', 1, 1274214450, 1, 1274214450);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (271, 'SBW2-1.tiff', 5, 'tiff', 37036032, 0, 0, 0, '/booboo/', '', 'false', '', 1, 1274214597, 1, 1274214597);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (272, 'SBW2.jpeg', 1, 'jpeg', 540672, 0, 0, 0, '/booboo/', 'SBW2.jpeg', 'false', '', 1, 1274214600, 1, 1274214600);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (273, 'SBW2.tiff', 5, 'tiff', 37036032, 0, 0, 0, '/booboo/', '', 'false', '', 1, 1274214749, 1, 1274214749);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (307, 'ddc_water0.jpg', 1, 'jpg', 241664, 750, 469, 0, '/netgear/', 'ddc_water0.jpg', 'false', '', 1, 1274302722, 1, 1274302722);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (308, 'ddc_Water1.jpg', 1, 'jpg', 131072, 750, 469, 0, '/netgear/', 'ddc_Water1.jpg', 'false', '', 1, 1274302723, 1, 1274302723);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (309, 'ddc_water2.jpg', 1, 'jpg', 229376, 750, 469, 0, '/netgear/', 'ddc_water2.jpg', 'false', '', 1, 1274302725, 1, 1274302725);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (310, 'ddc_water3.jpg', 1, 'jpg', 180224, 750, 469, 0, '/netgear/', 'ddc_water3.jpg', 'false', '', 1, 1274302727, 1, 1274302727);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (311, 'ddc_water4.jpg', 1, 'jpg', 196608, 750, 469, 0, '/netgear/', 'ddc_water4.jpg', 'false', '', 1, 1274302728, 1, 1274302728);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (312, 'ddc_water5.jpg', 1, 'jpg', 225280, 750, 469, 0, '/netgear/', 'ddc_water5.jpg', 'false', '', 1, 1274302730, 1, 1274302730);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (313, 'ddc_water6.jpg', 1, 'jpg', 212992, 750, 731, 0, '/netgear/', 'ddc_water6.jpg', 'false', '', 1, 1274302732, 1, 1274302732);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (314, 'ddc_water8.jpg', 1, 'jpg', 253952, 750, 733, 0, '/netgear/', 'ddc_water8.jpg', 'false', '', 1, 1274302734, 1, 1274302734);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (315, 'ddc_water9.jpg', 1, 'jpg', 307200, 750, 722, 0, '/netgear/', 'ddc_water9.jpg', 'false', '', 1, 1274302736, 1, 1274302736);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (316, 'I.D._ADR_Cover.gif', 5, 'gif', 77824, 0, 0, 0, '/netgear/', '', 'false', '', 1, 1274302737, 1, 1274302737);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (317, 'rumble2_2.JPG', 1, 'JPG', 323584, 750, 500, 0, '/netgear/', 'rumble2_2.JPG', 'false', '', 1, 1274302778, 1, 1274302778);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (318, 'rumble2_2_1.JPG', 1, 'JPG', 323584, 750, 500, 0, '/netgear/', 'rumble2_2_1.JPG', 'false', '', 1, 1274302780, 1, 1274302780);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (319, 'rumble2_7.JPG', 1, 'JPG', 409600, 750, 536, 0, '/netgear/', 'rumble2_7.JPG', 'false', '', 1, 1274302783, 1, 1274302783);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (320, 'rumble2_8.JPG', 1, 'JPG', 405504, 750, 491, 0, '/netgear/', 'rumble2_8.JPG', 'false', '', 1, 1274302785, 1, 1274302785);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (384, 'Better_Place01.jpg', 1, 'jpg', 139264, 1000, 667, 0, '/delllatitude/', 'Better_Place01.jpg', 'false', '', 1, 1274304327, 1, 1274304327);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (385, 'Better_Place02.jpg', 1, 'jpg', 241664, 1348, 899, 0, '/delllatitude/', 'Better_Place02.jpg', 'false', '', 1, 1274304329, 1, 1274304329);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (386, 'Better_Place02b.jpg', 1, 'jpg', 65536, 1500, 900, 0, '/delllatitude/', 'Better_Place02b.jpg', 'false', '', 1, 1274304330, 1, 1274304330);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (387, 'Better_Place03.jpg', 1, 'jpg', 106496, 1500, 917, 0, '/delllatitude/', 'Better_Place03.jpg', 'false', '', 1, 1274304332, 1, 1274304332);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (388, 'Better_Place03B.jpg', 1, 'jpg', 49152, 1500, 900, 0, '/delllatitude/', 'Better_Place03B.jpg', 'false', '', 1, 1274304333, 1, 1274304333);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (441, 'Better_Place05.jpg', 1, 'jpg', 61440, 1000, 727, 0, '/delllatitude/', 'Better_Place05.jpg', 'false', '', 1, 1274392678, 1, 1274392678);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (442, 'Better_Place06.jpg', 1, 'jpg', 122880, 1000, 606, 0, '/delllatitude/', 'Better_Place06.jpg', 'false', '', 1, 1274392679, 1, 1274392679);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (443, 'BetterPlace_I_thumb.jpg', 1, 'jpg', 12288, 155, 110, 0, '/delllatitude/', 'BetterPlace_I_thumb.jpg', 'false', '', 1, 1274392680, 1, 1274392680);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (444, 'brankica_people.jpg', 1, 'jpg', 307200, 750, 500, 0, '/delllatitude/', 'brankica_people.jpg', 'false', '', 1, 1274392682, 1, 1274392682);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (445, 'chinatown-nyc-700793.JPG', 1, 'JPG', 90112, 640, 480, 0, '/delllatitude/', 'chinatown-nyc-700793.JPG', 'false', '', 1, 1274392683, 1, 1274392683);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (446, 'christmas09.jpg', 1, 'jpg', 172032, 340, 450, 0, '/delllatitude/', 'christmas09.jpg', 'false', '', 1, 1274392684, 1, 1274392684);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (447, 'clients_shirt.jpg', 1, 'jpg', 118784, 340, 450, 0, '/delllatitude/', 'clients_shirt.jpg', 'false', '', 1, 1274392686, 1, 1274392686);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (448, 'cocoon01.jpg', 1, 'jpg', 94208, 1000, 610, 0, '/delllatitude/', 'cocoon01.jpg', 'false', '', 1, 1274392687, 1, 1274392687);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (449, 'cocoon02.jpg', 1, 'jpg', 98304, 1000, 610, 0, '/delllatitude/', 'cocoon02.jpg', 'false', '', 1, 1274392688, 1, 1274392688);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (450, 'cocoon03.jpg', 1, 'jpg', 77824, 1000, 610, 0, '/delllatitude/', 'cocoon03.jpg', 'false', '', 1, 1274392689, 1, 1274392689);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (451, 'cocoon04.jpg', 1, 'jpg', 49152, 1000, 610, 0, '/delllatitude/', 'cocoon04.jpg', 'false', '', 1, 1274392690, 1, 1274392690);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (452, 'cocoon05.jpg', 1, 'jpg', 81920, 1000, 610, 0, '/delllatitude/', 'cocoon05.jpg', 'false', '', 1, 1274392691, 1, 1274392691);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (453, 'cocoon_family5_thumb.jpg', 1, 'jpg', 8192, 155, 110, 0, '/delllatitude/', 'cocoon_family5_thumb.jpg', 'false', '', 1, 1274392692, 1, 1274392692);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (497, 'SO002_e-blast_final_13.jpg', 1, 'jpg', 65536, 242, 607, 0, '/test/', 'SO002_e-blast_final_13.jpg', 'false', '', 1, 1274492464, 1, 1274492464);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (498, 'SO002_e-blast_final_13_1.jpg', 1, 'jpg', 32768, 400, 400, 0, '/test/', 'SO002_e-blast_final_13_1.jpg', 'false', '', 1, 1274492465, 1, 1274492465);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (499, 'SO002_e-blast_final_14.jpg', 1, 'jpg', 12288, 153, 137, 0, '/test/', 'SO002_e-blast_final_14.jpg', 'false', '', 1, 1274492466, 1, 1274492466);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (500, 'SO002_e-blast_final_14_1.jpg', 1, 'jpg', 20480, 400, 400, 0, '/test/', 'SO002_e-blast_final_14_1.jpg', 'false', '', 1, 1274492467, 1, 1274492467);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (501, 'SO002_e-blast_final_14_2.jpg', 1, 'jpg', 12288, 153, 137, 0, '/test/', 'SO002_e-blast_final_14_2.jpg', 'false', '', 1, 1274492468, 1, 1274492468);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (502, 'SO002_e-blast_final_14_3.jpg', 1, 'jpg', 20480, 400, 400, 0, '/test/', 'SO002_e-blast_final_14_3.jpg', 'false', '', 1, 1274492469, 1, 1274492469);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (503, 'SO002_e-blast_final_15.jpg', 1, 'jpg', 32768, 222, 508, 0, '/test/', 'SO002_e-blast_final_15.jpg', 'false', '', 1, 1274492470, 1, 1274492470);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (504, 'SO002_e-blast_final_15_1.jpg', 1, 'jpg', 12288, 400, 400, 0, '/test/', 'SO002_e-blast_final_15_1.jpg', 'false', '', 1, 1274492471, 1, 1274492471);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (505, 'SO002_e-blast_final_15_2.jpg', 1, 'jpg', 32768, 222, 508, 0, '/test/', 'SO002_e-blast_final_15_2.jpg', 'false', '', 1, 1274492472, 1, 1274492472);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (506, 'SO002_e-blast_final_15_3.jpg', 1, 'jpg', 12288, 400, 400, 0, '/test/', 'SO002_e-blast_final_15_3.jpg', 'false', '', 1, 1274492473, 1, 1274492473);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (507, 'SO002_e-blast_final_17.jpg', 1, 'jpg', 4096, 22, 371, 0, '/test/', 'SO002_e-blast_final_17.jpg', 'false', '', 1, 1274492474, 1, 1274492474);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (508, 'SO002_e-blast_final_17_1.jpg', 1, 'jpg', 8192, 400, 400, 0, '/test/', 'SO002_e-blast_final_17_1.jpg', 'false', '', 1, 1274492475, 1, 1274492475);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (509, 'SO002_e-blast_final_17_2.jpg', 1, 'jpg', 4096, 22, 371, 0, '/test/', 'SO002_e-blast_final_17_2.jpg', 'false', '', 1, 1274492475, 1, 1274492475);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (510, 'SO002_e-blast_final_17_3.jpg', 1, 'jpg', 8192, 400, 400, 0, '/test/', 'SO002_e-blast_final_17_3.jpg', 'false', '', 1, 1274492476, 1, 1274492476);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (511, 'SO002_e-blast_final.jpg', 1, 'jpg', 114688, 565, 927, 0, '/test/', 'SO002_e-blast_final.jpg', 'false', '', 1, 1274492479, 1, 1274492479);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (512, 'SO002_e-blast_final_1.jpg', 1, 'jpg', 20480, 400, 400, 0, '/test/', 'SO002_e-blast_final_1.jpg', 'false', '', 1, 1274492480, 1, 1274492480);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (513, 'SO002_e-blast_final_2.jpg', 1, 'jpg', 114688, 565, 927, 0, '/test/', 'SO002_e-blast_final_2.jpg', 'false', '', 1, 1274492483, 1, 1274492483);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (514, 'SO002_e-blast_final_3.jpg', 1, 'jpg', 20480, 400, 400, 0, '/test/', 'SO002_e-blast_final_3.jpg', 'false', '', 1, 1274492484, 1, 1274492484);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (515, 'SO002_kim_natural.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_natural.jpg', 'false', '', 1, 1274492485, 1, 1274492485);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (516, 'SO002_kim_natural_1.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_natural_1.jpg', 'false', '', 1, 1274492487, 1, 1274492487);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (517, 'SO002_kim_natural_2.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_natural_2.jpg', 'false', '', 1, 1274492489, 1, 1274492489);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (518, 'SO002_kim_natural_3.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_natural_3.jpg', 'false', '', 1, 1274492490, 1, 1274492490);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (519, 'SO002_kim_natural_4.jpg', 1, 'jpg', 12288, 400, 400, 0, '/test/', 'SO002_kim_natural_4.jpg', 'false', '', 1, 1274492491, 1, 1274492491);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (520, 'SO002_kim_natural_5.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_natural_5.jpg', 'false', '', 1, 1274492493, 1, 1274492493);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (521, 'SO002_kim_nighttime.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_nighttime.jpg', 'false', '', 1, 1274492495, 1, 1274492495);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (522, 'SO002_kim_nighttime_1.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_nighttime_1.jpg', 'false', '', 1, 1274492496, 1, 1274492496);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (523, 'SO002_kim_nighttime_2.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_nighttime_2.jpg', 'false', '', 1, 1274492498, 1, 1274492498);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (524, 'SO002_kim_nighttime_3.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_nighttime_3.jpg', 'false', '', 1, 1274492500, 1, 1274492500);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (525, 'SO002_kim_nighttime_4.jpg', 1, 'jpg', 12288, 400, 400, 0, '/test/', 'SO002_kim_nighttime_4.jpg', 'false', '', 1, 1274492501, 1, 1274492501);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (526, 'SO002_kim_nighttime_5.jpg', 1, 'jpg', 53248, 650, 425, 0, '/test/', 'SO002_kim_nighttime_5.jpg', 'false', '', 1, 1274492502, 1, 1274492502);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (531, 'IMG_0008.JPG', 1, 'JPG', 434176, 1600, 1200, 0, '/tartouk/', 'IMG_0008.JPG', 'false', '', 1, 1274679748, 1, 1274679748);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (532, 'IMG_0009.JPG', 1, 'JPG', 421888, 1600, 1200, 0, '/tartouk/', 'IMG_0009.JPG', 'false', '', 1, 1274679757, 1, 1274679757);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (533, 'IMG_0010.JPG', 1, 'JPG', 393216, 1600, 1200, 0, '/tartouk/', 'IMG_0010.JPG', 'false', '', 1, 1274679765, 1, 1274679765);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (534, 'IMG_0011.JPG', 1, 'JPG', 319488, 1600, 1200, 0, '/tartouk/', 'IMG_0011.JPG', 'false', '', 1, 1274679772, 1, 1274679772);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (535, 'IMG_0012.JPG', 1, 'JPG', 385024, 1600, 1200, 0, '/tartouk/', 'IMG_0012.JPG', 'false', '', 1, 1274679780, 1, 1274679780);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (536, 'IMG_0013.JPG', 1, 'JPG', 86016, 640, 480, 0, '/tartouk/', 'IMG_0013.JPG', 'false', '', 1, 1274679783, 1, 1274679783);
INSERT INTO `media` (`id`, `name`, `mimetypeid`, `extension`, `size`, `width`, `height`, `playtime`, `path`, `thumb`, `video_proxy`, `url`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (537, 'IMG_0014.JPG', 1, 'JPG', 282624, 1280, 1024, 0, '/tartouk/', 'IMG_0014.JPG', 'false', '', 1, 1274679789, 1, 1274679789);
UNLOCK TABLES;


LOCK TABLES `media_terms` WRITE;
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


LOCK TABLES `permgroups` WRITE;
UNLOCK TABLES;


LOCK TABLES `perms` WRITE;
UNLOCK TABLES;


LOCK TABLES `statuses` WRITE;
INSERT INTO `statuses` (`id`, `status`, `displayorder`) VALUES (1, 'Draft', 0);
INSERT INTO `statuses` (`id`, `status`, `displayorder`) VALUES (2, 'Awaiting Approval', 0);
INSERT INTO `statuses` (`id`, `status`, `displayorder`) VALUES (3, 'Published (Internal Only)', 0);
INSERT INTO `statuses` (`id`, `status`, `displayorder`) VALUES (4, 'Published', 0);
UNLOCK TABLES;


LOCK TABLES `template_customfields` WRITE;
INSERT INTO `template_customfields` (`id`, `templateid`, `customfieldid`, `fieldid`, `displayorder`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (1, 1, 1, 1, 1, 1, 1267733775, 1, 1267733775);
INSERT INTO `template_customfields` (`id`, `templateid`, `customfieldid`, `fieldid`, `displayorder`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (2, 1, 2, 2, 2, 1, 1267733775, 1, 1267733775);
INSERT INTO `template_customfields` (`id`, `templateid`, `customfieldid`, `fieldid`, `displayorder`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (3, 1, 3, 3, 3, 1, 1267733775, 1, 1267733775);
INSERT INTO `template_customfields` (`id`, `templateid`, `customfieldid`, `fieldid`, `displayorder`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (4, 1, 4, 4, 4, 1, 1267733775, 1, 1267733775);
INSERT INTO `template_customfields` (`id`, `templateid`, `customfieldid`, `fieldid`, `displayorder`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (5, 1, 5, 5, 5, 1, 1267733775, 1, 1267733775);
INSERT INTO `template_customfields` (`id`, `templateid`, `customfieldid`, `fieldid`, `displayorder`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (6, 1, 6, 6, 6, 1, 1267733775, 1, 1267733775);
UNLOCK TABLES;


LOCK TABLES `templates` WRITE;
INSERT INTO `templates` (`id`, `name`, `classname`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (1, 'Default', '', 1, 1267733775, 1, 1267733775);
INSERT INTO `templates` (`id`, `name`, `classname`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (2, 'FAQ', '', 1, 1267733775, 1, 1267733775);
UNLOCK TABLES;


LOCK TABLES `term_taxonomy` WRITE;
UNLOCK TABLES;


LOCK TABLES `terms` WRITE;
INSERT INTO `terms` (`id`, `name`, `slug`, `createdby`, `createdate`) VALUES (1, '2009', '2009', 1, 1267733775);
INSERT INTO `terms` (`id`, `name`, `slug`, `createdby`, `createdate`) VALUES (2, 'Brankica Kovrilja', 'brankica-kovrilja', 0, 0);
INSERT INTO `terms` (`id`, `name`, `slug`, `createdby`, `createdate`) VALUES (3, 'CCWA', 'ccwa', 0, 0);
INSERT INTO `terms` (`id`, `name`, `slug`, `createdby`, `createdate`) VALUES (4, 'Eddie Opara', 'eddie-opara', 0, 0);
UNLOCK TABLES;


LOCK TABLES `user` WRITE;
INSERT INTO `user` (`id`, `usergroupid`, `firstname`, `lastname`, `username`, `email`, `address`, `address2`, `city`, `state`, `country`, `zip`, `phone`, `mobile`, `fax`, `dateofbirth`, `password`, `lastlogin`, `active`, `createdby`, `createdate`, `modifiedby`, `modifieddate`) VALUES (1, 8, 'Raed', 'Atoui', 'raed', 'raed@themapoffice.com', '', '', '', '', '', '', '', '', '', 0, 'kriohqiriq', 1274723341, 1, 1, 1267733775, 1, 1267733775);
UNLOCK TABLES;


LOCK TABLES `user_notes` WRITE;
UNLOCK TABLES;


LOCK TABLES `user_usercategories` WRITE;
UNLOCK TABLES;


LOCK TABLES `usercategories` WRITE;
UNLOCK TABLES;


LOCK TABLES `usergroup_perms` WRITE;
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