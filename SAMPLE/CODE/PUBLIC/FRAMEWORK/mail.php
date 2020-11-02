<?php function SendEmail(
    string $server,
    int $port,
    string $username,
    string $password,
    string $sender_email,
    string $receiver_email,
    string $subject,
    string $message
    )
{
    ini_set( 'SMTP', $server );
    ini_set( 'smtp_port', $port );
    ini_set( 'username', $username );
    ini_set( 'password', $password );
    ini_set( 'sendmail_from', $sender_email );
    ini_set( 'sendmail_path', $sender_email );

    mail(
        $receiver_email,
        $subject,
        $message,
        "Content-type: text/plain; charset=utf-8\r\n"
        . "From: " . $sender_email . "\r\n"
        );
}
