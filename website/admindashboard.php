<?php
// Start the session to check if the user is logged in
session_start();
if (!isset($_SESSION['SessionID'])) {
    header("Location: login.php");
    exit();
}

// Check if the user is authorized to access this page (Admin only)
if ($_SESSION['UserTypeNumber'] != 1) {
    header("Location: login.php");
    exit();
}

// Include the database connection file
include 'connection.php';

// Handle POST requests for managing user approvals/rejections and applications
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['userId']) && isset($_POST['accept'])) {
        // Handle user approval/rejection
        $userId = intval($_POST['userId']);
        $accept = intval($_POST['accept']);

        if ($accept === 0 || $accept === 1) {
            $sqlCallProcedure = "{CALL AcceptOrRejectUser(?, ?)}";
            $params = [$userId, $accept];

            $stmt = sqlsrv_query($conn, $sqlCallProcedure, $params);

            if ($stmt === false) {
                echo "Error updating user status.";
                die(print_r(sqlsrv_errors(), true));
            } else {
                echo $accept === 1 ? "User approved successfully." : "User rejected successfully.";
            }

            sqlsrv_free_stmt($stmt);
            sqlsrv_close($conn);
            exit();
        }
    } elseif (isset($_POST['applicationId']) && isset($_POST['action']) && isset($_POST['reason'])) {
        // Handle application reactivation/approval/rejection
        $applicationId = intval($_POST['applicationId']);
        $action = intval($_POST['action']);
        $reason = $_POST['reason'];

        if ($action === 2) { // Reactivate
            $sqlCallProcedure = "{CALL ReactivateApplication(?, ?, ?)}";
            $params = [$applicationId, $reason, $_SESSION['SessionID']];

            $stmt = sqlsrv_query($conn, $sqlCallProcedure, $params);

            if ($stmt === false) {
                echo "Error while reactivating application.";
                die(print_r(sqlsrv_errors(), true));
            } else {
                echo "The application has been successfully reactivated.";
            }

            sqlsrv_free_stmt($stmt);
            sqlsrv_close($conn);
            exit();
        } elseif (in_array($action, [0, 1])) { // Accept or Reject
            $sqlCallProcedure = "{CALL AcceptOrRejectApplication(?, ?, ?, ?)}";
            $params = [$applicationId, $action, $reason, $_SESSION['SessionID']];

            $stmt = sqlsrv_query($conn, $sqlCallProcedure, $params);

            if ($stmt === false) {
                echo "Error while updating application status.";
                die(print_r(sqlsrv_errors(), true));
            } else {
                echo $action === 1 ? "The application has been successfully accepted." : "The application has been successfully rejected.";
            }

            sqlsrv_free_stmt($stmt);
            sqlsrv_close($conn);
            exit();
        }
    }

    echo "Invalid input.";
    exit();
}

// Fetch pending user requests using the stored procedure
$sqlUsers = "{CALL GetPendingUsers()}";
$stmtUsers = sqlsrv_query($conn, $sqlUsers);

if ($stmtUsers === false) {
    die(print_r(sqlsrv_errors(), true));
}

// Fetch all applications using the GetApplication stored procedure
$sqlApplications = "{CALL GetApplication()}";
$stmtApplications = sqlsrv_query($conn, $sqlApplications);

if ($stmtApplications === false) {
    die(print_r(sqlsrv_errors(), true));
}

