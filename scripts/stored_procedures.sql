-- 1. Drop Procedure for selecting all records from User table
DROP PROCEDURE IF EXISTS GetUser
GO

-- 2. Drop Procedure for selecting all records from Sponsorship_Category table
DROP PROCEDURE IF EXISTS GetSponsorship
GO

-- 3. Drop Procedure for selecting all records from Applicant table
DROP PROCEDURE IF EXISTS GetApplicant
GO

-- 4. Drop Procedure for selecting all records from Criteria table
DROP PROCEDURE IF EXISTS GetCriteria
GO

-- 5. Drop Procedure for selecting all records from Has table
DROP PROCEDURE IF EXISTS GetHas
GO

-- 6. Drop Procedure for selecting all records from Application table
DROP PROCEDURE IF EXISTS GetApplication
GO

-- 7. Drop Procedure for selecting all records from Document table
DROP PROCEDURE IF EXISTS GetDocument
GO

-- 8. Drop Procedure for selecting all records from Change table
DROP PROCEDURE IF EXISTS GetChange
GO

-- 9. Drop Procedure for selecting all records from Vehicle table
DROP PROCEDURE IF EXISTS GetVehicle
GO

-- 10. Drop Procedure for Sign Up
DROP PROCEDURE IF EXISTS SignUpUser
GO

-- 11. Drop Procedure for Login
DROP PROCEDURE IF EXISTS LoginUser
GO

-- 1. Stored Procedure for selecting all records from User table
CREATE PROCEDURE GetUser
AS
BEGIN
    SELECT * FROM [dbo].[User];
END
GO

-- 2. Stored Procedure for selecting all records from Sponsorship_Category table
CREATE PROCEDURE GetSponsorship
AS
BEGIN
    SELECT * FROM [dbo].[Sponsorship_Category];
END
GO

-- 3. Stored Procedure for selecting all records from Applicant table
CREATE PROCEDURE GetApplicant
AS
BEGIN
    SELECT * FROM [dbo].[Applicant];
END
GO

-- 4. Stored Procedure for selecting all records from Criteria table
CREATE PROCEDURE GetCriteria
AS
BEGIN
    SELECT * FROM [dbo].[Criteria];
END
GO

-- 5. Stored Procedure for selecting all records from Has table
CREATE PROCEDURE GetHas
AS
BEGIN
    SELECT * FROM [dbo].[Has];
END
GO

-- 6. Stored Procedure for selecting all records from Application table
CREATE PROCEDURE GetApplication
AS
BEGIN
    SELECT * FROM [dbo].[Application];
END
GO

-- 7. Stored Procedure for selecting all records from Document table
CREATE PROCEDURE GetDocument
AS
BEGIN
    SELECT * FROM [dbo].[Document];
END
GO

-- 8. Stored Procedure for selecting all records from Change table
CREATE PROCEDURE GetChange
AS
BEGIN
    SELECT * FROM [dbo].[Change];
END
GO

-- 9. Stored Procedure for selecting all records from Vehicle table
CREATE PROCEDURE GetVehicle
AS
BEGIN
    SELECT * FROM [dbo].[Vehicle];
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
    @BirthDate DATE = NULL                 -- Only required if user is an applicant
AS
BEGIN
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

    -- Hash the password using SHA-512
    DECLARE @HashedPassword VARBINARY(512);
    SET @HashedPassword = HASHBYTES('SHA2_512', @Password);

    -- Start a transaction for the user and applicant inserts
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insert the new user into the User table
        INSERT INTO [dbo].[User] 
            ([First_Name], [Last_Name], [Username], [Email], [Password], [User_Type], [Status])
        VALUES
            (@First_Name, @Last_Name, @Username, @Email, @HashedPassword, @User_Type, DEFAULT);

        -- Retrieve the User_ID of the newly inserted user using SCOPE_IDENTITY()
        DECLARE @User_ID INT;
        SET @User_ID = SCOPE_IDENTITY();

        -- If the user is an 'Applicant', insert into the Applicant table
        IF @User_Type = 'Applicant'
        BEGIN
            -- Check if all required fields for Applicant are provided
            IF @Identification IS NULL OR @Company_Private IS NULL OR @Gender IS NULL OR @BirthDate IS NULL
            BEGIN
                THROW 50003, 'For applicants, all fields (Identification, Company_Private, Gender, BirthDate) are required.', 1;
            END

            -- Insert the applicant details into the Applicant table
            INSERT INTO [dbo].[Applicant] 
                ([Identification], [Company_Private], [Gender], [BirthDate], [User_ID])
            VALUES
                (@Identification, @Company_Private, @Gender, @BirthDate, @User_ID);
        END

        -- Commit the transaction if everything is successful
        COMMIT TRANSACTION;

        PRINT 'User successfully created.';
    END TRY
    BEGIN CATCH
        -- Handle error and rollback transaction
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Stored Procedure for User Login
CREATE PROCEDURE [dbo].[LoginUser]
    @Username NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Declare variables to hold the password and status
        DECLARE @Password NVARCHAR(255);
        DECLARE @Status NVARCHAR(20);
        
        -- Fetch the password and status for the given username
        SELECT @Password = [Password], @Status = [Status]
        FROM [dbo].[User]
        WHERE [Username] = @Username;
        
        -- Return the password and status as output
        IF @Password IS NULL
        BEGIN
            RAISERROR('Invalid Username', 16, 1);
            RETURN;
        END
        
        -- Return the values
        SELECT @Password AS Password, @Status AS Status;

    END TRY
    BEGIN CATCH
        -- Handle errors
        PRINT 'An error occurred during the login process';
        THROW;
    END CATCH
END
GO
