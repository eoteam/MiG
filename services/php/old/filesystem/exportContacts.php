<?php
	// create the zip  
	$name = $_GET["name"];
	$content = $_POST["content"];
	
	header("Content-Type: text/plain");
	$header = 'Content-Disposition: attachment; filename="';
	$header .= $name. '.csv"';
	header($header);
	$arr = split('endline',stripslashes($content));
	foreach($arr as $line)
	{	echo $line;
		echo "\n";
	}
?>	