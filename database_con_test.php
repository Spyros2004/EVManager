<?php
$serverName = "mssql.cs.ucy.ac.cy"; 
$uid = "ssachm02"; // Your username
$pwd = "c4up57Rd"; // Your password
$database = "ssachm02"; // Your database

$connectionInfo = array("Database" => $database, "Uid" => $uid, "PWD" => $pwd);
$conn = sqlsrv_connect($serverName, $connectionInfo);

if ($conn === false) {
    die(print_r(sqlsrv_errors(), true)); // Print any connection error
} else {
    echo "Connection successful!";
    sqlsrv_close($conn);
}
?>
