<?php
// Include the database connection file
include 'connection.php';

// Start the session
session_start();

// Initialize error message variable
$errorMessage = '';

// Handle form submission and call the stored procedure for login
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Initialize the session ID variable for the output parameter
    $sessionID = ''; // Initialize it as an empty string

    // Prepare SQL query to call the stored procedure
    $sql = "{CALL LoginUser(?, ?, ?)}"; // Call LoginUser stored procedure

    // Define parameters for the stored procedure
    $params = [
        [$username, SQLSRV_PARAM_IN],     // Input parameter for username
        [$password, SQLSRV_PARAM_IN],     // Input parameter for password
        [&$sessionID, SQLSRV_PARAM_OUT]   // Output parameter for session ID (passed by reference)
    ];

    // Prepare the SQL statement
    $stmt = sqlsrv_prepare($conn, $sql, $params);

    // Check if the preparation succeeded
    if ($stmt === false) {
        die(print_r(sqlsrv_errors(), true));
    }

    // Execute the prepared statement
    if (sqlsrv_execute($stmt)) {
        // Check if session ID was returned (indicating a successful login)
        if (!empty($sessionID)) {
            // Login successful, store the session ID in PHP session
            $_SESSION['SessionID'] = $sessionID;

            // Redirect to the next page after successful login
            header("Location: dashboard.php");
            exit();
        } else {
            // If no session ID is returned, it means the login failed
            // Show the error message from the stored procedure
            $errorMessage = "Login failed. Please check your username and password.";
        }
    } else {
        // Handle SQL execution error (including custom error messages from the stored procedure)
        $sqlErrors = sqlsrv_errors();
        foreach ($sqlErrors as $error) {
            if ($error['code'] == '50001') {
                // This error corresponds to "Incorrect Password" error in stored procedure
                $errorMessage = "Incorrect username or password.";
            } elseif ($error['code'] == '50002') {
                // Handle other custom errors if any
                $errorMessage = "Account is pending approval. Please wait for admin approval.";
            } else {
                // Catch all other errors
                $errorMessage = "An unexpected error occurred. Please try again.";
            }
        }
    }

    // Free the statement resource
    sqlsrv_free_stmt($stmt);
}

// Close the connection
sqlsrv_close($conn);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>
<body>
    <h2>Login to your account</h2>

    <!-- Display any error message -->
    <?php if ($errorMessage): ?>
        <div style="color: red;">
            <strong>Error:</strong> <?php echo htmlspecialchars($errorMessage); ?>
        </div>
    <?php endif; ?>

    <!-- Login Form -->
    <form method="POST" action="">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" required><br><br>

        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required><br><br>

        <input type="submit" value="Login">
    </form>
</body>
</html>
