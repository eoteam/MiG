<?php

/**
 * checks minimum required version of PHP
 * @param String $minVersion - PHP version (e.g.: "5.2.*" or "5.2")
 */
function checkPHPVersion($minVersion)
{
	$phpV = PHP_VERSION;

	// if we've got a system like ubuntu or something else, we get something like '5.2.4-2ubuntu5.2',
	// the following will fix it
	if (strpos($phpV,'-') != null) {
		$phpV = substr($phpV,0,strpos($phpV,'-'));
	}

	if ($phpV[0] >= $minVersion[0]) {
		if (empty($minVersion[2]) || $minVersion[2] == '*') {
			return true;
		} else if ($phpV[2] >= $minVersion[2]) {
			if (empty($minVersion[4]) || $minVersion[4] == '*' || $phpV[4] >= $minVersion[4]) {
				return true;
			}
		}
	}

	return false;
}

/**
 * returns array of files found by extension at the root directory
 * @param String $rootDir - directory to search in
 * @param String $extension - extension of the file to find
 */
function findFilesByExt($rootDir, $extension)
{
	$files = array();

	$directory = new RecursiveDirectoryIterator($rootDir);
	$iterator = new RecursiveIteratorIterator($directory); // gets all files and directories under $rootDir
	$ext = '/^.+\.'.$extension.'$/i';
	$regex = new RegexIterator($iterator, $ext, RecursiveRegexIterator::GET_MATCH); // gets all .extension files recursively

	foreach ($regex as $path=>$cur) {
		$path = preg_replace("{\\\}", "/", $path);
		$files[] .= $path;
	}

	return $files;
}

/**
 *
 * @param String $rootDir - directory to search in
 * @param String $filename
 * @param return array $files - array of the found files
 */
function findFilesByName($rootDir, $filename, $files = array())
{
	$dir_content = scandir($rootDir);					// run through content of root directory
	foreach($dir_content as $key => $content)
	{
		if ($key != 0 && $key != 1) {
			$path = $rootDir.'/'.$content;
			if(is_file($path) && is_readable($path)) {
				if ($content == $filename) {
					$files[] = $path;					// save file path
				}
			} else if(is_dir($path) && is_readable($path)) {
				$files = findFilesByName($path, $filename, $files);		// recursive callback to open new directory
			}
		}
	}

	return $files;
}

/**
 * deletes file by path
 * @param String $path
 */
function deleteFile($path)
{
	$filename = substr($path, strrpos($path, '/') + 1);
	$filepath = substr($path, 0, strrpos($path, '/'));
	$olddir = getcwd();
	chdir($filepath);

	if (is_file($filename)) {
		if (unlink($filename)) {
			chdir($olddir);
			return true;
		} else {
			chdir($olddir);
			return false;
		}
	} else {
		chdir($olddir);
		return false;
	}
}

/**
 * creates new file, writes provided data in it
 * @param String $filepath
 * @param String $data
 */
function createFile($path, $data)
{

	$filename = substr($path, strrpos($path, '/') + 1);
	$filepath = substr($path, 0, strrpos($path, '/'));

	$olddir = getcwd();
	chdir($filepath);

	if (!is_file($filename)) {
		if ($handle = fopen($filename,"x")) {
			fwrite($handle,$data);
			fclose($handle);
			chdir($olddir);
			return true;
		} else {
			chdir($olddir);
			return false;
		}
	} else {
		chdir($olddir);
		return false;
	}
}

/**
 * recursively deletes directory's content except $filesStay files
 * @param $rootDir
 * @param $filesStay
 */
function emptyFolder($rootDir, $filesStay)
{
	$dir_content = scandir($rootDir); // run through content of root directory
	foreach($dir_content as $key => $content)
	{
		if ($key != 0 && $key != 1) {
			$path = $rootDir.'/'.$content;
			if(is_file($path) && is_readable($path)) {
				if (!in_array($content, $filesStay)) {
					unlink($path);
				}
			} else if(is_dir($path) && is_readable($path)) {
				emptyFolder($path, $filesStay);
				rmdir($path);
			}
		}
	}

	return;
}

