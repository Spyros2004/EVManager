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
    <script>
        // JavaScript to show additional fields if 'Applicant' is selected
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
    <h2>Sign Up</h2>
    
    <!-- Sign-Up Form -->
    <form action="signup.php" method="POST">
        <label for="first_name">First Name:</label>
        <input type="text" id="first_name" name="first_name" value="<?php echo htmlspecialchars($firstName); ?>" required><br><br>

        <label for="last_name">Last Name:</label>
        <input type="text" id="last_name" name="last_name" value="<?php echo htmlspecialchars($lastName); ?>" required><br><br>

        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="<?php echo htmlspecialchars($username); ?>" required><br><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<?php echo htmlspecialchars($email); ?>" required><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>

        <label for="user_type">User Type:</label>
        <select id="user_type" name="user_type" onchange="toggleApplicantFields()" required>
            <option value="">Select Type</option>
            <option value="TOM">TOM</option>
            <option value="AA">AA</option>
            <option value="Applicant">Applicant</option>
        </select><br><br>

        <!-- Applicant Fields (hidden initially) -->
        <div id="applicantFields" style="display:<?php echo ($userType == "Applicant" ? "block" : "none"); ?>;">
            <label for="identification">Identification:</label>
            <input type="text" id="identification" name="identification" value="<?php echo htmlspecialchars($identification); ?>"><br><br>

            <label for="company_private">Company Private:</label>
            <select id="company_private" name="company_private">
                <option value="">Select Company Type</option>
                <option value="company" <?php echo ($companyPrivate == "company" ? "selected" : ""); ?>>Company</option>
                <option value="private" <?php echo ($companyPrivate == "private" ? "selected" : ""); ?>>Private</option>
            </select><br><br>

            <label for="gender">Gender:</label>
            <select id="gender" name="gender">
                <option value="">Select Gender</option>
                <option value="M" <?php echo ($gender == "M" ? "selected" : ""); ?>>Male</option>
                <option value="F" <?php echo ($gender == "F" ? "selected" : ""); ?>>Female</option>
                <option value="O" <?php echo ($gender == "O" ? "selected" : ""); ?>>Other</option>
            </select><br><br>

            <label for="birth_date">Birth Date:</label>
            <input type="date" id="birth_date" name="birth_date" value="<?php echo htmlspecialchars($birthDate); ?>"><br><br>
        </div>

        <button type="submit">Sign Up</button>
    </form>
</body>
</html>
