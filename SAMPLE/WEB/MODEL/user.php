<?php // -- FUNCTIONS

function GetDatabaseUserArray(
    )
{
     $statement = GetDatabaseStatement( 'select Id, Email, Pseudonym, Password, ItIsAdministrator from USER order by Email asc' );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

    return GetDatabaseObjectArray( $statement );
}

// ~~

function GetDatabaseUserById(
    int $id
    )
{
     $statement = GetDatabaseStatement( 'select Id, Email, Pseudonym, Password, ItIsAdministrator from USER where Id = ? limit 1' );
    $statement->bindParam( 1, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

    return GetDatabaseObject( $statement );
}

// ~~

function AddDatabaseUser(
    string $email,
    string $pseudonym,
    string $password,
    bool $it_is_administrator
    )
{
     $statement = GetDatabaseStatement( 'insert into USER ( Email, Pseudonym, Password, ItIsAdministrator ) values ( ?, ?, ?, ? )' );
    $statement->bindParam( 1, $email, PDO::PARAM_STR );
    $statement->bindParam( 2, $pseudonym, PDO::PARAM_STR );
    $statement->bindParam( 3, $password, PDO::PARAM_STR );
    $statement->bindParam( 4, $it_is_administrator, PDO::PARAM_BOOL );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }

    return GetDatabaseAddedId( $statement );
}

// ~~

function SetDatabaseUser(
    int $id,
    string $email,
    string $pseudonym,
    string $password,
    bool $it_is_administrator
    )
{
     $statement = GetDatabaseStatement( 'update USER set Email = ?, Pseudonym = ?, Password = ?, ItIsAdministrator = ? where Id = ?' );
    $statement->bindParam( 1, $email, PDO::PARAM_STR );
    $statement->bindParam( 2, $pseudonym, PDO::PARAM_STR );
    $statement->bindParam( 3, $password, PDO::PARAM_STR );
    $statement->bindParam( 4, $it_is_administrator, PDO::PARAM_BOOL );
    $statement->bindParam( 5, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }
}

// ~~

function RemoveDatabaseUserById(
    int $id
    )
{
     $statement = GetDatabaseStatement( 'delete from USER where Id = ?' );
    $statement->bindParam( 1, $id, PDO::PARAM_INT );

    if ( !$statement->execute() )
    {
        var_dump( $statement->errorInfo() );
    }
}
