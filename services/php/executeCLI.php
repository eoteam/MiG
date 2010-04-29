<?php

/**
 * execute.php is a generic file which looks up the function it
 * should call in the read/write function files. The results from
 * the function are serialized as XML and returned to the application
 */

require_once "readFunctions.php";
require_once "writeFunctions.php";
require_once "loginFunctions.php";
require_once "fileFunctions.php";
require_once "customFunctions.php";
require_once "config/constants.php";

// get any parameters that were passed in the post 

if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$postData = $_GET;
	unset($postData['mode']);
	
} else {

	$postData = fgets(STDIN);
}
$postData = trim($postData);
$postData = split("&",$postData);
// iterate through the array, cleaning data as we go!

$params = array();

// escape all post data, for security!

foreach ($postData as $chunk) 
{
	$chunkArr = explode("=",$chunk);
	$key = $chunkArr[0];
	$value = $chunkArr[1];
	if (($value || $value == '0') && $key != 'submit')
	 	$params[$key] = addslashes($value);
	
}
	
/*echo "<pre>";
print_r($params);
echo "</pre>";
exit(); 
*/

// append custom functions to vaildActions array!

$validActions = array_merge($validActions,$customFunctions);

// if we don't have a valid function, quit
if (!isset($params['action']) || !in_array($params['action'],$validActions))
{
    die("Invalid Action Specified.");
}

// get the result from the query_function
$action = $params['action'];
$result = $action($params);
//$result = stripslashes($result);
// output the serialized xml
output_xml($result);


?>
