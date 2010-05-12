<?php

require_once "../includes/functions.php";
require_once "../config/constants.php";


$params = $_POST;

// get the mapping that was passed
$directory = $params["directory"];
$root = $params["rootDir"];

if($directory){
	//$newdir = "./../".$mapping."/";
	$path = "../../".$root."/".$directory."/";
}

$success = rm_recursive($path);

$path2 = "../../".$root."/migThumbs/".$directory."/";
$success2 = rm_recursive($path2);

function rm_recursive($filepath)
{
    if (is_dir($filepath) && !is_link($filepath))
    {
        if ($dh = opendir($filepath))
        {
            while (($sf = readdir($dh)) !== false)
            {
                if ($sf == '.' || $sf == '..')
                {
                    continue;
                }
                if (!rm_recursive($filepath.'/'.$sf))
                {
                    throw new Exception($filepath.'/'.$sf.' could not be deleted.');
                }
            }
            closedir($dh);
        }
        return rmdir($filepath);
    }
    return unlink($filepath);
}
sendSuccess();

?>