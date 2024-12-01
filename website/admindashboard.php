<?php
// Start the session to check if the user is logged in
session_start();
if (!isset($_SESSION['SessionID'])) {
    header("Location: login.php");
    exit();
}

// Check if the user is authorized to access this page (Admin only)
if ($_SESSION['UserTypeNumber'] != 1) {
    header("Location: login.php");
    exit();
}

// Include the database connection file
include 'connection.php';

// Handle POST requests for managing user approvals/rejections and applications
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['userId']) && isset($_POST['accept'])) {
        // Handle user approval/rejection
        $userId = intval($_POST['userId']);
        $accept = intval($_POST['accept']);

        if ($accept === 0 || $accept === 1) {
            $sqlCallProcedure = "{CALL AcceptOrRejectUser(?, ?)}";
            $params = [$userId, $accept];

            $stmt = sqlsrv_query($conn, $sqlCallProcedure, $params);

            if ($stmt === false) {
                echo "Error updating user status.";
                die(print_r(sqlsrv_errors(), true));
            } else {
                echo $accept === 1 ? "User approved successfully." : "User rejected successfully.";
            }

            sqlsrv_free_stmt($stmt);
            sqlsrv_close($conn);
            exit();
        }
    } elseif (isset($_POST['applicationId']) && isset($_POST['action']) && isset($_POST['reason'])) {
        // Handle application reactivation/approval/rejection
        $applicationId = intval($_POST['applicationId']);
        $action = intval($_POST['action']);
        $reason = $_POST['reason'];

        if ($action === 2) { // Reactivate
            $sqlCallProcedure = "{CALL ReactivateApplication(?, ?, ?)}";
            $params = [$applicationId, $reason, $_SESSION['SessionID']];

            $stmt = sqlsrv_query($conn, $sqlCallProcedure, $params);

            if ($stmt === false) {
                echo "Error while reactivating application.";
                die(print_r(sqlsrv_errors(), true));
            } else {
                echo "The application has been successfully reactivated.";
            }

            sqlsrv_free_stmt($stmt);
            sqlsrv_close($conn);
            exit();
        } elseif (in_array($action, [0, 1])) { // Accept or Reject
            $sqlCallProcedure = "{CALL AcceptOrRejectApplication(?, ?, ?, ?)}";
            $params = [$applicationId, $action, $reason, $_SESSION['SessionID']];

            $stmt = sqlsrv_query($conn, $sqlCallProcedure, $params);

            if ($stmt === false) {
                echo "Error while updating application status.";
                die(print_r(sqlsrv_errors(), true));
            } else {
                echo $action === 1 ? "The application has been successfully accepted." : "The application has been successfully rejected.";
            }

            sqlsrv_free_stmt($stmt);
            sqlsrv_close($conn);
            exit();
        }
    }

    echo "Invalid input.";
    exit();
}

// Fetch pending user requests using the stored procedure
$sqlUsers = "{CALL GetPendingUsers()}";
$stmtUsers = sqlsrv_query($conn, $sqlUsers);

if ($stmtUsers === false) {
    die(print_r(sqlsrv_errors(), true));
}

// Fetch all applications using the GetApplication stored procedure
$sqlApplications = "{CALL GetApplication()}";
$stmtApplications = sqlsrv_query($conn, $sqlApplications);

if ($stmtApplications === false) {
    die(print_r(sqlsrv_errors(), true));
}

$applications = [];
while ($app = sqlsrv_fetch_array($stmtApplications, SQLSRV_FETCH_ASSOC)) {
    $applications[] = $app;
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Account & Application Requests</title>
    <style>
/* General Styling */
/* General Styling */
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f0f8f5;
    margin: 0;
    padding: 0;
    color: #333;
}

/* Header Styling */
h1 {
    text-align: center;
    margin: 20px 0;
    color: #2e7d32;
    font-size: 2.5em;
}

/* Container */
.container {
    width: 90%;
    max-width: 1200px;
    margin: 30px auto;
    background: #ffffff;
    padding: 20px 30px;
    border-radius: 15px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* Table Styling */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    border-radius: 8px;
    overflow: hidden;
    background-color: #f9fff9;
}

th, td {
    padding: 15px;
    text-align: center;
    border: 1px solid #ddd;
}

th {
    background-color: #2e7d32;
    color: white;
    text-transform: uppercase;
    font-size: 1em;
}

td {
    font-size: 0.95em;
    color: #333;
}

/* Buttons Styling */
button {
    padding: 10px 15px;
    border: none;
    cursor: pointer;
    font-weight: bold;
    border-radius: 5px;
    font-size: 1em;
    transition: background-color 0.3s, transform 0.2s;
}

