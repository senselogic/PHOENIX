<?php // -- FUNCTIONS

function SetTimeZone(
    string $time_zone
    )
{
    date_default_timezone_set( $time_zone );
}

// ~~

function GetCurrentTimestamp(
    )
{
    return time();
}

// ~~

function GetCurrentMillisecondTimestamp(
    )
{
     $part_array = explode( ' ', microtime() );

    return $part_array[ 1 ] . substr( $part_array[ 0 ] . '00000', 2, 3 );
}

// ~~

function GetCurrentMicrosecondTimestamp(
    )
{
     $part_array = explode( ' ', microtime() );

    return $part_array[ 1 ] . substr( $part_array[ 0 ] . '00000000', 2, 6 );
}

// ~~

function GetCurrentDateTimeSuffix(
    )
{
    return date( 'YmdHis' );
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

// ~~

function GetTimestampFromDateTime(
    string $date_time
    )
{
    return strtotime( $date_time );
}

// ~~

function GetDateTimeFromTimestampAndTimeZone(
    int64 $timestamp,
    string $time_zone
    )
{
     $date_time = new DateTime( '@' . $timestamp, new DateTimeZone( $time_zone ) );

    return $date_time->format( 'Y-m-d H:i:s' );
}

// ~~

function GetDateFromTimestampAndTimeZone(
    int64 $timestamp,
    string $time_zone
    )
{
     $date_time = new DateTime( '@' . $timestamp, new DateTimeZone( $time_zone ) );

    return $date_time->format( 'Y-m-d' );
}

// ~~

function GetTimeFromTimestampAndTimeZone(
    int64 $timestamp,
    string $time_zone
    )
{
     $date_time = new DateTime( '@' . $timestamp, new DateTimeZone( $time_zone ) );

    return $date_time->format( 'H:i:s' );
}
