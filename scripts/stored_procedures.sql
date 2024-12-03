DROP PROCEDURE IF EXISTS dbo.Report11;
GO

DROP PROCEDURE IF EXISTS dbo.Report10;
GO

DROP PROCEDURE IF EXISTS dbo.Report9;
GO
    
DROP PROCEDURE IF EXISTS dbo.Report8
GO

    DROP PROCEDURE IF EXISTS dbo.Report7
    GO

    DROP PROCEDURE IF EXISTS dbo.Report6
    GO

    DROP PROCEDURE IF EXISTS dbo.Report5;
    GO
    
    DROP PROCEDURE IF EXISTS dbo.Report4;
    GO

    DROP PROCEDURE IF EXISTS dbo.Report3;
    GO

    DROP PROCEDURE IF EXISTS dbo.Report2;
    GO

    DROP PROCEDURE IF EXISTS dbo.Report1;
    GO

    DROP PROCEDURE IF EXISTS dbo.GenerateReport
    GO

    DROP PROCEDURE IF EXISTS dbo.VerifyPasswordBySession
    GO

    DROP PROCEDURE IF EXISTS dbo.UpdateExpiredApplications
    GO

    DROP PROCEDURE IF EXISTS dbo.GetOrderedApplications
    GO

    DROP PROCEDURE IF EXISTS dbo.AddDocument
    GO

    DROP PROCEDURE IF EXISTS dbo.UpdateDocument
    GO

    DROP PROCEDURE IF EXISTS dbo.GetDocumentsByApplicationID
    GO

    DROP PROCEDURE IF EXISTS dbo.GetApplicationLog
    GO

    DROP PROCEDURE IF EXISTS dbo.GetFullApplicationDetails
    GO

    DROP PROCEDURE IF EXISTS dbo.AcceptOrRejectApplication
    GO
	    
    DROP PROCEDURE IF EXISTS dbo.AcceptOrRejectApplicationTOM
    GO
        
    DROP PROCEDURE IF EXISTS dbo.ReactivateApplication
    GO

    DROP PROCEDURE IF EXISTS dbo.AddVehicleAndDocument
    GO

    DROP PROCEDURE IF EXISTS dbo.ShowSponsorships
    GO

    DROP PROCEDURE IF EXISTS dbo.GetApplicationDetailsByIdentification
    GO

    DROP PROCEDURE IF EXISTS dbo.CheckIsAA;
    GO

    DROP PROCEDURE IF EXISTS dbo.CheckIsAdmin;
    GO

    DROP PROCEDURE IF EXISTS dbo.CheckIsTOM;
    GO

    DROP PROCEDURE IF EXISTS dbo.CheckIsApplicant;
    GO

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

    CREATE PROCEDURE dbo.showSponsorships
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Select only categories 1-8 and 10-14
        SELECT * 
        FROM [dbo].[Sponsorship_Category]
        WHERE Category_Number BETWEEN 1 AND 8
        OR Category_Number BETWEEN 10 AND 14;
    END
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
            THROW 50001, 'Ο χρήστης δεν υπάρχει.', 1;
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
            THROW 50000, 'Μη έγκυρο Session ID', 1;
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
            THROW 50000, 'Μη έγκυρο ID', 1;
            RETURN;
        END

        -- Fetch applications for the user
        SELECT A.Tracking_Number, A.Application_Date, A.Current_Status, SC.Description AS Category_Description
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
                THROW 50000, 'Δεν βρέθηκε ενεργό session για αυτό το session ID.', 1;
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
            THROW 50005, 'Όλα τα πεδία χρήστη είναι υποχρεωτικά.', 1;
            RETURN;
        END

        -- Check if Username or Email already exists
        IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Username] = @Username)
        BEGIN
            THROW 50001, 'Το όνομα χρήστη υπάρχει ήδη. Παρακαλώ επιλέξτε ένα διαφορετικό.', 1;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Email] = @Email)
        BEGIN
            THROW 50002, 'Το email υπάρχει ήδη. Παρακαλώ χρησιμοποιήστε ένα διαφορετικό.', 1;
            RETURN;
        END

        -- Additional checks if the User_Type is 'Applicant'
        IF @User_Type = 'Applicant'
        BEGIN
            -- Check if all required Applicant fields are provided
            IF @Identification IS NULL OR @Company_Private IS NULL OR @Gender IS NULL 
            OR @BirthDate IS NULL OR @Telephone_Number IS NULL OR @Address IS NULL
            BEGIN
                THROW 50003, 'Για τους αιτούντες, όλα τα πεδία είναι υποχρεωτικά.', 1;
                RETURN;
            END

            -- Check if Identification already exists in Applicant table
            IF EXISTS (SELECT 1 FROM [dbo].[Applicant] WHERE [Identification] = @Identification)
            BEGIN
                THROW 50004, 'Η ταυτότητα υπάρχει ήδη για άλλον χρήστη. Παρακαλούμε δώστε μια διαφορετική ταυτότητα.', 1;
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
                THROW 50000, 'Μη έγκυρο όνομα χρήστη', 1;
            END

            -- Check if the user's status is "pending"
            IF @Status = 'pending'
            BEGIN
                -- Throw an error if the user is in "pending" status
                THROW 50002, 'Ο λογαριασμός εκκρεμεί έγκριση. Παρακαλούμε περιμένετε έγκριση από τον φορέα υλοποίησης.', 1;
            END

            -- Compare the stored hashed password with the provided password
            IF @StoredPassword != HASHBYTES('SHA2_512', @Password)
            BEGIN
                -- Throw an error for incorrect password
                THROW 50001, 'Λανθασμένος κωδικός πρόσβασης.', 1;
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
            THROW 50000, 'Ο χρήστης δεν είναι αιτών.', 1;
        END;

        DECLARE @ApplicantID INT;
        SELECT @ApplicantID = Applicant_ID
        FROM Applicant
        WHERE User_ID = @UserID;

        -- Store Company_Private value in a variable for later use
        DECLARE @CompanyPrivate VARCHAR(10);
        SELECT @CompanyPrivate = Company_Private
        FROM Applicant
        WHERE Applicant_ID = @ApplicantID;

        -- Check if the applicant has 2 applications with expired status
        IF (
            SELECT COUNT(*) 
            FROM Application 
            WHERE Applicant_ID = @ApplicantID AND Current_Status = 'expired'
        ) >= 2
        BEGIN
            THROW 50004, 'Ο αιτών έχει 2 αιτήσεις που έχουν λήξει.', 1;
        END;

        -- Check if the applicant has 2 applications with declined status
        IF (
            SELECT COUNT(*) 
            FROM Application 
            WHERE Applicant_ID = @ApplicantID AND Current_Status = 'declined'
        ) >= 2
        BEGIN
            THROW 50005, 'Ο αιτών έχει 2 απορριφθείσες αιτήσεις.', 1;
        END;

        -- Check if the applicant is private and attempting category 1-13 but already has an active/accepted application
        IF (
            @CompanyPrivate = 'Private'
            AND @CategoryNumber BETWEEN 1 AND 13
            AND EXISTS (
                SELECT 1 
                FROM Application 
                WHERE Applicant_ID = @ApplicantID 
                AND Category_Number BETWEEN 1 AND 13
                AND Current_Status IN ('active', 'accepted')
            )
        )
        BEGIN
            THROW 50006, 'Φυσικά πρόσωπα δεν μπορούν να υποβάλουν 2η αίτηση κατηγορίας 1-13 όταν υπάρχει ήδη ενεργή/αποδεκτή αίτηση.', 1;
        END;

        -- Check if the applicant is private and attempting category 14 but already has an active/accepted application
        IF (
            @CompanyPrivate = 'Private'
            AND @CategoryNumber = 14
            AND EXISTS (
                SELECT 1 
                FROM Application 
                WHERE Applicant_ID = @ApplicantID 
                AND Category_Number = 14
                AND Current_Status IN ('active', 'accepted')
            )
        )
        BEGIN
            THROW 50007, 'Φυσικά πρόσωπα δεν μπορούν να υποβάλουν 2η αίτηση κατηγορίας 14 όταν υπάρχει ήδη ενεργή/αποδεκτή αίτηση..', 1;
        END;

        -- Check if the applicant is a company and chooses an invalid category (3, 4, 7, 8, 9)
        IF (
            @CompanyPrivate = 'Company'
            AND @CategoryNumber IN (3, 4, 7, 8, 9)
        )
        BEGIN
            THROW 50008, 'Νομικά πρόσωπα δεν μπορούν να υποβάλουν αίτηση για τις κατηγορίες 3, 4, 7, 8 ή 9.', 1;
        END;

        -- Check if the applicant is a company and already has 20 applications of specific categories with active/accepted status
        IF (
            @CompanyPrivate = 'Company'
            AND (
                SELECT COUNT(*) 
                FROM Application 
                WHERE Applicant_ID = @ApplicantID 
                AND Category_Number IN (1, 2, 5, 6, 10, 11, 12, 13, 14)
                AND Current_Status IN ('active', 'accepted')
            ) >= 20
        )
        BEGIN
            THROW 50009, 'Νομικά πρόσωπα δεν μπορούν να έχουν περισσότερες από 20 αιτήσεις των κατηγοριών 1, 2, 5, 6, 10-14 με ενεργό/αποδεκτό καθεστώς.', 1;
        END;

        -- Check if there are available positions in the category
        IF NOT EXISTS (
            SELECT 1 
            FROM Sponsorship_Category
            WHERE Category_Number = @CategoryNumber AND Remaining_Positions > 0
        )
        BEGIN
            THROW 50001, 'Δεν υπάρχουν υπόλοιπες θέσεις σε αυτή την κατηγορία.', 1;
        END;

        -- Validate license plate for categories 1-4
        IF @CategoryNumber BETWEEN 1 AND 4
        BEGIN
            IF @LicensePlate IS NULL
            BEGIN
                THROW 50002, 'Για τις κατηγορίες 1 έως 4 απαιτείται αριθμός πινακίδας αυτοκινήτου.', 1;
            END

            -- Check if the license plate format is valid
            IF @LicensePlate NOT LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'
            BEGIN
                THROW 50010, 'Η πινακίδα αυτοκινήτου πρέπει να αποτελείται από 3 κεφαλαία γράμματα ακολουθούμενα από 3 αριθμούς. (π.χ. ABC123)', 1;
            END

            -- Check if the license plate already exists in the system
            IF EXISTS (
                SELECT 1 
                FROM Discarded_Car 
                WHERE License_Plate = @LicensePlate
            )
            BEGIN
                THROW 50011, 'Η πινακίδα αυτοκινήτου υπάρχει ήδη στο σύστημα!', 1;
            END
        END

        -- Validate required documents for specific categories
        IF (@CategoryNumber = 3 OR @CategoryNumber = 4 OR @CategoryNumber = 7) AND @Document IS NULL
        BEGIN
            THROW 50003, 'Απαιτείται ανάρτηση αρχείου για αυτή τη κατηγορία!', 1;
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
            IF @Document IS NOT NULL AND @CategoryNumber IN (3, 5, 7)
            BEGIN
                DECLARE @DocumentType NVARCHAR(255);
                DECLARE @DocumentID INT;
                DECLARE @URL VARCHAR(255);

                -- Determine document type based on the category
                IF @CategoryNumber IN (3, 7)
                    SET @DocumentType = N'Αρχείο - Βεβαίωση Τμήματος Κοινωνικής Ενσωμάτωσης ατόμων με αναπηρίες';
                ELSE IF @CategoryNumber = 5
                    SET @DocumentType = N'Αρχείο - Ταυτότητα Πολυτέκνων';

                -- Insert into Document table with a temporary placeholder URL (or an initial dummy value)
                INSERT INTO Document (URL, Document_Type, Application_ID, User_ID)
                VALUES ('', @DocumentType, @ApplicationID, @UserID);

                -- Retrieve the newly inserted Document_ID
                SET @DocumentID = SCOPE_IDENTITY();

                -- Construct the URL dynamically using Document_ID
                SET @URL = CONCAT('Applications/Documents/', @Document, '/document', @DocumentID, '.pdf');

                -- Update the Document record with the constructed URL
                UPDATE Document
                SET URL = @URL
                WHERE Document_ID = @DocumentID;
            END

            -- Commit the transaction if all operations succeed
            COMMIT;

            -- Capture the tracking number from the inserted record
            SELECT @TrackingNumber = Tracking_Number
            FROM Application
            WHERE Application_ID = @ApplicationID;

        END TRY
        BEGIN CATCH
            -- Rollback if there is an error
            ROLLBACK;

            -- Correct usage of THROW without parameters, which rethrows the error caught
            THROW;
        END CATCH;
    END;
    GO

    CREATE PROCEDURE dbo.CheckIsAA
        @SessionID UNIQUEIDENTIFIER,
        @IsAA BIT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @UserID INT;
        DECLARE @UserType VARCHAR(20);

        -- Retrieve the User ID associated with the session ID
        SELECT @UserID = User_ID
        FROM [dbo].[User_Session]
        WHERE Session_ID = @SessionID;

        -- If no user is found with the given session ID, set output to 0
        IF @UserID IS NULL
        BEGIN
            SET @IsAA = 0;
            RETURN;
        END

        -- Retrieve the User Type associated with the user ID
        SELECT @UserType = User_Type
        FROM [dbo].[User]
        WHERE User_ID = @UserID;

        -- Set output parameter based on the user type
        SET @IsAA = CASE WHEN @UserType = 'AA' THEN 1 ELSE 0 END;
    END
    GO

    CREATE PROCEDURE dbo.CheckIsAdmin
        @SessionID UNIQUEIDENTIFIER,
        @IsAdmin BIT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @UserID INT;
        DECLARE @UserType VARCHAR(20);

        -- Retrieve the User ID associated with the session ID
        SELECT @UserID = User_ID
        FROM [dbo].[User_Session]
        WHERE Session_ID = @SessionID;

        -- If no user is found with the given session ID, set output to 0
        IF @UserID IS NULL
        BEGIN
            SET @IsAdmin = 0;
            RETURN;
        END

        -- Retrieve the User Type associated with the user ID
        SELECT @UserType = User_Type
        FROM [dbo].[User]
        WHERE User_ID = @UserID;

        -- Set output parameter based on the user type
        SET @IsAdmin = CASE WHEN @UserType = 'Admin' THEN 1 ELSE 0 END;
    END
    GO

    CREATE PROCEDURE dbo.CheckIsTOM
        @SessionID UNIQUEIDENTIFIER,
        @IsTOM BIT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @UserID INT;
        DECLARE @UserType VARCHAR(20);

        -- Retrieve the User ID associated with the session ID
        SELECT @UserID = User_ID
        FROM [dbo].[User_Session]
        WHERE Session_ID = @SessionID;

        -- If no user is found with the given session ID, set output to 0
        IF @UserID IS NULL
        BEGIN
            SET @IsTOM = 0;
            RETURN;
        END

        -- Retrieve the User Type associated with the user ID
        SELECT @UserType = User_Type
        FROM [dbo].[User]
        WHERE User_ID = @UserID;

        -- Set output parameter based on the user type
        SET @IsTOM = CASE WHEN @UserType = 'TOM' THEN 1 ELSE 0 END;
    END
    GO

    CREATE PROCEDURE dbo.CheckIsApplicant
        @SessionID UNIQUEIDENTIFIER,
        @IsApplicant BIT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @UserID INT;
        DECLARE @UserType VARCHAR(20);

        -- Retrieve the User ID associated with the session ID
        SELECT @UserID = User_ID
        FROM [dbo].[User_Session]
        WHERE Session_ID = @SessionID;

        -- If no user is found with the given session ID, set output to 0
        IF @UserID IS NULL
        BEGIN
            SET @IsApplicant = 0;
            RETURN;
        END

        -- Retrieve the User Type associated with the user ID
        SELECT @UserType = User_Type
        FROM [dbo].[User]
        WHERE User_ID = @UserID;

        -- Set output parameter based on the user type
        SET @IsApplicant = CASE WHEN @UserType = 'Applicant' THEN 1 ELSE 0 END;
    END
    GO

    CREATE PROCEDURE dbo.GetApplicationDetailsByIdentification
        @Identification VARCHAR(20),
        @TrackingNumber NCHAR(8),
        @FullName NVARCHAR(101) OUTPUT,
        @ApplicationDate DATE OUTPUT,
        @CategoryNumber INT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Validate if the application exists for the given identification, tracking number, and active status
        IF NOT EXISTS (
            SELECT 1
            FROM Application AS App
            JOIN Applicant AS A ON App.Applicant_ID = A.Applicant_ID
            WHERE A.Identification = @Identification 
            AND App.Tracking_Number = @TrackingNumber
            AND App.Current_Status = 'active'
        )
        BEGIN
            THROW 50000, 'Δεν βρέθηκε καμία ενεργή αίτηση για το συγκεκριμένο ID και Tracking Number.', 1;
        END;

        -- Retrieve the required details
        SELECT 
            @FullName = CONCAT(U.First_Name, ' ', U.Last_Name),
            @ApplicationDate = App.Application_Date,
            @CategoryNumber = App.Category_Number
        FROM Application AS App
        JOIN Applicant AS A ON App.Applicant_ID = A.Applicant_ID
        JOIN [User] AS U ON A.User_ID = U.User_ID
        WHERE A.Identification = @Identification AND App.Tracking_Number = @TrackingNumber;
    END;
    GO

    CREATE PROCEDURE dbo.AddVehicleAndDocument
        @SessionID UNIQUEIDENTIFIER,
        @TrackingNumber NCHAR(8),
        @VehicleDate DATE,
        @VehicleType VARCHAR(20),
        @CO2Emissions INT,
        @Manufacturer VARCHAR(50),
        @Model VARCHAR(50),
        @Price INT,
        @Document1 VARCHAR(100),
        @Document2 VARCHAR(100)
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Declare variables to store retrieved Application_ID and User_ID
        DECLARE @ApplicationID INT;
        DECLARE @UserID INT;
        DECLARE @DocumentID INT;

        SELECT @UserID = User_ID
        FROM [User_Session]
        WHERE Session_ID = @SessionID;

        -- Validate the application exists and is active
        IF NOT EXISTS (
            SELECT 1 
            FROM Application
            WHERE Tracking_Number = @TrackingNumber AND Current_Status = 'active'
        )
        BEGIN
            THROW 50001, 'Δεν βρέθηκε καμία αίτηση για το συγκεκριμένο Tracking Number.', 1;
        END;

        IF @Document1 IS NULL OR @Document1 = ''
        BEGIN
            THROW 50005, 'Το Document1 δεν μπορεί να είναι κενό.', 1;
        END;

        IF @Document2 IS NULL OR @Document2 = ''
        BEGIN
            THROW 50006, 'Το Document2 δεν μπορεί να είναι κενό.', 1;
        END;

        -- Retrieve Application_ID and User_ID
        SELECT 
            @ApplicationID = Application_ID
        FROM Application AS A
        WHERE A.Tracking_Number = @TrackingNumber;

        -- Validate Vehicle attributes
        IF @VehicleDate < GETDATE()
        BEGIN
            THROW 50002, 'Η ημερομηνία Εγγραφής Αυτοκινήτου δεν μπορεί να είναι νωρίτερα από σήμερα.', 1;
        END;

        IF @CO2Emissions > 50
        BEGIN
            THROW 50003, 'Οι εκπομπές CO2 πρέπει να είναι μικρότερες ή ίσες με 50.', 1;
        END;

        IF @Price > 80000
        BEGIN
            THROW 50004, 'Η τιμή του οχήματος πρέπει να είναι μικρότερη ή ίση με €80.000.', 1;
        END;

        -- Start transaction for insert operations
        BEGIN TRANSACTION;

        BEGIN TRY
            DECLARE @URL VARCHAR(255);
            
            -- Insert the document
            INSERT INTO Document (URL, Document_Type, Application_ID, User_ID)
            VALUES ('', N'Παραγγελία Αυτοκινήτου', @ApplicationID, @UserID);

            -- Retrieve the newly created Document_ID
            SET @DocumentID = SCOPE_IDENTITY();

            -- Construct the URL dynamically using Document_ID
            SET @URL = CONCAT('Applications/Documents/', @Document1, '/document', @DocumentID, '.pdf');

            -- Update the Document record with the constructed URL
            UPDATE Document
            SET URL = @URL
            WHERE Document_ID = @DocumentID;

            -- Insert the vehicle details, now including the Model column
            INSERT INTO Vehicle (Vehicle_Date, Vehicle_Type, CO2_Emissions, Manufacturer, Model, Price, Document_ID)
            VALUES (@VehicleDate, @VehicleType, @CO2Emissions, @Manufacturer, @Model, @Price, @DocumentID);

            INSERT INTO Document (URL, Document_Type, Application_ID, User_ID)
            VALUES ('', N'Πιστοποιητικό Συμμόρφωσης ΕΚ', @ApplicationID, @UserID);

            -- Retrieve the newly created Document_ID
            SET @DocumentID = SCOPE_IDENTITY();

            -- Construct the URL dynamically using Document_ID
            SET @URL = CONCAT('Applications/Documents/', @Document2, '/document', @DocumentID, '.pdf');

            -- Update the Document record with the constructed URL
            UPDATE Document
            SET URL = @URL
            WHERE Document_ID = @DocumentID;

            -- Update application status to 'ordered'
            UPDATE Application
            SET Current_Status = 'ordered'
            WHERE Application_ID = @ApplicationID;

        INSERT INTO Modification (Modification_Date, New_Status, Reason, User_ID, Application_ID)
        VALUES (GETDATE(), 'ordered', 'Order submitted and documents uploaded.', @UserID, @ApplicationID);

            -- Commit the transaction if all insert operations succeed
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            -- Rollback the transaction if any error occurs during inserts
            ROLLBACK TRANSACTION;

            -- Re-throw the error to propagate it to the calling application
            THROW;
        END CATCH;
    END;
    GO

    CREATE PROCEDURE dbo.AcceptOrRejectApplication
        @ApplicationID INT,       -- ID of the application
        @Action INT,              -- Action: 0 = Reject, 1 = Accept
        @Reason NVARCHAR(255),    -- Reason for the action
        @SessionID UNIQUEIDENTIFIER -- Session ID of the user performing the action
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Retrieve the User_ID from the Session_ID
        DECLARE @UserID INT;

        SELECT 
            @UserID = U.User_ID
        FROM [dbo].[User_Session] US
        JOIN [dbo].[User] U ON US.User_ID = U.User_ID
        WHERE US.Session_ID = @SessionID;

        -- Ensure a reason is provided for the action
        IF @Reason IS NULL OR LEN(@Reason) = 0
        BEGIN
            THROW 50000, 'Για την ενέργεια αυτή απαιτείται αιτιολόγηση.', 1;
        END;

        IF @Action = 1
        BEGIN
			-- Admin: Check if the application is in "checked" status
            IF NOT EXISTS (SELECT 1 FROM [dbo].[Application] WHERE Application_ID = @ApplicationID AND Current_Status = 'checked')
            BEGIN
				THROW 50001, 'Η αίτηση πρέπει να είναι σε κατάσταση «checked» για να γίνει δεκτή.', 1;
            END;

            -- Update the application status to "accepted"
            UPDATE [dbo].[Application]
            SET Current_Status = 'accepted'
            WHERE Application_ID = @ApplicationID;

            -- Log the change
            INSERT INTO [dbo].[Modification] (Modification_Date, New_Status, Reason, User_ID, Application_ID)
            VALUES (GETDATE(), 'accepted', @Reason, @UserID, @ApplicationID);
		END
        ELSE IF @Action = 0
        BEGIN
            -- Reject Action: Check if the application is in "active", "ordered", or "checked" status
            IF NOT EXISTS (SELECT 1 FROM [dbo].[Application] WHERE Application_ID = @ApplicationID AND Current_Status IN ('active', 'ordered', 'checked'))
            BEGIN
                THROW 50002, 'Η αίτηση πρέπει να είναι σε κατάσταση «active», «ordered» ή «checked» για να απορριφθεί.', 1;
            END;

            -- Update the application status to "rejected"
            UPDATE [dbo].[Application]
            SET Current_Status = 'rejected'
            WHERE Application_ID = @ApplicationID;

            -- Log the change
            INSERT INTO [dbo].[Modification] (Modification_Date, New_Status, Reason, User_ID, Application_ID)
            VALUES (GETDATE(), 'rejected', @Reason, @UserID, @ApplicationID);
        END
        ELSE
        BEGIN
            THROW 50003, 'Άκυρη ενέργεια.', 1;
        END;
    END;
    GO


	CREATE PROCEDURE dbo.AcceptOrRejectApplicationTOM
        @ApplicationID INT,       -- ID of the application
        @Action INT,              -- Action: 0 = Reject, 1 = Accept
        @Reason NVARCHAR(255),    -- Reason for the action
        @SessionID UNIQUEIDENTIFIER -- Session ID of the user performing the action
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Retrieve the User_ID and User_Type from the Session_ID
        DECLARE @UserID INT;

        SELECT 
            @UserID = U.User_ID
        FROM [dbo].[User_Session] US
        JOIN [dbo].[User] U ON US.User_ID = U.User_ID
        WHERE US.Session_ID = @SessionID;

        -- Ensure a reason is provided for the action
        IF @Reason IS NULL OR LEN(@Reason) = 0
        BEGIN
            THROW 50000, 'Για την ενέργεια αυτή απαιτείται αιτιολόγηση.', 1;
        END;

        IF @Action = 1
        BEGIN
			-- TOM: Check if the application is in "active" status
            IF NOT EXISTS (SELECT 1 FROM [dbo].[Application] WHERE Application_ID = @ApplicationID AND Current_Status = 'ordered')
            BEGIN
                THROW 50004, 'Η αίτηση πρέπει να είναι σε κατάσταση «ordered» για να επισημανθεί ως «checked».', 1;
            END;

            -- Update the application status to "checked"
            UPDATE [dbo].[Application]
            SET Current_Status = 'checked'
            WHERE Application_ID = @ApplicationID;

            -- Log the change
            INSERT INTO [dbo].[Modification] (Modification_Date, New_Status, Reason, User_ID, Application_ID)
            VALUES (GETDATE(), 'checked', @Reason, @UserID, @ApplicationID);
        END
        ELSE IF @Action = 0
        BEGIN
            -- Reject Action: Check if the application is in "active", "ordered", or "checked" status
            IF NOT EXISTS (SELECT 1 FROM [dbo].[Application] WHERE Application_ID = @ApplicationID AND Current_Status IN ('active', 'ordered', 'checked'))
            BEGIN
                THROW 50002, 'Η αίτηση πρέπει να είναι σε κατάσταση «active», «ordered» ή «checked» για να απορριφθεί.', 1;
            END;

            -- Update the application status to "rejected"
            UPDATE [dbo].[Application]
            SET Current_Status = 'rejected'
            WHERE Application_ID = @ApplicationID;

            -- Log the change
            INSERT INTO [dbo].[Modification] (Modification_Date, New_Status, Reason, User_ID, Application_ID)
            VALUES (GETDATE(), 'rejected', @Reason, @UserID, @ApplicationID);
        END
        ELSE
        BEGIN
            THROW 50003, 'Άκυρη ενέργεια.', 1;
        END;
    END;
    GO

    CREATE PROCEDURE dbo.ReactivateApplication
        @ApplicationID INT,       -- ID of the application
        @Reason NVARCHAR(255),    -- Reason for reactivation
        @SessionID UNIQUEIDENTIFIER -- Session ID of the admin performing the action
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Retrieve the User_ID from the Session_ID
        DECLARE @UserID INT;
        SELECT @UserID = User_ID
        FROM [dbo].[User_Session]
        WHERE Session_ID = @SessionID;

        -- Ensure a reason is provided for the action
        IF @Reason IS NULL OR LEN(@Reason) = 0
        BEGIN
            THROW 50000, 'Για την ενέργεια αυτή απαιτείται αιτιολόγηση.', 1;
        END

        -- Reactivate: Check if the application is in "rejected" status
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Application] WHERE Application_ID = @ApplicationID AND Current_Status = 'rejected')
        BEGIN
            THROW 50000, N'Η αίτηση πρέπει να βρίσκεται σε κατάσταση «rejected» για να ενεργοποιηθεί εκ νέου.', 1;
        END

        -- Ensure the reactivating admin is not the same as the rejecting admin
        DECLARE @RejectingUserID INT;
        SELECT TOP 1 @RejectingUserID = User_ID
        FROM [dbo].[Modification]
        WHERE Application_ID = @ApplicationID AND New_Status = 'rejected'
        ORDER BY Modification_Date DESC;

        IF @RejectingUserID = @UserID
        BEGIN
            THROW 50001, 'Δεν μπορείτε να ενεργοποιήσετε εκ νέου μια αίτηση που απορρίψατε.', 1;
        END

        -- Check if there are available positions in the sponsorship category
        DECLARE @CategoryNumber INT;
        SELECT @CategoryNumber = Category_Number
        FROM [dbo].[Application]
        WHERE Application_ID = @ApplicationID;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Sponsorship_Category]
            WHERE Category_Number = @CategoryNumber AND Remaining_Positions > 0
        )
        BEGIN
            THROW 50002, 'Δεν υπάρχει διαθέσιμος αριθμός χορηγιών σε αυτή την κατηγορία.', 1;
        END

        -- Update the application status to "active"
        UPDATE [dbo].[Application]
        SET Current_Status = 'active'
        WHERE Application_ID = @ApplicationID;

        -- Log the change
        INSERT INTO [dbo].[Modification] (Modification_Date, New_Status, Reason, User_ID, Application_ID)
        VALUES (GETDATE(), 'active', @Reason, @UserID, @ApplicationID);
    END;
    GO

    CREATE PROCEDURE dbo.GetFullApplicationDetails
        @ApplicationID INT
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Validate if the application exists
        IF NOT EXISTS (SELECT 1 FROM Application WHERE Application_ID = @ApplicationID)
        BEGIN
            THROW 50000, 'Δεν βρέθηκε καμία αίτηση για το παρεχόμενο Application ID.', 1;
        END;

        -- Retrieve full details for the application
        SELECT 
            -- User Details
            U.First_Name,
            U.Last_Name,
            U.Username,
            U.Email,

            -- Applicant Details
            A.Applicant_ID,
            A.Identification,
            A.Company_Private,
            A.Gender,
            A.BirthDate,
            A.Telephone_Number,
            A.Address,

            -- Application Details
            App.Application_ID,
            App.Tracking_Number,
            App.Application_Date,
            App.Current_Status,
            App.Category_Number,

            -- Discarded Car Details (Nullable)
            DC.License_Plate AS Discarded_Car_License_Plate

        FROM 
            Application AS App
        INNER JOIN 
            Applicant AS A ON App.Applicant_ID = A.Applicant_ID
        INNER JOIN 
            [User] AS U ON A.User_ID = U.User_ID
        LEFT JOIN 
            Discarded_Car AS DC ON App.Application_ID = DC.Application_ID
        WHERE 
            App.Application_ID = @ApplicationID;
    END;
    GO

    CREATE PROCEDURE dbo.GetDocumentsByApplicationID
        @ApplicationID INT
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Validate if the application exists
        IF NOT EXISTS (SELECT 1 FROM Application WHERE Application_ID = @ApplicationID)
        BEGIN
            THROW 50000, 'Δεν βρέθηκε καμία αίτηση για το παρεχόμενο Application ID.', 1;
        END;

        -- Retrieve all documents related to the application, including Username
        SELECT 
            D.Document_ID,
            D.URL,
            D.Document_Type,
            D.Application_ID,
            U.Username
        FROM 
            Document AS D
        INNER JOIN 
            [User] AS U ON D.User_ID = U.User_ID
        WHERE 
            D.Application_ID = @ApplicationID;
    END;
    GO

    CREATE PROCEDURE dbo.GetApplicationLog
        @ApplicationID INT
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Validate if the application exists
        IF NOT EXISTS (SELECT 1 FROM Application WHERE Application_ID = @ApplicationID)
        BEGIN
            THROW 50000, 'Δεν βρέθηκε καμία αίτηση για το παρεχόμενο Application ID.', 1;
        END;

        -- Fetch all modifications related to the application, including Username
        SELECT 
            M.Modification_ID,
            M.Modification_Date,
            M.New_Status,
            M.Reason,
            U.Username,
            M.Application_ID
        FROM 
            Modification AS M
        INNER JOIN 
            [User] AS U ON M.User_ID = U.User_ID
        WHERE 
            M.Application_ID = @ApplicationID
        ORDER BY 
            M.Modification_Date ASC; -- Sort modifications by most recent
    END;
    GO

    CREATE PROCEDURE dbo.UpdateDocument
        @SessionID UNIQUEIDENTIFIER, -- ID of the logged-in user (session)
        @DocumentID INT -- ID of the document to be updated
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @UserID INT;
        SELECT @UserID = User_ID
        FROM [dbo].[User_Session]
        WHERE Session_ID = @SessionID;

        -- Validate if the document exists
        IF NOT EXISTS (SELECT 1 FROM Document WHERE Document_ID = @DocumentID)
        BEGIN
            THROW 50000, 'Δεν βρέθηκε κανένα έγγραφο για το παρεχόμενο αναγνωριστικό εγγράφου.', 1;
        END;

        -- Retrieve the associated Application_ID and Document_Type for the document
        DECLARE @ApplicationID INT;
        DECLARE @DocumentType NVARCHAR(100);
        SELECT 
            @ApplicationID = Application_ID,
            @DocumentType = Document_Type
        FROM 
            Document
        WHERE 
            Document_ID = @DocumentID;

        -- Validate if the associated application exists
        IF NOT EXISTS (SELECT 1 FROM Application WHERE Application_ID = @ApplicationID)
        BEGIN
            THROW 50001, 'Δεν βρέθηκε καμία εφαρμογή για το σχετικό αναγνωριστικό αίτησης.', 1;
        END;

        -- Retrieve the current status of the application
        DECLARE @CurrentStatus VARCHAR(20);
        SELECT @CurrentStatus = Current_Status
        FROM Application
        WHERE Application_ID = @ApplicationID;

        -- Update the User_ID for the document to the session user
        UPDATE Document
        SET User_ID = @UserID
        WHERE Document_ID = @DocumentID;

        -- Insert a record into the Modification table
        INSERT INTO Modification (
            Modification_Date,
            New_Status,
            Reason,
            User_ID,
            Application_ID
        )
        VALUES (
            GETDATE(), -- Current date
            @CurrentStatus, -- Keep the current application status
            CONCAT('Updated ', @DocumentType, ' by TOM'), -- Reason for modification
            @UserID, -- User performing the update
            @ApplicationID -- Application associated with the document
        );
    END;
    GO

    CREATE PROCEDURE dbo.GetOrderedApplications
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Select only records where Current_Status is 'ordered'
        SELECT * 
        FROM [dbo].[Application]
        WHERE Current_Status = 'ordered';
    END
    GO

    CREATE PROCEDURE dbo.AddDocument
        @SessionID UNIQUEIDENTIFIER, -- ID of the logged-in user (session)
        @ApplicationID INT,          -- ID of the associated application
        @DocumentType NVARCHAR(100), -- Type of the document
        @URL VARCHAR(255)            -- Path/URL of the document
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Declare variables
        DECLARE @UserID INT;
        DECLARE @DocumentID INT;
        DECLARE @CurrentStatus NVARCHAR(20); -- To store the current status of the application

        -- Retrieve the User_ID from the session
        SELECT @UserID = User_ID
        FROM [dbo].[User_Session]
        WHERE Session_ID = @SessionID;

        -- Validate if the user exists
        IF @UserID IS NULL
        BEGIN
            THROW 50000, 'Το session δεν είναι έγκυρο ή ο χρήστης δεν βρέθηκε.', 1;
        END;

        -- Validate if the associated application exists and retrieve its current status
        SELECT @CurrentStatus = Current_Status
        FROM Application
        WHERE Application_ID = @ApplicationID;

        IF @CurrentStatus IS NULL
        BEGIN
            THROW 50001, 'Δεν βρέθηκε καμία αίτηση για το παρεχόμενο αναγνωριστικό αίτησης.', 1;
        END;

        -- Start the transaction block
        BEGIN TRANSACTION;

        BEGIN TRY
            -- Insert the document into the Document table
            INSERT INTO Document (URL, Document_Type, Application_ID, User_ID)
            VALUES ('', @DocumentType, @ApplicationID, @UserID);

            -- Retrieve the newly created Document_ID
            SET @DocumentID = SCOPE_IDENTITY();

            -- Construct the URL dynamically using the Document_ID
            SET @URL = CONCAT('Applications/Documents/', @DocumentType, '/document', @DocumentID, '.pdf');

            -- Update the Document record with the constructed URL
            UPDATE Document
            SET URL = @URL
            WHERE Document_ID = @DocumentID;

            -- Insert a record into the Modification table for logging
            INSERT INTO Modification (
                Modification_Date,
                New_Status,
                Reason,
                User_ID,
                Application_ID
            )
            VALUES (
                GETDATE(), -- Current date
                @CurrentStatus, -- Keep current status
                CONCAT('Added new document: ', @DocumentType, ' ,by TOM'), -- Reason for modification
                @UserID, -- User adding the document
                @ApplicationID -- Associated application
            );

            -- Commit the transaction
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            -- Rollback the transaction if any error occurs
            ROLLBACK TRANSACTION;

            -- Re-throw the error
            THROW;
        END CATCH;
    END;
    GO

    CREATE PROCEDURE dbo.UpdateExpiredApplications
    AS
    BEGIN
        -- Update applications where the current status is 'active' and the date difference is greater than 14 days
        UPDATE [dbo].[Application]
        SET [Current_Status] = 'expired'
        WHERE [Current_Status] = 'active'
        AND DATEDIFF(DAY, [Application_Date], GETDATE()) > 14;
    END;
    GO



    CREATE PROCEDURE dbo.VerifyPasswordBySession
        @SessionID UNIQUEIDENTIFIER,
        @InputPassword NVARCHAR(255)
    AS
    BEGIN
        DECLARE @StoredPassword VARBINARY(512);

        BEGIN TRY
            -- Fetch the stored password for the user associated with the Session_ID
            SELECT @StoredPassword = U.Password
            FROM [dbo].[User] U
            INNER JOIN [dbo].[User_Session] US
            ON U.User_ID = US.User_ID
            WHERE US.Session_ID = @SessionID;

            -- If no password is found, throw an error
            IF @StoredPassword IS NULL
            BEGIN
                THROW 50001, 'Δεν βρέθηκε κωδικός για τον συνδεδεμένο χρήστη.', 1;
            END

            -- Compare the input password with the stored password
            IF HASHBYTES('SHA2_512', @InputPassword) != @StoredPassword
            BEGIN
                THROW 50002, 'Ο κωδικός σας είναι λανθασμένος.', 1;
            END

            -- If the password is correct, return without any output
        END TRY
        BEGIN CATCH
            -- Re-throw any caught errors
            THROW;
        END CATCH
    END;
    GO

   CREATE PROCEDURE dbo.GenerateReport
        @StartDate DATE = NULL,
        @EndDate DATE = NULL,
        @CategoryFilter INT = NULL,
        @ApplicantType VARCHAR(20) = NULL, -- 'Company', 'Private', or NULL
        @TimeGrouping VARCHAR(9) = NULL, -- 'daily', 'monthly', 'quarterly', 'yearly'
        @GroupByCategory BIT = 0,          -- 1 to group by category, 0 otherwise
        @GroupByApplicantType BIT = 0,     -- 1 to group by applicant type, 0 otherwise
        @ReportType INT,                   -- Report type (1 to 11)
        @SortBy VARCHAR(8) = 'Amount',     -- Sort column
        @SortOrder VARCHAR(4) = 'ASC'     -- Sort order
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Validate CategoryFilter
        IF @CategoryFilter IS NOT NULL AND @CategoryFilter NOT IN (SELECT Category_Number FROM Sponsorship_Category)
        BEGIN
            THROW 50001, 'Invalid CategoryFilter provided. Please choose a valid category.', 1;
        END;

        -- Validate ApplicantType
        IF @ApplicantType IS NOT NULL AND @ApplicantType NOT IN ('Company', 'Private')
        BEGIN
            THROW 50002, 'Invalid ApplicantType provided. It must be "Company" or "Private".', 1;
        END;

        -- Validate TimeGrouping
        IF @TimeGrouping IS NOT NULL AND @TimeGrouping NOT IN ('daily', 'weekly', 'monthly', 'quarterly', 'yearly')
        BEGIN
            THROW 50003, 'Invalid TimeGrouping provided. Please choose one of "daily", "weekly", "monthly", "quarterly", or "yearly".', 1;
        END;

        -- Validate SortBy
        IF @SortBy NOT IN ('Amount', 'Category')
        BEGIN
            THROW 50004, 'Invalid SortBy value. Please choose either "Amount" or "Category".', 1;
        END;

        -- Validate SortOrder
        IF @SortOrder NOT IN ('ASC', 'DESC')
        BEGIN
            THROW 50005, 'Invalid SortOrder value. Please choose either "ASC" or "DESC".', 1;
        END;

        -- Validate Specific Conditions Based on ReportType
        IF (@ReportType NOT IN (1, 2)) AND (@SortBy IS NOT NULL OR @SortOrder IS NOT NULL)
        BEGIN
            THROW 50006, 'SortBy and SortOrder are only valid for Report Types 1 and 2.', 1;
        END;

        IF @ReportType = 2 AND (@StartDate IS NOT NULL OR @EndDate IS NOT NULL OR @ApplicantType IS NOT NULL OR @TimeGrouping IS NOT NULL OR @GroupByCategory = 1 OR @GroupByApplicantType = 1)
        BEGIN
            THROW 50007, 'Report Type 2 does not support filtering or grouping by time, category, or applicant type.', 1;
        END;

        IF @ReportType = 4 AND (@CategoryFilter IS NOT NULL OR @GroupByCategory = 1)
        BEGIN
            THROW 50008, 'Report Type 4 does not allow filtering by category or grouping by category.', 1;
        END;

        IF @ReportType = 6 AND (@TimeGrouping IS NULL OR @StartDate IS NOT NULL OR @EndDate IS NOT NULL OR @GroupByCategory = 1 OR @GroupByApplicantType = 1)
        BEGIN
            THROW 50009, 'Report Type 6 does not allow filtering by time or grouping by category or applicant type.', 1;
        END;

        IF (@ReportType IN (1, 2)) AND (@SortBy IS NULL OR @SortOrder IS NULL)
        BEGIN
            THROW 50010, 'Report Type 1 and 2 requires ordering', 1;
        END;

        -- Create temporary table
        CREATE TABLE #FilteredReport (
            [Application_ID] INT,
            [Tracking_Number] NCHAR(8),
            [Application_Date] DATE,
            [Current_Status] VARCHAR(20), 
            [Applicant_ID] INT,
            [Category_Number] INT
        );
        INSERT INTO #FilteredReport (Application_ID, Tracking_Number, Application_Date, Current_Status, Applicant_ID, Category_Number)
        SELECT 
            a.Application_ID,
            a.Tracking_Number,
            a.Application_Date,
            a.Current_Status,
            a.Applicant_ID,
            a.Category_Number
        FROM Application a
        JOIN Applicant ap ON a.Applicant_ID = ap.Applicant_ID  -- Assuming 'Applicant_ID' is the key
        WHERE 
            (@StartDate IS NULL OR a.Application_Date >= @StartDate)
            AND (@EndDate IS NULL OR a.Application_Date <= @EndDate)
            AND (@CategoryFilter IS NULL OR a.Category_Number = @CategoryFilter)
            AND (@ApplicantType IS NULL OR ap.Company_Private = @ApplicantType);

        -- Handle Report Types
        IF @ReportType = 1
        BEGIN
            -- Logic for Report Type 1: Overview of Total Grants
        EXEC dbo.Report1 @TimeGrouping, @GroupByApplicantType, @SortBy, @SortOrder
        END
        ELSE IF @ReportType = 2
        BEGIN
            -- Logic for Report Type 2: Remaining Grants Overview
        EXEC dbo.Report2 @SortBy, @SortOrder
        END
        ELSE IF @ReportType = 3
        BEGIN
            -- Logic for Report Type 3: Application Count Analysis
        EXEC dbo.Report3 @TimeGrouping , @GroupByCategory, @GroupByApplicantType
        END
        ELSE IF @ReportType = 4
        BEGIN
            -- Logic for Report Type 4: % of Total
        EXEC dbo.Report4 @TimeGrouping , @GroupByApplicantType
        END
        ELSE IF @ReportType = 5
        BEGIN
            -- Logic for Report Type 5:  Success Rate Analysis
        EXEC dbo.Report5 @TimeGrouping , @GroupByCategory, @GroupByApplicantType
        END
        ELSE IF @ReportType = 6
        BEGIN
            -- Logic for Report Type 6: High Activity Periods
        EXEC dbo.Report6 @TimeGrouping
        END
        ELSE IF @ReportType = 7
        BEGIN
            -- Logic for Report Type 7: Grant Average by Category
        EXEC dbo.Report7 @TimeGrouping , @GroupByCategory, @GroupByApplicantType
        END
        ELSE IF @ReportType = 8
        BEGIN
            -- Logic for Report Type 8: Highest and Lowest Grants by Category
        EXEC dbo.Report8 @TimeGrouping , @GroupByApplicantType
        END
        ELSE
        BEGIN
            -- Throw an error for invalid ReportType
            THROW 50000, 'Invalid Report Type provided. Please choose a valid report type (1-8).', 1;
        END;

        -- Clean up temp table
        DROP TABLE IF EXISTS #FilteredReport;
    END;
    GO

    CREATE PROCEDURE dbo.Report1
    @TimeGrouping VARCHAR(9) = NULL,       -- 'daily', 'weekly', 'monthly', 'quarterly', 'yearly'
    @GroupByApplicantType BIT = 0,         -- 1 to group by Company_Private, 0 otherwise
    @SortBy VARCHAR(8) = 'Amount',         -- 'Amount' or 'Category'
    @SortOrder VARCHAR(4) = 'ASC'          -- 'ASC' or 'DESC'
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if #FilteredReport exists
    IF OBJECT_ID('tempdb..#FilteredReport') IS NULL
    BEGIN
        -- If the table doesn't exist, throw an error
        THROW 50010, 'The temporary filter table #FilteredReport is required but does not exist.', 1;
    END;

    -- Use #FilteredReport for calculations
    SELECT 
        fr.Category_Number,
        CASE 
            WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
            WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
            WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
            ELSE NULL
        END AS TimePeriod,
        CASE WHEN @GroupByApplicantType = 1 THEN ap.Company_Private ELSE NULL END AS ApplicantType,
        SUM(sc.Amount) AS Total_Amount
    FROM #FilteredReport fr
    INNER JOIN Sponsorship_Category sc ON fr.Category_Number = sc.Category_Number
    INNER JOIN Applicant ap ON fr.Applicant_ID = ap.Applicant_ID
	WHERE fr.Current_Status = 'approved'
    GROUP BY 
        fr.Category_Number,
        CASE 
            WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
            WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
            WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
            ELSE NULL
        END,
        CASE WHEN @GroupByApplicantType = 1 THEN ap.Company_Private ELSE NULL END
    ORDER BY 
        CASE WHEN @SortBy = 'Amount' AND @SortOrder = 'ASC' THEN SUM(sc.Amount) END ASC,
        CASE WHEN @SortBy = 'Amount' AND @SortOrder = 'DESC' THEN SUM(sc.Amount) END DESC,
        CASE WHEN @SortBy = 'Category' AND @SortOrder = 'ASC' THEN fr.Category_Number END ASC,
        CASE WHEN @SortBy = 'Category' AND @SortOrder = 'DESC' THEN fr.Category_Number END DESC;
