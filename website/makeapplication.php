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

// Fetch sponsorship categories using the stored procedure (now includes Title and Description)
$sql = "{CALL GetSponsorshipCategory()}";
$stmt = sqlsrv_query($conn, $sql);

if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
}

while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    $sponsorshipCategories[] = [
        'Category_Number' => $row['Category_Number'],
        'Title' => $row['Title'],
        'Description' => $row['Description']
    ];
}

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $categoryNumber = $_POST['category'];
    $licensePlate = isset($_POST['license_plate']) ? $_POST['license_plate'] : null;
    $sessionID = $_SESSION['SessionID'];
    $document = null;

    // Check if file upload is required and uploaded
    if (isset($_FILES['document']) && $_FILES['document']['error'] == UPLOAD_ERR_OK) {
        $document = $_FILES['document']['name'];
        // Move the uploaded file to a permanent location (assuming 'uploads' folder exists)
        $uploadDir = 'uploads/';
        $uploadFilePath = $uploadDir . basename($document);
        if (!move_uploaded_file($_FILES['document']['tmp_name'], $uploadFilePath)) {
            $errorMessage = "Failed to upload the document.";
        }
    }

    if (empty($categoryNumber)) {
        $errorMessage = "Please select a sponsorship category.";
    } elseif (!$errorMessage) {
        // Initialize applicationID as an integer
        $applicationID = 0;

        // Call ApplyForSponsorship stored procedure
        $sql = "{CALL ApplyForSponsorship(?, ?, ?, ?, ?)}";
        $params = [
            [$sessionID, SQLSRV_PARAM_IN],             // Session ID
            [$categoryNumber, SQLSRV_PARAM_IN],        // Category Number
            [$licensePlate, SQLSRV_PARAM_IN],          // License Plate (optional for non-category 1-4)
            [$document, SQLSRV_PARAM_IN],              // Document file name (if applicable)
            [$applicationID, SQLSRV_PARAM_OUT]         // Output parameter for application ID
        ];

        // Execute the query
        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            $sqlErrors = sqlsrv_errors();
            foreach ($sqlErrors as $error) {
                if ($error['code'] == 50000) {
                    $errorMessage = "User is not an applicant.";
                } elseif ($error['code'] == 50001) {
                    $errorMessage = "No remaining positions in this category.";
                } elseif ($error['code'] == 50002) {
                    $errorMessage = "License plate is required for categories 1 through 4.";
                } elseif ($error['code'] == 50003) {
                    $errorMessage = "Document is required for this category.";
                } else {
                    $errorMessage = "An unexpected error occurred: " . $error['message'];
                }
            }
        } else {
            // Check if the application ID was returned
            if ($applicationID != 0) {
                $successMessage = "Your application has been submitted successfully! Application ID: " . $applicationID;
            } else {
                $errorMessage = "An error occurred while processing your application.";
            }
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
    <script>
        function toggleLicensePlateField() {
            const categorySelect = document.getElementById("category");
            const licensePlateField = document.getElementById("license-plate-field");
            const documentField = document.getElementById("document-field");
            const documentLabel = document.getElementById("document-label");
            const selectedCategory = parseInt(categorySelect.value);

            // Define the mapping between categories and document types
            const documentTypes = {
                3: 'Αρχείο - Βεβαίωση Τμήματος Κοινωνικής Ενσωμάτωσης ατόμων με αναπηρίες',
                7: 'Αρχείο - Βεβαίωση Τμήματος Κοινωνικής Ενσωμάτωσης ατόμων με αναπηρίες',
                5: 'Αρχείο - Ταυτότητα Πολυτέκνων'
            };

            // Show/hide license plate field for categories 1-4
            if (selectedCategory >= 1 && selectedCategory <= 4) {
                licensePlateField.style.display = "block";
            } else {
                licensePlateField.style.display = "none";
            }

            // Show/hide document field for categories 3, 5, 7 that require it
            if (documentTypes[selectedCategory]) {
                documentField.style.display = "block";
                documentLabel.textContent = documentTypes[selectedCategory];
            } else {
                documentField.style.display = "none";
            }
        }
    </script>
    <style>
        select {
            width: 200px;
            white-space: normal;
            word-wrap: break-word;
            overflow-wrap: break-word;
            max-width: 247ch;
        }
    </style>
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
    <form method="POST" action="" enctype="multipart/form-data">

        <label for="category">Select Sponsorship Category:</label>
        <br>
        <select name="category" id="category" required onchange="toggleLicensePlateField()">
            <option value="">-- Select --</option>
            <?php foreach ($sponsorshipCategories as $category): ?>
                <option value="<?php echo $category['Category_Number']; ?>">
                    <?php echo htmlspecialchars($category['Title'] . " - " . $category['Description']); ?>
                </option>
            <?php endforeach; ?>
        </select>
        <br><br>

        <div id="license-plate-field" style="display: none;">
            <label for="license_plate">License Plate Number:</label>
            <input type="text" name="license_plate" id="license_plate" maxlength="6">
            <br><br>
        </div>

        <div id="document-field" style="display: none;">
            <label for="document" id="document-label">Upload Required Document:</label>
            <input type="file" name="document" id="document">
            <br><br>
        </div>

        <input type="submit" value="Submit Application">
    </form>
</body>
</html>
