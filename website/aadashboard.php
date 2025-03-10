<?php
// Εισαγωγή σύνδεσης με τη βάση δεδομένων
include 'connection.php';

// Έναρξη συνεδρίας
session_start();

// Έλεγχος αν ο χρήστης είναι συνδεδεμένος
if (!isset($_SESSION['SessionID'])) {
    header("Location: login.php");
    exit();
}

// Έλεγχος αν ο χρήστης έχει εξουσιοδότηση για πρόσβαση σε αυτήν τη σελίδα (μόνο για AA)
if ($_SESSION['UserTypeNumber'] != 3) {
    header("Location: login.php");
    exit();
}

// Αρχικοποίηση μηνυμάτων
$errorMessage = '';
$successMessage = '';
$applicationDetails = [];

// Διαχείριση υποβολής φόρμας αναζήτησης
if (isset($_POST['search'])) {
    $identification = trim($_POST['identification']);
    $trackingNumber = trim($_POST['trackingNumber']);
    $fullName = ''; // Παράμετρος εξόδου
    $applicationDate = ''; // Παράμετρος εξόδου
    $categoryNumber = ''; // Παράμετρος εξόδου για την κατηγορία

    // Κλήση της αποθηκευμένης διαδικασίας
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
        // Διαχείριση σφαλμάτων SQL και εμφάνιση μόνο των κύριων μηνυμάτων σφάλματος
        $sqlErrors = sqlsrv_errors();
        foreach ($sqlErrors as $error) {
            $mainMessage = preg_replace('/^.*\]\s*/', '', $error['message']); // Εξαγωγή του κύριου μηνύματος μετά το τελευταίο `]`
            $errorMessage .= htmlspecialchars($mainMessage);
        }
    } else {
        if (!empty($fullName) && !empty($applicationDate)) {
            $applicationDetails = [
                'FullName' => $fullName,
                'ApplicationDate' => $applicationDate,
                'TrackingNumber' => $trackingNumber,
                'CategoryNumber' => $categoryNumber
            ];
            $successMessage = "Η αίτηση βρέθηκε!";
        } else {
            $errorMessage = "Δεν βρέθηκε ενεργή αίτηση για τα παρεχόμενα στοιχεία.";
        }
    }
}

