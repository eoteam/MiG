<?php

require_once "../includes/functions.php";
require_once "../config/constants.php";


if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$params = $_GET;
	unset($params['mode']);
	
} else {

	$params = $_POST;
}

if (isset($params['oldname']) && isset($params['newname']) && isset($params['thumb']) )
{
	$oldName = $fileDir . $params["oldname"];
	$newName = $fileDir . $params["newname"];
	rename ($oldName,$newName);
	if($params['thumb'] == '1')
	{
		$oldName = $thumbDir . $params["oldname"];
		$newName = $thumbDir . $params["newname"];
		rename ($oldName,$newName);
	}
}
else
	die("Missing arguments for file rename");
sendSuccess();


?>