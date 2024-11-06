
** PREPEI NA DOUME TA ON UPDATE KAI ON DELETE KAI OPOU EVALA ASTERAKIA **


CREATE TABLE User
(
  User_ID INT NOT NULL AUTO_INCREMENT, 
  First_Name VARCHAR(50) NOT NULL, 
  Last_Name VARCHAR(50) NOT NULL, 
  Username VARCHAR(50) NOT NULL, 
  Email VARCHAR(100) NOT NULL, 
  Password VARCHAR(255) NOT NULL, 
  User_Type VARCHAR(20) NOT NULL CHECK (User_Type IN ('Admin', 'TOM', 'AA', 'User', 'Applicant')), 
  Status VARCHAR(20) NOT NULL CHECK (Status IN ('pending', 'approved', 'suspended', 'deactivated', 'rejected')), 
  UNIQUE (Username),
  UNIQUE (Email),
  PRIMARY KEY (User_ID)
);


CREATE TABLE Sponsorship_Category
(
  Category_Number INT NOT NULL AUTO_INCREMENT,
  Description VARCHAR(255) NOT NULL, 
  Amount DECIMAL(15, 2) NOT NULL CHECK (Amount > 0), 
  Total_Positions INT NOT NULL CHECK (Total_Positions > 0), 
  Remaining_Positions INT NOT NULL DEFAULT Total_Positions CHECK (Remaining_Positions <= Total_Positions),
  PRIMARY KEY (Category_Number)
);


CREATE TABLE Applicant
(
  Applicant_ID INT NOT NULL AUTO_INCREMENT, 
  Company_Private VARCHAR(20) NOT NULL CHECK (Company_Private IN ('company', 'private')),
  Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F', 'O')),
  BirthDate DATE NOT NULL,
  User_ID INT NOT NULL,
  PRIMARY KEY (Applicant_ID),
  FOREIGN KEY (User_ID) REFERENCES User(User_ID)
  ON DELETE CASCADE (ON UPDATE CASCADE) ****
);

CREATE TABLE Criteria
(
  Criteria_Number VARCHAR(10) NOT NULL,
  Title VARCHAR(255) NOT NULL,
  Description VARCHAR(255) NOT NULL,
  PRIMARY KEY (Criteria_Number), 
  UNIQUE (Title)
);


CREATE TABLE Has
(
  Category_Number INT NOT NULL,
  Criteria_Number VARCHAR(10) NOT NULL, 
  PRIMARY KEY (Category_Number, Criteria_Number),
  FOREIGN KEY (Category_Number) REFERENCES Sponsorship_Category(Category_Number)
  ON DELETE CASCADE ON UPDATE CASCADE, 
  FOREIGN KEY (Criteria_Number) REFERENCES Criteria(Criteria_Number)
  ON DELETE CASCADE ON UPDATE CASCADE 
);


CREATE TABLE Application
(
  Application_ID INT NOT NULL AUTO_INCREMENT,
  Application_Date DATE NOT NULL,
  Discarder_Car_LPN CHAR(6) NOT NULL, 
  Attempt INT NOT NULL DEFAULT 1,
  Current_Status VARCHAR(20) NOT NULL CHECK (Current_Status IN ('pending', 'approved', 'rejected', 'under_review', 'in_progress')), 
  Applicant_ID INT NOT NULL,
  Category_Number INT NOT NULL,
  UNIQUE (Discarder_Car_LPN),
  PRIMARY KEY (Application_ID),
  FOREIGN KEY (Applicant_ID) REFERENCES Applicant(Applicant_ID)
  ON DELETE CASCADE ON UPDATE CASCADE, 
  FOREIGN KEY (Category_Number) REFERENCES Sponsorship_Category(Category_Number)
  ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE Document
(
  Document_ID INT NOT NULL AUTO_INCREMENT,
  URL VARCHAR(255) NOT NULL, 
  Document_Type VARCHAR(50) NOT NULL CHECK (Document_Type IN ('type1', 'type2', 'type3')), ****
  Reason VARCHAR(255) NOT NULL,
  Application_ID INT NOT NULL,
  User_ID INT NOT NULL,
  UNIQUE (URL),
  PRIMARY KEY (Document_ID),
  FOREIGN KEY (Application_ID) REFERENCES Application(Application_ID)
  ON DELETE CASCADE ON UPDATE CASCADE, 
  FOREIGN KEY (User_ID) REFERENCES User(User_ID)
  ON DELETE CASCADE ON UPDATE CASCADE 
);


CREATE TABLE Change
(
  Log_ID INT NOT NULL AUTO_INCREMENT,
  Modification_Date DATE NOT NULL,
  New_Status VARCHAR(20) NOT NULL CHECK (New_Status IN ('approved', 'rejected', 'under_review')),***
  Reason VARCHAR(255) NOT NULL, 
  User_ID INT NOT NULL,
  Application_ID INT NOT NULL,
  PRIMARY KEY (Log_ID),
  FOREIGN KEY (User_ID) REFERENCES User(User_ID)
  ON DELETE CASCADE ON UPDATE CASCADE, 
  FOREIGN KEY (Application_ID) REFERENCES Application(Application_ID)
  ON DELETE CASCADE ON UPDATE CASCADE 

CREATE TABLE Vehicle
(
  Vehicle_ID INT NOT NULL AUTO_INCREMENT, 
  Vehicle_Year INT NOT NULL,
  Vehicle_Month INT NOT NULL CHECK (Vehicle_Month >= 1 AND Vehicle_Month <= 12), 
  Vehicle_Type VARCHAR(20) NOT NULL CHECK (Vehicle_Type IN ('electric', 'hybrid')), 
  CO2_Emissions INT NOT NULL CHECK (CO2_Emissions <= 50), 
  Brand VARCHAR(50) NOT NULL, 
  Price DECIMAL(15, 2) NOT NULL CHECK (Price <= 80000), 
  Engine_Fuel VARCHAR(10) NOT NULL CHECK (Engine_Fuel IN ('diesel', 'petrol')), 
  Document_ID INT NOT NULL,
  PRIMARY KEY (Vehicle_ID),
  FOREIGN KEY (Document_ID) REFERENCES Document(Document_ID)
  ON DELETE CASCADE ON UPDATE CASCADE 
);