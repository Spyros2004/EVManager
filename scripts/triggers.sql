DROP TRIGGER IF EXISTS [dbo].[UpdateStatusOnUserType]
GO
DROP TRIGGER IF EXISTS [dbo].[SetRemainingPositions]
GO
DROP TRIGGER IF EXISTS [dbo].[InsertModificationAfterApplicationInsert]
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
