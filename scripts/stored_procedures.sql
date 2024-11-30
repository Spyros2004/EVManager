-- 1. Drop Procedure for selecting all records from User table
DROP PROCEDURE IF EXISTS GetUser;
GO

-- 2. Drop Procedure for selecting all records from Sponsorship_Category table
DROP PROCEDURE IF EXISTS GetSponsorshipCategory;
GO

-- 3. Drop Procedure for selecting all records from Applicant table
DROP PROCEDURE IF EXISTS GetApplicant;
GO

-- 4. Drop Procedure for selecting all records from Criterion table
DROP PROCEDURE IF EXISTS GetCriterion;
GO

-- 5. Drop Procedure for selecting all records from Category_Has_Criterion table
DROP PROCEDURE IF EXISTS GetCategoryHasCriterion;
GO

-- 6. Drop Procedure for selecting all records from Application table
DROP PROCEDURE IF EXISTS GetApplication;
GO

-- 7. Drop Procedure for selecting all records from Document table
DROP PROCEDURE IF EXISTS GetDocument;
GO

-- 8. Drop Procedure for selecting all records from Modification table
DROP PROCEDURE IF EXISTS GetModification;
GO

-- 9. Drop Procedure for selecting all records from Vehicle table
DROP PROCEDURE IF EXISTS GetVehicle;
GO

-- 10. Drop Procedure for selecting all records from User_Session table
DROP PROCEDURE IF EXISTS GetUserSession;
GO

-- 10. Drop Procedure for Sign Up
DROP PROCEDURE IF EXISTS SignUpUser
GO

-- 11. Drop Procedure for Login
DROP PROCEDURE IF EXISTS LoginUser
GO

-- 12. Drop procedure for application
DROP PROCEDURE IF EXISTS ApplyForSponsorship
GO

DROP PROCEDURE IF EXISTS GetApplicationsForUser
GO

DROP PROCEDURE IF EXISTS GetUsernameBySessionID
GO

DROP PROCEDURE IF EXISTS [dbo].[LogoutUser]
GO

DROP PROCEDURE IF EXISTS GetPendingUsers
GO

DROP PROCEDURE IF EXISTS AcceptOrRejectUser
GO

DROP PROCEDURE IF EXISTS GetDiscardedCar
GO

CREATE PROCEDURE GetDiscardedCar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Discarded_Car];
END
GO

CREATE PROCEDURE AcceptOrRejectUser
    @UserID INT,          -- ID of the user to be updated
    @Accept BIT           -- TRUE (1) to approve, FALSE (0) to reject
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the user exists
    IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE User_ID = @UserID)
    BEGIN
        THROW 50001, 'User does not exist.', 1;
    END

    -- Update the user's status based on the @Accept flag
    IF @Accept = 1
    BEGIN
        -- If the user is accepted, set their status to 'approved'
        UPDATE [dbo].[User]
        SET Status = 'approved'
        WHERE User_ID = @UserID;
    END
    ELSE
    BEGIN
        -- If the user is rejected, set their status to 'rejected'
        UPDATE [dbo].[User]
        SET Status = 'rejected'
        WHERE User_ID = @UserID;
    END
END
GO

CREATE PROCEDURE GetPendingUsers
AS
BEGIN
    SET NOCOUNT ON;

    -- Query to fetch all users with status 'pending'
    SELECT 
        User_ID, 
        First_Name, 
        Last_Name, 
        Username, 
        Email, 
        User_Type, 
        Status
    FROM [dbo].[User]
    WHERE Status = 'pending';
END
GO

CREATE PROCEDURE GetUsernameBySessionID
    @SessionID UNIQUEIDENTIFIER,
    @Username NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Get the User_ID from the session
    DECLARE @UserID INT;
    SELECT @UserID = User_ID
    FROM [dbo].[User_Session]
    WHERE Session_ID = @SessionID;

    -- Ensure the User_ID was found
    IF @UserID IS NULL
    BEGIN
        THROW 50000, 'Invalid Session ID', 1;
        RETURN;
    END

    -- Fetch the username for the User_ID
    SELECT @Username = Username
    FROM [dbo].[User]
    WHERE User_ID = @UserID;
