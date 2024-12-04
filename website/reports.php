<?php
// Start the session to check if the user is logged in
session_start();
if (!isset($_SESSION['SessionID'])) {
    header("Location: login.php");
    exit();
}

if ($_SESSION['UserTypeNumber'] != 1) {
    header("Location: login.php");
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>
    <style>
        .container {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        .filters {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .results {
            width: 100%;
            margin-top: 20px;
        }
    </style>
    <script>
        function updateSecondDropdown() {
            const reportType = document.getElementById("reportType").value;
            const detailDropdown = document.getElementById("reportDetails");

            detailDropdown.innerHTML = "";

            if (reportType === "GrantReports") {
                const options = ["Total Grants Overview", "Remaining Grants Overview"];
                options.forEach(option => {
                    const opt = document.createElement("option");
                    opt.value = option;
                    opt.innerText = option;
                    detailDropdown.appendChild(opt);
                });
            } else if (reportType === "ApplicationStats") {
                const options = ["Application Count Analysis", "Trends Comparison", "Success Rate"];
                options.forEach(option => {
                    const opt = document.createElement("option");
                    opt.value = option;
                    opt.innerText = option;
                    detailDropdown.appendChild(opt);
                });
            } else if (reportType === "GrantAmounts") {
                const options = ["Average Grant by Category", "Highest & Lowest Grants"];
                options.forEach(option => {
                    const opt = document.createElement("option");
                    opt.value = option;
                    opt.innerText = option;
                    detailDropdown.appendChild(opt);
                });
            } else if (reportType === "PerformanceReports") {
                const options = [
                    "Legal Entities Performance",
                    "Monthly Consistency (Last 4 months)",
                    "Annual Applications Over Threshold"
                ];
                options.forEach(option => {
                    const opt = document.createElement("option");
                    opt.value = option;
                    opt.innerText = option;
                    detailDropdown.appendChild(opt);
                });
            }
        }
    </script>
</head>
<body>
    <h1>Reports</h1>
    <div class="container">
        <form method="POST" action="process_report.php">
            <label for="reportType">Select Report Category:</label>
            <select id="reportType" name="reportType" onchange="updateSecondDropdown()" required>
                <option value="" selected disabled>Choose a category</option>
                <option value="GrantReports">Grant Reports</option>
                <option value="ApplicationStats">Application Statistics</option>
                <option value="GrantAmounts">Grant Amounts</option>
                <option value="PerformanceReports">Performance Reports</option>
            </select>
            <br><br>

            <label for="reportDetails">Select Specific Report:</label>
            <select id="reportDetails" name="reportDetails" required>
                <option value="" selected disabled>Choose a report</option>
            </select>
            <br><br>

            <div class="filters">
                <h3>Filters</h3>
                <label for="startDate">Start Date:</label>
                <input type="date" id="startDate" name="startDate">
                <br><br>

                <label for="endDate">End Date:</label>
                <input type="date" id="endDate" name="endDate">
                <br><br>

                <label for="timeGrouping">Time Grouping:</label>
                <select id="timeGrouping" name="timeGrouping">
                    <option value="" selected disabled>Choose a grouping</option>
                    <option value="daily">Daily</option>
                    <option value="weekly">Weekly</option>
                    <option value="monthly">Monthly</option>
                    <option value="quarterly">Quarterly</option>
                    <option value="yearly">Yearly</option>
                </select>
                <br><br>

                <label for="sortBy">Sort By:</label>
                <select id="sortBy" name="sortBy">
                    <option value="" selected disabled>Choose sorting</option>
                    <option value="Amount">Amount</option>
                    <option value="Category">Category</option>
                </select>
                <br><br>

                <label for="sortOrder">Sort Order:</label>
                <select id="sortOrder" name="sortOrder">
                    <option value="" selected disabled>Choose order</option>
                    <option value="ASC">Ascending</option>
                    <option value="DESC">Descending</option>
                </select>
            </div>
            <br>

            <button type="submit">Generate Report</button>
        </form>
    </div>
</body>
</html>
