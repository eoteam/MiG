<?php
// +----------------------------------------------------------------------+
// | PHP version 5                                                        |
// +----------------------------------------------------------------------+
// | Copyright (c) 2002-2006 James Heinrich, Allan Hansen                 |
// +----------------------------------------------------------------------+
// | This source file is subject to version 2 of the GPL license,         |
// | that is bundled with this package in the file license.txt and is     |
// | available through the world-wide-web at the following url:           |
// | http://www.gnu.org/copyleft/gpl.html                                 |
// +----------------------------------------------------------------------+
// | getID3() - http://getid3.sourceforge.net or http://www.getid3.org    |
// +----------------------------------------------------------------------+
// | Authors: James Heinrich <info�getid3*org>                            |
// |          Allan Hansen <ah�artemis*dk>                                |
// +----------------------------------------------------------------------+
// | demo.basic.php                                                       |
// | getID3() demo file - showing the most basic use of getID3().         |
// +----------------------------------------------------------------------+
//
// $Id: demo.basic.php,v 1.3 2006/11/16 22:11:58 ah Exp $


// Include getID3() library (can be in a different directory if full path is specified)

require_once "fileFunctions.php";
require_once "../includes/functions.php";
require_once "../config/constants.php";

if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$params = $_GET;
	unset($params['mode']);
	
} else {

	$params = $_POST;
}
if(isset($params['file'])) {
	$file = '../../' . $params["file"];
	if(file_exists($file)) {
		$result = getPlaytime($file);
		if($result[0] == true)
			sendSuccess($result[1]);
		else
			sendFailed($result[1]);		
	}
	else
		sendFailed("file doesnt exist");	
}
else
	sendFailed("invalid file");

	

?>