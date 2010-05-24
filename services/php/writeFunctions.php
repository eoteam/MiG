<?php


require_once "readFunctions.php";

function updateTag($params)
{
	/*
		* Script will attempt to update tags at tables 'terms' and 'term_taxonomy'
		* You will get an error if you provided invalid field names.

		** REQUIRED PARAMS
		id - primary key of the record to update at 'term_taxonomy'
		termid -

		** OTHER PARAMS
		* name/value pairs to update:
		- parentid
		- description
		- color
		- date1
		- date2
		- displyorder
		*/

	// gets arrays of field names for tables 'terms' and 'term_taxonomy'
	$columnsTermsArray = getTableColumns('terms');
	$columnsTermTaxArray = getTableColumns('term_taxonomy');

	if(isset($params['id']) && isset($params['termid']))
	{
		$sendParams = array();
		$sql = "UPDATE `term_taxonomy` SET ";
		foreach ($params as $key=>$value)
		{
			if ($key != 'action' && $key != 'id' && $key != 'name' && $key != 'slug')
			{
				if (in_array($key, $columnsTermTaxArray)) // checks for misspelling of field name
				{
					$sql .= $key . " = :".$key.", ";
					$sendParams[$key] = processText($value);
				}
				else die("Unknown field name '$key'.");
			}
		}
		// remove last comma and space!
		$sql = substr($sql,0,strlen($sql)-2);
		$sql .= " WHERE id = :id";
		$sendParams['id'] = $params['id'];

		if($result = queryDatabase($sql, $sendParams))
		{
			if (in_array('name', $columnsTermsArray) && in_array('slug', $columnsTermsArray)) // checks for misspelling of field name
			{
				$sendParams = array();
				$sql  = " UPDATE `terms` SET";
				$sql .= " name = :name ,";
				$sql .= " slug = :slug";
				$sql .= " WHERE id = :termid";
				$sendParams['name'] = processText($params['name']);
				$sendParams['slug'] = processSlug($params['slug']);
				$sendParams['termid'] = $params['termid'];

				if($result = queryDatabase($sql, $sendParams)) {
					sendSuccess();
				}
				else die("Query Failed:" . $result->errorInfo());
			} else die("Unknown field name.");
		}
		else die("Query Failed:" . $result->errorInfo());
	}
	else die("No tag id is provided.");
}

function updateRecord($params)
{
	/*
		* Script will attempt to update multiple fields (name/value pairs) of one record by id.
		* You will get an error if you provided invalid field names.

		** REQUIRED PARAMS
		tablename - name of the table to update
		id - primary key of the record to update
		name/value pairs to update

		** OTHER PARAMS
		* tags - if found, this will attempt to add tags if they don't already exist in the system, otherwise it will tie tags to the content or media being inserted.
		* if a param is sent called 'password' it will automatically be encrypted.

		*/

	$numParamsToUpdate = 0; // counts num of params to update.
	$sendParams = array();

	// make sure we have a content id and tablename
	if (isset($params['id']) && isset($params['tablename'])) {

		// gets array of fields name for 'tablename'
		$columnsArray = getTableColumns($params['tablename']);
			
		$sql = "UPDATE `".$params['tablename']."` SET ";
		foreach ($params as $key=>$value) {

			if ($key != 'action' && $key != 'id' && $key != 'tablename' && $key != 'tags' && $key != 'verbosity') {
				$numParamsToUpdate++;
					
				if (in_array($key, $columnsArray)) // checks for misspelling of field name
				{
					if ($key == 'password') {
						$sql .= $key . " = :".$key.", ";
						$sendParams[$key] = text_crypt($value);
					}
					else {
						$sql .= $key . " = :".$key.", ";
						$sendParams[$key] = processText($value);
					}
				} else die("Unknown field name '$key'.");
			}
		}

		if ($numParamsToUpdate==0) { //no other name/value pairs provided
			die("No name/value pairs provided to update.");
		}
		else {
			// remove last comma and space!
			$sql = substr($sql,0,strlen($sql)-2);

			$sql .= " WHERE id = :id";
			$sendParams['id'] = $params['id'];
		}

	} else {
		die("No id or tablename provided.");
	}

	// get the results
	if ($numParamsToUpdate > 0)
		$result = queryDatabase($sql, $sendParams);

/*	
	if (isset($params['tags']))
	associateTags($params['tablename'],$params['id'],$params['tags']);
*/
		
	if ($params['tablename'] == "content")
	updateContainerPaths(null);

	if (isset($params['verbosity']))
	{
		$params2['verbosity'] = $params['verbosity'];
		$params2['contentid'] = $params['id'];
		$result = getContent($params2);

		// output the serialized xml
		return $result;
	}
	else
	{
		sendSuccess();
	}
}

