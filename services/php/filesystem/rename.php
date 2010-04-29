<?php 

require_once "../includes/functions.php";
require_once "../config/constants.php";


$params = $_POST;

if (isset($params['oldname']) && isset($params['newname']) && isset($params['thumb']) )
{	
	$oldName = '../files/' . $params["oldname"];
	$newName = '../files/' . $params["newname"];
	rename ($oldName,$newName);
	if($params['thumb'] == '1')
	{
		$oldName = '../files/migThumbs/' . $params["oldname"];
		$newName = '../files/migThumbs/' . $params["newname"];
		rename ($oldName,$newName);			
	}	
}		
else
	die("Missing arguments for file rename");
sendSuccess();

?>