END;
GO

     CREATE PROCEDURE dbo.Report2
    @SortBy VARCHAR(8) = 'Amount',    -- 'Amount' or 'Category'
    @SortOrder VARCHAR(4) = 'ASC'     -- 'ASC' or 'DESC'
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for existence of the #FilteredReport table
    IF OBJECT_ID('tempdb..#FilteredReport') IS NULL
    BEGIN
        THROW 50010, '#FilteredReport table not found. Please ensure it is created and populated.', 1;
    END;

    -- Query using the filtered report and approved applications
    SELECT 
        sc.Category_Number,
        (sc.Total_Positions - COUNT(CASE WHEN fr.Current_Status = 'approved' THEN fr.Application_ID END)) * sc.Amount AS Remaining_Amount
    FROM Sponsorship_Category sc
    LEFT JOIN #FilteredReport fr ON sc.Category_Number = fr.Category_Number
    GROUP BY sc.Category_Number, sc.Total_Positions, sc.Amount
    ORDER BY 
        CASE WHEN @SortBy = 'Amount' AND @SortOrder = 'ASC' THEN 
            (sc.Total_Positions - COUNT(CASE WHEN fr.Current_Status = 'approved' THEN fr.Application_ID END)) * sc.Amount END ASC,
        CASE WHEN @SortBy = 'Amount' AND @SortOrder = 'DESC' THEN 
            (sc.Total_Positions - COUNT(CASE WHEN fr.Current_Status = 'approved' THEN fr.Application_ID END)) * sc.Amount END DESC,
        CASE WHEN @SortBy = 'Category' AND @SortOrder = 'ASC' THEN sc.Category_Number END ASC,
        CASE WHEN @SortBy = 'Category' AND @SortOrder = 'DESC' THEN sc.Category_Number END DESC;
