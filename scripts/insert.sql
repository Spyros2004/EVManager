SET NOCOUNT ON

ALTER TABLE [dbo].[Discarded_Car] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[User] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Sponsorship_Category] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Applicant] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Criterion] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Category_Has_Criterion] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Application] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Document] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Modification] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Vehicle] NOCHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[User_Session] NOCHECK CONSTRAINT ALL;

INSERT INTO [dbo].[User] ([First_Name], [Last_Name], [Username], [Email], [Password], [User_Type], [Status])
VALUES ('Admin', 'Admin', 'admin', 'admin@example.com', HASHBYTES('SHA2_512', N'1234'), 'Admin', 'approved');
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

SET NOCOUNT ON
DECLARE @UserID INT = 1;

WHILE @UserID <= 5500
BEGIN
    INSERT INTO [dbo].[User] ([First_Name], [Last_Name], [Username], [Email], [Password], [User_Type], [Status])
    VALUES (
        N'FirstName' + CAST(@UserID AS NVARCHAR),
        N'LastName' + CAST(@UserID AS NVARCHAR),
        N'username' + CAST(@UserID AS NVARCHAR),
        N'user' + CAST(@UserID AS NVARCHAR) + N'@example.com',
        HASHBYTES('SHA2_256', N'password' + CAST(@UserID AS NVARCHAR)),
        CASE WHEN @UserID <= 5000 THEN N'Applicant' ELSE N'AA' END,
        CASE WHEN @UserID % 3 = 0 THEN N'approved' ELSE N'pending' END
    );

    SET @UserID = @UserID + 1;
END;

-- Step 2: Populate Applicant Table (5,500 applicants)
DECLARE @ApplicantID INT = 1;

WHILE @ApplicantID <= 5500
BEGIN
    INSERT INTO [dbo].[Applicant] ([Identification], [Company_Private], [Gender], [BirthDate], [Telephone_Number], [Address], [User_ID])
    VALUES (
        CAST(100000000 + @ApplicantID AS NVARCHAR), -- Identification
        CASE WHEN @ApplicantID <= 5000 THEN N'private' ELSE N'company' END,
        CASE WHEN @ApplicantID % 3 = 0 THEN N'M' WHEN @ApplicantID % 3 = 1 THEN N'F' ELSE N'O' END,
        DATEADD(YEAR, -ABS(CHECKSUM(NEWID())) % 60, GETDATE()), -- Random birth date
        990000000 + @ApplicantID, -- Telephone number
        N'Address ' + CAST(@ApplicantID AS NVARCHAR),
        @ApplicantID -- Link to User_ID
    );

    SET @ApplicantID = @ApplicantID + 1;
END;

-- Step 3: Create and Initialize Category Sequence Table
DECLARE @CategorySequence TABLE (
    Category_Number INT PRIMARY KEY,
    Current_Sequence INT
);

INSERT INTO @CategorySequence (Category_Number, Current_Sequence)
VALUES
(1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0),
(8, 0), (9, 0), (10, 0), (11, 0), (12, 0), (13, 0), (14, 0);

-- Step 4: Reserve Applications for Report 10 (at least 5 per category per month for 4 months)
DECLARE @CurrentMonth INT = MONTH(GETDATE());
DECLARE @CurrentYear INT = YEAR(GETDATE());
DECLARE @FourMonthsAgo DATE = DATEADD(MONTH, -3, DATEFROMPARTS(@CurrentYear, @CurrentMonth, 1));
DECLARE @MonthCounter INT = 0;
DECLARE @CategoryToCover INT;
DECLARE @ApplicationDate DATE;
DECLARE @ReservedApplicationID INT = 1;

-- Categories to Cover for Report 10
DECLARE @CategoriesToCover TABLE (Category_Number INT);
INSERT INTO @CategoriesToCover VALUES (1), (5), (10);

-- Insert Applications for the Last 4 Months
WHILE @MonthCounter <= 3
BEGIN
    SET @ApplicationDate = DATEADD(MONTH, @MonthCounter, @FourMonthsAgo);

    DECLARE @CategoryCursor CURSOR;
    SET @CategoryCursor = CURSOR FOR SELECT Category_Number FROM @CategoriesToCover;

    OPEN @CategoryCursor;
    FETCH NEXT FROM @CategoryCursor INTO @CategoryToCover;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insert at least 5 applications per category for the current month
        DECLARE @AppsPerCategory INT = 1;
        WHILE @AppsPerCategory <= 5
        BEGIN
            -- Check Remaining_Positions
            DECLARE @RemainingPositions INT;
            SELECT @RemainingPositions = Remaining_Positions
            FROM [dbo].[Sponsorship_Category]
            WHERE Category_Number = @CategoryToCover;

            IF @RemainingPositions > 4
            BEGIN
                -- Increment Sequence
                DECLARE @CurrentSequence INT;
                SELECT @CurrentSequence = Current_Sequence
                FROM @CategorySequence
                WHERE Category_Number = @CategoryToCover;

                SET @CurrentSequence = @CurrentSequence + 1;

                -- Update Sequence Table
                UPDATE @CategorySequence
                SET Current_Sequence = @CurrentSequence
                WHERE Category_Number = @CategoryToCover;

                -- Insert Application
                INSERT INTO [dbo].[Application] ([Tracking_Number], [Application_Date], [Current_Status], [Applicant_ID], [Category_Number])
                VALUES (
                    N'Γ' + RIGHT(N'0' + CAST(@CategoryToCover AS NVARCHAR), 2) + N'.' + RIGHT(N'0000' + CAST(@CurrentSequence AS NVARCHAR), 4),
                    @ApplicationDate,
                    CASE 
                        WHEN @CurrentSequence % 5 = 0 THEN N'rejected'
                        WHEN @CurrentSequence % 3 = 0 THEN N'approved'
                        ELSE N'active'
                    END,
                    (@ReservedApplicationID % 5500) + 1,
                    @CategoryToCover
                );

                SET @ReservedApplicationID = @ReservedApplicationID + 1;
            END;

            SET @AppsPerCategory = @AppsPerCategory + 1;
        END;

        FETCH NEXT FROM @CategoryCursor INTO @CategoryToCover;
    END;

    CLOSE @CategoryCursor;
    DEALLOCATE @CategoryCursor;

    SET @MonthCounter = @MonthCounter + 1;
