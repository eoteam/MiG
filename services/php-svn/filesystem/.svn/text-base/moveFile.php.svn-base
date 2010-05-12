<?php

require_once "../includes/functions.php";
require_once "../config/constants.php";


if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$params = $_GET;
	unset($params['mode']);
	
} else {

	$params = $_POST;
}
if(isset($params['name']) && isset($params['path']) 
	&& isset($params['newPath']) && isset($params['type']) && isset($params['id']))
{
	// get the mapping that was passed
	$name = $params["name"];
	$path = '../../files' . $params["path"];
	$newPath = '../../files' . $params["name"];
	
	rename($path.$name,$newPath.$name);
	if($params['type'] == "images")
	{
		$thumbPath = '../../files/migThumbs' . $params["path"];
		$newThumbPath = '../../files/migThumbs' . $params["name"];
		rename($thumbPath.$name,$newThumbPath.$name);
	}
	$sql = "UPDATE media SET path='" . $newPath  . "' WHERE id='" . $params['id'] . "'";
	if($result = queryDatabase($sql))
		sendSuccess();
	else
		die ("Query failed");
}
else
{
	die ("Missing Parameters");
}
?>