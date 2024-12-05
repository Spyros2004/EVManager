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

-- DROP CONSTRAINTS
DROP INDEX IF EXISTS IX_Application_TrackingNumber ON Application;
GO

DROP INDEX IF EXISTS IX_Application_Status_Category ON Application;
GO

DROP INDEX IF EXISTS IX_Application_ApplicationDate ON Application;
GO

DROP INDEX IF EXISTS IX_Applicant_UserID_CompanyPrivate ON Applicant;
GO

DROP INDEX IF EXISTS IX_Application_Status_Date ON Application;
GO

-- Drop foreign key constraints
ALTER TABLE [dbo].[Discarded_Car] DROP CONSTRAINT [FK_DISCARDED_CAR_APPLICATION];
GO
ALTER TABLE [dbo].[User_Session] DROP CONSTRAINT [FK_USER_SESSION_USER]
GO
ALTER TABLE [dbo].[Vehicle] DROP CONSTRAINT [FK_VEHICLE_DOCUMENT]
GO
ALTER TABLE [dbo].[Modification] DROP CONSTRAINT [FK_MODIFICATION_APPLICATION]
GO
ALTER TABLE [dbo].[Modification] DROP CONSTRAINT [FK_MODIFICATION_USER]
GO
ALTER TABLE [dbo].[Document] DROP CONSTRAINT [FK_DOCUMENT_USER]
GO
ALTER TABLE [dbo].[Document] DROP CONSTRAINT [FK_DOCUMENT_APPLICATION]
GO
ALTER TABLE [dbo].[Application] DROP CONSTRAINT [FK_APPLICATION_SPONSORSHIP_CATEGORY]
GO
ALTER TABLE [dbo].[Application] DROP CONSTRAINT [FK_APPLICATION_APPLICANT]
GO
ALTER TABLE [dbo].[Category_Has_Criterion] DROP CONSTRAINT [FK_HAS_CRITERIA]
GO

ALTER TABLE [dbo].[Category_Has_Criterion] DROP CONSTRAINT [FK_HAS_SPONSORSHIP_CATEGORY]
GO
ALTER TABLE [dbo].[Applicant] DROP CONSTRAINT [FK_APPLICANT_USER]
GO

-- Drop tables in reverse order to avoid dependency issues

DROP TABLE [dbo].[User_Session]
GO
DROP TABLE [dbo].[Vehicle]
GO
DROP TABLE [dbo].[Modification]
GO
DROP TABLE [dbo].[Document]
GO
DROP TABLE [dbo].[Application]
GO
DROP TABLE [dbo].[Category_Has_Criterion]
GO
DROP TABLE [dbo].[Criterion]
GO
DROP TABLE [dbo].[Applicant]
GO
DROP TABLE [dbo].[Sponsorship_Category]
GO
DROP TABLE [dbo].[User]
GO

DROP TABLE [dbo].[Discarded_Car];
GO
