<?php


function uploadFile($params) {
	
	/*
	
		-- REQUIRED PARAMS --
		
			target_dir
			target_thumbDir
			target_fileType
			userid - user currently logged into MIG
			
			Filedata - file itself from HTML form
			
		-- OPTIONAL PARAMS --
		
			tags - comma-delimited list of tags to associate with the file
			title - the title of the media e.g. "my photo"
			caption
			credits
			
		
	
	*/
	
	global $_FILES;
	
	if (isset($params["fileType"]) && isset($params["thumbsDir"]) && isset($params["userid"])) {

		//error_reporting(0);
		ini_set("upload_max_filesize", "5000");
		ini_set("file_uploads", "50");
		ini_set("max_input_time", "-1");
		//set_time_limit(5000000);
		$MAXIMUM_FILESIZE = 1024 * 2000000; 
		$MAXIMUM_FILE_COUNT = 10000; 
		
		// get the directory
		$target_dir = "../../".$params['directory'];
		$target_thumbDir = "../../".$params["thumbsDir"];
		$target_fileType = $params["fileType"];
		print_r($_FILES['Filedata']);
		if ($_FILES['Filedata']['size'] <= $MAXIMUM_FILESIZE)
		{
		
			if (move_uploaded_file($_FILES['Filedata']['tmp_name'],$target_dir.$_FILES['Filedata']['name'])) {
			
				// default title to filename if no title sent
				
				if (isset($params['title']))
					$title = $params['title'];
				else
					$title = $_FILES['Filedata']['name'];
			
				// write entry to db!
				
				$sql = "INSERT INTO media (name,mimetype,path,caption,credits,createdby,createdate,modifiedby,modifieddate)
						VALUES ('".$title."','".$_FILES['Filedata']['type']."','".$params['directory'].$_FILES['Filedata']['name']."','".$params['caption']."','".$params['credits']."','".$params['userid']."','".mktime()."','".$params['userid']."','".mktime()."')";
				
				queryDatabase($sql);
				$mediaid = mysql_insert_id();
			
			}

		} else {
		
			die ("File Too Large!");
		
		}
		
		// call createThumb function and pass to it as parameters the path 
		// to the directory that contains images, the path to the directory
		// in which thumbnails will be placed and the thumbnail's width. 
		// We are assuming that the path will be a relative path working 
		// both in the filesystem, and through the web for links
	 	if($target_fileType == "images")
		{
			if (createThumbs($target_dir,$_FILES['Filedata']['name'],$target_thumbDir,250)) {
			
				// update media record with thumbnail path!
				
				$sql = "UPDATE media SET thumbnail_path = '".$params['thumbsDir'].$_FILES['Filedata']['name']."' WHERE id = '".$mediaid."'";
				queryDatabase($sql);
				
			}
		}
		
		if ($params['tags']) {
		
			associateTags('media',$mediaid,$params['tags']);
		
		}
		
		sendSuccess();
		die();

	} else {
	
		die("Required parameters are missing!");
	
	}

}

function removeFile($params)
{
	// get the mapping that was passed
	if(isset($params['directory']) && isset($params['folderName']) && isset($params['fileName']) )
	{
		$directory = $params["directory"];
		$folderName = $params["folderName"];
		$file = $params["fileName"];
		
		if($file)
		{
			unlink("../../".$directory."/".$folderName."/".$file);
			unlink("../../".$directory."/migThumbs/".$folderName."/".$file);
			sendSuccess();
		}
	}
	else
		Die ("one paramater is not set correctly");
}
?>