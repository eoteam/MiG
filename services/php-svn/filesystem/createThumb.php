<?php

require_once "../includes/functions.php";
require_once "../config/constants.php";
require_once "thumbnail_generator.php";

if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$params = $_GET;
	unset($params['mode']);
	
} else {

	$params = $_POST;
}
if(isset($params['name']) && isset($params['path']))
{
	$arr = getExtension('.',$params['name'],-2);
	$extension = $arr[1];
	$base = $arr[0];

	$name = $params['name'];
	$path = '../../files' . $params["path"]; //make sure its formatted
	$thumbPath = '../../files/migThumbs' . $params["path"];

	if(!file_exists($thumbPath))
	{	
		mkdir($thumbPath, 0777);
		chmod($thumbPath,0777);	
	}	
	$image = preg_match_all('/^.*\.(jpg|jpeg|JPG|JPEG|PNG|png|GIF|gif)$/i',$name, $arr2, PREG_PATTERN_ORDER);
	$video = preg_match_all('/^.*\.(mov|m4v|flv|f4v|mp4)$/i',$name, $arr3, PREG_PATTERN_ORDER);
	$thumbase = $base; 
	$thumbextension = $extension;
	$videoProxy = false;
	if(file_exists($thumbPath.$thumbase.'.'.$thumbextension))
	{
		$counter = checkName($thumbPath,$thumbase,$extension,1);
		$thumbase .= '_'.$counter;
	}	
	if($image == '1')
	{
		$size = shell_exec("du -k " . $path.$name);
		$chars = preg_split("/[\s,]*\\\"([^\\\"]+)\\\"[\s,]*|" . "[\s,]*'([^']+)'[\s,]*|" . "[\s,]+/", $size, -1, PREG_SPLIT_OFFSET_CAPTURE);	
		$size = $chars[0][0];
		
		if($size < 2000) // in KB
		{
			createthumb($path.$name,$thumbPath,$thumbase,$thumbextension,150,150);
			createsquarethumb($path.$name,$thumbPath,$thumbase,$thumbextension,300);			
		}
	}
	else if($video == '1' && extension_loaded("ffmpeg"))
	{	
		$movie = new ffmpeg_movie($path.$name, false);
		$tFrame = $movie->getFrame(1);
		$gdi = $tFrame->toGDImage(); 
		$thumbextension = "jpg";
		imagejpeg($gdi, $thumbPath.$thumbase . ".jpg");      
		$exportcmd = "ffmpeg -i " . $path.$name . "  -acodec libmp3lame -ab 48k -ac 2 -ar 22050 -f flv -b 1000k " . $thumbPath.$thumbase.".flv"; 
		exec($exportcmd,$output=array()); 
		$videoProxy = true;
	}
	header("Content-type: text/xml");
	$out  = "<result><success>true</success>";
	$out .= "<thumb>". $thumbase.'.'.$thumbextension."</thumb>";
	if($videoProxy)
		$out .= "<video_proxy>" . $thumbase . ".flv</video_proxy>";
	else 
		$out .= "<video_proxy>false</video_proxy>"; 
	$out .= "</result>";
	echo $out;	
}
else
{
	die ("Missing Parameters");
}
function checkName($t,$b,$e,$index)
{
	if(file_exists($t.$b.'_'.$index.'.'.$e))
	{
		$index++;
		return checkName($t,$b,$e,$index);
	}
	else
		return $index;
}
function getExtension($delim, $str, $lim = 1)
{
    if ($lim > -2) return explode($delim, $str, abs($lim));

    $lim = -$lim;
    $out = explode($delim, $str);
    if ($lim >= count($out)) return $out;

    $out = array_chunk($out, count($out) - $lim + 1);

    return array_merge(array(implode($delim, $out[0])), $out[1]);
}
?>