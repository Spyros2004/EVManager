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

DROP PROCEDURE IF EXISTS SignUpUser
GO

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

-- Stored Procedure for User Sign Up
CREATE PROCEDURE SignUpUser
    @First_Name NVARCHAR(50),
    @Last_Name NVARCHAR(50),
    @Username NVARCHAR(50),
    @Email NVARCHAR(100),
    @Password NVARCHAR(255),
    @User_Type NVARCHAR(20),
    @Status NVARCHAR(20) = 'pending' -- Default to 'pending'
AS
BEGIN
    BEGIN TRY
        -- Check if Username or Email already exists
        IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Username] = @Username)
        BEGIN
            RAISERROR('Username already exists. Please choose a different one.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Email] = @Email)
        BEGIN
            RAISERROR('Email already exists. Please use a different one.', 16, 1);
            RETURN;
        END

        -- Insert the new user into the User table
        INSERT INTO [dbo].[User] 
        ([First_Name], [Last_Name], [Username], [Email], [Password], [User_Type], [Status])
        VALUES
        (@First_Name, @Last_Name, @Username, @Email, @Password, @User_Type, @Status);

        PRINT 'User successfully created.';
    END TRY
    BEGIN CATCH
        -- Handle error
        PRINT 'An error occurred during sign-up.';
        THROW;
    END CATCH
END
GO

-- Stored Procedure for User Login
CREATE PROCEDURE LoginUser
    @Username NVARCHAR(50),
    @Password NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        -- Verify user credentials (Username + Password)
        DECLARE @UserID INT;
        DECLARE @UserStatus NVARCHAR(20);
        
        SELECT @UserID = User_ID, @UserStatus = Status
        FROM [dbo].[User]
        WHERE [Username] = @Username AND [Password] = @Password;

        IF @UserID IS NULL
        BEGIN
            RAISERROR('Invalid Username or Password.', 16, 1);
            RETURN;
        END

        -- Check user status (can be extended for more statuses)
        IF @UserStatus = 'approved'
        BEGIN
            PRINT 'Login successful.';
        END
        ELSE
        BEGIN
            PRINT 'User not approved or is inactive.';
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Handle error
        PRINT 'An error occurred during login.';
        THROW;
    END CATCH
END
GO