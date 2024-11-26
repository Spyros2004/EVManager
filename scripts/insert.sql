-- Insert some users into the User table
INSERT INTO [dbo].[User] ([First_Name], [Last_Name], [Username], [Email], [Password], [User_Type], [Status]) 
VALUES 
('John', 'Doe', 'johndoe', 'johndoe@example.com', HASHBYTES('SHA2_512', '1234'), 'Applicant', 'pending'),
('Alice', 'Smith', 'alicesmith', 'alicesmith@example.com', HASHBYTES('SHA2_512', '1234'), 'Admin', 'approved'),
('Bob', 'Brown', 'bobbrown', 'bobbrown@example.com', HASHBYTES('SHA2_512', '1234'), 'TOM', 'suspended'),
('Charlie', 'Davis', 'charliedavis', 'charliedavis@example.com', HASHBYTES('SHA2_512', '1234'), 'AA', 'deactivated');

-- Insert some categories into the Sponsorship_Category table
INSERT INTO [dbo].[Sponsorship_Category] ([Description], [Amount], [Total_Positions], [Remaining_Positions]) 
VALUES 
('Category 1', 1000.00, 10, 5),
('Category 2', 500.00, 15, 10),
('Category 3', 1500.00, 5, 3);

-- Insert some applicants into the Applicant table
INSERT INTO [dbo].[Applicant] ([Identification], [Company_Private], [Gender], [BirthDate], [User_ID]) 
VALUES 
('ID12345', 'company', 'M', '1990-05-20', 1),
('ID67890', 'private', 'F', '1985-08-15', 2),
('ID11223', 'company', 'O', '1992-02-25', 3);

-- Insert some criteria into the Criteria table
INSERT INTO [dbo].[Criteria] ([Title], [Description]) 
VALUES 
('Criterion 1', 'Description of criterion 1'),
('Criterion 2', 'Description of criterion 2'),
('Criterion 3', 'Description of criterion 3');

-- Insert some associations between categories and criteria into the Has table
INSERT INTO [dbo].[Has] ([Category_Number], [Criteria_Number]) 
VALUES 
(1, 1),
(2, 2),
(3, 3);

-- Insert applications for applicants into the Application table
INSERT INTO [dbo].[Application] ([Application_Date], [Discarder_Car_LPN], [Attempt], [Current_Status], [Applicant_ID], [Category_Number]) 
VALUES 
('2024-11-26', 'ABC123', 1, 'pending', 1, 1),
('2024-11-26', 'XYZ456', 1, 'approved', 2, 2),
('2024-11-26', 'LMN789', 1, 'rejected', 3, 3);

-- Insert some documents for applications into the Document table
INSERT INTO [dbo].[Document] ([URL], [Document_Type], [Reason], [Application_ID], [User_ID]) 
VALUES 
('http://example.com/doc1.pdf', 'type1', 'Supporting Document 1', 1, 1),
('http://example.com/doc2.pdf', 'type2', 'Supporting Document 2', 2, 2),
('http://example.com/doc3.pdf', 'type3', 'Supporting Document 3', 3, 3);

-- Insert changes to applications into the Change table
INSERT INTO [dbo].[Change] ([Modification_Date], [New_Status], [Reason], [User_ID], [Application_ID]) 
VALUES 
('2024-11-26', 'approved', 'Verified eligibility', 1, 1),
('2024-11-26', 'rejected', 'Insufficient documentation', 2, 2),
('2024-11-26', 'under_review', 'Pending further evaluation', 3, 3);

-- Insert some vehicles into the Vehicle table
INSERT INTO [dbo].[Vehicle] ([Vehicle_Year], [Vehicle_Month], [Vehicle_Type], [CO2_Emissions], [Brand], [Price], [Engine_Fuel], [Document_ID]) 
VALUES 
(2022, 5, 'electric', 0, 'Tesla', 50000.00, 'electricity', 1),
(2021, 8, 'hybrid', 50, 'Toyota', 25000.00, 'petrol', 2),
(2020, 3, 'electric', 0, 'Nissan', 30000.00, 'electricity', 3);

-- Insert a user session into the User_Session table
INSERT INTO [dbo].[User_Session] ([User_ID], [Session_Token], [Login_Time]) 
VALUES 
(1, 'abc123token', '2024-11-26 08:30:00'),
(2, 'xyz456token', '2024-11-26 09:00:00'),
(3, 'lmn789token', '2024-11-26 09:30:00');









