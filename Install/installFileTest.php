<?php
require_once "functions.php";
require_once "zip/pclzip.lib.php";

$errorMsg = "";
$minRequiredPHPV = "5.2";
$rootDir = "."; // uses for functions: findFilesByName, emptyFolder; (the same directory as cwd)

$olddir = getcwd();

// changes current working directory to C:/testintaller
chdir('/testinstaller'); //TODO: check whether it works without changing cwd

// if error occurs, working folder will be clean, but these files will stay
$arrMandatoryFiles = array( "sample.zip" );  //TODO: add mandatory files (html/php/exe/..)

//////////////////////////////////////////////////////////////////////////////////
// checks if the PHP version is newer than $minRequiredPHPV

if (checkPHPVersion($minRequiredPHPV)) {
	$errorMsg .= "PHP version is newer or equal to ".$minRequiredPHPV.".\n";
} else {
	$errorMsg .= "ERROR : PHP version is elder than ".$minRequiredPHPV.".\n";
	chdir($olddir);
	die($errorMsg);
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// checks if extensions are loaded

$arrExtToCheck = array( "PDO", "gd", "zip" ); // required extensions

for($i = 0, $size = sizeof($arrExtToCheck); $i < $size; ++$i)
{
	if (extension_loaded($arrExtToCheck[$i])) {
		$errorMsg .= $arrExtToCheck[$i]." extension is installed.\n";
	} else {
		$errorMsg .= "ERROR : " .$arrExtToCheck[$i]." extension is not installed.\n";
		chdir($olddir);
		die($errorMsg);
	}
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// gets package filepath

$zipFilename = sanitize_file_name($_FILES['Filedata']['name']);
if (is_file($zipFilename)) {
	$errorMsg .= "Package is provided.\n";
} else {
	$errorMsg .= "ERROR : Package is not provided.\n";
	chdir($olddir);
	die($errorMsg);
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
//unzips package

$archive = new PclZip($zipFilename);
if (($v_result_list = $archive->extract(PCLZIP_OPT_PATH, './')) != 0) {
	$errorMsg .= "Package unzipped successfully.\n";
} else {
	$errorMsg .= "ERROR : Package was not unzipped: ".$archive->errorInfo(true)."\n";
	chdir($olddir);
	die($errorMsg);
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// checks for DB info and modifies ./php/includes/database.php file

if (isset($_REQUEST['db_server']) && isset($_REQUEST['db_user']) &&
isset($_REQUEST['db_pass']) && isset($_REQUEST['db_name'])) {

	$db_server = $_REQUEST["db_server"];
	$db_user = $_REQUEST["db_user"];
	$db_pass = $_REQUEST["db_pass"];
	$db_name = $_REQUEST["db_name"];

	if ($db_server != "" &&  $db_user != "" && $db_name != "") { //&& $db_pass != "") {

		// finds database.php file
		$filename = "database.php";
		$foundFilesArray = findFilesByName($rootDir, $filename);
		$countFiles = sizeof($foundFilesArray); // counts found files

		if ($countFiles > 1) {
			$errorMsg .= "ERROR : More than one '" .$filename. "' files found.\n";
			
			emptyFolder($rootDir, $arrMandatoryFiles); // revert
			$errorMsg .= "(folder is empty)\n";
	
			chdir($olddir);
			die($errorMsg);
		} else if ($countFiles == 0) {
			$errorMsg .= "ERROR : File '" .$filename. "' not found.\n";
			
			emptyFolder($rootDir, $arrMandatoryFiles); // revert
			$errorMsg .= "(folder is empty)\n";
	
			chdir($olddir);
			die($errorMsg);
		} else {
			foreach ($foundFilesArray as $key=>$value) {
				$databaseFilepath = $value;
			}
			$errorMsg .= "File '" .$databaseFilepath. "' found.\n";
		}

		// deletes and creates new database.php file
		$data = '<?php
			define("DB_SERVER", "'. $db_server .'");
			define("DB_USER", "'. $db_user .'");
			define("DB_PASS", "'. $db_pass .'");
			define("DB_NAME", "'. $db_name .'");?>';

		if (deleteFile($databaseFilepath)) {
			$errorMsg .= "File '" .$databaseFilepath. "' deleted.\n";
		} else {
			$errorMsg .= "ERROR : File '" .$databaseFilepath. "' is not a file or cannot be deleted.\n";
			
			emptyFolder($rootDir, $arrMandatoryFiles); // revert
			$errorMsg .= "(folder is empty)\n";
	
			chdir($olddir);
			die($errorMsg);
		}

		if (createFile($databaseFilepath, $data)) {
			$errorMsg .= "File '" .$databaseFilepath. "' created.\n";
		} else {
			$errorMsg .= "ERROR : File '" .$databaseFilepath. "' exists or cannot be created.\n";
			
			emptyFolder($rootDir, $arrMandatoryFiles); // revert
			$errorMsg .= "(folder is empty)\n";
	
			chdir($olddir);
			die($errorMsg);
		}

		// defines constants for the further use
		define("DB_SERVER", $db_server);
		define("DB_USER", $db_user);
		define("DB_PASS", $db_pass);
			
	} else {
		$errorMsg .= "ERROR : Invalid db data provided.\n";
		
		emptyFolder($rootDir, $arrMandatoryFiles); // revert
		$errorMsg .= "(folder is empty)\n";
	
		chdir($olddir);
		die($errorMsg);
	}
} else {
	$errorMsg .= "ERROR : DB information is not provided. All fields are required.\n";
	
	emptyFolder($rootDir, $arrMandatoryFiles); // revert
	$errorMsg .= "(folder is empty)\n";
	
	chdir($olddir);
	die($errorMsg);
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// checks for $_REQUEST['folder_name'] and modifies ./php/config/filepath.php file

if (isset($_REQUEST['folder_name'])) {

	$folder_name = $_REQUEST['folder_name'];

	if ($folder_name != "") {
		if ($folder_name != "files") {

			// finds filepath.php file
			$filename = "filepath.php";
			$foundFilesArray = findFilesByName($rootDir, $filename);
			$countFiles = sizeof($foundFilesArray); // count found files

			if ($countFiles > 1) {
				$errorMsg .= "ERROR : More than one '" .$filename. "' files found.\n";
				
				emptyFolder($rootDir, $arrMandatoryFiles); // revert
				$errorMsg .= "(folder is empty)\n";
	
				chdir($olddir);
				die($errorMsg);
			} else if ($countFiles == 0) {
				$errorMsg .= "ERROR : File '" .$filename. "' not found.\n";
				
				emptyFolder($rootDir, $arrMandatoryFiles); // revert
				$errorMsg .= "(folder is empty)\n";
	
				chdir($olddir);
				die($errorMsg);
			} else {
				foreach ($foundFilesArray as $key=>$value) {
					$constantFilepath = $value;
				}
				$errorMsg .= "File '" .$constantFilepath. "' found.\n";
			}

			// deletes and creates new filepath.php file
			$data = '<?php
					$fileDir = "./' . $folder_name . '/";
					$thumbDir = "./' . $folder_name . '/migThumbs/";
					$tempDir = "./temporary/";?>';

			if (deleteFile($constantFilepath)) {
				$errorMsg .= "File " .$constantFilepath. " deleted.\n";
			} else {
				$errorMsg .= "ERROR : File '" .$constantFilepath. "' is not a file or cannot be deleted.\n";

				emptyFolder($rootDir, $arrMandatoryFiles); // revert
				$errorMsg .= "(folder is empty)\n";
	
				chdir($olddir);
				die($errorMsg);
			}

			if (createFile($constantFilepath, $data)) {
				$errorMsg .= "File '" .$constantFilepath. "' created.\n";
			} else {
				$errorMsg .= "ERROR : File '" .$constantFilepath. "' exists or cannot be created.\n";
				
				emptyFolder($rootDir, $arrMandatoryFiles); // revert
				$errorMsg .= "(folder is empty)\n";
	
				chdir($olddir);
				die($errorMsg);
			}
		}
	} else {
		$errorMsg .= "ERROR : Folder name is null.\n";
		
		emptyFolder($rootDir, $arrMandatoryFiles); //revert
		$errorMsg .= "(folder is empty)\n";
	
		chdir($olddir);
		die($errorMsg);
	}
} else {
	$errorMsg .= "ERROR : Folder name is not provided.\n";
	
	emptyFolder($rootDir, $arrMandatoryFiles); // revert
	$errorMsg .= "(folder is empty)\n";
	
	chdir($olddir);
	die($errorMsg);
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// creates folders

$fileDir = "./" . $folder_name . "/";
$thumbDir = "./" . $folder_name . "/migThumbs/";
$tempDir = "./temporary/";

$fontsDir = "./fonts/";
//$xmlDir = "./xml/";

$arrFoldersToCreate = array( $fileDir, $thumbDir, $tempDir, $fontsDir );//, $xmlDir );

for($i = 0, $size = sizeof($arrFoldersToCreate); $i < $size; ++$i)
{
	if (mkdir($arrFoldersToCreate[$i], 0777)) {
		$errorMsg .= "Folder '" .$arrFoldersToCreate[$i]. "' successfully created.\n";
	} else {
		$errorMsg .= "ERROR : Failed to create '" .$arrFoldersToCreate[$i]. "' folder.\n";
		
		emptyFolder($rootDir, $arrMandatoryFiles); // revert
		$errorMsg .= "(folder is empty)\n";
	
		chdir($olddir);
		die($errorMsg);
	}
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// finds SQL file

$extension = "sql";
$foundFilesArray = findFilesByExt($rootDir, $extension);
$countFiles = sizeof($foundFilesArray); // count found files

if ($countFiles > 1) {
	$errorMsg .= "ERROR : More than one '" .strtoupper($extension). "' files found.\n";
	
	emptyFolder($rootDir, $arrMandatoryFiles); // revert
	$errorMsg .= "(folder is empty)\n";
	
	chdir($olddir);
	die($errorMsg);
} else if ($countFiles == 0) {
	$errorMsg .= "ERROR : File '" .strtoupper($extension). "' not found.\n";
	
	emptyFolder($rootDir, $arrMandatoryFiles); // revert
	$errorMsg .= "(folder is empty)\n";
	
	chdir($olddir);
	die($errorMsg);
} else {
	foreach ($foundFilesArray as $key=>$value) {
		$sqlFilepath = $value;			// SQL filepath
	}
	$errorMsg .= strtoupper($extension). " file found ('" .$sqlFilepath. "').\n";
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// creates database $db_name

$mysql = connectOldDatabase();

$sql = "DROP SCHEMA IF EXISTS `".$db_name."`";
$result = queryDatabase($sql,$mysql);
if (!$result) {
	$errorMsg .= "ERROR : " .$result. "\n";
	mysql_close($mysql);
	
	emptyFolder($rootDir, $arrMandatoryFiles);
	$errorMsg .= "(folder is empty)\n";
	
	chdir($olddir);
	die($errorMsg);
}

$sql = "CREATE SCHEMA `".$db_name."` DEFAULT CHARACTER SET latin1";
$result = queryDatabase($sql,$mysql);
if ($result) {
	$errorMsg .= "Database " .$db_name. " created.\n";
	mysql_close($mysql);
} else {
	$errorMsg .= "ERROR : " .$result. "\n";
	mysql_close($mysql);
	
	emptyFolder($rootDir, $arrMandatoryFiles); // revert
	$errorMsg .= "(folder is empty)\n";
	
	chdir($olddir);
	die($errorMsg);
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// imports database $sqlFilepath

define("DB_NAME", $db_name);	// defines mig database name constant
$mysql = connectNewDatabase();	// connects to new mig database

$handle = @fopen($sqlFilepath, "r");
$query = '';
if ($handle) {
	while (!feof($handle)) {
		$query .= fgets($handle, 4096);
		if (substr(rtrim($query), -1) == ';') {
			if (!$result = queryDatabase($query,$mysql)) {
				$errorMsg .= "ERROR : " .$result. "\n";
				mysql_close($mysql);

				if ($remove = removeDatabase($db_name)) { // revert
					$errorMsg .= "(database removed)\n";
				} else {
					$errorMsg .= "ERROR : " .$remove. " (cannot remove database)\n";
				}

				emptyFolder($rootDir, $arrMandatoryFiles); // revert
				$errorMsg .= "(folder is empty)\n";

				chdir($olddir);
				die($errorMsg);
			}
			$query = '';
		}
	}
	fclose($handle);
	$errorMsg .= "Database " .$sqlFilepath. " imported successfully.\n";
	mysql_close($mysql);
} else {
	$errorMsg .= "ERROR : Failed to open " .$sqlFilepath. " file.\n";
	mysql_close($mysql);
	
	emptyFolder($rootDir, $arrMandatoryFiles); // revert
	$errorMsg .= "(folder is empty)\n";
	
	chdir($olddir);
	die($errorMsg);
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// imports user record to 'user' table at database $db_name

$mysql = connectNewDatabase();	// connects to new mig database

$query = " INSERT INTO `user` ( id, usergroupid, username, password, createdate, createdby, modifiedby ) ";
$query .= " VALUES ( '1', '8', '" .$db_user. "', '" .text_crypt($db_pass). "', '" .date('mdY'). "', '1', '1' ) ";

if ($result = queryDatabase($query, $mysql)) {
	$errorMsg .= "New user '" .$db_user. "' inserted to 'user' table.\n";
	mysql_close($mysql);
} else {
	$errorMsg .= "ERROR : " .$result. "\n";
	mysql_close($mysql);

	if ($remove = removeDatabase($db_name)) {
		$errorMsg .= "(database removed)\n";
	} else {
		$errorMsg .= "ERROR : " .$remove. " (cannot remove database)\n";
	}

	emptyFolder($rootDir, $arrMandatoryFiles); // revert
	$errorMsg .= "(folder is empty)\n";
	
	chdir($olddir);
	die($errorMsg);
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// deletes files: sql, zip, ... (?)

$zipFilepath = "./".$zipFilename;
$arrFilesToDel = array( $sqlFilepath, $zipFilepath );	// files to delete by path

for($i = 0, $size = sizeof($arrFilesToDel); $i < $size; ++$i)
{
	if (deleteFile($arrFilesToDel[$i])) {
		$errorMsg .= "File " .$arrFilesToDel[$i]. " deleted.\n";
	} else {
		$errorMsg .= "ERROR : File " .$arrFilesToDel[$i]. " is not a file or cannot be deleted.\n";

		if ($remove = removeDatabase($db_name)) {
			$errorMsg .= "(database removed)\n";
		} else {
			$errorMsg .= "ERROR : " .$remove. " (cannot remove database)\n";
		}

		emptyFolder($rootDir, $arrMandatoryFiles); // revert
		$errorMsg .= "(folder is empty)\n";
		
		chdir($olddir);
		die($errorMsg);
	}
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// checks for configuration options

$arrIniParams = array( "max_execution_time", "max_input_time", "magic_quotes_gpc", "safe_mode", 
"upload_max_filesize", "post_max_size", "memory_limit" ); // checks these ini parameters

$arrIniSugValues = array( "3600", "3600", "ON", "OFF", 
"1024M", "1025M", "1026M" ); // suggested values

for($i = 0, $size = sizeof($arrIniParams); $i < $size; ++$i) {
	$get = ini_get($arrIniParams[$i]); // string on success, or an empty string on failure or for null values. 
	if ($get == null) $get = "OFF or 'no value'";
	if ($get == 1) $get = "ON or 1";
	$arrIniCurValues[$i] = $get; // current values
}
//////////////////////////////////////////////////////////////////////////////////

chdir($olddir);
$errorMsg .= "\n SUCCESS \n";
echo $errorMsg;

displayTable($arrIniParams, $arrIniCurValues, $arrIniSugValues);

?>