<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Report Generator</title>
    <style>
        
      
    <style>
    /* Reset styles for a consistent look across browsers */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(to bottom right, #007bff, #5a9bff);
        color: #fff;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }

    h1 {
        text-align: center;
        font-size: 2rem;
        margin-bottom: 20px;
    }

    form {
        background: rgba(0, 0, 0, 0.7);
        padding: 20px;
        border-radius: 10px;
        width: 100%;
        max-width: 600px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
    }

    label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
    }

    input,
    select,
    button {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
        border: none;
        border-radius: 5px;
        font-size: 1rem;
    }

    input,
    select {
        background: #f1f1f1;
        color: #333;
    }

    button {
        background: #007bff;
        color: #fff;
        font-weight: bold;
        cursor: pointer;
        transition: background 0.3s ease;
    }

    button:hover {
        background: #0056b3;
    }

    .hidden {
        display: none;
    }

    @media (max-width: 768px) {
        h1 {
            font-size: 1.5rem;
        }

        form {
            padding: 15px;
        }

        input,
        select,
        button {
            font-size: 0.9rem;
        }
    }
</style>


</head>
<body>
    <h1>Generate Report</h1>
    <form method="post" action="generateReports.php">
        <!-- Report Type Selection -->
        <label for="reportType">Report Type:</label>
        <select name="reportType" id="reportType" required>
            <option value="1">R1-Total Grants Overview</option>
            <option value="2">R2-Remaining Grants Overview</option>
            <option value="3">R3-Application Count Analysis</option>
            <option value="4">R4-Trend Comparison</option>
            <option value="5">R5-Success Percentage</option>
            <option value="6">R6-High Activity Periods</option>
            <option value="7">R7-Average Grant Amount</option>
            <option value="8">R8-Highest and Lowest Grants</option>
            <option value="9">R9-Applications by Legal Entities</option>
            <option value="10">R10-Categories Active for Four Months</option>
            <option value="11">R11-Categories with Minimum Applications</option>
        </select>
        <br><br>

        <!-- Time Period -->
        <div id="timePeriodInputs" class="hidden">
            <label for="startDate">Start Date:</label>
            <input type="date" name="startDate" id="startDate">
            <br>

            <label for="endDate">End Date:</label>
            <input type="date" name="endDate" id="endDate">
            <br>
        </div>

        <!-- Category Filter -->
        <div id="categoryFilterInputs" class="hidden">
            <label for="categoryFilter">Category Filter:</label>
            <input type="number" name="categoryFilter" id="categoryFilter">
            <br>
        </div>

        <!-- Applicant Type -->
        <div id="applicantTypeInputs" class="hidden">
            <label for="applicantType">Applicant Type:</label>
            <select name="applicantType" id="applicantType">
                <option value="">None</option>
                <option value="Company">Company</option>
                <option value="Private">Private</option>
            </select>
            <br>
        </div>

        <!-- Time Grouping -->
        <div id="timeGroupingInputs" class="hidden">
            <label for="timeGrouping">Time Grouping:</label>
            <select name="timeGrouping" id="timeGrouping">
                <option value="">None</option>
                <option value="daily">Daily</option>
                <option value="weekly">Weekly</option>
                <option value="monthly">Monthly</option>
                <option value="quarterly">Quarterly</option>
                <option value="yearly">Yearly</option>
            </select>
            <br>
        </div>

        <!-- Minimum Applications (for Report 11) -->
        <div id="minApplicationsInput" class="hidden">
            <label for="minApplications">Minimum Applications:</label>
            <input type="number" name="minApplications" id="minApplications">
            <br>
        </div>

        <!-- Sort By and Sort Order -->
        <div id="sortInputs" class="hidden">
            <label for="sortBy">Sort By:</label>
            <select name="sortBy" id="sortBy">
                <option value="Amount">Amount</option>
                <option value="Category">Category</option>
            </select>
            <br>

            <label for="sortOrder">Sort Order:</label>
            <select name="sortOrder" id="sortOrder">
                <option value="ASC">Ascending</option>
                <option value="DESC">Descending</option>
            </select>
            <br>
        </div>

        <button type="submit">Generate Report</button>
    </form>

    <script>
        const reportTypeSelect = document.getElementById("reportType");
        const timePeriodInputs = document.getElementById("timePeriodInputs");
        const categoryFilterInputs = document.getElementById("categoryFilterInputs");
        const applicantTypeInputs = document.getElementById("applicantTypeInputs");
        const timeGroupingInputs = document.getElementById("timeGroupingInputs");
        const minApplicationsInput = document.getElementById("minApplicationsInput");
        const sortInputs = document.getElementById("sortInputs");

        reportTypeSelect.addEventListener("change", function () {
            // Get selected report type
            const reportType = parseInt(this.value);

            // Hide all optional inputs initially
            timePeriodInputs.classList.add("hidden");
            categoryFilterInputs.classList.add("hidden");
            applicantTypeInputs.classList.add("hidden");
            timeGroupingInputs.classList.add("hidden");
            minApplicationsInput.classList.add("hidden");
            sortInputs.classList.add("hidden");

            // Show inputs based on the selected report type
            switch (reportType) {
                case 1: // Total Grants Overview
                    timePeriodInputs.classList.remove("hidden");
                    categoryFilterInputs.classList.remove("hidden");
                    applicantTypeInputs.classList.remove("hidden");
                    sortInputs.classList.remove("hidden");
                    break;
                case 2: // Remaining Grants Overview
                    sortInputs.classList.remove("hidden");
                    break;
                case 3: // Application Count Analysis
                case 7: // Average Grant Amount
                    timePeriodInputs.classList.remove("hidden");
                    categoryFilterInputs.classList.remove("hidden");
                    applicantTypeInputs.classList.remove("hidden");
                    break;
                case 4: // Trend Comparison
                case 5: // Success Percentage
                    applicantTypeInputs.classList.remove("hidden");
                    break;
                case 6: // High Activity Periods
                    timeGroupingInputs.classList.remove("hidden");
                    break;
                case 8: // Highest and Lowest Grants
                    timePeriodInputs.classList.remove("hidden");
                    categoryFilterInputs.classList.remove("hidden");
                    break;
                case 9: // Applications by Legal Entities
                    timePeriodInputs.classList.remove("hidden");
                    break;
                case 10: // Categories Active for Four Months
                    // No additional inputs required
                    break;
                case 11: // Categories with Minimum Applications
                    minApplicationsInput.classList.remove("hidden");
                    break;
                default:
                    break;
            }
        });

        // Trigger change event to set default visibility
        reportTypeSelect.dispatchEvent(new Event("change"));
    </script>
</body>
</html>
