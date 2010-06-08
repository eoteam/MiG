<?php

require_once "database.php";

// PEAR error management and XML_Serializer
require_once "PEAR.php";
require_once "XML_Serializer.php";
require_once "XML_Util.php";

ini_set('display_errors','1');
ini_set('display_startup_errors','1');
error_reporting (E_ALL);


function userErrorHandler($errno, $errmsg, $filename, $linenum, $vars)
{
    // timestamp for the error entry
    $dt = date("Y-m-d H:i:s (T)");

    // define an assoc array of error string
    // in reality the only entries we should
    // consider are E_WARNING, E_NOTICE, E_USER_ERROR,
    // E_USER_WARNING and E_USER_NOTICE
    $errortype = array (
                E_ERROR              => 'Error',
                E_WARNING            => 'Warning',
                E_NOTICE             => 'Notice',
                E_USER_ERROR         => 'User Error',
                E_USER_WARNING       => 'User Warning',
                E_USER_NOTICE        => 'User Notice',
                E_STRICT             => 'Runtime Notice',
                E_RECOVERABLE_ERROR  => 'Catchable Fatal Error'
                );
    // set of errors for which a var trace will be saved
    $user_errors = array(E_USER_ERROR, E_USER_WARNING, E_USER_NOTICE);
    
	if($errortype[$errno] != "Warning" AND $errortype[$errno] != "User Notice" AND $errortype[$errno] != "User Warning" AND $errortype[$errno] != "Runtime Notice")
	{
		$err = "<result>\n";
		$err .= "\t<errorentry>\n";
	    $err .= "\t<datetime>" . $dt . "</datetime>\n";
	    $err .= "\t<errornum>" . $errno . "</errornum>\n";
	    $err .= "\t<errortype>" . $errortype[$errno] . "</errortype>\n";
	    $err .= "\t<errormsg>" . $errmsg . "</errormsg>\n";
		$err .= "</errorentry>\n";
	    $err .= "</result>\n\n";
		
		
		$error = array("errorName"=>$errortype[$errno], "errorNumber"=>$errno, "errorMsg"=>$errmsg);
		
		$result = array();
		array_push($result, $error);
		
		//$newerror = '[error]';
		$options = array(
	        XML_SERIALIZER_OPTION_XML_DECL_ENABLED => false,
	        XML_SERIALIZER_OPTION_DOCTYPE_ENABLED => false,
	        XML_SERIALIZER_OPTION_INDENT => "    ",
	        XML_SERIALIZER_OPTION_LINEBREAKS => "\n",
	        XML_SERIALIZER_OPTION_TYPEHINTS => false,
	        XML_SERIALIZER_OPTION_XML_ENCODING => "UTF-8?",
	        XML_SERIALIZER_OPTION_ROOT_NAME => "results",
	        XML_SERIALIZER_OPTION_DEFAULT_TAG => "result",
	        XML_SERIALIZER_OPTION_CDATA_SECTIONS => true
	    );

	    // instatiate the serializer object
	    $serializer = new XML_Serializer($options);
	    $serializer->setErrorHandling(PEAR_ERROR_DIE);

	    // serialze the data
	    $status = $serializer->serialize($result);

	    // check whether serialization worked
	    if (PEAR::isError($status)) {
	        die($status->getMessage());
	    }

	    // get the serialized data
	    $xml = $serializer->getSerializedData();

	    header("Content-type: text/xml");

	    // return the xml
	    echo($xml);
		exit;
		//echo "ECHO ".$err;
	}
    
}
function sendSuccess($message = null) // this function returns an xml success message, along with an insertid (if applicable)
{
	header("Content-type: text/xml");
	$output = '<result><success>true</success>';
	if($message) {
		$output .='<message>'.$message.'</message>';
	}
	$output .= '</result>';
    echo($output);
	exit;	
}
function sendFailed($message=null)
{
	header("Content-type: text/xml");
	$output = '<result><success>false</success>';
	if($message) {
		$output .='<message>'.$message.'</message>';
	}
	$output .= '</result>';
    echo($output);
	exit;
}

/**
 * Quote variables to make safe.
 */
