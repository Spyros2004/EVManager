<?php
include 'connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['applicationId'])) {
    $applicationId = intval($_POST['applicationId']);

    // Prepare the stored procedure call for application details
    $sqlDetails = "{CALL GetFullApplicationDetails(?)}";
    $paramsDetails = [$applicationId];
    $stmtDetails = sqlsrv_query($conn, $sqlDetails, $paramsDetails);

    if ($stmtDetails === false) {
        echo "Πρόβλημα κατά την ανάκτηση των λεπτομερειών της αίτησης.";
        die(print_r(sqlsrv_errors(), true));
    }

    // Display application details
    echo "<div class='popup-content'>";
    echo "<h2>Λεπτομέρειες Αίτησης</h2>";

    if ($rowDetails = sqlsrv_fetch_array($stmtDetails, SQLSRV_FETCH_ASSOC)) {
        foreach ($rowDetails as $key => $value) {
            // Translate keys to Greek
            $translations = [
                'First_Name' => 'Όνομα',
                'Last_Name' => 'Επώνυμο',
                'Username' => 'Όνομα Χρήστη',
                'Email' => 'Ηλεκτρονική Διεύθυνση',
                'Applicant_ID' => 'Κωδικός Υποψήφιου',
                'Identification' => 'Αριθμός Ταυτότητας',
                'Company_Private' => 'Εταιρεία/Ιδιώτης',
                'Gender' => 'Φύλο',
                'BirthDate' => 'Ημερομηνία Γέννησης',
                'Telephone_Number' => 'Τηλέφωνο',
                'Address' => 'Διεύθυνση',
                'Application_ID' => 'Κωδικός Αίτησης',
                'Tracking_Number' => 'Αριθμός Παρακολούθησης',
                'Application_Date' => 'Ημερομηνία Αίτησης',
                'Current_Status' => 'Κατάσταση',
                'Category_Number' => 'Αριθμός Κατηγορίας',
                'Discarded_Car_License_Plate' => 'Πινακίδα Αποσυρμένου Οχήματος',
            ];
            $label = $translations[$key] ?? $key;

            // Handle DateTime objects
            if ($value instanceof DateTime) {
                $value = $value->format('Y-m-d'); // Format the date to a string
            }

            echo "<div class='popup-field'>";
            echo "<span class='popup-label'>" . htmlspecialchars($label) . ":</span>";
            echo "<span class='popup-value'>" . htmlspecialchars((string) $value) . "</span>";
            echo "</div>";
        }
    } else {
        echo "Δεν βρέθηκαν λεπτομέρειες για αυτήν την αίτηση.";
    }
    echo "</div>";

    sqlsrv_free_stmt($stmtDetails);

  // Prepare the stored procedure call for documents
$sqlDocuments = "{CALL GetDocumentsByApplicationID(?)}";
$paramsDocuments = [$applicationId];
$stmtDocuments = sqlsrv_query($conn, $sqlDocuments, $paramsDocuments);

if ($stmtDocuments === false) {
    echo "Πρόβλημα κατά την ανάκτηση των εγγράφων.";
    die(print_r(sqlsrv_errors(), true));
}

// Display documents
echo "<div class='popup-content'>";
echo "<h2>Έγγραφα Σχετικά με την Αίτηση</h2>";

$hasDocuments = false;
while ($rowDocuments = sqlsrv_fetch_array($stmtDocuments, SQLSRV_FETCH_ASSOC)) {
    $hasDocuments = true;

    echo "<div class='document-entry'>"; // Wrapper for each document entry

    echo "<div class='popup-field'>";
    echo "<span class='popup-label'>Τύπος Εγγράφου:</span>";
    echo "<span class='popup-value'>" . htmlspecialchars($rowDocuments['Document_Type']) . "</span>";
    echo "</div>";

    echo "<div class='popup-field'>";
    echo "<span class='popup-label'>Όνομα Χρήστη:</span>";
    echo "<span class='popup-value'>" . htmlspecialchars($rowDocuments['Username']) . "</span>";
    echo "</div>";

    echo "<div class='popup-field'>";
    echo "<span class='popup-label'>Διαδρομή Αρχείου:</span>";
    echo "<span class='popup-value'>" . htmlspecialchars($rowDocuments['URL']) . "</span>";
    echo "</div>";

    echo "</div>"; // Close the wrapper
}

