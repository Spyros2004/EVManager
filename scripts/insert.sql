INSERT INTO [dbo].[User] ([First_Name], [Last_Name], [Username], [Email], [Password], [User_Type], [Status])
VALUES ('Admin', 'Admin', 'admin', 'admin@example.com', HASHBYTES('SHA2_512', '1234'), 'Admin', 'approved');
GO

INSERT INTO Sponsorship_Category (Description, Amount, Total_Positions)
VALUES
(N'Απόσυρση και αντικατάσταση με καινούργιο όχημα ιδιωτικής χρήσης χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ)', 7500, 1228),
(N'Απόσυρση και αντικατάσταση με καινούργιο όχημα ταξί χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ)', 12000, 30),
(N'Απόσυρση και αντικατάσταση με καινούργιο όχημα χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ) για δικαιούχο αναπηρικού οχήματος', 15000, 30),
(N'Απόσυρση και αντικατάσταση με καινούργιο όχημα χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ) πολύτεκνης οικογένειας', 15000, 30),
(N'Χορηγία για αγορά καινούργιου οχήματος ιδιωτικής χρήσης μηδενικών εκπομπών CO2', 9000, 1827),
(N'Χορηγία για αγορά καινούργιου οχήματος ταξί μηδενικών εκπομπών CO2', 20000, 60),
(N'Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 για δικαιούχο αναπηρικού οχήματος', 20000, 60),
(N'Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 πολύτεκνης οικογένειας', 20000, 60),
(N'Χορηγία για αγορά μεταχειρισμένου οχήματος ιδιωτικής χρήσης μηδενικών εκπομπών CO2', 9000, 104),
(N'Χορηγία για αγορά καινούργιου ηλεκτρικού οχήματος κατηγορίας Ν1 (εμπορικό μικτού βάρους μέχρι 3.500 κιλά) μηδενικών εκπομπών CO2', 15000, 185),
(N'Χορηγία για αγορά καινούργιου ηλεκτρικού οχήματος κατηγορίας Ν2 (εμπορικό μικτού βάρους που υπερβαίνει τα 3.500 κιλά αλλά δεν υπερβαίνει τα 12.000 κιλά) μηδενικών εκπομπών CO2', 25000, 4),
(N'Χορηγία για αγορά καινούργιου οχήματος κατηγορίας M2 μηδενικών εκπομπών CO2 (μικρό λεωφορείο το οποίο περιλαμβάνει περισσότερες από οκτώ θέσεις καθημένων πέραν του καθίσματος του οδηγού και έχει μέγιστη μάζα το πολύ 5 τόνους)', 40000, 2),
(N'Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 κατηγορίας L6e (υποκατηγορία "Β") και L7e (υποκατηγορία "C")', 4000, 65),
(N'Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 κατηγορίας L (εξαιρουμένων των οχημάτων κατηγορίας L6e (υποκατηγορία "Β") και L7e (υποκατηγορία "Β και C"))', 1500, 893),
(N'Χορηγία για αγορά καινούργιου ηλεκτρικού ποδήλατου (υποβοηθούμενης ποδηλάτησης) χωρίς περιορισμό για τη θέση του κινητήρα ή της μπαταρίας', 500, 933),
(N'Απόσυρση έναντι παροχής δωρεάν εισιτηρίων αξίας €250 για χρήση στις τακτικές γραμμές λεωφορείων και του εφάπαξ ποσού των €500', 750, 72);
GO

INSERT INTO [dbo].[Criterion] ([Title], [Description])
VALUES
('Discard Car', N'Απαιτείται απόσυρση παλαιού οχήματος'),
('Euro 6d compliance', N'Το όχημα πρέπει να συμμορφώνεται με το πρότυπο Euro 6d ή νεότερο'),
('Purchase Price', N'Η τιμή αγοράς πρέπει να είναι μικρότερη ή ίση με 80,000 ευρώ'),
('CO2 Emissions', N'Οι εκπομπές CO2 δεν πρέπει να υπερβαίνουν τα 50 g/km'),
('Electric Vehicle', N'Το όχημα πρέπει να είναι αμιγώς ηλεκτρικό'),
('Ownership Restriction', N'Απαγορεύεται η μεταβίβαση για 2 έτη'),
('Taxi Use', N'Το όχημα πρέπει να διατηρηθεί ως ταξί για τουλάχιστον 5 έτη'),
('Multiple Dependents', N'Ο αιτητής πρέπει να είναι πολύτεκνος με τουλάχιστον 4 εξαρτώμενα παιδιά'),
('Disabled Accessibility', N'Ο αιτητής πρέπει να είναι άτομο με αναπηρίες'),
('New Vehicle Requirement', N'Το όχημα πρέπει να είναι καινούργιο και να μην έχει καταχωρηθεί προγενέστερα')
  GO

