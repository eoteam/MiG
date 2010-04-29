
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `mig`;

CREATE SCHEMA `mig` DEFAULT CHARACTER SET latin1 ;

USE `mig`;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` (`id`,`name`,`value`,`system`)
VALUES
	(1,'Media','ON',0),
	(2,'Users','ON',0),
	(3,'Fonts','OFF',0),
	(4,'Tags','ON',0),
	(5,'Contacts','OFF',0),
	(7,'Custom Fields','OFF',0),
	(8,'Events','OFF',0),
	(9,'config','config_NDD.xml',1),
	(10,'prompt','New Deal Design',1);

/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;


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
  CONSTRAINT `content_parent_content_fk` FOREIGN KEY (`parentid`) REFERENCES `content` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_status_fk` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `content_template_fk` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=latin1;

LOCK TABLES `content` WRITE;
/*!40000 ALTER TABLE `content` DISABLE KEYS */;
INSERT INTO `content` (`id`,`parentid`,`templateid`,`title`,`migtitle`,`color`,`url`,`permalink`,`shortdescription`,`shortdescription2`,`description`,`description2`,`date`,`statusid`,`customfield1`,`customfield2`,`customfield3`,`customfield4`,`customfield5`,`customfield6`,`customfield7`,`customfield8`,`customfield9`,`customfield10`,`customfield11`,`customfield12`,`containerpath`,`createdby`,`createdate`,`modifiedby`,`modifieddate`,`deleted`,`is_fixed`,`search_exclude`,`can_have_children`,`displayorder`)
VALUES
	(1,1,1,'Root','Root','','','','','','','',0,4,'','','','','','','','','','','','','',1,0,1,0,0,1,1,1,0),
	(2,2,2,'FAQs','FAQs','','','','','','<TextFlow columnCount=\"inherit\" columnGap=\"inherit\" columnWidth=\"inherit\" lineBreak=\"inherit\" paddingBottom=\"inherit\" paddingLeft=\"inherit\" paddingRight=\"inherit\" paddingTop=\"inherit\" verticalAlign=\"inherit\" whiteSpaceCollapse=\"preserve\" xmlns=\"http://ns.adobe.com/textLayout/2008\"><p direction=\"ltr\" justificationRule=\"auto\" justificationStyle=\"auto\" leadingModel=\"auto\" paragraphEndIndent=\"0\" paragraphSpaceAfter=\"0\" paragraphSpaceBefore=\"0\" paragraphStartIndent=\"0\" textAlign=\"left\" textAlignLast=\"start\" textIndent=\"0\" textJustify=\"interWord\"><span alignmentBaseline=\"useDominantBaseline\" backgroundAlpha=\"1\" backgroundColor=\"transparent\" baselineShift=\"0\" breakOpportunity=\"auto\" cffHinting=\"horizontalStem\" color=\"0xffffff\" digitCase=\"default\" digitWidth=\"default\" dominantBaseline=\"auto\" fontFamily=\"Transmit-Bold\" fontLookup=\"device\" fontSize=\"13.9\" fontStyle=\"normal\" fontWeight=\"normal\" kerning=\"off\" ligatureLevel=\"common\" lineHeight=\"120%\" lineThrough=\"false\" locale=\"en\" renderingMode=\"cff\" textAlpha=\"1\" textDecoration=\"none\" textRotation=\"auto\" trackingLeft=\"0\" trackingRight=\"0\" typographicCase=\"default\"></span></p></TextFlow>','<TextFlow columnCount=\"inherit\" columnGap=\"inherit\" columnWidth=\"inherit\" lineBreak=\"inherit\" paddingBottom=\"inherit\" paddingLeft=\"inherit\" paddingRight=\"inherit\" paddingTop=\"inherit\" verticalAlign=\"inherit\" whiteSpaceCollapse=\"preserve\" xmlns=\"http://ns.adobe.com/textLayout/2008\"><p direction=\"ltr\" justificationRule=\"auto\" justificationStyle=\"auto\" leadingModel=\"auto\" paragraphEndIndent=\"0\" paragraphSpaceAfter=\"0\" paragraphSpaceBefore=\"0\" paragraphStartIndent=\"0\" textAlign=\"left\" textAlignLast=\"start\" textIndent=\"0\" textJustify=\"interWord\"><span alignmentBaseline=\"useDominantBaseline\" backgroundAlpha=\"1\" backgroundColor=\"transparent\" baselineShift=\"0\" breakOpportunity=\"auto\" cffHinting=\"horizontalStem\" color=\"0xffffff\" digitCase=\"default\" digitWidth=\"default\" dominantBaseline=\"auto\" fontFamily=\"Transmit-Bold\" fontLookup=\"embeddedCFF\" fontSize=\"13.9\" fontStyle=\"normal\" fontWeight=\"normal\" kerning=\"off\" ligatureLevel=\"common\" lineHeight=\"120%\" lineThrough=\"false\" locale=\"en\" renderingMode=\"cff\" textAlpha=\"1\" textDecoration=\"none\" textRotation=\"auto\" trackingLeft=\"0\" trackingRight=\"0\" typographicCase=\"default\"/></p></TextFlow>',0,4,'','','','','','','','','','','','','FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs<>FAQs',0,0,1,1269375147127,0,1,1,1,1),
	(3,1,3,'Projects','Projects','','projects','','','','','',1267520400000,4,'','','','','','','','','','','','','Root',0,0,5,1269465079048,0,1,1,1,1),
	(4,1,3,'Posts','Posts','','','','','','','',0,4,'','','','','','','','','','','','','Root',0,0,5,1269465079048,0,1,1,1,2),
	(5,1,3,'Awards','Awards','','','','','','','',1255770000000,4,'','','','','','','','','','','','','Root',0,0,6,1269969370045,0,1,1,1,3),
	(6,1,3,'Media','Media','','media','','','','','',0,4,'','','','','','','','','','','','','Root',0,0,5,1269528891729,0,1,1,1,4),
	(7,1,7,'Stream','Stream','','stream','','','','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span></span></p></TextFlow>','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span/></p></TextFlow>',0,4,'','newdealdesign,newdealstudio,gadiamit','','','','','','','','','','','Root',0,0,5,1270072016483,0,1,1,1,5),
	(8,1,3,'About Us','About Us','','aboutus','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi commodo, ipsum sed pharetra gravida, orci magna rhoncus neque, id pulvinar odio lorem non turpis. Nullam sit amet enim. Suspendisse id velit vitae ligula volutpat condimentum. Aliquam erat volutpat. Sed quis velit. Nulla facilisi. Nulla libero. Vivamus pharetra posuere sapien. Nam consectetuer. Sed aliquam, nunc eget euismod ullamcorper, lectus nunc ullamcorper orci, fermentum bibendum enim nibh eget ipsum. Donec porttitor ligula eu dolor. Maecenas vitae nulla consequat libero cursus venenatis. Nam magna enim, accumsan eu, blandit sed, blandit a, eros.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Quisque facilisis erat a dui. Nam malesuada ornare dolor. Cras gravida, diam sit amet rhoncus ornare, erat elit consectetuer erat, id egestas pede nibh eget odio. Proin tincidunt, velit vel porta elementum, magna diam molestie sapien, non aliquet massa pede eu diam.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi commodo, ipsum sed pharetra gravida, orci magna rhoncus neque, id pulvinar odio lorem non turpis. Nullam sit amet enim. Suspendisse id velit vitae ligula volutpat condimentum. Aliquam erat volutpat. Sed quis velit. Nulla facilisi. Nulla libero. Vivamus pharetra posuere sapien. Nam consectetuer. Sed aliquam, nunc eget euismod ullamcorper, lectus nunc ullamcorper orci, fermentum bibendum enim nibh eget ipsum. Donec porttitor ligula eu dolor. Maecenas vitae nulla consequat libero cursus venenatis. Nam magna enim, accumsan eu, blandit sed, blandit a, eros.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Quisque facilisis erat a dui. Nam malesuada ornare dolor. Cras gravida, diam sit amet rhoncus ornare, erat elit consectetuer erat, id egestas pede nibh eget odio. Proin tincidunt, velit vel porta elementum, magna diam molestie sapien, non aliquet massa pede eu diam.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p></body>',0,4,'','','','','','','','','','','','','Root',0,0,6,1270076545629,0,1,1,1,6),
	(9,1,3,'Contact','Contact','','contact','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi commodo, ipsum sed pharetra gravida, orci magna rhoncus neque, id pulvinar odio lorem non turpis. Nullam sit amet enim. Suspendisse id velit vitae ligula volutpat condimentum. Aliquam erat volutpat. Sed quis velit. Nulla facilisi. Nulla libero. Vivamus pharetra posuere sapien. Nam consectetuer. Sed aliquam, nunc eget euismod ullamcorper, lectus nunc ullamcorper orci, fermentum bibendum enim nibh eget ipsum. Donec porttitor ligula eu dolor. Maecenas vitae nulla consequat libero cursus venenatis. Nam magna enim, accumsan eu, blandit sed, blandit a, eros.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Quisque facilisis erat a dui. Nam malesuada ornare dolor. Cras gravida, diam sit amet rhoncus ornare, erat elit consectetuer erat, id egestas pede nibh eget odio. Proin tincidunt, velit vel porta elementum, magna diam molestie sapien, non aliquet massa pede eu diam.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi commodo, ipsum sed pharetra gravida, orci magna rhoncus neque, id pulvinar odio lorem non turpis. Nullam sit amet enim. Suspendisse id velit vitae ligula volutpat condimentum. Aliquam erat volutpat. Sed quis velit. Nulla facilisi. Nulla libero. Vivamus pharetra posuere sapien. Nam consectetuer. Sed aliquam, nunc eget euismod ullamcorper, lectus nunc ullamcorper orci, fermentum bibendum enim nibh eget ipsum. Donec porttitor ligula eu dolor. Maecenas vitae nulla consequat libero cursus venenatis. Nam magna enim, accumsan eu, blandit sed, blandit a, eros.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Quisque facilisis erat a dui. Nam malesuada ornare dolor. Cras gravida, diam sit amet rhoncus ornare, erat elit consectetuer erat, id egestas pede nibh eget odio. Proin tincidunt, velit vel porta elementum, magna diam molestie sapien, non aliquet massa pede eu diam.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p></body>',0,4,'','','','','','','','','','','','','Root',0,0,5,1269548152487,0,1,1,1,7),
	(10,3,4,'Fitfffffff','Fitbit Tracker','324324','projects/fitbit','','','','sdsdasdsadsa','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span>Cras dictum. Maecenas ut turpis. In vitae erat ac orci dignissim eleifend. Nunc quis justo. Sed vel ipsum in purus tincidunt pharetra. Sed pulvinar, felis id consectetuer malesuada, enim nisl mattis elit, a facilisis tortor nibh quis leo. Sed augue lacus, pretium vitae, molestie eget, rhoncus quis, elit. Donec in augue. Fusce orci wisi, ornare id, mollis vel, lacinia vel, massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</span></p></TextFlow>',1268211600000,4,'','','','','','','','','','','','','Root<>Projects',1,1267733775278,6,1270076443308,0,0,0,0,2),
	(11,3,4,'Dell Studio Hybrid','Dell Studio Hybrid','','projects/dellstudiohybrid','','','','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span>Maecenas ut turpis. In vitae erat ac orci dignissim eleifend. Nunc quis justo. Sed vel ipsum in purus tincidunt pharetra. Sed pulvinar, felis id consectetuer malesuada, enim nisl mattis elit, a facilisis tortor nibh quis leo. Sed augue lacus, pretium vitae, molestie eget, rhoncus quis, elit. Donec in augue. Fusce orci wisi, ornare id, mollis vel, lacinia vel, massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</span></p></TextFlow>','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span>Maecenas ut turpis. In vitae erat ac orci dignissim eleifend. Nunc quis justo. Sed vel ipsum in purus tincidunt pharetra. Sed pulvinar, felis id consectetuer malesuada, enim nisl mattis elit, a facilisis tortor nibh quis leo. Sed augue lacus, pretium vitae, molestie eget, rhoncus quis, elit. Donec in augue. Fusce orci wisi, ornare id, mollis vel, lacinia vel, massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</span></p></TextFlow>',1269939600000,4,'','','','','','','','','','','','','Root<>Projects',1,1267733781751,5,1269960909244,0,0,0,0,3),
	(12,3,4,'Ogo','Ogo','','projects/ogo','','','','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span>Nulla facilisi. In vel sem. Morbi id urna in diam dignissim feugiat. Proin molestie tortor eu velit. Aliquam erat volutpat. Nullam ultrices, diam tempus vulputate egestas, eros pede varius leo, sed imperdiet lectus est ornare odio. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin consectetuer velit in dui. Phasellus wisi purus, interdum vitae, rutrum accumsan, viverra in, velit. Sed enim risus, congue non, tristique in, commodo eu, metus. Aenean tortor mi, imperdiet id, gravida eu, posuere eu, felis. Mauris sollicitudin, turpis in hendrerit sodales, lectus ipsum pellentesque ligula, sit amet scelerisque urna nibh ut arcu. Aliquam in lacus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla placerat aliquam wisi. Mauris viverra odio. Quisque fermentum pulvinar odio. Proin posuere est vitae ligula. Etiam euismod. Cras a eros.</span></p></TextFlow>','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span>Nulla facilisi. In vel sem. Morbi id urna in diam dignissim feugiat. Proin molestie tortor eu velit. Aliquam erat volutpat. Nullam ultrices, diam tempus vulputate egestas, eros pede varius leo, sed imperdiet lectus est ornare odio. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin consectetuer velit in dui. Phasellus wisi purus, interdum vitae, rutrum accumsan, viverra in, velit. Sed enim risus, congue non, tristique in, commodo eu, metus. Aenean tortor mi, imperdiet id, gravida eu, posuere eu, felis. Mauris sollicitudin, turpis in hendrerit sodales, lectus ipsum pellentesque ligula, sit amet scelerisque urna nibh ut arcu. Aliquam in lacus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla placerat aliquam wisi. Mauris viverra odio. Quisque fermentum pulvinar odio. Proin posuere est vitae ligula. Etiam euismod. Cras a eros.</span></p></TextFlow>',1263286800000,4,'','','','','','','','','','','','','Root<>Projects',1,1267733790007,5,1269960920137,0,0,0,0,4),
	(13,3,4,'Tana Water Bar','Tana Water Bar','','tana','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>A new generation of the market-defining, best-selling Tana Water Bar.</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>A new generation of the market-defining, best-selling Tana Water Bar.</span></Font></p></body>',1268125200000,4,'','','','','','','','','','','','','Root<>Projects',1,1267733775278,5,1268923509782,1,0,0,0,1),
	(14,5,6,'Red Dot 09','Red Dot 09','','awards/reddot09','','','','','',1237453200000,4,'','','','','','','','','','','','','Root<>Awards',1,1267733907327,6,1269632295696,1,0,0,0,2),
	(15,5,6,'Index 09','Index 09','','awards/index09','','','','','',1238144400000,4,'','','','','','','','','','','','','Root<>Awards',1,1267733912189,6,1269632323803,1,0,0,0,3),
	(16,5,6,'Index Finalist 09','Index Finalist 09','','awards/indexfinalist09','','','','','',1236243600000,4,'','','','','','','','','','','','','Root<>Awards',1,1267733917398,6,1269632330300,1,0,0,0,4),
	(17,5,6,'Award 4','Award 4','','awards/award-4','','','','','',0,4,'','','','','','','','','','','','','Root<>Awards',1,1268674033893,6,1269632346186,1,0,0,0,1),
	(18,4,5,'Fire, Agriculture, Design: How Human Creativity Built Society','Fire, Agriculture, Design: How Human Creativity Built Society','','posts/fire_agriculture_design_how_human_creativity_built_society','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Ever since the Renaissance, we have been told that art is a product of a noble society, one that is rich enough and functional enough to support the muse. Maslow\\\'s hierarchy of needs made that belief into science: In order for humans to reach the peaks of artistic thinking, he postulated, they must provide for their most basic needs such as food, shelter, sex and more. This social science axiom has been introduced to me more than once in meetings about design, effectively suggesting that design (and art) are secondary and may exist only at the benevolence of functionalists, those people who satisfy our core existential needs first. With that idea so deeply ingrained in our culture, society is now programmed to see art and design as luxury we can afford only after our basic \\\"needs\\\" are met.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I was not too old when I noticed that humans do quite extreme things out of wish, rather than necessity. Great poetry was created through misery and truly horrific deeds were born in the comfort of well-to-do societies. Without getting too much into politics or philosophy, I simply wasn\\\'t buying the Maslow theory. Now comes a possible proof for a complete reversal of this hierarchy: How Art Made the World is a wonderful TV series, brilliantly hosted by Dr. Nigel Spivey.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Spivey presents the viewer with a provocative and scientifically-proven concept aiming to topple our Western function-first paradigm. It provides compelling evidence that the need to tell stories, visualize dreams and congregate for rituals drove humans to settle, evolve social structures and develop functional skills like crafting objects. In plain English: art, design, storytelling and rituals are essential--and a precondition to much of human society.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>How Art Made the World takes us to the deepest caves, showing us paintings of beautiful animals created about 30,000 years ago, in the full glory of the artist\\\'s abstract and nuanced control. Counter to popular belief, these animals depicted are not the common game animals. These are in fact rare creature of majestic presence, appearing in dreams and ritual--we know that since the bones found in those caves were of different animals, the ones that were actually hunted and consumed.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>hen we are told that for tens of thousands of years humanity stopped living in caves and transformed its society from hunter-gatherer to agricultural--how did this happen? Well, the first human villages were created for ritual, as a central place of worship. These places saw the creation of architecture, cultivation of wheat and massive public-works projects, designed by a society with skills, artisanship and structure. The evidence found in a remote site in Turkey as well as at Stonehenge show a clear link between the ritual, the structure made for that ritual, and the establishment of a settlement, social structure and the calls of artisans.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The series goes on to suggest to origin of branding through the story of Alexander the Great literally \\\"coining\\\" himself by putting his likeness on currency. Although the program uses \\\"art\\\" as its topic, the actual pieces of evidence are more works of design than pure art.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>As John F. Kennedy, Jr. said, we chose to go to the moon not because it was easy--and not because we had a score to settle with the other guys. It is a dream humanity had and we fulfilled this dream because the moon was there. We humans are unique in our drive to climb mountains, physical or not, just because \\\"it\\\'s there.\\\" This is how Sir Edmund Hillary described the rationale behind his quest to climb Mount Everest.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Ever since the Renaissance, we have been told that art is a product of a noble society, one that is rich enough and functional enough to support the muse. Maslow\\\'s hierarchy of needs made that belief into science: In order for humans to reach the peaks of artistic thinking, he postulated, they must provide for their most basic needs such as food, shelter, sex and more. This social science axiom has been introduced to me more than once in meetings about design, effectively suggesting that design (and art) are secondary and may exist only at the benevolence of functionalists, those people who satisfy our core existential needs first. With that idea so deeply ingrained in our culture, society is now programmed to see art and design as luxury we can afford only after our basic \\\"needs\\\" are met.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I was not too old when I noticed that humans do quite extreme things out of wish, rather than necessity. Great poetry was created through misery and truly horrific deeds were born in the comfort of well-to-do societies. Without getting too much into politics or philosophy, I simply wasn\\\'t buying the Maslow theory. Now comes a possible proof for a complete reversal of this hierarchy: How Art Made the World is a wonderful TV series, brilliantly hosted by Dr. Nigel Spivey.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Spivey presents the viewer with a provocative and scientifically-proven concept aiming to topple our Western function-first paradigm. It provides compelling evidence that the need to tell stories, visualize dreams and congregate for rituals drove humans to settle, evolve social structures and develop functional skills like crafting objects. In plain English: art, design, storytelling and rituals are essential--and a precondition to much of human society.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>How Art Made the World takes us to the deepest caves, showing us paintings of beautiful animals created about 30,000 years ago, in the full glory of the artist\\\'s abstract and nuanced control. Counter to popular belief, these animals depicted are not the common game animals. These are in fact rare creature of majestic presence, appearing in dreams and ritual--we know that since the bones found in those caves were of different animals, the ones that were actually hunted and consumed.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>hen we are told that for tens of thousands of years humanity stopped living in caves and transformed its society from hunter-gatherer to agricultural--how did this happen? Well, the first human villages were created for ritual, as a central place of worship. These places saw the creation of architecture, cultivation of wheat and massive public-works projects, designed by a society with skills, artisanship and structure. The evidence found in a remote site in Turkey as well as at Stonehenge show a clear link between the ritual, the structure made for that ritual, and the establishment of a settlement, social structure and the calls of artisans.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The series goes on to suggest to origin of branding through the story of Alexander the Great literally \\\"coining\\\" himself by putting his likeness on currency. Although the program uses \\\"art\\\" as its topic, the actual pieces of evidence are more works of design than pure art.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>As John F. Kennedy, Jr. said, we chose to go to the moon not because it was easy--and not because we had a score to settle with the other guys. It is a dream humanity had and we fulfilled this dream because the moon was there. We humans are unique in our drive to climb mountains, physical or not, just because \\\"it\\\'s there.\\\" This is how Sir Edmund Hillary described the rationale behind his quest to climb Mount Everest.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p></body>',1265014800000,4,'Test Author','','','','','','','','','','','','Root<>Posts',1,1267733885196,5,1269634962238,0,0,0,0,7),
	(19,4,5,'Apple may change the world&#8230; again.','Apple may change the world&#8230; again.','','posts/apple-may-change-world-again','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>In a few days or weeks, according to rumors(http://gizmodo.com/5434566/the-exhaustive-guide-to-apple-tablet-rumors), Apple will introduce a new device to the market. Apparently it&#8217;s a Tablet device, with either 7&#8221; or 10&#8221; display. With much commotion in the tech blogsphere, the &#8216;iSlate&#8217; (as was suggested) is discussed as if it is a fact of life. However one crucial detail is not clear &#8211; will this be a Cellular device like the iPhone or just another WiFi device like the iPod Touch.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Here is my prediction &#8211; I hope it is a truly mobile cellular device like the iPhone and if so, we&#8217;re in for a massive change in the world of computing as we know it.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>First, a cellular mobile tablet launched by a power-house like Apple will overnight change the PC world, rendering many laptops obsolete and redefine usability and mobility. As any user of a smart-phone noticed, it is only a little extra functionality that holds you from leaving your heavy laptop at home while you&#8217;re traveling around. Schlepping around with a 5-6Lbs brick, regardless of design and quality, is far less fun than carrying a svelte 1lbs Tablet (my guesstimate for weight). &#8216;Disruptive&#8217; should be an understated word concerning the device&#8217;s possible impact on the PC world &#8211; ending one of its worst years ever, with margins squeezed to the limits, the last thing giants such as HP, Dell or Acer need is a device questioning the merits of their only profitable item, the executive laptop.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Second, since Apple has rarely (or actually&#8230;never?) failed with market introduction of a strategic device, I will go out on a limb and say that this might change the Software industry as well. With its iPhone app store being so robust and successful, Apple&#8217;s Tablet will surely carry on and extended that model. In doing so we can kiss goodbye to the days of $300-Application as the Micosoft, Adobe and others forced upon us in the last 20 years. Say &#8216;welcome&#8217; to the $19.99 &#8216;Office&#8217; app.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Again, all the above is assuming a Mobile/Cellular device, not a mere WiFi &#8216;grown-up&#8217; iPod.  I hope this is still Steve&#8217;s Apple and the obvious will be done &#8211; Apple will push RESET to the PC world and release a the first truly personal computer. If it&#8217;s just a grown-up iPod Touch, I will be disappointed and assume Apple&#8217;s bean-counters held it back due to fears of cannibalizing Mac sales... But that&#8217;s just me.</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>In a few days or weeks, according to rumors(http://gizmodo.com/5434566/the-exhaustive-guide-to-apple-tablet-rumors), Apple will introduce a new device to the market. Apparently it&#8217;s a Tablet device, with either 7&#8221; or 10&#8221; display. With much commotion in the tech blogsphere, the &#8216;iSlate&#8217; (as was suggested) is discussed as if it is a fact of life. However one crucial detail is not clear &#8211; will this be a Cellular device like the iPhone or just another WiFi device like the iPod Touch.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Here is my prediction &#8211; I hope it is a truly mobile cellular device like the iPhone and if so, we&#8217;re in for a massive change in the world of computing as we know it.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>First, a cellular mobile tablet launched by a power-house like Apple will overnight change the PC world, rendering many laptops obsolete and redefine usability and mobility. As any user of a smart-phone noticed, it is only a little extra functionality that holds you from leaving your heavy laptop at home while you&#8217;re traveling around. Schlepping around with a 5-6Lbs brick, regardless of design and quality, is far less fun than carrying a svelte 1lbs Tablet (my guesstimate for weight). &#8216;Disruptive&#8217; should be an understated word concerning the device&#8217;s possible impact on the PC world &#8211; ending one of its worst years ever, with margins squeezed to the limits, the last thing giants such as HP, Dell or Acer need is a device questioning the merits of their only profitable item, the executive laptop.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Second, since Apple has rarely (or actually&#8230;never?) failed with market introduction of a strategic device, I will go out on a limb and say that this might change the Software industry as well. With its iPhone app store being so robust and successful, Apple&#8217;s Tablet will surely carry on and extended that model. In doing so we can kiss goodbye to the days of $300-Application as the Micosoft, Adobe and others forced upon us in the last 20 years. Say &#8216;welcome&#8217; to the $19.99 &#8216;Office&#8217; app.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Again, all the above is assuming a Mobile/Cellular device, not a mere WiFi &#8216;grown-up&#8217; iPod.  I hope this is still Steve&#8217;s Apple and the obvious will be done &#8211; Apple will push RESET to the PC world and release a the first truly personal computer. If it&#8217;s just a grown-up iPod Touch, I will be disappointed and assume Apple&#8217;s bean-counters held it back due to fears of cannibalizing Mac sales... But that&#8217;s just me.</span></Font></p></body>',1255597200000,4,'','','','','','','','','','','','','Root<>Posts',1,1267733893450,6,1269642124450,0,0,0,0,8),
	(20,4,5,'Making sense of Design Thinking: Three definitions, two problems and one big question','Making sense of Design Thinking: Three definitions, two problems and one big question','','posts/making-sense-design-thinking-three-definitions-two-problems','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>It won&#8217;t surprise anyone who read this blog that I am not an admirer of the Design Thinking phenomenon. I will call myself a skeptic observer. However I am not directly oppose to it. If you wonder how come, you should consider the confused and blurred presentation of Design Thinking throughout the design world - I don&#8217;t know if I&#8217;m &#8216;against&#8217; or &#8216;for&#8217; something so ill defined. So while trying to refine the point for myself, I am defining it in three ways, noting two major problems and asking a question.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span> </span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>First, Design Thinking as Synthetic thinking.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>At first, in 1960&#8217;s, researchers from the field of Cognitive Psychology (notably Herbert Simon -http://en.wikipedia.org/wiki/Herbert_Simon) used Design Thinking in parallel with the term Synthetic Thinking - the combination of ideas into a complex whole. The general notion is to define a philosophical difference between the traditional scientific analytical thinking and a type of thinking specializing in convergence, rather than divergence. Implicitly it should be noted that Design Thinking is not new and has nothing to add to the well-discussed subject of the limitation of analytical thinking and management. In fact, I was first exposed to the term over 20 years ago by my dad, an architect. Today I find it more than ironic that the people who promote the Design thinking notion are among the more analytical, systemic and process-driven persona in the design world. After all, the notion of Design Thinking, as well as Synthetic thinking, was originated to a degree as the antithesis of Analytical thinking. Naturally as a &#8216;classic&#8217; designer, I am fully on-board with the notion that the convergence of ideas into a cohesive whole, or to be precise, the Quality of such convergence, is at the core of what I do as much as any designer work since Brunelleschi. I also believe non-designers acting and implementing Synthetic thinking daily, throughout many aspects of life. Possibly any large complex problem is by definition solved through Synthetic/design thinking since by analysis alone you get nowhere.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span> </span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Second, Design Thinking as a Methodology.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Over the last decade, in part because of the growing recognition in Design, the methodology of design was gaining credit as a worthy management method. This lead to formulating Design Thinking as a methodology - the prescribed process of Define-Research-Ideate-Prototype-Choose-Implement-Learn (http://en.wikipedia.org/wiki/Design_thinking). Again, there is nothing new about it since it resembles any design process description I heard off. I have two major problems with the Design Thinking methodology-</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>a. I think Design thinking is regressive and risky for design since it is placing thought (&#8216;define&#8217;) always before action (&#8216;prototype&#8217;) and analysis (&#8216;research&#8217;) as the precursor to creativity (&#8216;ideate&#8217;). I simply don&#8217;t believe the wheel was created through this process. In fact, the real challenge designers face is the opposite - a recognition that action (prototyping, sketching) often precede thinking and many products, inventions and great companies were born out of a burst of creativity and not through a regimented thought process. Furthermore, the notion of linear process as the absolute gold-standard for proper management and creativity is, in reality, one big fallacy. Linear process&#8217; are seldom the way the world works. The non-linear and even chaotic nature of creative thinking is curtailed by a false presentation of a sqeeky-clean linear process.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>b. I find it disingenuous to retroactively assign &#8216;design thinking&#8217; label over the work of some of our best entrepreneurial thinkers. The &#8216;Design Thinking&#8217; community is full of that.  I recently read in a blog that both Steve Jobs and Philippe Starck are among the top-20 design thinkers. These are two great creative individuals yet we simply don&#8217;t know if they are &#8216;design thinkers&#8217;. I will more than surprise to find Starck&#8217;s legendary-quick artistic process is actually a premeditated Design-thinking act. Steve Jobs is obviously one of the best technology leaders we are blessed with. Jobs&#8217; Apple is a brilliant continuum of visionary business leadership, yet it could be called &#8216;Design thinking&#8217; only through an act of jarring revisionism: Apple or the Macintosh platform was not envisioned by a declared design-thinker, following the process mentioned above. So the problem here is simple - where is the proof for Design thinking efficacy? It will be nice to see real examples of true &#8216;design thinking&#8217; process succeeding in real life, delivering the true proof-in-pudding for the efficacy of design-thinkers as business leaders. </span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span> </span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Design Thinking as a Marketing slogan.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Third and last is the hidden definition - what is not said clearly and is not discussed openly is quite the obvious, that Design thinking is a marketing slogan adapted by a very large and influential Innovation consultancy to redefine its services to be somewhat-similar to Business consulting. Nothing wrong with that except that it&#8217;s not clearly discussed and acknowledged. The transformation of a message from &#8216;Innovation&#8217; to &#8216;Design thinking&#8217; is therefore also an amazing business strategy transformation through PR and marketing campaign. The large Innovation agencies of the early 2000&#8217;s transformed their message for &#8216;Design thinking&#8217; not only because of a sudden discovery or change of heart - simply put, they had to. The business of a large creative agency at the early of 2000&#8217;s was based on Product Development (aka &#8216;Innovation&#8217;), or to be precise, selling Engineering hours. These expensive billable-hours went to China and something new had to be found. Luckily for them, the MBA methodology was overhyped and too expensive with results varying and less than perfectly quantifiable. And here laid an opportunity: Creating a new strategy based on old corporate in-roads from the &#8216;Innovation&#8217; era with more tangible results compared with McKinsey&#8217;s. The transformation of large Design agencies to a worthy competitor of the large management consulting firms is a very interesting phenomenon. I am sure that if it is truly successful, design as a whole will gain some additional respect, maybe to level MBA grew to become the preeminent management methodology. However, there is some hesitation by the large Design thinking agencies to clearly position themselves as direct competitors to McKinsey, Boston Consulting and such. This hesitation is telling and perhaps a sign of weakness, possibly due to clients reaction. Lately I was privy to two cases in which very large clients received the results of a large Design Thinking project and... opted to continue with actual design work with a more traditional design house. It looks as if in reality clients perceive &#8216;Design Thinking&#8217; as Think-but-don&#8217;t-Design, not as Think-then-Design as suggested.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span> </span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>So here comes the big question - why won&#8217;t Design Thinking be presented as service, on par with Business Consulting?</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>It won&#8217;t surprise anyone who read this blog that I am not an admirer of the Design Thinking phenomenon. I will call myself a skeptic observer. However I am not directly oppose to it. If you wonder how come, you should consider the confused and blurred presentation of Design Thinking throughout the design world - I don&#8217;t know if I&#8217;m &#8216;against&#8217; or &#8216;for&#8217; something so ill defined. So while trying to refine the point for myself, I am defining it in three ways, noting two major problems and asking a question.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span> </span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>First, Design Thinking as Synthetic thinking.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>At first, in 1960&#8217;s, researchers from the field of Cognitive Psychology (notably Herbert Simon -http://en.wikipedia.org/wiki/Herbert_Simon) used Design Thinking in parallel with the term Synthetic Thinking - the combination of ideas into a complex whole. The general notion is to define a philosophical difference between the traditional scientific analytical thinking and a type of thinking specializing in convergence, rather than divergence. Implicitly it should be noted that Design Thinking is not new and has nothing to add to the well-discussed subject of the limitation of analytical thinking and management. In fact, I was first exposed to the term over 20 years ago by my dad, an architect. Today I find it more than ironic that the people who promote the Design thinking notion are among the more analytical, systemic and process-driven persona in the design world. After all, the notion of Design Thinking, as well as Synthetic thinking, was originated to a degree as the antithesis of Analytical thinking. Naturally as a &#8216;classic&#8217; designer, I am fully on-board with the notion that the convergence of ideas into a cohesive whole, or to be precise, the Quality of such convergence, is at the core of what I do as much as any designer work since Brunelleschi. I also believe non-designers acting and implementing Synthetic thinking daily, throughout many aspects of life. Possibly any large complex problem is by definition solved through Synthetic/design thinking since by analysis alone you get nowhere.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span> </span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Second, Design Thinking as a Methodology.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Over the last decade, in part because of the growing recognition in Design, the methodology of design was gaining credit as a worthy management method. This lead to formulating Design Thinking as a methodology - the prescribed process of Define-Research-Ideate-Prototype-Choose-Implement-Learn (http://en.wikipedia.org/wiki/Design_thinking). Again, there is nothing new about it since it resembles any design process description I heard off. I have two major problems with the Design Thinking methodology-</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>a. I think Design thinking is regressive and risky for design since it is placing thought (&#8216;define&#8217;) always before action (&#8216;prototype&#8217;) and analysis (&#8216;research&#8217;) as the precursor to creativity (&#8216;ideate&#8217;). I simply don&#8217;t believe the wheel was created through this process. In fact, the real challenge designers face is the opposite - a recognition that action (prototyping, sketching) often precede thinking and many products, inventions and great companies were born out of a burst of creativity and not through a regimented thought process. Furthermore, the notion of linear process as the absolute gold-standard for proper management and creativity is, in reality, one big fallacy. Linear process&#8217; are seldom the way the world works. The non-linear and even chaotic nature of creative thinking is curtailed by a false presentation of a sqeeky-clean linear process.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>b. I find it disingenuous to retroactively assign &#8216;design thinking&#8217; label over the work of some of our best entrepreneurial thinkers. The &#8216;Design Thinking&#8217; community is full of that.  I recently read in a blog that both Steve Jobs and Philippe Starck are among the top-20 design thinkers. These are two great creative individuals yet we simply don&#8217;t know if they are &#8216;design thinkers&#8217;. I will more than surprise to find Starck&#8217;s legendary-quick artistic process is actually a premeditated Design-thinking act. Steve Jobs is obviously one of the best technology leaders we are blessed with. Jobs&#8217; Apple is a brilliant continuum of visionary business leadership, yet it could be called &#8216;Design thinking&#8217; only through an act of jarring revisionism: Apple or the Macintosh platform was not envisioned by a declared design-thinker, following the process mentioned above. So the problem here is simple - where is the proof for Design thinking efficacy? It will be nice to see real examples of true &#8216;design thinking&#8217; process succeeding in real life, delivering the true proof-in-pudding for the efficacy of design-thinkers as business leaders. </span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span> </span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Design Thinking as a Marketing slogan.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Third and last is the hidden definition - what is not said clearly and is not discussed openly is quite the obvious, that Design thinking is a marketing slogan adapted by a very large and influential Innovation consultancy to redefine its services to be somewhat-similar to Business consulting. Nothing wrong with that except that it&#8217;s not clearly discussed and acknowledged. The transformation of a message from &#8216;Innovation&#8217; to &#8216;Design thinking&#8217; is therefore also an amazing business strategy transformation through PR and marketing campaign. The large Innovation agencies of the early 2000&#8217;s transformed their message for &#8216;Design thinking&#8217; not only because of a sudden discovery or change of heart - simply put, they had to. The business of a large creative agency at the early of 2000&#8217;s was based on Product Development (aka &#8216;Innovation&#8217;), or to be precise, selling Engineering hours. These expensive billable-hours went to China and something new had to be found. Luckily for them, the MBA methodology was overhyped and too expensive with results varying and less than perfectly quantifiable. And here laid an opportunity: Creating a new strategy based on old corporate in-roads from the &#8216;Innovation&#8217; era with more tangible results compared with McKinsey&#8217;s. The transformation of large Design agencies to a worthy competitor of the large management consulting firms is a very interesting phenomenon. I am sure that if it is truly successful, design as a whole will gain some additional respect, maybe to level MBA grew to become the preeminent management methodology. However, there is some hesitation by the large Design thinking agencies to clearly position themselves as direct competitors to McKinsey, Boston Consulting and such. This hesitation is telling and perhaps a sign of weakness, possibly due to clients reaction. Lately I was privy to two cases in which very large clients received the results of a large Design Thinking project and... opted to continue with actual design work with a more traditional design house. It looks as if in reality clients perceive &#8216;Design Thinking&#8217; as Think-but-don&#8217;t-Design, not as Think-then-Design as suggested.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span> </span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>So here comes the big question - why won&#8217;t Design Thinking be presented as service, on par with Business Consulting?</span></Font></p></body>',1259398800000,4,'','','','','','','','','','','','','Root<>Posts',1,1267733898885,6,1269044089230,0,0,0,0,9),
	(138,3,4,'raed','raed','','projects/raed','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>jkhjkhkkjhjkhkhkj</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>jkhjkhkkjhjkhkhkj</span></Font></p></body>',0,4,'','','','','','','','','','','','','Root<>Projects',1,1268928037396,5,1268937842122,1,0,0,0,4),
	(139,3,4,'Better Place','Better Place','','projects/betterplace','','','','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span>Proin at eros non eros adipiscing mollis. Donec semper turpis sed diam. Sed consequat ligula nec tortor. Integer eget sem. Ut vitae enim eu est vehicula gravida. Morbi ipsum ipsum, porta nec, tempor id, auctor vitae, purus. Pellentesque neque. Nulla luctus erat vitae libero. Integer nec enim. Phasellus aliquam enim et tortor. Quisque aliquet, quam elementum condimentum feugiat, tellus odio consectetuer wisi, vel nonummy sem neque in elit. Curabitur eleifend wisi iaculis ipsum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In non velit non ligula laoreet ultrices. Praesent ultricies facilisis nisl. Vivamus luctus elit sit amet mi. Phasellus pellentesque, erat eget elementum volutpat, dolor nisl porta neque, vitae sodales ipsum nibh in ligula. Maecenas mattis pulvinar diam. Curabitur sed leo.</span></p></TextFlow>','<TextFlow columnCount=\\\"inherit\\\" columnGap=\\\"inherit\\\" columnWidth=\\\"inherit\\\" lineBreak=\\\"inherit\\\" paddingBottom=\\\"inherit\\\" paddingLeft=\\\"inherit\\\" paddingRight=\\\"inherit\\\" paddingTop=\\\"inherit\\\" verticalAlign=\\\"inherit\\\" whiteSpaceCollapse=\\\"preserve\\\" xmlns=\\\"http://ns.adobe.com/textLayout/2008\\\"><p><span>Proin at eros non eros adipiscing mollis. Donec semper turpis sed diam. Sed consequat ligula nec tortor. Integer eget sem. Ut vitae enim eu est vehicula gravida. Morbi ipsum ipsum, porta nec, tempor id, auctor vitae, purus. Pellentesque neque. Nulla luctus erat vitae libero. Integer nec enim. Phasellus aliquam enim et tortor. Quisque aliquet, quam elementum condimentum feugiat, tellus odio consectetuer wisi, vel nonummy sem neque in elit. Curabitur eleifend wisi iaculis ipsum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In non velit non ligula laoreet ultrices. Praesent ultricies facilisis nisl. Vivamus luctus elit sit amet mi. Phasellus pellentesque, erat eget elementum volutpat, dolor nisl porta neque, vitae sodales ipsum nibh in ligula. Maecenas mattis pulvinar diam. Curabitur sed leo.</span></p></TextFlow>',1267520400000,4,'','','','','','','','','','','','','Root<>Projects',6,1269024865619,6,1269988502892,0,0,0,0,5),
	(140,3,4,'Memorex Clock','Memorex Clock','','projects/memorex_clock','','','','','',1268816400000,4,'','','','','','','','','','','','','Root<>Projects',6,1269027604657,6,1269563404144,0,0,0,0,6),
	(141,3,4,'Glide TV','Glide TV','','projects/glidetv','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>From movies to TV shows, from music services to radio stations, it&#8217;s all there at a click of a mouse.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>But try to access it from your TV using an HTPC and you&#8217;ll discover that you need to balance a whole office on your knees...from a full keyboard to a mouse and a pad. And if you use a universal remote, you\\\'ll discover that two-axis movement is not enough to navigate today\\\'s websites. The experience becomes cumbersome, even frustrating.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>That&#8217;s where GlideTV Navigator comes in...it combines the functionality of a keyboard, mouse and AV remote in an elegant device that fits the palm of your hand.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>GlideTV is the easiest way to surf the net from your TV...head-up and leaning-back.</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>From movies to TV shows, from music services to radio stations, it&#8217;s all there at a click of a mouse.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>But try to access it from your TV using an HTPC and you&#8217;ll discover that you need to balance a whole office on your knees...from a full keyboard to a mouse and a pad. And if you use a universal remote, you\\\'ll discover that two-axis movement is not enough to navigate today\\\'s websites. The experience becomes cumbersome, even frustrating.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>That&#8217;s where GlideTV Navigator comes in...it combines the functionality of a keyboard, mouse and AV remote in an elegant device that fits the palm of your hand.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>GlideTV is the easiest way to surf the net from your TV...head-up and leaning-back.</span></Font></p></body>',1265792400000,4,'','','','','','','','','','','','','Root<>Projects',6,1269032891847,6,1269046254514,0,0,0,0,7),
	(142,3,4,'Cocoon','Cocoon','','projects/cocoon','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>EVERYONE knows that the first few days of large-scale disasters aren&#8217;t easy. Even awful. Saving the most lives possible. Digging and cleaning a bunch of households. Comforting victims and assisting societies. Tough program.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Although some people are looking for practical solutions. Practical means making the most from the same standard device, item, material or whatever.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>And there&#8217;s one concept that like, here at Cocolico. It&#8217;s called the Cocoon, designed by the NewDealDesign, and at first sight, looks like a tent solutions. Homeless population can use them as a primary shelter that doesn&#8217;t need a PhD to get mounted.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>When subsequent tent cities are assembled, the Cocoon shelters can provide additional privacy and security. Such like clothe replacement or building materials for bigger collective buildings.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The three designs, Case, Capsule and Cuddle, cover the full spectrum of need, from larger, more rigid structures to the Cuddle blanket/poncho. This open-source design is intended to be mass produced by local governments, NGOs and the UN.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>EVERYONE knows that the first few days of large-scale disasters aren&#8217;t easy. Even awful. Saving the most lives possible. Digging and cleaning a bunch of households. Comforting victims and assisting societies. Tough program.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Although some people are looking for practical solutions. Practical means making the most from the same standard device, item, material or whatever.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>And there&#8217;s one concept that like, here at Cocolico. It&#8217;s called the Cocoon, designed by the NewDealDesign, and at first sight, looks like a tent solutions. Homeless population can use them as a primary shelter that </span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>When subsequent tent cities are assembled, the Cocoon shelters can provide additional privacy and security. Such like clothe replacement or building materials for bigger collective buildings.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The three designs, Case, Capsule and Cuddle, cover the full spectrum of need, from larger, more rigid structures to the Cuddle blanket/poncho. This open-source design is intended to be mass produced by local governments, NGOs and the UN.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>EVERYONE knows that the first few days of large-scale disasters aren&#8217;t easy. Even awful. Saving the most lives possible. Digging and cleaning a bunch of households. Comforting victims and assisting societies. Tough program.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Although some people are looking for practical solutions. Practical means making the most from the same standard device, item, material or whatever.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>And there&#8217;s one concept that like, here at Cocolico. It&#8217;s called the Cocoon, designed by the NewDealDesign, and at first sight, looks like a tent solutions. Homeless population can use them as a primary shelter that doesn&#8217;t need a PhD to get mounted.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>When subsequent tent cities are assembled, the Cocoon shelters can provide additional privacy and security. Such like clothe replacement or building materials for bigger collective buildings.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The three designs, Case, Capsule and Cuddle, cover the full spectrum of need, from larger, more rigid structures to the Cuddle blanket/poncho. This open-source design is intended to be mass produced by local governments, NGOs and the UN.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>EVERYONE knows that the first few days of large-scale disasters aren&#8217;t easy. Even awful. Saving the most lives possible. Digging and cleaning a bunch of households. Comforting victims and assisting societies. Tough program.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Although some people are looking for practical solutions. Practical means making the most from the same standard device, item, material or whatever.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>And there&#8217;s one concept that like, here at Cocolico. It&#8217;s called the Cocoon, designed by the NewDealDesign, and at first sight, looks like a tent solutions. Homeless population can use them as a primary shelter that doesn&#8217;t need a PhD to get mounted.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>When subsequent tent cities are assembled, the Cocoon shelters can provide additional privacy and security. Such like clothe replacement or building materials for bigger collective buildings.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The three designs, Case, Capsule and Cuddle, cover the full spectrum of need, from larger, more rigid structures to the Cuddle blanket/poncho. This open-source design is intended to be mass produced by local governments, NGOs and the UN.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>EVERYONE knows that the first few days of large-scale disasters aren&#8217;t easy. Even awful. Saving the most lives possible. Digging and cleaning a bunch of households. Comforting victims and assisting societies. Tough program.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Although some people are looking for practical solutions. Practical means making the most from the same standard device, item, material or whatever.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>And there&#8217;s one concept that like, here at Cocolico. It&#8217;s called the Cocoon, designed by the NewDealDesign, and at first sight, looks like a tent solutions. Homeless population can use them as a primary shelter that </span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>When subsequent tent cities are assembled, the Cocoon shelters can provide additional privacy and security. Such like clothe replacement or building materials for bigger collective buildings.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The three designs, Case, Capsule and Cuddle, cover the full spectrum of need, from larger, more rigid structures to the Cuddle blanket/poncho. This open-source design is intended to be mass produced by local governments, NGOs and the UN.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>EVERYONE knows that the first few days of large-scale disasters aren&#8217;t easy. Even awful. Saving the most lives possible. Digging and cleaning a bunch of households. Comforting victims and assisting societies. Tough program.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Although some people are looking for practical solutions. Practical means making the most from the same standard device, item, material or whatever.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>And there&#8217;s one concept that like, here at Cocolico. It&#8217;s called the Cocoon, designed by the NewDealDesign, and at first sight, looks like a tent solutions. Homeless population can use them as a primary shelter that doesn&#8217;t need a PhD to get mounted.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>When subsequent tent cities are assembled, the Cocoon shelters can provide additional privacy and security. Such like clothe replacement or building materials for bigger collective buildings.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The three designs, Case, Capsule and Cuddle, cover the full spectrum of need, from larger, more rigid structures to the Cuddle blanket/poncho. This open-source design is intended to be mass produced by local governments, NGOs and the UN.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p></body>',1268643600000,4,'','','','','','','','','','','','','Root<>Projects',6,1269033309940,6,1269046254514,0,0,0,0,8),
	(143,3,4,'Fujitsu Phones','Fujitsu Phones','','projects/fujitsuphones','','','','','',1210323600000,4,'','','','','','','','','','','','','Root<>Projects',6,1269037351639,6,1269046254514,0,0,0,0,9),
	(144,3,4,'Dell Latitude','Dell Latitude','','projects/dell-latitude','','','','','',1236762000000,4,'','','','','','','','','','','','','Root<>Projects',6,1269039248145,6,1269622691825,0,0,0,0,10),
	(145,3,4,'Netgear','Netgear','','projects/netgear','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Striking in form, rich in detail and clever in function, our design work won many awards and accolades.</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Striking in form, rich in detail and clever in function, our design work won many awards and accolades.</span></Font></p></body>',1260349200000,4,'','','','','','','','','','','','','Root<>Projects',6,1269040389009,6,1269046254514,0,0,0,0,11),
	(146,4,5,'Dear Gadget Reviewers: You Don\\\'t Understand Beauty','Dear Gadget Reviewers: You Don\\\'t Understand Beauty','','posts/dear-gadget-reviewers-you-dont-understand-beauty','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>An entirely new industry of quasi-professional reviewers has grown out of the Internet. And since most of these reviewers are preoccupied with consumer electronics (which is what I design), it hits me close to home. I am well aware of the importance of these many reviews as a public service and as a driver of our tattered economy. But beyond appreciating the variety and diversity of opinion offered, I can\\\'t say I like many of them. Why? Because none of these reviewers understand design.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>When reviewers do feel a need to say something about design, it is usually shallow. Design is routinely mentioned as \\\'looking like\\\' something else. It\\\'s \\\'sleek\\\' or \\\'ugly\\\'--but rarely anything in between.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Take Engadget. It\\\'s a daily staple for me. Engadget is the most energetic venue for hot technology objects, and it has become an influential actor in the design world as a result. I believe they started the \\\"unboxing\\\" ritual that has now become de rigueur for gadget reviewers. But when Engadget writers pay attention to design, they fail to say anything substantial. For example, Engadget covered Dell\\\'s amazingly thin Adamo XPS launch with full attention to teaser imagery, executive comments, and the obvious unboxing. Yet with all that fanfare, and the repeated comparisons to the rival Macbook Air, not much was said about the styling, configuration (\\\"untraditional\\\"!), and structure of this highly unusual notebook. The (very detailed) unboxing was the most disappointing, because here\\\'s what it had that to say about design: \\\"For such a sleek device, the box it comes in is rather huge and bulky.\\\" That\\\'s all? C\\\'mon guys, you can do better!</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>This dismissive, uninformed writing is not the modus operandi of the novices only. Some of the blame here should be directed at The Wall Street Journal\\\'s chief electronics reviewer Walt Mossberg. Mr. Mossberg has become a phenomenon, and for the right reasons: giving honest critique of objects we all consider essential. Mossberg gets a lot of things right--except beauty, fun, and that elusive \\\'got to have it\\\' factor. You know, that factor that tells you to buy (and look at) the red dress? But his reviews have captured too much weight in the industry. And unfortunately, he has inspired a generation of reviewers to adopt the same subtle \\\"geek rage\\\" approach that he often exhibits in his columns.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Take for example CRAVE, CNET\\\'s answer to Engadget. In a post talking about LG\\\'s Chocolate Touch, they said: \\\"The geometric shapes on the back of the phone and the blob-like buttons underneath the display are about the only things that are unique about the phone\\\'s design.\\\" Dear CRAVE editor, I am familiar with geometric shapes from kindergarten, as an adult I am now able to discuss geometry in some detail. Perhaps your writers could distinguish some of those fuzzy geometric forms and enlighten me with an explanation of their positive effect.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>But the worst are the \\\'looks like\\\' comments, which are a double punch: It suggests some plagiarism while refusing to credit good design. Sometimes there are subtle similarities (we call them trends for a reason) and good designers have been known to arrive at the same conclusion from many miles away. In 2001, my firm designed the award- and market-winning Palm Zire. It came in white, silver, and blue covers. Still, reviewers often noted that it \\\"looks like the iPod\\\" even though it was designed before the iPod came to life. Being \\\"like an iPod\\\" is not bad for business, yet it just so happened that the product had a completely different form vernacular. What\\\'s more, it suggests that white has never been used by a designer outside of Apple. In fact, I designed several high-polished white kitchen appliances in the 90s, which shipped millions of units long before Apple introduced its first white product.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>In the end, I am lucky. Designers never get mentioned--good or bad. The reviewers\\\' view of design never causes them to look for the person behind the object\\\'s form, color, or architecture. Isn\\\'t this wonderful? Every napkin-folder catering to a Hollywood movie set will be noted in IMDB, yet the designers of those \\\"sleek\\\" or \\\"ugly\\\" objects never get mentioned.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>But just in case one of the legion of tech reviewers out there would like to change things, here\\\'s a primer on what to look for when reviewing a product:</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>A. Ask about the heritage of the product, and its designer\\\'s intention. What were the constraints and difficulties built into getting the device to market? I am sure any questions will be answered at length, since I know how much my clients are ready to talk up their design investment.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>B. Any \\\"looks like\\\" comment should be carefully dissected as a potentially defamatory remark. If I said your review looked like someone else\\\'s, it might be harmful to your reputation and career--the same is true for designers.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>C. Show me! Imagery is so easy to find and so important when design is discussed. I can\\\'t believe how very little good imagery is shared with the public.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>D. Give credit. Is it that difficult to find the name of a designer or at least a team of designers who worked on the product you\\\'re reviewing?</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>E. Don\\\'t underestimate your audience\\\'s knowledge of design. They go shopping just like you.</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>An entirely new industry of quasi-professional reviewers has grown out of the Internet. And since most of these reviewers are preoccupied with consumer electronics (which is what I design), it hits me close to home. I am well aware of the importance of these many reviews as a public service and as a driver of our tattered economy. But beyond appreciating the variety and diversity of opinion offered, I can\\\'t say I like many of them. Why? Because none of these reviewers understand design.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>When reviewers do feel a need to say something about design, it is usually shallow. Design is routinely mentioned as \\\'looking like\\\' something else. It\\\'s \\\'sleek\\\' or \\\'ugly\\\'--but rarely anything in between.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Take Engadget. It\\\'s a daily staple for me. Engadget is the most energetic venue for hot technology objects, and it has become an influential actor in the design world as a result. I believe they started the \\\"unboxing\\\" ritual that has now become de rigueur for gadget reviewers. But when Engadget writers pay attention to design, they fail to say anything substantial. For example, Engadget covered Dell\\\'s amazingly thin Adamo XPS launch with full attention to teaser imagery, executive comments, and the obvious unboxing. Yet with all that fanfare, and the repeated comparisons to the rival Macbook Air, not much was said about the styling, configuration (\\\"untraditional\\\"!), and structure of this highly unusual notebook. The (very detailed) unboxing was the most disappointing, because here\\\'s what it had that to say about design: \\\"For such a sleek device, the box it comes in is rather huge and bulky.\\\" That\\\'s all? C\\\'mon guys, you can do better!</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>This dismissive, uninformed writing is not the modus operandi of the novices only. Some of the blame here should be directed at The Wall Street Journal\\\'s chief electronics reviewer Walt Mossberg. Mr. Mossberg has become a phenomenon, and for the right reasons: giving honest critique of objects we all consider essential. Mossberg gets a lot of things right--except beauty, fun, and that elusive \\\'got to have it\\\' factor. You know, that factor that tells you to buy (and look at) the red dress? But his reviews have captured too much weight in the industry. And unfortunately, he has inspired a generation of reviewers to adopt the same subtle \\\"geek rage\\\" approach that he often exhibits in his columns.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Take for example CRAVE, CNET\\\'s answer to Engadget. In a post talking about LG\\\'s Chocolate Touch, they said: \\\"The geometric shapes on the back of the phone and the blob-like buttons underneath the display are about the only things that are unique about the phone\\\'s design.\\\" Dear CRAVE editor, I am familiar with geometric shapes from kindergarten, as an adult I am now able to discuss geometry in some detail. Perhaps your writers could distinguish some of those fuzzy geometric forms and enlighten me with an explanation of their positive effect.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>But the worst are the \\\'looks like\\\' comments, which are a double punch: It suggests some plagiarism while refusing to credit good design. Sometimes there are subtle similarities (we call them trends for a reason) and good designers have been known to arrive at the same conclusion from many miles away. In 2001, my firm designed the award- and market-winning Palm Zire. It came in white, silver, and blue covers. Still, reviewers often noted that it \\\"looks like the iPod\\\" even though it was designed before the iPod came to life. Being \\\"like an iPod\\\" is not bad for business, yet it just so happened that the product had a completely different form vernacular. What\\\'s more, it suggests that white has never been used by a designer outside of Apple. In fact, I designed several high-polished white kitchen appliances in the 90s, which shipped millions of units long before Apple introduced its first white product.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>In the end, I am lucky. Designers never get mentioned--good or bad. The reviewers\\\' view of design never causes them to look for the person behind the object\\\'s form, color, or architecture. Isn\\\'t this wonderful? Every napkin-folder catering to a Hollywood movie set will be noted in IMDB, yet the designers of those \\\"sleek\\\" or \\\"ugly\\\" objects never get mentioned.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>But just in case one of the legion of tech reviewers out there would like to change things, here\\\'s a primer on what to look for when reviewing a product:</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>A. Ask about the heritage of the product, and its designer\\\'s intention. What were the constraints and difficulties built into getting the device to market? I am sure any questions will be answered at length, since I know how much my clients are ready to talk up their design investment.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>B. Any \\\"looks like\\\" comment should be carefully dissected as a potentially defamatory remark. If I said your review looked like someone else\\\'s, it might be harmful to your reputation and career--the same is true for designers.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>C. Show me! Imagery is so easy to find and so important when design is discussed. I can\\\'t believe how very little good imagery is shared with the public.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>D. Give credit. Is it that difficult to find the name of a designer or at least a team of designers who worked on the product you\\\'re reviewing?</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>E. Don\\\'t underestimate your audience\\\'s knowledge of design. They go shopping just like you.</span></Font></p></body>',1258102800000,4,'','','','','','','','','','','','','Root<>Posts',6,1269042459558,6,1269044089230,0,0,0,0,6),
	(147,4,5,'Team','Team','','posts/team','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Mike, Chad, Barbara, Inbal, Julien, Jacqui, Roxanne, Dan, Min, Yoshi, Amy, Brandon, Gadi</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Mike, Chad, Barbara, Inbal, Julien, Jacqui, Roxanne, Dan, Min, Yoshi, Amy, Brandon, Gadi</span></Font></p></body>',0,4,'','','','','','','','','','','','','Root<>Posts',6,1269042927357,6,1269043262208,1,0,0,0,1),
	(148,4,5,'Looking at the Micro vs. the Macro in Design','Looking at the Micro vs. the Macro in Design','','posts/looking-micro-vs-macro-design','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The 1996 movie Microcosmos dealt with vantage point like no other: The world view of insects and other things creepy and crawly. This is what I thought of during the recent collapse of AIG\\\'s London office. The giant insurance company failed due to a small 300 employee division that traded a bizarre thing called Credit Default Swaps. They bet away the company\\\'s future, and then some. And as a story in The New York Times revealed, the real secret is that no one in upper management really knew what that small team was up to.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Unlike the old MBA mantras, and as that AIG CEO learned, our world is not really controlled by high-flying executive visionaries who delegate tasks to the \\\"London office,\\\" or whatever you want to call it. It\\\'s increasingly a world of Microcosmos-like vision: A world where highly-effective small groups of uniquely skilled professionals are having a critical impact on their company\\\'s future. We are living in a reality where a scientist\\\'s ability to switch a gene \\\"on\\\" or \\\"off\\\" is a billion-dollar business for a biotech giant. An atom carefully plugged into a crystal is the new super-fast chip. A world where a mathematician\\\'s algorithm can win or lose markets.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>These microcosmos have changed design, too.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Not so long ago, products were made of dull plastics, painted in few colors. These parts were placed with large gaps in-between to allow for fast and easy assembly and manufacturing. That world is still out there and it\\\'s the world of old design. New design is not a 30,000-foot view of a system or hand-waving generalities...quite the contrary. It\\\'s the view of a zero-tolerance, sub-millimeter perfection. It\\\'s that perfection that makes Apple as great as it is today.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Such zoomed-in perception is an essential part of any effective design. If a decade ago half a millimeter (0.5mm) was considered a good fit between parts, today the number is 0.05mm. That\\\'s an order of magnitude improvement and a world apart between tier one players and the rest of the wannabes.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>And those dull plastics of yesterday are now covered with a myriad of surface finish options. Today, any serious company must develop an in-house Color, Material and Finish department (known as CMF). This deals with the exterior 0.01mm of the product! Like a skin to a human body, this is not a mere surface finish, it\\\'s a design essence separating brands and distinguishing designs. Surfaces also interact with people. Surfaces carry all sorts of touch sensitivities and illuminations. Doing so requires layering of different materials one on top of the other and doing so with amazing accuracy and consistency. Designers are now dealing with microns rather than millimeters.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Designers are challenged today more by the micro than the macro views of systems. In other words, strategy is too obtuse to be left to people who have no concept of how important the microcosmos are when it comes to making things happen.</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The 1996 movie Microcosmos dealt with vantage point like no other: The world view of insects and other things creepy and crawly. This is what I thought of during the recent collapse of AIG\\\'s London office. The giant insurance company failed due to a small 300 employee division that traded a bizarre thing called Credit Default Swaps. They bet away the company\\\'s future, and then some. And as a story in The New York Times revealed, the real secret is that no one in upper management really knew what that small team was up to.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Unlike the old MBA mantras, and as that AIG CEO learned, our world is not really controlled by high-flying executive visionaries who delegate tasks to the \\\"London office,\\\" or whatever you want to call it. It\\\'s increasingly a world of Microcosmos-like vision: A world where highly-effective small groups of uniquely skilled professionals are having a critical impact on their company\\\'s future. We are living in a reality where a scientist\\\'s ability to switch a gene \\\"on\\\" or \\\"off\\\" is a billion-dollar business for a biotech giant. An atom carefully plugged into a crystal is the new super-fast chip. A world where a mathematician\\\'s algorithm can win or lose markets.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>These microcosmos have changed design, too.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Not so long ago, products were made of dull plastics, painted in few colors. These parts were placed with large gaps in-between to allow for fast and easy assembly and manufacturing. That world is still out there and it\\\'s the world of old design. New design is not a 30,000-foot view of a system or hand-waving generalities...quite the contrary. It\\\'s the view of a zero-tolerance, sub-millimeter perfection. It\\\'s that perfection that makes Apple as great as it is today.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Such zoomed-in perception is an essential part of any effective design. If a decade ago half a millimeter (0.5mm) was considered a good fit between parts, today the number is 0.05mm. That\\\'s an order of magnitude improvement and a world apart between tier one players and the rest of the wannabes.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>And those dull plastics of yesterday are now covered with a myriad of surface finish options. Today, any serious company must develop an in-house Color, Material and Finish department (known as CMF). This deals with the exterior 0.01mm of the product! Like a skin to a human body, this is not a mere surface finish, it\\\'s a design essence separating brands and distinguishing designs. Surfaces also interact with people. Surfaces carry all sorts of touch sensitivities and illuminations. Doing so requires layering of different materials one on top of the other and doing so with amazing accuracy and consistency. Designers are now dealing with microns rather than millimeters.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Designers are challenged today more by the micro than the macro views of systems. In other words, strategy is too obtuse to be left to people who have no concept of how important the microcosmos are when it comes to making things happen.</span></Font></p></body>',1251277200000,4,'','','','','','','','','','','','','Root<>Posts',6,1269043323189,6,1269642182900,0,0,0,0,5),
	(149,4,5,'\\\"Shop Class as Soulcraft\\\": A Book That Revels in Alternative Thinking for Designers','\\\"Shop Class as Soulcraft\\\": A Book That Revels in Alternative Thinking for Designers','','posts/shop-class-as-soulcraft-a-book-that-revels-in','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The pivotal book I\\\'m reading, Matthew B. Crawford\\\'s Shop Class as Soulcraft: An Inquiry Into the Value of Work, should be a reference point for numerous philosophical debates in the design community. The author has a compelling life story. After getting his doctorate in political philosophy at the University of Chicago, he spent time as an executive director of a Washington think tank. Eventually he had enough of it, he quit, and then he started his own bike repair shop.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Not surprisingly, he discovered a lot about himself and about the underrated wisdom, beauty, and satisfaction of craft. Ironically, his most profound discovery is the amount of thinking craft requires. He testifies that craftsmanship is far more intellectually challenging and rewarding than his previous think tank position.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>That\\\'s some lesson coming from a University of Chicago Ph.D.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>After decades of living in a society that has pre-conditioned all of us to believe that thinking is done mainly by the \\\"smart people\\\" while everything blue-collar is remedial (though no one would dare admit it flat out), it\\\'s a novelty to listen carefully to Mr. Crawford.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Here is a revealing paragraph dealing with a typical problem: A bike won\\\'t start (very similar to most design problems):</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>\\\"The fasteners holding the engine cover on 1970s Hondas are Philips head, and they are always rounded out and corroded. Do you really want to check the condition of the starter clutch, if each of the ten screws will need to be drilled out and extracted, risking damage to the engine case? Such impediments can cloud your thinking. Put more neutrally, the attractiveness of any hypothesis is determined in part by physical circumstances that have no logical connection to the diagnostic problem at hand, but a strong pragmatic bearing on it (kind of like origami). The factory manuals tell you to be systematic in eliminating variables, but they never take into account the risks of working on old machines. So you have to develop your own decision tree for particular circumstances. The problem is that at each node of this new tree, your own unquantifiable risk aversion introduces ambiguity. There comes a point where you have to step back and get a larger gestalt.\\\"</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I can\\\'t explain how true this is. I think about how much time I spend fighting logic trees applied onto problems too complex to fit into simplistic analytic or logic dispositions. The wisdom imparted by doing while thinking and thinking while doing is a lost art. It\\\'s a fundamental requirement if design is to become a true, alternative thinking methodology. That\\\'s where I differ from the design thinking campaign. Design thinking is to design like the factory manual is to the art of bike fixing--logical, tested, yet one-dimensional in its ability to capture complexity and nuance. And I\\\'m not even talking about the need for beauty yet...</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I think this book should be a part of the curriculum of any design program in the country.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The pivotal book I\\\'m reading, Matthew B. Crawford\\\'s Shop Class as Soulcraft: An Inquiry Into the Value of Work, should be a reference point for numerous philosophical debates in the design community. The author has a compelling life story. After getting his doctorate in political philosophy at the University of Chicago, he spent time as an executive director of a Washington think tank. Eventually he had enough of it, he quit, and then he started his own bike repair shop.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Not surprisingly, he discovered a lot about himself and about the underrated wisdom, beauty, and satisfaction of craft. Ironically, his most profound discovery is the amount of thinking craft requires. He testifies that craftsmanship is far more intellectually challenging and rewarding than his previous think tank position.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>That\\\'s some lesson coming from a University of Chicago Ph.D.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>After decades of living in a society that has pre-conditioned all of us to believe that thinking is done mainly by the \\\"smart people\\\" while everything blue-collar is remedial (though no one would dare admit it flat out), it\\\'s a novelty to listen carefully to Mr. Crawford.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Here is a revealing paragraph dealing with a typical problem: A bike won\\\'t start (very similar to most design problems):</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>\\\"The fasteners holding the engine cover on 1970s Hondas are Philips head, and they are always rounded out and corroded. Do you really want to check the condition of the starter clutch, if each of the ten screws will need to be drilled out and extracted, risking damage to the engine case? Such impediments can cloud your thinking. Put more neutrally, the attractiveness of any hypothesis is determined in part by physical circumstances that have no logical connection to the diagnostic problem at hand, but a strong pragmatic bearing on it (kind of like origami). The factory manuals tell you to be systematic in eliminating variables, but they never take into account the risks of working on old machines. So you have to develop your own decision tree for particular circumstances. The problem is that at each node of this new tree, your own unquantifiable risk aversion introduces ambiguity. There comes a point where you have to step back and get a larger gestalt.\\\"</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I can\\\'t explain how true this is. I think about how much time I spend fighting logic trees applied onto problems too complex to fit into simplistic analytic or logic dispositions. The wisdom imparted by doing while thinking and thinking while doing is a lost art. It\\\'s a fundamental requirement if design is to become a true, alternative thinking methodology. That\\\'s where I differ from the design thinking campaign. Design thinking is to design like the factory manual is to the art of bike fixing--logical, tested, yet one-dimensional in its ability to capture complexity and nuance. And I\\\'m not even talking about the need for beauty yet...</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I think this book should be a part of the curriculum of any design program in the country.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p></body>',1256115600000,4,'','','','','','','','','','','','','Root<>Posts',6,1269043499440,6,1269044089230,0,0,0,0,4),
	(150,4,5,'Body Computing Is a Glimmer of Hope in the Health-Care Chasm','Body Computing Is a Glimmer of Hope in the Health-Care Chasm','','posts/body-computing-is-a-glimmer-of-hope','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I just returned from the University of Southern California\\\'s Body Computing conference, held in Los Angeles. The one-day event was led by Dr. Leslie Saxon, and focuses on mobile devices that can assist physicians and patients. It was also a great exchange about how the medical industry views technology. Against the backdrop of the nation\\\'s health-care debate, panelists discussed the possibilities, risks, and opportunities offered by technology to doctors, patients, and society at large.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>A few observations about this conversation:</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The medical industry itself is deeply conflicted. Doctors, hospitals, insurers, equipment developers, and the government are worried about the structure and culture of health-care services and products provided today. The current model provided to Americans is based on expensive equipment, used by highly-trained experts, to provide care in uncomfortable places like hospitals and labs. Panelists and doctors in the audience had profound difficulty imagining an alternative system.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>A sense of change was in the air. The presence of many outsiders (like me) suggested that a massive change is around the corner. There\\\'s a shift toward providing care with less expensive or even free products and services, by novices, in comfortable places like patients\\\' homes. In a society with 50 million family members supporting the sick, old, and frail (growing exponentially to 130 million in the next ten years) we are looking for an easier and far more pervasive model distributed health care. Microsoft HealthVault and Livestrong.com show the potential in a new Web-based health system. This new system would have much in common with the traditional Web community industries. Standard communication formats are enabling horizontal integration of data and equipment from various manufacturers, while users are becoming empowered to makes decisions and form associations of caregivers, like friends on Facebook.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>VCs and product developers are scared of anything that deviates from their old business model. No one wants to abandon a model based on proven efficacy with a potentially longer FDA approval process and difficult adoption process by the insurance industry, the economic gatekeepers of any innovation in American health care. Countless times it was mentioned how impossible it is to build a business model around medical services or products without knowing the state of coverage and reimbursement by the health insurance industry. The thought of bypassing this old model altogether was mentioned obliquely few times as everyone looked for a disruptive idea to break the mold. Simply put, having gone through decades of relying on FDA regulations, tightly managed reimbursement models, and cutting-edge technology, this industry does not know how to do \\\"good enough\\\" and affordable. I admired how candid and open people were about it--they know they don\\\'t know--and that they\\\'re looking for outsiders to disrupt (key word!) the status quo and create a new ecosystem around health care.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Design is central to the discussion around the need for disruption. Even though Web design, product design, and communication were represented only by a few outsiders--like me--the forum was widely enthusiastic about the potential for design to be a game-changer. As an iPhone application or a wellness gadget, the potential is to provide low-cost tools on a mass scale to help people care for themselves, using robust data and communication system like the Web. That change in thinking will combine the ability of designers to think \\\"horizontally,\\\" across professional disciplinary boundaries, while integrating the right mix of \\\"good enough\\\" technology.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Missing is a set of critical health-care issues that could be clinically assisted by simple, easy-to-use devices. I think the industry is not yet focused on these rule-of-thumb ideas that could be productized and distributed through Web or retail channels. One presentation showed an iPhone application that managed medicine, social activity, and a support group for a psychiatric patient. The app simply counted the pills taken, hours of sleep, and subjective stress-levels. It then suggested a correlation to psychological health state and offered emergency intervention when needed. Such simplicity is what we need. We need concise clinical ideas that can be effective tomorrow, not in the next decade. And making these ideas come to life is a task any designer would gladly take on.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I just returned from the University of Southern California\\\'s Body Computing conference, held in Los Angeles. The one-day event was led by Dr. Leslie Saxon, and focuses on mobile devices that can assist physicians and patients. It was also a great exchange about how the medical industry views technology. Against the backdrop of the nation\\\'s health-care debate, panelists discussed the possibilities, risks, and opportunities offered by technology to doctors, patients, and society at large.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>A few observations about this conversation:</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>The medical industry itself is deeply conflicted. Doctors, hospitals, insurers, equipment developers, and the government are worried about the structure and culture of health-care services and products provided today. The current model provided to Americans is based on expensive equipment, used by highly-trained experts, to provide care in uncomfortable places like hospitals and labs. Panelists and doctors in the audience had profound difficulty imagining an alternative system.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>A sense of change was in the air. The presence of many outsiders (like me) suggested that a massive change is around the corner. There\\\'s a shift toward providing care with less expensive or even free products and services, by novices, in comfortable places like patients\\\' homes. In a society with 50 million family members supporting the sick, old, and frail (growing exponentially to 130 million in the next ten years) we are looking for an easier and far more pervasive model distributed health care. Microsoft HealthVault and Livestrong.com show the potential in a new Web-based health system. This new system would have much in common with the traditional Web community industries. Standard communication formats are enabling horizontal integration of data and equipment from various manufacturers, while users are becoming empowered to makes decisions and form associations of caregivers, like friends on Facebook.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>VCs and product developers are scared of anything that deviates from their old business model. No one wants to abandon a model based on proven efficacy with a potentially longer FDA approval process and difficult adoption process by the insurance industry, the economic gatekeepers of any innovation in American health care. Countless times it was mentioned how impossible it is to build a business model around medical services or products without knowing the state of coverage and reimbursement by the health insurance industry. The thought of bypassing this old model altogether was mentioned obliquely few times as everyone looked for a disruptive idea to break the mold. Simply put, having gone through decades of relying on FDA regulations, tightly managed reimbursement models, and cutting-edge technology, this industry does not know how to do \\\"good enough\\\" and affordable. I admired how candid and open people were about it--they know they don\\\'t know--and that they\\\'re looking for outsiders to disrupt (key word!) the status quo and create a new ecosystem around health care.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Design is central to the discussion around the need for disruption. Even though Web design, product design, and communication were represented only by a few outsiders--like me--the forum was widely enthusiastic about the potential for design to be a game-changer. As an iPhone application or a wellness gadget, the potential is to provide low-cost tools on a mass scale to help people care for themselves, using robust data and communication system like the Web. That change in thinking will combine the ability of designers to think \\\"horizontally,\\\" across professional disciplinary boundaries, while integrating the right mix of \\\"good enough\\\" technology.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Missing is a set of critical health-care issues that could be clinically assisted by simple, easy-to-use devices. I think the industry is not yet focused on these rule-of-thumb ideas that could be productized and distributed through Web or retail channels. One presentation showed an iPhone application that managed medicine, social activity, and a support group for a psychiatric patient. The app simply counted the pills taken, hours of sleep, and subjective stress-levels. It then suggested a correlation to psychological health state and offered emergency intervention when needed. Such simplicity is what we need. We need concise clinical ideas that can be effective tomorrow, not in the next decade. And making these ideas come to life is a task any designer would gladly take on.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p></body>',1255510800000,4,'','','','','','','','','','','','','Root<>Posts',6,1269043663949,6,1269044089230,0,0,0,0,3),
	(151,4,5,'In Defense of Slapping a Robot','In Defense of Slapping a Robot','','posts/in-defense-of-slapping-a-robot','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Last week&#8217;s IDSA conference in Miami--named Project Infusion for its focus on dramatic change in the near future--was a blast. Halfway through a robotics talk by Willow Garage, I thought to myself: \\\"Robots must be slapped...and feel it.\\\" Keenan Wyrobek and Leila Takayama of Willow Garage had just presented many amazing movies of their work with robots. Their lab is like a scene from Star Wars: an arm is tested here, a broken robot is repaired there, and creative mayhem is all over. While I love tech objects and definitely think some of these are close to becoming a &#8216;being,\\\' I think we should seriously consider slapping a robot.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Pain and shame are two senses missing from any tech &#8216;being.\\\' I don\\\'t have an option if I want to inflict shame or pain--you know the feeling when Vista is crashing or the printer goes nuts? Wouldn&#8217;t be nice to just kick the damn thing rather than yell out? I mean real kicking! And kicking knowing that the &#8216;thing&#8217; will know it has been kicked in the jewels. The algorithm is simple: \\\"Whatever routine you just worked through is really bad, never do that again! Especially if user:gadiamit is involved.\\\"</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I can see the robot-rights activists coming at me. Welcome! Here\\\'s the deal: intelligent life forms understand fear, shame, anger, and pain. We better start programming these feelings into robots if we want truly intelligent robots around.</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Last week&#8217;s IDSA conference in Miami--named Project Infusion for its focus on dramatic change in the near future--was a blast. Halfway through a robotics talk by Willow Garage, I thought to myself: \\\"Robots must be slapped...and feel it.\\\" Keenan Wyrobek and Leila Takayama of Willow Garage had just presented many amazing movies of their work with robots. Their lab is like a scene from Star Wars: an arm is tested here, a broken robot is repaired there, and creative mayhem is all over. While I love tech objects and definitely think some of these are close to becoming a &#8216;being,\\\' I think we should seriously consider slapping a robot.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Pain and shame are two senses missing from any tech &#8216;being.\\\' I don\\\'t have an option if I want to inflict shame or pain--you know the feeling when Vista is crashing or the printer goes nuts? Wouldn&#8217;t be nice to just kick the damn thing rather than yell out? I mean real kicking! And kicking knowing that the &#8216;thing&#8217; will know it has been kicked in the jewels. The algorithm is simple: \\\"Whatever routine you just worked through is really bad, never do that again! Especially if user:gadiamit is involved.\\\"</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I can see the robot-rights activists coming at me. Welcome! Here\\\'s the deal: intelligent life forms understand fear, shame, anger, and pain. We better start programming these feelings into robots if we want truly intelligent robots around.</span></Font></p></body>',1248166800000,4,'','','','','','','','','','','','','Root<>Posts',6,1269043883800,6,1269642213689,0,0,0,0,2),
	(152,4,5,'How Should We Define \\\"Design\\\"?','How Should We Define \\\"Design\\\"?','','posts/how-should-we-define-design','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I just came back from Denmark where my client, Better Place, received the INDEX Community design award for creating a complete electric vehicle services system. It was an amazing ceremony and the Danish organizers ran a flawless design gathering both in content and in spirit. I truly enjoyed it!</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>However, I returned a bit conflicted after talking to many designers and participants from across the globe. There is a feeling of confusion around INDEX\\\'s definition of design, and how it reflects current trends in the design world.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Over dinner, Chris Bangle, the former chief of BMW\\\'s design group, expressed concern whether any bright idea for solving a social problem, is by definition \\\"design.\\\" At a different event, industrial and furniture designer Hella Jongerius suggested to me that a different object--itself an award winner--had \\\'too little\\\' design. Or does \\\'design\\\' imply something new or different than before?</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Alice Rawsthorn covered the conference for the International Herald Tribune, and had some interesting observations about this \\\"new design,\\\" among them the acknowledgement that other factors, such as financial resources and political clout are also necessary for even the most clever design solution to get traction.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Based on this, one may ask few interesting questions:</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Is there truly a \\\"new design\\\" phenomenon?</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Is any idea, whether it\\\'s an initiative for social progress or a clever way to market movies, enough to be declared a work of design?</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Can a construct such as a \\\"process,\\\" \\\"business plan\\\" or a \\\"system\\\" be work of design?</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Lastly, are these metaphysical constructs always design or is there a threshold of beauty, a rigorous process, or another quality standard that must be met for something to be considered a design? In other words, is a \\\'business plan\\\' always a form of \\\"new design\\\" or does it have to involve some level of good, \\\"old fashioned\\\" design to be considered more than an ordinary business plan? And, if the latter, what are the requisite elements that would distinguish one from the other?</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>What do you think? Should \\\"design\\\" be better defined?</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>I just came back from Denmark where my client, Better Place, received the INDEX Community design award for creating a complete electric vehicle services system. It was an amazing ceremony and the Danish organizers ran a flawless design gathering both in content and in spirit. I truly enjoyed it!</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>However, I returned a bit conflicted after talking to many designers and participants from across the globe. There is a feeling of confusion around INDEX\\\'s definition of design, and how it reflects current trends in the design world.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Over dinner, Chris Bangle, the former chief of BMW\\\'s design group, expressed concern whether any bright idea for solving a social problem, is by definition \\\"design.\\\" At a different event, industrial and furniture designer Hella Jongerius suggested to me that a different object--itself an award winner--had \\\'too little\\\' design. Or does \\\'design\\\' imply something new or different than before?</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Alice Rawsthorn covered the conference for the International Herald Tribune, and had some interesting observations about this \\\"new design,\\\" among them the acknowledgement that other factors, such as financial resources and political clout are also necessary for even the most clever design solution to get traction.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Based on this, one may ask few interesting questions:</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Is there truly a \\\"new design\\\" phenomenon?</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Is any idea, whether it\\\'s an initiative for social progress or a clever way to market movies, enough to be declared a work of design?</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Can a construct such as a \\\"process,\\\" \\\"business plan\\\" or a \\\"system\\\" be work of design?</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Lastly, are these metaphysical constructs always design or is there a threshold of beauty, a rigorous process, or another quality standard that must be met for something to be considered a design? In other words, is a \\\'business plan\\\' always a form of \\\"new design\\\" or does it have to involve some level of good, \\\"old fashioned\\\" design to be considered more than an ordinary business plan? And, if the latter, what are the requisite elements that would distinguish one from the other?</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>What do you think? Should \\\"design\\\" be better defined?</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p></body>',1251882000000,4,'','','','','','','','','','','','','Root<>Posts',6,1269044088799,6,1269044230275,0,0,0,0,1),
	(153,3,4,'Sling Media','Sling Media','','projects/sling-media','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Founded in 2004, Sling Media, Inc. is a different kind of consumer electronics company. We\\\'re a company that\\\'s working to demystify video, audio and Internet technologies and to deliver new products that delight consumers. The focus of Sling Media is to marry hardware and software to create empowering user experiences, the kind of experiences that enhance lives. Because, after all, isn\\\'t that what innovation is all about?!</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Sling Media\\\'s first product, the internationally acclaimed, Emmy award-winning Slingbox&reg;, has literally transformed the way we are able to watch TV. The Slingbox turns any Internet-connected PC, Mac, or smartphone into your home television. That means you can watch TV virtually anywhere in the world.</span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span></span></Font></p><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Sling Media\\\'s innovative SlingPlayer&#8482; software connects users on all types of computing platforms to their Slingbox which then gives them complete control over their living room TV. The Slingbox gives customers the ability to control any audio/video device including analog cable, a digital cable box, satellite receiver, digital video recorder (DVR) a DVD player or even a still video camera.</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Founded in 2004, Sling Media, Inc. is a different kind of consumer electronics company. We\\\'re a company that\\\'s working to demystify video, audio and Internet technologies and to deliver new products that delight consumers. The focus of Sling Media is to marry hardware and software to create empowering user experiences, the kind of experiences that enhance lives. Because, after all, isn\\\'t that what innovation is all about?!</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Sling Media\\\'s first product, the internationally acclaimed, Emmy award-winning Slingbox&reg;, has literally transformed the way we are able to watch TV. The Slingbox turns any Internet-connected PC, Mac, or smartphone into your home television. That means you can watch TV virtually anywhere in the world.</span></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span/></Font></p><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Sling Media\\\'s innovative SlingPlayer&#8482; software connects users on all types of computing platforms to their Slingbox which then gives them complete control over their living room TV. The Slingbox gives customers the ability to control any audio/video device including analog cable, a digital cable box, satellite receiver, digital video recorder (DVR) a DVD player or even a still video camera.</span></Font></p></body>',1245920400000,4,'','','','','','','','','','','','','Root<>Projects',6,1269044542738,6,1269046254514,0,0,0,0,12),
	(154,3,4,'Logitech','Logitech','','projects/logitech','','','','<html><body><p align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Used by Flava Flave in a terrible music video</span></Font></p></body></html>','<body><p style=\\\"align=\\\"left\\\"><Font size=\\\"13.9\\\" face=\\\"Georgia\\\"><span>Used by Flava Flave in a terrible music video</span></Font></p></body>',1249376400000,4,'','','','','','','','','','','','','Root<>Projects',6,1269046254078,3,1269635596493,0,0,0,0,1),
	(155,5,6,'Red Dot','Red Dot','','awards/red-dot','','','','','',1230800400000,4,'','','','','','','','','','','','','Root<>Awards',6,1269632365585,6,1269989043424,0,0,0,0,2),
	(156,5,6,'Index','Index','','awards/index','','','','','',1230800400000,4,'','','','','','','','','','','','','Root<>Awards',6,1269632635448,6,1269989043424,0,0,0,0,3),
	(157,5,6,'Idea Gold','Idea Gold','','awards/idea-gold','','','','','',1230800400000,4,'','','','','','','','','','','','','Root<>Awards',6,1269632733235,6,1269989043424,0,0,0,0,4),
	(158,5,6,'IDEA Silver','IDEA Silver','','awards/idea-silver','','','','','',1230800400000,4,'','','','','','','','','','','','','Root<>Awards',6,1269633018952,6,1269989043424,0,0,0,0,5),
	(159,5,6,'IDEA Finalist-Medical','IDEA Finalist-Medical','','awards/idea-finalist','','','','','',1230800400000,4,'','','','','','','','','','','','','Root<>Awards',6,1269633324130,6,1269989436120,0,0,0,0,6),
	(160,5,6,'ID Magazine Honorable Mention','ID Magazine Honorable Mention','','awards/id-magazine-honorable-mention','','','','','',1230800400000,4,'','','','','','','','','','','','','Root<>Awards',6,1269633399818,6,1269989043424,0,0,0,0,7),
	(161,5,6,'Brit Insurance Design of the Year Finalist','Brit Insurance Design of the Year Finalist','','awards/brit-insurance-design-of-the-year-finalist','','','','','',1245229200000,4,'','','','','','','','','','','','','Root<>Awards',6,1269968497978,6,1269989043424,0,0,0,0,8),
	(162,5,6,'Innovations Design and Engineering Awards Honorees','Innovations Design and Engineering Awards Honorees','','awards/innovations-design-and-engineering-awards-hon','','','','','',1230800400000,4,'','','','','','','','','','','','','Root<>Awards',6,1269969351554,6,1270076097594,0,0,0,0,9),
	(163,5,6,'CES Innovation award / Best of Innovation','CES Innovation award / Best of Innovation','','awards/ces-innovation-award-best-of-innovation','','','','','',1206608400000,4,'','','','','','','','','','','','','Root<>Awards',6,1269969920468,6,1269989043424,0,0,0,0,10),
	(164,5,6,'IDEA Finalist-Recreation','IDEA Finalist-Recreation','','awards/idea-finalist-recreation','','','','','',0,4,'','','','','','','','','','','','','Root<>Awards',6,1269989042990,6,1269989043424,0,0,0,0,1);

