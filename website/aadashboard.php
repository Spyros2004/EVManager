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

// Handle search form submission
if (isset($_POST['search'])) {
    $identification = trim($_POST['identification']);
    $trackingNumber = trim($_POST['trackingNumber']);
    $fullName = ''; // Output parameter
    $applicationDate = ''; // Output parameter
    $categoryNumber = ''; // Output parameter for category

    
        // Call the stored procedure
        $sql = "{CALL dbo.GetApplicationDetailsByIdentification(?, ?, ?, ?, ?)}";
        $params = [
            [&$identification, SQLSRV_PARAM_IN],
            [&$trackingNumber, SQLSRV_PARAM_IN],
            [&$fullName, SQLSRV_PARAM_OUT],
            [&$applicationDate, SQLSRV_PARAM_OUT],
            [&$categoryNumber, SQLSRV_PARAM_OUT]
        ];

        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            // Handle SQL errors
            $sqlErrors = sqlsrv_errors();
            foreach ($sqlErrors as $error) {
                $errorMessage .= htmlspecialchars($error['message']) . "<br>";
            }
        } else {
            if (!empty($fullName) && !empty($applicationDate)) {
                $applicationDetails = [
                    'FullName' => $fullName,
                    'ApplicationDate' => $applicationDate,
                    'TrackingNumber' => $trackingNumber,
                    'CategoryNumber' => $categoryNumber
                ];
                $successMessage = "Application found!";
            } else {
                $errorMessage = "No active application found for the provided details.";
            }
        
    }
}

// Handle add car order form submission
if (isset($_POST['addOrder'])) {
    $trackingNumber = trim($_POST['trackingNumber']);
    $vehicleDate = $_POST['vehicleDate'];
    $vehicleType = $_POST['vehicleType'];
    $co2Emissions = intval($_POST['co2Emissions']);
    $manufacturer = trim($_POST['manufacturer']);
    $model = trim($_POST['model']);
    $price = intval($_POST['price']);
    $document1 = trim($_POST['document1']);
    $document2 = trim($_POST['document2']);

    // Validate inputs
    if (empty($vehicleDate) || empty($vehicleType) || $co2Emissions > 50 || $price > 80000) {
        $errorMessage = "Please check your input values and try again.";
    } else {
        // Call the stored procedure with the correct number of parameters
        $sql = "{CALL dbo.AddVehicleAndDocument(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        $params = [
            $trackingNumber,
            $vehicleDate,
            $vehicleType,
            $co2Emissions,
            $manufacturer,
            $model,
            $price,
            $document1,
            $document2
        ];

        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            // Capture and display SQL errors
            $sqlErrors = sqlsrv_errors();
            foreach ($sqlErrors as $error) {
                $errorMessage .= htmlspecialchars($error['message']) . "<br>";
            }
        } else {
            $successMessage = "The vehicle and documents have been added successfully!";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search and Add Car Order</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
        }
        .form-container, .result-container {
            max-width: 600px;
            margin: 20px auto;
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
        }
        .success {
            color: green;
        }
    </style>
    <script>
        function uploadFile(inputId, outputId) {
            const category = "3"; // Example category
            const outputField = document.getElementById(outputId);
            const generatedFileName = "G" + category + "_" + Date.now() + ".pdf";
            outputField.value = generatedFileName;
            alert("File generated: " + generatedFileName);
        }
    </script>
</head>
<body>

<div class="form-container">
    <h1>Search Application</h1>
    <form method="POST">
        <label for="identification">Identification:</label>
        <input type="text" id="identification" name="identification" value="<?= htmlspecialchars($_POST['identification'] ?? '') ?>" required>

        <label for="trackingNumber">Tracking Number:</label>
        <input type="text" id="trackingNumber" name="trackingNumber" value="<?= htmlspecialchars($_POST['trackingNumber'] ?? '') ?>" required>

        <button type="submit" name="search">Search</button>
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
        <p><strong>Category Number:</strong> <?= htmlspecialchars($applicationDetails['CategoryNumber']) ?></p>

        <h2>Add Car Order</h2>
        <form method="POST">
            <input type="hidden" name="trackingNumber" value="<?= htmlspecialchars($applicationDetails['TrackingNumber']) ?>" required>

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

            <label for="document1">Document 1 (File Name or Identifier):</label>
            <input type="text" id="document1" name="document1" readonly>
            <button type="button" onclick="uploadFile('document1', 'document1')">Generate Document 1</button>

            <label for="document2">Document 2 (File Name or Identifier):</label>
            <input type="text" id="document2" name="document2" readonly>
            <button type="button" onclick="uploadFile('document2', 'document2')">Generate Document 2</button>

            <button type="submit" name="addOrder">Submit</button>
        </form>
    </div>
<?php endif; ?>

</body>
</html>
