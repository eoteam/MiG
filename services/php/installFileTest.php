<?php
require_once "fileFunctions.php";
require_once "zip/archive.php";

/*
$fileDir = "../files/";
$thumbDir = "../files/migThumbs/";
$tempDir = "../temporary/";
*/
$zipfilename = sanitize_file_name($_FILES['Filedata']['name']);
$arr = getExtension('.', $filename, -2);
$fielExtension = $arr[1];
$fileBase = $arr[0];



?>