$applications = [];
while ($app = sqlsrv_fetch_array($stmtApplications, SQLSRV_FETCH_ASSOC)) {
    $applications[] = $app;
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Πίνακας Διαχειριστή - Διαχείριση Λογαριασμών και Αιτήσεων</title>
    <style>
/* General Styling */
body {
    font-family: 'Roboto', Arial, sans-serif;
    background-color: #f7f9fc;
    margin: 0;
    padding: 0;
    color: #333;
}

/* Header Styling */
h1 {
    text-align: center;
    margin: 20px 0;
    color: #0056b3;
    font-size: 2.5em;
    font-weight: bold;
}

/* Container */
.container {
    width: 90%;
    max-width: 1200px;
    margin: 30px auto;
    background: #ffffff;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

/* Table Styling */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    border-radius: 8px;
    overflow: hidden;
    background-color: #ffffff;
}

th, td {
    padding: 15px;
    text-align: center;
    border: 1px solid #ddd;
}

th {
    background-color: #0056b3;
    color: white;
    text-transform: uppercase;
    font-size: 1em;
}

td {
    font-size: 0.95em;
    color: #555;
}

tr:nth-child(even) {
    background-color: #f2f2f2;
}

tr:hover {
    background-color: #e9f5ff;
}

/* Buttons Styling */
button {
    padding: 10px 15px;
    border: none;
    cursor: pointer;
    font-weight: bold;
    border-radius: 5px;
    font-size: 1em;
    transition: background-color 0.3s, transform 0.2s;
    margin-bottom: 10px;
}

/* Approve Button */
.btn-approve {
    background-color: #28a745;
    color: white;
}
.btn-approve:hover {
    background-color: #218838;
    transform: scale(1.05);
}

/* Reject Button */
.btn-reject {
    background-color: #dc3545;
    color: white;
}
.btn-reject:hover {
    background-color: #c82333;
    transform: scale(1.05);
}

/* Reactivate Button */
.btn-reactivate {
    background-color: #17a2b8;
    color: white;
}
.btn-reactivate:hover {
    background-color: #138496;
    transform: scale(1.05);
}

/* Check Button */
.btn-check {
    background-color: #ffc107;
    color: #333;
}
.btn-check:hover {
    background-color: #e0a800;
    transform: scale(1.05);
}

/* Logout and Reports Buttons */
.logout-btn, .reports-btn {
    position: absolute;
    top: 20px;
    padding: 10px 20px;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: bold;
    transition: background-color 0.3s ease;
}

.logout-btn {
    right: 20px;
    background-color: #dc3545;
}

.logout-btn:hover {
    background-color: #c82333;
}

.reports-btn {
    left: 20px;
    background-color: #007bff;
}

.reports-btn:hover {
    background-color: #0056b3;
}

/* Responsive Table */
@media (max-width: 768px) {
    table, th, td {
        font-size: 0.85em;
    }
    .container {
        padding: 15px;
    }
}

/* Modal Background */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.5);
}

/* Modal Box */
.modal-box {
    background-color: #fff;
    margin: 10% auto;
    padding: 30px;
    border-radius: 15px;
    width: 60%;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    text-align: left;
}

/* Close Button */
.close {
    color: #aaa;
    float: right;
    font-size: 24px;
    font-weight: bold;
    cursor: pointer;
    margin-top: -10px;
    margin-right: -10px;
}

.close:hover,
.close:focus {
    color: #000;
    text-decoration: none;
}

/* Popup Content Styling */
.popup-content {
    padding: 10px 20px;
}

.popup-content h2 {
    text-align: center;
    color: #0056b3;
    margin-bottom: 20px;
    font-size: 1.5em;
    border-bottom: 2px solid #e6e6e6;
    padding-bottom: 10px;
}

.popup-field {
    display: flex;
    margin-bottom: 10px;
    flex-wrap: wrap;
}

.popup-label {
    font-weight: bold;
    color: #555;
    min-width: 250px;
    display: inline-block;
    margin-right: 10px;
}

.popup-value {
    color: #333;
    font-weight: normal;
}

.popup-field a {
    color: #007bff;
    text-decoration: none;
}

.popup-field a:hover {
    text-decoration: underline;
    color: #0056b3;
}

/* Responsive Modal */
@media (max-width: 768px) {
    .modal-box {
        width: 90%;
    }
}

    </style>
    <script>
        function handleRequest(applicationId, action) {
            const reason = action !== 2 ? prompt("Παρακαλώ εισάγετε έναν λόγο για αυτή την ενέργεια:") : null;
            if (!reason && action !== 2) {
                alert("Πρέπει να παρέχετε έναν λόγο.");
                return;
            }
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    alert(xhr.responseText);
                    location.reload();
                }
            };
            xhr.send(`applicationId=${applicationId}&action=${action}&reason=${encodeURIComponent(reason || '')}`);
        }
        function handleRequest(applicationId, action) {
    const reason = action !== 2 ? prompt("Please enter a reason for this action:") : prompt("Please enter a reason for reactivating:");
    if (!reason) {
        alert("You must provide a reason.");
        return;
    }
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            alert(xhr.responseText);
            location.reload();
        }
    };
    xhr.send(`applicationId=${applicationId}&action=${action}&reason=${encodeURIComponent(reason)}`);
}

function handleUserRequest(userId, accept) {
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            alert(xhr.responseText);
            location.reload();
        }
    };
    xhr.send(`userId=${userId}&accept=${accept}`);
}

function viewDetails(applicationId) {
        // AJAX call to fetch application details
        const xhr = new XMLHttpRequest();
        xhr.open("POST", "getApplicationDetails.php", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // Display details in the modal
                document.getElementById("modal-content").innerHTML = xhr.responseText;
                document.getElementById("modal").style.display = "block";
            }
        };

        xhr.send(`applicationId=${applicationId}`);
    }

    // Close the modal
    function closeModal() {
        document.getElementById("modal").style.display = "none";
    }


    </script>
