#!/usr/bin/php
<?php 
/**
 * Configuration
 */
# email de l'expediteur
$email_from = 'raspberrypi.gard@gmail.com';
# email des destinataires
$email_dest = array('raspberrypi.gard@gmail.com'); 
 
function sendMail($email_dest, $subject, $content, $headers) {
    foreach($email_dest as $dest)
    {
        mail($dest, $subject, $content, $headers);
    }
}

//Argument N° 2 passé avec la page PHP 0 sujet OK et 1 sujet pas OK
if ($argv[2]==0){
	$subject = "Sauvegarde CloudVPS --> Hubic OK"; 
}else{
	$subject = "Sauvegarde CloudVPS --> ERREUR !!!";
}

//Argument N°1 passé avec la page PHP texte du message
$message_html = $argv[1];
$headers = "From: $email_from\n";
$headers .= "MIME-Version: 1.0\r\n";
$headers .= "Content-Type: text/html; charset=utf8\r\n";
sendMail($email_dest, $subject, $message_html, $headers);
?>