function quote_smart($value)
{
   // Stripslashes
   if (get_magic_quotes_gpc()) {
       $value = stripslashes($value);
   }
   // Quote if not integer
   if (!is_numeric($value)) {
       $value = "'" . mysql_real_escape_string($value) . "'";
   }
   return $value;
}

/**
 * returns array of fields for the table
 */
function getTableColumns($tablename)
{
	$sql = "SHOW COLUMNS FROM ".$tablename;
	$result = queryDatabase($sql);
	$columnsArray = array();
	
    while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
		$columnsArray[] = $row['Field'];
    }
    
    return $columnsArray;
}

/**
 * returns auto-increment for the table
 */
function getAutoIncrement($tablename)
{
	$sql = "SELECT Auto_increment FROM information_schema.tables WHERE table_name='".$tablename."' AND table_schema='".DB_NAME."'";
	$result = queryDatabase($sql);
	$row = $result->fetch(PDO::FETCH_ASSOC);
	$autoIncrement = $row['Auto_increment'];
    
    return $autoIncrement;
}

/**
 * Generic database query function. Returns the results
 * from the database query.
 */
function queryDatabase($query, $params=null, &$outparams=null)
{
	// connects to the database
	try {
		$hostname = DB_SERVER;
		$dbname = DB_NAME;
		$username = DB_USER;
		$pw = DB_PASS;

		$mysql = new PDO("mysql:host=$hostname;dbname=$dbname","$username","$pw");

/* // sets an attribute: error reporting (just sets error code)	
 * $mysql->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_SILENT );*/
	}
	catch (PDOException $e) {
		echo "Failed to connect:".$e->getMessage()."\n";
		exit;
	}
	
	// prepares a statement for execution and returns a statement object 
	$sth = $mysql->prepare($query);
	if (!$sth){
		$arrayError = $mysql->errorInfo();
		die("PDO::errorInfo(): ".$arrayError[2].".");
	} 

	// binds a value to a parameter
	if ($params!=null){
		foreach ($params as $key=>$value) {
			$sth->bindValue(":".$key, $value);
		}
	}
	// executes a prepared statement
	$result = $sth->execute();
	if (!$result){
		$arrayError = $sth->errorInfo();
		die("PDOStatement::errorInfo(): ".$arrayError[2].".");
	    $sth=null;
	} 
	
	// returns the ID of the last inserted row or sequence value 
	$outparams = $mysql->lastInsertId();

	// returns the PDOStatement Object
	return $sth; 
}

/**
 * Return xml version of result set.
 */
function outputDirectoryListing($newdir){
	$dir=opendir($newdir);
	$resultList = array();
	
	if($dir)
	{
		while(($file = readdir($dir)) !== false){
			
			if($file !== "." && $file !== ".." && $file != "migThumbs" && $file != ".DS_Store"){
				
				$mtime = filemtime($newdir.$file);
				
				if(is_file($newdir.$file))
				{	
					$type="file";
					$size = shell_exec("du -k " . $newdir.$file);
					$chars = preg_split("/[\s,]*\\\"([^\\\"]+)\\\"[\s,]*|" . "[\s,]*'([^']+)'[\s,]*|" . "[\s,]+/", $size, -1, PREG_SPLIT_OFFSET_CAPTURE);	
					//print_r($chars);
					$size = $chars[0][0];
					$createthumb = preg_match_all('/^.*\.(jpg|jpeg|png|gif|tiff|tiff|bmp|mov|m4v|flv|f4v|mp4)$/i',$file, $arr, PREG_PATTERN_ORDER);
				}
				else
				{
					$type="folder";
					$size = dirsize($newdir.$file);
					$createthumb = 0;
				}
				$size *= 1024;
				//$size = byteSize($size);
				$arr =  array("name"=>$file,"createdate"=>$mtime,"size"=>$size,"type"=>$type,"createthumb"=>$createthumb);
				array_push($resultList, $arr);
				
			}
		}
		serializeArray($resultList);
	}
}
function serializeArray($resultList)
{
    $options = array(
        XML_SERIALIZER_OPTION_XML_DECL_ENABLED => false,
        XML_SERIALIZER_OPTION_DOCTYPE_ENABLED => false,
        XML_SERIALIZER_OPTION_INDENT => "    ",
        XML_SERIALIZER_OPTION_LINEBREAKS => "\n",
        XML_SERIALIZER_OPTION_TYPEHINTS => false,
        XML_SERIALIZER_OPTION_XML_ENCODING => "UTF-8?",
        XML_SERIALIZER_OPTION_ROOT_NAME => "results",
        XML_SERIALIZER_OPTION_DEFAULT_TAG => "result",
        XML_SERIALIZER_OPTION_CDATA_SECTIONS => true
    );
    
    // instatiate the serializer object
    $serializer = new XML_Serializer($options);
    $serializer->setErrorHandling(PEAR_ERROR_DIE);
    
    // serialze the data
    $status = $serializer->serialize($resultList);
    
    // check whether serialization worked
    if (PEAR::isError($status)) {
        die($status->getMessage());
    }
    
    // get the serialized data
    $xml = $serializer->getSerializedData();
    
    header("Content-type: text/xml; charset=UTF-8");
    //header("Content-Transfer-Encoding: binary\n");
    // return the xml
    $xml = html_entity_decode($xml,ENT_QUOTES, 'UTF-8');
    $xml = stripslashes($xml);
    $xml = trim($xml);
    echo($xml); 
}
/**
 * Calculate the size of a directory by iterating its contents
 *
 * @author      Aidan Lister <aidan@php.net>
 * @version     1.2.0
 * @link        http://aidanlister.com/repos/v/function.dirsize.php
 * @param       string   $directory    Path to directory
 */
