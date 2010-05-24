<?php
require_once('../getid3/getid3.php');


function createThumbFromCenter($file,$thumbDirectory,$base,$extension,$new_w,$new_h)
{
	if (preg_match("/jpg|jpeg/",strtolower($extension)))
		$src_img=imagecreatefromjpeg($file);
	if (preg_match("/png/",strtolower($extension))) {
		$src_img=imagecreatefrompng($file);
		imagealphablending($src_img, true); // setting alpha blending on
		imagesavealpha($src_img, true); // save alphablending setting (important)
	}
		
	if (preg_match("/gif/",strtolower($extension)))
		$src_img=imagecreatefromgif($file);
		
	// assuming that $img holds the image with which you are working
	$img_width  = imagesx($src_img);
	$img_height = imagesy($src_img);
	
	// New image size
	$width  = $new_w;
	$height = $new_h;
	
	// Starting point of crop
	$tlx = floor($img_width / 2) - floor ($width / 2);
	$tly = floor($img_height / 2) - floor($height / 2);
	
	// Adjust crop size if the image is too small
	if ($tlx < 0)
	{
	  $tlx = 0;
	}
	if ($tly < 0)
	{
	  $tly = 0;
	}
	
	if (($img_width - $tlx) < $width)
	{
	  $width = $img_width - $tlx;
	}
	if (($img_height - $tly) < $height)
	{
	  $height = $img_height - $tly;
	}
	
	$dst_img = imagecreatetruecolor($width, $height);
	imagecopy($dst_img, $src_img, 0, 0, $tlx, $tly, $width, $height);
	if (preg_match("/png/",strtolower($extension))) {
	
		imagepng($dst_img,$thumbDirectory.$base.'.'.$extension,9); 
		//imagealphablending($dst_img, true); // setting alpha blending on
		//imagesavealpha($dst_img, true); // save alphablending setting (important)
	}
		
	else if (preg_match("/jpg|jpeg/",strtolower($extension)))
		imagejpeg($dst_img,$thumbDirectory.$base.'.'.$extension,100); 
	else
		imagegif($dst_img,$thumbDirectory.$base.'.'.$extension);
	imagedestroy($dst_img); 
	imagedestroy($src_img); 
}
function createthumb($file,$thumbDirectory,$base,$extension,$new_w,$new_h)
{
	if (preg_match("/jpg|jpeg/",$extension))
		$src_img=imagecreatefromjpeg($file);
	if (preg_match("/png/",$extension))
		$src_img=imagecreatefrompng($file);
	if (preg_match("/gif/",$extension))
		$src_img=imagecreatefromgif($file);
	
	$old_x=imageSX($src_img);
	$old_y=imageSY($src_img);

	if ($old_x > $old_y) 
	{
		$thumb_w=$new_w;
		$thumb_h=$old_y*($new_h/$old_x);
	}
	if ($old_x < $old_y) 
	{
		$thumb_w=$old_x*($new_w/$old_y);
		$thumb_h=$new_h;
	}
	if ($old_x == $old_y) 
	{
		$thumb_w=$new_w;
		$thumb_h=$new_h;
	}
	$dst_img=ImageCreateTrueColor($thumb_w,$thumb_h);
	imagecopyresampled($dst_img,$src_img,0,0,0,0,$thumb_w,$thumb_h,$old_x,$old_y); 
	if (preg_match("/png/",$extension))
		imagepng($dst_img,$thumbDirectory.$base.'.'.$extension); 
	else if (preg_match("/jpg|jpeg/",$extension))
		imagejpeg($dst_img,$thumbDirectory.$base.'.'.$extension); 
	else
		imagegif($dst_img,$thumbDirectory.$base.'.'.$extension);
	imagedestroy($dst_img); 
	imagedestroy($src_img); 
	
}
function createsquarethumb($file,$thumbDirectory,$base,$extension,$thumbwidth)
{
	if (preg_match("/jpg|jpeg/",$extension))
		$src_img=imagecreatefromjpeg($file);
	if (preg_match("/png/",$extension))
		$src_img=imagecreatefrompng($file);
	if (preg_match("/gif/",$extension))
		$src_img=imagecreatefromgif($file);
	

	$origWidth = imagesx($src_img);
	$origHeight = imagesy($src_img);
	$x = ($origWidth - $thumbwidth)/2;
	$y = ($origHeight - $thumbwidth)/2;
																		
	$dst_img=ImageCreateTrueColor($thumbwidth,$thumbwidth);
	
	imagecopyresized($dst_img, $src_img, 0, 0, $x, $y, $thumbwidth, $thumbwidth, $thumbwidth, $thumbwidth);	
	
	if (preg_match("/png/",$extension))
		imagepng($dst_img,$thumbDirectory.$base.'_square.'.$extension); 
	else if (preg_match("/jpg|jpeg/",$extension))
		imagejpeg($dst_img,$thumbDirectory.$base.'_square.'.$extension); 
	else
		imagegif($dst_img,$thumbDirectory.$base.'_square.'.$extension);
	imagedestroy($dst_img); 
	imagedestroy($src_img); 
							
}
function parseXMP($file) {
	$result = array();
	if(file_exists($file)) {
		$size = shell_exec("du -k " . $file);
		$chars = preg_split("/[\s,]*\\\"([^\\\"]+)\\\"[\s,]*|" . "[\s,]*'([^']+)'[\s,]*|" . "[\s,]+/", $size, -1, PREG_SPLIT_OFFSET_CAPTURE);	
		$size = $chars[0][0];
		
		if($size < 2000) {	
				
			$fh = fopen($file,'rb') or die($php_errormsg);
			$content = fread($fh,filesize($file));
			header("Content-Type: text/plain");
			
			if(strpos($content, "<x:xmpmeta")) {
				
				$tempArr = explode("<x:xmpmeta",$content);
				$tempStr = "<x:xmpmeta" . $tempArr[1];
				$tempArr = explode("</x:xmpmeta>",$tempStr);
				$tempStr = $tempArr[0] . "</x:xmpmeta>";
				$result[0] = true;
				$result[1] = $tempStr;
			}
			else {
				$result[0] = false;
				$result[1] = "parsing failed";
			}
		}
		else {
				$result[0] = false;
				$result[1] = "file size is too big";
		}
//		try {
//			$myFile = "tmp.sh";
//			$fh = fopen("tmp.sh",'wb') or die($php_errormsg);
//			$execcmd = "./xmpcommand -compact get " . $file . " >> tmp.xml";
//			$fh = fopen($myFile, 'w') or die("can't open file");
//			fwrite($fh, $execcmd);
//			fclose($fh);
//			chmod($myFile,0777);
//			exec("./tmp.sh");
//			$fh = fopen("tmp.xml",'rb') or die($php_errormsg);
//			$content = fread($fh,filesize("tmp.xml"));			 
//			$result[0] = true;
//			$result[1] = $content;
//		}
//		catch (Exception $e) {
//			$result[0] = false;		
//			$result[1] = "FAILS";
//			return $result;
//		}
	}
	else {
		$result[0] = false;
		$result[1] = "file doesnt exist";
	}
	return $result;
}
function getTags($file) {
	$result = parseXMP($file);
	if($result[0] == true) {
		$xmp = $result[1];
		$tempArr = explode("<dc:subject>",$xmp);
		$tempArr = explode("</dc:subject>",$tempArr[1]);
		$tempArr = explode("<rdf:Bag>",$tempArr[0]);
		$tempArr = explode("</rdf:Bag>",trim($tempArr[1]));
		$tempArr = explode("<rdf:li>",trim($tempArr[0]));
		
		$tags = '';
		foreach($tempArr as $li) {
			if(trim($li) != '')
				$tags .= strip_tags(trim($li)) .',';
		}
		$tags = substr($tags,0,strlen($tags)-1);
		return $tags;
	}
	else
		return '';
}
// Analyze file	
function getPlaytime($file) {
	// Initialize getID3 engine
	$getid3 = new getID3;
	// Tell getID3() to use UTF-8 encoding - must send proper header as well.
	$getid3->encoding = 'UTF-8';
	$result = array();
	try {
		
	    $info = $getid3->Analyze($file);
	    if(isset($info["playtime_seconds"])) {
			$result[0] = true;
			$result[1] = $info["playtime_seconds"];
		}
	   	else {
			$result[0] = false;		
			$result[1] = "file format doesnt have playtime";
		}
		return $result;
	}
	catch (Exception $e) {
		$result[0] = false;		
		$result[1] = $e->message;
		return $result;
	}
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
function sanitize_file_name( $filename ) 
{
	$filename_raw = $filename;
	$special_chars = array("?", "[", "]", "/", "\\", "=", "<", ">", ":", ";", ",", "'", "\"", "&", "$", "#", "*", "(", ")", "|", "~", "`", "!", "{", "}", chr(0));
	$filename = str_replace($special_chars, '', $filename);
	$filename = preg_replace('/[\s-]+/', '-', $filename);
	$filename = trim($filename, '.-_');

	// Split the filename into a base and extension[s]
	$parts = explode('.', $filename);

	return $filename;
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
?>