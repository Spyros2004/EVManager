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

// Check if the user is authorized to access this page (Applicant only)
if ($_SESSION['UserTypeNumber'] != 4) {
    // Redirect unauthorized users to the login page
    header("Location: login.php");
    exit();
}

// Initialize messages
$errorMessage = '';
$successMessage = '';
$sponsorshipCategories = [];

// Fetch sponsorship categories using ShowSponsorships stored procedure
$sql = "{CALL ShowSponsorships()}";
$stmt = sqlsrv_query($conn, $sql);

if ($stmt === false) {
    // Handle SQL errors and display only the main error messages
    $sqlErrors = sqlsrv_errors();
    foreach ($sqlErrors as $error) {
        $mainMessage = preg_replace('/^.*\]\s*/', '', $error['message']); // Extract main message after last `]`
        $errorMessage .= htmlspecialchars($mainMessage) . "<br>";
    }
    die($errorMessage); // Stop execution if categories cannot be fetched
}

while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    $sponsorshipCategories[] = [
        'Category_Number' => $row['Category_Number'],
        'Description' => $row['Description']
    ];
}

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $categoryNumber = $_POST['category'];
    $licensePlate = isset($_POST['license_plate']) ? strtoupper(trim($_POST['license_plate'])) : null;
    $sessionID = $_SESSION['SessionID'];
    $trackingNumber = ''; // Output parameter
    $document = isset($_POST['document']) ? $_POST['document'] : null;

    // Categories that require a document
    $requiresDocumentCategories = [3, 5, 7];

    // Check if file upload is required and validate it
    if (in_array($categoryNumber, $requiresDocumentCategories) && empty($document)) {
        $errorMessage = "Το αρχείο είναι απαραίτητο για αυτή την κατηγορία.";
    }

    // If there are no validation errors, proceed with the stored procedure
    if (empty($errorMessage)) {
        $sql = "{CALL ApplyForSponsorship(?, ?, ?, ?, ?)}";
        $params = [
            [&$sessionID, SQLSRV_PARAM_IN],
            [&$categoryNumber, SQLSRV_PARAM_IN],
            [&$licensePlate, SQLSRV_PARAM_IN],
            [&$document, SQLSRV_PARAM_IN],
            [&$trackingNumber, SQLSRV_PARAM_OUT]
        ];

        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            // Handle SQL errors and display only the main error messages
            $sqlErrors = sqlsrv_errors();
            foreach ($sqlErrors as $error) {
                $mainMessage = preg_replace('/^.*\]\s*/', '', $error['message']); // Extract main message after last `]`
                $errorMessage .= htmlspecialchars($mainMessage) . "<br>";
            }
        } else {
            // Check if tracking number was returned
            if (!empty($trackingNumber)) {
                $successMessage = "Η αίτηση σας υποβλήθηκε επιτυχώς! Αριθμός παρακολούθησης: " . $trackingNumber;
                header("Location: applicantdashboard.php");
                exit();
            } else {
                $errorMessage = "Παρουσιάστηκε σφάλμα κατά την επεξεργασία της αίτησης.";
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="el">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Υποβολή Αίτησης</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #e6f7ff, #ffffff);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
    width: 90%;
    max-width: 800px; /* Αυξήστε το μέγιστο πλάτος */
    background: #ffffff;
    padding: 40px 50px; /* Αυξήστε τα περιθώρια */
    border-radius: 15px; /* Ελαφρώς μεγαλύτερες γωνίες */
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3); /* Εντονότερη σκίαση */
    text-align: center;
}


        h2 {
            color: #0056b3;
            margin-bottom: 20px;
        }

        select, input[type="text"], input[type="submit"], button {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 14px;
        }

        select {
            background: #f9f9f9;
        }

        input[type="submit"] {
    background: #007bff; /* Μπλε χρώμα */
    color: white;
    border: none;
    cursor: pointer;
    padding: 10px 20px;
    border-radius: 5px;
    font-size: 16px;
    font-weight: bold;
    transition: background-color 0.3s ease, transform 0.3s ease;
}