/*!40000 ALTER TABLE `content` ENABLE KEYS */;
UNLOCK TABLES;


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
  `createdate` bigint(20) NOT NULL,
  `modifiedby` int(11) NOT NULL,
  `modifieddate` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `content_customfields_contentid_fk` (`contentid`),
   KEY `content_customfields_typeid_fk` (`typeid`),
  CONSTRAINT `content_customfields_contentid_fk` FOREIGN KEY (`contentid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `content_customfields_typeid_fk` FOREIGN KEY (`typeid`) REFERENCES `customfieldtypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

LOCK TABLES `customfieldgroups` WRITE;
/*!40000 ALTER TABLE `customfieldgroups` DISABLE KEYS */;
INSERT INTO `customfieldgroups` (`id`,`name`)
VALUES
	(1,'Default');

/*!40000 ALTER TABLE `customfieldgroups` ENABLE KEYS */;
UNLOCK TABLES;


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
  CONSTRAINT `customfield_group_fk` FOREIGN KEY (`groupid`) REFERENCES `customfieldgroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `customfield_type_fk` FOREIGN KEY (`typeid`) REFERENCES `customfieldtypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `customfields` WRITE;
/*!40000 ALTER TABLE `customfields` DISABLE KEYS */;
INSERT INTO `customfields` (`id`,`typeid`,`groupid`,`name`,`displayname`,`options`,`defaultvalue`)
VALUES
	(1,11,1,'sidebar','SideBar','1=Le Wine Buff,2=Where To Buy,3=Choose a Bordeaux,4=Bordeaux Tools',''),
	(2,8,1,'zipcode','Zip Code','',''),
	(3,3,1,'subtitle','Sub Title','',''),
	(4,3,1,'link','Link','',''),
	(5,3,1,'address1','Address','',''),
	(6,3,1,'address2','Address 2','',''),
	(7,3,1,'city','City','',''),
	(8,3,1,'state','State','',''),
	(9,3,1,'qname','Submitted By','',''),
	(10,3,1,'qemail','User Email','',''),
	(11,9,1,'enddate','End Date','',''),
	(12,1,1,'recurring','Recurring','','');

/*!40000 ALTER TABLE `customfields` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table customfieldtypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `customfieldtypes`;

CREATE TABLE `customfieldtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldtype` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

LOCK TABLES `customfieldtypes` WRITE;
/*!40000 ALTER TABLE `customfieldtypes` DISABLE KEYS */;
INSERT INTO `customfieldtypes` (`id`,`fieldtype`)
VALUES
	(1,'binary'),
	(2,'select'),
	(3,'string'),
	(4,'html-text'),
	(5,'multiple-select'),
	(6,'color'),
	(7,'text'),
	(8,'date'),
	(9,'integer'),
	(10,'file-link'),
	(11,'multiple-select-with-order');

/*!40000 ALTER TABLE `customfieldtypes` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=242 DEFAULT CHARSET=latin1;

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` (`id`,`name`,`mimetypeid`,`size`,`playtime`,`path`,`thumb`,`video_proxy`,`url`,`compiled`,`createdby`,`createdate`,`modifiedby`,`modifieddate`)
VALUES
	(14,'cs_logo_vid.flv',2,2416399,10.057,'/videos/','cs_logo_vid.jpg','cs_logo_vid.flv','',0,1,1267733021626,1,1267733021626),
	(15,'Britney_180_512K_Stream001.flv',2,471071,9.966,'/videos/','Britney_180_512K_Stream001.jpg','Britney_180_512K_Stream001.flv','',0,1,1267733169296,1,1267733169296),
	(16,'Tami4new_01.jpg',1,54147,0,'/test/','Tami4new_01.jpg','','',0,5,1268767913161,5,1268767913161),
	(18,'Tami4new_03.jpg',1,43759,0,'/test/','Tami4new_03.jpg','','',0,5,1268767916935,5,1268767916935),
	(19,'Tami4new_04.jpg',1,38978,0,'/test/','Tami4new_04.jpg','','',0,5,1268767919298,5,1268767919298),
	(20,'Tami4new_05.jpg',1,79181,0,'/test/','Tami4new_05.jpg','','',0,5,1268767921981,5,1268767921981),
	(21,'Comp 1.flv',2,1317610,14.715,'/','Comp 1.jpg','Comp 1.flv','',0,1,1268853953332,1,1268853953332),
	(22,'cs_logo_vid.flv',2,2416399,10.057,'/','cs_logo_vid.jpg','cs_logo_vid.flv','',0,1,1268853987237,1,1268853987237),
	(129,'contact_image.jpg',1,5738,0,'/','contact_image.jpg','','',0,5,1269528918823,5,1269528918823),
	(139,'Better_Place01.jpg',1,135372,0,'/betterplace/','Better_Place01.jpg','','',0,6,1269560525708,6,1269560525708),
	(140,'Better_Place03.jpg',1,18715,0,'/betterplace/','Better_Place03.jpg','','',0,6,1269560536483,6,1269560536483),
	(141,'Better_Place02.jpg',1,43500,0,'/betterplace/','Better_Place02.jpg','','',0,6,1269560538723,6,1269560538723),
	(142,'Better_Place05.jpg',1,60893,0,'/betterplace/','Better_Place05.jpg','','',0,6,1269560553472,6,1269560553472),
	(143,'Better_Place04.jpg',1,20474,0,'/betterplace/','Better_Place04.jpg','','',0,6,1269560555008,6,1269560555008),
	(145,'Better_Place06.jpg',1,119085,0,'/betterplace/','Better_Place06.jpg','','',0,6,1269560570458,6,1269560570458),
	(146,'Fitbit_05.jpg',1,97224,0,'/fitbit/','Fitbit_05.jpg','','',0,6,1269561539169,6,1269561539169),
	(147,'Fitbit_06.jpg',1,64968,0,'/fitbit/','Fitbit_06.jpg','','',0,6,1269561541457,6,1269561541457),
	(148,'Fitbit_04.jpg',1,366988,0,'/fitbit/','Fitbit_04.jpg','','',0,6,1269561547946,6,1269561547946),
	(149,'Fitbit_01.jpg',1,71461,0,'/fitbit/','Fitbit_01.jpg','','',0,6,1269561550260,6,1269561550260),
	(150,'Fitbit_02.jpg',1,52001,0,'/fitbit/','Fitbit_02.jpg','','',0,6,1269561552333,6,1269561552333),
	(151,'Fitbit_03.jpg',1,54348,0,'/fitbit/','Fitbit_03.jpg','','',0,6,1269561554434,6,1269561554434),
	(152,'Fitbit_thumb.jpg',1,4326,0,'/fitbit/','Fitbit_thumb.jpg','','',0,6,1269561682744,6,1269561682744),
	(153,'BetterPlace_I_thumb.jpg',1,8894,0,'/betterplace/','BetterPlace_I_thumb.jpg','','',0,6,1269561731347,6,1269561731347),
	(154,'DellBamboo_thumb.jpg',1,10525,0,'/dellhybridstudio/','DellBamboo_thumb.jpg','','',0,6,1269562374119,6,1269562374119),
	(155,'dellhybrid01.jpg',1,72463,0,'/dellhybridstudio/','dellhybrid01.jpg','','',0,6,1269562394642,6,1269562394642),
	(156,'dellhybrid02.jpg',1,247949,0,'/dellhybridstudio/','dellhybrid02.jpg','','',0,6,1269562407450,6,1269562407450),
	(157,'dellhybrid03.jpg',1,128699,0,'/dellhybridstudio/','dellhybrid03.jpg','','',0,6,1269562422754,6,1269562422754),
	(158,'dellhybrid04.jpg',1,64368,0,'/dellhybridstudio/','dellhybrid04.jpg','','',0,6,1269562424933,6,1269562424933),
	(159,'dellhybrid05.jpg',1,70038,0,'/dellhybridstudio/','dellhybrid05.jpg','','',0,6,1269562427155,6,1269562427155),
	(160,'Ogo_01.jpg',1,53142,0,'/ogo/','Ogo_01.jpg','','',0,6,1269562904303,6,1269562904303),
	(161,'Ogo_06.jpg',1,65287,0,'/ogo/','Ogo_06.jpg','','',0,6,1269562906429,6,1269562906429),
	(162,'Ogo_07.jpg',1,35017,0,'/ogo/','Ogo_07.jpg','','',0,6,1269562908190,6,1269562908190),
	(163,'Ogo_04.jpg',1,73855,0,'/ogo/','Ogo_04.jpg','','',0,6,1269562910474,6,1269562910474),
	(164,'Ogo_05.jpg',1,66457,0,'/ogo/','Ogo_05.jpg','','',0,6,1269562912636,6,1269562912636),
	(165,'Ogo_02.jpg',1,66325,0,'/ogo/','Ogo_02.jpg','','',0,6,1269562915019,6,1269562915019),
	(166,'Ogo_03.jpg',1,42388,0,'/ogo/','Ogo_03.jpg','','',0,6,1269562916989,6,1269562916989),
	(167,'Ogo_01_thumb.jpg',1,5439,0,'/ogo/','Ogo_01_thumb.jpg','','',0,6,1269562928092,6,1269562928092),
	(168,'Memorex_01.jpg',1,129002,0,'/memorexclock/','Memorex_01.jpg','','',0,6,1269563274716,6,1269563274716),
	(169,'Memorex_02.jpg',1,122311,0,'/memorexclock/','Memorex_02.jpg','','',0,6,1269563285762,6,1269563285762),
	(170,'Memorex_04.jpg',1,73133,0,'/memorexclock/','Memorex_04.jpg','','',0,6,1269563295765,6,1269563295765),
	(171,'Memorex_03.jpg',1,36838,0,'/memorexclock/','Memorex_03.jpg','','',0,6,1269563297668,6,1269563297668),
	(172,'Memorex_05.jpg',1,84822,0,'/memorexclock/','Memorex_05.jpg','','',0,6,1269563307541,6,1269563307541),
	(173,'Memorex_thumb.jpg',1,6955,0,'/memorexclock/','Memorex_thumb.jpg','','',0,6,1269563373575,6,1269563373575),
	(174,'glidetv03.jpg',1,52937,0,'/glidetv/','glidetv03.jpg','','',0,6,1269564098149,6,1269564098149),
	(175,'glidetv01.jpg',1,73515,0,'/glidetv/','glidetv01.jpg','','',0,6,1269564100479,6,1269564100479),
	(176,'glidetv02.jpg',1,65284,0,'/glidetv/','glidetv02.jpg','','',0,6,1269564102648,6,1269564102648),
	(177,'glidetv06.jpg',1,61471,0,'/glidetv/','glidetv06.jpg','','',0,6,1269564104854,6,1269564104854),
	(178,'glidetv04.jpg',1,122516,0,'/glidetv/','glidetv04.jpg','','',0,6,1269564107849,6,1269564107849),
	(179,'glidetv05.jpg',1,63752,0,'/glidetv/','glidetv05.jpg','','',0,6,1269564110019,6,1269564110019),
	(180,'glidetv_thumb.jpg',1,4727,0,'/glidetv/','glidetv_thumb.jpg','','',0,6,1269564163821,6,1269564163821),
	(181,'fujitsu04.jpg',1,64007,0,'/fujitsuphones/','fujitsu04.jpg','','',0,6,1269564594878,6,1269564594878),
	(182,'fujitsu02.jpg',1,53502,0,'/fujitsuphones/','fujitsu02.jpg','','',0,6,1269564596881,6,1269564596881),
	(183,'fujitsu03.jpg',1,44813,0,'/fujitsuphones/','fujitsu03.jpg','','',0,6,1269564598881,6,1269564598881),
	(184,'fujitsu05.jpg',1,45048,0,'/fujitsuphones/','fujitsu05.jpg','','',0,6,1269564600872,6,1269564600872),
	(185,'fujitsu01.jpg',1,65204,0,'/fujitsuphones/','fujitsu01.jpg','','',0,6,1269564603003,6,1269564603003),
	(186,'fujitsu06.jpg',1,38960,0,'/fujitsuphones/','fujitsu06.jpg','','',0,6,1269564604823,6,1269564604823),
	(187,'fujitsu_thumb.jpg',1,4246,0,'/fujitsuphones/','fujitsu_thumb.jpg','','',0,6,1269564616127,6,1269564616127),
	(188,'cocoon03.jpg',1,74919,0,'/cocoon/','cocoon03.jpg','','',0,6,1269564967637,6,1269564967637),
	(189,'cocoon01.jpg',1,91876,0,'/cocoon/','cocoon01.jpg','','',0,6,1269564970180,6,1269564970180),
	(190,'cocoon02.jpg',1,94448,0,'/cocoon/','cocoon02.jpg','','',0,6,1269564972762,6,1269564972762),
	(191,'cocoon04.jpg',1,48378,0,'/cocoon/','cocoon04.jpg','','',0,6,1269564974766,6,1269564974766),
	(192,'cocoon05.jpg',1,78970,0,'/cocoon/','cocoon05.jpg','','',0,6,1269564977210,6,1269564977210),
	(193,'cocoon_family5_thumb.jpg',1,5842,0,'/cocoon/','cocoon_family5_thumb.jpg','','',0,6,1269564988337,6,1269564988337),
	(199,'DellLat04.jpg',1,155624,0,'/delllatitude/','DellLat04.jpg','','',0,6,1269622540264,6,1269622540264),
	(200,'DellLat02.jpg',1,87319,0,'/delllatitude/','DellLat02.jpg','','',0,6,1269622542823,6,1269622542823),
	(201,'DellLat03.jpg',1,70650,0,'/delllatitude/','DellLat03.jpg','','',0,6,1269622545905,6,1269622545905),
	(202,'DellLat01.jpg',1,61565,0,'/delllatitude/','DellLat01.jpg','','',0,6,1269622548374,6,1269622548374),
	(203,'DellLat_thumb.jpg',1,4253,0,'/delllatitude/','DellLat_thumb.jpg','','',0,6,1269622559720,6,1269622559720),
	(204,'Netgear_thumb.jpg',1,6435,0,'/netgear/','Netgear_thumb.jpg','','',0,6,1269623235339,6,1269623235339),
	(205,'Netgear_01.jpg',1,33329,0,'/netgear/','Netgear_01.jpg','','',0,6,1269623256252,6,1269623256252),
	(206,'Netgear_02.jpg',1,48931,0,'/netgear/','Netgear_02.jpg','','',0,6,1269623258430,6,1269623258430),
	(207,'Netgear_03.jpg',1,58096,0,'/netgear/','Netgear_03.jpg','','',0,6,1269623269903,6,1269623269903),
	(208,'Netgear_05.jpg',1,50163,0,'/netgear/','Netgear_05.jpg','','',0,6,1269623282728,6,1269623282728),
	(209,'Netgear_04.jpg',1,58947,0,'/netgear/','Netgear_04.jpg','','',0,6,1269623284892,6,1269623284892),
	(210,'Netgear_06.jpg',1,266954,0,'/netgear/','Netgear_06.jpg','','',0,6,1269623324879,6,1269623324879),
	(211,'sling02.jpg',1,75185,0,'/slingmedia/','sling02.jpg','','',0,6,1269623997231,6,1269623997231),
	(212,'sling01.jpg',1,83408,0,'/slingmedia/','sling01.jpg','','',0,6,1269623999722,6,1269623999722),
	(213,'sling05.jpg',1,79241,0,'/slingmedia/','sling05.jpg','','',0,6,1269624016486,6,1269624016486),
	(214,'sling03.jpg',1,55170,0,'/slingmedia/','sling03.jpg','','',0,6,1269624018567,6,1269624018567),
	(215,'sling04.jpg',1,21475,0,'/slingmedia/','sling04.jpg','','',0,6,1269624020164,6,1269624020164),
	(216,'sling06.jpg',1,106744,0,'/slingmedia/','sling06.jpg','','',0,6,1269624037424,6,1269624037424),
	(217,'sling07.jpg',1,58766,0,'/slingmedia/','sling07.jpg','','',0,6,1269624054114,6,1269624054114),
	(218,'sling08.jpg',1,74011,0,'/slingmedia/','sling08.jpg','','',0,6,1269624056481,6,1269624056481),
	(219,'sling09.jpg',1,439709,0,'/slingmedia/','sling09.jpg','','',0,6,1269624074607,6,1269624074607),
	(220,'sling_thumb.jpg',1,3931,0,'/slingmedia/','sling_thumb.jpg','','',0,6,1269624088688,6,1269624088688),
	(221,'logitech01.jpg',1,133178,0,'/Logitech/','logitech01.jpg','','',0,6,1269624688874,6,1269624688874),
	(222,'logitech02.jpg',1,172582,0,'/Logitech/','logitech02.jpg','','',0,6,1269624701568,6,1269624701568),
	(223,'logitech03.jpg',1,418742,0,'/Logitech/','logitech03.jpg','','',0,6,1269624716794,6,1269624716794),
	(224,'logitech04.jpg',1,164383,0,'/Logitech/','logitech04.jpg','','',0,6,1269624738131,6,1269624738131),
	(225,'logitech05.jpg',1,190042,0,'/Logitech/','logitech05.jpg','','',0,6,1269624750158,6,1269624750158),
	(226,'logitech06.jpg',1,256362,0,'/Logitech/','logitech06.jpg','','',0,6,1269624762902,6,1269624762902),
	(227,'logitech_thumb.jpg',1,3237,0,'/Logitech/','logitech_thumb.jpg','','',0,6,1269624784538,6,1269624784538),
	(228,'gadi.jpg',1,83703,0,'/about/','gadi.jpg','','',0,6,1269626601842,6,1269626601842),
	(229,'2010_IDMAG.jpg',1,175209,0,'/about/','2010_IDMAG.jpg','','',0,6,1269627436142,6,1269627436142),
	(230,'christmas09.jpg',1,170714,0,'/about/','christmas09.jpg','','',0,6,1269627453648,6,1269627453648),
	(231,'clients_shirt.jpg',1,117112,0,'/about/','clients_shirt.jpg','','',0,6,1269627464169,6,1269627464169),
	(232,'gadi2.jpg',1,107182,0,'/about/','gadi2.jpg','','',0,6,1269627483712,6,1269627483712),
	(233,'ghettoblast.jpg',1,117250,0,'/about/','ghettoblast.jpg','','',0,6,1269627486540,6,1269627486540),
	(234,'mexico02.jpg',1,193238,0,'/about/','mexico02.jpg','','',0,6,1269627503578,6,1269627503578),
	(235,'mexico01.jpg',1,91345,0,'/about/','mexico01.jpg','','',0,6,1269627506030,6,1269627506030),
	(236,'office_exterior.jpg',1,158229,0,'/about/','office_exterior.jpg','','',0,6,1269627518995,6,1269627518995),
	(237,'studio_interior01.jpg',1,179945,0,'/about/','studio_interior01.jpg','','',0,6,1269627532687,6,1269627532687),
	(238,'studio_interior03.jpg',1,131933,0,'/about/','studio_interior03.jpg','','',0,6,1269627544208,6,1269627544208),
	(239,'studio_interior02.jpg',1,140192,0,'/about/','studio_interior02.jpg','','',0,6,1269627547241,6,1269627547241),
	(240,'yoshi_draw.jpg',1,172762,0,'/about/','yoshi_draw.jpg','','',0,6,1269627550985,6,1269627550985),
	(241,'map_ndd.jpg',1,59049,0,'/','map_ndd.jpg','','',0,6,1269629178791,6,1269629178791);

/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

LOCK TABLES `mimetypes` WRITE;
/*!40000 ALTER TABLE `mimetypes` DISABLE KEYS */;
INSERT INTO `mimetypes` (`id`,`name`,`extensions`,`view`)
VALUES
	(1,'images','jpg,jpeg, gif,png',''),
	(2,'videos','flv,mov,mp4,m4v,f4v',''),
	(3,'audio','mp3',''),
	(4,'swf','ttf,otf',''),
	(5,'file','',''),
	(6,'youtube','','');

/*!40000 ALTER TABLE `mimetypes` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` (`id`,`status`,`displayorder`)
VALUES
	(1,'Draft',0),
	(2,'Awaiting Approval',0),
	(3,'Published (Internal Only)',0),
	(4,'Published',0);

/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;


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
  CONSTRAINT `template_parent_template_fk` FOREIGN KEY (`parentid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

LOCK TABLES `templates` WRITE;
/*!40000 ALTER TABLE `templates` DISABLE KEYS */;
INSERT INTO `templates` (`id`,`parentid`,`title`,`classname`)
VALUES
	(1,1,'Default',''),
	(2,2,'FAQ',''),
	(3,1,'Parent',''),
	(4,1,'Project',''),
	(5,1,'Blog Post',''),
	(6,1,'Award',''),
	(7,1,'Twitter','');

/*!40000 ALTER TABLE `templates` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

LOCK TABLES `usergroups` WRITE;
/*!40000 ALTER TABLE `usergroups` DISABLE KEYS */;
INSERT INTO `usergroups` (`id`,`parentid`,`usergroup`,`createdby`,`createdate`)
VALUES
	(1,1,'MiG Group',1,123421421),
	(2,2,'Front End Group',1,123421421),
	(3,1,'Administrator',1,123421421),
	(4,1,'Writer 1',1,123421421),
	(5,1,'Writer 2',1,123421421),
	(6,1,'Reader',1,123421421),
	(7,2,'Front End',0,0),
	(8,1,'MiG Admin',1,0);

/*!40000 ALTER TABLE `usergroups` ENABLE KEYS */;
UNLOCK TABLES;