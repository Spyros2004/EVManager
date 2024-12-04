--CREATE THE INDEXES
CREATE UNIQUE NONCLUSTERED INDEX IX_Application_TrackingNumber ON Application (Tracking_Number);

CREATE INDEX IX_Application_Status_Category ON Application (Current_Status, Category_Number);

CREATE INDEX IX_Application_ApplicationDate ON Application (Application_Date);

CREATE INDEX IX_Applicant_UserID_CompanyPrivate ON Applicant (User_ID, Company_Private);

CREATE INDEX IX_Application_Status_Date ON Application (Current_Status, Application_Date);
