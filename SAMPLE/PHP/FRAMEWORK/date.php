<?php // -- FUNCTIONS

function GetCurrentTimestamp()
{
    return microtime();
}

// ~~

function GetCurrentDateTime(
    )
{
    return date( 'Y-m-d H:i:s' );
}

// ~~

function GetCurrentDate(
    )
{
    return date( 'Y-m-d' );
}

// ~~

function GetCurrentTime(
    )
{
    return date( 'H:i:s' );
}