INSERT INTO Sponsorship_Category (Description, Amount, Total_Positions)
VALUES
('Απόσυρση και αντικατάσταση με καινούργιο όχημα ιδιωτικής χρήσης χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ)', 7500, 1228),
('Απόσυρση και αντικατάσταση με καινούργιο όχημα ταξί χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ)', 12000, 30),
('Απόσυρση και αντικατάσταση με καινούργιο όχημα χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ) για δικαιούχο αναπηρικού οχήματος', 15000, 30),
('Απόσυρση και αντικατάσταση με καινούργιο όχημα χαμηλών εκπομπών CO2 (μέχρι 50 γρ/χλμ) πολύτεκνης οικογένειας', 15000, 30),
('Χορηγία για αγορά καινούργιου οχήματος ιδιωτικής χρήσης μηδενικών εκπομπών CO2', 9000, 1827),
('Χορηγία για αγορά καινούργιου οχήματος ταξί μηδενικών εκπομπών CO2', 20000, 60),
('Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 για δικαιούχο αναπηρικού οχήματος', 20000, 60),
('Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 πολύτεκνης οικογένειας', 20000, 60),
('Χορηγία για αγορά μεταχειρισμένου οχήματος ιδιωτικής χρήσης μηδενικών εκπομπών CO2', 9000, 104),
('Χορηγία για αγορά καινούργιου ηλεκτρικού οχήματος κατηγορίας Ν1 (εμπορικό μικτού βάρους μέχρι 3.500 κιλά) μηδενικών εκπομπών CO2', 15000, 185),
('Χορηγία για αγορά καινούργιου ηλεκτρικού οχήματος κατηγορίας Ν2 (εμπορικό μικτού βάρους που υπερβαίνει τα 3.500 κιλά αλλά δεν υπερβαίνει τα 12.000 κιλά) μηδενικών εκπομπών CO2', 25000, 4),
('Χορηγία για αγορά καινούργιου οχήματος κατηγορίας M2 μηδενικών εκπομπών CO2 (μικρό λεωφορείο το οποίο περιλαμβάνει περισσότερες από οκτώ θέσεις καθημένων πέραν του καθίσματος του οδηγού και έχει μέγιστη μάζα το πολύ 5 τόνους)', 40000, 2),
('Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 κατηγορίας L6e (υποκατηγορία «Β») και L7e (υποκατηγορία «C»)', 4000, 65),
('Χορηγία για αγορά καινούργιου οχήματος μηδενικών εκπομπών CO2 κατηγορίας L (εξαιρουμένων των οχημάτων κατηγορίας L6e (υποκατηγορία «Β») και L7e (υποκατηγορία «Β και C»))', 1500, 893),
('Χορηγία για αγορά καινούργιου ηλεκτρικού ποδήλατου (υποβοηθούμενης ποδηλάτησης) χωρίς περιορισμό για τη θέση του κινητήρα ή της μπαταρίας', 500, 933),
('Απόσυρση έναντι παροχής δωρεάν εισιτηρίων αξίας €250 για χρήση στις τακτικές γραμμές λεωφορείων και του εφάπαξ ποσού των €500', 750, 72);


INSERT INTO Category_Has_Criterion (Category_Number, Criterion_ID)
VALUES (1,1),
(2,1),
(3,1),
(4,1),
(1,2),
(2,2),
(3,2),
(4,2),
(5,3),
(6,3),
(7,3),
(8,3),
(10,3),
(11,3),
(12,3),
(13,3),
(14,3),
(1,4),
(2,4),
(3,4),
(4,4),
(5,4),
(6,4),
(7,4),
(8,4),
(10,4),
(11,4),
(12,4),
(13,4),
(14,4),
(1,5),
(2,5),
(3,5),
(4,5),
(5,5),
(6,5),
(7,5),
(8,5),
(10,5),
(11,5),
(12,5),
(1,6),
(2,6),
(3,6),
(4,6),
(10,7),
(11,7),
(12,7),
(10,8),
(11,8),
(12,8),
(13,8),
(14,8),
(1,9),
(2,9),
(3,9),
(4,9),
(5,9),
(6,9),
(7,9),
(8,9),
(10,9),
(11,9),
(12,9),
(13,9),
(14,9)
