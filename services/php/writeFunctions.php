<?php


include_once("zip/pclzip.lib.php");
 require_once "readFunctions.php"; 

function updateRecord($params) // A GENERAL-USE UPDATE FUNCTION
{
	/*
		
		** REQUIRED PARAMS
			tablename - name of the table to update.
			id - id of the record to update.
		
		** OTHER PARAMS	
			Script will attempt to update content with all other name/value pairs provided. You will get an error if you provided invalid field names!
			tags - if found, this will attempt to add tags if they don't already exist in the system, otherwise it will tie tags to the content or media being inserted.
			if a param is sent called 'password' it will automatically be encrypted! -- Not yet, since no decryption is in place		
	
	*/
	$numParamsToUpdate = 0; // count params to update.
	if (isset($params['id']) && isset($params['tablename'])) { // make sure we have a content id and tablename.
	
		$sql = "UPDATE `".$params['tablename']."` SET ";
	
		foreach ($params as $key=>$value) {
			
			if ($key != 'action' && $key != 'id' && $key != 'tablename' && $key != 'tags' && $key != 'verbosity') {
			
				$numParamsToUpdate++;
			if ($key == 'password')
				$sql .= $key . " = '".text_crypt($value) ."', ";
			else	 	
				$sql .= $key . " = '".processText($value)."', ";
			}
			
		}
		
		// remove last comma and space!
		$sql = substr($sql,0,strlen($sql)-2); 
	
		$sql .= " WHERE id = '".$params['id']."'";
	
	} else {
	
		die("No id or tablename Provided.");
	
	}
	
	
	//die($sql);
	
	// get the results
	
	if ($numParamsToUpdate > 0)
		$result = queryDatabase($sql);
	
	if (isset($params['tags']))
		associateTags($params['tablename'],$params['id'],$params['tags']);
	if($params['tablename'] == "content")
		updateContainerPaths(null);
		
	if (isset($params['verbosity']))
	{
		$params2['verbosity'] = $params['verbosity'];
		$params2['contentid'] = $params['id'];
		$result = getContent($params2);
		//$result = stripslashes($result);
		// output the serialized xml
		return $result;	
	}
	else
	{
		sendSuccess();
	}		
	//return the results
	//return $result;
}
function updateTag($params)
{
	if(isset($params['id']) && isset($params['termid']))
	{
		$sql = "UPDATE `term_taxonomy` SET ";
		foreach ($params as $key=>$value) 
		{
			if ($key != 'action' && $key != 'id' && $key != 'name' && $key != 'slug')
			{
				$sql .= $key . " = '".processText($value)."', ";
			}			
		}
		// remove last comma and space!
		$sql = substr($sql,0,strlen($sql)-2); 
		$sql .= " WHERE id = '".$params['id']."'";
		if($result = queryDatabase($sql))
		{
			$sql  = " UPDATE `terms` SET";
			$sql .= " name = '". processText($params['name']) ."' ,";
			$sql .= " slug = '". processSlug($params['slug']) ."'";
			$sql .= " WHERE id = '".$params['termid']."'";
			if($result = queryDatabase($sql))
				sendSuccess();
			else
				die("Query Failed:" . mysql_error());					
		}
		else
			die("Query Failed:" . mysql_error());				
	}
	else
	{
		die("No tag is provided");
	}
}
function insertTag($params)
{
	$validParams = array("taxonomy");
	if (isset($params['taxonomy'])) {
		
		$sql = "INSERT INTO `terms` (name,slug) VALUES (";

		$sql .= "'" . processText($params['name']) . "','" . processSlug($params['slug']) . "')";
		if ($result = queryDatabase($sql)) 
		{
			$insertid = mysql_insert_id();
							
			$sql = "INSERT into term_taxonomy (termid,";
			foreach ($params as $key=>$value) {
				if ($key != 'action' && $key != 'name' && $key != 'slug') {
				
					$sql .= $key . ",";	
				
				}
			}		
			// remove last comma
			$sql = substr($sql,0,strlen($sql)-1);
			$sql .= ")";
			// put values into SQL
			
			$sql .= " VALUES ('". $insertid . "',";
			
			foreach ($params as $key=>$value) {
			
				if ($key != 'action' && $key !='name' && $key != 'slug') {

					$sql .= "'".processText($value)."',";
				
				}	
			}	
			// remove last comma
			$sql = substr($sql,0,strlen($sql)-1);
			$sql .=")";						
			if($result = queryDatabase($sql))
			{
				$insertid = mysql_insert_id();
				$sql = "SELECT term_taxonomy.*,terms.slug,terms.name FROM `term_taxonomy` " .
				   "LEFT JOIN terms ON terms.id = term_taxonomy.termid  WHERE term_taxonomy.id = '".$insertid."'";
				$result = queryDatabase($sql);
				return $result;						
			}
			else
				die("Query Failed:" . mysql_error());								
		}
	}
	else
	{
		die("No taxonomy Provided.");
	}
	//return $result;
	//sendSuccess();
}
function insertRecord($params) // A GENERAL-USE INSERT FUNCTION
{

	/*
		
		** REQUIRED PARAMS
			tablename - name of the table to update.
		
		** OTHER PARAMS
			tags - if found, this will attempt to add tags if they don't already exist in the system, otherwise it will tie tags to the content or media being inserted.
			Script will attempt to insert content with all other name/value pairs provided. You will get an error if you provided invalid field names!
			if a param is sent called 'password' it will automatically be encrypted!!
			
	*/
	
	if (isset($params['tablename'])) { // make sure we have a content id and tablename.
	
		$sql = "INSERT INTO `".$params['tablename']."` ";
		
		// put field names into SQL
		
		$sql .= "(";
		
		foreach ($params as $key=>$value) {
		
			if ($key != 'action' && $key != 'tablename' && $key != 'tags' && $key != 'verbose') {
			
				$sql .= $key . ",";	
			
			}
			
		}
		
		// remove last comma
		$sql = substr($sql,0,strlen($sql)-1);
		
		$sql .= ")";
		
		// put values into SQL
		
		$sql .= " VALUES (";
		
		foreach ($params as $key=>$value) {
		
			if ($key != 'action' && $key != 'tablename' && $key != 'tags' && $key != 'verbose') {
				
			if ($key == 'password')
				$sql .= "'".text_crypt($value)."',";
			else
				$sql .= "'".processText($value)."',";
			
			}	
		}
		
		// remove last comma
		$sql = substr($sql,0,strlen($sql)-1);
		
		$sql .=")";

	
	} else {
	
		die("No id or tablename Provided.");
	
	}
	
	
	//die($sql);
	
	// get the results
	if ($result = queryDatabase($sql)) {
	
		$insertid = mysql_insert_id();
		
		if (isset($params['tags']))
			associateTags($params['tablename'],$insertid,$params['tags']);
		
		if($params['tablename'] == 'content')
		{
			$tokens = updateContainerPaths($params);
				
			$urlPath = '';		
			$arr = split('<>',$tokens);
			foreach($arr as $t)
			{
				$urlPath .= generateSlug($t) . '/';
			}
			if(!isset($params['url'])) {
				$urlPath .= generateSlug($params['title']); //assuming inserting a content record always goes with the title being set. which is true
				$sql = "UPDATE content SET url='" . $urlPath . "' WHERE id='" . $insertid . "'";
				queryDatabase($sql);
			}
		}				
		if (isset($params['verbose']))
		{
			if($params['verbose'] == 'true')
				$sql = "SELECT * FROM `".$params['tablename']."`  WHERE id = '".$insertid."'";
			else
				$sql = "SELECT id FROM `".$params['tablename']."`  WHERE id = '".$insertid."'";
		}
		else
			$sql = "SELECT id FROM `".$params['tablename']."`  WHERE id = '".$insertid."'";
		if ($result = queryDatabase($sql)) 
			return $result;
		else
			die("Query Failed:" . mysql_error());
	}
	else 
	{
		die("Query Failed:" . mysql_error());
	}
	
	return $result;
}
function generateSlug($phrase)
{
    $result = strtolower($phrase);

    $result = preg_replace("/[^a-z0-9\s-]/", "", $result);
    $result = trim(preg_replace("/\s+/", " ", $result));
    $result = trim(substr($result, 0, 45));
    $result = preg_replace("/\s/", "-", $result);

    return $result;
}
function deleteRecord($params) // A GENERAL-USE DELETE FUNCTION
{
	/*
		
		** REQUIRED PARAMS
			tablename - name of the table to delete.
			id - primary key of the record to update.
		
	*/
	//print_r($params);
	if (isset($params['id']) && isset($params['tablename'])) { // make sure we have a content id and tablename.
	
		$sql = "DELETE FROM `".$params['tablename']."` ";
	
		$sql .= " WHERE id = '".$params['id']."'";
	
	} 
	else if (isset($params['idfield1']) && isset($params['tablename']) && isset($params['idfield2']))  {
		$sql = "DELETE FROM `".$params['tablename']."` ";
		$sql .= " WHERE " . $params['idfield1']  ."= '". $params[$params['idfield1']]."' AND ";
		if($params['many'] == '0')
			$sql .= $params['idfield2']  ."= '". $params[$params['idfield2']]."'";
		else
			$sql .= $params['idfield2']  ." IN ". $params[$params['idfield2']]; //comma delimited list
	}
	else {
		die("No id or tablename Provided.");
	}	
	//die($sql);
	
	// get the results
	if ($result = queryDatabase($sql)) 
		sendSuccess();
	else
		die("Query Failed:" . mysql_error());

	// return the results
	return $result;
}
function deleteContent($params)
{
	if(isset($params['id']))
	{
		$sql = "DELETE content, content_media, content_users, content_content, content_terms,content_customfields
		FROM content 
		LEFT JOIN content_media   		ON content_media.contentid = content.id
		LEFT JOIN content_users			ON content_users. contentid = content.id
		LEFT JOIN content_content		ON content_content. contentid = content.id
		LEFT JOIN content_terms   		ON content_terms. contentid = content.id
		LEFT JOIN content_customfields	ON content_customfields. contentid = content.id
		WHERE content.id = '" . $params['id'] . "'";		
	}
	else {
	
		die("No id or tablename Provided.");
	
	}	

	if ($result = queryDatabase($sql)) 
		sendSuccess();
	else
		die("Query Failed:" . mysql_error());

	// return the results
	return $result;	
}
function updateRecords($params) // A GENERAL-USE DELETE FUNCTION
{
	/*
		
		** REQUIRED PARAMS
			tablename - name of the table to delete.
			idfield - name of the multiple id field
			updatefield - name of the field to update
			updateValue - name of the value
			id -  expects formatted id string (id,id,id).
		
	*/
	$validParams = array("action","idvalues","tablename","idfield","updatefield","updatevalue");
	//action=updateRecords & tablename=comments & updatefield=statusid & updatevalue=4  & ifdield=id & idvalues=1,2,3,4
	if (isset($params['idvalues']) && isset($params['tablename']) && isset($params['idfield']) && isset($params['updatefield']) && isset($params['updatevalue'])) 
	{ // make sure we have a content id and tablename.
	
		$sql = "UPDATE `".$params['tablename']."` SET ";
		$sql .= $params['updatefield'] . " = '". $params['updatevalue'] ."'";
		$sql .= " WHERE ". $params['idfield']. " IN " .$params['idvalues']. "";
	
	} else {
		die("No id or tablename Provided.");
	
	}	
	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{
			$sql .= " AND " . $key . " = '".$value."'";
		}
	}
	// get the results
	if ($result = queryDatabase($sql)) 
		sendSuccess();
	else
		die("Query Failed:" . mysql_error());

	// return the results
	return $result;
}
function deleteRecords($params) // A GENERAL-USE DELETE FUNCTION
{
	/*
		
		** REQUIRED PARAMS
			tablename - name of the table to delete.
			idfield - name of the multiple id field
			id -  expects formatted id string (id,id,id).
		
	*/
	$validParams = array("action","idvalues","tablename","idfield");
	if (isset($params['idvalues']) && isset($params['tablename']) && isset($params['idfield']) ) 
	{ // make sure we have a content id and tablename.
	
		$sql = "DELETE FROM `".$params['tablename']."` ";
	
		$sql .= " WHERE ". $params['idfield']. " IN " .$params['idvalues']. "";
	
	} else {
	
		die("No id or tablename Provided.");
	
	}	
	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{
			$sql .= " AND " . $key . " = '".$value."'";
		}
	}
	// get the results
	if ($result = queryDatabase($sql)) 
		sendSuccess();
	else
		die("Query Failed:" . mysql_error());

	// return the results
	return $result;
}
function deleteTag($params)
{
	if(isset($params['id']))
	{
		$sql = "DELETE FROM `term_taxonomy` WHERE id='" . $params['id'] . "'";
		if($result = queryDatabase($sql))
		{
			$sql = "DELETE FROM `content_terms` WHERE termid='" . $params['id'] . "'";
			if($result = queryDatabase($sql))
				sendSuccess();
			else
				die("Query Failed:" . mysql_error());
			
		}
		else
			die("Query Failed:" . mysql_error());
	}
	else
		die ("No id provided");
	return $result;
}	
function deleteRelatedRecords($params)
{
	/*
		
		** REQUIRED PARAMS
			tablename - name of the table to delete.
			some parameter
		
	*/
	
	if (isset($params['tablename'])) { // make sure we have a content id and tablename.
	
		$sql = "DELETE FROM `".$params['tablename']."` ";
		$sql2 = "UPDATE `".$params['tablename']."` ";
		if($params['tablename'] == "content_media")
		{
			$sql .= " WHERE usage_type!='thumb' AND mediaid = '" . $params['mediaid'] . "'";
			$sql2 .= " SET mediaid='0' WHERE usage_type='thumb' AND mediaid = '" . $params['mediaid'] . "'";
		}
		else if($params["tablename"] == "content_tags")
		{
			$sql .= " WHERE tagid = '" . $params['tagid'] . "'";
		}
		else if($params["tablename"] == "media_terms")
		{
			$sql .= " WHERE mediaid = '" . $params['mediaid'] . "'";
		}		
		else if($params['tablename'] == "user_usercategories")
		{
			$sql .= " WHERE " .$params['fieldname']. " = '" . $params['fieldvalue'] . "'";
		}
		else
		{
			die("This is crazy shit that would have deleted everything!");
		}
	}
	else 
	{
		die("No id or tablename Provided.");
	}
	
	// get the results
	if ($result = queryDatabase($sql)) 
	{
		if($result2 =  queryDatabase($sql2)) 
			sendSuccess();
		else
			die("Query Failed:" . mysql_error());
	}
	else
		die("Query Failed:" . mysql_error());

	// return the results
	return $result;	
}
function updateRelatedRecords($params)
{
	/*
		** REQUIRED PARAMS
			tablename - name of the table to delete.
			some parameter	
	*/
	if ( isset($params['tablename']) && isset($params['setField']) && isset($params['setValue']) 
		&& isset($params['paramField']) && isset($params['paramValue'])) 
	{ // make sure we have a   and tablename.
	
		$sql = "UPDATE  `".$params['tablename']."` ";
		$sql .= "SET " . $params['setField'] .  " = '" . processText($params['setValue']) . "'";
		$sql .= " WHERE ". $params['paramField'] . " = '" . $params['paramValue'] . "'";		
	}
	else 
	{
		die("This is crazy shit that would have modified everything!");
	}
	// get the results
	if ($result = queryDatabase($sql)) 
		sendSuccess();
	else
		die("Query Failed:" . mysql_error());

	// return the results
	return $result;	
}
function associateTags($tablename,$id,$tags) {

	// put tags into an array!
	$arrTags = explode(",",$tags);
	
	// clean tags. get rid of spaces on either side, make lowercase.
	
	foreach ($arrTags as $key=>$tag) {
	
		$arrTags[$key] = array("tag"=>trim($tag));
		
	}
	
	// now lets check if they are already in the DB
	
	foreach ($arrTags as $key=>$arrTag) {
	
		$sql = "SELECT id FROM `terms` WHERE name = '".$arrTag['tag']."'";
		$result = queryDatabase($sql);
		
		if (mysql_num_rows($result) > 0) { // tag is in db, put id into arrTags
		
			$row = mysql_fetch_array($result);
			$arrTags[$key]['tagid'] = $row['id'];
		
		} else { // tag is not in db, insert it!
		
			$name = $arrTag['tag'];
			$slug = strtolower(trim($name));
			$slug = preg_replace('/[^a-z0-9-]/', '-', $slug);
			$slug = preg_replace('/-+/', "-", $slug);
			$slug = strtolower($slug);
			$sql = "INSERT INTO `terms` (name,slug) VALUES ('".$arrTag['tag']."','" . $slug. "')";
			queryDatabase($sql);
			$insertid =  mysql_insert_id();
			$arrTags[$key]['tagid'] = $insertid;
			$sql = "INSERT into `term_taxonomy` (termid,taxonomy) VALUES ('". $insertid. "','tag')";
			queryDatabase($sql);
		}
	
	}
	
	// now lets associate the tags with the record, first delete all associated tags!
	
	$tagsTableName = $tablename . "_tags";
	$idField = $tablename . "id";
	
	$sql = "DELETE FROM $tagsTableName WHERE $idField = '$id'";
	queryDatabase($sql);
	
	foreach ($arrTags as $arrTag) {
	
		$sql = "INSERT INTO $tagsTableName ($idField,tagid) VALUES ('".$id."','".$arrTag['tagid']."')";
		queryDatabase($sql);
	
	}
	
	
	return true;

}
function updateContainerPaths($params) {

	$sql = "SELECT id FROM content";
	
	if (isset($params['id']))
		$sql .=" WHERE id IN (".$params['id'].")";
	
	$result = queryDatabase($sql);
	
	while ($row = mysql_fetch_array($result)) {
	
		// get the tree path to this piece of content!
		
		$sql = "SELECT U2.title AS parent1,U3.title AS parent2,U4.title AS parent3,U5.title AS parent4,U6.title AS parent5,U7.title AS parent6,U8.title AS parent7,U9.title AS parent8,U10.title AS parent9
				FROM content AS U1
				LEFT JOIN content AS U2
					ON U2.id = U1.parentid
				LEFT JOIN content AS U3
					ON U3.id = U2.parentid
				LEFT JOIN content AS U4
					ON U4.id = U3.parentid
				LEFT JOIN content AS U5
					ON U5.id = U4.parentid
				LEFT JOIN content AS U6
					ON U6.id = U5.parentid
				LEFT JOIN content AS U7
					ON U7.id = U6.parentid
				LEFT JOIN content AS U8
					ON U8.id = U7.parentid
				LEFT JOIN content AS U9
					ON U9.id = U8.parentid
				LEFT JOIN content AS U10
					ON U10.id = U9.parentid
				WHERE U1.id = '".$row['id']."'";
			
		$result2 = queryDatabase($sql);
		$row2 = mysql_fetch_assoc($result2);
		
		$strPath = "";
		$strPath2 = "";
		if (is_array($row2)) {
		
			foreach ($row2 as $contName) {
			
				if ($contName)
				{
					$strPath = $contName . "," . $strPath;
					$strPath2 = $contName . "<>" . $strPath2;
				}
			}
			
			// remove last comma!
			$strPath = substr($strPath,0,strlen($strPath)-1);
			$strPath2 = substr($strPath2,0,strlen($strPath2)-2);
			if ($strPath)
			{
				$sql = "UPDATE content SET containerpath = '" . $strPath2 . "' WHERE id = '".$row['id']."'";
				//die($sql);
				queryDatabase($sql);
			}
			
			
		}
	
	}
	return $strPath2;
	//if($ret)
	//	sendSuccess();

}

