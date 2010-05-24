<?php

require_once "../includes/functions.php";
require_once "../config/constants.php";
include("classTTFInfo.php");
if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET
	$params = $_GET;
	unset($params['mode']);
	
} else {

	$params = $_POST;
}
if(isset($params['file']))
{
	//
	$xml =  '<fonts>';
	$dir=opendir($fileDir . $params['file']);
	$path = $fileDir . $params['file'];
	$resultList = array();
	if($dir)
	{
		while(($file = readdir($dir)) !== false)
		{
			if($file !== "." && $file !== ".." && $file != "migThumbs" && $file != ".DS_Store"){
				if(is_file($path.'/'.$file))
				{	
					try{
					$ttf = new ttf;
					$ttf_info=$ttf->get_friendly_ttf_name($path.'/'.$file);
					
					$xml .= "<font>";
					$xml .= "<fontfamily>" . $ttf_info["fontfamily"]. "</fontfamily>";
					$xml .= "<fontsubfamily>" . $ttf_info["fontsubfamily"]. "</fontsubfamily>";
					$xml .= "<fullfontname>" . $ttf_info["fullfontname"]. "</fullfontname>";			
					$xml .= "<copyright><![CDATA[" .$ttf_info["copyright"]. "]]></copyright>";
					$xml .= "</font>";
					}
					catch(Exception $e)
					{
						echo '<font><name>' . $file . '</name></font>';
					}
				}
			}
		}
	}
	$xml .= '</fonts>';
	$xml = utf8_encode($xml);
	header("Content-type: text/xml; charset=UTF-8");
	for($i = 0; $i < strlen($xml); $i++)
    {
    	$value = ord($xml[$i]);		
        if($value != '16' && $value != '19')
        {
         	echo chr($value);
        }
     }	
}
else
	die('Font is missing');
?>