/**
 * Generic database connect function.
 */
function connectOldDatabase()
{
	// connects to the database
	$mysql = mysql_connect(DB_SERVER, DB_USER, DB_PASS);

	if (!$mysql) {
		return "Could not connect to a server: " . mysql_error() .".";
	} else {
		return $mysql;
	}
}

/**
 * Generic database connect function.
 * With selected database.
 */
function connectNewDatabase()
{
	// connects to the database
	$mysql = mysql_connect(DB_SERVER, DB_USER, DB_PASS);

	if (!$mysql) {
		return "Could not connect to a server: " . mysql_error() .".";
	}

	// select the database
	mysql_select_db(DB_NAME);
	return $mysql;
}

/**
 * Generic database query function.
 * @param $query
 * @param $mysql - link identifier
 */
function queryDatabase($query, $mysql)
{
	// query the database
	$result = mysql_query($query, $mysql);

	if (!$result) {
		return "Error in query : " . mysql_error() .".";
	}

	return $result;
}

/**
 * removes installed database
 * @param $db_name
 */
function removeDatabase($db_name)
{
	$mysql = connectOldDatabase();
	if (!$mysql) {
		return $mysql;
	}

	$query = "DROP SCHEMA IF EXISTS `".$db_name."`";
	$result = queryDatabase($query, $mysql);
	if (!$result) {
		return $result;
	}

	mysql_close($mysql);
	return true;
}

/**
 *
 * @param String $filename
 */
function sanitize_file_name( $filename )
{
	$filename_raw = $filename;
	$special_chars = array("?", "[", "]", "/", "\\", "=", "<", ">", ":", ";", ",", "'", "\"", "&", "$", "#", "*", "(", ")", "|", "~", "`", "!", "{", "}", chr(0));
	$filename = str_replace($special_chars, '', $filename);
	$filename = preg_replace('/[\s-]+/', '-', $filename);
	$filename = trim($filename, '.-_');

	// Split the filename into a base and extension[s]
	$parts = explode('.', $filename);

	return $filename;
}

/**
 *
 * @param $s string to crypt
 */
function text_crypt($s) {
	global $START_CHAR_CODE, $CRYPT_SALT;

	if ($s == "")
	return $s;
	$enc = rand(1,255); # generate random salt.
	$result = text_crypt_symbol($enc); # include salt in the result;
	$enc ^= $CRYPT_SALT;
	for ($i = 0; $i < strlen($s); $i++) {
		$r = ord(substr($s, $i, 1)) ^ $enc++;
		if ($enc > 255)
		$enc = 0;
		$result .= text_crypt_symbol($r);
	}
	return $result;
}

function text_crypt_symbol($c) {

	# $c is ASCII code of symbol. returns 2-letter text-encoded version of symbol
	global $START_CHAR_CODE, $CRYPT_SALT;
	return chr($START_CHAR_CODE + ($c & 240) / 16).chr($START_CHAR_CODE + ($c & 15));
}


/**
 * displays a table of configuration options
 * @param array $iniKeys
 * @param array $iniCurValues
 * @param array $iniSugValues
 */
function displayTable($iniKeys, $iniCurValues, $iniSugValues)
{
	?>
<html>
<head></head>
<body>
<br /><br />
<table border cellpadding=3>
	<tr>
		<td>Configuration option</td>
		<td>Current value</td>
		<td>Suggested value</td>
	</tr>
	<?php
	foreach($iniKeys as $key => $value)
	{
		?>
	<tr>
		<td><?php echo $value?></td>
		<td><?php echo $iniCurValues[$key]?></td>
		<td><?php echo $iniSugValues[$key]?></td>
	</tr>

	<?php
	}
	?>
</table>
</body>
</html>
	<?php
}
?>