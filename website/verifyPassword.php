<?php
session_start();
include 'connection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SESSION['SessionID']) && isset($_POST['password'])) {
    $sessionID = $_SESSION['SessionID'];
    $inputPassword = $_POST['password'];

    // Δημιουργία κλήσης στη stored procedure VerifyPasswordBySession
    $sqlCallProcedure = "{CALL VerifyPasswordBySession(?, ?)}";
    $params = [$sessionID, $inputPassword];

    $stmt = sqlsrv_query($conn, $sqlCallProcedure, $params);

    if ($stmt === false) {
        echo "error";
    } else {
        echo "success";
    }

    sqlsrv_free_stmt($stmt);
    sqlsrv_close($conn);
    exit();
}

echo "error";
exit();
?>
