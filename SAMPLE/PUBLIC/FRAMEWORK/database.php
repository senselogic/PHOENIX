<?php // -- FUNCTIONS

function GetDatabaseConnection(
    )
{
    static 
        $connection = null;

    if ( is_null( $connection ) )
    {
        $connection
            = new PDO(
                  'mysql:host=' . DatabaseHost . ';dbname=' . DatabaseName,
                  DatabaseUserName,
                  DatabasePassword
                  );

        $connection->prepare( "set names 'utf8mb4'" )->execute();
    }

    return $connection;
}

// ~~

function GetDatabaseError(
    )
{
    return GetDatabaseConnection()->errorInfo();
}

// ~~

function GetDatabaseAddedId(
    )
{
    return GetDatabaseConnection()->lastInsertId();
}

// ~~

function GetDatabaseStatement(
    string $command
    )
{
    return GetDatabaseConnection()->prepare( $command );
}

// ~~

function GetDatabaseObject(
    $statement
    )
{
    return $statement->fetchObject();
}

// ~~

function GetDatabaseObjectArray(
    $statement
    )
{
     $object_array = [];

    while (  $object = $statement->fetchObject() )
    {
        array_push( $object_array, $object );
    }

    return $object_array;
}