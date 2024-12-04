-- DROP CONSTRAINTS
DROP INDEX IX_Application_TrackingNumber ON Application;
GO

DROP INDEX IX_Application_Status_Category ON Application;
GO

DROP INDEX IX_Application_ApplicationDate ON Application;
GO

DROP INDEX IX_Applicant_UserID_CompanyPrivate ON Applicant;
GO

DROP INDEX IX_Application_Status_Date ON Application;
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
ALTER TABLE [dbo].[Category_Has_Criterion] DROP CONSTRAINT [FK_HAS_CRITERIA]GO

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