function updateRecords($params)
{
	/*
		* Script will attempt to update one field (updatefield/updatevalue) of multiple records by idfield/idvalues (comma-delimited) and other name/value ($key=>$value) parameters.
		* You will get an error if you provided invalid field names.

		** REQUIRED PARAMS
		tablename - name of the table to update
		updatefield - name of the field to update
		updatevalue - value of the field to update
		idfield - name of the parameter to specify records
		idvalues - values of idfield; expects formatted id string (id,id,id)

		** OTHER PARAMS
		* name/value pairs to specify records to update
		*/

	$validParams = array("action","idvalues","tablename","idfield","updatefield","updatevalue");
	/* examples:
	 * action=updateRecords & tablename=comments & updatefield=statusid & updatevalue=4 & idfield=id & idvalues=1,2,3,4
	 * action=updateRecords & tablename=media_terms & updatefield=termid & updatevalue=7 & idfield=contentid & idvalues=4,5 
	 */

	$sendParams = array();

	// gets array of fields name for 'tablename'
	$columnsArray = getTableColumns($params['tablename']);

	// make sure we have a content id and tablename
	if (isset($params['tablename']) && isset($params['idfield']) && isset($params['idvalues']) && isset($params['updatefield']) && isset($params['updatevalue'])) {
		$sql = "UPDATE `".$params['tablename']."` SET ";

		if (in_array($params['updatefield'], $columnsArray)) // checks for misspelling of field name
		$sql .= $params['updatefield']." = :updatevalue ";
		else die("Unknown field name '".$params['updatefield']."'.");

		if (in_array($params['idfield'], $columnsArray)) // checks for misspelling of field name
		$sql .= " WHERE ".$params['idfield']." IN ( ";
		else die("Unknown field name '".$params['idfield']."'.");
			
		// $params['idvalues'] can be comma-delimited
		$manyvalues = explode(",",$params['idvalues']);
		foreach($manyvalues as $value)
		{
			$sql .= " :singlevalue".$value.", ";
			$sendParams['singlevalue'.$value] = $value;
		}
		$sql = substr($sql,0,strlen($sql)-2); //remove last comma and space
			
		$sql .= " )";
		$sendParams['updatevalue'] = $params['updatevalue'];
	} else {
		die("No tablename or idfield/idvalue or updatefield/updatevalue parameters provided.");
	}

	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams) && (in_array($key,$columnsArray)))
		{
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		} else die("Unknown field name '$key'.");
	}

	// get the results
	if ($result = queryDatabase($sql, $sendParams))
	sendSuccess();
	else
	die("Query Failed:" . $result->errorInfo());

	// return the results
	return $result;
}
function updateContainerPaths($params, $insertid) {

	$sql = "SELECT id FROM content";
	$sendParams = array();

	if (isset($params['id'])) {
		$sql .= " WHERE id IN ( ";
		
		// $params['id'] can be comma-delimited
		$manyvalues = explode(",",$params['id']);
		foreach($manyvalues as $value)
		{
			$sql .= " :singlevalue".$value.", ";
			$sendParams['singlevalue'.$value] = $value;
		}
		$sql = substr($sql,0,strlen($sql)-2); //remove last comma and space
		$sql .= " )";
	} else $sql .= " WHERE id IN ($insertid)";

	$result = queryDatabase($sql, $sendParams);

	while ($row = $result->fetch(PDO::FETCH_ASSOC)) {

		// get the tree path to this piece of content!

		$sql = "SELECT U2.migtitle AS parent1,U3.migtitle AS parent2,U4.migtitle AS parent3,U5.migtitle AS parent4,U6.migtitle AS parent5,U7.migtitle AS parent6,U8.migtitle AS parent7,U9.migtitle AS parent8,U10.migtitle AS parent9
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
		$row2 = $result2->fetch(PDO::FETCH_ASSOC);

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
				queryDatabase($sql);
			}
		}
	}
	return $strPath2;
}

