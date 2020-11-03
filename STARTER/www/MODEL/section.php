<?php // -- FUNCTIONS

function GetDatabaseSectionArray(
    )
{
     $statement = GetDatabaseStatement( 'select Id, Name, Slug from SECTION' );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

     $section_array = [];

    while (  $section = $statement->fetchObject() )
    {
        $section->Id = ( int )( $section->Id );
        array_push( $section_array, $section );
    }

    return $section_array;
}

// ~~

function GetDatabaseSectionById(
    int $id
    )
{
     $statement = GetDatabaseStatement( 'select Id, Name, Slug from SECTION where Id = ? limit 1' );
    $statement->bindParam( 1, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

     $section = $statement->fetchObject();
    $section->Id = ( int )( $section->Id );

    return $section;
}

// ~~

function AddDatabaseSection(
    string $name,
    string $slug
    )
{
     $statement = GetDatabaseStatement( 'insert into SECTION ( Name, Slug ) values ( ?, ? )' );
    $statement->bindParam( 1, $name, PDO::PARAM_STR );
    $statement->bindParam( 2, $slug, PDO::PARAM_STR );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

    return GetDatabaseAddedId( $statement );
}

// ~~

function SetDatabaseSection(
    int $id,
    string $name,
    string $slug
    )
{
     $statement = GetDatabaseStatement( 'update SECTION set Name = ?, Slug = ? where Id = ?' );
    $statement->bindParam( 1, $name, PDO::PARAM_STR );
    $statement->bindParam( 2, $slug, PDO::PARAM_STR );
    $statement->bindParam( 3, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }
}

// ~~

function RemoveDatabaseSectionById(
    int $id
    )
{
     $statement = GetDatabaseStatement( 'delete from SECTION where Id = ?' );
    $statement->bindParam( 1, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }
}