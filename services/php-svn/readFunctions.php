<?php

function getCustomFields($params) { // general read function

	/*
		-- VALID PARAMS --
		-- REQUIRED --

		contentid (int) - what contentid are we getting fields for? - CANNOT BE COMMA-DELIMITED!
		*/

	if (isset($params['contentid'])) {
	
		$arrCF = array();
	
		$sql = "SELECT template_customfields.customfieldid,'template' as cftype,customfields.name,customfields.displayname, '' as value, customfieldtypes.type, template_customfields.displayorder
				FROM content 
				LEFT JOIN template_customfields ON template_customfields.templateid = content.templateid
				LEFT JOIN customfields ON customfields.id = template_customfields.customfieldid
				LEFT JOIN customfieldtypes ON customfieldtypes.id = customfields.typeid
				WHERE content.id = '".$params['contentid']."' AND template_customfields.customfieldid IS NOT NULL";
				if(!isset($params['include_all']))
					$sql .= " AND customfieldtypes.type != 'special' ";			
				$sql .= " UNION ALL
				SELECT content_customfields.id AS customfieldid, 'content' as cftype, content_customfields.name,content_customfields.displayname, content_customfields.value, customfieldtypes.type, content_customfields.displayorder
				FROM content_customfields
				LEFT JOIN customfieldtypes ON customfieldtypes.id = content_customfields.typeid
				WHERE content_customfields.contentid = '".$params['contentid']."'";

		$result = queryDatabase($sql,$sendParams);

		// put the results into an array

		while ($row = $result->fetch(PDO::FETCH_ASSOC))
		$arrCF[] = $row;
			
		// now we need to get field data for template-based custom fields. this info is stored in the content table (customfield1,2,3,etc...)

		$sendParams = array(); //params to replace placeholders at queryDatabase()
			
		$sql = "SELECT customfield1,customfield2,customfield3,customfield4,customfield5,customfield6,customfield7,customfield8 FROM content WHERE id = :contentid";
		$sendParams['contentid'] = $params['contentid'];
		$result = queryDatabase($sql,$sendParams);

		if ($result->rowCount() > 0) {

			$row = $result->fetch(PDO::FETCH_ASSOC);

			foreach ($arrCF as $key => $CF) {
				if ($CF['cftype'] == 'template')
				$arrCF[$key]['data'] = $row['customfield'.$CF['customfieldid']];
			}
		}

	} else {

		die("contentid is required!");

	}
 	serializeArray($arrCF);
	die();
}

function getData ($params) { // general read function

	/*
		-- VALID PARAMS --
		-- REQUIRED --

		tablename (str) - what table should we read?

		-- OPTIONAL --

		id - return a specific id or comma-delimited list
		orderby - field name to order results by, should be expressed as table.field (e.g. content.title). Can also be comma-delimited list.
		*/

	if (isset($params['tablename'])) {

		$validParams = array("action","tablename","id","orderby","orderdirection");

		$sql = "SELECT `".$params['tablename']."`.*";

		$sql .= " FROM `".$params['tablename']."`";

		$sql .= " WHERE id <> 0 ";

		$sendParams = array(); //params to replace placeholders at queryDatabase()

		if (isset($params['id'])) { // return a specific content id, or a list thereof

			$sql .= " AND id IN (:id)";
			$sendParams['id'] = $params['id'];
		}
		foreach ($params as $key=>$value) {

			if (!in_array($key,$validParams) &&  $key != 'orderdirection') { // this is a custom parameter

				//			if ($key == 'password')
				//				$sql .= " AND " . $key . " = '".text_crypt($value)	."'";
				//			else
				$sql .= " AND " . $key . " = :".$key;
				$sendParams[$key] = $value;

			}

		}

	} else {

		die("tablename is required!");

	}

	// ORDER BY
	if (isset($params['orderby']))
	{
		if(isset($params['orderdirection']))
		{
			$sql .= " ORDER BY ".$params['tablename'].".".$params['orderby']." ".$params['orderdirection'];
		}
		else
		{
			$sql .= " ORDER BY ".$params['tablename'].".".$params['orderby'];
		}
	}
	else
	$sql .= " ORDER BY id ASC";

	// get the results
	$result = queryDatabase($sql,$sendParams);

	// return the results
	return $result;

}