/* Approve Button */
.btn-approve {
    background-color: #9bcd46; /* Lime Green (Λαχανί) */
    color: white;
}
.btn-approve:hover {
    background-color: #74c686;
    transform: scale(1.05);
}

/* Reject Button */
.btn-reject {
    background-color: #e63946; /* Red */
    color: white;
}
.btn-reject:hover {
    background-color: #cc2e3b;
    transform: scale(1.05);
}

/* Reactivate Button */
.btn-reactivate {
    background-color: #17a2b8;
    color: white;
}
.btn-reactivate:hover {
    background-color: #138496;
    transform: scale(1.05);
}

/* Logout and Reports Buttons */
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
    left: 20px;
    background-color: #007bff;
}

.reports-btn:hover {
    background-color: #0056b3;
}

/* Responsive Table */
@media (max-width: 768px) {
    table, th, td {
        font-size: 0.85em;
    }
    .container {
        padding: 15px;
    }
}


    </style>
    <script>
        function handleRequest(applicationId, action) {
            const reason = action !== 2 ? prompt("Παρακαλώ εισάγετε έναν λόγο για αυτή την ενέργεια:") : null;
            if (!reason && action !== 2) {
                alert("Πρέπει να παρέχετε έναν λόγο.");
                return;
            }
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    alert(xhr.responseText);
                    location.reload();
                }
            };
            xhr.send(`applicationId=${applicationId}&action=${action}&reason=${encodeURIComponent(reason || '')}`);
        }
        function handleRequest(applicationId, action) {
    const reason = action !== 2 ? prompt("Please enter a reason for this action:") : prompt("Please enter a reason for reactivating:");
    if (!reason) {
        alert("You must provide a reason.");
        return;
    }
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            alert(xhr.responseText);
            location.reload();
        }
    };
    xhr.send(`applicationId=${applicationId}&action=${action}&reason=${encodeURIComponent(reason)}`);
}

function handleUserRequest(userId, accept) {
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            alert(xhr.responseText);
            location.reload();
        }
    };
    xhr.send(`userId=${userId}&accept=${accept}`);
}


    </script>
</head>
<body>
    <h1>Welcome to Admin Dashboard</h1>
    <div class="container">
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
            <td><?= htmlspecialchars($row['User_ID']) ?></td>
            <td><?= htmlspecialchars($row['First_Name']) ?></td>
            <td><?= htmlspecialchars($row['Last_Name']) ?></td>
            <td><?= htmlspecialchars($row['Username']) ?></td>
            <td><?= htmlspecialchars($row['Email']) ?></td>
            <td><?= htmlspecialchars($row['User_Type']) ?></td>
            <td><?= htmlspecialchars($row['Status']) ?></td>
            <td>
                <button class="btn-approve" onclick="handleUserRequest(<?= $row['User_ID'] ?>, 1)">Approve</button>
                <button class="btn-reject" onclick="handleUserRequest(<?= $row['User_ID'] ?>, 0)">Reject</button>
            </td>
        </tr>
    <?php endwhile; ?>
</tbody>
        </table>
    </div>
    <div class="container">
        <h2>All Applications</h2>
        <table>
    <thead>
        <tr>
            <th>Application ID</th>
            <th>Tracking Number</th>
            <th>Application Date</th>
            <th>Applicant ID</th>
            <th>Category Number</th>
            <th>Status</th>
            <th>Reactivation</th> <!-- Νέα Στήλη -->
            <th>Actions</th> <!-- Νέα Στήλη -->
        </tr>
    </thead>
    <tbody>
    <?php foreach ($applications as $app): ?>
        <tr>
            <td><?= htmlspecialchars($app['Application_ID']) ?></td>
            <td><?= htmlspecialchars($app['Tracking_Number']) ?></td>
            <td><?= htmlspecialchars($app['Application_Date']->format('Y-m-d')) ?></td>
            <td><?= htmlspecialchars($app['Applicant_ID']) ?></td>
            <td><?= htmlspecialchars($app['Category_Number']) ?></td>
            <td><?= htmlspecialchars($app['Current_Status']) ?></td>
            <td>
                <?php if ($app['Current_Status'] === 'rejected'): ?>
                    <button class="btn-reactivate" onclick="handleRequest(<?= $app['Application_ID'] ?>, 2)">Reactivate</button>
                <?php else: ?>
                    <span>Not applicable</span>
                <?php endif; ?>
            </td>
            <td>
                <?php if (in_array($app['Current_Status'], ['active', 'ordered', 'checked'])): ?>
                    <button class="btn-approve" onclick="handleRequest(<?= $app['Application_ID'] ?>, 1)">Accept</button>
                    <button class="btn-reject" onclick="handleRequest(<?= $app['Application_ID'] ?>, 0)">Reject</button>
                <?php else: ?>
                    <span>No actions available</span>
                <?php endif; ?>
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
