<?php
require_once "fileFunctions.php";

$path = "../../".$_REQUEST['directory'];
$thumbpath = "../../".$_REQUEST["thumbsDir"];
$fileType = $_REQUEST["fileType"];
$filename = sanitize_file_name($_FILES['Filedata']['name']);
$arr = getExtension('.', $filename, -2);
$extension = $arr[1];
$base = $arr[0];

move_uploaded_file($_FILES['Filedata']['tmp_name'], "./../../temporary/". $filename);
 
if(file_exists($path.$filename))   
{
	$counter = checkName($path,$base,$extension,1);
	$base .= '_'.$counter;
}
rename("./../../temporary/".$filename, $path.$base.'.'.$extension);

$thumbase = $base; 
$thumbextension = $extension;
$thumbCreated = false;
$videoProxy = false;
if(file_exists($thumbpath.$thumbase.'.'.$thumbextension))
{
	$counter = checkName($thumbpath,$thumbase,$thumbextension,1);
	$thumbase .= '_'.$counter;
}

if($fileType == "images")
{
	$thumbCreated = true;
	createthumb($path.$base.'.'.$extension,$thumbpath,$thumbase,$thumbextension,150,150);
	createsquarethumb($path.$base.'.'.$extension,$thumbpath,$thumbase,$thumbextension,300);
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
	$exportcmd = "ffmpeg -i " . $moviepath. "  -acodec libmp3lame -ab 48k -ac 2 -ar 22050 -f flv -b 1000k " . $thumbpath.$thumbase.".flv";
	exec($exportcmd,$output=array());
	$videoProxy = true;
}

//get playtime if video or audio
$playtime = 0;
$playtimeArr = getPlaytime($path.$base.'.'.$extension);

if($playtimeArr[0] == true)
	$playtime = $result[1];
else
	$playtime = 0;

	
//try xmp	
$tags = getTags($path.$base.'.'.$extension);
		
header("Content-type: text/xml");
$out = "<result><filename>" . $base.'.'.$extension."</filename>";
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