END;

-- Step 5: Populate Remaining Applications (Maximize Total Applications)
DECLARE @ApplicationID INT = @ReservedApplicationID;
DECLARE @CategoryNumber INT;


WHILE EXISTS (SELECT 1 FROM [dbo].[Sponsorship_Category] WHERE Remaining_Positions > 0)
BEGIN
    -- Select the next category with available positions
    SELECT TOP 1 @CategoryNumber = Category_Number, @RemainingPositions = Remaining_Positions
    FROM [dbo].[Sponsorship_Category]
    WHERE Remaining_Positions > 0
    ORDER BY Category_Number;

    -- Increment Sequence
    SELECT @CurrentSequence = Current_Sequence
    FROM @CategorySequence
    WHERE Category_Number = @CategoryNumber;

    SET @CurrentSequence = @CurrentSequence + 1;

    -- Update Sequence Table
    UPDATE @CategorySequence
    SET Current_Sequence = @CurrentSequence
    WHERE Category_Number = @CategoryNumber;

    -- Insert Application
    INSERT INTO [dbo].[Application] ([Tracking_Number], [Application_Date], [Current_Status], [Applicant_ID], [Category_Number])
    VALUES (
        N'Γ' + RIGHT(N'0' + CAST(@CategoryNumber AS NVARCHAR), 2) + N'.' + RIGHT(N'0000' + CAST(@CurrentSequence AS NVARCHAR), 4),
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 30, GETDATE()), -- Random future date
        CASE 
            WHEN @ApplicationID % 5 = 0 THEN N'rejected'
            WHEN @ApplicationID % 3 = 0 THEN N'approved'
            ELSE N'active'
        END,
        (@ApplicationID % 5500) + 1,
        @CategoryNumber
    );

    SET @ApplicationID = @ApplicationID + 1;
END;

-- Step: Populate Modification Table
DECLARE @MaxModifications INT = 5; -- Maximum modifications per application
DECLARE @ModificationCount INT;
DECLARE @RandomDate DATE;
DECLARE @RandomStatus NVARCHAR(20);
DECLARE @ModificationID INT = 1

-- Get all Application IDs
DECLARE ApplicationCursor CURSOR FOR 
SELECT Application_ID 
FROM [dbo].[Application];

OPEN ApplicationCursor;
FETCH NEXT FROM ApplicationCursor INTO @ApplicationID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Determine how many modifications to add for this application (1 to 5)
    SET @ModificationCount = ABS(CHECKSUM(NEWID())) % @MaxModifications + 1;

    WHILE @ModificationCount > 0
    BEGIN
        -- Generate a random date within the last 365 days
        SET @RandomDate = DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Generate a random status
        SET @RandomStatus = CASE ABS(CHECKSUM(NEWID())) % 4
            WHEN 0 THEN N'ordered'
            WHEN 1 THEN N'checked'
            WHEN 2 THEN N'rejected'
            ELSE N'approved'
        END;

        -- Assign a random User_ID
        SET @UserID = ABS(CHECKSUM(NEWID())) % 5500 + 1;

        -- Insert the modification
        INSERT INTO [dbo].[Modification] ([Modification_Date], [New_Status], [Reason], [User_ID], [Application_ID])
        VALUES (
            @RandomDate,
            @RandomStatus,
            N'Reason for modification ' + CAST(@ModificationID AS NVARCHAR), -- Random reason
            @UserID,
            @ApplicationID
        );

        -- Increment counters
        SET @ModificationID = @ModificationID + 1;
        SET @ModificationCount = @ModificationCount - 1;
    END;

    -- Move to the next application
    FETCH NEXT FROM ApplicationCursor INTO @ApplicationID;
END;

CLOSE ApplicationCursor;
DEALLOCATE ApplicationCursor;

ALTER TABLE [dbo].[Discarded_Car] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[User] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Sponsorship_Category] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Applicant] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Criterion] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Category_Has_Criterion] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Application] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Modification] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT ALL;
ALTER TABLE [dbo].[User_Session] CHECK CONSTRAINT ALL;
