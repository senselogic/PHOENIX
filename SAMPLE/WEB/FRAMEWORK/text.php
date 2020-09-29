<?php // -- FUNCTIONS

function GetCharacterCount(
    string $text
    )
{
    return strlen( $text );
}

// ~~

function HasPrefix(
    string $text,
    string $prefix
    )
{
     $text_character_count = strlen( $text );
     $prefix_character_count = strlen( $prefix );

    return
        $text_character_count >= $prefix_character_count
        && strncmp( $text, $prefix, $prefix_character_count ) === 0;
}

// ~~

function RemovePrefix(
    string $text,
    string $prefix
    )
{
     $text_character_count = strlen( $text );
     $prefix_character_count = strlen( $prefix );

    if ( $text_character_count >= $prefix_character_count
         && strncmp( $text, $prefix, $prefix_character_count ) === 0 )
    {
        return substr( $text, $prefix_character_count );
    }
    else
    {
        return $text;
    }
}

// ~~

function HasSuffix(
    string $text,
    string $suffix
    )
{
     $text_character_count = strlen( $text );
     $suffix_character_count = strlen( $suffix );

    return
        $text_character_count >= $suffix_character_count
        && substr_compare( $text, $suffix, $text_character_count - $suffix_character_count, $suffix_character_count ) === 0;
}

// ~~

function RemoveSuffix(
    string $text,
    string $suffix
    )
{
     $text_character_count = strlen( $text );
     $suffix_character_count = strlen( $suffix );

    if ( $text_character_count >= $suffix_character_count
         && substr_compare( $text, $suffix, $text_character_count - $suffix_character_count, $suffix_character_count ) === 0 )
    {
        return substr( $text, 0, $text_character_count - $suffix_character_count );
    }
    else
    {
        return $text;
    }
}
