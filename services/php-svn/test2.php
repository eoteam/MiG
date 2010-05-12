<?php

/* 
$dsn = 'mysql:dbname=mig;host=localhost';
$user = 'root';
$password = 'root';
*/
/*
try {
    $db = new PDO('mysql:host=localhost;dbname=mig', 'root', '');
    //$db = new PDO($dsn, $user, $password);
} catch (PDOException $e) {
    echo 'Connection failed:  ' . $e->getMessage();
}
*/

$db = new PDO('mysql:host=localhost;dbname=mig', 'root', '');
$db->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING );

/*
// Execute a prepared statement with question mark parameters 
$sth = $db->prepare("
    SELECT 
        * 
    FROM 
        fonts 
    WHERE 
        id > ?  
    ORDER BY 
        name");

$sth->execute(array(3));
    
while ($id3 = $sth->fetchObject()) {
        echo $id3->id, ": ", $id3->name, " ";
    }
 
echo "\n";
*/

/*
//Execute a prepared statement with named parameters

$sql = '

	SELECT 
        fonts.*
    FROM 
        fonts
    WHERE 
        id = :id  and name = :name
    ORDER BY 
        name';

$sth = $db->prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
//$sth->execute(array(':id' => $params['id'], ':name' => $params['name'], ':tablename' => $params['tablename']));
//$sth->execute(array(':id' => 5, ':name' => "eee", ':tablename' => fonts));
//$sth->execute(array(':id' => 5, ':name' => "'eee' or 1=1"));
//$v1='fonts';
$v2=5;
$v3='eee';
//$sth->bindValue(':tablename', $v1, PDO::PARAM_STR);
$sth->bindParam(':id', $v2, PDO::PARAM_INT);
$sth->bindParam(':name', $v3, PDO::PARAM_STR);
$sth->execute();

print_r($sth);
echo "<br>";


while ($result = $sth->fetchObject()) {
	//print_r($result);
	echo $result->id, ": ", $result->name;
//	echo $aaa1->id, ": ", $aaa1->name, " from ", $aaa1->tablename;
}
*/

/*
//INJECTION!!
$v1 = 5;
$v2 = "'eee' or 1=1";
$sth = $db->prepare("SELECT * from fonts WHERE id=$v1 and name=$v2 ORDER BY id", array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY)); 
$sth->execute();
while ($aaa1 = $sth->fetchObject()) {
	echo $aaa1->id, ": ", $aaa1->name, "<br>";
}
*/

/*
$sth->execute(array(':id' => 4, ':name' => 'aaa'));
$aaa4 = $sth->fetchAll();
echo $aaa4->id, ": ", $aaa4->name, " ";
*/

/*
//insert example
$sth = $db->prepare("INSERT INTO fonts (id, name) VALUES (:id, :name)");
$past = 'id';
$key=":".$past;
$value='9';

$past2 = 'name';
$key2=":".$past2;
$value2='aaaaa';

$sth->bindParam($key,$value);
$sth->bindParam($key2,$value2);

$sth->execute();
*/

//update example
$sth = $db->prepare("UPDATE fonts SET name=:name WHERE id=:id");
$past = 'id';
$key=":".$past;
$value='9';

$past2 = 'name';
$key2=":".$past2;
$value2='ooooo';

$sth->bindParam($key,$value);
$sth->bindParam($key2,$value2);
  
$sth->execute();
	
	
/*
//insert example
$sth = $db->prepare("INSERT INTO fonts (id, name) VALUES (:id, :name)");
$sth->bindParam(':id',$id);
$sth->bindParam(':name',$name);
for ($i=9;$i<=12;$i++)
{
	$id=$i;
	$name='aaaaa';
	$sth->execute();
} 
*/

/*
//update example
$var ="jgjgjgjg"; //injection

//sql would be escaped
$sth = $db->prepare("UPDATE fonts SET name=:name WHERE id=9");
$sth->bindParam(":name", $var);  
$sth->execute();
*/
	
	
/*
//injection would occur!!
$sth = $db->prepare("UPDATE fonts SET name='".$var."' WHERE id=7"); 
$sth->execute();
*/


$db = null;

?>