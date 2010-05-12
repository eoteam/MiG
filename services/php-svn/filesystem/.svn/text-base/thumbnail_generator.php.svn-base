<?php 	
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
?>