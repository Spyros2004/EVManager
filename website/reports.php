<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Report Generator</title>
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

.checkbox-container {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-bottom: 15px;
}

.checkbox-container input[type="checkbox"] {
    margin-right: 8px;
}

.checkbox-container label {
    display: inline-block;
    font-weight: normal;
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
<h1>Δημιουργία Αναφοράς</h1>
<form method="post" action="generateReports.php">
    <!-- Επιλογή Τύπου Αναφοράς -->
    <label for="reportType">Τύπος Αναφοράς:</label>
    <select name="reportType" id="reportType" required>
        <option value="1">R1-Επισκόπηση των συνολικών ποσών που δόθηκαν ως επιχορήγηση</option>
        <option value="2">R2-Επισκόπηση των υπολειπόµενων διαθέσιµών ποσών επιχορήγησης</option>
        <option value="3">R3-Ανάλυση Αριθμού Αιτήσεων</option>
        <option value="4">R4-Σύγκριση των τάσεων αιτήσεων µεταξύ διαφορετικών κατηγοριών επιχορήγησης</option>
        <option value="5">R5-Ποσοστό Επιτυχών αιτήσεων</option>
        <option value="6">R6-Περίοδοι Υψηλής Δραστηριότητας</option>
        <option value="7">R7-Μέσο ποσό επιχορήγησης επιτυχών αιτήσεων για κάθε κατηγορία</option>
        <option value="8">R8-Υψηλότερες και Χαμηλότερες Χορηγίες επιτυχών αιτήσεων</option>
        <option value="9">R9-Όλα τα νοµικά πρόσωπα που έκαναν αίτηση σε κάθε κατηγορία εντός κάποιου χρονικού διαστήµατος ακολουθούµενα από τα νοµικά πρόσωπα που δεν είχαν καµία επιτυχή αίτηση στο ίδιο
χρονικό διάστηµα</option>
        <option value="10">R10-Τουλάχιστον µια αίτηση κάθε µήνα του τελευταίου τετράµηνου</option>
        <option value="11">R11-Κατηγορίες με τουλάχιστον Χ αιτήσεις</option>
    </select>
    <br><br>

    <!-- Χρονική Περίοδος -->
    <div id="timePeriodInputs" class="hidden">
        <label for="startDate">Ημερομηνία Έναρξης:</label>
        <input type="date" name="startDate" id="startDate">
        <br>

        <label for="endDate">Ημερομηνία Λήξης:</label>
        <input type="date" name="endDate" id="endDate">
        <br>
    </div>

    <!-- Φίλτρο Κατηγορίας -->
    <div id="categoryFilterInputs" class="hidden">
        <label for="categoryFilter">Φίλτρο Κατηγορίας(1-14):</label>
        <input type="number" name="categoryFilter" id="categoryFilter">
        <br>
    </div>

    <!-- Τύπος Αιτούντος -->
    <div id="applicantTypeInputs" class="hidden">
        <label for="applicantType">Τύπος Αιτούντος:</label>
        <select name="applicantType" id="applicantType">
            <option value="">Κανένας</option>
            <option value="Company">Εταιρεία</option>
            <option value="Private">Ιδιώτης</option>
        </select>
        <br>
    </div>

    <!-- Ομαδοποίηση Χρόνου -->
    <div id="timeGroupingInputs" class="hidden">
        <label for="timeGrouping">Ομαδοποίηση Χρόνου:</label>
        <select name="timeGrouping" id="timeGrouping">
            <option value="">Καμία</option>
            <option value="daily">Ημερήσια</option>
            <option value="weekly">Εβδομαδιαία</option>
            <option value="monthly">Μηνιαία</option>
            <option value="quarterly">Τριμηνιαία</option>
            <option value="yearly">Ετήσια</option>
        </select>
        <br>
    </div>

    <!-- Ομαδοποίηση κατά Τύπο Αιτούντος -->
    <div id="groupByApplicantTypeInput" class="hidden">
        <label for="ApplicantType">Ομαδοποίηση κατά Αιτούντα:</label>
        <select name="groupByApplicantType" id="groupByApplicantType">
            <option value="">Καμία</option>
            <option value="Yes">Ναι</option>
            <option value="No">Όχι</option>
        </select>
        <br>
    </div>

    <!-- Ομαδοποίηση κατά Κατηγορία -->
    <div id="groupByCategoryInput" class="hidden">
        <label for="Category">Ομαδοποίηση κατά Κατηγορία:</label>
        <select name="groupByCategoryInput" id="groupByCategoryInput">
            <option value="">Καμία</option>
            <option value="Yes">Ναι</option>
            <option value="No">Όχι</option>
        </select>
        <br>
    </div>

    <!-- Ελάχιστες Αιτήσεις (για την Αναφορά 11) -->
    <div id="minApplicationsInput" class="hidden">
        <label for="minApplications">Ελάχιστες Αιτήσεις:</label>
        <input type="number" name="minApplications" id="minApplications">
        <br>
    </div>

    <!-- Ταξινόμηση και Σειρά Ταξινόμησης -->
    <div id="sortInputs" class="hidden">
        <label for="sortBy">Ταξινόμηση κατά:</label>
        <select name="sortBy" id="sortBy">
            <option value="Amount">Ποσό</option>
            <option value="Category">Κατηγορία</option>
        </select>
        <br>

        <label for="sortOrder">Σειρά Ταξινόμησης:</label>
        <select name="sortOrder" id="sortOrder">
            <option value="ASC">Αύξουσα</option>
            <option value="DESC">Φθίνουσα</option>
        </select>
        <br>
    </div>

    <button type="submit">Δημιουργία Αναφοράς</button>
</form>


    <script>
        const reportTypeSelect = document.getElementById("reportType");
const timePeriodInputs = document.getElementById("timePeriodInputs");
const categoryFilterInputs = document.getElementById("categoryFilterInputs");
const applicantTypeInputs = document.getElementById("applicantTypeInputs");
const timeGroupingInputs = document.getElementById("timeGroupingInputs");
const minApplicationsInput = document.getElementById("minApplicationsInput");
const sortInputs = document.getElementById("sortInputs");
const groupByCategoryInput = document.getElementById("groupByCategoryInput");
const groupByApplicantTypeInput = document.getElementById("groupByApplicantTypeInput");

reportTypeSelect.addEventListener("change", function () {
    const reportType = parseInt(this.value);

    // Hide all optional inputs initially
    timePeriodInputs.classList.add("hidden");
    categoryFilterInputs.classList.add("hidden");
    applicantTypeInputs.classList.add("hidden");
    timeGroupingInputs.classList.add("hidden");
    minApplicationsInput.classList.add("hidden");
    sortInputs.classList.add("hidden");
    groupByCategoryInput.classList.add("hidden");
    groupByApplicantTypeInput.classList.add("hidden");

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
            groupByCategoryInput.classList.remove("hidden");
            groupByApplicantTypeInput.classList.remove("hidden");
            break;
        case 4: // Trend Comparison
            applicantTypeInputs.classList.remove("hidden");
            timeGroupingInputs.classList.remove("hidden");
            groupByApplicantTypeInput.classList.remove("hidden");
            break;
        case 5: // Success Percentage
            applicantTypeInputs.classList.remove("hidden");
            groupByCategoryInput.classList.remove("hidden");
            groupByApplicantTypeInput.classList.remove("hidden");
            break;
        case 6: // High Activity Periods
            timeGroupingInputs.classList.remove("hidden");
            break;
        case 8: // Highest and Lowest Grants
            timePeriodInputs.classList.remove("hidden");
            categoryFilterInputs.classList.remove("hidden");
            timeGroupingInputs.classList.remove("hidden");
            groupByCategoryInput.classList.remove("hidden");
            groupByApplicantTypeInput.classList.remove("hidden");
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


        // Trigger change event to set default visibility
        reportTypeSelect.dispatchEvent(new Event("change"));
    </script>
</body>
</html>
