<?php
// Include the database connection file
include 'connection.php';

// Initialize variables to store form data
$firstName = $lastName = $username = $email = $password = $userType = '';
$identification = $companyPrivate = $gender = $birthDate = '';

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get form data
    $firstName = $_POST['first_name'];
    $lastName = $_POST['last_name'];
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $userType = $_POST['user_type'];

    // Optionally get additional fields if user type is Applicant
    $identification = isset($_POST['identification']) ? $_POST['identification'] : null;
    $companyPrivate = isset($_POST['company_private']) ? $_POST['company_private'] : null;
    $gender = isset($_POST['gender']) ? $_POST['gender'] : null;
    $birthDate = isset($_POST['birth_date']) ? $_POST['birth_date'] : null;

    try {
        // Prepare the SQL query
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
                    @BirthDate = ?";

        // Prepare the SQL statement
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
            $birthDate
        ));

        // Execute the stored procedure
        if (sqlsrv_execute($stmt)) {
            // Redirect to login.php after successful registration
            header('Location: login.php');
            exit(); // Ensure no further code is executed
        } else {
            // If there is an error in executing the stored procedure, show error message
            echo "<p>Error: Registration failed. Please try again.</p>";
            // Optionally log the SQL error for debugging purposes
            echo "<p>Error details: " . print_r(sqlsrv_errors(), true) . "</p>";
        }
    } catch (Exception $e) {
        // Handle any exceptions and show an error message
        echo "<p>Error: " . $e->getMessage() . "</p>";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
    text-align: center;
    max-height: 80vh; /* Καθορισμένο μέγιστο ύψος για το κουτί */
    overflow-y: auto; /* Προσθήκη κύλισης στο κουτί όταν το περιεχόμενο υπερβαίνει το ύψος */
}

        h2 {
            margin-bottom: 25px;
            font-weight: 600;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="date"],
        select {
            width: calc(100% - 20px);
            padding: 15px;
            margin: 15px 0;
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
        }
        button[type="submit"]:hover {
            background: #218838;
        }
        .applicant-fields {
            display: none;
        }
        .signup-container .input-group {
            position: relative;
        }
        .signup-container .input-group i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            font-size: 21px;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="date"],
        select {
            padding-left: 50px;
        }
        @media (max-width: 600px) {
            .signup-container {
                padding: 30px;
            }
            input[type="text"],
            input[type="email"],
            input[type="password"],
            input[type="date"],
            select,
            button[type="submit"] {
                padding: 12px;
            }
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
        <h2>Sign Up</h2>
        
      <!-- Sign-Up Form -->
<form action="signup.php" method="POST" onsubmit="return validateForm()">
    <div class="input-group">
        <i class="fas fa-user"></i>
        <input type="text" id="first_name" name="first_name" placeholder="First Name" required>
    </div>

    <div class="input-group">
        <i class="fas fa-user"></i>
        <input type="text" id="last_name" name="last_name" placeholder="Last Name" required>
    </div>

    <div class="input-group">
        <i class="fas fa-user"></i>
        <input type="text" id="username" name="username" placeholder="Username" required>
    </div>

    <div class="input-group">
        <i class="fas fa-envelope"></i>
        <input type="email" id="email" name="email" placeholder="Email" required>
    </div>

    <div class="input-group">
        <i class="fas fa-lock"></i>
        <input type="password" id="password" name="password" placeholder="Password" required>
    </div>

    <div class="input-group">
        <i class="fas fa-lock"></i>
        <input type="password" id="confirm_password" name="confirm_password" placeholder="Confirm Password" required>
    </div>

    <div class="input-group">
        <i class="fas fa-user-tag"></i>
        <select id="user_type" name="user_type" onchange="toggleApplicantFields()" required>
            <option value="">Select User Type</option>
            <option value="TOM">TOM</option>
            <option value="AA">AA</option>
            <option value="Applicant">Applicant</option>
        </select>
    </div>

    <!-- Applicant Fields (hidden initially) -->
    <div id="applicantFields" class="applicant-fields">
        <div class="input-group">
            <i class="fas fa-id-card"></i>
            <input type="text" id="identification" name="identification" placeholder="Identification">
        </div>

        <div class="input-group">
            <i class="fas fa-building"></i>
            <select id="company_private" name="company_private">
                <option value="">Select Company Type</option>
                <option value="company">Company</option>
                <option value="private">Private</option>
            </select>
        </div>

        <div class="input-group">
            <i class="fas fa-venus-mars"></i>
            <select id="gender" name="gender">
                <option value="">Select Gender</option>
                <option value="M">Male</option>
                <option value="F">Female</option>
                <option value="O">Other</option>
            </select>
        </div>

        <div class="input-group">
            <i class="fas fa-birthday-cake"></i>
            <input type="date" id="birth_date" name="birth_date" placeholder="Birth Date">
        </div>
    </div>

    <button type="submit">Sign Up</button>
</form>
<br>
         <!-- Create Account Link -->
         <p style="text-align: center; font-size: 0.9em; color: black;">
            <a href="login.php" style="text-decoration: underline; font-weight: bold; color: black;">Έχεις ήδη λογαριασμό? Σύνδεση</a>
        </p>

    </div>
<script>
    function validateForm() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirm_password").value;

        if (password !== confirmPassword) {
            alert("Passwords do not match. Please make sure both passwords are the same.");
            return false; // Μην υποβάλλεις τη φόρμα αν οι κωδικοί δεν ταιριάζουν
        }
        return true;
    }
</script>
</body>
</html>