</head>
<body>
    <h1>Καλωσορίσατε στο Admin Dashboard</h1>
    <div class="container">
    <h2>Εκκρεμή Αιτήματα Χρηστών</h2>
    <table>
            <thead>
                <tr>
                <th>Αναγνωριστικο Χρηστη</th>
                <th>Ονομα</th>
                <th>Επωνυμο</th>
                <th>Ονομα Χρηστη</th>
                <th>Email</th>
                <th>Τυπος Χρηστη</th>
                <th>Κατασταση</th>
                <th>Ενεργειες</th>

                </tr>
            </thead>
            <tbody>
    <?php while ($row = sqlsrv_fetch_array($stmtUsers, SQLSRV_FETCH_ASSOC)): ?>
        <tr>
            <td><?= htmlspecialchars($row['User_ID']) ?></td>
            <td><?= htmlspecialchars($row['First_Name']) ?></td>
            <td><?= htmlspecialchars($row['Last_Name']) ?></td>
            <td><?= htmlspecialchars($row['Username']) ?></td>
            <td><?= htmlspecialchars($row['Email']) ?></td>
            <td><?= htmlspecialchars($row['User_Type']) ?></td>
            <td><?= htmlspecialchars($row['Status']) ?></td>
            <td>
                <button class="btn-approve" onclick="handleUserRequest(<?= $row['User_ID'] ?>, 1)">Approve</button>
                <button class="btn-reject" onclick="handleUserRequest(<?= $row['User_ID'] ?>, 0)">Reject</button>
            </td>
        </tr>
    <?php endwhile; ?>
</tbody>
        </table>
    </div>
    <div class="container">
    <h2>Όλες οι Αιτήσεις</h2>
    <table>
    <thead>
        <tr>
        <th>Αναγνωριστικο Αιτησης</th>
        <th>Αριθμος Αιτησης</th>
        <th>Ημερομηνια Καταχωρησης</th>
        <th>Ταυτοτητα Αιτητη/Αριθμος Εταιρειας</th>
        <th>Κατηγορια</th>
        <th>Κατασταση</th>
        <th>Επαναενεργοποιηση</th> 
        <th>Εγκριση/Απορριψη</th> 
        <th>Ελεγχος</th> 

        </tr>
    </thead>
    <tbody>
    <?php foreach ($applications as $app): ?>
        <tr>
            <td><?= htmlspecialchars($app['Application_ID']) ?></td>
            <td><?= htmlspecialchars($app['Tracking_Number']) ?></td>
            <td><?= htmlspecialchars($app['Application_Date']->format('Y-m-d')) ?></td>
            <td><?= htmlspecialchars($app['Applicant_ID']) ?></td>
            <td><?= htmlspecialchars($app['Category_Number']) ?></td>
            <td><?= htmlspecialchars($app['Current_Status']) ?></td>
            <td>
                <?php if ($app['Current_Status'] === 'rejected'): ?>
                    <button class="btn-reactivate" onclick="handleRequest(<?= $app['Application_ID'] ?>, 2)">Reactivate</button>
                <?php else: ?>
                    <span>Not applicable</span>
                <?php endif; ?>
            </td>
            <td>
                <?php if (in_array($app['Current_Status'], ['active', 'ordered', 'checked'])): ?>
                    <button class="btn-approve" onclick="handleRequest(<?= $app['Application_ID'] ?>, 1)">Accept</button>
                    <button class="btn-reject" onclick="handleRequest(<?= $app['Application_ID'] ?>, 0)">Reject</button>
                <?php else: ?>
                    <span>No actions available</span>
                <?php endif; ?>
            </td>
            <td>
                <!-- New Check Button -->
                <button class="btn-check" onclick="viewDetails(<?= $app['Application_ID'] ?>)">Check</button>
            </td>
        </tr>
    <?php endforeach; ?>
</tbody>

</table>

    </div>
    <?php
    sqlsrv_free_stmt($stmtUsers);
    sqlsrv_free_stmt($stmtApplications);
    sqlsrv_close($conn);
    ?>

    <!-- Modal -->
<div id="modal" class="modal">
    <div class="modal-box">
        <span class="close" onclick="closeModal()">&times;</span>
        <div id="modal-content">
            <!-- Details will be dynamically loaded here -->
        </div>
    </div>
</div>
</body>
</html>
