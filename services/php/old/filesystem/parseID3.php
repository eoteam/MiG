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
require_once('../getid3/getid3.php');

require_once "../includes/functions.php";
require_once "../config/constants.php";


if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$params = $_GET;
	unset($params['mode']);
	
} else {

	$params = $_POST;
}
// Initialize getID3 engine
$getid3 = new getID3;
$array2xml = new array2xml;
// Tell getID3() to use UTF-8 encoding - must send proper header as well.
$getid3->encoding = 'UTF-8';

// Tell browser telling it use UTF-8 encoding as well.
header("Content-type: text/xml");

// Analyze file
if(isset($params['file']))
{
	$file = $fileDir . $params["file"];
	try {
	
	    $info = $getid3->Analyze($file);
		$array2xml->formatarray2xml($info);
		echo $array2xml->output; 
		//return $info;
	
	}
	catch (Exception $e) {
	    
	    die('An error occured: ' .  $e->message);
	}
}
else
	die("invalid file");

?>