END;
GO

CREATE PROCEDURE GetApplicationsForUser
    @SessionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    -- Get the User_ID from the session
    DECLARE @UserID INT;
    SELECT @UserID = User_ID
    FROM [dbo].[User_Session]
    WHERE Session_ID = @SessionID;

    -- Ensure the User_ID was found
    IF @UserID IS NULL
    BEGIN
        THROW 50000, 'Invalid Session ID', 1;
        RETURN;
    END

    -- Fetch applications for the user
    SELECT A.Application_ID, A.Application_Date, A.Current_Status, SC.Description AS Category_Description
    FROM [dbo].[Application] A
    INNER JOIN [dbo].[Applicant] AP ON A.Applicant_ID = AP.Applicant_ID
    INNER JOIN [dbo].[User] U ON AP.User_ID = U.User_ID
    INNER JOIN [dbo].[Sponsorship_Category] SC ON A.Category_Number = SC.Category_Number
    WHERE U.User_ID = @UserID;
END;
GO
    
CREATE PROCEDURE [dbo].[LogoutUser]
    @Session_ID UNIQUEIDENTIFIER -- Input parameter for the session ID
AS
BEGIN
    SET NOCOUNT ON;

    -- Attempt to delete the session from the User_Session table
    BEGIN TRY
        DELETE FROM [dbo].[User_Session]
        WHERE [Session_ID] = @Session_ID;

        -- If no session is found to delete, you can raise an error or just proceed
        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50000, 'No active session found for this session ID.', 1;
        END
    END TRY
    BEGIN CATCH
        -- Handle errors and rethrow the original error
        THROW; -- Re-throws the original error
    END CATCH
END
GO

-- 1. Stored Procedure for selecting all records from User table
CREATE PROCEDURE GetUser
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[User];
END
GO

-- 2. Stored Procedure for selecting all records from Sponsorship_Category table
CREATE PROCEDURE GetSponsorshipCategory
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Sponsorship_Category];
END
GO

-- 3. Stored Procedure for selecting all records from Applicant table
CREATE PROCEDURE GetApplicant
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Applicant];
END
GO

-- 4. Stored Procedure for selecting all records from Criterion table
CREATE PROCEDURE GetCriterion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Criterion];
END
GO

-- 5. Stored Procedure for selecting all records from Category_Has_Criterion table
CREATE PROCEDURE GetCategoryHasCriterion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Category_Has_Criterion];
END
GO

-- 6. Stored Procedure for selecting all records from Application table
CREATE PROCEDURE GetApplication
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Application];
END
GO

-- 7. Stored Procedure for selecting all records from Document table
CREATE PROCEDURE GetDocument
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Document];
END
GO

-- 8. Stored Procedure for selecting all records from Modification table
CREATE PROCEDURE GetModification
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Modification];
END
GO

-- 9. Stored Procedure for selecting all records from Vehicle table
CREATE PROCEDURE GetVehicle
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Vehicle];
END
GO

-- 10. Stored Procedure for selecting all records from User_Session table
CREATE PROCEDURE GetUserSession
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[User_Session];
END
GO

