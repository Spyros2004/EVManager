<?php
include 'connection.php';
session_start();

// Check if user is logged in and authorized
if (!isset($_SESSION['SessionID']) || $_SESSION['UserTypeNumber'] != 2) {
    header("Location: login.php");
    exit();
}

// Function to verify the password before executing actions
function verifyPassword($conn, $sessionId, $inputPassword) {
    $sql = "{CALL VerifyPasswordBySession(?, ?)}";
    $params = [$sessionId, $inputPassword];
    $stmt = sqlsrv_query($conn, $sql, $params);
    if ($stmt === false) {
        return false;
    }
    sqlsrv_free_stmt($stmt);
    return true;
}

// Fetch ordered applications
$orderedApplications = [];
$sql = "{CALL GetOrderedApplications()}";
$stmt = sqlsrv_query($conn, $sql);
if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
}
while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    $orderedApplications[] = $row;
}
sqlsrv_free_stmt($stmt);

// Handle actions (Accept/Reject, Add/Edit Document, View Details)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $sessionId = $_SESSION['SessionID'];
    $inputPassword = $_POST['password'] ?? null;

    if (!$inputPassword || !verifyPassword($conn, $sessionId, $inputPassword)) {
        echo "<script>alert('Λανθασμένος κωδικός. Παρακαλώ δοκιμάστε ξανά.');</script>";
        exit();
    }

    if (isset($_POST['viewDetails'])) {
        $applicationId = $_POST['applicationId'];

        // Fetch full application details
        $sql = "{CALL GetFullApplicationDetails(?)}";
        $params = [$applicationId];
        $stmt = sqlsrv_query($conn, $sql, $params);
        if ($stmt === false) {
            die(print_r(sqlsrv_errors(), true));
        }
        $applicationDetails = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
        sqlsrv_free_stmt($stmt);

        // Fetch associated documents
        $sql = "{CALL GetDocumentsByApplicationID(?)}";
        $stmt = sqlsrv_query($conn, $sql, $params);
        if ($stmt === false) {
            die(print_r(sqlsrv_errors(), true));
        }
        $documents = [];
        while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
            $documents[] = $row;
        }
        sqlsrv_free_stmt($stmt);

    } elseif (isset($_POST['addDocument'])) {
        $applicationId = $_POST['applicationId'];
        $documentType = $_POST['documentType'];

        $sql = "{CALL AddDocument(?, ?, ?, NULL)}";
        $params = [$sessionId, $applicationId, $documentType];
        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            echo "<script>alert('Error adding document: " . print_r(sqlsrv_errors(), true) . "');</script>";
        } else {
            echo "<script>alert('Document added successfully');</script>";
        }
    } elseif (isset($_POST['updateDocument'])) {
        $documentId = $_POST['documentId'];

        $sql = "{CALL UpdateDocument(?, ?)}";
        $params = [$sessionId, $documentId];
        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            echo "<script>alert('Error updating document: " . print_r(sqlsrv_errors(), true) . "');</script>";
        } else {
            echo "<script>alert('Document updated successfully');</script>";
        }
    } elseif (isset($_POST['acceptReject'])) {
        $applicationId = $_POST['applicationId'];
        $action = $_POST['action']; // 0 = Reject, 1 = Accept
        $reason = $_POST['reason'];

        $sql = "{CALL AcceptOrRejectApplicationTOM(?, ?, ?, ?)}";
        $params = [$applicationId, $action, $reason, $sessionId];
        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            echo "<script>alert('Error processing application: " . print_r(sqlsrv_errors(), true) . "');</script>";
        } else {
            $status = $action == 1 ? 'accepted' : 'rejected';
            echo "<script>alert('Application has been $status successfully');</script>";
        }
    }
}
?>
<!DOCTYPE html>
<html lang="el">
<head>
    <meta charset="UTF-8">
    <title>Πίνακας Ελέγχου TOM</title>
    <style>
       body {
    font-family: Arial, sans-serif;
    background-color: #f0f8ff; /* Light blue background */
    color: #333; /* Darker text color for readability */
    margin: 0;
    padding: 0;
}
.welcome {
    font-size: 22px;
    font-weight: 700;
}

