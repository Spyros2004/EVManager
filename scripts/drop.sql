-- DROP FOREIGN KEY CONSTRAINTS
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_APPLICANT_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[Applicant]'))
    ALTER TABLE [dbo].[Applicant] DROP CONSTRAINT [FK_APPLICANT_USER];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_HAS_SPONSORSHIP_CATEGORY]') AND parent_object_id = OBJECT_ID(N'[dbo].[CategoryHasCriterion]'))
    ALTER TABLE [dbo].[CategoryHasCriterion] DROP CONSTRAINT [FK_HAS_SPONSORSHIP_CATEGORY];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_HAS_CRITERIA]') AND parent_object_id = OBJECT_ID(N'[dbo].[CategoryHasCriterion]'))
    ALTER TABLE [dbo].[CategoryHasCriterion] DROP CONSTRAINT [FK_HAS_CRITERIA];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_APPLICATION_APPLICANT]') AND parent_object_id = OBJECT_ID(N'[dbo].[Application]'))
    ALTER TABLE [dbo].[Application] DROP CONSTRAINT [FK_APPLICATION_APPLICANT];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_APPLICATION_SPONSORSHIP_CATEGORY]') AND parent_object_id = OBJECT_ID(N'[dbo].[Application]'))
    ALTER TABLE [dbo].[Application] DROP CONSTRAINT [FK_APPLICATION_SPONSORSHIP_CATEGORY];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DOCUMENT_APPLICATION]') AND parent_object_id = OBJECT_ID(N'[dbo].[Document]'))
    ALTER TABLE [dbo].[Document] DROP CONSTRAINT [FK_DOCUMENT_APPLICATION];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DOCUMENT_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[Document]'))
    ALTER TABLE [dbo].[Document] DROP CONSTRAINT [FK_DOCUMENT_USER];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MODIFICATION_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[Modification]'))
    ALTER TABLE [dbo].[Modification] DROP CONSTRAINT [FK_MODIFICATION_USER];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MODIFICATION_APPLICATION]') AND parent_object_id = OBJECT_ID(N'[dbo].[Modification]'))
    ALTER TABLE [dbo].[Modification] DROP CONSTRAINT [FK_MODIFICATION_APPLICATION];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VEHICLE_DOCUMENT]') AND parent_object_id = OBJECT_ID(N'[dbo].[Vehicle]'))
    ALTER TABLE [dbo].[Vehicle] DROP CONSTRAINT [FK_VEHICLE_DOCUMENT];
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_USER_SESSION_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[User_Session]'))
    ALTER TABLE [dbo].[User_Session] DROP CONSTRAINT [FK_USER_SESSION_USER];
GO

-- DROP TABLES
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Applicant]') AND type IN (N'U'))
    DROP TABLE [dbo].[Applicant];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CategoryHasCriterion]') AND type IN (N'U'))
    DROP TABLE [dbo].[CategoryHasCriterion];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Application]') AND type IN (N'U'))
    DROP TABLE [dbo].[Application];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Document]') AND type IN (N'U'))
    DROP TABLE [dbo].[Document];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Modification]') AND type IN (N'U'))
    DROP TABLE [dbo].[Modification];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vehicle]') AND type IN (N'U'))
    DROP TABLE [dbo].[Vehicle];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type IN (N'U'))
    DROP TABLE [dbo].[User];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sponsorship_Category]') AND type IN (N'U'))
    DROP TABLE [dbo].[Sponsorship_Category];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Criterion]') AND type IN (N'U'))
    DROP TABLE [dbo].[Criterion];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User_Session]') AND type IN (N'U'))
    DROP TABLE [dbo].[User_Session];
GO
