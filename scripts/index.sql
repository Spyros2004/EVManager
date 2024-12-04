--CREATE THE INDEXES
CREATE UNIQUE NONCLUSTERED INDEX IX_Application_TrackingNumber ON Application (Tracking_Number);
GO

CREATE INDEX IX_Application_Status_Category ON Application (Current_Status, Category_Number);
GO

CREATE INDEX IX_Application_ApplicationDate ON Application (Application_Date);
GO

CREATE INDEX IX_Applicant_UserID_CompanyPrivate ON Applicant (User_ID, Company_Private);
GO

CREATE INDEX IX_Application_Status_Date ON Application (Current_Status, Application_Date);
GO
