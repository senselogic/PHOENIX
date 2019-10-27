<?php // -- FUNCTIONS

function GetBrowserLanguageCode(
    array $valid_language_code_array
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
    else
    {
        return $valid_language_code_array[ 0 ];
    }
}

// ~~

function GetTranslatedText(
    string $text,
    int $translated_text_index
    )
{
    
        

     $translated_text_array = explode( '¨', $text );

    if ( $translated_text_index < count( $translated_text_array ) )
    {
        $translated_text = $translated_text_array[ $translated_text_index ];
    }
    else
    {
        $translated_text = $translated_text_array[ 0 ];
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