function insertTag($params)
{
	/*
		* Script will attempt to insert tag to 'terms' and then to 'term_taxonomy'
		* You will get an error if you provided invalid field names.

		** REQUIRED PARAMS
		name - tag name
		slug - slug of the tag
			
		** OTHER PARAMS
		taxonomy - 'tag' or 'category'; if taxonomy is not provided then it is 'tag ' 
		name/value pairs to set parameters for the tag :
		- parentid (optional) - if doesn't exist then parentid=id
		- description
		- color
		- date1
		- date2
		- displyorder

		*/

	// gets array of field names for 'tablename'
	$columnsArray = getTableColumns('term_taxonomy');

	if (isset($params['taxonomy'])) {
		$sendParams = array();
		$sql = "INSERT INTO `terms` (name,slug) VALUES (:name,:slug)";
		$sendParams['name'] = processText($params['name']);
		$sendParams['slug'] = processText($params['slug']);
		if ($result = queryDatabase($sql,$sendParams,$insertid))
		{
			$sendParams = array();
			$sql = "INSERT into `term_taxonomy` (id,parentid,termid,";
			foreach ($params as $key=>$value) {
				if ($key != 'action' && $key != 'name' && $key != 'slug' && $key != 'parentid') {
					if (in_array($key, $columnsArray)) { // checks for misspelling of field name
						$sql .= $key.",";
					}
					else die ("Unknown field name '$key'.");
				}
			}

			// remove last comma
			$sql = substr($sql,0,strlen($sql)-1);
			$sql .= ")";

			// put values into SQL
			$sql .= " VALUES (";

			// get next auto increment in 'term_taxonomy'
			$sql2 = "SELECT Auto_increment FROM information_schema.tables WHERE table_name='term_taxonomy' AND table_schema='".DB_NAME."'";
			$result2 = queryDatabase($sql2);
			$row2 = $result2->fetch(PDO::FETCH_ASSOC);

			$sql .= "'".$row2['Auto_increment']."',"; //id

			$autoIncrement = $row2['Auto_increment'];

			if (isset($params['parentid'])) { // parentid is set
				$sql .= "'".$params['parentid']."',"; // parentid
			}
			else {
				// if parent id is not set then parentid = id
				$sql .= "'".$row2['Auto_increment']."',"; // set the same parent_id as the auto_incremented id
			}

			$sql .=  "'".$insertid."',"; // termid

			foreach ($params as $key=>$value) {
				if ($key != 'action' && $key !='name' && $key != 'slug') {
					$sql .= ":".$key.",";
					$sendParams[$key] = processText($value);
				}
			}

			// remove last comma
			$sql = substr($sql,0,strlen($sql)-1);
			$sql .=")";

			// $autoIncrement should be equal to $insertid2
			if($result = queryDatabase($sql,$sendParams,$insertid2))
			{
				$sql = "SELECT term_taxonomy.*,terms.slug,terms.name FROM `term_taxonomy` " .
				   "LEFT JOIN terms ON terms.id = term_taxonomy.termid WHERE term_taxonomy.id = '".$insertid2."'";
				$result = queryDatabase($sql);
				return $result;
			}
			else die("Query Failed:" . $result->errorInfo());
		}
	}
	else die("No taxonomy provided.");
}
function updateMediaByPath($params)
{
	if (isset($params['oldpath']) && isset($params['newpath'])) {
	
		$sql = "UPDATE `media` ";
		$sql .= " WHERE `path` = REPLACE(`path`," . $params['oldpath'] . "," . $params['newpath'] . ")";
	} 
	else {
		die("missing path parameters");
	}	
	//die($sql);

	// get the results
	if ($result = queryDatabase($sql)) 
		sendSuccess();
	else
		die("Query Failed:" . mysql_error());

}
function insertRecord($params)
{
	/*
		* Script will attempt to insert a record with all other name/value pairs provided
		* You will get an error if you provided invalid field names.

		** REQUIRED PARAMS
		tablename - name of the table to insert the record in
		name/value pairs to set parameters for the record

		** OTHER PARAMS
		if a param is sent called 'password' it will automatically be encrypted.
		*/

	// gets array of fields name for 'tablename'
	$columnsArray = getTableColumns($params['tablename']);
	$sendParams = array();

	// make sure we have a tablename
	if (isset($params['tablename'])) {
		$sql = "INSERT INTO `".$params['tablename']."` ";
		$sql .= "(";

		foreach ($params as $key=>$value) {
			if ($key != 'action' && $key != 'tablename' && $key != 'tags' && $key != 'verbose') {

				if (in_array($key, $columnsArray)) // checks for misspelling of field name
				$sql .= $key . ",";
				else die("Unknown field name '$key'.");
			}
		}

		// remove last comma
		$sql = substr($sql,0,strlen($sql)-1);
		$sql .= ")";

		// put values into SQL
		$sql .= " VALUES (";

		foreach ($params as $key=>$value) {
			if ($key != 'action' && $key != 'tablename' && $key != 'tags' && $key != 'verbose') {

				if ($key == 'password') {
					$sql .= ":".$key.",";
					$sendParams[$key] = text_crypt($value);
				}
				else {
					$sql .= ":".$key.",";
					$sendParams[$key] = processText($value);
				}
			}
		}

		// remove last comma
		$sql = substr($sql,0,strlen($sql)-1);
		$sql .=")";

	} else die("No tablename provided.");

	// get the results
	if ($result = queryDatabase($sql,$sendParams,$insertid)) {

		/*
		 if (isset($params['tags']))
			associateTags($params['tablename'],$insertid,$params['tags']);
			*/

		if($params['tablename'] == 'content')
		{
			$tokens = updateContainerPaths($params, $insertid);
			$urlPath = '';
			$arr = explode('<>',$tokens);
			foreach($arr as $t)
			{
				$urlPath .= generateSlug($t) . '/';
			}

			if(!isset($params['containerpath'])) {
				$sendParams = array();
				$urlPath .= generateSlug($params['migtitle']); //assuming insertinga content record always goes with the title being set. which is true
				$sql = "UPDATE content SET containerpath=:containerpath WHERE id='" . $insertid . "'";
				$sendParams['containerpath'] = $urlPath;
				queryDatabase($sql,$sendParams);
			}
		}

		if (isset($params['verbose']))
		{
			if($params['verbose'] == 'true')
			$sql = "SELECT * FROM `".$params['tablename']."`  WHERE id = '".$insertid."'";
			else $sql = "SELECT id FROM `".$params['tablename']."`  WHERE id = '".$insertid."'";
		}
		else $sql = "SELECT id FROM `".$params['tablename']."`  WHERE id = '".$insertid."'";

		if ($result = queryDatabase($sql))
		return $result;
		else die("Query Failed: " . $result->errorInfo());
	}
	else die("Query Failed: " . $result->errorInfo());

	return $result;
}

