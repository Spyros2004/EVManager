<?php
// Start the session to check if the user is logged in
session_start();
if (!isset($_SESSION['SessionID'])) {
    // Redirect to login page if the session is not set
    header("Location: login.php");
    exit();
}

// Check if the user is authorized to access this page (Admin only)
if ($_SESSION['UserTypeNumber'] != 1) {
    // Redirect unauthorized users to the login page
    header("Location: login.php");
    exit();
}

// Include the database connection file
include 'connection.php';

// Handle POST requests for approving/rejecting applications
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $applicationId = isset($_POST['applicationId']) ? intval($_POST['applicationId']) : null;
    $accept = isset($_POST['accept']) ? intval($_POST['accept']) : null;

    if ($applicationId !== null && ($accept === 0 || $accept === 1)) {
        // Determine the new status based on the action
        $newStatus = $accept === 1 ? 'approved' : 'rejected';

        // Prepare the SQL query to update the status
        $sqlUpdate = "UPDATE Application SET Current_Status = ? WHERE Application_ID = ?";
        $params = [$newStatus, $applicationId];

        // Execute the query
        $stmtUpdate = sqlsrv_query($conn, $sqlUpdate, $params);

        if ($stmtUpdate === false) {
            echo "An error occurred: ";
            die(print_r(sqlsrv_errors(), true));
        } else {
            echo $accept === 1 ? "Application approved successfully." : "Application rejected successfully.";
        }

        sqlsrv_free_stmt($stmtUpdate);
        sqlsrv_close($conn);
        exit();
    } else {
        echo "Invalid input.";
        exit();
    }
}

// Fetch pending user requests using the stored procedure
$sqlUsers = "{CALL GetPendingUsers()}";
$stmtUsers = sqlsrv_query($conn, $sqlUsers);

// Check if the query was successful for users
if ($stmtUsers === false) {
    die(print_r(sqlsrv_errors(), true));
}

// Fetch all applications using the GetApplication stored procedure
$sqlApplications = "{CALL GetApplication()}";
$stmtApplications = sqlsrv_query($conn, $sqlApplications);

// Check if the query was successful for applications
if ($stmtApplications === false) {
    die(print_r(sqlsrv_errors(), true));
}

// Prepare an array to hold pending applications
$pendingApplications = [];

// Loop through all fetched applications and filter by status
while ($app = sqlsrv_fetch_array($stmtApplications, SQLSRV_FETCH_ASSOC)) {
    if ($app['Current_Status'] === 'active') {
        $pendingApplications[] = $app;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Account & Application Requests</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e6ffe6;
            margin: 0;
            padding: 0;
        }
        .logout-btn, .reports-btn {
            position: absolute;
            top: 20px;
            padding: 10px 20px;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .logout-btn {
            right: 20px;
            background-color: #dc3545;
        }
        .logout-btn:hover {
            background-color: #b52b32;
        }
        .reports-btn {
            left: 120px;
            background-color: #007bff;
        }
        .reports-btn:hover {
            background-color: #0056b3;
        }
        h1 {
            text-align: center;
            margin-top: 40px;
            color: #2e7d32;
            font-size: 2.5em;
        }
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto;
            background: #ffffff;
            padding: 30px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            border-radius: 15px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th {
            background-color: #388e3c;
            color: white;
            padding: 20px;
            text-transform: uppercase;
            font-size: 1em;
        }
        td {
            padding: 20px;
            text-align: center;
            background-color: #f1fff1;
            color: #333;
        }
        .action-btn {
            padding: 12px 20px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            border-radius: 10px;
            transition: background-color 0.3s, transform 0.2s;
            font-size: 1em;
        }
        .approve-btn {
            background-color: #28a745;
            color: white;
        }
        .approve-btn:hover {
            background-color: #218838;
            transform: scale(1.05);
        }
        .reject-btn {
            background-color: #ffbb33;
            color: #333;
        }
        .reject-btn:hover {
            background-color: #e0a800;
            transform: scale(1.05);
        }
    </style>
    <script>
        function handleApplication(applicationId, action) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    alert(xhr.responseText);
                    location.reload();
                }
            };
            var acceptFlag = (action === 'approve') ? 1 : 0;
            xhr.send("applicationId=" + applicationId + "&accept=" + acceptFlag);
        }
    </script>
</head>
<body>
    <button class="logout-btn" onclick="window.location.href='logout.php'">Logout</button>
    <button class="reports-btn" onclick="window.location.href='reports.php'">View Reports</button>
    <h1>Welcome to Admin Dashboard</h1>
    <div class="container">
        <!-- User Requests Section -->
        <h2>Pending User Requests</h2>
        <table>
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>User Type</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php while ($row = sqlsrv_fetch_array($stmtUsers, SQLSRV_FETCH_ASSOC)): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($row['User_ID']); ?></td>
                        <td><?php echo htmlspecialchars($row['First_Name']); ?></td>
                        <td><?php echo htmlspecialchars($row['Last_Name']); ?></td>
                        <td><?php echo htmlspecialchars($row['Username']); ?></td>
                        <td><?php echo htmlspecialchars($row['Email']); ?></td>
                        <td><?php echo htmlspecialchars($row['User_Type']); ?></td>
                        <td><?php echo htmlspecialchars($row['Status']); ?></td>
                        <td>
                            <button class="action-btn approve-btn" onclick="handleAction(<?php echo $row['User_ID']; ?>, 'approve')">Approve</button>
                            <button class="action-btn reject-btn" onclick="handleAction(<?php echo $row['User_ID']; ?>, 'reject')">Reject</button>
                        </td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </div>
    <div class="container">
        <!-- Application Requests Section -->
        <h2>Pending Application Requests</h2>
        <table>
            <thead>
                <tr>
                    <th>Application ID</th>
                    <th>Tracking Number</th>
                    <th>Application Date</th>
                    <th>Applicant ID</th>
                    <th>Category Number</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($pendingApplications as $app): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($app['Application_ID']); ?></td>
                        <td><?php echo htmlspecialchars($app['Tracking_Number']); ?></td>
                        <td><?php echo htmlspecialchars($app['Application_Date']); ?></td>
                        <td><?php echo htmlspecialchars($app['Applicant_ID']); ?></td>
                        <td><?php echo htmlspecialchars($app['Category_Number']); ?></td>
                        <td><?php echo htmlspecialchars($app['Current_Status']); ?></td>
                        <td>
                            <button class="action-btn approve-btn" onclick="handleApplication(<?php echo $app['Application_ID']; ?>, 'approve')">Approve</button>
                            <button class="action-btn reject-btn" onclick="handleApplication(<?php echo $app['Application_ID']; ?>, 'reject')">Reject</button>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
    <?php
    sqlsrv_free_stmt($stmtUsers);
    sqlsrv_free_stmt($stmtApplications);
    sqlsrv_close($conn);
    ?>
</body>
</html>
