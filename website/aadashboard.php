
<?php
// Include database connection
include 'connection.php';

// Start session
session_start();

// Check if user is logged in
if (!isset($_SESSION['SessionID'])) {
    header("Location: login.php");
    exit();
}

// Check if the user is authorized to access this page (AA only)
if ($_SESSION['UserTypeNumber'] != 3) {
    header("Location: login.php");
    exit();
}

// Initialize messages
$errorMessage = '';
$successMessage = '';
$applicationDetails = [];

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $identification = trim($_POST['identification']);
    $trackingNumber = trim($_POST['trackingNumber']);
    $fullName = ''; // Output parameter
    $applicationDate = ''; // Output parameter

    // Validate input fields
    if (empty($identification) || empty($trackingNumber)) {
        $errorMessage = "Both Identification and Tracking Number are required.";
    } else {
        // Call the stored procedure
        $sql = "{CALL GetApplicationDetailsByIdentification(?, ?, ?, ?)}";
        $params = [
            [&$identification, SQLSRV_PARAM_IN],
            [&$trackingNumber, SQLSRV_PARAM_IN],
            [&$fullName, SQLSRV_PARAM_OUT],
            [&$applicationDate, SQLSRV_PARAM_OUT]
        ];

        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            // Handle SQL errors and display only the main error messages
            $sqlErrors = sqlsrv_errors();
            foreach ($sqlErrors as $error) {
                $mainMessage = preg_replace('/^.*\]\s*/', '', $error['message']); // Extract main message after last `]`
                $errorMessage .= htmlspecialchars($mainMessage) ;
            }
        } else {
            if (!empty($fullName) && !empty($applicationDate)) {
                $applicationDetails = [
                    'FullName' => $fullName,
                    'ApplicationDate' => $applicationDate,
                    'TrackingNumber' => $trackingNumber
                ];
                $successMessage = "Application found!";
            } else {
                $errorMessage = "No active application found for the provided details.";
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Application</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
        }
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-container input, .form-container button {
            width: 100%;
            margin: 10px 0;
            padding: 10px;
            font-size: 16px;
        }
        .result-container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background: #e9f7e9;
            border: 1px solid #d4edd4;
            border-radius: 8px;
        }
        .error {
            color: red;
            margin-top: 10px;
        }
        .success {
            color: green;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h1>Search Application</h1>
    <form method="POST">
        <label for="identification">Identification:</label>
        <input type="text" id="identification" name="identification" value="<?= htmlspecialchars($identification ?? '') ?>" required>

        <label for="trackingNumber">Tracking Number:</label>
        <input type="text" id="trackingNumber" name="trackingNumber" value="<?= htmlspecialchars($trackingNumber ?? '') ?>" required>

        <button type="submit">Search</button>
    </form>

    <?php if ($errorMessage): ?>
        <p class="error"><?= htmlspecialchars($errorMessage) ?></p>
    <?php elseif ($successMessage): ?>
        <p class="success"><?= htmlspecialchars($successMessage) ?></p>
    <?php endif; ?>
</div>

<?php if ($applicationDetails): ?>
    <div class="result-container">
        <h2>Application Details</h2>
        <p><strong>Full Name:</strong> <?= htmlspecialchars($applicationDetails['FullName']) ?></p>
        <p><strong>Application Date:</strong> <?= htmlspecialchars($applicationDetails['ApplicationDate']) ?></p>
        <button onclick="window.location.href='add_car_order.php?trackingNumber=<?= urlencode($applicationDetails['TrackingNumber']) ?>'">Add Car Order</button>
    </div>
<?php endif; ?>

</body>
</html>
