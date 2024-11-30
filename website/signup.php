<?php
// Συμπερίληψη του αρχείου σύνδεσης με τη βάση δεδομένων
include 'connection.php';

// Αρχικοποίηση μεταβλητών για την αποθήκευση δεδομένων φόρμας
$firstName = $lastName = $username = $email = $password = $userType = '';
$identification = $companyPrivate = $gender = $birthDate = $telephoneNumber = $address = '';
$errorMessage = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Λήψη δεδομένων φόρμας
    $firstName = $_POST['first_name'];
    $lastName = $_POST['last_name'];
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $userType = $_POST['user_type'];

    // Προαιρετική λήψη πρόσθετων πεδίων αν ο τύπος χρήστη είναι "Αιτητής"
    $identification = $_POST['identification'] ?? null;
    $companyPrivate = $_POST['company_private'] ?? null;
    $gender = $_POST['gender'] ?? null;
    $birthDate = $_POST['birth_date'] ?? null;
    $telephoneNumber = $_POST['telephone_number'] ?? null;
    $address = $_POST['address'] ?? null;

    try {
        // Προετοιμασία του SQL ερωτήματος
        $sql = "EXEC [dbo].[SignUpUser] 
                        @First_Name = ?, 
                        @Last_Name = ?, 
                        @Username = ?, 
                        @Email = ?, 
                        @Password = ?, 
                        @User_Type = ?, 
                        @Identification = ?, 
                        @Company_Private = ?, 
                        @Gender = ?, 
                        @BirthDate = ?, 
                        @Telephone_Number = ?, 
                        @Address = ?";

        // Προετοιμασία του SQL statement
        $stmt = sqlsrv_prepare($conn, $sql, array(
            $firstName,
            $lastName,
            $username,
            $email,
            $password,
            $userType,
            $identification,
            $companyPrivate,
            $gender,
            $birthDate,
            $telephoneNumber,
            $address
        ));

        // Εκτέλεση της αποθηκευμένης διαδικασίας
        if (sqlsrv_execute($stmt)) {
            // Ανακατεύθυνση στο login.php μετά από επιτυχή εγγραφή
            header('Location: login.php');
            exit();
        } else {
            // Αποθήκευση λεπτομερειών σφάλματος
            $errors = sqlsrv_errors();
            foreach ($errors as $error) {
                if ($error['code'] === 50001) {
                    $errorMessage = "Το όνομα χρήστη υπάρχει ήδη. Παρακαλώ δοκιμάστε άλλο.";
                } elseif ($error['code'] === 50002) {
                    $errorMessage = "Το email υπάρχει ήδη. Παρακαλώ χρησιμοποιήστε άλλο.";
                } elseif ($error['code'] === 50003) {
                    $errorMessage = "Για τους αιτητές, όλα τα πεδία (Α.Π.Τ., Φύλο, Ημ/νία, Τηλέφωνο, Διεύθυνση) είναι υποχρεωτικά.";
                } elseif ($error['code'] === 50004) {
                    $errorMessage = "Το αναγνωριστικό υπάρχει ήδη. Παρακαλώ δοκιμάστε άλλο.";
                } elseif ($error['code'] === 50005) {
                    $errorMessage = "Όλα τα πεδία για το χρήστη (Όνομα, Επώνυμο, Όνομα Χρήστη, Email, Κωδικός) είναι υποχρεωτικά.";
                } else {
                    $errorMessage = "Σφάλμα κατά την εγγραφή. Παρακαλώ προσπαθήστε ξανά.";
                }
            }
        }
    } catch (Exception $e) {
        $errorMessage = "Σφάλμα: " . $e->getMessage();
    }
}
?>


<!DOCTYPE html>
<html lang="el">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Εγγραφή</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: linear-gradient(to right, #e6ffe6, #f0fff0);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            margin: 0;
        }
        .signup-container {
            background: #ffffff;
            padding: 60px;
            border-radius: 20px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 600px;
            text-align: left;
            max-height: 80vh;
            overflow-y: auto;
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="date"],
        select {
            width: calc(100% - 20px);
            padding: 15px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 12px;
            font-size: 16px;
            box-sizing: border-box;
        }
        button[type="submit"] {
            width: 100%;
            padding: 15px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 18px;
            transition: background 0.3s;
            box-sizing: border-box;
            margin-top: 20px;
        }
        button[type="submit"]:hover {
            background: #218838;
        }
        .applicant-fields {
            display: none;
        }
        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 10px;
            text-align: center;
        }
    </style>
    <script>
        function toggleApplicantFields() {
            var userType = document.getElementById("user_type").value;
            var applicantFields = document.getElementById("applicantFields");

            if (userType === "Applicant") {
                applicantFields.style.display = "block";
            } else {
                applicantFields.style.display = "none";
            }
        }
    </script>
</head>
<body>
    <div class="signup-container">
        <h2>Εγγραφή</h2>

        <!-- Εμφάνιση μηνύματος σφάλματος -->
        <?php if (!empty($errorMessage)) : ?>
            <p class="error-message"><?= htmlspecialchars($errorMessage) ?></p>
        <?php endif; ?>

        <form action="signup.php" method="POST">
        <label for="user_type">Εγγραφή ως:</label>
            <select id="user_type" name="user_type" onchange="toggleApplicantFields()" required>
                <option value="">Επιλέξτε Τύπο Χρήστη</option>
                <option value="TOM">Λειτουργός Τμήματος</option>
                <option value="AA">Αντιπρόσωπος Αυτοκινήτων</option>
                <option value="Applicant">Αιτητής</option>
            </select>

            <label for="first_name">Όνομα:</label>
            <input type="text" id="first_name" name="first_name" required>

            <label for="last_name">Επώνυμο:</label>
            <input type="text" id="last_name" name="last_name" required>

            <label for="username">Όνομα Χρήστη:</label>
            <input type="text" id="username" name="username" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="password">Κωδικός:</label>
            <input type="password" id="password" name="password" required>

          
            <div id="applicantFields" class="applicant-fields">
                <label for="identification">Α.Π.Τ. / Αρ. Εταιρίας:</label>
                <input type="text" id="identification" name="identification">

                <label for="company_private">Φυσικό/Νομικό Πρόσωπο:</label>
                <select id="company_private" name="company_private">
                    <option value="">Επιλέξτε Φυσικό/Νομικό Πρόσωπο</option>
                    <option value="company">Νομικό Πρόσωπο</option>
                    <option value="private">Φυσικό Πρόσωπο</option>
                </select>

                <label for="gender">Φύλο:</label>
                <select id="gender" name="gender">
                    <option value="">Επιλέξτε Φύλο</option>
                    <option value="M">Άνδρας</option>
                    <option value="F">Γυναίκα</option>
                    <option value="O">Άλλο</option>
                </select>

                <label for="birth_date">Ημ/νία Γέννησης ή Ημ/νία Ίδρυσης Εταιρίας:</label>
                <input type="date" id="birth_date" name="birth_date">

                <label for="telephone_number">Τηλέφωνο:</label>
                <input type="text" id="telephone_number" name="telephone_number">

                <label for="address">Διεύθυνση:</label>
                <input type="text" id="address" name="address">
            </div>

            <button type="submit">Εγγραφή</button>
        </form>
        <p style="text-align: center; margin-top: 20px;">
            Έχετε ήδη λογαριασμό; <a href="login.php">Σύνδεση</a>
        </p>
    </div>
</body>
</html>
