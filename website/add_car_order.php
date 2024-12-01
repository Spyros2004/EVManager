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

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $trackingNumber = trim($_POST['trackingNumber']);
    $vehicleDate = $_POST['vehicleDate'];
    $vehicleType = $_POST['vehicleType'];
    $co2Emissions = intval($_POST['co2Emissions']);
    $manufacturer = trim($_POST['manufacturer']);
    $model = trim($_POST['model']);
    $price = intval($_POST['price']);
    $document = trim($_POST['document']); // File name or identifier

    // Call the stored procedure
    $sql = "{CALL AddVehicleAndDocument(?, ?, ?, ?, ?, ?, ?, ?)}";
    $params = [
        &$trackingNumber,
        &$vehicleDate,
        &$vehicleType,
        &$co2Emissions,
        &$manufacturer,
        &$model,
        &$price,
        &$document
    ];

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        // Capture errors thrown by the stored procedure
        $sqlErrors = sqlsrv_errors();
        foreach ($sqlErrors as $error) {
            $errorMessage .= "SQLSTATE: " . $error['SQLSTATE'] . "<br>";
            $errorMessage .= "Code: " . $error['code'] . "<br>";
            $errorMessage .= "Message: " . htmlspecialchars($error['message']) . "<br><br>";
        }
    } else {
        $successMessage = "The vehicle and document have been added successfully!";
    }
}

// Retrieve the tracking number from the query string
$trackingNumber = $_GET['trackingNumber'] ?? '';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Car Order</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-container input, .form-container select, .form-container button {
            width: 100%;
            margin: 10px 0;
            padding: 10px;
            font-size: 16px;
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
    <h1>Add Car Order</h1>

    <!-- Display error or success messages -->
    <?php if ($errorMessage): ?>
        <p class="error"><?= htmlspecialchars($errorMessage) ?></p>
    <?php elseif ($successMessage): ?>
        <p class="success"><?= htmlspecialchars($successMessage) ?></p>
    <?php endif; ?>

    <!-- Form -->
    <form method="POST">
        <input type="hidden" name="trackingNumber" value="<?= htmlspecialchars($trackingNumber) ?>" required>

        <label for="vehicleDate">Vehicle Date:</label>
        <input type="date" id="vehicleDate" name="vehicleDate" required>

        <label for="vehicleType">Vehicle Type:</label>
        <select id="vehicleType" name="vehicleType" required>
            <option value="pure-electric">Pure Electric</option>
            <option value="hybrid">Hybrid</option>
        </select>

        <label for="co2Emissions">CO2 Emissions (<= 50):</label>
        <input type="number" id="co2Emissions" name="co2Emissions" min="0" max="50" required>

        <label for="manufacturer">Manufacturer:</label>
        <input type="text" id="manufacturer" name="manufacturer" maxlength="50" required>

        <label for="model">Model:</label>
        <input type="text" id="model" name="model" maxlength="50" required>

        <label for="price">Price (0 - 80000):</label>
        <input type="number" id="price" name="price" min="0" max="80000" required>

        <label for="document">Document (File Name or Identifier):</label>
        <input type="text" id="document" name="document" maxlength="100" required>

        <button type="submit">Submit</button>
    </form>
</div>

</body>
</html>
