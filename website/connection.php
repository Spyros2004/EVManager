<?php
$serverName = "mssql.cs.ucy.ac.cy";
$database = "ssachm02";
$uid = "ssachm02";
$pass = "c4up57Rd";

$connectionOptions = [
    "Database" => $database,
    "Uid" => $uid,
    "PWD" => $pass,  // Corrected to use $pass
    "CharacterSet" => "UTF-8" // Set character set to UTF-8
];

// Establish connection
$conn = sqlsrv_connect($serverName, $connectionOptions);  // Corrected to use $connectionOptions

if (!$conn) {
    die(print_r(sqlsrv_errors(), true));
}
?>
