<?php
// Include the database connection file
include 'connection.php';

// Check if the connection is successful
if (!$conn) {
    die("Connection failed: " . sqlsrv_errors());
}

// Define a map of table names to stored procedures
$tableProcedures = [
    'Applicant' => 'GetApplicant',
    'Application' => 'GetApplication',
    'Criterion' => 'GetCriterion', // Changed from 'Criteria' to 'Criterion'
    'Document' => 'GetDocument',
    'Category_Has_Criterion' => 'GetCategoryHasCriterion', // Fixed 'has' to 'Category_Has_Criterion'
    'Modification' => 'GetModification', // Changed from 'Change' to 'Modification'
    'Sponsorship' => 'GetSponsorshipCategory', // Ensure the name matches your procedure
    'User' => 'GetUser',
    'Vehicle' => 'GetVehicle',
    'User_Session' => 'GetUserSession' // Added User_Session here
];

// Get the list of tables for the dropdown menu
$tables = array_keys($tableProcedures); // Use the keys of $tableProcedures as table names for the dropdown

// Initialize variables for handling form submission
$selectedTable = '';
$records = [];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['table_name'])) {
    $selectedTable = $_POST['table_name'];

    // Check if the selected table has a corresponding stored procedure
    if (array_key_exists($selectedTable, $tableProcedures)) {
        $procedure = $tableProcedures[$selectedTable];

        // Prepare and execute the stored procedure
        $sql = "{CALL $procedure}";

        // Execute the query
        $stmt = sqlsrv_query($conn, $sql);

        // Check for errors in executing the query
        if ($stmt === false) {
            die(print_r(sqlsrv_errors(), true));
        }

        // Fetch all records
        while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
            // Format DateTime fields as strings before adding them to records
            foreach ($row as $key => $value) {
                // If the value is a DateTime object, format it as a string
                if ($value instanceof DateTime) {
                    $row[$key] = $value->format('Y-m-d H:i:s');
                }
            }
            $records[] = $row;
        }

        // Free the statement resource
        sqlsrv_free_stmt($stmt);
    } else {
        echo "No stored procedure found for the selected table.";
    }
}

// Close the connection
sqlsrv_close($conn);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Table and View Records</title>
</head>
<body>
    <h2>Select a Table to View Records</h2>

    <!-- Dropdown form to choose the table -->
    <form method="POST" action="">
        <label for="table_name">Choose a Table:</label>
        <select name="table_name" id="table_name" required>
            <option value="">--Select a table--</option>
            <?php foreach ($tables as $table): ?>
                <option value="<?php echo $table; ?>" <?php if($table == $selectedTable) echo 'selected'; ?>>
                    <?php echo $table; ?>
                </option>
            <?php endforeach; ?>
        </select>
        <input type="submit" value="View Records">
    </form>

    <!-- Display records if a table is selected -->
    <?php if (!empty($records)): ?>
        <h3>Records in Table: <?php echo htmlspecialchars($selectedTable); ?></h3>
        <table border="1">
            <tr>
                <?php foreach (array_keys($records[0]) as $column): ?>
                    <th><?php echo htmlspecialchars($column); ?></th>
                <?php endforeach; ?>
            </tr>
            <?php foreach ($records as $record): ?>
                <tr>
                    <?php foreach ($record as $field): ?>
                        <td><?php echo htmlspecialchars($field); ?></td>
                    <?php endforeach; ?>
                </tr>
            <?php endforeach; ?>
        </table>
    <?php elseif ($selectedTable): ?>
        <p>No records found in this table.</p>
    <?php endif; ?>
</body>
</html>