function getUserInfo($params) {

	/*
		-- VALID PARAMS --
		-- ALL ARE OPTIONAL --

		userid (int) - specifies a specific user id to return (can be comma-delimited)
		usergroupid
		orderby - field name to order results by, should be expressed as table.field (e.g. content.title). Can also be comma-delimited list.
		*/

	$validParams = array("action","userid","orderby","usergroupid");

	$sql = "SELECT user.*, usergroups.usergroup, GROUP_CONCAT(perms.id) AS permids, GROUP_CONCAT(perms.perm) AS permissions";

	$sql .= " FROM user
			  LEFT JOIN usergroups ON usergroups.id = user.usergroupid
			  LEFT JOIN usergroup_perms ON usergroup_perms.usergroupid = user.usergroupid
			  LEFT JOIN perms ON perms.id = usergroup_perms.permid";

	$sql .= " WHERE user.id <> 0 ";

	$sendParams = array(); //params to replace placeholders at queryDatabase()

	if (isset($params['userid'])) { // return a specific content id, or a list thereof

		$sql .= " AND user.id IN (:userid)";
		$sendParams['userid'] = $params['userid'];

	}

	if (isset($params['usergroupid'])) { // return a specific content id, or a list thereof

		$sql .= " AND user.usergroupid IN (:usergroupid)";
		$sendParams['usergroupid'] = $params['usergroupid'];

	}

	foreach ($params as $key=>$value) {

		if (!in_array($key,$validParams)) { // this is a custom parameter

			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		}

	}

	// GROUP BY CLAUSE

	$sql .= " GROUP BY user.id";

	// ORDER BY

	if (isset($params['orderby'])) {
		$sql .= " ORDER BY ".$params['orderby'];
	}
	else
	$sql .= " ORDER BY user.id ASC";

	// get the results
	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function getUsers($params) {

	/*
	 -- VALID PARAMS --
	 -- ALL ARE OPTIONAL --

	 userid (int) - specifies a specific user id to return (can be comma-delimited)
	 contentid (int) - specifies a specific content id to return media results for (can be comma-delimited)

	 //tagid (int) - specifies a specific media id to return (can be comma-delimited)
	 //include_unused (1,0) - include media that is not tied to content - defaults to 0 (NO).
	 */
	$sendParams = array();

	$validParams = array("action","userid","contentid","include_unused");

	// define the sql query
	$sql = "SELECT user.* , GROUP_CONCAT(DISTINCT content_users.contentid) AS contentids, GROUP_CONCAT(DISTINCT user_usercategories.categoryid) AS categoryids ";

	$sql .= " FROM user
			  LEFT JOIN content_users ON content_users.userid = user.id
			  LEFT JOIN content ON (content.id = content_users.contentid  AND content.deleted = 0)
			  LEFT JOIN user_usercategories ON user_usercategories.userid = user.id
			  LEFT JOIN usercategories ON usercategories.id = user_usercategories.categoryid";
	// WHERE CLAUSE INFO

	$sql .= " WHERE user.id <> 0 ";

	if (isset($params['userid'])) { // return a specific media id, or a list thereof

		$sql .= " AND userid.id IN (:userid)";
		$sendParams['userid'] = $params['userid'];
	}

	if (isset($params['contentid'])) { // return media for a specific content id, or a list thereof

		$sql .= " AND content_users.contentid IN (:contentid)";
		$sendParams['contentid'] = $params['contentid'];
	}

	//if (!isset($params['include_unused']) || ($params['include_unused'] == 0) ) { // return media for a specific content id, or a list thereof

	//	$sql .= " AND content_users.id IS NOT NULL";

	//}
	// GET ANY EXTRA PARAMS AND APPLY THOSE TO THE WHERE CLAUSE

	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{ // this is a custom parameter
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		}
	}

	$sql .=" GROUP BY user.id";

	// ORDER BY
	$sql .= " ORDER BY user.id ASC";

	// get the results
	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function getContent($params)
{
	/*
		-- VALID PARAMS --
		-- ALL ARE OPTIONAL --

		contentid (int) - specifies a specific content id to return (can be comma-delimited)
		parentid (int) - only return content under this parent id (can be comma-delimited) - This also overrrides contentid!!!
		includechildren (0,1) - only applies when a contentid or parentid is specified, do we return children as well?
		has_tag - comma-delimited list of tags to search for.
		search_terms - search words to search for (comma-delimited). this searches title, description + custom fields.
		search_description - search words to search for in description (comma-delimited).
		search_customfields - words to search for in the custom fields (comma-delimited).
		verbosity - (1 = ids + titles only, 2 - all fields + named custom fields, 3 - all fields).
		orderby - field name to order results by, should be expressed as table.field (e.g. content.title). Can also be comma-delimited list.

		customfield* OR customfieldname (as it appears in DB) will both work for returning content based on custom field data.

		*/

	global $arrVerbosity,$arrCFFlag;

	$validParams = array("action","contentid","include_children","typeid","has_tag","search_terms","thumbUsage",
	"search_description","search_title","search_customfields","verbosity","parentid","orderby","orderdirection","children_depth");


	// first let's grab customfield names, so we can translate!!

	// first get all custom fields!
	$sql = "SELECT * FROM customfields";
	$sql = "SELECT template_customfields.fieldid, customfields.fieldname, customfields.displayname
				FROM template_customfields " .
	 			"LEFT JOIN customfields ON customfields.id = template_customfields.customfieldid";

	$result = queryDatabase($sql);
	$customfields = array();

	if ($result->rowCount() > 0) { // make sure some custom fields exist!

		while ($row = $result->fetch(PDO::FETCH_ASSOC))
		$customfields[$row['fieldid']] = $row['fieldname'];

		// now cycle through all params, and translate to custom field number if we have one
		foreach ($params as $key=>$value) {

			if ($cfKey = array_search($key, $customfields)) {

				$params['customfield'.$cfKey] = $params[$key];
				unset($params[$key]);
					
			}
		}
	}


	if (isset($params['parentid'])) {

		// for this we need to get all contentids which have a particular parentid, and then get all their children!
		$sendParams = array(); //params to replace placeholders at queryDatabase()

		$sql = "SELECT id FROM content WHERE parentid IN (:parentid)";
		$sendParams['parentid'] = $params['parentid'];

		$result = queryDatabase($sql,$sendParams);

		$arrContentIDs = array();

		if ($result->rowCount() > 0) {

			while ($row = $result->fetch(PDO::FETCH_ASSOC)) {

				$arrContentIDs[] = $row['id'];

				/*if (isset($params['include_children']) && ($params['include_children'] == 1))
				 {

					if(isset($params['children_depth']))
					{
					$children_depth = $params['children_depth'];
					}
					$currentChildIDs = getChildren($row['id']);
					$arrContentIDs = array_merge($arrContentIDs,$currentChildIDs);
					}*/
			}
			$params['contentid'] = implode(",", $arrContentIDs);
		}
		else
		{
			$params['contentid'] = "0";
		}
	}

	$sendParams = array(); //params to replace placeholders at queryDatabase()
	$i = 0;
	
	if (isset($params['include_children']) && isset($params['contentid']) && ($params['include_children'] == 1)) { // include_children

		// get childids for all contentids specified
		$contentids = explode(",",$params['contentid']);
		$childids = array();
		foreach ($contentids as $id)
		{
			$currentChildIDs = getChildren($id,$params['children_depth']);
			$childids = array_merge($childids,$currentChildIDs);
		}
		if ($childids) // make sure we actually got some results
		$strChildIDs = implode(",",$childids);
	}


	// SELECT fields according to verbosity

	if (!isset($params['verbosity'])) // set default verbosity
	$params['verbosity'] = 0;


	// BUILD SELECT STATEMENT FROM INFO IN VERBOSITY ARRAY!

	$sql = "SELECT ";

	if (@is_array($arrVerbosity[$params['verbosity']])) {

		foreach ($arrVerbosity[$params['verbosity']] as $field)
		$sql .= $field . ",";

	} else {

		die("Invalid verbosity level.");

	}

	// give us back the custom fields with appropriate names!

	if (isset($arrCFFlag[$params['verbosity']])) {

		foreach ($customfields AS $key=>$value)
		$sql .= " customfield".$key." AS ".$value.",";
	}
	// remove last comma!
	$sql = substr($sql,0,strlen($sql)-1);


	//,GROUP_CONCAT(DISTINCT media.path,media.name) AS thumbtitle
	$includeThumb = true;
	if(isset($params["thumbUsage"])) {
		$thumb_usage = $params["thumbUsage"];
		$includeThumb = false;
	}
	$thumb_usage = "thumb";


	$sql .= " FROM content
			  LEFT JOIN content_users ON content_users.contentid = content.id
			  LEFT JOIN user ON user.id = content_users.userid
			  			  
			  LEFT JOIN content_terms AS content_terms ON content_terms.contentid = content.id
			  LEFT JOIN term_taxonomy AS term_taxonomy ON term_taxonomy.id = content_terms.termid 
			  LEFT JOIN terms AS terms ON terms.id = term_taxonomy.termid
			  LEFT JOIN templates ON templates.id = content.templateid 		  

			  LEFT JOIN (
	
				SELECT content_content.contentid,GROUP_CONCAT(content_content.contentid2 ORDER BY content_content.id) AS contentids 
				FROM content_content
				GROUP BY content_content.contentid
			
 			 ) AS content1 ON content1.contentid = content.id

			  LEFT JOIN (
	
				SELECT content_content.contentid2,GROUP_CONCAT(content_content.contentid ORDER BY content_content.id) AS contentids 
				FROM content_content
				GROUP BY content_content.contentid2
			
 			 ) AS content2 ON content2.contentid2 = content.id
		
			  
			  LEFT JOIN (
			  	
			  		SELECT content_media.contentid,GROUP_CONCAT(content_media.mediaid ORDER BY content_media.displayorder) AS mediaids 
			  		FROM content_media";
	if($includeThumb == false) {
		$sql .= " WHERE content_media.usage_type <> '".$thumb_usage."' ";
	}

	$sql .=	" GROUP BY content_media.contentid
			  			
			   ) AS content_mediaids ON content_mediaids.contentid = content.id
			   
			  LEFT JOIN (
			  	
			  		SELECT content_media.contentid,GROUP_CONCAT(content_media.mediaid ORDER BY content_media.displayorder) AS thumbids 
			  		FROM content_media
			  		WHERE content_media.usage_type = '".$thumb_usage."'
			  		GROUP BY content_media.contentid
			  	
			   ) AS content_thumbids ON content_thumbids.contentid = content.id
			   LEFT JOIN media ON media.id = thumbids ";	

	// WHERE CLAUSE INFO

	$sql .= " WHERE content.id <> 0 ";

	if (isset($params['contentid'])) { // return a specific content id, or a list thereof

		if (isset($strChildIDs)) {
			$sql .= " AND content.id IN (:contentid,".$strChildIDs.")";
			$sendParams['contentid'] = $params['contentid'];
		}
		else {
			$sql .= " AND content.id IN (:contentid)";
			$sendParams['contentid'] = $params['contentid'];
		}
	}

	if (isset($params['has_tag'])) { // search for tags

		$arrTags = explode(",",$params['has_tag']);

		if (is_array($arrTags)) {

			$strTags = "";

			foreach ($arrTags as $tag)
			$strTags .= "'".$tag."'";


			$sql .= " AND tags.tag IN (".$strTags.") ";
		}
			
	}

	if (isset($params['search_terms'])) { // general search

		$arrSearchTerms = explode(",",$params['search_terms']);

		if (is_array($arrSearchTerms)) {

			$sql .= " AND ( ";

			foreach ($arrSearchTerms as $term) {
				$i++;
				$sql .= " content.title LIKE :term".$i." OR";
				$sql .= " content.url LIKE :term".$i." OR";
				$sql .= " content.description LIKE :term".$i." OR";
				$sql .= " content.customfield1 LIKE :term".$i." OR";
				$sql .= " content.customfield2 LIKE :term".$i." OR";
				$sql .= " content.customfield3 LIKE :term".$i." OR";
				$sql .= " content.customfield4 LIKE :term".$i." OR";
				$sql .= " content.customfield5 LIKE :term".$i." OR";
				$sql .= " content.customfield6 LIKE :term".$i." OR";
				$sql .= " content.customfield7 LIKE :term".$i." OR";
				$sql .= " content.customfield8 LIKE :term".$i." OR";
				$sql .= " terms.name LIKE :term".$i." OR";
				
				$sendParams['term'.$i] = "%".$term."%";
			}
			// remove last "OR"

			$sql = substr($sql,0,strlen($sql)-2);

			$sql .= " ) ";

		}
			
	}

	if (isset($params['search_customfields'])) { // search customfields

		$arrSearchTerms = explode(",",$params['search_customfields']);

		if (is_array($arrSearchTerms)) {

			$sql .= " AND ( ";

			foreach ($arrSearchTerms as $term) {
					
				foreach ($customfields as $key=>$field) {

					$sql .= " content.customfield".$key." LIKE '%".$term."%' OR";

				}
					
			}
			// remove last "OR"
			$sql = substr($sql,0,strlen($sql)-2);
			$sql .= " ) ";
		}
	}

	if (isset($params['search_description'])) { // search description

		$arrSearchTerms = explode(",",$params['search_description']);

		if (is_array($arrSearchTerms)) {

			$sql .= " AND ( ";

			foreach ($arrSearchTerms as $term) {
				$i++;
				$sql .= " content.description LIKE :term".$i." OR";
				$sendParams['term'.$i] = "%".$term."%";
			}
						
			// remove last "OR"

			$sql = substr($sql,0,strlen($sql)-2);

			$sql .= " ) ";

		}
	}

	if (isset($params['search_title'])) { // search title

		$arrSearchTerms = explode(",",$params['search_title']);

		if (is_array($arrSearchTerms)) {

			$sql .= " AND ( ";

			foreach ($arrSearchTerms as $term) {
				$i++;
				$sql .= " content.title LIKE :term".$i." OR";
				$sendParams['term'.$i] = "%".$term."%";
			}
			
			// remove last "OR"

			$sql = substr($sql,0,strlen($sql)-2);

			$sql .= " ) ";

		}
			
	}
	// GET ANY EXTRA PARAMS AND APPLY THOSE TO THE WHERE CLAUSE!


	foreach ($params as $key=>$value) {

		if (!in_array($key,$validParams)) { // this is a custom parameter

			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;

		}

	}

	// GROUP BY CLAUSE

	$sql .= " GROUP BY content.id";

	// ORDER BY

	if (isset($params['orderby']))
	{
		if(isset($params['orderdirection'])) {
			$sql .= " ORDER BY " . 'content.'. $params['orderby'] ." ". $params['orderdirection'];
		}
		else
		$sql .= " ORDER BY " . 'content.'.$params['orderby'] . " ";
	}
	else
	$sql .= " ORDER BY content.id ASC";

	//echo $sql;
	// get the results
	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

//$old_error_handler = set_error_handler("userErrorHandler");

function getContentMedia($params)
{
	/*
		-- VALID PARAMS --
		-- REQUIRED --

		contentid (int) - specifies a specific content id to return (can be comma-delimited)

		*/

	$validParams = array("action","tablename","id","orderby");
	$sendParams = array();

	$sql = "SELECT content_media.id, content_media.contentid,content_media.mediaid,content_media.usage_type," .
			"content_media.displayorder,content_media.caption,content_media.credits,media.name, media.mimetype," .
			"media.path,media.playtime,media.url,media.thumb,media.video_proxy,media.createdby,media.createdate,media.modifiedby,media.modifieddate";

	$sql .= " FROM `". 'content_media' ."`";

	$sql .= " LEFT JOIN media ON (content_media.mediaid = media.id)";

	//contentid ** required!
	if (isset($params['contentid']))
	{
		$sql .= " WHERE contentid = :contentid ";
		$sendParams['contentid'] = $params['contentid'];
	}
	else
	{
		die("No contentid was provided");
	}
	// ORDER BY

	$thumb = false;
	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{ // this is a custom parameter
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
			if($value == "thumb")
			$thumb = true;
		}
	}

	$sql .= " ORDER BY displayorder ASC";

	// get the results
	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function getContentTags($params)
{
	/*
		-- VALID PARAMS --
		-- REQUIRED --

		contentid (int) - specifies a specific content id to return (can be comma-delimited)

		*/

	$sendParams = array();
	$validParams = array("action","tablename","id","orderby");

	$sql = "SELECT content_terms.id, content_terms.termid, terms.name,term_taxonomy.taxonomy";

	$sql .= " FROM `content_terms`";

	$sql .= " LEFT JOIN term_taxonomy  ON term_taxonomy.id = content_terms.termid";
	$sql .= " LEFT JOIN terms  ON terms.id = term_taxonomy.termid";

	if (isset($params['contentid']))
	{
		$sql .= " WHERE contentid = :contentid ";
		$sendParams['contentid'] = $params['contentid'];
	}
	else
	{
		die("No contentid was provided");
	}

	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{ // this is a custom parameter
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		}
	}
	$sql .= " ORDER BY id ASC";

	// get the results
	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function getContentUsers($params)
{
	/*
		-- VALID PARAMS --
		-- REQUIRED --

		contentid (int) - specifies a specific content id to return (can be comma-delimited)

		*/

	$sendParams = array();

	$validParams = array("action","tablename","id","orderby");

	$sql = "SELECT content_users.id, content_users.contentid,content_users.userid, user.firstname, user.lastname, user.username, user.email";

	$sql .= " FROM `content_users`";

	$sql .= " LEFT JOIN user  ON (content_users.userid = user.id)";

	//contentid ** required!
	if (isset($params['contentid']))
	{
		$sql .= " WHERE contentid = :contentid ";
		$sendParams['contentid'] = $params['contentid'];
	}
	else
	{
		die("No contentid was provided");
	}

	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{ // this is a custom parameter
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		}
	}

	$sql .= " ORDER BY id ASC";

	// get the results
	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function getContentContent($params)
{
	/*
		-- VALID PARAMS --
		-- REQUIRED --

		contentid (int) - specifies a specific content id to return (can be comma-delimited)

		*/

	$sendParams = array();
	$validParams = array("action","tablename","contentid","orderby");

	$sql = "SELECT content_content.id,content_content.contentid2,content.title,content.templateid";

	$sql .= " FROM `". 'content_content' ."`";

	$sql .= " LEFT JOIN content  ON content.id = content_content.contentid2";

	//contentid ** required!
	if (isset($params['contentid']))
	{
		$sql .= " WHERE content_content.contentid = :contentid ";
		$sendParams['contentid'] = $params['contentid'];
	}
	else
	{
		die("No contentid was provided");
	}

	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{ // this is a custom parameter
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		}
	}
	$sql .= " ORDER BY id ASC";

	// get the results

	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function getContentTree($params)
{
	global $statusid;

	global $search; global $values;
	$list = get_html_translation_table(HTML_ENTITIES);
	//unset($list['"']);
	unset($list['<']);
	unset($list['>']);

	$search = array_keys($list);
	$values = array_values($list);
	$search = array_map('utf8_encode', $search);

	$sendParams = array();

	$statusid = -1;
	$xml = "";
	$sql = "SELECT content.id,content.parentid,content.title,content.url,is_fixed,color " .
			"FROM `content` ";

	if(isset($params['id']))
	{
		$sql .=  " WHERE content.id = :id ";
		$sendParams['id'] = $params['id'];
		if(isset($params['statusid']))
		{
			$statusid = $params['statusid'];
			$sql .= " AND content.statusid = :statusid ";
			$sendParams['statusid'] = $params['statusid'];
		}
		$sql .=	 " AND deleted = '0' ORDER BY displayorder";
	}
	else
	{
		$sql .= " WHERE parentid = 0 AND deleted = '0' ORDER BY displayorder";

	}
	$result = queryDatabase($sql, $sendParams);

	$xml .="<categoryTree>";
	//$arrContainers = array();

	while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
			
		$xml.= "<container ".returnTagAttributes($row).">";

		if ($x = returnChildren($row['id']))
		$xml .= $x;

		$xml.= "</container>";

	}

	$xml .="</categoryTree>";

	header('Content-type: text/xml; charset="utf-8"',true);

	$xml = trim($xml);

	echo $xml;
	die();
}

function getMedia($params) {

	/*
		-- VALID PARAMS --
		-- ALL ARE OPTIONAL --

		mediaid (int) - specifies a specific media id to return (can be comma-delimited)
		contentid (int) - specifies a specific content id to return media results for (can be comma-delimited)
		include_unused (1,0) - include media that is not tied to content - defaults to 0 (NO).
		has_tag - comma-delimited list of tags to search for.
		search_caption - search words to search for in description (comma-delimited).
		search_credits - words to search for in the custom fields (comma-delimited).
		orderby - field name to order results by, should be expressed as table.field (e.g. content.title). Can also be comma-delimited list.
		mimetype

		*/
	global $mediaVerbosity;
	$validParams = array("action","mediaid","contentid","include_unused","has_tag","search_caption","search_credits","orderby","name","include_thumb","verbosity");

	$sendParams = array();
	$i = 0;
	
	// SELECT fields according to verbosity

	if (!isset($params['verbosity'])) // set default verbosity
	$params['verbosity'] = 0;


	// BUILD SELECT STATEMENT FROM INFO IN VERBOSITY ARRAY!

	$sql = "SELECT ";

	if (@is_array($mediaVerbosity[$params['verbosity']])) {

		foreach ($mediaVerbosity[$params['verbosity']] as $field)
		$sql .= $field . ",";

	} else {

		die("Invalid verbosity level.");

	}
	$sql = substr($sql,0,strlen($sql)-1);
	$sql .= " FROM media
			  LEFT JOIN media_tags ON media_tags.mediaid = media.id
			  LEFT JOIN terms ON terms.id = media_tags.tagid
			  LEFT JOIN content_media AS content_media ON  content_media.mediaid = media.id
			  LEFT JOIN content ON (content.id = content_media.contentid AND content.deleted='0') ";

	// WHERE CLAUSE INFO

	$sql .= " WHERE media.id <> 0 ";

	if (isset($params['mediaid'])) { // return a specific media id, or a list thereof

		$sql .= " AND media.id IN (:mediaid)";
		$sendParams['mediaid'] = $params['mediaid'];
	}

	if (isset($params['contentid'])) { // return media for a specific content id, or a list thereof

		$sql .= " AND content_media.contentid IN (:contentid)";
		$sendParams['contentid'] = $params['contentid'];
	}

	if (!isset($params['include_unused']) || ($params['include_unused'] == 0) ) { // return media for a specific content id, or a list thereof

		$sql .= " AND content_media.id IS NOT NULL";

	}

	if (isset($params['has_tag'])) { // search for tags

		$arrTags = explode(",",$params['has_tag']);

		if (is_array($arrTags)) {
			$sql .= " AND ( ";
			foreach ($arrTags as $term) {
				$i++;
				$sql .= " terms.name LIKE :term".$i." OR";
				$sendParams['term'.$i] = "%".$term."%";
			}
			$sql = substr($sql,0,strlen($sql)-2);

			$sql .= " ) ";
		}
		else {
			$sql .= " AND terms.name LIKE :has_tag ";
			$sendParams['has_tag'] = "%".$params['has_tag']."%";
		}
	}

	if (isset($params['search_caption'])) { // search caption

		$arrSearchTerms = explode(",",$params['search_caption']);

		if (is_array($arrSearchTerms)) {

			$sql .= " AND ( ";

			foreach ($arrSearchTerms as $term) {
				$i++;
				$sql .= " media.caption LIKE :term".$i." OR";
				$sendParams['term'.$i] = "%".$term."%";
			}
			// remove last "OR"

			$sql = substr($sql,0,strlen($sql)-2);

			$sql .= " ) ";

		}
	}

	if (isset($params['search_credits'])) { // search credits

		$arrSearchTerms = explode(",",$params['search_credits']);

		if (is_array($arrSearchTerms)) {

			$sql .= " AND ( ";

			foreach ($arrSearchTerms as $term) {
				$i++;
				$sql .= " media.credits LIKE :term".$i." OR";
				$sendParams['term'.$i] = "%".$term."%";
			}
			
			// remove last "OR"

			$sql = substr($sql,0,strlen($sql)-2);

			$sql .= " ) ";

		}
	}

	// NOW, LETS GET ANY EXTRA PARAMS AND APPLY THOSE TO THE WHERE CLAUSE!

	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{ // this is a custom parameter
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		}
	}

	if(isset($params['include_thumb']))
	{
		if($params['include_thumb'] == '0')
		$sql .= " AND content_media.usage_type != 'list_thumbnail' AND content_media.usage_type != 'main_thumbnail' ";
	}

	$sql .=" GROUP BY media.id";


	// ORDER BY

	if (isset($params['orderby'])) {
		$sql .= " ORDER BY ".$params['orderby'];
	}
	else if (isset($params['contentid']))
	$sql .= " ORDER BY content_media.displayorder ASC";
	else
	$sql .= " ORDER BY media.id ASC";

	// get the results
	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function contentSearch($params)
{
	/*
		-- VALID PARAMS --
		-- REQUIRED PARAMS --

		search_terms - search words to search for (comma-delimited). this searches title, description + custom fields.

		*/

	$sendParams = array();
	$i = 0;
	
	if (!$params['search_terms'])
		die("search_terms is required");

	$validParams = array("action","contentid","include_children","typeid","has_tag","search_terms","search_description","search_customfields","verbosity","parentid","orderby");

	$sql = "";

	if (!isset($params['type']) || $params['type'] == 'content') {

		$sql .= " ( SELECT 'content' as type, content.id as contentid, content.parentid as parentid, 0 as mediaid, content.templateid," .
				   "content.title as contenttitle, '' as mediatitle, content.createdby, content.createdate, content.modifiedby, content.modifieddate, " .
				   "templates.title AS templatetitle, templates.classname AS templateclassname, content.containerpath AS path, '' AS diskpath ";

		$sql .= " FROM content
				  LEFT JOIN content_terms ON content_terms.contentid = content.id
				  LEFT JOIN term_taxonomy ON term_taxonomy.id = content_terms.termid
				  LEFT JOIN terms ON terms.id = term_taxonomy.termid
				  LEFT JOIN templates ON templates.id = content.templateid 
				";


		// WHERE CLAUSE INFO

		$sql .= " WHERE content.search_exclude <> 1 AND deleted='0' ";

		if (isset($params['search_terms'])) { // general search

			$arrSearchTerms = explode(",",$params['search_terms']);

			if (is_array($arrSearchTerms)) {

				$sql .= " AND ( ";

				foreach ($arrSearchTerms as $term) {
					$i++;
					$sql .= " content.title LIKE :term".$i." OR";
					//$sql .= " content.description LIKE :term".$i." OR";
					//$sql .= " content.customfield1 LIKE :term".$i." OR";
					//$sql .= " content.customfield2 LIKE :term".$i." OR";
					//$sql .= " content.customfield3 LIKE :term".$i." OR";
					//$sql .= " content.customfield4 LIKE :term".$i." OR";
					//$sql .= " content.customfield5 LIKE :term".$i." OR";
					//$sql .= " content.customfield6 LIKE :term".$i." OR";
					//$sql .= " content.customfield7 LIKE :term".$i." OR";
					//$sql .= " content.customfield8 LIKE :term".$i." OR";

					///!!!! crucial for tag search - use like ins
					//$sql .= " tags.tag = :termtags".$i." OR";
					//$sendParams['termtags'.$i] = $term;
					
					$sql .= " terms.name LIKE :term".$i." OR";
					$sendParams['term'.$i] = "%".$term."%";
				}

				// remove last "OR"

				$sql = substr($sql,0,strlen($sql)-2);
					
				$sql .= " ) ";

				foreach ($params as $key=>$value)
				{
					if (!in_array($key,$validParams))
					{ // this is a custom parameter
						$sql .= " AND " . $key  . " = :'".$key;
						$sendParams[$key] = $value;
					}
				}
			}
		}

		// GROUP BY CLAUSE

		$sql .= " GROUP BY content.id ) ";

	}

	// ORDER BY

	$sql .= " ORDER BY contentid,mediaid,createdate DESC";


	// get the results
	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function migSearch($params)
{
	/*
		-- VALID PARAMS --
		-- REQUIRED PARAMS --

		search_terms - search words to search for (comma-delimited). this searches title, description + custom fields.

		-- OPTIONAL PARAMS --

		type - media or content.
		*/

	$sendParams = array();
	$i = 0;

	if (!$params['search_terms'])
	die("search_terms is required");

	$validParams = array("action","contentid","include_children","typeid","has_tag","search_terms","search_description","search_customfields","verbosity","parentid","orderby");

	$sql = "";

	//type = content

	if (!isset($params['type']) || $params['type'] == 'content') {

		$sql .= " ( SELECT 'content' as type, content.id as contentid, 0 as mediaid, content.templateid,content.title as contenttitle, " .
				"'' as mediatitle, content.createdby, content.createdate, content.modifiedby, content.modifieddate, templates.title AS templatetitle, " .
				"templates.classname AS templateclassname, content.containerpath AS path, '' AS diskpath ";

		$sql .= " FROM content
			  	  LEFT JOIN content_terms AS content_terms ON content_terms.contentid = content.id
			      LEFT JOIN term_taxonomy AS term_taxonomy ON term_taxonomy.id = content_terms.termid 
			      LEFT JOIN terms AS terms ON terms.id = term_taxonomy.termid
				  LEFT JOIN templates ON templates.id = content.templateid";


		// WHERE CLAUSE INFO

		$sql .= " WHERE content.search_exclude <> 1 AND deleted='0' ";

		if (isset($params['search_terms'])) { // general search

			$arrSearchTerms = explode(",",$params['search_terms']);

			if (is_array($arrSearchTerms)) {

				$sql .= " AND ( ";

				foreach ($arrSearchTerms as $term) {
					$i++;
					$sql .= " content.title LIKE :term".$i." OR";
					$sql .= " content.description LIKE :term".$i." OR";
					$sql .= " content.customfield1 LIKE :term".$i." OR";
					$sql .= " content.customfield2 LIKE :term".$i." OR";
					$sql .= " content.customfield3 LIKE :term".$i." OR";
					$sql .= " content.customfield4 LIKE :term".$i." OR";
					$sql .= " content.customfield5 LIKE :term".$i." OR";
					$sql .= " content.customfield6 LIKE :term".$i." OR";
					$sql .= " content.customfield7 LIKE :term".$i." OR";
					$sql .= " content.customfield8 LIKE :term".$i." OR";

					///!!!! crucial for tag search
					//$sql .= " tags.tag = :termtags".$i." OR";
					//$sendParams['termtags'.$i] = $term;
					
					$sql .= " terms.name LIKE :term".$i." OR";
					$sendParams['term'.$i] = "%".$term."%";
				}

				// remove last "OR"

				$sql = substr($sql,0,strlen($sql)-2);
					
				$sql .= " ) ";
			}
		}

		// GROUP BY CLAUSE

		$sql .= " GROUP BY content.id ) ";

		if (!isset($params['type']))
		$sql .= " UNION ALL";
	}

	// type = media

	if (!isset($params['type']) || $params['type'] == 'media') {

		$sql .= "( SELECT 'media' as type, content.id as contentid, media.id as mediaid, 0 as templateid, content.title as contenttitle, media.name as mediatitle, media.createdby, media.createdate, media.modifiedby, media.modifieddate, '' as templatetitle, '' as templateclassname, content.containerpath AS path, media.path AS diskpath";

		$sql .= " FROM media
				  LEFT JOIN media_tags ON media_tags.mediaid = media.id
				  LEFT JOIN terms ON terms.id = media_tags.tagid
				  LEFT JOIN content_media ON content_media.mediaid = media.id
				  LEFT JOIN content ON content.id = content_media.contentid";

		$sql .= " WHERE media.id <> 0 ";


		if (isset($params['search_terms'])) { // search for tags

			$arrTerms = explode(",",$params['search_terms']);

			if (is_array($arrTerms)) {

				foreach ($arrTerms as $term) {
					$i++;
					
					///!!!! crucial for tag search
					//$sql .= " AND ( tags.tag = :termtags".$i." OR";
					//$sendParams['termtags'.$i] = $term;
					
					$sql .= " AND ( terms.name LIKE :term".$i." OR";
					$sql .= " content_media.caption LIKE :term".$i." OR";
					$sql .= " media.name LIKE :term".$i." OR";
					$sql .= " content_media.credits LIKE :term".$i." ";
					$sql .=" )";
					$sendParams['term'.$i] = "%".$term."%";
				}
			}
		}

		$sql .= "GROUP BY media.id, content_media.contentid ) ";

		$sql .= "
	
			UNION ALL
			
			( SELECT 'media' as type, 0 AS contentid, media.id as mediaid, 0 as templateid, '' as contenttitle, media.name as mediatitle, media.createdby, media.createdate, media.modifiedby, media.modifieddate, '' as templatetitle, '' as templateclassname, '' AS path, media.path AS diskpath";

		$sql .= " FROM media
				  LEFT JOIN media_tags ON media_tags.mediaid = media.id
				  LEFT JOIN content_media ON content_media.mediaid = media.id
				  LEFT JOIN terms ON terms.id = media_tags.tagid";

		$sql .= " WHERE media.id <> 0 ";

		if (isset($params['search_terms'])) { // search for tags

			$arrTerms = explode(",",$params['search_terms']);

			if (is_array($arrTerms)) {

				foreach ($arrTerms as $term) {
					$i++;
					
					///!!!! crucial for tag search
					//$sql .= " AND ( tags.tag = :termtags".$i." OR";
					//$sendParams['termtags'.$i] = $term;
					
					$sql .= " AND ( terms.name LIKE :term".$i." OR";
					$sql .= " content_media.caption LIKE :term".$i." OR";
					$sql .= " media.name LIKE :term".$i." OR";
					$sql .= " content_media.credits LIKE :term".$i." ";
					$sql .=" )";
					$sendParams['term'.$i] = "%".$term."%";
				}
			}
		}

		$sql .= "GROUP BY media.id )";
	}

	// ORDER BY

	$sql .= " ORDER BY contentid,mediaid,createdate DESC";

	// get the results
	$result = queryDatabase($sql,$sendParams);

	// return the results
	return $result;
}

function returnTagAttributes($row)
{
	global $search; global $values;
	$keyvalues = array();
	foreach ($row as $key=>$value) {
		$value = stripslashes($value);
		$value = str_replace($search, $values, $value);
		$keyvalues[$key] = $value;
	}
	$tagAttr = "id=\"".$keyvalues['id']."\" parentid=\"".$keyvalues['parentid']."\" title=\"".$keyvalues['title'] ."\" url=\"".$keyvalues['url'] ."\" is_fixed=\"".$keyvalues['is_fixed']."\" color=\"".$keyvalues['color']."\"";

	return $tagAttr;
}

function returnChildren($contentid)
{
	global $statusid;
	$sendParams = array();
	$sql = "SELECT  content.id,content.parentid,content.title,content.url,is_fixed,color FROM `content` WHERE parentid = :contentid";
	$sendParams['contentid'] = $contentid;

	if($statusid != -1) {
		$sql .=  " AND deleted='0' AND content.statusid= :statusid ORDER BY displayorder";
		$sendParams['statusid'] = $statusid;
	}
	else
	$sql .= " AND deleted = '0' ORDER BY displayorder";

	$result = queryDatabase($sql, $sendParams);

	$xml = "";
	while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
		$xml.= "<container ".returnTagAttributes($row).">";

		if ($x = returnChildren($row['id']))
		$xml .= $x;
		$xml.= "</container>";
	}
	return $xml;
}

function getChildren($contentid, $depth = null)
{ // returns array of children for a given contentid
global $arrChildIDs;
$arrChildIDs = array();
if ($contentid != 0) { // this gets rid of unintentional behavior when contentid is set to 0 (which means none, not parent of all!)
	fetchChildren($contentid,$depth,0);
	return $arrChildIDs;
}
}

function fetchChildren($contentid,$depth,$level = 0){ // this function is used by get children recursively
	global $arrChildIDs;
	// retrieve all children of $parent
	$sendParams = array();
	$sql = "SELECT content.id FROM content WHERE parentid = :contentid";
	$sendParams['contentid'] = $contentid;
	$result = queryDatabase($sql, $sendParams);
	while ($row = $result->fetch(PDO::FETCH_ASSOC))
	{
		$arrChildIDs[] = $row['id'];
		if( $depth == -1)
		{
			fetchChildren($row['id'], $level+1);
		}
		else if($level+1 < $depth)
		{
			fetchChildren($row['id'], $level+1);
		}
	}
}

function getTags($params) {

	/*
		-- VALID PARAMS --
		-- ALL ARE OPTIONAL --

		//tagid (int) - specifies a specific media id to return (can be comma-delimited)
		//contentids (int) - specifies a specific content id to return media results for (can be comma-delimited)
		//include_unused (1,0) - include media that is not tied to content - defaults to 0 (NO).
		*/

	$sendParams = array();
	$validParams = array("action","tagid","contentid","include_unused");

	// define the sql query
	$sql = "SELECT terms.name,terms.slug,term_taxonomy.* , GROUP_CONCAT(DISTINCT content_terms.contentid) AS contentids,GROUP_CONCAT(DISTINCT content.title) AS contenttitles, " .
		   "GROUP_CONCAT(DISTINCT media.path,media.name) AS mediatitles, GROUP_CONCAT(DISTINCT media.id) AS mediaids";

	$sql .= " FROM term_taxonomy
			  LEFT JOIN terms ON terms.id = term_taxonomy.termid
			  LEFT JOIN content_terms ON content_terms.termid = term_taxonomy.id
			  LEFT JOIN content ON (content.id = content_terms.contentid  AND content.deleted = 0)
			  LEFT JOIN media_tags ON media_tags.tagid = terms.id
			  LEFT JOIN media ON media.id = media_tags.mediaid";
	// WHERE CLAUSE INFO

	$sql .= " WHERE term_taxonomy.id <> 0 ";
	//
	//	if (isset($params['tagid'])) {
	//
	//		$sql .= " AND tagid.id IN (".$params['tagid'].")";
	//
	//	}
	//
	//	if (isset($params['contentid'])) {
	//
	//		$sql .= " AND content_tags.contentid IN (".$params['contentid'].")";
	//
	//	}
	//
	//	if (!isset($params['include_unused']) || ($params['include_unused'] == 0) ) {
	//
	//		$sql .= " AND conte	nt_tags.id IS NOT NULL";
	//
	//	}
	// GET ANY EXTRA PARAMS AND APPLY THOSE TO THE WHERE CLAUSE

	foreach ($params as $key=>$value)
	{
		if (!in_array($key,$validParams))
		{ // this is a custom parameter
			$sql .= " AND " . $key . " = :".$key;
			$sendParams[$key] = $value;
		}
	}

	$sql .=" GROUP BY term_taxonomy.id";

	// ORDER BY
	$sql .= " ORDER BY term_taxonomy.displayorder ASC";

	$result = queryDatabase($sql, $sendParams);

	// return the results
	return $result;
}

function sendUserInformation($params) {
	if(isset($params["email"])) {
		$sendParams;
		$sql = "SELECT * from user";
		$sql .= " WHERE email=:email ";
		$sendParams['email'] = $params['email'];
		$result = queryDatabase($sql, $sendParams);

		$count = 0;
		while ($row = $result->fetch(PDO::FETCH_ASSOC))
		{
			$count++;
			$body = "Here is your requested user information.\r\n";
			$body.= "username: ". $row["username"] ."\r\n";
			$body.= "password: ". text_decrypt($row["password"])."\r\n \r\n";
			$email = $row["email"];
		}

		if($count == 1) {
			$headers = "From: mig@themapoffice.com \r\n";
			$headers.= "Content-Type: text/plain; charset=UTF-8";
			$headers.= "MIME-Version: 1.0 ";
			mail($email, "Your MiG account information", $body, $headers);
			sendSuccess();
		}
		else if($count == 0) die ("No such email");
		else die("Contact System administrator");
	}
	else
	die ("No email was provided");
}
?>