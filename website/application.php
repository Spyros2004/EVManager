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
?>