END;
GO

   CREATE PROCEDURE dbo.Report3
    @TimeGrouping VARCHAR(9) = NULL,      -- 'daily', 'weekly', 'monthly', 'quarterly', 'yearly'
    @GroupByCategory BIT = 0,            -- 1 to group by category, 0 otherwise
    @GroupByApplicantType BIT = 0        -- 1 to group by applicant type, 0 otherwise
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate inputs
    IF @TimeGrouping IS NOT NULL AND @TimeGrouping NOT IN ('daily', 'weekly', 'monthly', 'quarterly', 'yearly')
    BEGIN
        THROW 50010, 'Invalid TimeGrouping value. Please choose "daily", "weekly", "monthly", "quarterly", or "yearly".', 1;
    END;

    -- Check for existence of the #FilteredReport table
    IF OBJECT_ID('tempdb..#FilteredReport') IS NULL
    BEGIN
        THROW 50002, '#FilteredReport table not found. Please ensure it is created and populated.', 1;
    END;

    -- Perform Application Count Analysis
    SELECT 
        CASE 
            WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
            WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
            WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
            ELSE NULL
        END AS TimePeriod,
        CASE WHEN @GroupByCategory = 1 THEN fr.Category_Number ELSE NULL END AS Category,
        CASE WHEN @GroupByApplicantType = 1 THEN ap.Company_Private ELSE NULL END AS Applicant_Type,
        COUNT(*) AS Total_Applications
    FROM #FilteredReport fr
    INNER JOIN Applicant ap ON fr.Applicant_ID = ap.Applicant_ID
    GROUP BY 
        CASE 
            WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
            WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
            WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
            ELSE NULL
        END,
        CASE WHEN @GroupByCategory = 1 THEN fr.Category_Number ELSE NULL END,
        CASE WHEN @GroupByApplicantType = 1 THEN ap.Company_Private ELSE NULL END
    ORDER BY TimePeriod ASC, Category ASC, Applicant_Type ASC;
