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

// Validate and set parameters
$reportType = isset($_POST['reportType']) ? intval($_POST['reportType']) : null; // ReportType is required
$startDate = isset($_POST['startDate']) && !empty($_POST['startDate']) ? $_POST['startDate'] : null;
$endDate = isset($_POST['endDate']) && !empty($_POST['endDate']) ? $_POST['endDate'] : null;
$categoryFilter = isset($_POST['categoryFilter']) && !empty($_POST['categoryFilter']) ? intval($_POST['categoryFilter']) : null;
$applicantType = isset($_POST['applicantType']) && in_array($_POST['applicantType'], ['Company', 'Private']) ? $_POST['applicantType'] : null;
$timeGrouping = isset($_POST['timeGrouping']) && in_array($_POST['timeGrouping'], ['daily', 'weekly', 'monthly', 'quarterly', 'yearly']) ? $_POST['timeGrouping'] : null;

// Determine grouping parameters from dropdowns
$groupByCategory = isset($_POST['groupByCategoryInput']) && $_POST['groupByCategoryInput'] === 'Yes' ? 1 : 0;
$groupByApplicantType = isset($_POST['groupByApplicantType']) && $_POST['groupByApplicantType'] === 'Yes' ? 1 : 0;

// Set default values for Sort By and Sort Order
$sortBy = null;
$sortOrder = null;

// Adjust parameters based on Report Type
if ($reportType === 1 || $reportType === 2) {
    $sortBy = isset($_POST['sortBy']) ? $_POST['sortBy'] : 'Amount';
    $sortOrder = isset($_POST['sortOrder']) ? $_POST['sortOrder'] : 'ASC';
}

// Construct and execute the query based on report type
if ($reportType >= 1 && $reportType <= 8) {
    $sql = "EXEC GenerateReport ?, ?, ?, ?, ?, ?, ?, ?, ?, ?;";
    $params = [
        $startDate,
        $endDate,
        $categoryFilter,
        $applicantType,
        $timeGrouping,
        $groupByCategory,
        $groupByApplicantType,
        $reportType,
        $sortBy,
        $sortOrder
    ];
} elseif ($reportType === 9) {
    $sql = "EXEC Report9 ?, ?;";
    $params = [$startDate, $endDate];
} elseif ($reportType === 10) {
    $sql = "EXEC Report10;";
    $params = [];
} elseif ($reportType === 11) {
    $minApplications = isset($_POST['minApplications']) ? intval($_POST['minApplications']) : null;
    if ($minApplications === null) {
        die("Minimum applications are required for Report 11.");
    }
    $sql = "EXEC Report11 ?;";
    $params = [$minApplications];
} else {
    die("Invalid report type selected.");
}

// Debugging: Send parameters to the browser console
echo "<script>console.log('Report Type: $reportType');</script>";
echo "<script>console.log('Parameters:', " . json_encode($params) . ");</script>";

// Execute the query
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt === false) {
    echo "<script>console.error('SQL Error: " . json_encode(sqlsrv_errors()) . "');</script>";
    die("Query failed: " . print_r(sqlsrv_errors(), true));
}

// Output the results with CSS
echo '<style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f9f9f9;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px auto;
            background-color: #fff;
            border: 1px solid #ddd;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        table th, table td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }
        table th {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }
        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        table tr:hover {
            background-color: #f1f1f1;
        }
      </style>';

// Check if any results were returned
if (sqlsrv_has_rows($stmt) === false) {
    echo "<p>No results found from the stored procedure.</p>";
} else {
    // Fetch all rows first to determine which columns have non-NULL data
    $rows = [];
    while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        $rows[] = $row;
    }

    // Determine non-NULL columns
    $nonNullColumns = [];
    foreach ($rows as $row) {
        foreach ($row as $column => $value) {
            if ($value !== null) {
                $nonNullColumns[$column] = true;
            }
        }
    }

    // Start the HTML table
    echo "<table>";
    echo "<thead><tr>";

    // Get the column names for the table header, but only include non-NULL columns
    foreach ($nonNullColumns as $column => $isNonNull) {
        echo "<th>" . htmlspecialchars($column) . "</th>";
    }
    echo "</tr></thead><tbody>";

    // Render the rows, but only include non-NULL columns
    foreach ($rows as $row) {
        echo "<tr>";
        foreach ($nonNullColumns as $column => $isNonNull) {
            echo "<td>" . htmlspecialchars($row[$column]) . "</td>";
        }
        echo "</tr>";
    }

    echo "</tbody></table>";
}
// Add a button to redirect back to the reports page
echo '<div style="text-align: center; margin-top: 20px;">
        <form action="reports.php" method="get">
            <button type="submit" style="
                background-color: #007bff; 
                color: white; 
                padding: 10px 20px; 
                border: none; 
                border-radius: 5px; 
                font-size: 16px; 
                cursor: pointer;">
                Start New Report
            </button>
        </form>
      </div>';

// Free statement and close connection
sqlsrv_free_stmt($stmt);
sqlsrv_close($conn);
?>
