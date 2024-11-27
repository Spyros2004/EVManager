<?php
// Include the database connection file
include 'connection.php';

// Σύνδεση με τη βάση δεδομένων
$conn = sqlsrv_connect($serverName, $connectionOptions);
if ($conn === false) {
    die(print_r(sqlsrv_errors(), true));
}

// Κλήση του stored procedure
$sql = "{CALL GetSponsorshipCategory()}";
$stmt = sqlsrv_query($conn, $sql);

// Έλεγχος για τυχόν σφάλματα
if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
}
?>
<!DOCTYPE html>
<html lang="el">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EVManager - Κυβέρνηση της Κύπρου</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background: #ffffff;
            color: #2f3d4a;
        }

        .header {
            background: #4CAF50;
            padding: 10px 0;
            text-align: center;
            color: #fff;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            font-size: 1.2em;
        }

        .menu-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            background: #4CAF50;
            position: fixed;
            width: 100%;
            top: 100px;
            z-index: 1000;
            flex-wrap: wrap; /* Εξασφαλίζει ότι τα links θα προσαρμόζονται σε μικρές οθόνες */
        }

        .menu-bar a {
            margin: 0 15px;
            text-decoration: none;
            color: #fff;
            font-size: 1.2em;
            font-weight: 500;
            text-align: center;
            display: inline-block;
        }

        .menu-bar a:hover {
            color: #ffeb3b;
        }

        .content {
            text-align: center;
            padding: 200px 20px;
        }

        .button-container {
            display: flex;
            justify-content: center;
            flex-wrap: wrap; /* Προσαρμογή των κουμπιών */
            gap: 20px;
        }

        .button {
            background-color: #ffb400;
            color: #2f3d4a;
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #e5a200;
        }

        table {
            width: 100%;
            max-width: 1000px; /* Περιορίζει το μέγιστο πλάτος */
            margin: 50px auto;
            border-collapse: collapse;
            background: #fff;
            color: #2f3d4a;
            font-size: 1em;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow-x: auto; /* Ενεργοποιεί οριζόντια κύλιση σε μικρές οθόνες */
            display: block; /* Εξασφαλίζει ότι λειτουργεί σε μικρές οθόνες */
        }

        table,
        th,
        td {
            border: 1px solid #ddd;
        }

        th {
            background: #4CAF50;
            color: #fff;
            text-transform: uppercase;
            padding: 15px;
        }

        td {
            padding: 15px;
            text-align: center;
        }

        td:nth-child(odd) {
            background: #f9f9f9;
        }

        tr:hover {
            background: #e8f5e9;
        }

        footer {
            background: #4CAF50;
            color: #fff;
            padding: 20px;
            text-align: left;
        }

        footer a {
            color: #ffeb3b;
            text-decoration: none;
        }

        footer a:hover {
            text-decoration: underline;
        }

        /* Responsive CSS για μικρές οθόνες */
        @media (max-width: 768px) {
            .header {
                font-size: 1em;
                padding: 15px 0;
            }

            .menu-bar a {
                font-size: 1em;
                margin: 5px 10px;
            }

            table {
                font-size: 0.9em; /* Μειώνει το μέγεθος του κειμένου */
            }

            th, td {
                padding: 10px;
            }
        }
    </style>
</head>

