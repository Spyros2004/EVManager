<?php
session_start();
if (!isset($_SESSION['SessionID']) || $_SESSION['UserTypeNumber'] != 1) {
    header("Location: login.php");
    exit();
}

include 'connection.php';

$sqlCallProcedure = "{CALL UpdateExpiredApplications()}";
$stmt = sqlsrv_query($conn, $sqlCallProcedure);

if ($stmt === false) {
    echo "Σφάλμα κατά την ενημέρωση των αιτήσεων.";
    die(print_r(sqlsrv_errors(), true));
} else {
    echo "Οι αιτήσεις που έχουν λήξει ενημερώθηκαν επιτυχώς.";
}

sqlsrv_free_stmt($stmt);
sqlsrv_close($conn);
?>
