-- phpMyAdmin SQL Dump
-- version 3.2.0.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 06, 2010 at 05:58 PM
-- Server version: 5.1.37
-- PHP Version: 5.2.11

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mig`
--
CREATE DATABASE `mig` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `mig`;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

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
  KEY `comments_statusid_fk` (`statusid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `config`
--

CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `system` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `config`
--

INSERT INTO `config` VALUES(1, 'Media', 'ON', 0);
INSERT INTO `config` VALUES(2, 'Users', 'ON', 0);
INSERT INTO `config` VALUES(3, 'Fonts', 'OFF', 0);
INSERT INTO `config` VALUES(4, 'Tags', 'ON', 0);
INSERT INTO `config` VALUES(5, 'Contacts', 'OFF', 0);
INSERT INTO `config` VALUES(7, 'Custom Fields', 'OFF', 0);
INSERT INTO `config` VALUES(8, 'Events', 'OFF', 0);
INSERT INTO `config` VALUES(9, 'configfile', 'xml/config.xml', 0);
INSERT INTO `config` VALUES(10, 'prompt', 'New Deal Design', 1);

-- --------------------------------------------------------

--
-- Table structure for table `content`
--

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
  `createdate` bigint(20) NOT NULL,
  `modifieddate` bigint(20) NOT NULL,
  `search_exclude` int(1) NOT NULL,
  `can_have_children` int(1) NOT NULL,
  `displayorder` int(4) NOT NULL,
  `modifiedby` int(11) NOT NULL,
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
  KEY `content_status_fk` (`statusid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=165 ;

--
-- Dumping data for table `content`
--

INSERT INTO `content` VALUES(1, 1, 1, 'Root', 4, '', 0, 1, 1, 0, 0, 1, 1, 0, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(2, 2, 2, 'FAQs', 4, 'FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs', 0, 1, 0, 0, 1269375147127, 1, 1, 1, 1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(3, 1, 1, 'Projects', 4, 'Root', 0, 1, 0, 0, 1269465079048, 1, 1, 1, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(4, 1, 1, 'Posts', 4, 'Root', 0, 1, 0, 0, 1269465079048, 1, 1, 2, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(5, 1, 1, 'Awards', 4, 'Root', 0, 1, 0, 0, 1269969370045, 1, 1, 3, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(6, 1, 1, 'Media', 4, 'Root', 0, 1, 0, 0, 1269528891729, 1, 1, 4, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(7, 1, 1, 'Stream', 4, 'Root', 0, 1, 0, 0, 1270072016483, 1, 1, 5, 5, '', 'newdealdesign,newdealstudio,gadiamit', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(8, 1, 1, 'About Us', 4, 'Root', 0, 1, 0, 0, 1270076545629, 1, 1, 6, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(9, 1, 1, 'Contact', 4, 'Root', 0, 1, 0, 0, 1269548152487, 1, 1, 7, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(10, 3, 1, 'Fitbit Tracker', 4, 'Root<>Projects', 0, 0, 1, 1267733775278, 1270076443308, 0, 0, 2, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(11, 3, 1, 'Dell Studio Hybrid', 4, 'Root<>Projects', 0, 0, 1, 1267733781751, 1269960909244, 0, 0, 3, 5, '1,3,2,4', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(12, 3, 1, 'Ogo', 4, 'Root<>Projects', 0, 0, 1, 1267733790007, 1269960920137, 0, 0, 4, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(13, 3, 1, 'Tana Water Bar', 4, 'Root<>Projects', 1, 0, 1, 1267733775278, 1268923509782, 0, 0, 1, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(14, 5, 1, 'Red Dot 09', 4, 'Root<>Awards', 1, 0, 1, 1267733907327, 1269632295696, 0, 0, 2, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(15, 5, 1, 'Index 09', 4, 'Root<>Awards', 1, 0, 1, 1267733912189, 1269632323803, 0, 0, 3, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(16, 5, 1, 'Index Finalist 09', 4, 'Root<>Awards', 1, 0, 1, 1267733917398, 1269632330300, 0, 0, 4, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(17, 5, 1, 'Award 4', 4, 'Root<>Awards', 1, 0, 1, 1268674033893, 1269632346186, 0, 0, 1, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(18, 4, 1, 'Fire, Agriculture, Design: How Human Creativity Built Society', 4, 'Root<>Posts', 0, 0, 1, 1267733885196, 1269634962238, 0, 0, 7, 5, 'Test Author', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(19, 4, 1, 'Apple may change the world&#8230; again.', 4, 'Root<>Posts', 0, 0, 1, 1267733893450, 1269642124450, 0, 0, 8, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(20, 4, 1, 'Making sense of Design Thinking: Three definitions, two problems and one big question', 4, 'Root<>Posts', 0, 0, 1, 1267733898885, 1269044089230, 0, 0, 9, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(138, 3, 1, 'raed', 4, 'Root<>Projects', 1, 0, 1, 1268928037396, 1268937842122, 0, 0, 4, 5, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(139, 3, 1, 'Better Place', 4, 'Root<>Projects', 0, 0, 6, 1269024865619, 1269988502892, 0, 0, 5, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(140, 3, 1, 'Memorex Clock', 4, 'Root<>Projects', 0, 0, 6, 1269027604657, 1269563404144, 0, 0, 6, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(141, 3, 1, 'Glide TV', 4, 'Root<>Projects', 0, 0, 6, 1269032891847, 1269046254514, 0, 0, 7, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(142, 3, 1, 'Cocoon', 4, 'Root<>Projects', 0, 0, 6, 1269033309940, 1269046254514, 0, 0, 8, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(143, 3, 1, 'Fujitsu Phones', 4, 'Root<>Projects', 0, 0, 6, 1269037351639, 1269046254514, 0, 0, 9, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(144, 3, 1, 'Dell Latitude', 4, 'Root<>Projects', 0, 0, 6, 1269039248145, 1269622691825, 0, 0, 10, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(145, 3, 1, 'Netgear', 4, 'Root<>Projects', 0, 0, 6, 1269040389009, 1269046254514, 0, 0, 11, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(146, 4, 1, 'Dear Gadget Reviewers: You Don\\''t Understand Beauty', 4, 'Root<>Posts', 0, 0, 6, 1269042459558, 1269044089230, 0, 0, 6, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(147, 4, 1, 'Team', 4, 'Root<>Posts', 1, 0, 6, 1269042927357, 1269043262208, 0, 0, 1, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(148, 4, 1, 'Looking at the Micro vs. the Macro in Design', 4, 'Root<>Posts', 0, 0, 6, 1269043323189, 1269642182900, 0, 0, 5, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(149, 4, 1, '\\"Shop Class as Soulcraft\\": A Book That Revels in Alternative Thinking for Designers', 4, 'Root<>Posts', 0, 0, 6, 1269043499440, 1269044089230, 0, 0, 4, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(150, 4, 1, 'Body Computing Is a Glimmer of Hope in the Health-Care Chasm', 4, 'Root<>Posts', 0, 0, 6, 1269043663949, 1269044089230, 0, 0, 3, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(151, 4, 1, 'In Defense of Slapping a Robot', 4, 'Root<>Posts', 0, 0, 6, 1269043883800, 1269642213689, 0, 0, 2, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(152, 4, 1, 'How Should We Define \\"Design\\"?', 4, 'Root<>Posts', 0, 0, 6, 1269044088799, 1269044230275, 0, 0, 1, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(153, 3, 1, 'Sling Media', 4, 'Root<>Projects', 0, 0, 6, 1269044542738, 1269046254514, 0, 0, 12, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(154, 3, 1, 'Logitech', 4, 'Root<>Projects', 0, 0, 6, 1269046254078, 1269635596493, 0, 0, 1, 3, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(155, 5, 1, 'Red Dot', 4, 'Root<>Awards', 0, 0, 6, 1269632365585, 1269989043424, 0, 0, 2, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(156, 5, 1, 'Index', 4, 'Root<>Awards', 0, 0, 6, 1269632635448, 1269989043424, 0, 0, 3, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(157, 5, 1, 'Idea Gold', 4, 'Root<>Awards', 0, 0, 6, 1269632733235, 1269989043424, 0, 0, 4, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(158, 5, 1, 'IDEA Silver', 4, 'Root<>Awards', 0, 0, 6, 1269633018952, 1269989043424, 0, 0, 5, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(159, 5, 1, 'IDEA Finalist-Medical', 4, 'Root<>Awards', 0, 0, 6, 1269633324130, 1269989436120, 0, 0, 6, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(160, 5, 1, 'ID Magazine Honorable Mention', 4, 'Root<>Awards', 0, 0, 6, 1269633399818, 1269989043424, 0, 0, 7, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(161, 5, 1, 'Brit Insurance Design of the Year Finalist', 4, 'Root<>Awards', 0, 0, 6, 1269968497978, 1269989043424, 0, 0, 8, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(162, 5, 1, 'Innovations Design and Engineering Awards Honorees', 4, 'Root<>Awards', 0, 0, 6, 1269969351554, 1270076097594, 0, 0, 9, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(163, 5, 1, 'CES Innovation award / Best of Innovation', 4, 'Root<>Awards', 0, 0, 6, 1269969920468, 1269989043424, 0, 0, 10, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `content` VALUES(164, 5, 1, 'IDEA Finalist-Recreation', 4, 'Root<>Awards', 0, 0, 6, 1269989042990, 1269989043424, 0, 0, 1, 6, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `content_content`
--

CREATE TABLE `content_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `contentid2` int(11) NOT NULL,
  `desc` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`,`contentid2`),
  KEY `content_content_contentid_fk` (`contentid`),
  KEY `content_content_contentid2_fk` (`contentid2`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `content_content`
--

INSERT INTO `content_content` VALUES(1, 1, 2, 'Š,Œ,Ž,š,œ,ž,Ÿ,¥,µ,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,');

-- --------------------------------------------------------

--
-- Table structure for table `content_customfields`
--

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
  `createdate` bigint(20) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `content_customfields_contentid_fk` (`contentid`),
  KEY `content_customfields_typeid_fk` (`typeid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `content_customfields`
--

INSERT INTO `content_customfields` VALUES(1, 11, 4, 'biography', '', 'ok lets add text', '', '', 0, 0, 0, 0, 0);
INSERT INTO `content_customfields` VALUES(2, 11, 2, 'line', 'Line', 'fab', '', '', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `content_media`
--

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
  KEY `content_media_mediaid_fk` (`mediaid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `content_media`
--


-- --------------------------------------------------------

--
-- Table structure for table `content_terms`
--

CREATE TABLE `content_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `termid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `tagid` (`termid`),
  KEY `content_terms_contentid_fk` (`contentid`),
  KEY `content_terms_termid_fk` (`termid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `content_terms`
--


-- --------------------------------------------------------

--
-- Table structure for table `content_users`
--

CREATE TABLE `content_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contentid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contentid` (`contentid`),
  KEY `userid` (`userid`),
  KEY `content_users_userid_fk` (`userid`),
  KEY `content_users_contentid_fk` (`contentid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `content_users`
--


-- --------------------------------------------------------

--
-- Table structure for table `customfieldgroups`
--

CREATE TABLE `customfieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `customfieldgroups`
--

INSERT INTO `customfieldgroups` VALUES(1, 'Default');

-- --------------------------------------------------------

--
-- Table structure for table `customfields`
--

CREATE TABLE `customfields` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `typeid` int(11) NOT NULL,
  `groupid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `displayname` varchar(255) NOT NULL,
  `options` text NOT NULL,
  `defaultvalue` text NOT NULL,
  `visible` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `customfield_type_fk` (`typeid`),
  KEY `customfield_group_fk` (`groupid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `customfields`
--

INSERT INTO `customfields` VALUES(1, 3, 1, 'title', 'Title', '', '', 1);
INSERT INTO `customfields` VALUES(2, 3, 1, 'url', 'URL', '', '', 1);
INSERT INTO `customfields` VALUES(3, 4, 1, 'description', 'Description', '', '', 1);
INSERT INTO `customfields` VALUES(4, 4, 1, 'shortdescription', 'Short Description', '', '', 1);
INSERT INTO `customfields` VALUES(5, 7, 1, 'description2', 'Unformatted Description', '', '', 0);
INSERT INTO `customfields` VALUES(6, 7, 1, 'shortdescription2', 'Unformatted Short Description', '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `customfieldtypes`
--

CREATE TABLE `customfieldtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `sqltypes` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `customfieldtypes`
--

INSERT INTO `customfieldtypes` VALUES(1, 'binary', 'int(1)');
INSERT INTO `customfieldtypes` VALUES(2, 'select', 'varchar(10)');
INSERT INTO `customfieldtypes` VALUES(3, 'string', 'varchar(255)');
INSERT INTO `customfieldtypes` VALUES(4, 'html-text', 'longtext,mediumtext');
INSERT INTO `customfieldtypes` VALUES(5, 'multiple-select', 'varchar(255)');
INSERT INTO `customfieldtypes` VALUES(6, 'color', 'int(11)');
INSERT INTO `customfieldtypes` VALUES(7, 'text', 'longtext,mediumtext');
INSERT INTO `customfieldtypes` VALUES(8, 'date', 'bigint(20)');
INSERT INTO `customfieldtypes` VALUES(9, 'integer', 'int(11),bigint(20)');
INSERT INTO `customfieldtypes` VALUES(10, 'file-link', 'varch(255)');
INSERT INTO `customfieldtypes` VALUES(11, 'multiple-select-with-order', 'varch(255)');

-- --------------------------------------------------------

--
-- Table structure for table `fonts`
--

CREATE TABLE `fonts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `device` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `fonts`
--


-- --------------------------------------------------------

--
-- Table structure for table `media`
--

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
  KEY `media_mimetype_fk` (`mimetypeid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=242 ;

--
-- Dumping data for table `media`
--

INSERT INTO `media` VALUES(14, 'cs_logo_vid.flv', 2, 2416399, 10.057, '/videos/', 'cs_logo_vid.jpg', 'cs_logo_vid.flv', '', 0, 1, 1267733021626, 1, 1267733021626);
INSERT INTO `media` VALUES(15, 'Britney_180_512K_Stream001.flv', 2, 471071, 9.966, '/videos/', 'Britney_180_512K_Stream001.jpg', 'Britney_180_512K_Stream001.flv', '', 0, 1, 1267733169296, 1, 1267733169296);
INSERT INTO `media` VALUES(16, 'Tami4new_01.jpg', 1, 54147, 0, '/test/', 'Tami4new_01.jpg', '', '', 0, 5, 1268767913161, 5, 1268767913161);
INSERT INTO `media` VALUES(18, 'Tami4new_03.jpg', 1, 43759, 0, '/test/', 'Tami4new_03.jpg', '', '', 0, 5, 1268767916935, 5, 1268767916935);
INSERT INTO `media` VALUES(19, 'Tami4new_04.jpg', 1, 38978, 0, '/test/', 'Tami4new_04.jpg', '', '', 0, 5, 1268767919298, 5, 1268767919298);
INSERT INTO `media` VALUES(20, 'Tami4new_05.jpg', 1, 79181, 0, '/test/', 'Tami4new_05.jpg', '', '', 0, 5, 1268767921981, 5, 1268767921981);
INSERT INTO `media` VALUES(21, 'Comp 1.flv', 2, 1317610, 14.715, '/', 'Comp 1.jpg', 'Comp 1.flv', '', 0, 1, 1268853953332, 1, 1268853953332);
INSERT INTO `media` VALUES(22, 'cs_logo_vid.flv', 2, 2416399, 10.057, '/', 'cs_logo_vid.jpg', 'cs_logo_vid.flv', '', 0, 1, 1268853987237, 1, 1268853987237);
INSERT INTO `media` VALUES(129, 'contact_image.jpg', 1, 5738, 0, '/', 'contact_image.jpg', '', '', 0, 5, 1269528918823, 5, 1269528918823);
INSERT INTO `media` VALUES(139, 'Better_Place01.jpg', 1, 135372, 0, '/betterplace/', 'Better_Place01.jpg', '', '', 0, 6, 1269560525708, 6, 1269560525708);
INSERT INTO `media` VALUES(140, 'Better_Place03.jpg', 1, 18715, 0, '/betterplace/', 'Better_Place03.jpg', '', '', 0, 6, 1269560536483, 6, 1269560536483);
INSERT INTO `media` VALUES(141, 'Better_Place02.jpg', 1, 43500, 0, '/betterplace/', 'Better_Place02.jpg', '', '', 0, 6, 1269560538723, 6, 1269560538723);
INSERT INTO `media` VALUES(142, 'Better_Place05.jpg', 1, 60893, 0, '/betterplace/', 'Better_Place05.jpg', '', '', 0, 6, 1269560553472, 6, 1269560553472);
INSERT INTO `media` VALUES(143, 'Better_Place04.jpg', 1, 20474, 0, '/betterplace/', 'Better_Place04.jpg', '', '', 0, 6, 1269560555008, 6, 1269560555008);
INSERT INTO `media` VALUES(145, 'Better_Place06.jpg', 1, 119085, 0, '/betterplace/', 'Better_Place06.jpg', '', '', 0, 6, 1269560570458, 6, 1269560570458);
INSERT INTO `media` VALUES(146, 'Fitbit_05.jpg', 1, 97224, 0, '/fitbit/', 'Fitbit_05.jpg', '', '', 0, 6, 1269561539169, 6, 1269561539169);
INSERT INTO `media` VALUES(147, 'Fitbit_06.jpg', 1, 64968, 0, '/fitbit/', 'Fitbit_06.jpg', '', '', 0, 6, 1269561541457, 6, 1269561541457);
INSERT INTO `media` VALUES(148, 'Fitbit_04.jpg', 1, 366988, 0, '/fitbit/', 'Fitbit_04.jpg', '', '', 0, 6, 1269561547946, 6, 1269561547946);
INSERT INTO `media` VALUES(149, 'Fitbit_01.jpg', 1, 71461, 0, '/fitbit/', 'Fitbit_01.jpg', '', '', 0, 6, 1269561550260, 6, 1269561550260);
INSERT INTO `media` VALUES(150, 'Fitbit_02.jpg', 1, 52001, 0, '/fitbit/', 'Fitbit_02.jpg', '', '', 0, 6, 1269561552333, 6, 1269561552333);
INSERT INTO `media` VALUES(151, 'Fitbit_03.jpg', 1, 54348, 0, '/fitbit/', 'Fitbit_03.jpg', '', '', 0, 6, 1269561554434, 6, 1269561554434);
INSERT INTO `media` VALUES(152, 'Fitbit_thumb.jpg', 1, 4326, 0, '/fitbit/', 'Fitbit_thumb.jpg', '', '', 0, 6, 1269561682744, 6, 1269561682744);
INSERT INTO `media` VALUES(153, 'BetterPlace_I_thumb.jpg', 1, 8894, 0, '/betterplace/', 'BetterPlace_I_thumb.jpg', '', '', 0, 6, 1269561731347, 6, 1269561731347);
INSERT INTO `media` VALUES(154, 'DellBamboo_thumb.jpg', 1, 10525, 0, '/dellhybridstudio/', 'DellBamboo_thumb.jpg', '', '', 0, 6, 1269562374119, 6, 1269562374119);
INSERT INTO `media` VALUES(155, 'dellhybrid01.jpg', 1, 72463, 0, '/dellhybridstudio/', 'dellhybrid01.jpg', '', '', 0, 6, 1269562394642, 6, 1269562394642);
INSERT INTO `media` VALUES(156, 'dellhybrid02.jpg', 1, 247949, 0, '/dellhybridstudio/', 'dellhybrid02.jpg', '', '', 0, 6, 1269562407450, 6, 1269562407450);
INSERT INTO `media` VALUES(157, 'dellhybrid03.jpg', 1, 128699, 0, '/dellhybridstudio/', 'dellhybrid03.jpg', '', '', 0, 6, 1269562422754, 6, 1269562422754);
INSERT INTO `media` VALUES(158, 'dellhybrid04.jpg', 1, 64368, 0, '/dellhybridstudio/', 'dellhybrid04.jpg', '', '', 0, 6, 1269562424933, 6, 1269562424933);
INSERT INTO `media` VALUES(159, 'dellhybrid05.jpg', 1, 70038, 0, '/dellhybridstudio/', 'dellhybrid05.jpg', '', '', 0, 6, 1269562427155, 6, 1269562427155);
INSERT INTO `media` VALUES(160, 'Ogo_01.jpg', 1, 53142, 0, '/ogo/', 'Ogo_01.jpg', '', '', 0, 6, 1269562904303, 6, 1269562904303);
INSERT INTO `media` VALUES(161, 'Ogo_06.jpg', 1, 65287, 0, '/ogo/', 'Ogo_06.jpg', '', '', 0, 6, 1269562906429, 6, 1269562906429);
INSERT INTO `media` VALUES(162, 'Ogo_07.jpg', 1, 35017, 0, '/ogo/', 'Ogo_07.jpg', '', '', 0, 6, 1269562908190, 6, 1269562908190);
INSERT INTO `media` VALUES(163, 'Ogo_04.jpg', 1, 73855, 0, '/ogo/', 'Ogo_04.jpg', '', '', 0, 6, 1269562910474, 6, 1269562910474);
INSERT INTO `media` VALUES(164, 'Ogo_05.jpg', 1, 66457, 0, '/ogo/', 'Ogo_05.jpg', '', '', 0, 6, 1269562912636, 6, 1269562912636);
INSERT INTO `media` VALUES(165, 'Ogo_02.jpg', 1, 66325, 0, '/ogo/', 'Ogo_02.jpg', '', '', 0, 6, 1269562915019, 6, 1269562915019);
INSERT INTO `media` VALUES(166, 'Ogo_03.jpg', 1, 42388, 0, '/ogo/', 'Ogo_03.jpg', '', '', 0, 6, 1269562916989, 6, 1269562916989);
INSERT INTO `media` VALUES(167, 'Ogo_01_thumb.jpg', 1, 5439, 0, '/ogo/', 'Ogo_01_thumb.jpg', '', '', 0, 6, 1269562928092, 6, 1269562928092);
INSERT INTO `media` VALUES(168, 'Memorex_01.jpg', 1, 129002, 0, '/memorexclock/', 'Memorex_01.jpg', '', '', 0, 6, 1269563274716, 6, 1269563274716);
INSERT INTO `media` VALUES(169, 'Memorex_02.jpg', 1, 122311, 0, '/memorexclock/', 'Memorex_02.jpg', '', '', 0, 6, 1269563285762, 6, 1269563285762);
INSERT INTO `media` VALUES(170, 'Memorex_04.jpg', 1, 73133, 0, '/memorexclock/', 'Memorex_04.jpg', '', '', 0, 6, 1269563295765, 6, 1269563295765);
INSERT INTO `media` VALUES(171, 'Memorex_03.jpg', 1, 36838, 0, '/memorexclock/', 'Memorex_03.jpg', '', '', 0, 6, 1269563297668, 6, 1269563297668);
INSERT INTO `media` VALUES(172, 'Memorex_05.jpg', 1, 84822, 0, '/memorexclock/', 'Memorex_05.jpg', '', '', 0, 6, 1269563307541, 6, 1269563307541);
INSERT INTO `media` VALUES(173, 'Memorex_thumb.jpg', 1, 6955, 0, '/memorexclock/', 'Memorex_thumb.jpg', '', '', 0, 6, 1269563373575, 6, 1269563373575);
INSERT INTO `media` VALUES(174, 'glidetv03.jpg', 1, 52937, 0, '/glidetv/', 'glidetv03.jpg', '', '', 0, 6, 1269564098149, 6, 1269564098149);
INSERT INTO `media` VALUES(175, 'glidetv01.jpg', 1, 73515, 0, '/glidetv/', 'glidetv01.jpg', '', '', 0, 6, 1269564100479, 6, 1269564100479);
INSERT INTO `media` VALUES(176, 'glidetv02.jpg', 1, 65284, 0, '/glidetv/', 'glidetv02.jpg', '', '', 0, 6, 1269564102648, 6, 1269564102648);
INSERT INTO `media` VALUES(177, 'glidetv06.jpg', 1, 61471, 0, '/glidetv/', 'glidetv06.jpg', '', '', 0, 6, 1269564104854, 6, 1269564104854);
INSERT INTO `media` VALUES(178, 'glidetv04.jpg', 1, 122516, 0, '/glidetv/', 'glidetv04.jpg', '', '', 0, 6, 1269564107849, 6, 1269564107849);
INSERT INTO `media` VALUES(179, 'glidetv05.jpg', 1, 63752, 0, '/glidetv/', 'glidetv05.jpg', '', '', 0, 6, 1269564110019, 6, 1269564110019);
INSERT INTO `media` VALUES(180, 'glidetv_thumb.jpg', 1, 4727, 0, '/glidetv/', 'glidetv_thumb.jpg', '', '', 0, 6, 1269564163821, 6, 1269564163821);
INSERT INTO `media` VALUES(181, 'fujitsu04.jpg', 1, 64007, 0, '/fujitsuphones/', 'fujitsu04.jpg', '', '', 0, 6, 1269564594878, 6, 1269564594878);
INSERT INTO `media` VALUES(182, 'fujitsu02.jpg', 1, 53502, 0, '/fujitsuphones/', 'fujitsu02.jpg', '', '', 0, 6, 1269564596881, 6, 1269564596881);
INSERT INTO `media` VALUES(183, 'fujitsu03.jpg', 1, 44813, 0, '/fujitsuphones/', 'fujitsu03.jpg', '', '', 0, 6, 1269564598881, 6, 1269564598881);
INSERT INTO `media` VALUES(184, 'fujitsu05.jpg', 1, 45048, 0, '/fujitsuphones/', 'fujitsu05.jpg', '', '', 0, 6, 1269564600872, 6, 1269564600872);
INSERT INTO `media` VALUES(185, 'fujitsu01.jpg', 1, 65204, 0, '/fujitsuphones/', 'fujitsu01.jpg', '', '', 0, 6, 1269564603003, 6, 1269564603003);
INSERT INTO `media` VALUES(186, 'fujitsu06.jpg', 1, 38960, 0, '/fujitsuphones/', 'fujitsu06.jpg', '', '', 0, 6, 1269564604823, 6, 1269564604823);
INSERT INTO `media` VALUES(187, 'fujitsu_thumb.jpg', 1, 4246, 0, '/fujitsuphones/', 'fujitsu_thumb.jpg', '', '', 0, 6, 1269564616127, 6, 1269564616127);
INSERT INTO `media` VALUES(188, 'cocoon03.jpg', 1, 74919, 0, '/cocoon/', 'cocoon03.jpg', '', '', 0, 6, 1269564967637, 6, 1269564967637);
INSERT INTO `media` VALUES(189, 'cocoon01.jpg', 1, 91876, 0, '/cocoon/', 'cocoon01.jpg', '', '', 0, 6, 1269564970180, 6, 1269564970180);
INSERT INTO `media` VALUES(190, 'cocoon02.jpg', 1, 94448, 0, '/cocoon/', 'cocoon02.jpg', '', '', 0, 6, 1269564972762, 6, 1269564972762);
INSERT INTO `media` VALUES(191, 'cocoon04.jpg', 1, 48378, 0, '/cocoon/', 'cocoon04.jpg', '', '', 0, 6, 1269564974766, 6, 1269564974766);
INSERT INTO `media` VALUES(192, 'cocoon05.jpg', 1, 78970, 0, '/cocoon/', 'cocoon05.jpg', '', '', 0, 6, 1269564977210, 6, 1269564977210);
INSERT INTO `media` VALUES(193, 'cocoon_family5_thumb.jpg', 1, 5842, 0, '/cocoon/', 'cocoon_family5_thumb.jpg', '', '', 0, 6, 1269564988337, 6, 1269564988337);
INSERT INTO `media` VALUES(199, 'DellLat04.jpg', 1, 155624, 0, '/delllatitude/', 'DellLat04.jpg', '', '', 0, 6, 1269622540264, 6, 1269622540264);
INSERT INTO `media` VALUES(200, 'DellLat02.jpg', 1, 87319, 0, '/delllatitude/', 'DellLat02.jpg', '', '', 0, 6, 1269622542823, 6, 1269622542823);
INSERT INTO `media` VALUES(201, 'DellLat03.jpg', 1, 70650, 0, '/delllatitude/', 'DellLat03.jpg', '', '', 0, 6, 1269622545905, 6, 1269622545905);
INSERT INTO `media` VALUES(202, 'DellLat01.jpg', 1, 61565, 0, '/delllatitude/', 'DellLat01.jpg', '', '', 0, 6, 1269622548374, 6, 1269622548374);
INSERT INTO `media` VALUES(203, 'DellLat_thumb.jpg', 1, 4253, 0, '/delllatitude/', 'DellLat_thumb.jpg', '', '', 0, 6, 1269622559720, 6, 1269622559720);
INSERT INTO `media` VALUES(204, 'Netgear_thumb.jpg', 1, 6435, 0, '/netgear/', 'Netgear_thumb.jpg', '', '', 0, 6, 1269623235339, 6, 1269623235339);
INSERT INTO `media` VALUES(205, 'Netgear_01.jpg', 1, 33329, 0, '/netgear/', 'Netgear_01.jpg', '', '', 0, 6, 1269623256252, 6, 1269623256252);
INSERT INTO `media` VALUES(206, 'Netgear_02.jpg', 1, 48931, 0, '/netgear/', 'Netgear_02.jpg', '', '', 0, 6, 1269623258430, 6, 1269623258430);
INSERT INTO `media` VALUES(207, 'Netgear_03.jpg', 1, 58096, 0, '/netgear/', 'Netgear_03.jpg', '', '', 0, 6, 1269623269903, 6, 1269623269903);
INSERT INTO `media` VALUES(208, 'Netgear_05.jpg', 1, 50163, 0, '/netgear/', 'Netgear_05.jpg', '', '', 0, 6, 1269623282728, 6, 1269623282728);
INSERT INTO `media` VALUES(209, 'Netgear_04.jpg', 1, 58947, 0, '/netgear/', 'Netgear_04.jpg', '', '', 0, 6, 1269623284892, 6, 1269623284892);
INSERT INTO `media` VALUES(210, 'Netgear_06.jpg', 1, 266954, 0, '/netgear/', 'Netgear_06.jpg', '', '', 0, 6, 1269623324879, 6, 1269623324879);
INSERT INTO `media` VALUES(211, 'sling02.jpg', 1, 75185, 0, '/slingmedia/', 'sling02.jpg', '', '', 0, 6, 1269623997231, 6, 1269623997231);
INSERT INTO `media` VALUES(212, 'sling01.jpg', 1, 83408, 0, '/slingmedia/', 'sling01.jpg', '', '', 0, 6, 1269623999722, 6, 1269623999722);
INSERT INTO `media` VALUES(213, 'sling05.jpg', 1, 79241, 0, '/slingmedia/', 'sling05.jpg', '', '', 0, 6, 1269624016486, 6, 1269624016486);
INSERT INTO `media` VALUES(214, 'sling03.jpg', 1, 55170, 0, '/slingmedia/', 'sling03.jpg', '', '', 0, 6, 1269624018567, 6, 1269624018567);
INSERT INTO `media` VALUES(215, 'sling04.jpg', 1, 21475, 0, '/slingmedia/', 'sling04.jpg', '', '', 0, 6, 1269624020164, 6, 1269624020164);
INSERT INTO `media` VALUES(216, 'sling06.jpg', 1, 106744, 0, '/slingmedia/', 'sling06.jpg', '', '', 0, 6, 1269624037424, 6, 1269624037424);
INSERT INTO `media` VALUES(217, 'sling07.jpg', 1, 58766, 0, '/slingmedia/', 'sling07.jpg', '', '', 0, 6, 1269624054114, 6, 1269624054114);
INSERT INTO `media` VALUES(218, 'sling08.jpg', 1, 74011, 0, '/slingmedia/', 'sling08.jpg', '', '', 0, 6, 1269624056481, 6, 1269624056481);
INSERT INTO `media` VALUES(219, 'sling09.jpg', 1, 439709, 0, '/slingmedia/', 'sling09.jpg', '', '', 0, 6, 1269624074607, 6, 1269624074607);
INSERT INTO `media` VALUES(220, 'sling_thumb.jpg', 1, 3931, 0, '/slingmedia/', 'sling_thumb.jpg', '', '', 0, 6, 1269624088688, 6, 1269624088688);
INSERT INTO `media` VALUES(221, 'logitech01.jpg', 1, 133178, 0, '/Logitech/', 'logitech01.jpg', '', '', 0, 6, 1269624688874, 6, 1269624688874);
INSERT INTO `media` VALUES(222, 'logitech02.jpg', 1, 172582, 0, '/Logitech/', 'logitech02.jpg', '', '', 0, 6, 1269624701568, 6, 1269624701568);
INSERT INTO `media` VALUES(223, 'logitech03.jpg', 1, 418742, 0, '/Logitech/', 'logitech03.jpg', '', '', 0, 6, 1269624716794, 6, 1269624716794);
INSERT INTO `media` VALUES(224, 'logitech04.jpg', 1, 164383, 0, '/Logitech/', 'logitech04.jpg', '', '', 0, 6, 1269624738131, 6, 1269624738131);
INSERT INTO `media` VALUES(225, 'logitech05.jpg', 1, 190042, 0, '/Logitech/', 'logitech05.jpg', '', '', 0, 6, 1269624750158, 6, 1269624750158);
INSERT INTO `media` VALUES(226, 'logitech06.jpg', 1, 256362, 0, '/Logitech/', 'logitech06.jpg', '', '', 0, 6, 1269624762902, 6, 1269624762902);
INSERT INTO `media` VALUES(227, 'logitech_thumb.jpg', 1, 3237, 0, '/Logitech/', 'logitech_thumb.jpg', '', '', 0, 6, 1269624784538, 6, 1269624784538);
INSERT INTO `media` VALUES(228, 'gadi.jpg', 1, 83703, 0, '/about/', 'gadi.jpg', '', '', 0, 6, 1269626601842, 6, 1269626601842);
INSERT INTO `media` VALUES(229, '2010_IDMAG.jpg', 1, 175209, 0, '/about/', '2010_IDMAG.jpg', '', '', 0, 6, 1269627436142, 6, 1269627436142);
INSERT INTO `media` VALUES(230, 'christmas09.jpg', 1, 170714, 0, '/about/', 'christmas09.jpg', '', '', 0, 6, 1269627453648, 6, 1269627453648);
INSERT INTO `media` VALUES(231, 'clients_shirt.jpg', 1, 117112, 0, '/about/', 'clients_shirt.jpg', '', '', 0, 6, 1269627464169, 6, 1269627464169);
INSERT INTO `media` VALUES(232, 'gadi2.jpg', 1, 107182, 0, '/about/', 'gadi2.jpg', '', '', 0, 6, 1269627483712, 6, 1269627483712);
INSERT INTO `media` VALUES(233, 'ghettoblast.jpg', 1, 117250, 0, '/about/', 'ghettoblast.jpg', '', '', 0, 6, 1269627486540, 6, 1269627486540);
INSERT INTO `media` VALUES(234, 'mexico02.jpg', 1, 193238, 0, '/about/', 'mexico02.jpg', '', '', 0, 6, 1269627503578, 6, 1269627503578);
INSERT INTO `media` VALUES(235, 'mexico01.jpg', 1, 91345, 0, '/about/', 'mexico01.jpg', '', '', 0, 6, 1269627506030, 6, 1269627506030);
INSERT INTO `media` VALUES(236, 'office_exterior.jpg', 1, 158229, 0, '/about/', 'office_exterior.jpg', '', '', 0, 6, 1269627518995, 6, 1269627518995);
INSERT INTO `media` VALUES(237, 'studio_interior01.jpg', 1, 179945, 0, '/about/', 'studio_interior01.jpg', '', '', 0, 6, 1269627532687, 6, 1269627532687);
INSERT INTO `media` VALUES(238, 'studio_interior03.jpg', 1, 131933, 0, '/about/', 'studio_interior03.jpg', '', '', 0, 6, 1269627544208, 6, 1269627544208);
INSERT INTO `media` VALUES(239, 'studio_interior02.jpg', 1, 140192, 0, '/about/', 'studio_interior02.jpg', '', '', 0, 6, 1269627547241, 6, 1269627547241);
INSERT INTO `media` VALUES(240, 'yoshi_draw.jpg', 1, 172762, 0, '/about/', 'yoshi_draw.jpg', '', '', 0, 6, 1269627550985, 6, 1269627550985);
INSERT INTO `media` VALUES(241, 'map_ndd.jpg', 1, 59049, 0, '/', 'map_ndd.jpg', '', '', 0, 6, 1269629178791, 6, 1269629178791);

-- --------------------------------------------------------

--
-- Table structure for table `media_terms`
--

CREATE TABLE `media_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mediaid` int(11) NOT NULL,
  `termid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mediaid` (`mediaid`),
  KEY `termid` (`termid`),
  KEY `media_terms_mediaid_fk` (`mediaid`),
  KEY `media_terms_termid_fk` (`termid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `media_terms`
--


-- --------------------------------------------------------

--
-- Table structure for table `mimetypes`
--

CREATE TABLE `mimetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `extensions` varchar(255) NOT NULL,
  `view` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `mimetypes`
--

INSERT INTO `mimetypes` VALUES(1, 'images', 'jpg,jpeg, gif,png', '');
INSERT INTO `mimetypes` VALUES(2, 'videos', 'flv,mov,mp4,m4v,f4v', '');
INSERT INTO `mimetypes` VALUES(3, 'audio', 'mp3', '');
INSERT INTO `mimetypes` VALUES(4, 'swf', '', '');
INSERT INTO `mimetypes` VALUES(5, 'file', '', '');
INSERT INTO `mimetypes` VALUES(6, 'youtube', '', '');
INSERT INTO `mimetypes` VALUES(7, 'font', 'ttf,otf', '');

-- --------------------------------------------------------

--
-- Table structure for table `permgroups`
--

CREATE TABLE `permgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permgroup` varchar(255) NOT NULL,
  `displayorder` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `permgroups`
--


-- --------------------------------------------------------

--
-- Table structure for table `perms`
--

CREATE TABLE `perms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permgroupid` int(11) NOT NULL,
  `perm` varchar(255) NOT NULL,
  `permtext` text NOT NULL,
  `displayorder` int(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `permgroupid` (`permgroupid`),
  KEY `perms_permgroupid_fk` (`permgroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `perms`
--


-- --------------------------------------------------------

--
-- Table structure for table `statuses`
--

CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) NOT NULL,
  `displayorder` int(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `statuses`
--

INSERT INTO `statuses` VALUES(1, 'Draft', 0);
INSERT INTO `statuses` VALUES(2, 'Awaiting Approval', 0);
INSERT INTO `statuses` VALUES(3, 'Published (Internal Only)', 0);
INSERT INTO `statuses` VALUES(4, 'Published', 0);

-- --------------------------------------------------------

--
-- Table structure for table `template_customfields`
--

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
  KEY `template_customfields_customfieldid_fk` (`customfieldid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `template_customfields`
--

INSERT INTO `template_customfields` VALUES(1, 1, 1, 1, 1);
INSERT INTO `template_customfields` VALUES(2, 1, 2, 2, 2);
INSERT INTO `template_customfields` VALUES(3, 1, 3, 3, 3);
INSERT INTO `template_customfields` VALUES(4, 1, 4, 4, 4);
INSERT INTO `template_customfields` VALUES(5, 1, 5, 5, 5);
INSERT INTO `template_customfields` VALUES(6, 1, 6, 6, 6);

-- --------------------------------------------------------

--
-- Table structure for table `templates`
--

CREATE TABLE `templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `classname` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `templates`
--

INSERT INTO `templates` VALUES(1, 'Default', '');
INSERT INTO `templates` VALUES(2, 'FAQ', '');

-- --------------------------------------------------------

--
-- Table structure for table `term_taxonomy`
--

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
  KEY `term_taxonomy_parent_term_taxonomy_fk` (`parentid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `term_taxonomy`
--


-- --------------------------------------------------------

--
-- Table structure for table `terms`
--

CREATE TABLE `terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `terms`
--


-- --------------------------------------------------------

--
-- Table structure for table `user`
--

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
  KEY `user_usergroup_fk` (`usergroupid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` VALUES(1, 8, 'Raed', 'Atoui', 'raed', 'raed@themapoffice.com', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 'kriohqiriq', 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_notes`
--

CREATE TABLE `user_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `createdate` bigint(20) NOT NULL,
  `modifieddate` bigint(20) NOT NULL,
  `deleted` int(1) NOT NULL,
  KEY `id` (`id`),
  KEY `user_notes_userid_fk` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `user_notes`
--


-- --------------------------------------------------------

--
-- Table structure for table `user_usercategories`
--

CREATE TABLE `user_usercategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  KEY `categoryid` (`categoryid`),
  KEY `user_usercategories_userid_fk` (`userid`),
  KEY `user_usercategories_categoryid_fk` (`categoryid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `user_usercategories`
--


-- --------------------------------------------------------

--
-- Table structure for table `usercategories`
--

CREATE TABLE `usercategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usergroupid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usercategories_usergroupid_fk` (`usergroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `usercategories`
--


-- --------------------------------------------------------

--
-- Table structure for table `usergroup_perms`
--

CREATE TABLE `usergroup_perms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usergroupid` int(11) NOT NULL,
  `permid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usergroupid` (`usergroupid`),
  KEY `permid` (`permid`),
  KEY `usergroup_id` (`usergroupid`),
  KEY `usergroup_perms_usergroupid_fk` (`usergroupid`),
  KEY `usergroup_perms_permid_fk` (`permid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `usergroup_perms`
--


-- --------------------------------------------------------

--
-- Table structure for table `usergroups`
--

CREATE TABLE `usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(11) NOT NULL,
  `usergroup` varchar(255) CHARACTER SET latin1 NOT NULL,
  `createdby` int(11) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentid` (`parentid`),
  KEY `usergroups_parent_usergroups_fk` (`parentid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `usergroups`
--

INSERT INTO `usergroups` VALUES(1, 1, 'MiG Group', 1, 123421421);
INSERT INTO `usergroups` VALUES(2, 2, 'Front End Group', 1, 123421421);
INSERT INTO `usergroups` VALUES(3, 1, 'Administrator', 1, 123421421);
INSERT INTO `usergroups` VALUES(4, 1, 'Writer 1', 1, 123421421);
INSERT INTO `usergroups` VALUES(5, 1, 'Writer 2', 1, 123421421);
INSERT INTO `usergroups` VALUES(6, 1, 'Reader', 1, 123421421);
INSERT INTO `usergroups` VALUES(7, 2, 'Front End', 0, 0);
INSERT INTO `usergroups` VALUES(8, 1, 'MiG Admin', 1, 0);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `comments_statusid_fk` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `content`
--
ALTER TABLE `content`
  ADD CONSTRAINT `content_parent_content_fk` FOREIGN KEY (`parentid`) REFERENCES `content` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `content_status_fk` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `content_template_fk` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `content_content`
--
ALTER TABLE `content_content`
  ADD CONSTRAINT `content_content_contentid2_fk` FOREIGN KEY (`contentid2`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `content_content_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `content_customfields`
--
ALTER TABLE `content_customfields`
  ADD CONSTRAINT `content_customfields_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `content_customfields_typeid_fk` FOREIGN KEY (`typeid`) REFERENCES `customfieldtypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `content_media`
--
ALTER TABLE `content_media`
  ADD CONSTRAINT `content_media_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `content_media_mediaid_fk` FOREIGN KEY (`mediaid`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `content_terms`
--
ALTER TABLE `content_terms`
  ADD CONSTRAINT `content_terms_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `content_terms_termid_fk` FOREIGN KEY (`termid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `content_users`
--
ALTER TABLE `content_users`
  ADD CONSTRAINT `content_users_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `content_users_userid_fk` FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customfields`
--
ALTER TABLE `customfields`
  ADD CONSTRAINT `customfield_group_fk` FOREIGN KEY (`groupid`) REFERENCES `customfieldgroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `customfield_type_fk` FOREIGN KEY (`typeid`) REFERENCES `customfieldtypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `media`
--
ALTER TABLE `media`
  ADD CONSTRAINT `media_ibfk_1` FOREIGN KEY (`mimetypeid`) REFERENCES `mimetypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `media_terms`
--
ALTER TABLE `media_terms`
  ADD CONSTRAINT `media_terms_mediaid_fk` FOREIGN KEY (`mediaid`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `media_terms_termid_fk` FOREIGN KEY (`termid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `perms`
--
ALTER TABLE `perms`
  ADD CONSTRAINT `perms_permgroupid_fk` FOREIGN KEY (`permgroupid`) REFERENCES `permgroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `template_customfields`
--
ALTER TABLE `template_customfields`
  ADD CONSTRAINT `template_customfields_customfieldid_fk` FOREIGN KEY (`customfieldid`) REFERENCES `customfields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `template_customfields_templateid_fk` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `term_taxonomy`
--
ALTER TABLE `term_taxonomy`
  ADD CONSTRAINT `term_taxonomy_parent_term_taxonomy_fk` FOREIGN KEY (`parentid`) REFERENCES `term_taxonomy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `term_taxonomy_termid_fk` FOREIGN KEY (`termid`) REFERENCES `terms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_usergroup_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_notes`
--
ALTER TABLE `user_notes`
  ADD CONSTRAINT `user_notes_userid_fk` FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_usercategories`
--
ALTER TABLE `user_usercategories`
  ADD CONSTRAINT `userusercategories_categoryid_fk` FOREIGN KEY (`categoryid`) REFERENCES `usercategories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `userusercategories_userid_fk` FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usercategories`
--
ALTER TABLE `usercategories`
  ADD CONSTRAINT `usercategories_usergroupid_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usergroup_perms`
--
ALTER TABLE `usergroup_perms`
  ADD CONSTRAINT `usergroup_perms_permid_fk` FOREIGN KEY (`permid`) REFERENCES `perms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usergroup_perms_usergroupid_fk` FOREIGN KEY (`usergroupid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usergroups`
--
ALTER TABLE `usergroups`
  ADD CONSTRAINT `usergroups_parent_usergroups_fk` FOREIGN KEY (`parentid`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