// 
function insertRecordWithRelatedTag($params)
{
	/*
		* Script will attempt to insert a record with related tags
		* You will get an error if you provided invalid field names.

		** REQUIRED PARAMS
		tablename - name of the table /'content' or 'media'/
		name/value pairs to set parameters for the record
		tags - comma-delimited list of related tags -> if found, this will attempt to add tags if they don't already exist in the system, otherwise it will tie tags to the content or media being inserted.

		** OTHER PARAMS
		*/

	if (isset($params['tablename']) && isset($params['tags'])) {

		// get auto increment in 'tablename'
		$sql = "SELECT Auto_increment FROM information_schema.tables WHERE table_name='".$params['tablename']."' AND table_schema='".DB_NAME."'";

		$result = queryDatabase($sql);
		$row = $result->fetch(PDO::FETCH_ASSOC);
		$autoIncrement = $row['Auto_increment'];

		// insert record to 'tablename'
		if($result = insertRecord($params)) {
			// relate tags using auto increment
			associateTags($params['tablename'],$autoIncrement,$params['tags']);
		} else die ("Insert Record Failed: " . $result->errorInfo());
	}
	else die("No tablename or tags provided.");

	return $result;
}

// +
function deleteTag($params)
{
	/*
		* Script will attempt to delete tag from 'term_taxonomy' and then from the tables 'content' and 'media'

		** REQUIRED PARAMS
		id - primary key of the record at table 'term_taxonomy' to delete 

		*/

	if(isset($params['id']))
	{
		$sendParams = array();
		$sql = "DELETE FROM `term_taxonomy` WHERE id = :id ";
		$sendParams['id'] = $params['id'];

		if($result = queryDatabase($sql,$sendParams))
		{
			// delete from 'content'
			$sql = "DELETE FROM `content_terms` WHERE termid = :id ";
			if($result = queryDatabase($sql,$sendParams)) {
				sendSuccess();
			}
			else die("Query Failed:" . $result->errorInfo());
			
			// delete from 'media'
			$sql = "DELETE FROM `media_terms` WHERE termid = :id ";
			if($result = queryDatabase($sql,$sendParams)) {
				sendSuccess();
			}
			else die("Query Failed:" . $result->errorInfo());
		}
		else die("Query Failed:" . $result->errorInfo());
	}
	else die ("No id provided.");

	return $result;
}

