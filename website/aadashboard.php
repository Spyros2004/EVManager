<?php
// Start the session to check if the user is logged in
session_start();
if (!isset($_SESSION['SessionID'])) {
    // Redirect to login page if the session is not set
    header("Location: login.php");
    exit();
}

// Check if the user is authorized to access this page (AA only)
if ($_SESSION['UserTypeNumber'] != 2) {
    // Redirect unauthorized users to the login page
    header("Location: login.php");
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AA Dashboard</title>
    <style>
        .logout-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 10px 20px;
            background-color: red;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <button class="logout-btn" onclick="window.location.href='logout.php'">Logout</button>

    <h1>Welcome to AA Dashboard</h1>
    <!-- AA Dashboard Content -->

</body>
</html>
