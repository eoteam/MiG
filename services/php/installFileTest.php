<?php

 require_once "includes/functions.php";
 require_once "zip/pclzip.lib.php";
 require_once "fileFunctions.php";
 
 $errorMsg = "";
 $phpMinRequiredV = "5.2.*";
/*
 // checks if the actual PHP version is newer than '5.2.*'
 if (phpMinVersion($phpMinRequiredV)) {
 $errorMsg .= "PHP version is newer or equal to ".$phpMinRequiredV.".\n";
 } else {
 $errorMsg .= "PHP version is older than ".$phpMinRequiredV.".\n";
 die($errorMsg);
 }

 $arrExtToCheck = array( "PDO", "gd", "zip" );

 // checks if extension is loaded
 for($i = 0, $size = sizeof($arrExtToCheck); $i < $size; ++$i)
 {
 if (!extension_loaded($arrExtToCheck[$i])) {
 $errorMsg .= $arrExtToCheck[$i]." extension is not installed.\n";
 die($errorMsg);
 } else {
 $errorMsg .= $arrExtToCheck[$i]." extension is installed.\n";
 }
 }

 //echo(get_loaded_extensions());


 chdir('/testinstaller');
 //echo getcwd()."\n";

 $fileDir = "./files/";
 $thumbDir = "./files/migThumbs/";
 $tempDir = "./temporary/";

 $fontsDir = "./fonts/";
 $xmlDir = "./xml/";

 $arrFoldersToCreate = array( $fileDir,$thumbDir,$tempDir,$fontsDir,$xmlDir );

 // creates folders
 for($i = 0, $size = sizeof($arrFoldersToCreate); $i < $size; ++$i)
 {
 if (mkdir($arrFoldersToCreate[$i], 0777)) {
 $errorMsg .= "Folder ".$arrFoldersToCreate[$i]." successfully created.\n";
 } else {
 $errorMsg .= "Failed to create ".$arrFoldersToCreate[$i]." folder.\n";
 die($errorMsg);
 }
 }

 //echo getcwd()."\n\n";

 // gets package filepath
 //$zipFileName = sanitize_file_name($_FILES['Filedata']['name']);
 $zipFileName = "C:/testinstaller/sample2.zip";
 //print_r($zipFileName);

 //unzips package
 $archive = new PclZip($zipFileName);
 if (($v_result_list = $archive->extract(PCLZIP_OPT_PATH, './')) == 0) {
 $errorMsg .= "Error while unzipping the package : ".$archive->errorInfo(true)."\n";
 die($errorMsg);
 } else {
 $errorMsg .= "Package unzipped successfully.\n";
 }
 */

/*
// modifies database.php 
$db_server = $_REQUEST["db_server"];
$db_user = $_REQUEST["db_user"];
$db_pass = $_REQUEST["db_pass"];
$db_name = $_REQUEST["db_name"];

define("DB_SERVER", $db_server);
define("DB_USER", $db_user);
define("DB_PASS", $db_pass);
define("DB_NAME", $db_name);
*/
/*
 $db_name = "importtest";
 $sql = "DROP SCHEMA IF EXISTS `".$db_name."`";
 if (!$result = queryDatabase($sql)) {
 	print_r ("Error : ".$result->errorInfo()."\n");
 }
 
 $sql = "CREATE SCHEMA `".$db_name."` DEFAULT CHARACTER SET latin1 ;";
 if (!$result = queryDatabase($sql)) {
 	print_r ("Error creating the database : ".$result->errorInfo()."\n");
 }
 */
 
// retrieves SQL file
$sqlFileName = "C:/testinstaller/mig_db_default.sql";

chdir('/testinstaller');
 
$rootDir = ".";
$allowExtension = array("sql");
$files_array = scanDirectories($rootDir, $allowExtension);
$files_array2 = getFile($rootDir);
print_r($files_array);
print_r($files_array2);


/*
// imports database

$handle = @fopen($sqlFileName, "r");
$query = '';
if ($handle) {
	while (!feof($handle)) {
		$query .= fgets($handle, 4096);
		if (substr(rtrim($query), -1) == ';') {
			print_r ("Query executing... : ".$query);
			if ($result = queryDatabase($query)) {
				//print_r ("Query executed : ".$query."\n");

				
				print_r(" !done!\n");
			} else {
				print_r ("Error importing the database: ".$result->errorInfo()."\n");
			}
			//print_r($query);
			//print_r("\n---\n");
			// ...run your query, then unset the string
			$query = '';
		}
	}
	fclose($handle);
	$errorMsg .= "Database imported successfully.\n";
} else {
	$errorMsg .= "Failed to open SQL file.\n";
}
*/
//

/*
 $sql = "SHOW COLUMNS FROM fonts;";
 $sql .= " SELECT name FROM templates where id=2;";
 $result = queryDatabase($sql);
 $row = $result->fetch(PDO::FETCH_ASSOC);
 print_r($row);
 */

//print_r($errorMsg);
echo "\n the end ";






/*
 ../ - parent
 ./ - same folder
 / - cwd
 */
//modify html form
?>