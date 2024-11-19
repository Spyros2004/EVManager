/****** Object:  Table [dbo].[Employees]    Script Date: 22/10/2021 07:14:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Company] [nvarchar](50) NULL,
	[Last Name] [nvarchar](50) NULL,
	[First Name] [nvarchar](50) NULL,
	[E-mail Address] [nvarchar](50) NULL,
	[Job Title] [nvarchar](50) NULL,
	[Business Phone] [nvarchar](25) NULL,
	[Home Phone] [nvarchar](25) NULL,
	[Mobile Phone] [nvarchar](25) NULL,
	[Fax Number] [nvarchar](25) NULL,
	[Address] [ntext] NULL,
	[City] [nvarchar](50) NULL,
	[State/Province] [nvarchar](50) NULL,
	[ZIP/Postal Code] [nvarchar](15) NULL,
	[Country/Region] [nvarchar](50) NULL,
	[Web Page] [ntext] NULL,
	[Notes] [ntext] NULL,
	[Attachments] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (1, N'Northwind Traders', N'Freehafer', N'Nancy', N'nancy@northwindtraders.com', N'Sales Representative', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 1st Avenue', N'Seattle', N'WA', N'99999', N'USA', N'#http://northwindtraders.com#', NULL, NULL)
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (2, N'Northwind Traders', N'Cencini', N'Andrew', N'andrew@northwindtraders.com', N'Vice President, Sales', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 2nd Avenue', N'Bellevue', N'WA', N'99999', N'USA', N'http://northwindtraders.com#http://northwindtraders.com/#', N'Joined the company as a sales representative, was promoted to sales manager and was then named vice president of sales.', NULL)
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (3, N'Northwind Traders', N'Kotas', N'Jan', N'jan@northwindtraders.com', N'Sales Representative', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 3rd Avenue', N'Redmond', N'WA', N'99999', N'USA', N'http://northwindtraders.com#http://northwindtraders.com/#', N'Was hired as a sales associate and was promoted to sales representative.', NULL)
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (4, N'Northwind Traders', N'Sergienko', N'Mariya', N'mariya@northwindtraders.com', N'Sales Representative', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 4th Avenue', N'Kirkland', N'WA', N'99999', N'USA', N'http://northwindtraders.com#http://northwindtraders.com/#', NULL, NULL)
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (5, N'Northwind Traders', N'Thorpe', N'Steven', N'steven@northwindtraders.com', N'Sales Manager', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 5th Avenue', N'Seattle', N'WA', N'99999', N'USA', N'http://northwindtraders.com#http://northwindtraders.com/#', N'Joined the company as a sales representative and was promoted to sales manager.  Fluent in French.', NULL)
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (6, N'Northwind Traders', N'Neipper', N'Michael', N'michael@northwindtraders.com', N'Sales Representative', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 6th Avenue', N'Redmond', N'WA', N'99999', N'USA', N'http://northwindtraders.com#http://northwindtraders.com/#', N'Fluent in Japanese and can read and write French, Portuguese, and Spanish.', NULL)
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (7, N'Northwind Traders', N'Zare', N'Robert', N'robert@northwindtraders.com', N'Sales Representative', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 7th Avenue', N'Seattle', N'WA', N'99999', N'USA', N'http://northwindtraders.com#http://northwindtraders.com/#', NULL, NULL)
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (8, N'Northwind Traders', N'Giussani', N'Laura', N'laura@northwindtraders.com', N'Sales Coordinator', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 8th Avenue', N'Redmond', N'WA', N'99999', N'USA', N'http://northwindtraders.com#http://northwindtraders.com/#', N'Reads and writes French.', NULL)
GO
INSERT [dbo].[Employees] ([ID], [Company], [Last Name], [First Name], [E-mail Address], [Job Title], [Business Phone], [Home Phone], [Mobile Phone], [Fax Number], [Address], [City], [State/Province], [ZIP/Postal Code], [Country/Region], [Web Page], [Notes], [Attachments]) VALUES (9, N'Northwind Traders', N'Hellung-Larsen', N'Anne', N'anne@northwindtraders.com', N'Sales Representative', N'(123)555-0100', N'(123)555-0102', NULL, N'(123)555-0103', N'123 9th Avenue', N'Seattle', N'WA', N'99999', N'USA', N'http://northwindtraders.com#http://northwindtraders.com/#', N'Fluent in French and German.', NULL)
GO
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
/****** Object:  Index [aaaaaEmployees_PK]    Script Date: 22/10/2021 07:14:11 ******/
ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [aaaaaEmployees_PK] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[EmployeesFromCity]    Script Date: 22/10/2021 07:14:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EmployeesFromCity] (@cityName CHAR(50)=NULL) 
ASBEGIN    
	SELECT	[ID], [Last Name], [First Name], [E-mail Address], [Job Title], [City]
	FROM	Employees
	WHERE	City = ISNULL(@cityName,City)
	ORDER BY [Last Name], [First Name]
END
GO
