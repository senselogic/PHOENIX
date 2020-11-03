<?php // -- FUNCTIONS

function GetDatabaseArticleArray(
    )
{
     $statement = GetDatabaseStatement( 'select Id, Title, Slug, Text, Image, Video, SectionSlug from ARTICLE' );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

     $article_array = [];

    while (  $article = $statement->fetchObject() )
    {
        $article->Id = ( int )( $article->Id );
        array_push( $article_array, $article );
    }

    return $article_array;
}

// ~~

function GetDatabaseArticleById(
    int $id
    )
{
     $statement = GetDatabaseStatement( 'select Id, Title, Slug, Text, Image, Video, SectionSlug from ARTICLE where Id = ? limit 1' );
    $statement->bindParam( 1, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

     $article = $statement->fetchObject();
    $article->Id = ( int )( $article->Id );

    return $article;
}

// ~~

function AddDatabaseArticle(
    string $title,
    string $slug,
    string $text,
    string $image,
    string $video,
    string $section_slug
    )
{
     $statement = GetDatabaseStatement( 'insert into ARTICLE ( Title, Slug, Text, Image, Video, SectionSlug ) values ( ?, ?, ?, ?, ?, ? )' );
    $statement->bindParam( 1, $title, PDO::PARAM_STR );
    $statement->bindParam( 2, $slug, PDO::PARAM_STR );
    $statement->bindParam( 3, $text, PDO::PARAM_STR );
    $statement->bindParam( 4, $image, PDO::PARAM_STR );
    $statement->bindParam( 5, $video, PDO::PARAM_STR );
    $statement->bindParam( 6, $section_slug, PDO::PARAM_STR );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

    return GetDatabaseAddedId( $statement );
}

// ~~

function SetDatabaseArticle(
    int $id,
    string $title,
    string $slug,
    string $text,
    string $image,
    string $video,
    string $section_slug
    )
{
     $statement = GetDatabaseStatement( 'update ARTICLE set Title = ?, Slug = ?, Text = ?, Image = ?, Video = ?, SectionSlug = ? where Id = ?' );
    $statement->bindParam( 1, $title, PDO::PARAM_STR );
    $statement->bindParam( 2, $slug, PDO::PARAM_STR );
    $statement->bindParam( 3, $text, PDO::PARAM_STR );
    $statement->bindParam( 4, $image, PDO::PARAM_STR );
    $statement->bindParam( 5, $video, PDO::PARAM_STR );
    $statement->bindParam( 6, $section_slug, PDO::PARAM_STR );
    $statement->bindParam( 7, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }
}

// ~~

function RemoveDatabaseArticleById(
    int $id
    )
{
     $statement = GetDatabaseStatement( 'delete from ARTICLE where Id = ?' );
    $statement->bindParam( 1, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }
}