CREATE PROCEDURE [dbo].SignUpUser
    @First_Name NVARCHAR(50),
    @Last_Name NVARCHAR(50),
    @Username NVARCHAR(50),
    @Email NVARCHAR(100),
    @Password NVARCHAR(255),
    @User_Type NVARCHAR(20),
    @Identification NVARCHAR(20) = NULL,   -- Only required if user is an applicant
    @Company_Private NVARCHAR(20) = NULL,  -- Only required if user is an applicant
    @Gender CHAR(1) = NULL,                -- Only required if user is an applicant
    @BirthDate DATE = NULL,                -- Only required if user is an applicant
    @Telephone_Number INT = NULL,          -- Only required if user is an applicant
    @Address NVARCHAR(255) = NULL          -- Only required if user is an applicant
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for NULL values in essential fields for User
    IF @First_Name IS NULL OR @Last_Name IS NULL OR @Username IS NULL 
        OR @Email IS NULL OR @Password IS NULL OR @User_Type IS NULL
    BEGIN
        THROW 50005, 'All user fields (First_Name, Last_Name, Username, Email, Password, User_Type) are required.', 1;
        RETURN;
    END

    -- Check if Username or Email already exists
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Username] = @Username)
    BEGIN
        THROW 50001, 'Username already exists. Please choose a different one.', 1;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Email] = @Email)
    BEGIN
        THROW 50002, 'Email already exists. Please use a different one.', 1;
        RETURN;
    END

    -- Additional checks if the User_Type is 'Applicant'
    IF @User_Type = 'Applicant'
    BEGIN
        -- Check if all required Applicant fields are provided
        IF @Identification IS NULL OR @Company_Private IS NULL OR @Gender IS NULL 
           OR @BirthDate IS NULL OR @Telephone_Number IS NULL OR @Address IS NULL
        BEGIN
            THROW 50003, 'For applicants, all fields (Identification, Company_Private, Gender, BirthDate, Telephone_Number, Address) are required.', 1;
            RETURN;
        END

        -- Check if Identification already exists in Applicant table
        IF EXISTS (SELECT 1 FROM [dbo].[Applicant] WHERE [Identification] = @Identification)
        BEGIN
            THROW 50004, 'Identification already exists for another user. Please provide a different Identification.', 1;
            RETURN;
        END
    END

    -- Hash the password using SHA-512
    DECLARE @HashedPassword VARBINARY(512);
    SET @HashedPassword = HASHBYTES('SHA2_512', @Password);

    -- Start a transaction for the user and applicant inserts
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insert the new user into the User table
        INSERT INTO [dbo].[User] 
            ([First_Name], [Last_Name], [Username], [Email], [Password], [User_Type])
        VALUES
            (@First_Name, @Last_Name, @Username, @Email, @HashedPassword, @User_Type);

        -- Retrieve the User_ID of the newly inserted user using SCOPE_IDENTITY()
        DECLARE @User_ID INT;
        SET @User_ID = SCOPE_IDENTITY();

        -- If the user is an 'Applicant', insert into the Applicant table
        IF @User_Type = 'Applicant'
        BEGIN
            INSERT INTO [dbo].[Applicant] 
                ([Identification], [Company_Private], [Gender], [BirthDate], [Telephone_Number], [Address], [User_ID])
            VALUES
                (@Identification, @Company_Private, @Gender, @BirthDate, @Telephone_Number, @Address, @User_ID);
        END

        -- Commit the transaction if everything is successful
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Handle error and rollback transaction
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


CREATE PROCEDURE [dbo].[LoginUser]
    @Username NVARCHAR(50),
    @Password NVARCHAR(255), -- Plain text password from PHP
    @Session_ID UNIQUEIDENTIFIER OUTPUT, -- Output parameter for the session ID
    @UserTypeNumber INT OUTPUT -- Output parameter for the user type number
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Declare variables to hold the stored password hash, status, user ID, and user type
        DECLARE @StoredPassword VARBINARY(512);
        DECLARE @Status VARCHAR(20);
        DECLARE @User_ID INT;
        DECLARE @User_Type VARCHAR(20);

        -- Fetch the password hash, status, user type, and user ID for the given username
        SELECT @StoredPassword = [Password], @Status = [Status], @User_Type = [User_Type], @User_ID = [User_ID]
        FROM [dbo].[User]
        WHERE [Username] = @Username;

        -- Check if the username exists
        IF @StoredPassword IS NULL
        BEGIN
            -- Throw an error for invalid username
            THROW 50000, 'Invalid Username', 1;
        END

        -- Check if the user's status is "pending"
        IF @Status = 'pending'
        BEGIN
            -- Throw an error if the user is in "pending" status
            THROW 50002, 'Account is pending approval. Please wait for admin approval.', 1;
        END

        -- Compare the stored hashed password with the provided password
        IF @StoredPassword != HASHBYTES('SHA2_512', @Password)
        BEGIN
            -- Throw an error for incorrect password
            THROW 50001, 'Incorrect Password', 1;
        END

        SET @Session_ID = NEWID(); -- Generate unique session ID

        -- Insert a new session record into the User_Session table
        INSERT INTO [dbo].[User_Session] (Session_ID, User_ID, Login_Time)
        VALUES (@Session_ID, @User_ID, DEFAULT);

        -- Set the user type number based on the User_Type
        SET @UserTypeNumber = 
            CASE 
                WHEN @User_Type = 'Admin' THEN 1
                WHEN @User_Type = 'TOM' THEN 2
                WHEN @User_Type = 'AA' THEN 3
                WHEN @User_Type = 'Applicant' THEN 4
                ELSE 0 -- Default number for unknown user types
            END;

    END TRY
    BEGIN CATCH
        -- Handle errors and rethrow the error
        THROW; -- Re-throws the original error
    END CATCH
