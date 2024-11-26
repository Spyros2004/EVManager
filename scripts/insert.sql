-- Insert some users into the User table
INSERT INTO [dbo].[User] ([First_Name], [Last_Name], [Username], [Email], [Password], [User_Type], [Status]) 
VALUES 
('John', 'Doe', 'johndoe', 'johndoe@example.com', 'hashedpassword1', 'Applicant', 'pending'),
('Alice', 'Smith', 'alicesmith', 'alicesmith@example.com', 'hashedpassword2', 'Admin', 'approved'),
('Bob', 'Brown', 'bobbrown', 'bobbrown@example.com', 'hashedpassword3', 'TOM', 'suspended'),
('Charlie', 'Davis', 'charliedavis', 'charliedavis@example.com', 'hashedpassword4', 'AA', 'deactivated');

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
