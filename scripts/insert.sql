-- Inserting random data for [dbo].[User]
INSERT INTO [dbo].[User] (First_Name, Last_Name, Username, Email, Password, User_Type, Status)
VALUES 
('John', 'Doe', 'john_doe', 'john.doe@example.com', 'password123', 'Admin', 'approved'),
('Jane', 'Smith', 'jane_smith', 'jane.smith@example.com', 'password123', 'TOM', 'pending'),
('Michael', 'Brown', 'michael_brown', 'michael.brown@example.com', 'password123', 'User', 'approved'),
('Sarah', 'Johnson', 'sarah_johnson', 'sarah.johnson@example.com', 'password123', 'AA', 'suspended'),
('Emily', 'Davis', 'emily_davis', 'emily.davis@example.com', 'password123', 'Applicant', 'approved');
GO

-- Inserting random data for [dbo].[Sponsorship_Category]
INSERT INTO [dbo].[Sponsorship_Category] (Description, Amount, Total_Positions, Remaining_Positions)
VALUES 
('Category 1: Tech', 10000.00, 50, 25),
('Category 2: Education', 20000.00, 100, 70),
('Category 3: Healthcare', 15000.00, 30, 20),
('Category 4: Environment', 12000.00, 40, 30),
('Category 5: Finance', 50000.00, 20, 15);
GO

-- Inserting random data for [dbo].[Applicant]
INSERT INTO [dbo].[Applicant] (Company_Private, Gender, BirthDate, User_ID)
VALUES 
('company', 'M', '1980-05-15', 1),  
('private', 'F', '1990-08-25', 2),  
('company', 'M', '1985-03-10', 3), 
('private', 'F', '1995-11-12', 4), 
('company', 'O', '1992-07-30', 5);  
GO

-- Inserting random data for [dbo].[Criteria]
INSERT INTO [dbo].[Criteria] (Criteria_Number, Title, Description)
VALUES 
('CR001', 'Criterion 1', 'Description of Criterion 1'),
('CR002', 'Criterion 2', 'Description of Criterion 2'),
('CR003', 'Criterion 3', 'Description of Criterion 3'),
('CR004', 'Criterion 4', 'Description of Criterion 4'),
('CR005', 'Criterion 5', 'Description of Criterion 5');
GO

-- Inserting random data for [dbo].[Has]
INSERT INTO [dbo].[Has] (Category_Number, Criteria_Number)
VALUES 
(1, 'CR001'),
(2, 'CR002'),
(3, 'CR003'),
(4, 'CR004'),
(5, 'CR005');
GO

-- Inserting random data for [dbo].[Application]
INSERT INTO [dbo].[Application] (Application_Date, Discarder_Car_LPN, Attempt, Current_Status, Applicant_ID, Category_Number)
VALUES 
('2024-11-01', 'AB1234', 1, 'pending', 1, 1), 
('2024-11-02', 'CD5678', 1, 'approved', 2, 2),
('2024-11-03', 'EF9101', 1, 'rejected', 3, 3),
('2024-11-04', 'GH2345', 1, 'under_review', 4, 4),  
('2024-11-05', 'IJ6789', 1, 'in_progress', 5, 5); 
GO

-- Inserting random data for [dbo].[Document]
INSERT INTO [dbo].[Document] (URL, Document_Type, Reason, Application_ID, User_ID)
VALUES 
('http://example.com/doc1', 'type1', 'Reason for document 1', 1, 1),  
('http://example.com/doc2', 'type2', 'Reason for document 2', 2, 2), 
('http://example.com/doc3', 'type3', 'Reason for document 3', 3, 3), 
('http://example.com/doc4', 'type1', 'Reason for document 4', 4, 4),  
('http://example.com/doc5', 'type2', 'Reason for document 5', 5, 5);  
GO

-- Inserting random data for [dbo].[Change]
INSERT INTO [dbo].[Change] (Modification_Date, New_Status, Reason, User_ID, Application_ID)
VALUES 
('2024-11-06', 'approved', 'Approved after review', 1, 1), 
('2024-11-07', 'rejected', 'Rejected due to criteria mismatch', 2, 2), 
('2024-11-08', 'under_review', 'Under review for further information', 3, 3),  
('2024-11-09', 'approved', 'Approved based on performance', 4, 4), 
('2024-11-10', 'rejected', 'Rejected for missing documents', 5, 5);  
GO

-- Inserting random data for [dbo].[Vehicle]
INSERT INTO [dbo].[Vehicle] (Vehicle_Year, Vehicle_Month, Vehicle_Type, CO2_Emissions, Brand, Price, Engine_Fuel, Document_ID)
VALUES 
(2022, 5, 'electric', 10, 'Tesla', 70000.00, 'electricity', 1),  
(2021, 7, 'hybrid', 25, 'Toyota', 35000.00, 'petrol', 2),
(2023, 3, 'electric', 5, 'BMW', 75000.00, 'electricity', 3), 
(2020, 11, 'hybrid', 20, 'Honda', 30000.00, 'diesel', 4), 
(2024, 6, 'electric', 8, 'Audi', 80000.00, 'electricity', 5); 
GO
