<?php
// Include the database connection file
include 'connection.php';

// Start the session
session_start();

// Check if the user is logged in
if (!isset($_SESSION['SessionID'])) {
    header("Location: login.php");
    exit();
}

// Initialize messages
$errorMessage = '';
$successMessage = '';
$sponsorshipCategories = [];

// Fetch sponsorship categories using the stored procedure
$sql = "{CALL GetSponsorshipCategory()}";
$stmt = sqlsrv_query($conn, $sql);

if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
}

while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    $sponsorshipCategories[] = $row;
}

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $categoryNumber = $_POST['category'];
    $sessionID = $_SESSION['SessionID'];

    if (empty($categoryNumber)) {
        $errorMessage = "Please select a sponsorship category.";
    } else {
        $applicationID = null;

        // Call ApplyForSponsorship stored procedure
        $sql = "{CALL ApplyForSponsorship(?, ?, ?)}";
        $params = [
            $sessionID,
            $categoryNumber,
            [&$applicationID, SQLSRV_PARAM_OUT]
        ];

        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            $sqlErrors = sqlsrv_errors();
            foreach ($sqlErrors as $error) {
                if ($error['code'] == 50000) {
                    $errorMessage = "User is not an applicant.";
                } elseif ($error['code'] == 50001) {
                    $errorMessage = "No remaining positions in this category.";
                } else {
                    $errorMessage = "An unexpected error occurred.";
                }
            }
        } else {
            $successMessage = "Your application has been submitted successfully! Application ID: " . $applicationID;
        }
    }
}

// Close the database connection
sqlsrv_close($conn);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Application</title>
</head>
<body>
    <h2>Apply for Sponsorship</h2>

    <!-- Display success or error message -->
    <?php if ($errorMessage): ?>
        <div style="color: red;">
            <strong>Error:</strong> <?php echo htmlspecialchars($errorMessage); ?>
        </div>
    <?php endif; ?>
    <?php if ($successMessage): ?>
        <div style="color: green;">
            <strong>Success:</strong> <?php echo htmlspecialchars($successMessage); ?>
        </div>
    <?php endif; ?>

    <!-- Application Form -->
    <form method="POST" action="">
        <label for="category">Select Sponsorship Category:</label>
        <select name="category" id="category" required>
            <option value="">-- Select --</option>
            <?php foreach ($sponsorshipCategories as $category): ?>
                <option value="<?php echo $category['Category_Number']; ?>">
                    <?php echo htmlspecialchars($category['Description'] . " - $" . $category['Amount']); ?>
                </option>
            <?php endforeach; ?>
        </select>
        <br><br>

        <input type="submit" value="Submit Application">
    </form>
</body>
</html>