// +
function deleteRecord($params)
{
	/*
		* Script will attempt to delete one record by id.

		** REQUIRED PARAMS
		tablename - name of the table to delete
		id - primary key of the record to delete

		*/

	// make sure we have a content id and tablename
	if (isset($params['tablename']) && isset($params['id'])) {
		$sendParams = array();
		$sql = "DELETE FROM `".$params['tablename']."` ";
		$sql .= " WHERE id = :id";
		$sendParams['id'] = $params['id'];
	}
	else die("No tablename or id provided.");

	// get the results
	if ($result = queryDatabase($sql,$sendParams)) {
		sendSuccess();	
	}
	else die("Query Failed:" . $result->errorInfo());

	// return the results
	return $result;
}
function deleteMediaByPath($params) // 
{
	if (isset($params['path'])) {
	
		$sql = "DELETE FROM `media` ";
		$sql .= " WHERE path LIKE '%".$params['path']. "%'";
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
// +
function deleteRecords($params)
{
	/*
		* Script will attempt to delete multiple records by idfield/idvalues (comma-delimited) and other name/value parameters.
		* You will get an error if you provided invalid field names.

		** REQUIRED PARAMS
		tablename - name of the table to delete
		idfield - name of the parameter to specify records to delete
		idvalues - values of idfield; expects formatted id string (id,id,id).

		** OTHER PARAMS
		* name/value pairs to specify records to delete

		*/

	$validParams = array("action","idvalues","tablename","idfield");
	$sendParams = array();

	// gets array of fields name for 'tablename'
	$columnsArray = getTableColumns($params['tablename']);

	// make sure we have a content id and tablename
	if (isset($params['idvalues']) && isset($params['tablename']) && isset($params['idfield'])) {
		$sql = "DELETE FROM `".$params['tablename']."` ";

		if (in_array($params['idfield'], $columnsArray)) { // checks for misspelling of field name
			$sql .= " WHERE ".$params['idfield']." IN ( ";
		}
		else die("Unknown field name '".$params['idfield']."'.");

		$manyvalues = explode(",",$params['idvalues']);
		foreach($manyvalues as $value)
		{
			$sql .= " :singlevalue".$value.", ";
			$sendParams['singlevalue'.$value] = $value;
		}

		$sql = substr($sql,0,strlen($sql)-2); //remove last comma and space
		$sql .= " )";

	} else {
		die("No tablename or id provided.");
	}

	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams) && (in_array($key,$columnsArray)))
		{
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		} else die("Unknown field name '$key'.");
	}

	// get the results
	if ($result = queryDatabase($sql,$sendParams)) {
		sendSuccess();
	}
	else die("Query Failed:" . $result->errorInfo());

	// return the results
	return $result;
}

