<?php

require_once "../includes/functions.php";
require_once "../config/constants.php";


if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$params = $_GET;
	unset($params['mode']);
	
} else {

	$params = $_POST;
}

// get the mapping that was passed
$directory = $params["directory"];
$folderName = $params["folderName"];
$file = $params["fileName"];

if($file)
{
	unlink("../../".$directory."/".$folderName."/".$file);
	if($params["removethumb"]) {
		unlink("../../".$directory."/migThumbs/".$folderName."/".$file);
	}
	sendSuccess();
}

?>