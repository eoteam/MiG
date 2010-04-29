<?php

//	include "zip/archive.php";
//	$paths = explode(",",$_REQUEST["files"]);
//	$test=new zip_file("archive.zip");
//	$test->set_options(array('inmemory'=>1,'storepaths'=>1,'recurse'=>0));
//	$test->add_files($paths);
//	$test->create_archive();
//	$test->download_file();


	include_once("../zip/pclzip.lib.php");
	$name = $_GET["name"];
  	$name = "archive";
    // create the zip  
	$archive = new PclZip('../../temporary/'.$name. '.zip');  
	$fileArr = explode(",",$_GET["files"]);
	$fileArr2 = array();
	foreach($fileArr  as $f)
	{
		$f = '../../' . $f;
		$fileArr2[] = $f;
	}
   	$v_list = $archive->create($fileArr2);  
  
    if ($v_list == 0)
    {   
        die("Error : ".$archive->errorInfo(true));  
    }  
    else  
    {  
    	$fileContent = file_get_contents('../../temporary/'.$name. '.zip');
		header("Content-Type: application/zip");
		$header = "Content-Disposition: attachment; filename=\"";
		$header .= $name. '.zip';
		$header .= "\"";
		header($header);
		header("Content-Length: " . strlen($fileContent));
		header("Content-Transfer-Encoding: binary");
		header("Cache-Control: no-cache, must-revalidate, max-age=60");
		header("Expires: Sat, 01 Jan 2000 12:00:00 GMT");	
		print($fileContent);
    } 
?>