function dirsize($path)
{
    // Init
    $size = 0;

    // Trailing slash
    if (substr($path, -1, 1) !== DIRECTORY_SEPARATOR) {
        $path .= DIRECTORY_SEPARATOR;
    }

    // Sanity check
    if (is_file($path)) {
        return filesize($path);
    } elseif (!is_dir($path)) {
        return false;
    }

    // Iterate queue
    $queue = array($path);
    for ($i = 0, $j = count($queue); $i < $j; ++$i)
    {
        // Open directory
        $parent = $i;
        if (is_dir($queue[$i]) && $dir = @dir($queue[$i])) {
            $subdirs = array();
            while (false !== ($entry = $dir->read())) {
                // Skip pointers
                if ($entry == '.' || $entry == '..') {
                    continue;
                }

                // Get list of directories or filesizes
                $path = $queue[$i] . $entry;
                if (is_dir($path)) {
                    $path .= DIRECTORY_SEPARATOR;
                    $subdirs[] = $path;
                } elseif (is_file($path)) {
					$temp = shell_exec("du -k " . $path);
					$chars = preg_split("/[\s,]*\\\"([^\\\"]+)\\\"[\s,]*|" . "[\s,]*'([^']+)'[\s,]*|" . "[\s,]+/", $temp, -1, PREG_SPLIT_OFFSET_CAPTURE);	
					$size += $chars[0][0];
                }
            }

            // Add subdirectories to start of queue
            unset($queue[0]);
            $queue = array_merge($subdirs, $queue);

            // Recalculate stack size
            $i = -1;
            $j = count($queue);

            // Clean up
            $dir->close();
            unset($dir);
        }
    }

    return $size;
}

function byteSize($bytes)  
    { 
    $size = $bytes; 
    if($size < 1024) 
        { 
        $size = number_format($size, 2); 
        $size .= ' KB'; 
        }  
    else  
        { 
        if($size / 1024 < 1024)  
            { 
            $size = number_format($size / 1024, 2); 
            $size .= ' MB'; 
            }  
        else if ($size / 1024 / 1024 < 1024)   
            { 
            $size = number_format($size / 1024 / 1024, 2); 
            $size .= ' GB'; 
            }  
        } 
    return $size; 
    } 

function ouputMySQLResults($result)
{
    if (is_null($result)){
    	return false;
    }
	// create an array to hold the query result
    $resultList = array();

    if ($result)
    {
    	while ($row = $result->fetch(PDO::FETCH_OBJ))
        {
        	if(isset($row->password))
        	{
        		$row->password = text_decrypt($row->password);
        	}
            array_push($resultList, $row);
        }
    }
	serializeArray($resultList);
}