// Διαχείριση υποβολής φόρμας προσθήκης παραγγελίας αυτοκινήτου
if (isset($_POST['addOrder'])) {
    $sessionID = $_SESSION['SessionID']; 
    $trackingNumber = trim($_POST['trackingNumber']);
    $vehicleDate = $_POST['vehicleDate'];
    $vehicleType = $_POST['vehicleType'];
    $co2Emissions = intval($_POST['co2Emissions']);
    $manufacturer = trim($_POST['manufacturer']);
    $model = trim($_POST['model']);
    $price = intval($_POST['price']);
    $document1 = trim($_POST['document1']);
    $document2 = trim($_POST['document2']);

    // Έλεγχος εγκυρότητας εισόδων
    if (empty($vehicleDate) || empty($vehicleType) || $co2Emissions > 50 || $price > 80000) {
        $errorMessage = "Ελέγξτε τις τιμές εισόδου σας και δοκιμάστε ξανά.";
    } else {
        // Κλήση της αποθηκευμένης διαδικασίας με τον σωστό αριθμό παραμέτρων
        $sql = "{CALL dbo.AddVehicleAndDocument(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        $params = [
            $sessionID,  
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
            // Διαχείριση σφαλμάτων SQL και εμφάνιση μόνο των κύριων μηνυμάτων σφάλματος
            $sqlErrors = sqlsrv_errors();
            foreach ($sqlErrors as $error) {
                $mainMessage = preg_replace('/^.*\]\s*/', '', $error['message']); // Εξαγωγή του κύριου μηνύματος μετά το τελευταίο `]`
                $errorMessage .= htmlspecialchars($mainMessage);
            }
        } else {
            $successMessage = "Το όχημα και τα έγγραφα προστέθηκαν επιτυχώς!";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="el">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Αναζήτηση και Προσθήκη Παραγγελίας Αυτοκινήτου</title>
    <style>
       body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f0f8ff; /* Light blue background */
    color: #333; /* Darker text color for readability */
    margin: 0;
    padding: 0;
}

.form-container, .result-container {
    width: 90%;
    max-width: 1200px;
    margin: 40px auto;
    background: #ffffff;
    padding: 30px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    border-radius: 15px;
}

h1, h2 {
    text-align: center;
    color: #0056b3; /* Blue */
}

form {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 15px;
}

label {
    font-size: 1em;
    font-weight: bold;
    color: #0056b3; /* Blue */
}

input[type="text"], input[type="date"], input[type="number"], select, button {
    width: 100%;
    max-width: 400px;
    padding: 10px;
    font-size: 1em;
    border-radius: 8px;
    border: 1px solid #ccc;
    box-sizing: border-box;
}

input[type="text"]:focus, input[type="date"]:focus, input[type="number"]:focus, select:focus {
    border-color: #0056b3; /* Blue */
    outline: none;
    box-shadow: 0 0 5px rgba(0, 86, 179, 0.5); /* Blue */
}

button, input[type="submit"] {
    padding: 10px 20px;
    font-size: 1em;
    background-color: #0056b3; /* Blue */
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.3s;
}

button:hover, input[type="submit"]:hover {
    background-color: #004494; /* Darker blue */
}

.error {
    background-color: #ffebe6;
    color: #d32f2f;
    padding: 10px;
    margin-top: 10px;
    border-left: 5px solid #d32f2f;
    border-radius: 8px;
}

.success {
    background-color: #e6ffe6; /* Light green background */
    color: #388e3c; /* Green text */
    padding: 10px;
    margin-top: 10px;
    border-left: 5px solid #388e3c; /* Green border */
    border-radius: 8px;
}


.file-button-container {
    display: flex;
    gap: 10px;
    align-items: center;
}

.file-button-container button {
    padding: 5px 15px;
    font-size: 0.9em;
    background-color: #0056b3; /* Blue */
    color: white;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
}

.file-button-container button:hover {
    background-color: #004494; /* Darker blue */
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    border-radius: 10px;
    overflow: hidden;
}

table, th, td {
    border: 1px solid #ddd;
}

th {
    background-color: #0056b3; /* Blue */
    color: white;
    padding: 15px;
    text-transform: uppercase;
    font-size: 1em;
}

td {
    padding: 15px;
    text-align: center;
    background-color: #f1f9ff; /* Light blue */
    color: #333;
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
</style>
    <script>
        function uploadFile(inputId, outputId) {
    const outputField = document.getElementById(outputId);
    if (!outputField) {
        console.error(`Element with id '${outputId}' not found.`);
        return;
    }
    const generatedFileName = "G" + <?= htmlspecialchars($applicationDetails['CategoryNumber'] ?? '') ?>;
    outputField.value = generatedFileName;
    alert("File generated: " + generatedFileName);
}
function confirmWithPassword(actionCallback) {
    const password = prompt("Παρακαλώ εισάγετε τον κωδικό σας:");

    if (!password) {
        alert("Δεν εισαγάγατε κωδικό. Η ενέργεια ακυρώθηκε.");
        return;
    }

    // AJAX αίτημα για επαλήθευση του κωδικού
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "verifyPassword.php", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function () {
        if (xhr.responseText === "success") {
            actionCallback(); // Εκτέλεση της αρχικής ενέργειας
        } else {
            alert("Λάθος κωδικός. Παρακαλώ δοκιμάστε ξανά.");
        }
    };
    xhr.send("password=" + encodeURIComponent(password));
}

    </script>
</head>
<body>
<div class="header">
    <header>
        <h1>Dashboard ΑΑ</h1>
    </header>
    <div class="header-buttons">
        <a href="logout.php" class="btn logout">Αποσύνδεση</a>
    </div>
    
</div>


<div class="form-container">
    <h1>Αναζήτηση Αίτησης</h1>
    <form method="POST">
        <label for="identification">Ταυτότητα:</label>
        <input type="text" id="identification" name="identification" value="<?= htmlspecialchars($_POST['identification'] ?? '') ?>" required>

        <label for="trackingNumber">Αριθμός Παρακολούθησης:</label>
        <input type="text" id="trackingNumber" name="trackingNumber" value="<?= htmlspecialchars($_POST['trackingNumber'] ?? '') ?>" required>

        <button type="submit" name="search">Αναζήτηση</button>
    </form>

    <?php if ($errorMessage): ?>
        <p class="error"><?= htmlspecialchars($errorMessage) ?></p>
    <?php elseif ($successMessage): ?>
        <p class="success"><?= htmlspecialchars($successMessage) ?></p>
    <?php endif; ?>
</div>

<?php if ($applicationDetails): ?>
    <div class="result-container">
        <h2>Λεπτομέρειες Αίτησης</h2>
        <p><strong>Ονοματεπώνυμο:</strong> <?= htmlspecialchars($applicationDetails['FullName']) ?></p>
        <p><strong>Ημερομηνία Αίτησης:</strong> <?= htmlspecialchars($applicationDetails['ApplicationDate']) ?></p>
        <p><strong>Αριθμός Κατηγορίας:</strong> <?= htmlspecialchars($applicationDetails['CategoryNumber']) ?></p>

        <h2>Προσθήκη Παραγγελίας Αυτοκινήτου</h2>
        <form method="POST">
            <input type="hidden" name="trackingNumber" value="<?= htmlspecialchars($applicationDetails['TrackingNumber']) ?>" required>

            <label for="vehicleDate">Ημερομηνία Οχήματος:</label>
            <input type="date" id="vehicleDate" name="vehicleDate" required>

            <label for="vehicleType">Τύπος Οχήματος:</label>
            <select id="vehicleType" name="vehicleType" required>
                <option value="pure-electric">Αμιγώς Ηλεκτρικό</option>
                <option value="hybrid">Υβριδικό</option>
            </select>

            <label for="co2Emissions">Εκπομπές CO2 (<= 50):</label>
            <input type="number" id="co2Emissions" name="co2Emissions" min="0" max="50" required>

            <label for="manufacturer">Κατασκευαστής:</label>
            <input type="text" id="manufacturer" name="manufacturer" maxlength="50" required>

            <label for="model">Μοντέλο:</label>
            <input type="text" id="model" name="model" maxlength="50" required>

            <label for="price">Τιμή (0 - 80000):</label>
            <input type="number" id="price" name="price" min="0" max="80000" required>

            <label for="document1">Έγγραφο 1 (Παραγγελία Αυτοκινήτου):</label>
            <input type="text" id="document1" name="document1" readonly>
            <button type="button" onclick="confirmWithPassword(() => uploadFile('document1', 'document1'));">Δημιουργία Εγγράφου 1</button>

            <label for="document2">Έγγραφο 2 (Πιστοποιητικό Συμμόρφωσης ΕΚ):</label>
            <input type="text" id="document2" name="document2" readonly>
            <button type="button" onclick="confirmWithPassword(() => uploadFile('document2', 'document2'));">Δημιουργία Εγγράφου 2</button>


            <button type="submit" name="addOrder">Υποβολή</button>
        </form>
    </div>
<?php endif; ?>

</body>
</html>
