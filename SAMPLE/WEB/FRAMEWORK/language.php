<?php // -- FUNCTIONS

function GetBrowserLanguageCode(
    array $valid_language_code_array,
    string $default_language_code = 'en'
    )
{
    if ( isset( $_SERVER[ 'HTTP_ACCEPT_LANGUAGE' ] ) )
    {
         $browser_language_code_array = explode( ',', str_replace( ';', ',', $_SERVER[ 'HTTP_ACCEPT_LANGUAGE' ] ) );

        foreach ( $browser_language_code_array as  $browser_language_code )
        {
            $browser_language_code = strtolower( substr( $browser_language_code, 0, 2 ) );

             $valid_language_code_index = array_search( $browser_language_code, $valid_language_code_array, true );

            if ( $valid_language_code_index !== false )
            {
                return $valid_language_code_array[ $valid_language_code_index ];
            }
        }
    }

    return $default_language_code;
}

// ~~

function ExtractLanguageCode(
    array & $path_value_array,
    array $valid_language_code_array,
    string $default_language_code = 'en'
    )
{
    if ( count( $path_value_array ) > 0 )
    {
         $language_code = $path_value_array[ 0 ];

        foreach ( $valid_language_code_array as  $valid_language_code )
        {
            if ( $language_code === $valid_language_code )
            {
                $path_value_array = array_slice( $path_value_array, 1 );

                return $language_code;
            }
        }
    }

    return $default_language_code;
}

// ~~

function GetTranslatedText(
    string $text,
    string $language_code,
    string $default_language_code = 'en'
    )
{
     $translated_text_array = explode( '¨', $text );
     $translated_text = $translated_text_array[ 0 ];

    if ( $language_code !== $default_language_code )
    {
        for (  $translated_text_index = 1;
              $translated_text_index < count( $translated_text_array );
              ++$translated_text_index )
        {
             $language_code_translated_text = $translated_text_array[ $translated_text_index ];

            if ( substr( $language_code_translated_text, 0, 2 ) === $language_code )
            {
                $translated_text = substr( $language_code_translated_text, 3 );

                break;
            }
        }
    }

    return str_replace( '[<', '<', str_replace( '>]', '>', $translated_text ) );
}

// ~~

function GetTranslatedNumber(
    string $number,
    string $decimal_separator
    )
{
    if ( $decimal_separator === ',' )
    {
        return str_replace( '.', ',', $number );
    }
    else
    {
        return $number;
    }
}
