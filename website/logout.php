<?php
session_start();

// Check if the session is set
if (isset($_SESSION['SessionID'])) {
    // Include the database connection
    include 'connection.php';

    // Get the Session_ID from the session variable
    $sessionID = $_SESSION['SessionID'];

    // Prepare the SQL query to call the LogoutUser stored procedure
    $sql = "{CALL LogoutUser(?)}"; // Call LogoutUser stored procedure

    // Define parameters for the stored procedure
    $params = [
        [$sessionID, SQLSRV_PARAM_IN]  // Input parameter for Session_ID
    ];

    // Prepare the SQL statement
    $stmt = sqlsrv_prepare($conn, $sql, $params);

    // Check if the preparation succeeded
    if ($stmt === false) {
        die(print_r(sqlsrv_errors(), true));  // Handle any SQL errors
    }

    // Execute the prepared statement
    if (sqlsrv_execute($stmt)) {
        // Clear the session on the server side
        session_destroy();  // Destroy the session to log out the user

        // Redirect to the login page after logout
        header("Location: login.php");
        exit();
    } else {
        // Handle any errors that occurred during the stored procedure execution
        $sqlErrors = sqlsrv_errors();
        foreach ($sqlErrors as $error) {
            echo "Error: " . $error['message'];
        }
    }

    // Free the statement resource
    sqlsrv_free_stmt($stmt);

    // Close the connection
    sqlsrv_close($conn);
} else {
    // If no session is set, redirect to the login page
    header("Location: login.php");
    exit();
}
?>
