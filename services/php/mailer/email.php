<?php
/*
if (isset($_GET['mode']) && $_GET['mode'] == 'test') { // this is a test mode for passing params via GET

	$postData = $_GET;
	unset($postData['mode']);
	
} else {

	$postData = $_POST;
}

	$sendTo = $postData['recepients'];
	$subject = $postData['subject'];
	$headers = "From: " . $postData["sender"] . "<" . $postData["senderEmail"] .">\r\n";
	$headers .= "Reply-To: " . $postData["senderEmail"] . "\r\n";
	$headers .= "Return-path: " . $postData["senderEmail"] . "\r\n";
	$headers .= " MIME-Version: 1.0\n" . "Content-type: text/html; charset=iso-8859-1";
	
	$message = $postData['message'];
	return mail($sendTo, $subject, $message, $headers);
	*/
	
	
	$postData = array();

	$postData["sender"] = "First Last";
	$postData["senderEmail"] = "apricot.lu@gmail.com";
	
	$headers = "From: " . $postData["sender"] . "<" . $postData["senderEmail"] .">\r\n";
	//$headers .= "Reply-To: " . $postData["senderEmail"] . "\r\n";
	//$headers .= "Return-path: " . $postData["senderEmail"] . "\r\n";
	//$headers .= " MIME-Version: 1.0\n" . "Content-type: text/html; charset=iso-8859-1";

	
	mail("luiza.gulyamova@gmail.com", "Test Subject", "Test Message", $headers);
	
?>