<body>
    <div class="header">
        <h1>Κυβέρνηση της Κύπρου - EVManager</h1>
    </div>
    <div class="menu-bar">
        <a href="index.php">Αρχική</a>
        <a href="makeapplication.php">Αίτηση για Επιχορήγηση</a>
        <a href="faq.php">Συχνές Ερωτήσεις</a>
    </div>
    <div class="content">
        <h1>Σχέδιο Ανάκαμψης και Ανθεκτικότητας - Προώθηση της Ηλεκτροκίνησης στην Κύπρο</h1>
        <img src="CYPRUS-REPUBLIC-LOGO.webp" alt="Έμβλημα Κυπριακής Δημοκρατίας" style="width: 150px; height: auto;">
        <h1>Καλώς ήρθατε στο EVManager</h1>
        <p>
            Η ολοκληρωμένη πλατφόρμα για τη διαχείριση του έργου προώθησης της χρήσης ηλεκτροκίνητων οχημάτων. Εδώ, οι χρήστες μπορούν να διαχειρίζονται τις αιτήσεις επιχορήγησης, τις αξιολογήσεις και την παρακολούθηση του προγράμματος αποτελεσματικά.
        </p>
        <div class="button-container">
            <button class="button" onclick="location.href='login.php';">Σύνδεση</button>
            <button class="button" onclick="location.href='signup.php';">Εγγραφή</button>
        </div>
        <br>
        <br>
        <br>

        <p>
        <h2>Εισαγωγή</h2>
        Το Σχέδιο αυτό χρηματοδοτείται από τον Μηχανισμό Ανάκαμψης και Ανθεκτικότητας της Ευρωπαϊκής Ένωσης, στο πλαίσιο του Σχεδίου Ανάκαμψης και Ανθεκτικότητας (ΣΑΑ) Κύπρου. Το Σχέδιο αφορά στην υλοποίηση τριών παρεμβάσεων σε δύο μέτρα του ΣΑΑ (C2.2I3, C6.1I4), τα οποία στοχεύουν στην προώθηση της ευρείας χρήσης οχημάτων με μηδενικούς ή χαμηλούς ρύπους, μέσω (α) της Απόσυρσης Ρυπογόνων Οχημάτων και Παραχώρησης Κινήτρων για Εναλλακτικούς, Χαμηλών Εκπομπών, Τρόπους Διακίνησης (παρέμβαση C2.2I3c στο ΣΑΑ) και (β) της επιχορήγησης για την Αγορά Ηλεκτροκίνητων Οχημάτων (παρεμβάσεις C2.2I3b και C6.1I4a στο ΣΑΑ).
        </p>
        <br>
        <br>
        <p>
            Η παρούσα προκήρυξη περιλαμβάνει:
            <div class="intro" style="text-align: left; margin-left: 0;">
                <p><strong>Χορηγία για αγορά οχημάτων μηδενικών εκπομπών CO2:</strong> αμιγώς ηλεκτρικών οχημάτων.</p>
                <p><strong>Χορηγία για αγορά ηλεκτρικού ποδηλάτου:</strong> υποβοηθούμενης ποδηλάτησης.</p>
                <p><strong>Απόσυρση παλαιού ρυπογόνου οχήματος:</strong> σε συνδυασμό με την επιχορήγηση της αγοράς οχημάτων με χαμηλές εκπομπές διοξειδίου του άνθρακα (με όριο εκπομπών CO2 τα 50g/km).</p>
                <p><strong>Απόσυρση παλαιού ρυπογόνου οχήματος:</strong> σε συνδυασμό με την παραχώρηση εισιτηρίων λεωφορείου και την καταβολή συμπληρωματικού εφάπαξ ποσού.</p>
            </div>
        </p>
        <br>
        <table>
            <thead>
                <tr>
                    <th>Κατηγορία Χορηγίας</th>
                    <th>Περιγραφή</th>
                    <th>Ποσό Χορηγίας</th>
                    <th>Αριθμός Διαθέσιμων Θέσεων</th>
                </tr>
            </thead>
            <tbody>
                <?php
                while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
                    echo "<tr>";
                    echo "<td>" . htmlspecialchars($row['Category_Number']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['Description']) . "</td>";
                    echo "<td>" . htmlspecialchars(number_format($row['Amount'], 2)) . "</td>";
                    echo "<td>" . htmlspecialchars($row['Remaining_Positions']) . "</td>";
                    echo "</tr>";
                }
                ?>
            </tbody>
        </table>
    </div>
    <footer>
        <strong>Πληροφορίες για τις διαδικτυακές υπηρεσίες του Τμήματος Οδικών Μεταφορών</strong>
        <p>Βασιλέως Παύλου 27, Έγκωμη, 2412 Λευκωσία</p>
        <p>Τηλ: 22807184, 22807153, 22807198</p>
        <p>Φάξ: 22354030</p>
        <p>e-mail: <a href="mailto:roadtransport@rtd.mcw.gov.cy">roadtransport@rtd.mcw.gov.cy</a></p>
    </footer>
</body>

</html>
