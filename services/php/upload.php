<?php
require_once "fileFunctions.php";
require_once "config/constants.php";

$path = $fileDir . $_REQUEST['directory'];
$thumbpath = $thumbDir . $_REQUEST['directory'];
$fileType = $_REQUEST["fileType"];
$filename = sanitize_file_name($_FILES['Filedata']['name']);
$arr = getExtension('.', $filename, -2);
$extension = $arr[1];
$base = $arr[0];

move_uploaded_file($_FILES['Filedata']['tmp_name'], $tempDir. $filename);
 
if(file_exists($path.$filename))   
{
	$counter = checkName($path,$base,$extension,1);
	$base .= '_'.$counter;
}
rename($tempDir.$filename, $path.$base.'.'.$extension);

$thumbase = $base; 
$thumbextension = $extension;
$thumbCreated = false;
$videoProxy = false;
if(file_exists($thumbpath.$thumbase.'.'.$thumbextension))
{
	$counter = checkName($thumbpath,$thumbase,$thumbextension,1);
	$thumbase .= '_'.$counter;
}
$width = 0;
$height = 0;
if($fileType == "images")
{
	$thumbCreated = true;
	createThumbFromCenter($path.$base.'.'.$extension,$thumbpath,$thumbase,$thumbextension,250,250);
	//createsquarethumb($path.$base.'.'.$extension,$thumbpath,$thumbase,$thumbextension,300);
	$temp = getimagesize($path.$base.'.'.$extension);
	$width = $temp[0]; $height = $temp[1];
}
else if($fileType == "videos" && extension_loaded("ffmpeg"))
{
	$thumbCreated = true;
	$moviepath = $path.$base.'.'.$extension;
	$movie = new ffmpeg_movie($moviepath, false);
	$tFrame = $movie->getFrame(1);
	$gdi = $tFrame->toGDImage();
	$thumbextension = "jpg"; 
	imagejpeg($gdi, $thumbpath.$thumbase . ".jpg");      
	$exportcmd = "ffmpeg -i " . $moviepath. "  -acodec libmp3lame -ab 48k -ac 2 -ar 44100 -f flv -b 1000k " . $thumbpath.$thumbase.".flv";
	exec($exportcmd,$output=array());
	$videoProxy = true;
}

//get playtime if video or audio
$playtime = 0;
$playtimeArr = getPlaytimeID3($path.$base.'.'.$extension);

if($playtimeArr[0] == true)
	$playtime = $result[1];
else
	$playtime = 0;

	
//try xmp	
$tmp = array();
$tmp['file'] = $path.$base.'.'.$extension;
$tags = getKeywords($tmp);
$size = shell_exec("ls -s " . $path.$base.'.'.$extension) *1024;		
header("Content-type: text/xml");
$out = "<result><name>" . $base.'.'.$extension."</name>";
$out .= "<extension>".$extension."</extension>";
$out .= "<size>".$size."</size>";
$out .= "<width>".$width."</width>";
$out .= "<height>".$height."</height>";
if($thumbCreated)
	$out .= "<thumb>". $thumbase.'.'.$thumbextension."</thumb>";
else
	$out .= "<thumb></thumb>";
if($videoProxy)
	$out .= "<video_proxy>" . $thumbase . ".flv</video_proxy>";
else
	$out .= "<video_proxy>false</video_proxy>"; 
$out .= "<playtime>".$playtime."</playtime>";
$out .= "<tags>".$tags."</tags>";	
$out .= "</result>";
echo $out;
?>