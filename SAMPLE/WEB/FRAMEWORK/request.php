<?php // -- FUNCTIONS

function GetRequest(
    )
{
    return $_SERVER[ 'REQUEST_URI' ];
}

// ~~

function GetPath(
    )
{
    static 
        $path = null;

    if ( is_null( $path ) )
    {
        $path = explode( '?', $_SERVER[ 'REQUEST_URI' ] )[ 0 ];

        if ( $path === '' )
        {
            $path = '/';
        }
    }

    return $path;
}

// ~~

function GetPathValueArray(
    string $path
    )
{
    if ( substr( $path, 0, 1 ) === '/' )
    {
        $path = substr( $path, 1 );
    }

    if ( substr( $path, -1 ) === '/' )
    {
        $path = substr( $path, 0, -1 );
    }

    if ( $path === '' )
    {
        return array();
    }
    else
    {
        return explode( '/', $path );
    }
}

// ~~

function IsGetRequest(
    )
{
    return $_SERVER[ 'REQUEST_METHOD' ] === 'GET';
}

// ~~

function IsPostRequest(
    )
{
    return $_SERVER[ 'REQUEST_METHOD' ] === 'POST';
}

// ~~

function IsPutRequest(
    )
{
    return $_SERVER[ 'REQUEST_METHOD' ] === 'PUT';
}

// ~~

function IsDeleteRequest(
    )
{
    return $_SERVER[ 'REQUEST_METHOD' ] === 'DELETE';
}

// ~~

function GetQuery(
    )
{
    return $_SERVER[ 'QUERY_STRING' ];
}

// ~~

function HasQueryValue(
    string $name
    )
{
    return isset( $_GET[ $name ] );
}

// ~~

function GetQueryValue(
    string $name
    )
{
    return $_GET[ $name ];
}

// ~~

function FindQueryValue(
    string $name,
    string $default_value
    )
{
    if ( isset( $_GET[ $name ] ) )
    {
        return $_GET[ $name ];
    }
    else
    {
        return $default_value;
    }
}

// ~~

function HasPostValue(
    string $name
    )
{
    return isset( $_POST[ $name ] );
}

// ~~

function GetPostValue(
    string $name
    )
{
    return $_POST[ $name ];
}

// ~~

function FindPostValue(
    string $name,
    string $default_value
    )
{
    if ( isset( $_POST[ $name ] ) )
    {
        return $_POST[ $name ];
    }
    else
    {
        return $default_value;
    }
}

// ~~

function HasCookieValue(
    string $name
    )
{
    return isset( $_COOKIE[ $name ] );
}

// ~~

function GetCookieValue(
    string $name
    )
{
    return $_COOKIE[ $name ];
}

// ~~

function FindCookieValue(
    string $name,
    string $default_value
    )
{
    if ( isset( $_COOKIE[ $name ] ) )
    {
        return $_COOKIE[ $name ];
    }
    else
    {
        return $default_value;
    }
}

// ~~

function GetIpAddress(
    )
{
    if ( isset( $_SERVER[ 'HTTP_CLIENT_IP' ] ) )
    {
        return $_SERVER[ 'HTTP_CLIENT_IP' ];
    }
    else if ( isset( $_SERVER[ 'HTTP_X_FORWARDED_FOR' ] ) )
    {
        return $_SERVER[ 'HTTP_X_FORWARDED_FOR' ];
    }
    else if ( isset( $_SERVER[ 'HTTP_X_FORWARDED' ] ) )
    {
        return $_SERVER[ 'HTTP_X_FORWARDED' ];
    }
    else if ( isset( $_SERVER[ 'HTTP_FORWARDED_FOR' ] ) )
    {
        return $_SERVER[ 'HTTP_FORWARDED_FOR' ];
    }
    else if ( isset( $_SERVER[ 'HTTP_FORWARDED' ] ) )
    {
        return $_SERVER[ 'HTTP_FORWARDED' ];
    }
    else if ( isset( $_SERVER[ 'REMOTE_ADDR' ] ) )
    {
        return $_SERVER[ 'REMOTE_ADDR' ];
    }
    else
    {
        return '0.0.0.0';
    }
}

// ~~

function GetBrowser(
    )
{
     $user_agent = $_SERVER[ 'HTTP_USER_AGENT' ];
     $part_array = explode( '/', str_replace( ' ', '/', $user_agent ) );

    if ( in_array( 'Edge', $part_array ) )
    {
        return 'Edge';
    }
    else if ( in_array( 'MSIE', $part_array )
              && !in_array( 'Opera', $part_array ) )
    {
        return 'MSIE';
    }
    else if ( in_array( 'Firefox', $part_array ) )
    {
        return 'Firefox';
    }
    else if ( in_array( 'Chrome', $part_array ) )
    {
        return 'Chrome';
    }
    else if ( in_array( 'Safari', $part_array ) )
    {
        return 'Safari';
    }
    else if ( in_array( 'Opera', $part_array ) )
    {
        return 'Opera';
    }
    else if ( in_array( 'Netscape', $part_array ) )
    {
        return 'Netscape';
    }
    else
    {
        return 'Unknown';
    }
}

// ~~

function IsId(
    $value
    )
{
    return
        is_numeric( $value )
        && $value == ( int ) $value
        && $value > 0;
}

// ~~

function Redirect(
    string $path
    )
{
    header( 'Location: ' . $path );
}