function createFont($params) // A GENERAL-USE INSERT FUNCTION
{
	//./3.0.0.477/bin/mxmlc AkkuratRegular.as -output=fonts/Akkurat/AkkuratRegular.swf
	if (!isset($params['classname']) || !isset($params['ttf'])) 
	{
	     die("font name or file not specified .");
	}
	$class = $params['classname'];
	$ttf = $params['ttf'];
	
	$fh = fopen($class.'.as', 'w');
	$stringData = '
	package
	{
		import flash.display.Sprite;	
		import flash.text.Font;
		public class ' . $class . ' extends Sprite 
		{
			public static var FONTNAME_NORMAL:String = "' . $class . '";		
			public function '.  $class . ' ()
			{
			    Font.registerFont(font);
			}
			public function get fontName_Normal():String
			{
				return FONTNAME_NORMAL;
			}
			[Embed(source="../'. $ttf . '", fontName=" '. $class .'")] public static var font:Class;
		}
	}';
	fwrite($fh, $stringData);
	fclose($fh);
	///Compile the file!
	$command = "../3.0.0.477/bin/mxmlc " . $class . ".as -output=../" . substr($ttf,0,-3) . "swf";
	$output = shell_exec($command);
	//remove AS file
	unlink($class.".as");	
	sendSuccess();
}
//$old_error_handler = set_error_handler("userErrorHandler");
function insertRelatedRecords($params) // A GENERAL-USE INSERT FUNCTION
{
	/*
		
		** REQUIRED PARAMS
			tablename - name of the table to update.
			singlefield
			singlevalue
			manyfield
			manyvalue
	*/	
	if (isset($params['tablename']))
	{ // make sure we have a content id and tablename.
	

		$sql = "INSERT INTO `".$params['tablename']."` ";
		
		// put field names into SQL
		
		$sql .= "(";
//		foreach ($params as $key=>$value)
//		{	
//			if ($key != 'action' && $key != 'tablename' && $key != 'tags' && $key != 'verbose' && 
//				$key != "singlevalue" && $key != "manyvalue") 
//			{
//			
//				$sql .= $value . ",";	
//			}	
//		}		
		// remove last comma
		//$sql = substr($sql,0,strlen($sql)-1);	
		
		$sql .= $params['singlefield'] . ",";
		$sql .= $params['manyfield'];		
		$sql .= ")";

		
		// put values into SQL
		
		$sql .= " VALUES ";
		$manyvalues = split(',',$params['manyvalue']);
		foreach($manyvalues as $value )
		{
			$sql .= ' (' . $params['singlevalue'] . ', ' . $value . ' ), ';	
		}
		$sql = substr($sql,0,strlen($sql)-2);
		if ($result = queryDatabase($sql)) {
			sendSuccess();
		}
		else
			die("Query Failed:" . mysql_error());
	}	
}
function ZipFolder($params) // this is what gets called from flash  
{  
	// include the library from http://www.phpconcept.net/pclzip/index.en.php  
    // create a unique file name.. this is prepended with manewc.com-  
	$uniqueFileName = uniqid($params["prefix"]);  
  
        // create the zip  
	$archive = new PclZip('../temporary/'.$uniqueFileName.'.zip');  
	$fileArr = explode(",",$params["files"]);
   	$v_list = $archive->create($fileArr);  
  
    if ($v_list == 0)
    {   
        die("Error : ".$archive->errorInfo(true));  
    }  
    else  
    {  
        sendSuccess($uniqueFileName.'.zip');
    }    
} 
function slug($str)
{
	$str = strtolower(trim($str));
	$str = preg_replace('/[^a-z0-9-]/', '-', $str);
	$str = preg_replace('/-+/', "-", $str);
	return $str;
}
function processText($text)
{
	global $htmlSymbols;
	$html = '';
	if($text != 'NULL')
	{
		$list = get_html_translation_table(HTML_ENTITIES);
		unset($list['"']);
		unset($list['<']);
		unset($list['>']);
		unset($list['&']);

		$search = array_keys($list);
		$values = array_values($list);
		$search = array_map('utf8_encode', $search);
		$html = str_replace($search, $values, $text);
	
		$search = array_keys($htmlSymbols);
		//$search = array_map('utf8_encode', $search);
		$values = array_values($htmlSymbols);
		$html = str_replace($search, $values, $html);	
		//var_dump($text, $html);
		return $html;
	}
	else
		return '';
}
function processSlug($text)
{
	$chars = array('Š','Œ','Ž','š','œ','ž','Ÿ','¥','µ','À','Á','Â','Ã','Ä','Å','Æ','Ç','È','É','Ê','Ë','Ì','Í','Î','Ï',
			       'Ð','Ñ','Ò','Ó','Ô','Õ','Ö','Ø','Ù','Ú','Û','Ü','Ý','ß','à','á','â','ã','ä','å','æ','ç','è','é','ê','ë',
				   'ì','í','î','ï','ð','ñ','ò','ó','ô','õ','ö','ø','ù','ú','û','ü','ý','ÿ');
	$base = array('S','O','Z','s','o','z','Y','Y','u','A','A','A','A','A','A','A','C','E','E','E','E','I','I','I','I',
										 'D','N','O','O','O','O','O','O','U','U','U','U','Y','s','a','a','a','a','a','a','a','c','e','e','e','e',
										 'i','i','i','i','o','n','o','o','o','o','o','o','u','u','u','u','y','y');				   
	$accents = array();
	$i=0;
	foreach($chars as $c)
	{
		$element = array(processText($c) => $base[$i]);
		$accents = array_merge($accents,$element);
		$i++;
	}								 
	return strtr(processText($text),$accents);
}
function duplicateContent($params)
{
	if(isset($params['id']))
	{
		$sql = "SELECT content.* from `content` WHERE id='" . $params['id'] . "'";
		$result = queryDatabase($sql);
		$row = mysql_fetch_assoc($result);
		$sql = "INSERT INTO `content` ";
		
		// put field names into SQL
		$sql .= "(";
		
		foreach ($row as $key=>$value) 
		{
			if($key != 'id')
				$sql .= $key . ",";	
		}		
		// remove last comma
		$sql = substr($sql,0,strlen($sql)-1);
		$sql .= ")";
		
		// put values into SQL
		$sql .= " VALUES (";
		
		foreach ($row as $key=>$value) 
		{
			if($key != 'id')
				$sql .= "'".addslashes($value)."',";
		}	
		$sql = substr($sql,0,strlen($sql)-1);
		$sql .=")";
		if ($result = queryDatabase($sql)) {
			$insertid = mysql_insert_id();	
			
			//duplicate relationships

			duplicateRows('content_media','contentid',$params['id'],$insertid);
			duplicateRows('content_content','contentid',$params['id'],$insertid);
			duplicateRows('content_users','contentid',$params['id'],$insertid);
			duplicateRows('content_terms','contentid',$params['id'],$insertid);
			duplicateRows('comments','contentid',$params['id'],$insertid);
			$params2['verbosity'] = 1;
			$params2['contentid'] = $insertid;
			$params2['action'] = 'getContent';
			$result = getContent($params2);		
			return $result;	
		}	
	}	
	else die("Content id is not set");	
}
function duplicateRows($tablename,$idField,$idValue,$insertId)
{
	$sql = "SELECT * from `". $tablename . "` WHERE ". $idField . "='" . $idValue . "'";
	$result = queryDatabase($sql);
	while ($row = mysql_fetch_assoc($result)) 
	{
			$sql = "INSERT INTO `". $tablename . "`";
			
			// put field names into SQL
			$sql .= "(";
			
			foreach ($row as $key=>$value) 
			{
				if($key != 'id')
					$sql .= $key . ",";	
			}		
			// remove last comma
			$sql = substr($sql,0,strlen($sql)-1);
			$sql .= ")";
			
			// put values into SQL
			$sql .= " VALUES (";
			
			foreach ($row as $key=>$value) 
			{
				if($key != 'id')
				{
					if($key == $idField)
						$sql .= "'".$insertId."',";
					else
						$sql .= "'".addslashes($value)."',";
				}
					
			}	
			$sql = substr($sql,0,strlen($sql)-1);
			$sql .=")";		
			queryDatabase($sql);		
	}
}
?>