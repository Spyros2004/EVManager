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
