<?php
// Start the session to check if the user is logged in
session_start();
if (!isset($_SESSION['SessionID'])) {
    // Redirect to login page if the session is not set
    header("Location: login.php");
    exit();
}

// Include the database connection file
include 'connection.php';

// Check if the request method is POST and handle the approve/reject action
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $userId = isset($_POST['userId']) ? intval($_POST['userId']) : null;
    $accept = isset($_POST['accept']) ? intval($_POST['accept']) : null;

    // Validate input
    if ($userId !== null && ($accept === 0 || $accept === 1)) {
        // Prepare SQL query to call the stored procedure
        $sql = "{CALL AcceptOrRejectUser(?, ?)}";
        $params = [
            [$userId, SQLSRV_PARAM_IN],
            [$accept, SQLSRV_PARAM_IN],
        ];

        // Execute the query
        $stmt = sqlsrv_query($conn, $sql, $params);

        // Check if the query was successful
        if ($stmt === false) {
            echo "An error occurred: ";
            die(print_r(sqlsrv_errors(), true));
        } else {
            if ($accept === 1) {
                echo "User approved successfully.";
            } else {
                echo "User rejected successfully.";
            }
        }

        // Free the statement resource
        sqlsrv_free_stmt($stmt);
        // Close the connection
        sqlsrv_close($conn);
        exit();
    } else {
        echo "Invalid input.";
        exit();
    }
}

// Fetch pending user requests using the stored procedure
$sql = "{CALL GetPendingUsers()}";
$stmt = sqlsrv_query($conn, $sql);

// Check if the query was successful
if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Account Requests</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e6ffe6;
            margin: 0;
            padding: 0;
        }
        .logout-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .logout-btn:hover {
            background-color: #b52b32;
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
            margin: 0 auto;
            background: #ffffff;
            padding: 30px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            border-radius: 15px;
            margin-top: 40px;
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
        function handleAction(userId, action) {
            // Send AJAX request to process the action
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    alert(xhr.responseText);
                    location.reload();
                }
            };
            var acceptFlag = (action === 'approve') ? 1 : 0;
            xhr.send("userId=" + userId + "&accept=" + acceptFlag);
        }
    </script>
</head>
<body>
    <button class="logout-btn" onclick="window.location.href='logout.php'">Logout</button>
    <h1>Welcome to Admin Dashboard</h1>
    <div class="container">
        <!-- Table to display pending account requests -->
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
                <?php while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)): ?>
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
    <?php
    // Free the statement resource
    sqlsrv_free_stmt($stmt);
    // Close the connection
    sqlsrv_close($conn);
    ?>
</body>
</html>
