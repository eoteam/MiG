<?php

/**
 * 
 * @author Mirko Bordjoski
 * @version Beta 1.0.0
 * @name APDF
 * 
 * http://candymandesign.blogspot.com
 * 
 */


if(!isset($_POST['paper']))
{	
	die('No valid data!');	
}



require_once('fpdf/fpdf.php');



//visitors ip
$ip = $_SERVER['REMOTE_ADDR']; 

//current id of the image
$img_id = rand(0,100000);
$img_x = 0;
$img_y = 0;
$img_width = 0;
$img_height = 0;

$txtx = 0;
$txty = 0;

$isCell = false;


//document data
$paper = stripslashes($_POST['paper']);


//creating pdf object
$pdf = new FPDF($_POST['orientation'], $_POST['unit'], $_POST['pageSize']);
$pdf->AddFont('Akkurat','','akkur.php');
$pdf->AddFont('Akkurat-LightItalic','','akkurligita.php');
$pdf->AddFont('AlbertinaMT-BoldItalic','','albermtbolita.php');

$pdf->SetMargins($_POST['left'], $_POST['top'], $_POST['right']);

$pdf->SetTitle($_POST['title']);
$pdf->SetAuthor($_POST['author']);
$pdf->SetCreator($_POST['creator']);
$pdf->SetKeywords($_POST['keywords']);
$pdf->SetSubject($_POST['subject']);






$reader = new XMLReader();
$reader->XML($paper);

while ($reader->read())
{
	if($reader->name == "page" && $reader->nodeType == XMLReader::ELEMENT)
	{
		$pdf->AddPage();
	}
	if($reader->name == "text" && $reader->nodeType == XMLReader::ELEMENT)
	{
		$fontType = $reader->getAttribute("fontType");
		$fontWeight = $reader->getAttribute("fontWeight");
		$fontSize = $reader->getAttribute("fontSize");		
		$pdf->SetFont($fontType,$fontWeight,$fontSize);
		
		$txtx = $reader->getAttribute("textx");
		$txty = $reader->getAttribute("texty");	
		
		$isCell = false;	
	}
	else if($reader->name == "cell" && $reader->nodeType == XMLReader::ELEMENT)
	{
		$fontType = $reader->getAttribute("fontType");
		$fontWeight = $reader->getAttribute("fontWeight");
		$fontSize = $reader->getAttribute("fontSize");		
		$pdf->SetFont($fontType,$fontWeight,$fontSize);
		
		$txtx = $reader->getAttribute("textx");
		$txty = $reader->getAttribute("texty");	
		
		$isCell = true;	
	}
	if($reader->nodeType == XMLReader::TEXT
      || $reader->nodeType == XMLReader::WHITESPACE
      || $reader->nodeType == XMLReader::SIGNIFICANT_WHITESPACE) 
      {
      	$pdf->SetXY($txtx, $txty);
      	if($isCell == false)
      	{
      		$pdf->Write(5,$reader->value);
      	}
      	else 
      	{
      		$pdf->MultiCell(0,5,$reader->value,0,"L");  
      	}      	    
    }
    if($reader->name == "image" && $reader->nodeType == XMLReader::ELEMENT)
    {
    	$img_x = $reader->getAttribute("x");
    	$img_y = $reader->getAttribute("y");
    	$img_width = $reader->getAttribute("width");
    	$img_height = $reader->getAttribute("height");
    }
	if($reader->nodeType == XMLReader::CDATA)
    {
    	$currentImg = 'temp/'.$ip.$img_id.'.jpg';
    	$fp = fopen($currentImg,'w');
    	fwrite($fp,base64_decode($reader->value));
    	fclose($fp);
    	
    	$pdf->Image($currentImg,$img_x,$img_y,$img_width,$img_height);
    	
    	unlink($currentImg);
    	$img_id++;		
    }
}



$reader->close();
$pdf->Output();

?>