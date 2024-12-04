<?php
// Start session and include database connection
session_start();
include 'connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $reportType = $_POST['reportType'];
    $reportDetails = $_POST['reportDetails'];
    $startDate = $_POST['startDate'] ?? null;
    $endDate = $_POST['endDate'] ?? null;
    $timeGrouping = $_POST['timeGrouping'] ?? null;
    $sortBy = $_POST['sortBy'] ?? null;
    $sortOrder = $_POST['sortOrder'] ?? null;

    $procedure = null;
    $params = [];

    // Select procedure based on report type and details
    if ($reportType === "GrantReports") {
        if ($reportDetails === "Total Grants Overview") {
            $procedure = "{CALL dbo.GenerateReport(?, ?, NULL, NULL, ?, 0, 0, 1, ?, ?)}";
            $params = [$startDate, $endDate, $timeGrouping, $sortBy, $sortOrder];
        } elseif ($reportDetails === "Remaining Grants Overview") {
            $procedure = "{CALL dbo.GenerateReport(?, ?, NULL, NULL, NULL, 0, 0, 2, ?, ?)}";
            $params = [$startDate, $endDate, $sortBy, $sortOrder];
        }
    } elseif ($reportType === "ApplicationStats") {
        if ($reportDetails === "Application Count Analysis") {
            $procedure = "{CALL dbo.GenerateReport(?, ?, NULL, NULL, ?, 1, 1, 3, NULL, NULL)}";
            $params = [$startDate, $endDate, $timeGrouping];
        }
    }

    if ($procedure) {
        $stmt = sqlsrv_query($conn, $procedure, $params);

        if ($stmt === false) {
            die(print_r(sqlsrv_errors(), true));
        }

        echo "<h1>Report Results</h1>";
        echo "<table border='1'>";
        $firstRow = true;
        while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
            if ($firstRow) {
                echo "<tr>";
                foreach (array_keys($row) as $header) {
                    echo "<th>$header</th>";
                }
                echo "</tr>";
                $firstRow = false;
            }
            echo "<tr>";
            foreach ($row as $value) {
                echo "<td>" . htmlspecialchars($value) . "</td>";
            }
            echo "</tr>";
        }
        echo "</table>";

        sqlsrv_free_stmt($stmt);
    } else {
        echo "<p>Invalid report selection.</p>";
    }
} else {
    echo "<p>Invalid request.</p>";
}
?>
