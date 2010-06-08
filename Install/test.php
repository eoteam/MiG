<?php
//require_once "functions.php";


$path = "C:\testinstaller2\files";
$path = str_replace("\\", "/", $path);

echo $path;
//chdir('/testinstaller2/migAssets');

//$path = getcwd();


//$path = "C:/testinstaller2/files";
//$arrMandatoryFiles = array( "sample.zip", "test.php" );
//$path = "C:/testinstaller";
//emptyFolder($path,$arrMandatoryFiles);

/*
$directory = new RecursiveDirectoryIterator($path);
$iterator = new RecursiveIteratorIterator($directory);


foreach ($iterator as $fileinfo) {
    if ($fileinfo->isFile()) {
        unlink($fileinfo->getFilename());
    }
}
*/
//echo "true";

/*
foreach ($iterator as $fileinfo) {
    if ($fileinfo->isDir() && !$fileinfo->isDot()) {
        echo $fileinfo->getFilename() . "\n";
    }
}
*/

/*
 ../ - parent
 ./ - the same folder
 / - cwd
 */

?>