.header {
    display: flex;
    justify-content: center; /* Center the content horizontally */
    align-items: center; /* Center the content vertically */
    position: relative; /* Allow positioning for logout button */
    padding: 20px;
    background-color: #0056b3; /* Blue background */
    color: white;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.header h1 {
    font-size: 36px; /* Larger font size for the title */
    font-weight: 700; /* Bold text */
    margin: 0;
    color: white; /* Ensure title is visible on blue background */
    text-align: center;
}
.container {
    padding: 30px;
    max-width: 1600px; /* Increased max width */
    margin: 0 auto;
}

.applications-container {
    display: flex;
    gap: 30px;
    margin-top: 30px;
}

.applications-list {
    width: 60%; /* Increased width */
    height: 600px; /* Increased height */
    overflow-y: auto;
    border: 2px solid #ccc; /* Thicker border */
    background-color: white;
    border-radius: 10px; /* Larger border radius */
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Larger shadow */
}

.applications-list table {
    width: 100%;
    border-collapse: collapse;
    font-size: 18px; /* Larger table font size */
}

.applications-list th {
    background-color: #0056b3;
    color: white;
    padding: 15px;
    text-align: center;
    font-size: 18px; /* Larger font size */
}

.applications-list td {
    border: 1px solid #ccc;
    padding: 15px; /* Increased padding */
    text-align: center;
    font-size: 16px; /* Larger font size */
}

.applications-list tr:nth-child(even) {
    background-color: #f9f9f9;
}

.application-details {
    width: 70%; /* Increased width */
}

.details-box {
    border: 2px solid #ccc; /* Thicker border */
    border-radius: 12px; /* Larger border radius */
    background-color: white;
    padding: 25px; /* Increased padding */
    margin-top: 25px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Larger shadow */
}

.details-box h2 {
    margin: 0 0 15px;
    color: #0056b3;
    font-size: 22px; /* Larger font size */
}

.details-box table {
    width: 100%;
}

.details-box th,
.details-box td {
    text-align: left;
    padding: 10px; /* Increased padding */
    font-size: 18px; /* Larger font size */
}

.action-btn {
    margin: 8px 0;
    padding: 12px 20px; /* Larger button size */
    background-color: #007bff; /* Blue button */
    color: white;
    border: none;
    border-radius: 8px; /* Larger border radius */
    cursor: pointer;
    font-weight: bold;
    font-size: 18px; /* Larger font size */
}

.action-btn:hover {
    background-color: #0056b3;
}

input[type="text"], select {
    padding: 12px; /* Larger padding */
    width: calc(100% - 24px);
    margin: 8px 0;
    border: 1px solid #ccc;
    border-radius: 8px; /* Larger border radius */
    font-size: 18px; /* Larger font size */
}

.form-inline {
    display: flex;
    gap: 15px; /* Increased gap between elements */
    align-items: center;
}

ul {
    list-style-type: none;
    padding: 0;
}

ul li {
    padding: 10px 0; /* Increased padding */
    font-size: 18px; /* Larger font size */
}

ul li a {
    color: #007bff;
    text-decoration: none;
    font-size: 18px; /* Larger font size */
}

ul li a:hover {
    text-decoration: underline;
}

.header-buttons {
    position: absolute;
    right: 20px; /* Align logout button to the right */
    top: 50%;
    transform: translateY(-50%); /* Vertically center the logout button */
}

.btn.logout {
    background-color: #dc3545; /* Red for logout button */
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 20px;
    text-decoration: none;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.3s ease;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.btn.logout:hover {
    background-color: #c82333; /* Darker red on hover */
    transform: translateY(-2px);
}
    </style>
    <script>

function verifyPasswordBeforeSubmit(form) {
    // Prompt user for password
    const password = prompt("Παρακαλώ εισάγετε τον κωδικό σας:");
    
    if (password) {
        // Create a hidden input field for the password
        const passwordInput = document.createElement('input');
        passwordInput.type = 'hidden';
        passwordInput.name = 'password';
        passwordInput.value = password;

        // Append the password input to the form
        form.appendChild(passwordInput);
        return true; // Allow form submission
    } else {
        // Alert user if password is not provided
        alert("Δεν εισαγάγατε κωδικό. Η ενέργεια ακυρώθηκε.");
        return false; // Prevent form submission
    }
}
</script>

</head>
<body>
 
<div class="header">
    <header>
        <h1>Πίνακας Ελέγχου TOM</h1>
    </header>
    <div class="header-buttons">
        <a href="logout.php" class="btn logout">Αποσύνδεση</a>
    </div>
</div>


    <div class="container">
        <div class="applications-container">
            <!-- List of Ordered Applications -->
            <div class="applications-list">
                <table>
                    <thead>
                        <tr>
                            <th>Κωδικός Αίτησης</th>
                            <th>Κατάσταση</th>
                            <th>Επεξεργασία</th>
                            <th>Αποδοχή/Απόρριψη</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($orderedApplications as $application): ?>
                            <tr>
                                <td><?= htmlspecialchars($application['Application_ID']) ?></td>
                                <td><?= htmlspecialchars($application['Current_Status']) ?></td>
                                <td>
                                <form method="POST" onsubmit="return verifyPasswordBeforeSubmit(this);">
                                    <input type="hidden" name="applicationId" value="<?= htmlspecialchars($application['Application_ID']) ?>">
                                    <button type="submit" class="action-btn" name="viewDetails">Προβολή</button>
                                </form>

                                </td>
                                <td>
                                <form method="POST" onsubmit="return verifyPasswordBeforeSubmit(this);">
                                    <input type="hidden" name="applicationId" value="<?= htmlspecialchars($application['Application_ID']) ?>">
                                    <select name="action" required>
                                        <option value="1">Αποδοχή</option>
                                        <option value="0">Απόρριψη</option>
                                    </select>
                                    <input type="text" name="reason" placeholder="Αιτιολόγηση" required>
                                    <button type="submit" class="action-btn" name="acceptReject">Υποβολή</button>
                                </form>

                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>

            <!-- Application Details -->
            <div class="application-details">
            <?php if (isset($applicationDetails)): ?>
    <div class="details-box">
        <h2>Λεπτομέρειες Αίτησης</h2>
        <table>
            <?php foreach ($applicationDetails as $key => $value): ?>
                <tr>
                    <th>
                        <?php 
                        // Μετατροπή αγγλικών τίτλων σε ελληνικούς
                        $titles = [
                            'Application_ID' => 'Κωδικός Αίτησης',
                            'Username' => 'Όνομα Χρήστη',
                            'First_Name' => 'Όνομα',
                            'Last_Name' => 'Επώνυμο',
                            'Email' => 'Ηλεκτρονική Διεύθυνση',
                            'Applicant_ID' => 'Κωδικός Υποψήφιου',
                            'Identification' => 'Αριθμός Ταυτότητας',
                            'Company_Private' => 'Ιδιότητα',
                            'Gender' => 'Φύλο',
                            'BirthDate' => 'Ημερομηνία Γέννησης',
                            'Telephone_Number' => 'Τηλέφωνο',
                            'Address' => 'Διεύθυνση',
                            'Tracking_Number' => 'Αριθμός Παρακολούθησης',
                            'Application_Date' => 'Ημερομηνία Υποβολής',
                            'Current_Status' => 'Κατάσταση',
                            'Category_Number' => 'Αριθμός Κατηγορίας',
                            'Discarded_Car_License_Plate' => 'Πινακίδα Απορριφθέντος Οχήματος',
                        ];
                        echo htmlspecialchars($titles[$key] ?? $key); 
                        ?>:
                    </th>
                    <td>
                        <?php 
                        // Έλεγχος αν η τιμή είναι αντικείμενο DateTime
                        if ($value instanceof DateTime) {
                            echo htmlspecialchars($value->format('d-m-Y')); // Εμφάνιση ως ΗΗ-ΜΜ-ΕΕΕΕ
                        } else {
                            echo htmlspecialchars($value); // Εμφάνιση της τιμής
                        }
                        ?>
                    </td>
                </tr>
            <?php endforeach; ?>
        </table>
    </div>
    <div class="details-box">
        <h2>Έγγραφα</h2>
        <ul>
            <?php foreach ($documents as $doc): ?>
                <li>
                    <?= htmlspecialchars($doc['Document_Type']) ?>: 
                    <a href="javascript:void(0);" style="color: blue; text-decoration: underline; cursor: default;">Προβολή</a>
                    <form method="POST" style="display: inline;" onsubmit="return verifyPasswordBeforeSubmit(this);">
                        <input type="hidden" name="documentId" value="<?= htmlspecialchars($doc['Document_ID']) ?>">
                        <button type="submit" class="action-btn" name="updateDocument">Ενημέρωση</button>
                    </form>

                </li>
            <?php endforeach; ?>
        </ul>
    </div>
    <form method="POST" style="margin-top: 20px;" onsubmit="return verifyPasswordBeforeSubmit(this);">
        <input type="hidden" name="applicationId" value="<?= htmlspecialchars($applicationDetails['Application_ID']) ?>">
        <label for="documentType">Τύπος Εγγράφου:</label>
        <input type="text" id="documentType" name="documentType" required>
        <button type="submit" class="action-btn" name="addDocument">Προσθήκη Εγγράφου</button>
    </form>

<?php endif; ?>



            </div>
        </div>
    </div>
</body>
</html>
