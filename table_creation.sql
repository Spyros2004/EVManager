/*USE COMPANY --name of your database
GO*/

SET ANSI_NULLS ON
GO

--DROP FOREIGN KEY CONSTRAINTS
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_APPLICANT_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[Applicant]'))
ALTER TABLE [dbo].[Applicant] DROP CONSTRAINT [FK_APPLICANT_USER]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_HAS_SPONSORSHIP_CATEGORY]') AND parent_object_id = OBJECT_ID(N'[dbo].[Has]'))
ALTER TABLE [dbo].[Has] DROP CONSTRAINT [FK_HAS_SPONSORSHIP_CATEGORY]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_HAS_CRITERIA]') AND parent_object_id = OBJECT_ID(N'[dbo].[Has]'))
ALTER TABLE [dbo].[Has] DROP CONSTRAINT [FK_HAS_CRITERIA]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_APPLICATION_APPLICANT]') AND parent_object_id = OBJECT_ID(N'[dbo].[Application]'))
ALTER TABLE [dbo].[Application] DROP CONSTRAINT [FK_APPLICATION_APPLICANT]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_APPLICATION_SPONSORSHIP_CATEGORY]') AND parent_object_id = OBJECT_ID(N'[dbo].[Application]'))
ALTER TABLE [dbo].[Application] DROP CONSTRAINT [FK_APPLICATION_SPONSORSHIP_CATEGORY]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DOCUMENT_APPLICATION]') AND parent_object_id = OBJECT_ID(N'[dbo].[Document]'))
ALTER TABLE [dbo].[Document] DROP CONSTRAINT [FK_DOCUMENT_APPLICATION]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DOCUMENT_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[Document]'))
ALTER TABLE [dbo].[Document] DROP CONSTRAINT [FK_DOCUMENT_USER]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHANGE_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[Change]'))
ALTER TABLE [dbo].[Change] DROP CONSTRAINT [FK_CHANGE_USER]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHANGE_APPLICATION]') AND parent_object_id = OBJECT_ID(N'[dbo].[Change]'))
ALTER TABLE [dbo].[Change] DROP CONSTRAINT [FK_CHANGE_APPLICATION]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VEHICLE_DOCUMENT]') AND parent_object_id = OBJECT_ID(N'[dbo].[Vehicle]'))
ALTER TABLE [dbo].[Vehicle] DROP CONSTRAINT [FK_VEHICLE_DOCUMENT]
GO


--DROP TABLES
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Applicant]') AND type in (N'U'))
DROP TABLE [dbo].[Applicant]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Has]') AND type in (N'U'))
DROP TABLE [dbo].[Has]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Application]') AND type in (N'U'))
DROP TABLE [dbo].[Application]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Document]') AND type in (N'U'))
DROP TABLE [dbo].[Document]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Change]') AND type in (N'U'))
DROP TABLE [dbo].[Change]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vehicle]') AND type in (N'U'))
DROP TABLE [dbo].[Vehicle]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
DROP TABLE [dbo].[User]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sponsorship_Category]') AND type in (N'U'))
DROP TABLE [dbo].[Sponsorship_Category]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Criteria]') AND type in (N'U'))
DROP TABLE [dbo].[Criteria]
GO

--CREATE TABLES
CREATE TABLE [dbo].[User]
(
    [User_ID] INT NOT NULL IDENTITY(1,1), 
    [First_Name] VARCHAR(50) NOT NULL, 
    [Last_Name] VARCHAR(50) NOT NULL, 
    [Username] VARCHAR(50) NOT NULL, 
    [Email] VARCHAR(100) NOT NULL, 
    [Password] VARCHAR(255) NOT NULL, 
    [User_Type] VARCHAR(20) NOT NULL CHECK ([User_Type] IN ('Admin', 'TOM', 'AA', 'User', 'Applicant')), 
    [Status] VARCHAR(20) NOT NULL CHECK ([Status] IN ('pending', 'approved', 'suspended', 'deactivated', 'rejected')), 
    UNIQUE ([Username]),
    UNIQUE ([Email]),
    CONSTRAINT [PK_USER] PRIMARY KEY ([User_ID] ASC)
)

CREATE TABLE [dbo].[Sponsorship_Category]
(
    [Category_Number] INT NOT NULL IDENTITY(1,1),
    [Description] VARCHAR(255) NOT NULL, 
    [Amount] DECIMAL(15, 2) NOT NULL CHECK ([Amount] > 0), 
    [Total_Positions] INT NOT NULL CHECK ([Total_Positions] > 0), 
    [Remaining_Positions] INT NOT NULL,
    CONSTRAINT [PK_SPONSORSHIP_CATEGORY] PRIMARY KEY ([Category_Number] ASC)
)

CREATE TABLE [dbo].[Applicant]
(
    [Applicant_ID] INT NOT NULL IDENTITY(1,1), 
    [Company_Private] VARCHAR(20) NOT NULL CHECK ([Company_Private] IN ('company', 'private')),
    [Gender] CHAR(1) NOT NULL CHECK ([Gender] IN ('M', 'F', 'O')),
    [BirthDate] DATE NOT NULL,
    [User_ID] INT NOT NULL,
    CONSTRAINT [PK_APPLICANT] PRIMARY KEY ([Applicant_ID] ASC)
)

CREATE TABLE [dbo].[Criteria]
(
    [Criteria_Number] INT NOT NULL IDENTITY(1,1),
    [Title] VARCHAR(255) NOT NULL,
    [Description] VARCHAR(255) NOT NULL,
    UNIQUE ([Title]),
    CONSTRAINT [PK_CRITERIA] PRIMARY KEY ([Criteria_Number] ASC)
)

