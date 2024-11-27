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
    @BirthDate DATE = NULL                 -- Only required if user is an applicant
AS
BEGIN
    SET NOCOUNT ON;
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

CREATE PROCEDURE [dbo].[LoginUser]
    @Username NVARCHAR(50),
    @Password NVARCHAR(255), -- Plain text password from PHP
    @Session_ID UNIQUEIDENTIFIER OUTPUT -- Output parameter for the session ID
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Declare variables to hold the stored password hash, status, and user ID
        DECLARE @StoredPassword VARBINARY(512);
        DECLARE @Status VARCHAR(20);
        DECLARE @User_ID INT;

        -- Fetch the password hash, status, and user ID for the given username
        SELECT @StoredPassword = [Password], @Status = [Status], @User_ID = [User_ID]
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

    END TRY
    BEGIN CATCH
        -- Handle errors and rethrow the error
        THROW; -- Re-throws the original error
    END CATCH
END
GO