-- Γ1: Απόσυρση και αντικατάσταση με καινούργιο όχημα ιδιωτικής χρήσης χαμηλών εκπομπών CO2
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(1, 1), -- Discard Car
(1, 2), -- Euro 6d compliance
(1, 3), -- Purchase Price
(1, 4), -- CO2 Emissions
(1, 10); -- New Vehicle Requirement
GO

-- Γ2: Απόσυρση και αντικατάσταση με καινούργιο όχημα ταξί χαμηλών εκπομπών CO2
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(2, 1), -- Discard Car
(2, 2), -- Euro 6d compliance
(2, 3), -- Purchase Price
(2, 4), -- CO2 Emissions
(2, 6), -- Taxi Use
(2, 10); -- New Vehicle Requirement
GO

-- Γ3: Απόσυρση και αντικατάσταση με καινούργιο όχημα χαμηλών εκπομπών CO2 για δικαιούχο αναπηρικού οχήματος
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(3, 1), -- Discard Car
(3, 2), -- Euro 6d compliance
(3, 3), -- Purchase Price
(3, 4), -- CO2 Emissions
(3, 9), -- Disabled Accessibility
(3, 10); -- New Vehicle Requirement
GO

-- Γ4: Απόσυρση και αντικατάσταση με καινούργιο όχημα χαμηλών εκπομπών CO2 πολύτεκνης οικογένειας
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(4, 1), -- Discard Car
(4, 2), -- Euro 6d compliance
(4, 3), -- Purchase Price
(4, 4), -- CO2 Emissions
(4, 8), -- Multiple Dependents
(4, 10); -- New Vehicle Requirement
GO

-- Γ5: Χορηγία για αγορά καινούργιου οχήματος ιδιωτικής χρήσης μηδενικών εκπομπών CO2
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(5, 3), -- Purchase Price
(5, 4), -- CO2 Emissions
(5, 5), -- Electric Vehicle
(5, 6), -- Ownership Restriction
(5, 10); -- New Vehicle Requirement
GO

-- Γ6: Χορηγία για αγορά καινούργιου οχήματος ταξί μηδενικών εκπομπών CO2
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(6, 3), -- Purchase Price
(6, 5), -- Electric Vehicle
(6, 6), -- Taxi Use
(6, 7), -- Ownership Restriction
(6, 10); -- New Vehicle Requirement
GO

-- Γ7: Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 για δικαιούχο αναπηρικού οχήματος
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(7, 3), -- Purchase Price
(7, 5), -- Electric Vehicle
(7, 6), -- Ownership Restriction
(7, 9), -- Disabled Accessibility
(7, 10); -- New Vehicle Requirement
GO

-- Γ8: Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 πολύτεκνης οικογένειας
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(8, 3), -- Purchase Price
(8, 5), -- Electric Vehicle
(8, 6), -- Ownership Restriction
(8, 8), -- Multiple Dependents
(8, 10); -- New Vehicle Requirement
GO

-- Γ10: Χορηγία για αγορά καινούργιου ηλεκτρικού οχήματος κατηγορίας Ν1
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(10, 3), -- Purchase Price
(10, 5), -- Electric Vehicle
(10, 6), -- Ownership Restriction
(10, 10); -- New Vehicle Requirement
GO

-- Γ11: Χορηγία για αγορά καινούργιου ηλεκτρικού οχήματος κατηγορίας Ν2
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(11, 3), -- Purchase Price
(11, 5), -- Electric Vehicle
(11, 6), -- Ownership Restriction
(11, 10); -- New Vehicle Requirement
GO

-- Γ12: Χορηγία για αγορά καινούργιου οχήματος κατηγορίας M2
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(12, 3), -- Purchase Price
(12, 5), -- Electric Vehicle
(12, 6), -- Ownership Restriction
(12, 10); -- New Vehicle Requirement
GO

-- Γ13: Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 κατηγορίας L6e/L7e
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(13, 3), -- Purchase Price
(13, 5), -- Electric Vehicle
(13, 6), -- Ownership Restriction
(13, 10); -- New Vehicle Requirement
GO

-- Γ14: Χορηγία για αγορά καινούργιου οχήματος κατηγορίας L
INSERT INTO [dbo].[Category_Has_Criterion] ([Category_Number], [Criterion_Number]) VALUES
(14, 3), -- Purchase Price
(14, 5), -- Electric Vehicle
(14, 6), -- Ownership Restriction
(14, 10); -- New Vehicle Requirement
GO