END
GO

DROP PROCEDURE IF EXISTS ApplyForSponsorship;
GO

DROP PROCEDURE IF EXISTS ApplyForSponsorship
GO

CREATE PROCEDURE ApplyForSponsorship
    @SessionID UNIQUEIDENTIFIER,
    @CategoryNumber INT,
    @LicensePlate CHAR(6) = NULL, -- Optional for non-category 1-4
    @Document NVARCHAR(255) = NULL, -- File name for the required document (if applicable)
    @TrackingNumber NVARCHAR(8) OUTPUT -- Tracking number to be returned
AS
BEGIN
    SET NOCOUNT ON;

    -- Retrieve User_ID from the session
    DECLARE @UserID INT;
    SELECT @UserID = User_ID
    FROM User_Session
    WHERE Session_ID = @SessionID;

    -- Ensure the user exists and is an applicant
    IF NOT EXISTS (
        SELECT 1 FROM Applicant WHERE User_ID = @UserID
    )
    BEGIN
        THROW 50000, 'User is not an applicant.', 1;
    END;

    DECLARE @ApplicantID INT;
    SELECT @ApplicantID = Applicant_ID
    FROM Applicant
    WHERE User_ID = @UserID;

    -- Check if the applicant has 2 applications with expired status
    IF (
        SELECT COUNT(*) 
        FROM Application 
        WHERE Applicant_ID = @ApplicantID AND Current_Status = 'expired'
    ) >= 2
    BEGIN
        THROW 50004, 'Applicant has 2 applications with expired status.', 1;
    END;

    -- Check if the applicant has 2 applications with declined status
    IF (
        SELECT COUNT(*) 
        FROM Application 
        WHERE Applicant_ID = @ApplicantID AND Current_Status = 'declined'
    ) >= 2
    BEGIN
        THROW 50005, 'Applicant has 2 applications with declined status.', 1;
    END;

    -- Check if the applicant is private and attempting category 1-12 but already has an active/accepted application
    IF (
        EXISTS (
            SELECT 1 
            FROM Applicant 
            WHERE Applicant_ID = @ApplicantID AND Company_Private = 'Private'
        )
        AND @CategoryNumber BETWEEN 1 AND 12
        AND EXISTS (
            SELECT 1 
            FROM Application 
            WHERE Applicant_ID = @ApplicantID 
              AND Category_Number BETWEEN 1 AND 12 
              AND Current_Status IN ('active', 'accepted')
        )
    )
    BEGIN
        THROW 50006, 'Private applicant cannot submit a category 1-12 application when an active/accepted application already exists.', 1;
    END;

    -- Check if the applicant is private and attempting category 13 but already has an active/accepted application
    IF (
        EXISTS (
            SELECT 1 
            FROM Applicant 
            WHERE Applicant_ID = @ApplicantID AND Company_Private = 'Private'
        )
        AND @CategoryNumber = 13
        AND EXISTS (
            SELECT 1 
            FROM Application 
            WHERE Applicant_ID = @ApplicantID 
              AND Category_Number = 13 
              AND Current_Status IN ('active', 'accepted')
        )
    )
    BEGIN
        THROW 50007, 'Private applicant cannot submit a category 13 application when an active/accepted application already exists.', 1;
    END;

    -- Check if the applicant is a company and chooses an invalid category (3, 4, 7, 8)
    IF (
        EXISTS (
            SELECT 1 
            FROM Applicant 
            WHERE Applicant_ID = @ApplicantID AND Company_Private = 'Company'
        )
        AND @CategoryNumber IN (3, 4, 7, 8)
    )
    BEGIN
        THROW 50008, 'Company applicants cannot apply for categories 3, 4, 7, or 8.', 1;
    END;

    -- Check if the applicant is a company and already has 20 applications of specific categories with active/accepted status
    IF (
        EXISTS (
            SELECT 1 
            FROM Applicant 
            WHERE Applicant_ID = @ApplicantID AND Company_Private = 'Company'
        )
        AND (
            SELECT COUNT(*) 
            FROM Application 
            WHERE Applicant_ID = @ApplicantID 
              AND Category_Number IN (1, 2, 5, 6, 9, 10, 11, 12, 13)
              AND Current_Status IN ('active', 'accepted')
        ) >= 20
    )
    BEGIN
        THROW 50009, 'Company applicants cannot have more than 20 applications of categories 1, 2, 5, 6, 9-13 with active/accepted status.', 1;
    END;

    -- Check if there are available positions in the category
    IF NOT EXISTS (
        SELECT 1 
        FROM Sponsorship_Category
        WHERE Category_Number = @CategoryNumber AND Remaining_Positions > 0
    )
    BEGIN
        THROW 50001, 'No remaining positions in this category.', 1;
    END;

    -- Validate license plate for categories 1-4
    IF @CategoryNumber BETWEEN 1 AND 4 AND @LicensePlate IS NULL
    BEGIN
        THROW 50002, 'License plate is required for categories 1 through 4.', 1;
    END;

    -- Validate required documents for specific categories
    IF (@CategoryNumber = 3 OR @CategoryNumber = 4 OR @CategoryNumber = 7) AND @Document IS NULL
    BEGIN
        THROW 50003, 'Document is required for these categories.', 1;
    END;

    -- Start transaction for the critical section
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insert the application with or without license plate, setting Current_Status to 'active'
        INSERT INTO Application (Applicant_ID, Category_Number, Current_Status)
        VALUES (
            @ApplicantID, 
            @CategoryNumber, 
            'active'
        );

        -- Retrieve the newly created Application ID
        DECLARE @ApplicationID INT;
        SET @ApplicationID = SCOPE_IDENTITY();

        -- Insert the license plate into Discarded_Car if it's a category 1-4 application
        IF @CategoryNumber BETWEEN 1 AND 4
        BEGIN
            INSERT INTO Discarded_Car (License_Plate, Application_ID)
            VALUES (@LicensePlate, @ApplicationID);
        END

        -- Insert document record with dynamically constructed URL
        IF @Document IS NOT NULL
        BEGIN
            DECLARE @DocumentType NVARCHAR(255);
            DECLARE @URL NVARCHAR(255);

            -- Determine document type based on the category
            IF @CategoryNumber IN (3, 7)
                SET @DocumentType = N'Αρχείο - Βεβαίωση Τμήματος Κοινωνικής Ενσωμάτωσης ατόμων με αναπηρίες';
            ELSE IF @CategoryNumber = 5
                SET @DocumentType = N'Αρχείο - Ταυτότητα Πολυτέκνων';

            -- Construct the URL dynamically
            SET @URL = CONCAT('Applications/Documents/', @Document, '/document', @UserID, '.pdf');

            -- Insert into Document table
            INSERT INTO Document (URL, Document_Type, Application_ID, User_ID)
            VALUES (@URL, @DocumentType, @ApplicationID, @UserID);
        END

        -- Commit the transaction if all operations succeed
        COMMIT;

        -- Capture the tracking number from the inserted record
        SELECT @TrackingNumber = TrackingNumber
        FROM Application
        WHERE Application_ID = @ApplicationID;

    END TRY
    BEGIN CATCH
        -- Rollback if there is an error
        ROLLBACK;
        THROW;
    END CATCH;
END;
GO