input[type="submit"]:hover {
    background: #0056b3; /* Σκούρο μπλε κατά την αιώρηση */
    transform: translateY(-2px);
}
        button {
            background: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }
        .back-button {
    display: inline-block;
    background: #6c757d;
    color: white;
    padding: 10px 20px;
    border-radius: 5px;
    text-decoration: none;
    text-align: center;
    cursor: pointer;
}

.back-button:hover {
    background: #5a6268;
}

        .message {
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 5px;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
   
</head>
<body>
    <div class="container">
        <h2>Υποβολή Αίτησης Επιχορήγησης</h2>

        <!-- Display messages -->
        <?php if ($errorMessage): ?>
            <div class="message error">
                <strong>Σφάλμα:</strong> <?php echo $errorMessage; ?>
            </div>
        <?php endif; ?>
        <?php if ($successMessage): ?>
            <div class="message success">
                <strong>Επιτυχία:</strong> <?php echo htmlspecialchars($successMessage); ?>
            </div>
        <?php endif; ?>

        <!-- Application Form -->
        <form method="POST" action="" onsubmit="return confirmPasswordBeforeSubmit(this);">
    <label for="category">Επιλέξτε Κατηγορία:</label>
    <select name="category" id="category" required onchange="toggleFields()">
        <option value="">-- Επιλέξτε --</option>
        <?php foreach ($sponsorshipCategories as $category): ?>
            <option value="<?php echo $category['Category_Number']; ?>">
                <?php echo "Γ" . $category['Category_Number'] . " - " . htmlspecialchars($category['Description']); ?>
            </option>
        <?php endforeach; ?>
    </select>

    <div id="license-plate-field" style="display: none;">
        <label for="license_plate">Αριθμός Πινακίδας:</label>
        <input type="text" name="license_plate" id="license_plate" maxlength="6">
    </div>

    <div id="upload-file-field" style="display: none;">
        <button type="button" onclick="confirmWithPassword(uploadFile)">Δημιουργία Αρχείου</button>
        <input type="hidden" name="document" id="document">
    </div>

    <input type="submit" value="Υποβολή Αίτησης">
</form>


<a href="applicantdashboard.php" class="back-button">Πίσω στον Πίνακα Ελέγχου</a>

    </div>
    <script>
 function confirmPasswordBeforeSubmit(form) {
    const password = prompt("Παρακαλώ εισάγετε τον κωδικό σας:");

    if (!password) {
        alert("Δεν εισαγάγατε κωδικό. Η ενέργεια ακυρώθηκε.");
        return false; // Ακυρώνει την υποβολή
    }

    // AJAX αίτημα για επαλήθευση του κωδικού
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "verifyPassword.php", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function () {
        if (xhr.responseText === "success") {
            form.submit(); // Υποβάλλει τη φόρμα αν ο κωδικός είναι σωστός
        } else {
            alert("Λάθος κωδικός. Παρακαλώ δοκιμάστε ξανά.");
        }
    };
    xhr.send("password=" + encodeURIComponent(password));

    return false; // Περιμένουμε το αποτέλεσμα του AJAX και ακυρώνουμε την υποβολή
}



        function toggleFields() {
            const categorySelect = document.getElementById("category");
            const licensePlateField = document.getElementById("license-plate-field");
            const uploadFileField = document.getElementById("upload-file-field");
            const selectedCategory = parseInt(categorySelect.value);

            // Categories that require a document
            const requiresDocumentCategories = [3, 5, 7];

            // Show/hide license plate field for categories 1-4
            if (selectedCategory >= 1 && selectedCategory <= 4) {
                licensePlateField.style.display = "block";
            } else {
                licensePlateField.style.display = "none";
            }

            // Show/hide document field for specific categories
            if (requiresDocumentCategories.includes(selectedCategory)) {
                uploadFileField.style.display = "block";
            } else {
                uploadFileField.style.display = "none";
            }
        }

        function uploadFile() {
            const documentField = document.getElementById("document");
            const category = document.getElementById("category").value;

            if (!category) {
                alert("Παρακαλώ επιλέξτε κατηγορία.");
                return;
            }

            // Simulate document creation
            documentField.value = "G" + category + "_" + Date.now() + ".pdf";
            alert("Το αρχείο δημιουργήθηκε: " + documentField.value);
        }
    </script>
</body>
</html>
