<?php

require_once "../includes/functions.php";
require_once "../config/constants.php";


$params = $_POST;

// get the mapping that was passed
$root = $params["rootDir"];
$directory = $params["directory"];
$folderName = $params["folderName"];

if($directory && $folderName){
	if($directory != null && $directory !="" && $directory !=" ")
	{
		mkdir("../../".$root."/".$directory."/".$folderName,0777);
		chmod("../../".$root."/".$directory."/".$folderName,0777);
		mkdir("../../".$root."/migThumbs/".$directory."/".$folderName, 0777);
		chmod("../../".$root."/migThumbs/".$directory."/".$folderName,0777);
	}
	else
	{
		mkdir("../../".$root."/".$folderName, 0777);
		mkdir("../../".$root."/migThumbs/".$folderName, 0777);
		chmod("../../".$root."/".$folderName, 0777);
		chmod("../../".$root."/migThumbs/".$folderName, 0777);		
	}	
	sendSuccess();
}

?>