END;
GO

  CREATE PROCEDURE dbo.Report4
    @TimeGrouping VARCHAR(9) = NULL,      -- 'daily', 'weekly', 'monthly', 'quarterly', 'yearly'
    @GroupByApplicantType BIT = 0         -- 1 to group by applicant type, 0 otherwise
AS
BEGIN
    SET NOCOUNT ON;


    -- Check for existence of the #FilteredReport table
    IF OBJECT_ID('tempdb..#FilteredReport') IS NULL
    BEGIN
        THROW 50010, '#FilteredReport table not found. Please ensure it is created and populated.', 1;
    END;

    -- Perform Success Rate Analysis
    SELECT 
        CASE 
            WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
            WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
            WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
            ELSE NULL
        END AS TimePeriod,
        fr.Category_Number AS Category,
        CASE WHEN @GroupByApplicantType = 1 THEN ap.Company_Private ELSE NULL END AS Applicant_Type,
        COUNT(*) AS Total_Applications,
        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY 
                CASE 
                    WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
                    WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
                    WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
                    WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
                    WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
                    ELSE NULL
                END
            ), 2) AS Percentage_Of_Total
    FROM #FilteredReport fr
    INNER JOIN Applicant ap ON fr.Applicant_ID = ap.Applicant_ID
    GROUP BY 
        CASE 
            WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
            WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
            WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
            WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
            ELSE NULL
        END,
        fr.Category_Number,
        CASE WHEN @GroupByApplicantType = 1 THEN ap.Company_Private ELSE NULL END
    ORDER BY TimePeriod ASC, Category ASC, Applicant_Type ASC;
