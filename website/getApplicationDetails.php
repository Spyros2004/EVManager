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
        echo "<div class='popup-field'>";
        echo "<span class='popup-label'>Τύπος Εγγράφου:</span>";
        echo "<span class='popup-value'>" . htmlspecialchars($rowDocuments['Document_Type']) . "</span>";
        echo "</div>";
    }

    if (!$hasDocuments) {
        echo "<p>Δεν υπάρχουν έγγραφα για αυτήν την αίτηση.</p>";
    }

    echo "</div>";

    sqlsrv_free_stmt($stmtDocuments);
    sqlsrv_close($conn);
}
?>
