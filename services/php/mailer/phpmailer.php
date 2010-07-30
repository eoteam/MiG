<?php
require_once('../PHPMailer_v5.1/class.phpmailer.php');

$mail = new PHPMailer(true); //defaults to using php "mail()"; the true param means it will throw exceptions on errors, which we need to catch
//$mail->IsSendmail(); // telling the class to use SendMail transport
//$mail->IsMAIL(); // telling the class to use SMTP
$mail->IsSMTP();

try {
  $mail->AddAddress('luiza.gulyamova@gmail.com', 'Luiza Gulyamova');
  $mail->SetFrom('apricot.lu@gmail.com', 'First Last');
//  $mail->AddReplyTo('apricot.lu@gmail.com', 'First Last');

  
  
  
  $mail->Subject = 'PHPMailerTest';
  $mail->Body = "testing body";
  $mail->AltBody = 'To view the message, please use an HTML compatible email viewer!'; // optional - MsgHTML will create an alternate automatically
  $mail->MsgHTML(file_get_contents('../PHPMailer_v5.1/examples/contents.html'));
  //$mail->AddAttachment('../testinstaller/bg_image.jpeg', 'bg_image.jpeg');      // attachment
  
  
  /*
  $mail->Host       = "mail.gmail.com"; // SMTP server
  $mail->SMTPDebug  = 2;                     // enables SMTP debug information (for testing)
  $mail->SMTPAuth   = true;                  // enable SMTP authentication
  //$mail->SMTPSecure = "ssl";                 // sets the prefix to the servier
  $mail->Host       = "smtp.gmail.com";      // sets GMAIL as the SMTP server
  $mail->Port       = 465;                   // set the SMTP port for the GMAIL server
  */
  echo "before Send</p>\n";
  
  
  $mail->Send();
  echo "Message Sent</p>\n";
  
  $mail->ClearAddresses();
  $mail->ClearAttachments();
  
} catch (phpmailerException $e) {
  echo $e->errorMessage(); //Pretty error messages from PHPMailer
} catch (Exception $e) {
  echo $e->getMessage(); //Boring error messages from anything else!
}
?>