<?php
// Include the database connection file
include 'connection.php';

// Check for form submission (Sign Up or Login)
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Sign Up
    if (isset($_POST['signup'])) {
        $first_name = $_POST['first_name'];
        $last_name = $_POST['last_name'];
        $username = $_POST['username'];
        $email = $_POST['email'];
        $password = password_hash($_POST['password'], PASSWORD_BCRYPT); // Encrypt password
        $user_type = $_POST['user_type'];

        // Call the stored procedure for Sign Up
        $stmt = sqlsrv_prepare(
            $conn,
            "EXEC SignUpUser ?, ?, ?, ?, ?, ?, ?",
            array($first_name, $last_name, $username, $email, $password, $user_type, 'pending')
        );

        if (sqlsrv_execute($stmt)) {
            echo "Sign Up successful!";
        } else {
            echo "Error during Sign Up.";
            die(print_r(sqlsrv_errors(), true));
        }
    }

    // Login
    if (isset($_POST['login'])) {
        $username = $_POST['login_username'];
        $password = $_POST['login_password'];

        $stmt = sqlsrv_prepare($conn, "EXEC [dbo].[LoginUser] ?", array($username));

        if (sqlsrv_execute($stmt)) {
            // Fetch the result
            $result = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);

                if ($result) {
                    // Get the hashed password and status
                    $hashedPasswordFromDB = $result['Password'];
                    $status = $result['Status'];

                    // Verify the password using password_verify()
                    if (password_verify($password, $hashedPasswordFromDB)) {
                        if ($status == 'approved') {
                        echo "Login successful!";
                        // Redirect the user or perform other actions
                    } else {
                    echo "User not approved.";
                    }
                } else {
                    echo "Invalid username or password!";
                }
            } else {
                    echo "Invalid username or password!";
                }
        } else {
        echo "Error during Login.";
        die(print_r(sqlsrv_errors(), true));
    }
    }
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up and Login</title>
</head>

<body>
    <h2>Sign Up</h2>
    <form method="POST">
        <input type="text" name="first_name" placeholder="First Name" required><br>
        <input type="text" name="last_name" placeholder="Last Name" required><br>
        <input type="text" name="username" placeholder="Username" required><br>
        <input type="email" name="email" placeholder="Email" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <select name="user_type">
            <option value="User">User</option>
            <option value="Admin">Admin</option>
        </select><br>
        <button type="submit" name="signup">Sign Up</button>
    </form>

    <h2>Login</h2>
    <form method="POST">
        <input type="text" name="login_username" placeholder="Username" required><br>
        <input type="password" name="login_password" placeholder="Password" required><br>
        <button type="submit" name="login">Login</button>
    </form>
</body>

</html>
