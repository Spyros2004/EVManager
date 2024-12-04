DROP TRIGGER IF EXISTS [dbo].[DecrementSponsorshipPositions]
GO
DROP TRIGGER IF EXISTS [dbo].[IncrementSponsorshipPositions]
GO
DROP TRIGGER IF EXISTS [dbo].[SetTrackingNumber]
GO
DROP TRIGGER IF EXISTS [dbo].[UpdateStatusOnUserType]
GO
DROP TRIGGER IF EXISTS [dbo].[SetRemainingPositions]
GO
DROP TRIGGER IF EXISTS [dbo].[InsertModificationAfterApplicationInsert]
GO

CREATE TRIGGER IncrementRemainingPositions
ON Application
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the status of the application has changed to 'rejected' or 'expired'
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.Application_ID = d.Application_ID
        WHERE i.Current_Status IN ('rejected', 'expired')
          AND d.Current_Status NOT IN ('rejected', 'expired')
    )
    BEGIN
        -- Increase the remaining positions for the relevant category
        UPDATE Sponsorship_Category
        SET Remaining_Positions = Remaining_Positions + 1
        WHERE Category_Number IN (
            SELECT i.Category_Number
            FROM inserted i
            JOIN deleted d ON i.Application_ID = d.Application_ID
            WHERE i.Current_Status IN ('rejected', 'expired')
              AND d.Current_Status NOT IN ('rejected', 'expired')
        );
    END
END;
GO
    
CREATE TRIGGER [dbo].[InsertModificationAfterApplicationInsert]
ON [dbo].[Application]
AFTER INSERT
AS
BEGIN
    -- Insert a record into the Modification table when a new Application is inserted
    INSERT INTO [dbo].[Modification] 
        (New_Status, Reason, User_ID, Application_ID)
    SELECT 
        'active',                    -- Status for the new application (or use logic based on the app's status)
        'Application Submitted',       -- Reason for the modification
        U.User_ID,                    -- User who submitted the application (assuming the user is logged in)
        I.Application_ID              -- ID of the newly inserted application
    FROM 
        INSERTED I
    JOIN
        [dbo].[Applicant] A ON A.Applicant_ID = I.Applicant_ID
    JOIN
        [dbo].[User] U ON U.User_ID = A.User_ID;  -- Get the User_ID from the Applicant table
END
GO

CREATE TRIGGER [dbo].[UpdateStatusOnUserType]
ON [dbo].[User]
AFTER INSERT
AS
BEGIN
    -- Update the Status to 'approved' for new records where User_Type is 'Admin' or 'Applicant'
    UPDATE U
    SET [Status] = 'approved'
    FROM [dbo].[User] U
    INNER JOIN INSERTED I ON U.User_ID = I.User_ID
    WHERE I.User_Type IN ('Admin', 'Applicant');
END
GO

CREATE TRIGGER [dbo].[SetRemainingPositions]
ON Sponsorship_Category
AFTER INSERT
AS
BEGIN
    -- Update Remaining_Positions to be the same as Total_Positions for the inserted record(s)
    UPDATE Sponsorship_Category
    SET Remaining_Positions = Total_Positions
    WHERE Category_Number IN (SELECT Category_Number FROM INSERTED);
END;
GO

CREATE TRIGGER [dbo].[SetTrackingNumber]
ON Application
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CategoryNumber INT, @CategoryCount INT, @TrackingNumber NCHAR(8), @ApplicationID INT;

    -- Retrieve the Category Number for the newly inserted application
    SELECT @CategoryNumber = Category_Number, @ApplicationID = Application_ID
    FROM inserted;

    -- Get the next available count for the category
    SELECT @CategoryCount = COUNT(*)
    FROM Application
    WHERE Category_Number = @CategoryNumber;

    -- Generate the tracking number in the format: ΓCategoryNumber.Number (e.g., Γ13.0001)
    SET @TrackingNumber = CONCAT(N'Γ', FORMAT(@CategoryNumber, '00'), '.', FORMAT(@CategoryCount, '0000'));

    -- Update the newly inserted application with the generated tracking number
    UPDATE Application
    SET Tracking_Number = @TrackingNumber
    WHERE Application_ID = @ApplicationID;
END;
GO

CREATE TRIGGER DecrementSponsorshipPositions
ON Application
AFTER INSERT
AS
BEGIN
    DECLARE @CategoryNumber INT;

    -- Retrieve the Category Number for the newly inserted application
    SELECT @CategoryNumber = Category_Number
    FROM inserted;

    -- Decrement Remaining_Positions in the Sponsorship_Category table for the given category
    UPDATE Sponsorship_Category
    SET Remaining_Positions = Remaining_Positions - 1
    WHERE Category_Number = @CategoryNumber;

END;
GO