function deleteContent($params)
{
	/*
		* Script will attempt to delete a record (by content id) from a table 'content'

		** REQUIRED PARAMS
		id - primary key of the record to delete

		*/

	// make sure we have a content id
	if(isset($params['id']))
	{
		// checks whether id is valid or not
		$sendParams = array();
		$sql = "SELECT content.* from `content` WHERE id = :id";
		$sendParams['id'] = $params['id'];

		$result = queryDatabase($sql,$sendParams);
		$row = $result->fetch(PDO::FETCH_ASSOC);

		// valid content id
		if ($row!=null) {
			$sql = "DELETE content, content_media, content_users, content_content, content_terms, content_customfields
			FROM content 
			LEFT JOIN content_media   		ON content_media.contentid = content.id
			LEFT JOIN content_users			ON content_users.contentid = content.id
			LEFT JOIN content_content		ON content_content.contentid = content.id
			LEFT JOIN content_terms   		ON content_terms.contentid = content.id
			LEFT JOIN content_customfields	ON content_customfields.contentid = content.id
			WHERE content.id = :id";
		} else die("Invalid id.");
	}
	else die("Content id is not set.");

	if ($result = queryDatabase($sql,$sendParams)) {
		sendSuccess();	
	}
	else die("Query Failed:" . $result->errorInfo());

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

		$sendParams = array();
		$sql = "SELECT id FROM `terms` WHERE name = :name";
		$sendParams['name'] = $arrTag['tag'];
		$result = queryDatabase($sql, $sendParams);

		if ($result->rowCount() > 0) {
			// tag does exist in 'terms'
			$row = $result->fetch(PDO::FETCH_ASSOC);

			// find the term_taxonomy row that uses it with taxonomy = tag
			$sql = "SELECT id FROM `term_taxonomy` WHERE termid = ".$row['id']." AND taxonomy = 'tag'";
			$result = queryDatabase($sql);
			if ($result->rowCount() > 0) {
				$row = $result->fetch(PDO::FETCH_ASSOC);
				// put term_taxonomy id into arrTags
				//$arrTags[$key]['termid'] = $row['id'];
				$addTags[$key]['termid'] = $row['id'];
			} else {
				// get auto increment in 'term_taxonomy'
				$sql2 = "SELECT Auto_increment FROM information_schema.tables WHERE table_name='term_taxonomy' AND table_schema='".DB_NAME."'";
				$result2 = queryDatabase($sql2);
				$row2 = $result2->fetch(PDO::FETCH_ASSOC);
				$autoIncrement = $row2['Auto_increment'];

				// insert new record into term_taxonomy using insertid(auto increment) and taxonomy=tag
				$sql = "INSERT into `term_taxonomy` (id,parentid,termid,taxonomy) VALUES ('". $autoIncrement. "','". $autoIncrement. "','".$row['id']. "','tag')";
				queryDatabase($sql);

				$addTags[$key]['termid'] = $autoIncrement;
			}
		} else {
			// tag does not exist in 'terms'
			$sendParams = array();
			$name = $arrTag['tag'];
			$slug = strtolower(trim($name));
			$slug = preg_replace('/[^a-z0-9-]/', '-', $slug);
			$slug = preg_replace('/-+/', "-", $slug);
			$slug = strtolower($slug);

			// insert tag into 'terms'
			$sql = "INSERT INTO `terms` (name,slug) VALUES (:name, :slug)";
			$sendParams['name'] = $arrTag['tag'];
			$sendParams['slug'] = $slug;
			queryDatabase($sql, $sendParams, $insertid); // get insertid

			// get auto increment in 'term_taxonomy'
			$sql2 = "SELECT Auto_increment FROM information_schema.tables WHERE table_name='term_taxonomy' AND table_schema='".DB_NAME."'";
			$result2 = queryDatabase($sql2);
			$row2 = $result2->fetch(PDO::FETCH_ASSOC);
			$autoIncrement = $row2['Auto_increment'];

			// insert new record into term_taxonomy using insertid(auto increment) and taxonomy=tag
			$sql = "INSERT into `term_taxonomy` (id,parentid,termid,taxonomy) VALUES ('". $autoIncrement. "','". $autoIncrement. "','". $insertid. "','tag')";
			queryDatabase($sql);

			//$arrTags[$key]['termid'] = $autoIncrement;
			$addTags[$key]['termid'] = $autoIncrement;
		}
	}

	// now lets associate the tags with the record, first delete all associated tags!
	$tagsTableName = $tablename . "_terms"; 	//'content_terms' or 'media_terms'
	$idField = $tablename . "id"; 				//'contentid' or 'mediaid'
	/*
	$sql = "DELETE FROM $tagsTableName WHERE $idField = '$id'";
	queryDatabase($sql);
	*/
	// relate to $tagsTableName using last inserted term_taxonomy id
	foreach ($addTags as $addTag) {
		$sql = "INSERT INTO $tagsTableName ($idField,termid) VALUES ('".$id."','".$addTag['termid']."')";
		queryDatabase($sql);
	}
	return true;
}