function text_decrypt_symbol($s, $i) {
	
	# $s is a text-encoded string, $i is index of 2-char code. function returns number in range 0-255
		global $START_CHAR_CODE, $CRYPT_SALT;
			return (ord(substr($s, $i, 1)) - $START_CHAR_CODE )*16 + ord(substr($s, $i+1, 1)) - $START_CHAR_CODE;
}
	
function text_decrypt($s) {

		global $START_CHAR_CODE, $CRYPT_SALT;
		$result = '';
	
		if ($s == "")
			return $s;
		$enc = $CRYPT_SALT ^ text_decrypt_symbol($s, 0);
		for ($i = 2; $i < strlen($s); $i+=2) { # $i=2 to skip salt
			$result .= chr(text_decrypt_symbol($s, $i) ^ $enc++);
			if ($enc > 255)
				$enc = 0;
		}
		return $result;
}
	
function text_crypt_symbol($c) {

	# $c is ASCII code of symbol. returns 2-letter text-encoded version of symbol
		global $START_CHAR_CODE, $CRYPT_SALT;
			return chr($START_CHAR_CODE + ($c & 240) / 16).chr($START_CHAR_CODE + ($c & 15));
}
	
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

function processContentText($text, $limitTo = null, $limitAppend = "...", $stripParaTags = false) 
{

	$text = stripslashes($text);

	if ($stripParaTags)
		$text = strip_tags($text);
	//else
	//	$text = strip_tags_attributes($text,"<p>,<TextFlow>,<span>,<u>,<a><font>","asdxc,href,letterspacing,align,columnGap");

	if ($limitTo && strlen($text) > $limitTo) {
	
		$whitespacePosition = strpos($text," ",$limitTo);
		$text = substr_replace($text, $limitAppend,$whitespacePosition); 
	
		$text = closetags($text); // close any open tags (font, etc.)
	
	}
	
	return $text;
}

function strip_tags_attributes($string,$allowtags=NULL,$allowattributes=NULL){

    $string = strip_tags($string,$allowtags);

    if (!is_null($allowattributes)) {

        if (!is_array($allowattributes))
            $allowattributes = explode(",",$allowattributes);
        if (is_array($allowattributes))
            $allowattributes = implode(")(?<!",$allowattributes);
        if (strlen($allowattributes) > 0)
            $allowattributes = "(?<!".$allowattributes.")";
        $string = preg_replace_callback("/<[^>]*>/i",create_function(
            '$matches',
            'return preg_replace("/ [^ =]*'.$allowattributes.'=(\"[^\"]*\"|\'[^\']*\')/i", "", $matches[0]);'   
        ),$string);

    }
    return $string;
}

function closetags($html) {

	#put all opened tags into an array
	
	preg_match_all ( "#<([a-z]+)( .*)?(?!/)>#iU", $html, $result );
	$openedtags = $result[1];
	
	#put all closed tags into an array
	
	preg_match_all ( "#</([a-z]+)>#iU", $html, $result );
	$closedtags = $result[1];
	$len_opened = count ( $openedtags );
	
	# all tags are closed
	
	if(count($closedtags) == $len_opened) 
		return $html;

	
	$openedtags = array_reverse ( $openedtags );
	
	# close tags
	
	for( $i = 0; $i < $len_opened; $i++ ) {

		if ( !in_array ( $openedtags[$i], $closedtags ) ) {
	
			$html .= "</" . $openedtags[$i] . ">";
	
		} else {
	
			unset ( $closedtags[array_search ( $openedtags[$i], $closedtags)] );
	
		}
	
	}
	
	return $html;

}

class array2xml {

   var $output = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";

   function formatarray2xml($array, $root = 'root', $element = 'element') 
   {    
       $this->output .= $this->make($array, $root, $element);
   }

   function make($array, $root, $element) {
      $xml = "<{$root}>\n";
      foreach ($array as $key => $value) {
         if (is_array($value)) {
            $xml .= $this->make($value, $element, $key);
         } else {
            if (is_numeric($key)) {
               $xml .= "<{$root}><![CDATA[{$value}]]></{$root}>\n";
            } else {
               $xml .= "<{$key}><![CDATA[{$value}]]></{$key}>\n";
            }
         }
      }
      $xml .= "</{$root}>\n";      
      return $xml;
   }
}
?>