END;
GO


    CREATE PROCEDURE dbo.Report5
        @TimeGrouping VARCHAR(9),           -- 'daily', 'weekly', 'monthly', 'quarterly', or 'yearly'
        @GroupByCategory BIT = 0,           -- 1 to group by category, 0 otherwise
        @GroupByApplicantType BIT = 0       -- 1 to group by applicant type, 0 otherwise
    AS
    BEGIN
        SET NOCOUNT ON;

        IF OBJECT_ID('tempdb..#FilteredReport') IS NULL
        BEGIN
            THROW 50010, '#FilteredReport does not exist. Please ensure the table is created before running the report.', 1;
        END;

        -- Base query structure
        SELECT
            -- Time grouping based on @TimeGrouping input
            CASE 
                WHEN @TimeGrouping = 'daily' THEN FORMAT(Application_Date, 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'weekly' THEN CONCAT(YEAR(Application_Date), ' Week ', DATEPART(WEEK, Application_Date))
                WHEN @TimeGrouping = 'monthly' THEN FORMAT(Application_Date, 'yyyy-MM')
                WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(Application_Date), ' Q', DATEPART(QUARTER, Application_Date))
                WHEN @TimeGrouping = 'yearly' THEN CAST(YEAR(Application_Date) AS NVARCHAR) -- Convert to NVARCHAR for consistency
                ELSE NULL
            END AS TimePeriod,

            -- Optionally group by Category if @GroupByCategory = 1
            CASE WHEN @GroupByCategory = 1 THEN SC.Category_Number ELSE NULL END AS Category,

            -- Optionally group by ApplicantType if @GroupByApplicantType = 1
            CASE WHEN @GroupByApplicantType = 1 THEN A.Company_Private ELSE NULL END AS ApplicantType,

            -- Success rate calculation
            CAST(SUM(CASE WHEN F.Current_Status = 'approved' THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) / COUNT(*) * 100 AS SuccessRate

        FROM
            #FilteredReport F
        -- Joining with Applicant and Sponsorship_Category tables to get details
        JOIN Applicant A ON F.Applicant_ID = A.Applicant_ID
        JOIN Sponsorship_Category SC ON F.Category_Number = SC.Category_Number

        -- Grouping the results based on the inputs
        GROUP BY 
            CASE 
                WHEN @TimeGrouping = 'daily' THEN FORMAT(Application_Date, 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'weekly' THEN CONCAT(YEAR(Application_Date), ' Week ', DATEPART(WEEK, Application_Date))
                WHEN @TimeGrouping = 'monthly' THEN FORMAT(Application_Date, 'yyyy-MM')
                WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(Application_Date), ' Q', DATEPART(QUARTER, Application_Date))
                WHEN @TimeGrouping = 'yearly' THEN CAST(YEAR(Application_Date) AS NVARCHAR) -- Convert to NVARCHAR for consistency
                ELSE NULL
            END,

            -- Group by Category if needed
            CASE WHEN @GroupByCategory = 1 THEN SC.Category_Number ELSE NULL END,

            -- Group by Applicant Type if needed
            CASE WHEN @GroupByApplicantType = 1 THEN A.Company_Private ELSE NULL END;
    END;
    GO

    CREATE PROCEDURE dbo.Report6
        @TimeGrouping VARCHAR(9) -- 'daily', 'weekly', 'monthly', 'quarterly', or 'yearly'
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Check if #FilteredReport exists
        IF OBJECT_ID('tempdb..#FilteredReport') IS NULL
        BEGIN
            THROW 50010, '#FilteredReport does not exist. Please ensure the table is created before running the report.', 1;
        END;

        -- Generate report for high activity periods based on the modification table
        SELECT
            -- Time grouping based on @TimeGrouping input
            CASE 
                WHEN @TimeGrouping = 'daily' THEN FORMAT(M.Modification_Date, 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'weekly' THEN CONCAT(YEAR(M.Modification_Date), ' Week ', DATEPART(WEEK, M.Modification_Date))
                WHEN @TimeGrouping = 'monthly' THEN FORMAT(M.Modification_Date, 'yyyy-MM')
                WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(M.Modification_Date), ' Q', DATEPART(QUARTER, M.Modification_Date))
                WHEN @TimeGrouping = 'yearly' THEN CAST(YEAR(Application_Date) AS NVARCHAR)
                ELSE NULL
            END AS TimePeriod,

            -- Count of modifications for each period
            COUNT(*) AS TotalModifications

        FROM
            #FilteredReport F
        INNER JOIN 
            Modification M
            ON F.Application_ID = M.Application_ID

        -- Grouping by the selected time period
        GROUP BY 
            CASE 
                WHEN @TimeGrouping = 'daily' THEN FORMAT(M.Modification_Date, 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'weekly' THEN CONCAT(YEAR(M.Modification_Date), ' Week ', DATEPART(WEEK, M.Modification_Date))
                WHEN @TimeGrouping = 'monthly' THEN FORMAT(M.Modification_Date, 'yyyy-MM')
                WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(M.Modification_Date), ' Q', DATEPART(QUARTER, M.Modification_Date))
                WHEN @TimeGrouping = 'yearly' THEN CAST(YEAR(Application_Date) AS NVARCHAR)
                ELSE NULL
            END

        -- Sorting by TotalModifications in descending order
        ORDER BY TotalModifications DESC;

    END;
    GO

    CREATE PROCEDURE dbo.Report7
        @TimeGrouping VARCHAR(9),           -- 'daily', 'weekly', 'monthly', 'quarterly', 'yearly'
        @GroupByCategory BIT = 1,           -- 1 to group by category (mandatory)
        @GroupByApplicantType BIT = 0       -- 1 to group by applicant type, 0 otherwise
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Check if #FilteredReport exists
        IF OBJECT_ID('tempdb..#FilteredReport') IS NULL
        BEGIN
            THROW 50010, '#FilteredReport temporary table not found. Ensure filtering step is completed before running this report.', 1;
        END;

        -- Query to calculate the average grant amount
        SELECT 
            -- Time grouping based on @TimeGrouping
            CASE 
                WHEN @TimeGrouping = 'daily' THEN FORMAT(f.Application_Date, 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'weekly' THEN CONCAT(YEAR(f.Application_Date), ' Week ', DATEPART(WEEK, f.Application_Date))
                WHEN @TimeGrouping = 'monthly' THEN FORMAT(f.Application_Date, 'yyyy-MM')
                WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(f.Application_Date), ' Q', DATEPART(QUARTER, f.Application_Date))
                WHEN @TimeGrouping = 'yearly' THEN CAST(YEAR(f.Application_Date) AS NVARCHAR)
            END AS TimePeriod,

            -- Category grouping
            CASE 
                WHEN @GroupByCategory = 1 THEN f.Category_Number
                ELSE NULL
            END AS CategoryNumber,

            -- Applicant type grouping (company or private)
            CASE 
                WHEN @GroupByApplicantType = 1 THEN a.Company_Private
                ELSE NULL
            END AS ApplicantType,

            -- Average grant amount
            AVG(c.Amount) AS AvgGrantAmount
        FROM 
            #FilteredReport f
        INNER JOIN 
            Application app ON f.Application_ID = app.Application_ID AND app.Current_Status = 'approved' -- Approved applications only
        INNER JOIN 
            Sponsorship_Category c ON f.Category_Number = c.Category_Number -- Join with category for grant amounts
        INNER JOIN 
            Applicant a ON f.Applicant_ID = a.Applicant_ID -- Join with applicant for type grouping
        GROUP BY 
            -- Time grouping
            CASE 
                WHEN @TimeGrouping = 'daily' THEN FORMAT(f.Application_Date, 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'weekly' THEN CONCAT(YEAR(f.Application_Date), ' Week ', DATEPART(WEEK, f.Application_Date))
                WHEN @TimeGrouping = 'monthly' THEN FORMAT(f.Application_Date, 'yyyy-MM')
                WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(f.Application_Date), ' Q', DATEPART(QUARTER, f.Application_Date))
                WHEN @TimeGrouping = 'yearly' THEN CAST(YEAR(f.Application_Date) AS NVARCHAR)
            END,
            -- Category grouping
            CASE 
                WHEN @GroupByCategory = 1 THEN f.Category_Number
            END,
            -- Applicant type grouping
            CASE 
                WHEN @GroupByApplicantType = 1 THEN a.Company_Private
            END
    END;
    GO


    CREATE PROCEDURE dbo.Report8
        @TimeGrouping VARCHAR(9) = NULL,      -- 'daily', 'weekly', 'monthly', 'quarterly', 'yearly'
        @GroupByCategory BIT = 0,             -- 1 to group by category, 0 otherwise
        @GroupByApplicantType BIT = 0         -- 1 to group by applicant type, 0 otherwise
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Check for existence of the #FilteredReport table
        IF OBJECT_ID('tempdb..#FilteredReport') IS NULL
        BEGIN
            THROW 50010, '#FilteredReport table not found. Please ensure it is created and populated.', 1;
        END;

        -- Temporary table to store calculated amounts
        CREATE TABLE #GrantTotals (
            TimePeriod VARCHAR(20) NULL,
            Category_Number INT,
            Applicant_Type NVARCHAR(10) NULL,
            Total_Grant DECIMAL(15, 2)
        );

        -- Insert calculated amounts into the temp table
        INSERT INTO #GrantTotals (TimePeriod, Category_Number, Applicant_Type, Total_Grant)
        SELECT 
            CASE 
                WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
                WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
                WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
                ELSE NULL
            END AS TimePeriod,
            fr.Category_Number,
            CASE WHEN @GroupByApplicantType = 1 THEN ap.Company_Private ELSE NULL END AS Applicant_Type,
            sc.Amount AS Total_Grant
        FROM #FilteredReport fr
        INNER JOIN Sponsorship_Category sc ON fr.Category_Number = sc.Category_Number
        INNER JOIN Applicant ap ON fr.Applicant_ID = ap.Applicant_ID
        WHERE fr.Current_Status = 'approved' -- Only approved applications
        GROUP BY 
            fr.Category_Number,
            CASE 
                WHEN @TimeGrouping = 'daily' THEN FORMAT(fr.Application_Date, 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'weekly' THEN FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, fr.Application_Date) + 1, fr.Application_Date), 'yyyy-MM-dd')
                WHEN @TimeGrouping = 'monthly' THEN FORMAT(fr.Application_Date, 'yyyy-MM')
                WHEN @TimeGrouping = 'quarterly' THEN CONCAT(YEAR(fr.Application_Date), '-Q', DATEPART(QUARTER, fr.Application_Date))
                WHEN @TimeGrouping = 'yearly' THEN FORMAT(fr.Application_Date, 'yyyy')
                ELSE NULL
            END,
            CASE WHEN @GroupByApplicantType = 1 THEN ap.Company_Private ELSE NULL END,
            sc.Amount;

        -- Select the highest and lowest grant categories
        SELECT * FROM 
        (
            SELECT TOP 1 WITH TIES
                'Highest' AS GrantType,
                Category_Number,
                TimePeriod,
                Applicant_Type,
                Total_Grant
            FROM #GrantTotals
            ORDER BY Total_Grant DESC
        ) AS HighestGrants

        UNION ALL

        SELECT * FROM 
        (
            SELECT TOP 1 WITH TIES
                'Lowest' AS GrantType,
                Category_Number,
                TimePeriod,
                Applicant_Type,
                Total_Grant
            FROM #GrantTotals
            ORDER BY Total_Grant ASC
        ) AS LowestGrants;

        -- Clean up temporary table
        DROP TABLE IF EXISTS #GrantTotals;
    END;
    GO
        
    --dbo.Report9 @StartDate , @EndDate
    --dbo.Report10 
    --dbo.Report11 @X
