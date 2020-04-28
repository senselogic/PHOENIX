<?php // -- STATEMENTS

function ShowErrors(
    )
{
    ini_set( 'display_errors', 1 );
    error_reporting( E_ALL );
}

// ~~

function HideErrors(
    )
{
    ini_set( 'display_errors', 0 );
    error_reporting( 0 );
}

// ~~

function PrintError(
    $message
    )
{
    error_log( $message );
}
