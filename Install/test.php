<?php

require_once "functions.php";
/*
echo 'max_execution_time = ' . ini_get('max_execution_time') . "\n";
echo 'max_input_time = ' . ini_get('max_input_time') . "\n";
echo 'magic_quotes_gpc = ' . ini_get('magic_quotes_gpc') . "\n";
echo 'safe_mode = ' . ini_get('safe_mode') . "\n";

echo 'upload_max_filesize = ' . ini_get('upload_max_filesize') . "\n";
echo 'post_max_size = ' . ini_get('post_max_size') . "\n";
echo 'memory_limit = ' . ini_get('memory_limit') . "\n";
*/

/*
$max_execution_time = ini_get('max_execution_time');
$max_input_time = ini_get('max_input_time');

$magic_quotes_gpc = ini_get('magic_quotes_gpc'); // boolean
$safe_mode = ini_get('safe_mode'); // boolean

$upload_max_filesize = ini_get('upload_max_filesize');
$post_max_size = ini_get('post_max_size');
$memory_limit = ini_get('memory_limit');
*/

/*
max_execution_time: 3600                                                                
max_input_time 3600
magic_quotes_gpc ON
safe_mode OFF

upload_max_filesize 1024M (or more)
post_max_size 1025M                               
memory_limit 1026M
*/

$arrIniParams = array( "max_execution_time", "max_input_time", "magic_quotes_gpc", "safe_mode", 
"upload_max_filesize", "post_max_size", "memory_limit", "track_errors", "output_buffering", "output_handler" ); // checks these ini parameters

$arrIniSugValues = array( "3600", "3600", "OFF", "OFF", 
"1024M", "1025M", "1026M", "ON", "1", "no value" ); // suggested values

for($i = 0, $size = sizeof($arrIniParams); $i < $size; ++$i) {
	$get = ini_get($arrIniParams[$i]); // could be int, string, boolean (ON = 1, OFF = null)
	// string on success, or an empty string on failure or for null values. 

/*	
	if ($get == null) {
		$get = "0";
	}
*/
	$arrIniCurValues[$i] = $get; // current values of the configuration option
}

	$safe_mode = (int) ini_get('safe_mode'); //off
	$output_handler = (int) ini_get('output_handler'); //no value
	echo "--".$safe_mode."--"; 
	echo "--".$output_handler."--"; 
	
print_r($arrIniCurValues);

displayTable($arrIniParams, $arrIniCurValues, $arrIniSugValues);
?>
