<?php



function validateUser($params)
{
	/*
		-- VALID PARAMS --
		-- ALL ARE REQUIRED! --
		
		username (str)
		password (str)
	
	*/
	
	
	$validParams = array("action","username","password");
	
		if (isset($params['username']) && isset($params['password'])) {
		
		$sql = "SELECT * FROM user WHERE username = '".$params['username']."' AND active='1'";
		$result = queryDatabase($sql);
		
		if ($row = mysql_fetch_array($result)) {
		
			if ($params['password'] == text_decrypt($row['password'])) {
				$sql = "SELECT * FROM user WHERE id = '".$row['id']."'";
				$result = queryDatabase($sql);
				return $result;
			} else {
				die("Invalid Password!!!");
			}
		
		} else {
		
			die("user not found");
		
		}
	
	} else {
	
		die ("Username and Password and both required!");
	
	}

}

//$old_error_handler = set_error_handler("userErrorHandler");


?>