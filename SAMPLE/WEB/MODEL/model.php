<?php // -- FUNCTIONS

function InflateDatabaseArticle(
    $article
    )
{
    $article->Section = GetDatabaseSectionById( $article->SectionId );
    $article->User = GetDatabaseUserById( $article->UserId );
}

// ~~

function InflateDatabaseArticleArray(
    array $article_array
    )
{
    foreach ( $article_array as  $article )
    {
        InflateDatabaseArticle( $article );
    }
}

// ~~

function GetDatabaseArticleArrayBySectionId(
    int $section_id
    )
{
     $statement = GetDatabaseStatement( 'select * from ARTICLE where SectionId = ? order by Date DESC' );
    $statement->bindParam( 1, $section_id, PDO::PARAM_INT );
    $statement->execute();

    return GetDatabaseObjectArray( $statement );
}

// ~~

function InflateDatabaseComment(
    $comment
    )
{
    $comment->Article = GetDatabaseArticleById( $comment->ArticleId );
    $comment->User = GetDatabaseUserById( $comment->UserId );
}

// ~~

function InflateDatabaseCommentArray(
    array $comment_array
    )
{
    foreach ( $comment_array as  $comment )
    {
        InflateDatabaseComment( $comment );
    }
}

// ~~

function GetDatabaseCommentArrayByArticleId(
    int $article_id
    )
{
     $statement = GetDatabaseStatement( 'select * from COMMENT where ArticleId = ? order by DateTime DESC' );
    $statement->bindParam( 1, $article_id, PDO::PARAM_INT );
    $statement->execute();

    return GetDatabaseObjectArray( $statement );
}

// ~~

function GetDatabaseUserByPseudonymAndPassword(
    string $pseudonym,
    string $password
    )
{
     $statement = GetDatabaseStatement( 'select * from USER where Pseudonym = ? and Password = ?' );
    $statement->bindParam( 1, $pseudonym, PDO::PARAM_STR );
    $statement->bindParam( 2, $password, PDO::PARAM_STR );
    $statement->execute();

    if ( $statement->rowCount() == 0 )
    {
        return null;
    }
    else
    {
        return GetDatabaseObject( $statement );
    }
}
