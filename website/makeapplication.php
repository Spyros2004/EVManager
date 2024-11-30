<?php
// Συμπερίληψη του αρχείου σύνδεσης με τη βάση δεδομένων
include 'connection.php';

// Έναρξη συνεδρίας
session_start();

// Έλεγχος αν ο χρήστης είναι συνδεδεμένος
if (!isset($_SESSION['SessionID'])) {
    header("Location: login.php");
    exit();
}

// Αρχικοποίηση μηνυμάτων
$errorMessage = '';
$successMessage = '';
$sponsorshipCategories = [];

// Ανάκτηση κατηγοριών επιχορηγήσεων μέσω της αποθηκευμένης διαδικασίας
$sql = "{CALL GetSponsorshipCategory()}";
$stmt = sqlsrv_query($conn, $sql);

if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
}

while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    $sponsorshipCategories[] = [
        'Category_Number' => $row['Category_Number'],
        'Description' => $row['Description']
    ];
}

// Επεξεργασία της αίτησης
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $categoryNumber = $_POST['category'];
    $licensePlate = isset($_POST['license_plate']) ? $_POST['license_plate'] : null;
    $sessionID = $_SESSION['SessionID'];
    $trackingNumber = ''; // Αρχικοποίηση της εξόδου
    $document = isset($_POST['document']) ? $_POST['document'] : null;

    // Έλεγχος αν επιλέχθηκε κατηγορία
    if (empty($categoryNumber)) {
        $errorMessage = "Παρακαλώ επιλέξτε κατηγορία.";
    } else {
        // Κλήση της αποθηκευμένης διαδικασίας ApplyForSponsorship
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
            $sqlErrors = sqlsrv_errors();
            foreach ($sqlErrors as $error) {
                if ($error['code'] == 50000) {
                    $errorMessage = "Ο χρήστης δεν είναι αιτητής.";
                } elseif ($error['code'] == 50001) {
                    $errorMessage = "Δεν υπάρχουν διαθέσιμες θέσεις για αυτή την κατηγορία.";
                } elseif ($error['code'] == 50002) {
                    $errorMessage = "Η πινακίδα είναι απαραίτητη για τις κατηγορίες 1 έως 4.";
                } elseif ($error['code'] == 50003) {
                    $errorMessage = "Το αρχείο είναι απαραίτητο για αυτή την κατηγορία.";
                } else {
                    $errorMessage = "Παρουσιάστηκε απροσδόκητο σφάλμα: " . $error['message'];
                }
            }
        } else {
            // Έλεγχος αν επιστράφηκε αριθμός παρακολούθησης
            if (!empty($trackingNumber)) {
                $successMessage = "Η αίτηση σας υποβλήθηκε επιτυχώς! Αριθμός παρακολούθησης: " . $trackingNumber;
                header("Location: applicantdashboard.php"); // Ανακατεύθυνση μετά την επιτυχή υποβολή
                exit();
            } else {
                $errorMessage = "Παρουσιάστηκε σφάλμα κατά την επεξεργασία της αίτησης.";
            }
        }
    }
}

// Κλείσιμο της σύνδεσης με τη βάση
sqlsrv_close($conn);
?>


<!DOCTYPE html>
<html lang="el">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Υποβολή Αίτησης</title>
    <script>
        function toggleFields() {
            const categorySelect = document.getElementById("category");
            const licensePlateField = document.getElementById("license-plate-field");
            const uploadFileField = document.getElementById("upload-file-field");
            const selectedCategory = parseInt(categorySelect.value);

            // Κατηγορίες που απαιτούν αρχείο
            const requiresDocumentCategories = [3, 5, 7];

            // Εμφάνιση/Απόκρυψη πεδίου πινακίδας για κατηγορίες 1-4
            if (selectedCategory >= 1 && selectedCategory <= 4) {
                licensePlateField.style.display = "block";
            } else {
                licensePlateField.style.display = "none";
            }

            // Εμφάνιση/Απόκρυψη πεδίου αρχείου για συγκεκριμένες κατηγορίες
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

            // Δημιουργία αρχείου
            documentField.value = "G" + category + "_" + Date.now() + ".pdf";
            alert("Το αρχείο δημιουργήθηκε: " + documentField.value);
        }
    </script>
</head>
<body>
    <h2>Υποβολή Αίτησης Επιχορήγησης</h2>

    <!-- Εμφάνιση μηνυμάτων -->
    <?php if ($errorMessage): ?>
        <div style="color: red;">
            <strong>Σφάλμα:</strong> <?php echo htmlspecialchars($errorMessage); ?>
        </div>
    <?php endif; ?>
    <?php if ($successMessage): ?>
        <div style="color: green;">
            <strong>Επιτυχία:</strong> <?php echo htmlspecialchars($successMessage); ?>
        </div>
    <?php endif; ?>

    <!-- Φόρμα Αίτησης -->
    <form method="POST" action="">
        <label for="category">Επιλέξτε Κατηγορία:</label>
        <br>
        <select name="category" id="category" required onchange="toggleFields()">
            <option value="">-- Επιλέξτε --</option>
            <?php foreach ($sponsorshipCategories as $category): ?>
                <?php if (
                    in_array($category['Category_Number'], range(1, 8)) || 
                    in_array($category['Category_Number'], range(10, 14))
                ): ?>
                    <option value="<?php echo $category['Category_Number']; ?>">
                        <?php echo "Γ" . $category['Category_Number'] . " - " . htmlspecialchars($category['Description']); ?>
                    </option>
                <?php endif; ?>
            <?php endforeach; ?>
        </select>
        <br><br>

        <div id="license-plate-field" style="display: none;">
            <label for="license_plate">Αριθμός Πινακίδας:</label>
            <input type="text" name="license_plate" id="license_plate" maxlength="6">
            <br><br>
        </div>

        <div id="upload-file-field" style="display: none;">
            <button type="button" onclick="uploadFile()">Δημιουργία Αρχείου</button>
            <input type="hidden" name="document" id="document">
        </div>
        <br><br>

        <input type="submit" value="Υποβολή Αίτησης">
    </form>
</body>
</html>