if (!$hasDocuments) {
    echo "<p>Δεν υπάρχουν έγγραφα για αυτήν την αίτηση.</p>";
}

echo "</div>";

sqlsrv_free_stmt($stmtDocuments);


    // Prepare the stored procedure call for application log
    $sqlLog = "{CALL GetApplicationLog(?)}";
    $paramsLog = [$applicationId];
    $stmtLog = sqlsrv_query($conn, $sqlLog, $paramsLog);

    if ($stmtLog === false) {
        echo "Πρόβλημα κατά την ανάκτηση του ιστορικού της αίτησης.";
        die(print_r(sqlsrv_errors(), true));
    }

    // Display application log
    echo "<div class='popup-content'>";
    echo "<h2>Ιστορικό Αλλαγών Αίτησης</h2>";

    $hasLog = false;
    while ($rowLog = sqlsrv_fetch_array($stmtLog, SQLSRV_FETCH_ASSOC)) {
        $hasLog = true;
        echo "<div class='log-entry'>"; // Add a wrapper for each log entry

        echo "<div class='popup-field'>";
        echo "<span class='popup-label'>Ημερομηνία Αλλαγής:</span>";
        echo "<span class='popup-value'>" . htmlspecialchars($rowLog['Modification_Date']->format('Y-m-d H:i:s')) . "</span>";
        echo "</div>";

        echo "<div class='popup-field'>";
        echo "<span class='popup-label'>Νέα Κατάσταση:</span>";
        echo "<span class='popup-value'>" . htmlspecialchars($rowLog['New_Status']) . "</span>";
        echo "</div>";

        echo "<div class='popup-field'>";
        echo "<span class='popup-label'>Λόγος:</span>";
        echo "<span class='popup-value'>" . htmlspecialchars($rowLog['Reason']) . "</span>";
        echo "</div>";

        echo "<div class='popup-field'>";
        echo "<span class='popup-label'>Κωδικός Διαχειριστή:</span>";
        echo "<span class='popup-value'>" . htmlspecialchars($rowLog['Username']) . "</span>";
        echo "</div>";
        echo "</div>"; // Close the wrapper

    }

    if (!$hasLog) {
        echo "<p>Δεν υπάρχουν αλλαγές για αυτήν την αίτηση.</p>";
    }

    echo "</div>";

    sqlsrv_free_stmt($stmtLog);
    sqlsrv_close($conn);
}
?>
<!DOCTYPE html>
<html lang="el">
<head>
    <meta charset="UTF-8">
    <title>Λεπτομέρειες Αίτησης</title>
    <style>
        /* CSS for the modal content */
        .popup-content {
            margin-bottom: 20px;
        }

        .popup-field {
            margin-bottom: 10px;
        }

        .popup-label {
            font-weight: bold;
            display: inline-block;
            width: 200px; /* Adjust to align values */
        }

       /* Ensure long text like file paths wraps properly */
.popup-value {
    display: inline-block;
    margin-left: 10px;
    max-width: 100%; /* Ensures the value doesn't exceed the container's width */
    overflow-wrap: break-word; /* Forces text to break if it's too long */
    word-wrap: break-word; /* Fallback for older browsers */
    word-break: break-word; /* Break long words */
    white-space: pre-wrap; /* Preserves whitespace and allows wrapping */
}


        .log-entry {
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 15px;
            padding: 15px;
            background-color: #f9f9f9;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .popup-content h2 {
            margin-top: 20px;
            color: #2e7d32;
        }

        /* Document Entry Styling */
.document-entry {
    border: 1px solid #ddd;
    border-radius: 8px;
    margin-bottom: 15px;
    padding: 15px;
    background-color: #f9f9f9;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* Popup Content Headings */
.popup-content h2 {
    margin-top: 20px;
    color: #2e7d32;
}


    </style>
</head>
<body>
    <!-- Modal content will be dynamically added here -->
</body>
</html>
