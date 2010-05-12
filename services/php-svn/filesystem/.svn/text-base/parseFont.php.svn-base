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
	$font = '../../'. $params['file'];
	$ttf = new ttf;
	$ttf_info=$ttf->get_friendly_ttf_name($font);
	header("Content-type: text/xml; charset=UTF-8");
	
	echo "<font>";
	echo "<family>" . $ttf_info["fontfamily"]. "</family>";
	echo "<weight>" . $ttf_info["fontsubfamily"]. "</weight>";
	echo "<name>" . $ttf_info["fullfontname"]. "</name>";
	$copyright = $ttf_info["copyright"];
	$copyright = utf8_encode($copyright);
	$c = '';
	for($i = 0; $i < strlen($copyright); $i++)
    {
    	$value = ord($copyright[$i]);		
        if($value != '16' && $value != '19')
         	$c .= chr($value);
    }  	
	echo "<copyright><![CDATA[" . $c . "]]></copyright>";
	echo "</font>";
}
else
	die('Font is missing');
?>