function slug($str)
{
	$str = strtolower(trim($str));
	$str = preg_replace('/[^a-z0-9-]/', '-', $str);
	$str = preg_replace('/-+/', "-", $str);
	return $str;
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
	/*
		* Script will attempt to duplicate a record (by content id) at table 'content'

		** REQUIRED PARAMS
		id - primary key of the record to duplicate
		*/

	// make sure we have a content id
	if(isset($params['id']))
	{
		$sendParams = array();
		$sql = "SELECT content.* from `content` WHERE id = :id";
		$sendParams['id'] = $params['id'];
		$result = queryDatabase($sql,$sendParams);
		$row = $result->fetch(PDO::FETCH_ASSOC);

		// valid content id
		if ($row!=null) {

			$sendParams = array();

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
				if($key != 'id') {
					$sql .= ":".$key.",";
					$sendParams[$key] = $value;
				}
			}
			$sql = substr($sql,0,strlen($sql)-1);
			$sql .=")";
			if ($result = queryDatabase($sql,$sendParams,$insertid)) {
					
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
		else die("Invalid id.");
	}
	else die("Content id is not set.");
}

function duplicateRows($tablename,$idField,$idValue,$insertId)
{
	$sendParams = array();
	$sql = "SELECT * from `". $tablename . "` WHERE ". $idField . "= :idvalue ";
	$sendParams['idvalue'] = $idValue;
	$result = queryDatabase($sql,$sendParams);

	while ($row = $result->fetch(PDO::FETCH_ASSOC))
	{
		$sendParams = array();

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
				else {
					$sql .= ":".$key.",";
					$sendParams[$key] = $value;
				}
			}

		}
		$sql = substr($sql,0,strlen($sql)-1);
		$sql .=")";
		queryDatabase($sql,$sendParams);
	}
}
/*
 function updateRelatedRecords($params)
 {
 * Script will attempt to update one field (setfield/setvalue) of multiple records by paramfield/paramvalue parameter. (????)

 ** REQUIRED PARAMS
 tablename - name of the table to update
 setfield - name of the field to update
 setvalue - value of the field to update
 paramfield - name of the parameter to specify records
 paramvalue - value of the paramfield

 $sendParams = array();

 // make sure we have a tablename and parameters
 if ( isset($params['tablename']) && isset($params['setfield']) && isset($params['setvalue']) && isset($params['paramfield']) && isset($params['paramvalue'])) {
 $sql = "UPDATE  `".$params['tablename']."` ";
 $sql .= "SET ".$params['setfield']." = :setvalue ";
 $sql .= " WHERE ".$params['paramfield']." = :paramvalue ";
 $sendParams['setvalue'] = processText($params['setvalue']);
 $sendParams['paramvalue'] = $params['paramvalue'];
 }
 else
 {
 die("No tablename or setfield/setvalue or paramfield/paramvalue parameters provided.");
 }

 // get the results
 if ($result = queryDatabase($sql,$sendParams))
 sendSuccess();
 else
 die("Query Failed:" . $result->errorInfo());

 // return the results
 return $result;
 }

 function insertRelatedRecords($params) // A GENERAL-USE INSERT FUNCTION
 {

 ** REQUIRED PARAMS
 tablename - name of the table to update.
 singlefield
 singlevalue
 manyfield
 manyvalue

 if (isset($params['tablename']))
 { // make sure we have a content id and tablename.

 $sendParams = array();
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
 $manyvalues = explode(',',$params['manyvalue']);
 foreach($manyvalues as $value )
 {
 $sql .= " (:singlevalue, :".$value."), ";
 $sendParams['singlevalue'] = $params['singlevalue'];
 $sendParams[$value] = $value;
 }
 $sql = substr($sql,0,strlen($sql)-2);
 if ($result = queryDatabase($sql,$sendParams)) {
 sendSuccess();
 }
 else
 die("Query Failed:" . $result->errorInfo());
 }
 }

 function deleteRelatedRecords($params)
 {
 * Script will attempt to delete  ..

 ** REQUIRED PARAMS
 tablename - name of the table to
 'content_media':
 mediaid -
 'content_terms':
 termid -
 'media_terms':
 mediaid -
 'user_usercategories':
 fieldname -
 fieldvalue -

 ** OTHER PARAMS

 $sendParams = array();
 $sendParams2 = array();

 // make sure we have a tablename
 if (isset($params['tablename'])) {

 $sql = "DELETE FROM `".$params['tablename']."` ";
 $sql2 = "UPDATE `".$params['tablename']."` ";
 if($params['tablename'] == "content_media")
 {
 $sql .= " WHERE usage_type!='thumb' AND mediaid = :mediaid ";
 $sql2 .= " SET mediaid='0' WHERE usage_type='thumb' AND mediaid = :mediaid ";
 $sendParams['mediaid'] = $params['mediaid'];
 $sendParams2['mediaid'] = $params['mediaid'];
 }
 else if($params["tablename"] == "content_terms")
 {
 $sql .= " WHERE termid = :termid ";
 $sendParams['termid'] = $params['termid'];
 }
 else if($params["tablename"] == "media_terms")
 {
 $sql .= " WHERE mediaid = :mediaid ";
 $sendParams['mediaid'] = $params['mediaid'];
 }
 else if($params['tablename'] == "user_usercategories")
 {
 $sql .= " WHERE ".$params['fieldname']." = :fieldvalue ";
 $sendParams['fieldvalue'] = $params['fieldvalue'];
 }
 else
 die("error?!");
 }
 else
 die("No tablename provided.");

 // get the results
 if ($result = queryDatabase($sql,$sendParams))
 {
 if($result2 =  queryDatabase($sql2,$sendParams2))
 sendSuccess();
 else
 die("Query Failed:" . $result2->errorInfo());
 }
 else
 die("Query Failed:" . $result->errorInfo());

 // return the results
 return $result;
 }
 */

?>