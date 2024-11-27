<?php
// Start the session
session_start();
if (!isset($_SESSION['SessionID'])) {
    // Redirect to login page if session not set
    header("Location: login.php");
    exit();
}

// Include the database connection
include 'connection.php';

// Get the session ID from the current session
$sessionID = $_SESSION['SessionID'];

// Fetch the username
$username = ''; // Placeholder for the username

// Prepare SQL to call the stored procedure
$sqlUsername = "{CALL GetUsernameBySessionID(?, ?)}";

// Define parameters (output parameter for username is passed by reference)
$paramsUsername = [
    [$sessionID, SQLSRV_PARAM_IN],  // Input: session ID
    [&$username, SQLSRV_PARAM_OUT] // Output: username
];

// Prepare and execute the statement
$stmtUsername = sqlsrv_prepare($conn, $sqlUsername, $paramsUsername);
if ($stmtUsername === false) {
    die(print_r(sqlsrv_errors(), true));
}

if (!sqlsrv_execute($stmtUsername)) {
    die(print_r(sqlsrv_errors(), true));
}

// Free the statement resource for username query
sqlsrv_free_stmt($stmtUsername);

// Prepare SQL to call the stored procedure for applications
$sqlApplications = "{CALL GetApplicationsForUser(?)}";

// Define parameters
$paramsApplications = [$sessionID];

// Execute the query
$stmtApplications = sqlsrv_query($conn, $sqlApplications, $paramsApplications);

// Check for errors
if ($stmtApplications === false) {
    die(print_r(sqlsrv_errors(), true));
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applicant Dashboard</title>
    <style>
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            background-color: #f1f1f1;
            margin-bottom: 20px;
        }
        .welcome {
            font-size: 18px;
        }
        .logout-btn, .new-app-btn {
            padding: 10px 20px;
            background-color: red;
            color: white;
            border: none;
            cursor: pointer;
        }
        .new-app-btn {
            background-color: green;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        .no-applications {
            text-align: center;
            margin-top: 20px;
        }
        .no-applications a {
            color: blue;
            text-decoration: underline;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <div class="header">
        <div class="welcome">Welcome, <?php echo htmlspecialchars($username); ?></div>
        <button class="new-app-btn" onclick="window.location.href='makeapplication.php'">New Application</button>
        <button class="logout-btn" onclick="window.location.href='logout.php'">Logout</button>
    </div>

    <h1>Applicant Dashboard</h1>

    <h2>Your Applications</h2>
    <?php
    // Check if there are any rows returned
    if (sqlsrv_has_rows($stmtApplications)) {
        echo '<table>
                <thead>
                    <tr>
                        <th>Application ID</th>
                        <th>Application Date</th>
                        <th>Current Status</th>
                        <th>Category Description</th>
                    </tr>
                </thead>
                <tbody>';
        // Fetch and display data
        while ($row = sqlsrv_fetch_array($stmtApplications, SQLSRV_FETCH_ASSOC)) {
            echo "<tr>";
            echo "<td>" . htmlspecialchars($row['Application_ID']) . "</td>";
            echo "<td>" . htmlspecialchars($row['Application_Date']->format('Y-m-d')) . "</td>";
            echo "<td>" . htmlspecialchars($row['Current_Status']) . "</td>";
            echo "<td>" . htmlspecialchars($row['Category_Description']) . "</td>";
            echo "</tr>";
        }
        echo '</tbody></table>';
    } else {
        // No applications message
        echo '<div class="no-applications">
                <p>You do not have any applications yet.</p>
                <a href="makeapplication.php">Click here to make a new application</a>
              </div>';
    }

    // Free the statement resource for applications query
    sqlsrv_free_stmt($stmtApplications);

    // Close the database connection
    sqlsrv_close($conn);
    ?>
</body>
</html>
