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
$root = $params["rootDir"];
$directory = $params["directory"];
$folderName = $params["folderName"];

if($directory && $folderName) {
	if($directory != null && $directory !="" && $directory !=" ")
	{
		$dir = "../../".$root."/".$directory."/".$folderName;
		mkdir("../../".$root."/".$directory."/".$folderName,0777);
		chmod("../../".$root."/".$directory."/".$folderName,0777);
		mkdir("../../".$root."/migThumbs/".$directory."/".$folderName, 0777);
		chmod("../../".$root."/migThumbs/".$directory."/".$folderName,0777);
	}
	else
	{
		$dir = "../../".$root."/".$folderName;
		mkdir("../../".$root."/".$folderName, 0777);
		mkdir("../../".$root."/migThumbs/".$folderName, 0777);
		chmod("../../".$root."/".$folderName, 0777);
		chmod("../../".$root."/migThumbs/".$folderName, 0777);		
	}	

	$mtime = filemtime($dir);		
	$type="folder";
	$size = dirsize($dir);
	$size *= 1024;
	$createthumb = 0;
	$results = array();
	$arr =  array("name"=>$folderName,"createdate"=>$mtime,"size"=>$size,"type"=>$type,"createthumb"=>$createthumb);
	array_push($results, $arr);
	serializeArray($results);

}
else
	sendFailed("Missing Parameters");

?>