CREATE TABLE [dbo].[Has]
(
    [Category_Number] INT NOT NULL,
    [Criteria_Number] VARCHAR(10) NOT NULL, 
    CONSTRAINT [PK_HAS] PRIMARY KEY ([Category_Number], [Criteria_Number] ASC)
)

CREATE TABLE [dbo].[Application]
(
    [Application_ID] INT NOT NULL IDENTITY(1,1),
    [Application_Date] DATE NOT NULL,
    [Discarder_Car_LPN] CHAR(6), 
    [Attempt] INT NOT NULL DEFAULT 1,
    [Current_Status] VARCHAR(20) NOT NULL CHECK ([Current_Status] IN ('pending', 'approved', 'rejected', 'under_review', 'in_progress')), 
    [Applicant_ID] INT NOT NULL,
    [Category_Number] INT NOT NULL,
    UNIQUE ([Discarder_Car_LPN]),
    CONSTRAINT [PK_APPLICATION] PRIMARY KEY ([Application_ID] ASC)
)

CREATE TABLE [dbo].[Document]
(
    [Document_ID] INT NOT NULL IDENTITY(1,1),
    [URL] VARCHAR(255) NOT NULL, 
    [Document_Type] VARCHAR(50) NOT NULL CHECK ([Document_Type] IN ('type1', 'type2', 'type3')),
    [Reason] VARCHAR(255) NOT NULL,
    [Application_ID] INT NOT NULL,
    [User_ID] INT NOT NULL,
    UNIQUE ([URL]),
    CONSTRAINT [PK_DOCUMENT] PRIMARY KEY ([Document_ID] ASC)
)

CREATE TABLE [dbo].[Change]
(
    [Log_ID] INT NOT NULL IDENTITY(1,1),
    [Modification_Date] DATE NOT NULL,
    [New_Status] VARCHAR(20) NOT NULL CHECK ([New_Status] IN ('approved', 'rejected', 'under_review')),
    [Reason] VARCHAR(255) NOT NULL, 
    [User_ID] INT NOT NULL,
    [Application_ID] INT NOT NULL,
    CONSTRAINT [PK_CHANGE] PRIMARY KEY ([Log_ID] ASC)
)

CREATE TABLE [dbo].[Vehicle]
(
    [Vehicle_ID] INT NOT NULL IDENTITY(1,1), 
    [Vehicle_Year] INT NOT NULL,
    [Vehicle_Month] INT NOT NULL CHECK ([Vehicle_Month] >= 1 AND [Vehicle_Month] <= 12), 
    [Vehicle_Type] VARCHAR(20) NOT NULL CHECK ([Vehicle_Type] IN ('electric', 'hybrid')), 
    [CO2_Emissions] INT NOT NULL CHECK ([CO2_Emissions] <= 50), 
    [Brand] VARCHAR(50) NOT NULL, 
    [Price] DECIMAL(15, 2) NOT NULL CHECK ([Price] <= 80000), 
    [Engine_Fuel] VARCHAR(10) NOT NULL CHECK ([Engine_Fuel] IN ('diesel', 'petrol')), 
    [Document_ID] INT NOT NULL,
    CONSTRAINT [PK_VEHICLE] PRIMARY KEY ([Vehicle_ID] ASC)
)

--CREATE FOREIGN KEY CONSTRAINTS
ALTER TABLE [dbo].[Applicant] WITH CHECK ADD CONSTRAINT [FK_APPLICANT_USER]
FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User] ([User_ID])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Has] WITH CHECK ADD CONSTRAINT [FK_HAS_SPONSORSHIP_CATEGORY]
FOREIGN KEY ([Category_Number]) REFERENCES [dbo].[Sponsorship_Category] ([Category_Number])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Has] WITH CHECK ADD CONSTRAINT [FK_HAS_CRITERIA]
FOREIGN KEY ([Criteria_Number]) REFERENCES [dbo].[Criteria] ([Criteria_Number])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Application] WITH CHECK ADD CONSTRAINT [FK_APPLICATION_APPLICANT]
FOREIGN KEY ([Applicant_ID]) REFERENCES [dbo].[Applicant] ([Applicant_ID])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Application] WITH CHECK ADD CONSTRAINT [FK_APPLICATION_SPONSORSHIP_CATEGORY]
FOREIGN KEY ([Category_Number]) REFERENCES [dbo].[Sponsorship_Category] ([Category_Number])
ON DELETE CASCADE ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[Document] WITH CHECK ADD CONSTRAINT [FK_DOCUMENT_APPLICATION]
FOREIGN KEY ([Application_ID]) REFERENCES [dbo].[Application] ([Application_ID])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Document] WITH CHECK ADD CONSTRAINT [FK_DOCUMENT_USER]
FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User] ([User_ID])
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[Change] WITH CHECK ADD CONSTRAINT [FK_CHANGE_USER]
FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User] ([User_ID])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Change] WITH CHECK ADD CONSTRAINT [FK_CHANGE_APPLICATION]
FOREIGN KEY ([Application_ID]) REFERENCES [dbo].[Application] ([Application_ID])
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[Vehicle] WITH CHECK ADD CONSTRAINT [FK_VEHICLE_DOCUMENT]
FOREIGN KEY ([Document_ID]) REFERENCES [dbo].[Document] ([Document_ID])
ON DELETE CASCADE ON UPDATE CASCADE
GO

--PRINT ALL CONSTRAINTS
SELECT 		OBJECT_NAME(OBJECT_ID) AS [Name of Constraint],
			OBJECT_NAME(parent_object_id) AS [Table Name],
			type_desc AS [Constraint Type]
FROM 		sys.objects
WHERE 		type_desc LIKE '%CONSTRAINT%'
			AND
			NOT OBJECT_NAME(parent_object_id)='sysdiagrams'
ORDER BY 	type_desc
