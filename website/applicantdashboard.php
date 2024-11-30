<?php
// Start the session
session_start();
if (!isset($_SESSION['SessionID'])) {
    // Redirect to login page if session not set
    header("Location: login.php");
    exit();
}

// Check if the user is authorized to access this page (Applicant only)
if ($_SESSION['UserTypeNumber'] != 4) {
    // Redirect unauthorized users to the login page
    header("Location: login.php");
    exit();
}

// Include the database connection
include 'connection.php';

// Get the session ID from the current session
$sessionID = $_SESSION['SessionID'];
var_dump($_SESSION['SessionID']); // This will help you see the SessionID value in the browser


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
    <title>Το Προφίλ Σου</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(to bottom, #f0f4f8, #d9e2ec);
            margin: 0;
            padding: 0;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background-color: #28a745; /* Changed to green */
            color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .welcome {
            font-size: 22px;
            font-weight: 700;
        }
        .header-buttons {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
            text-decoration: none;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .btn:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
        .btn.logout {
            background-color: #dc3545;
        }
        .btn.logout:hover {
            background-color: #c82333;
        }
        h1, h2 {
            text-align: center;
            color: #333;
        }
        .content {
            max-width: 1000px;
            margin: 40px auto;
            padding: 30px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            min-height: calc(100vh - 160px);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
            background-color: #f8f9fa;
            border-radius: 10px;
            overflow: hidden;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 15px;
            text-align: center;
        }
        th {
            background-color: #007BFF;
            color: white;
            font-weight: 700;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e1e7ee;
        }
        .no-applications {
            text-align: center;
            margin-top: 40px;
        }
        .no-applications a {
            color: #007BFF;
            text-decoration: none;
            font-weight: 700;
        }
        .no-applications a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    
    <div class="header">
        <div class="welcome">Καλωσήρθες, <?php echo htmlspecialchars($username); ?></div>
        <div class="header-buttons">
            <a href="logout.php" class="btn logout">Αποσύνδεση</a>
        </div>
    </div>

    <div class="content">
        <h1 style="font-size: 2.5em;">Το Προφίλ Σου</h1>
        
        <a href="makeapplication.php" class="btn" style="margin: 20px auto; display: block; width: fit-content; padding: 15px 30px; font-size: 1.2em;">Νέα Αίτηση</a>
        <br>
        <h1>Οι Αιτήσεις Σου</h1>
        <?php
      

      echo '<table>
      <thead style="background-color: #f0fff0 !important;">
          <tr>
              <th>Αριθμός Αίτησης</th>
              <th>Ημερομηνία Αίτησης</th>
              <th>Τρέχουσα Κατάσταση</th>
              <th>Περιγραφή Κατηγορίας</th>
          </tr>
      </thead>
      <tbody>';

// Check if there are any rows returned
if (sqlsrv_has_rows($stmtApplications)) {
  // Fetch and display data
  while ($row = sqlsrv_fetch_array($stmtApplications, SQLSRV_FETCH_ASSOC)) {
      echo "<tr>";
      echo "<td>" . htmlspecialchars($row['Tracking_Number']) . "</td>";
      echo "<td>" . htmlspecialchars($row['Application_Date']->format('Y-m-d')) . "</td>";
      echo "<td>" . htmlspecialchars($row['Current_Status']) . "</td>";
      echo "<td>" . htmlspecialchars($row['Category_Description']) . "</td>";
      echo "</tr>";
  }
} else {
  // No data, display a message in a table row
  echo '<tr><td colspan="4" class="no-data-message">
          Δεν έχετε καμία αίτηση ακόμα. <a href="makeapplication.php">Κάνε Αίτηση</a>
        </td></tr>';
}

// Close the table
echo '</tbody></table>';

        // Free the statement resource for applications query
        sqlsrv_free_stmt($stmtApplications);

        // Close the database connection
        sqlsrv_close($conn);
        ?>
    </div>
</body>
</html>
