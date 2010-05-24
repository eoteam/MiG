<?php

require_once "../includes/functions.php";
require_once "../config/constants.php";
require_once "fileFunctions.php";

if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$params = $_GET;
	unset($params['mode']);
	
} else {

	$params = $_POST;
}

if(isset($params['file']))
{
	$file = $fileDir . $params["file"];
	$result = parseXMP($file);
	if($result[0] == true) {
		header("Content-Type: text/xml");
		echo $result[1];
	}
	else
		sendFailed($result[1]);
}
else
	sendFailed("file parameter is not set");
?>