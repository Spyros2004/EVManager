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

    // Initialize the session ID and user type number variables for the output parameters
    $sessionID = ''; // Initialize it as an empty string
    $userTypeNumber = 0; // Initialize the user type number

    // Prepare SQL query to call the stored procedure
    $sql = "{CALL LoginUser(?, ?, ?, ?)}"; // Call LoginUser stored procedure

    // Define parameters for the stored procedure
    $params = [
        [$username, SQLSRV_PARAM_IN],     // Input parameter for username
        [$password, SQLSRV_PARAM_IN],     // Input parameter for password
        [&$sessionID, SQLSRV_PARAM_OUT],  // Output parameter for session ID (passed by reference)
        [&$userTypeNumber, SQLSRV_PARAM_OUT]  // Output parameter for user type number (passed by reference)
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
            // Login successful, store the session ID and user type number in PHP session
            $_SESSION['SessionID'] = $sessionID;
            $_SESSION['UserTypeNumber'] = $userTypeNumber;

            // Redirect to the appropriate dashboard based on the user type
            switch ($userTypeNumber) {
                case 1: // Admin
                    header("Location: admindashboard.php");
                    break;
                case 2: // TOM
                    header("Location: tomdashboard.php");
                    break;
                case 3: // AA
                    header("Location: aadashboard.php");
                    break;
                case 4: // Applicant
                    header("Location: applicantdashboard.php");
                    break;
                default:
                    $errorMessage = "Unknown user type. Please contact support.";
                    break;
            }
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
            if ($error['code'] == '50001'|| $error['code']=='50000') {
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
    <title>Σύνδεση για Αιτήσεις Επιχορηγήσεων</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: linear-gradient(to right, #e6ffe6, #f0fff0);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #fff;
            margin: 0;
        }
        .login-container {
            background: #ffffff;
            padding: 60px;
            border-radius: 20px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        h2 {
            margin-bottom: 40px; /* Μεγαλύτερο κενό από το αρχικό */
            color: #333;
            font-weight: 600;
        }
        input[type="text"],
        input[type="password"] {
            width: calc(100% - 20px);
            padding: 18px;
            margin: 25px 0; /* Περισσότερο κενό ανάμεσα στα πεδία */
            border: 1px solid #ddd;
            border-radius: 12px;
            font-size: 18px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            width: 100%;
            padding: 18px;
            margin-top: 30px; /* Προστέθηκε μεγαλύτερο κενό πάνω από το κουμπί */
            background: #28a745;
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 18px;
            transition: background 0.3s;
            box-sizing: border-box;
        }
        input[type="submit"]:hover {
            background: #218838;
        }
        .error-message {
            color: #ff4d4d;
            margin-bottom: 20px;
            background: #ffe5e5;
            padding: 10px;
            border-radius: 8px;
            font-weight: bold;
        }
        .login-container .input-group {
            position: relative;
        }
        .login-container .input-group i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            font-size: 21px;
        }
        input[type="text"],
        input[type="password"] {
            padding-left: 55px;
        }
        @media (max-width: 600px) {
            .login-container {
                padding: 30px;
            }
            input[type="text"],
            input[type="password"],
            input[type="submit"] {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Σύνδεση στο λογαριασμό σου</h2> <!-- Τίτλος λίγο πιο πάνω -->

        <!-- Display any error message -->
        <?php if ($errorMessage): ?>
            <div class="error-message">
                <strong>Error:</strong> <?php echo htmlspecialchars($errorMessage); ?>
            </div>
        <?php endif; ?>

        <!-- Login Form -->
        <form method="POST" action="">
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="username" id="username" placeholder="Username" required>
            </div>

            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" id="password" placeholder="Password" required>
            </div>

            <input type="submit" value="Login">
        </form>
        <br>
        <br>
         <!-- Create Account Link -->
         <p style="text-align: center; font-size: 0.9em; color: black;">
            <a href="signup.php" style="text-decoration: underline; font-weight: bold; color: black;">Δημιουργία Λογαριασμού</a>
        </p>
    </div>
</body>
</html>
