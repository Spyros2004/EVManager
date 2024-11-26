/*USE COMPANY --name of your database
GO*/

SET ANSI_NULLS ON
GO

--CREATE TABLES
CREATE TABLE [dbo].[User]
(
    [User_ID] INT NOT NULL IDENTITY(1,1), 
    [First_Name] NVARCHAR(50) NOT NULL, 
    [Last_Name] NVARCHAR(50) NOT NULL, 
    [Username] VARCHAR(50) NOT NULL, 
    [Email] VARCHAR(100) NOT NULL, 
    [Password] VARBINARY(512) NOT NULL, 
    [User_Type] VARCHAR(20) NOT NULL CHECK ([User_Type] IN ('Admin', 'TOM', 'AA', 'Applicant')), 
    [Status] VARCHAR(20) NOT NULL CHECK ([Status] IN ('pending', 'approved', 'suspended', 'deactivated', 'rejected')), 
    UNIQUE ([Username]),
    UNIQUE ([Email]),
    CONSTRAINT [PK_USER] PRIMARY KEY ([User_ID] ASC)
)

CREATE TABLE [dbo].[Sponsorship_Category]
(
    [Category_Number] INT NOT NULL IDENTITY(1,1),
    [Description] NVARCHAR(255) NOT NULL, 
    [Amount] DECIMAL(15, 2) NOT NULL CHECK ([Amount] > 0), 
    [Total_Positions] INT NOT NULL CHECK ([Total_Positions] > 0), 
    [Remaining_Positions] INT NOT NULL,
    CONSTRAINT [PK_SPONSORSHIP_CATEGORY] PRIMARY KEY ([Category_Number] ASC)
)

CREATE TABLE [dbo].[Applicant]
(
    [Applicant_ID] INT NOT NULL IDENTITY(1,1), 
    [Identification] VARCHAR(20) NOT NULL,
    [Company_Private] VARCHAR(20) NOT NULL CHECK ([Company_Private] IN ('company', 'private')),
    [Gender] CHAR(1) NOT NULL CHECK ([Gender] IN ('M', 'F', 'O')),
    [BirthDate] DATE NOT NULL,
    [User_ID] INT NOT NULL,
    UNIQUE([Identification]),
    CONSTRAINT [PK_APPLICANT] PRIMARY KEY ([Applicant_ID] ASC)
)

CREATE TABLE [dbo].[Criterion]
(
    [Criterion_Number] INT NOT NULL IDENTITY(1,1),
    [Title] NVARCHAR(255) NOT NULL,
    [Description] NVARCHAR(255) NOT NULL,
    UNIQUE ([Title]),
    CONSTRAINT [PK_CRITERIA] PRIMARY KEY ([Criterion_Number] ASC)
)

CREATE TABLE [dbo].[CategoryHasCriterion]
(
    [Category_Number] INT NOT NULL,
    [Criterion_Number] INT NOT NULL, 
    CONSTRAINT [PK_HAS] PRIMARY KEY ([Category_Number], [Criterion_Number] ASC)
)

CREATE TABLE [dbo].[Application]
(
    [Application_ID] INT NOT NULL IDENTITY(1,1),
    [Application_Date] DATE NOT NULL DEFAULT GETDATE(),
    [Discarder_Car_LPN] CHAR(6), 
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
    [Reason] NVARCHAR(255) NOT NULL,
    [Application_ID] INT NOT NULL,
    [User_ID] INT NOT NULL,
    UNIQUE ([URL]),
    CONSTRAINT [PK_DOCUMENT] PRIMARY KEY ([Document_ID] ASC)
)

CREATE TABLE [dbo].[Modification]
(
    [Modification_ID] INT NOT NULL IDENTITY(1,1),
    [Modification_Date] DATE NOT NULL DEFAULT GETDATE(),
    [New_Status] VARCHAR(20) NOT NULL CHECK ([New_Status] IN ('approved', 'rejected', 'under_review')),
    [Reason] NVARCHAR(255) NOT NULL, 
    [User_ID] INT NOT NULL,
    [Application_ID] INT NOT NULL,
    CONSTRAINT [PK_CHANGE] PRIMARY KEY ([Modification_ID] ASC)
)

CREATE TABLE [dbo].[Vehicle]
(
    [Vehicle_ID] INT NOT NULL IDENTITY(1,1), 
    [Vehicle_Date] DATE NOT NULL,
    [Vehicle_Type] VARCHAR(20) NOT NULL CHECK ([Vehicle_Type] IN ('electric', 'hybrid')), 
    [CO2_Emissions] INT NOT NULL CHECK ([CO2_Emissions] <= 50), 
    [Manufacturer] VARCHAR(50) NOT NULL, 
    [Price] DECIMAL(15, 2) NOT NULL CHECK ([Price] <= 80000), 
    [Engine_Fuel] VARCHAR(20) NOT NULL CHECK ([Engine_Fuel] IN ('diesel', 'petrol','electricity')), 
    [Document_ID] INT NOT NULL,
    CONSTRAINT [PK_VEHICLE] PRIMARY KEY ([Vehicle_ID] ASC)
)

CREATE TABLE [dbo].[User_Session]
(
    [Session_ID] INT NOT NULL IDENTITY(1,1),
    [User_ID] INT NOT NULL,
    [Session_Token] VARCHAR(255) NOT NULL,
    [Login_Time] DATETIME NOT NULL DEFAULT GETDATE(),
    UNIQUE([Session_Token]),
    CONSTRAINT [PK_USER_SESSION] PRIMARY KEY ([Session_ID] ASC)
)

--CREATE FOREIGN KEY CONSTRAINTS
ALTER TABLE [dbo].[Applicant] WITH CHECK ADD CONSTRAINT [FK_APPLICANT_USER]
FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User] ([User_ID])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[CategoryHasCriterion] WITH CHECK ADD CONSTRAINT [FK_HAS_SPONSORSHIP_CATEGORY]
FOREIGN KEY ([Category_Number]) REFERENCES [dbo].[Sponsorship_Category] ([Category_Number])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[CategoryHasCriterion] WITH CHECK ADD CONSTRAINT [FK_HAS_CRITERIA]
FOREIGN KEY ([Criterion_Number]) REFERENCES [dbo].[Criterion] ([Criterion_Number])
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

ALTER TABLE [dbo].[Modification] WITH CHECK ADD CONSTRAINT [FK_MODIFICATION_USER]
FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User] ([User_ID])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Modification] WITH CHECK ADD CONSTRAINT [FK_MODIFICATION_APPLICATION]
FOREIGN KEY ([Application_ID]) REFERENCES [dbo].[Application] ([Application_ID])
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[Vehicle] WITH CHECK ADD CONSTRAINT [FK_VEHICLE_DOCUMENT]
FOREIGN KEY ([Document_ID]) REFERENCES [dbo].[Document] ([Document_ID])
ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[User_Session] WITH CHECK ADD CONSTRAINT [FK_USER_SESSION_USER]
FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User] ([User_ID]) 
ON DELETE CASCADE ON UPDATE CASCADE;
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
