USE [master]
GO
/****** Object:  Database [TestDb]    Script Date: 10/2/2022 12:42:17 PM ******/
CREATE DATABASE [TestDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestDb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\TestDb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TestDb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\TestDb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [TestDb] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TestDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TestDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TestDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TestDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TestDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TestDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [TestDb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TestDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TestDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TestDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TestDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TestDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TestDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TestDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TestDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TestDb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TestDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TestDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TestDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TestDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TestDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TestDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TestDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TestDb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TestDb] SET  MULTI_USER 
GO
ALTER DATABASE [TestDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TestDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TestDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TestDb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TestDb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TestDb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'TestDb', N'ON'
GO
ALTER DATABASE [TestDb] SET QUERY_STORE = OFF
GO
USE [TestDb]
GO
/****** Object:  Table [dbo].[ProductVersion]    Script Date: 10/2/2022 12:42:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductVersion](
	[ID] [nchar](36) NOT NULL,
	[ProductID] [nchar](36) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatingDate] [datetime2](7) NOT NULL,
	[Width] [decimal](10, 2) NOT NULL,
	[Height] [decimal](10, 2) NOT NULL,
	[Length] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_ProductVersion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetAllVersions]    Script Date: 10/2/2022 12:42:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetAllVersions] 
(	
	@productID nchar(36)
)
RETURNS TABLE
AS
RETURN 
(
	SELECT *, (Width * Height * Length) as Volume FROM [TestDb].[dbo].[ProductVersion] v
	WHERE v.ProductID = @productID
)
GO
/****** Object:  Table [dbo].[Product]    Script Date: 10/2/2022 12:42:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ID] [nchar](36) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FindVersion]    Script Date: 10/2/2022 12:42:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[FindVersion] 
(	
	-- Add the parameters for the function here
	@product_name nvarchar(255), 
	@product_version nvarchar(255), 
	@min_volume decimal(10,2), 
	@max_volume decimal(10,2)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT v.ID, p.Name as 'Product Name', v.Name as 'Version Name', v.Width, v.Length, v.Height
  FROM [TestDb].[dbo].[Product] p
  OUTER APPLY [dbo].GetAllVersions(p.ID) v
  WHERE (@product_name is null OR p.Name like '%' + @product_name + '%') AND
		(@product_version is null OR v.Name like '%' + @product_version + '%') AND
		(@min_volume is null OR v.Volume >= @min_volume) AND
		(@max_volume is null OR v.Volume <= @max_volume)
)
GO
/****** Object:  Table [dbo].[EventLog]    Script Date: 10/2/2022 12:42:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLog](
	[ID] [nchar](36) NOT NULL,
	[EventDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'0555C5E3-4D8B-4D38-B167-CD49C5287B14', CAST(N'2022-10-01T07:19:55.1033333' AS DateTime2), N'Action: D; ProductID: 7538A4E6-934E-4CBD-AFC7-5516A84895F2')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'0DBC6642-B76D-4FDE-B92D-0EBF45AF552D', CAST(N'2022-10-02T12:35:50.9866667' AS DateTime2), N'Action: D; ProductVersionID: 52be40ff-b519-40f1-9b35-35d57bddf9ce')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'148BFA29-E779-42EB-B4EE-223280569BD2', CAST(N'2022-10-02T12:39:17.9333333' AS DateTime2), N'Action: I; ProductVersionID: ed5ff1f6-3fd4-4476-acec-bcd774aa4a4e')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'15E4819A-1C65-4437-BE24-C9749D60E8B3', CAST(N'2022-10-02T11:55:02.9533333' AS DateTime2), N'Action: I; ProductID: 97ee871f-aa67-4e00-8956-c8055407fd25')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'188E5AAC-9DDB-4D0E-A207-C49BB516628D', CAST(N'2022-10-02T12:39:38.3733333' AS DateTime2), N'Action: D; ProductVersionID: ed5ff1f6-3fd4-4476-acec-bcd774aa4a4e')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'1B632ACD-F358-4533-B962-D738DA6C6F10', CAST(N'2022-10-01T08:13:42.6933333' AS DateTime2), N'Action: I; ProductVersionID: CA49A4AB-55FB-43EF-9DCC-81035332323E')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'1DF5DEC1-1562-4A8B-B3A9-1F6A9DED63A4', CAST(N'2022-10-02T12:38:48.6500000' AS DateTime2), N'Action: I; ProductVersionID: da891369-0a3c-41f5-a35b-a04c24df9530')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'1E804409-C8A4-4F31-8293-90FFD8FD7CB3', CAST(N'2022-10-02T12:36:07.4033333' AS DateTime2), N'Action: I; ProductVersionID: ed5ff1f6-3fd4-4476-acec-bcd774aa4a4e')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'24CF5BC8-30A0-45A4-AFE4-ECA725B5005B', CAST(N'2022-10-02T12:38:48.5633333' AS DateTime2), N'Action: D; ProductID: fc4c1c93-387e-4793-b2ac-2d85905c9729')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'25169FE6-5CDE-49EA-A9CB-6DEF629F5D8A', CAST(N'2022-10-01T07:19:39.8833333' AS DateTime2), N'Action: I; ProductID: 483A67E7-9A00-4F7C-99E8-75FD90ECB0DF')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'37CFD8CF-41DA-428D-87EA-B6537576D5D0', CAST(N'2022-10-01T07:22:02.9633333' AS DateTime2), N'Action: D; ProductVersionID: 628BE8DC-A89B-4D77-B48E-9415451EB95C')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'425F9B82-B0E3-44D3-92D5-4FD6AA0AD005', CAST(N'2022-10-02T12:39:17.9100000' AS DateTime2), N'Action: D; ProductVersionID: ed5ff1f6-3fd4-4476-acec-bcd774aa4a4e')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'43DF8AE5-6D34-4140-800B-D5DD449A1B0D', CAST(N'2022-10-01T07:22:02.9633333' AS DateTime2), N'Action: D; ProductVersionID: E937B8D7-E10C-40CE-AF32-218A63D00B09')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'452D70F2-D60D-4386-93DA-1868EE8F25BD', CAST(N'2022-10-02T12:39:55.7333333' AS DateTime2), N'Action: D; ProductID: fc4c1c93-387e-4793-b2ac-2d85905c9729')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'4FA93474-6A6A-4121-8E33-6DE02174710A', CAST(N'2022-10-01T07:22:02.9666667' AS DateTime2), N'Action: D; ProductID: 34BE8ACF-B2A6-4713-BB0C-EB7E7301A00D')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'52A8DEDD-D501-4742-9A80-5278E169CC07', CAST(N'2022-10-01T08:13:53.8400000' AS DateTime2), N'Action: I; ProductVersionID: 14DFC9BB-D9FA-4914-A5FB-585F3E5BCB6D')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'5A2C2DCE-BA37-4A4D-822E-7ECD7B94AE07', CAST(N'2022-10-02T12:36:07.3966667' AS DateTime2), N'Action: I; ProductID: fc4c1c93-387e-4793-b2ac-2d85905c9729')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'5DD1ADC4-D30A-448F-8676-05F56897D251', CAST(N'2022-10-02T11:55:02.9866667' AS DateTime2), N'Action: I; ProductVersionID: 52be40ff-b519-40f1-9b35-35d57bddf9ce')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'6676656B-B87F-4AC9-AFAF-7DB0B99DE1A7', CAST(N'2022-10-02T12:40:08.4800000' AS DateTime2), N'Action: I; ProductVersionID: 54043014-424b-44e2-8eb7-793be265ba0a')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'73570467-A1E9-489E-A32A-0E9C9494274A', CAST(N'2022-10-01T07:22:02.9633333' AS DateTime2), N'Action: D; ProductVersionID: EF188C32-56DB-486A-864A-B3DB409E4B66')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'7524900E-3B06-441D-A921-10EDAD2679D3', CAST(N'2022-10-02T12:34:46.5633333' AS DateTime2), N'Action: D; ProductVersionID: 52be40ff-b519-40f1-9b35-35d57bddf9ce')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'7DE10EFB-8F2B-4A64-968C-E66680002BFA', CAST(N'2022-10-02T12:07:32.4100000' AS DateTime2), N'Action: U; ProductID: 97ee871f-aa67-4e00-8956-c8055407fd25')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'7F097E12-FBD8-4086-B8B7-CE9A723034B4', CAST(N'2022-10-02T12:34:46.6633333' AS DateTime2), N'Action: I; ProductVersionID: 52be40ff-b519-40f1-9b35-35d57bddf9ce')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'8E45B44F-2ED1-4D0D-A312-94B780171851', CAST(N'2022-10-01T07:21:10.1833333' AS DateTime2), N'Action: I; ProductVersionID: EF188C32-56DB-486A-864A-B3DB409E4B66')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'91FFFAB4-70E6-4D88-904F-453B57CF5B9E', CAST(N'2022-10-01T07:21:15.6600000' AS DateTime2), N'Action: I; ProductVersionID: DB40938E-17E6-486D-8ACC-47B6C0F1BDAC')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'95638372-94C6-4583-9771-7828854E8372', CAST(N'2022-10-01T07:19:51.4600000' AS DateTime2), N'Action: U; ProductID: 0F4DA1DC-3B09-4527-B8CE-38D9839F93B8')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'9F28E253-746F-4CFD-A058-79C6A015E91B', CAST(N'2022-10-01T08:12:27.2300000' AS DateTime2), N'Action: I; ProductVersionID: B4069477-4F3A-4F14-ADB3-07B86D80033A')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'B665B4F0-8D9E-407B-946F-FFAF352B9764', CAST(N'2022-10-02T12:34:46.5633333' AS DateTime2), N'Action: D; ProductID: 97ee871f-aa67-4e00-8956-c8055407fd25')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'BC254399-82B2-41CB-93C3-495D6778B5ED', CAST(N'2022-10-02T12:39:38.3800000' AS DateTime2), N'Action: I; ProductID: fc4c1c93-387e-4793-b2ac-2d85905c9729')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'BD2A07DB-6E54-45E9-9E89-B7FD6DC8DE5C', CAST(N'2022-10-02T12:39:17.9233333' AS DateTime2), N'Action: D; ProductID: fc4c1c93-387e-4793-b2ac-2d85905c9729')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'C022F4AB-E53D-4E86-AAD4-E725F51F2DC8', CAST(N'2022-10-02T12:40:08.4733333' AS DateTime2), N'Action: I; ProductID: 80a21d9a-aa4c-435f-9451-daf92931b2fc')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'C292F7BC-7765-41E3-8511-AE4BC3B445E0', CAST(N'2022-10-02T12:38:48.5600000' AS DateTime2), N'Action: D; ProductVersionID: ed5ff1f6-3fd4-4476-acec-bcd774aa4a4e')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'C3E1A39A-D6AE-4539-8479-68B651551D50', CAST(N'2022-10-02T12:35:50.9900000' AS DateTime2), N'Action: D; ProductID: 97ee871f-aa67-4e00-8956-c8055407fd25')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'C7F0A702-DF6F-4742-9D9A-D9D27AC7E910', CAST(N'2022-10-02T12:38:48.6400000' AS DateTime2), N'Action: I; ProductID: fc4c1c93-387e-4793-b2ac-2d85905c9729')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'CC761623-0E4D-4A69-8617-B333D3F9DE51', CAST(N'2022-10-01T08:12:39.5633333' AS DateTime2), N'Action: I; ProductVersionID: 381F4F65-8044-4096-9FB1-937D6B8BFA2D')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'D2F3C78A-FE5D-4F74-BF74-4AE62F9135E0', CAST(N'2022-10-02T12:38:48.6533333' AS DateTime2), N'Action: I; ProductVersionID: ed5ff1f6-3fd4-4476-acec-bcd774aa4a4e')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'D5F052D2-B8F5-41A8-92EF-61ECA7A9EE5C', CAST(N'2022-10-01T07:22:02.9633333' AS DateTime2), N'Action: D; ProductVersionID: DB40938E-17E6-486D-8ACC-47B6C0F1BDAC')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'DF4E2973-4E06-4864-BA31-10139F15B438', CAST(N'2022-10-02T12:39:38.3766667' AS DateTime2), N'Action: D; ProductID: fc4c1c93-387e-4793-b2ac-2d85905c9729')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'EB60AFCE-348C-45F3-95C3-4646A0C1C303', CAST(N'2022-10-02T12:39:17.9300000' AS DateTime2), N'Action: I; ProductID: fc4c1c93-387e-4793-b2ac-2d85905c9729')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'F55C62A5-F19D-4B58-A6A8-E5272D3B9DF3', CAST(N'2022-10-01T07:21:12.8000000' AS DateTime2), N'Action: I; ProductVersionID: E937B8D7-E10C-40CE-AF32-218A63D00B09')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'F75F7E8B-079E-4468-AF28-3ADB22C74274', CAST(N'2022-10-02T12:39:17.9100000' AS DateTime2), N'Action: D; ProductVersionID: da891369-0a3c-41f5-a35b-a04c24df9530')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'F84D1F22-2739-4604-8E80-ECE96D873CD9', CAST(N'2022-10-01T07:21:06.0000000' AS DateTime2), N'Action: I; ProductVersionID: 628BE8DC-A89B-4D77-B48E-9415451EB95C')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'F89BC432-451F-4F34-8540-D55665069B3D', CAST(N'2022-10-02T12:34:46.6566667' AS DateTime2), N'Action: I; ProductID: 97ee871f-aa67-4e00-8956-c8055407fd25')
GO
INSERT [dbo].[EventLog] ([ID], [EventDate], [Description]) VALUES (N'FA8A94F7-4CFC-4D37-8D09-79AAB3460B10', CAST(N'2022-10-02T10:15:40.0433333' AS DateTime2), N'Action: D; ProductID: 12345678-1234-1234-1234-183450789abc')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'05CE0723-79A0-4656-8639-C1F2164D7957', N'testsd', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'0BD93B03-18DC-4BC4-8F79-27552431C89F', N't0876876d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'0F4DA1DC-3B09-4527-B8CE-38D9839F93B8', N'testssd', N'kytryhsfgfdsg')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'1EF8FCA2-C6CE-4CDB-B897-9F1700DE689A', N't789df5dfg480909876556d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'45651E26-F506-4EA1-986E-92C122E5E673', N't096d', N'klhghghfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'483A67E7-9A00-4F7C-99E8-75FD90ECB0DF', N'k876gdfrt', N'sdfgsdfg')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'4ECF8F33-92B1-49FD-B308-242782F9622C', N't12356d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'517D8B11-D885-4959-8281-77C27912DF11', N'kl8lgdfrt', N'sdfgsdfg')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'74BECE98-5847-4B2C-93DA-5503DD0820E0', N't744480909876556d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'80a21d9a-aa4c-435f-9451-daf92931b2fc', N'string', N'string')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'81A3904A-9128-498E-A305-727C360FF17A', N't789456d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'8A89F0EC-6D79-46F2-9DBD-83866C56EF61', N't789480956d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'8F07D657-70BB-4736-893C-886F2652103E', N't789dfdfg480956d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'8FA1E5A6-3884-442D-978F-D91E7AA38281', N't789dfdfg480909876556d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'9202AFBD-7135-4255-8F74-4B463F5BA0C6', N'te700sfd', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'A201E13D-A6E3-4FBC-8892-818141BD1663', N't9907d', N'sfhgfdfdsdg')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'A6657231-3DB8-461E-972D-3159C629B353', N'te78fd', N'jkjgfdjghjfhg')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'C17A01DB-A9E5-4849-A2FA-D978A72652EF', N'tes65ssfd', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'DB5C5899-9695-487E-BD5C-02798F6708F9', N't888fd', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'E4DE822F-1BED-4D0A-B65B-9C5B5573B5A3', N't7976556d', N'ghgdfgjkfgdfd')
GO
INSERT [dbo].[Product] ([ID], [Name], [Description]) VALUES (N'EB8ED9E4-D301-430D-9062-46F00F5E82E4', N'tesftssd', N'hgdhfd')
GO
INSERT [dbo].[ProductVersion] ([ID], [ProductID], [Name], [Description], [CreatingDate], [Width], [Height], [Length]) VALUES (N'14DFC9BB-D9FA-4914-A5FB-585F3E5BCB6D', N'8FA1E5A6-3884-442D-978F-D91E7AA38281', N'testa98fs', N'gshgdfsafgf', CAST(N'2022-10-01T07:19:55.1033333' AS DateTime2), CAST(2.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[ProductVersion] ([ID], [ProductID], [Name], [Description], [CreatingDate], [Width], [Height], [Length]) VALUES (N'381F4F65-8044-4096-9FB1-937D6B8BFA2D', N'05CE0723-79A0-4656-8639-C1F2164D7957', N'testa98fs', N'gshgdfsafgf', CAST(N'2022-10-01T07:19:55.1033333' AS DateTime2), CAST(2.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[ProductVersion] ([ID], [ProductID], [Name], [Description], [CreatingDate], [Width], [Height], [Length]) VALUES (N'54043014-424b-44e2-8eb7-793be265ba0a', N'80a21d9a-aa4c-435f-9451-daf92931b2fc', N'string', N'string', CAST(N'2022-10-02T18:40:07.1290000' AS DateTime2), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[ProductVersion] ([ID], [ProductID], [Name], [Description], [CreatingDate], [Width], [Height], [Length]) VALUES (N'B4069477-4F3A-4F14-ADB3-07B86D80033A', N'05CE0723-79A0-4656-8639-C1F2164D7957', N'testasdfs', N'gshgdfsafgf', CAST(N'2022-10-01T07:19:55.1033333' AS DateTime2), CAST(1.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[ProductVersion] ([ID], [ProductID], [Name], [Description], [CreatingDate], [Width], [Height], [Length]) VALUES (N'CA49A4AB-55FB-43EF-9DCC-81035332323E', N'4ECF8F33-92B1-49FD-B308-242782F9622C', N'testa98fs', N'gshgdfsafgf', CAST(N'2022-10-01T07:19:55.1033333' AS DateTime2), CAST(2.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)))
GO
/****** Object:  Index [NonClusteredIndex-20221001-030811]    Script Date: 10/2/2022 12:42:17 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20221001-030811] ON [dbo].[EventLog]
(
	[EventDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex-20221001-015746]    Script Date: 10/2/2022 12:42:17 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20221001-015746] ON [dbo].[Product]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex-20221001-030354]    Script Date: 10/2/2022 12:42:17 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20221001-030354] ON [dbo].[ProductVersion]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20221001-030421]    Script Date: 10/2/2022 12:42:17 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20221001-030421] ON [dbo].[ProductVersion]
(
	[CreatingDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20221001-030438]    Script Date: 10/2/2022 12:42:17 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20221001-030438] ON [dbo].[ProductVersion]
(
	[Width] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20221001-030456]    Script Date: 10/2/2022 12:42:17 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20221001-030456] ON [dbo].[ProductVersion]
(
	[Height] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20221001-030505]    Script Date: 10/2/2022 12:42:17 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20221001-030505] ON [dbo].[ProductVersion]
(
	[Length] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventLog] ADD  CONSTRAINT [DF_EventLog_EventDate]  DEFAULT (getdate()) FOR [EventDate]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[ProductVersion] ADD  CONSTRAINT [DF_ProductVersion_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[ProductVersion]  WITH CHECK ADD  CONSTRAINT [FK_ProductVersion_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductVersion] CHECK CONSTRAINT [FK_ProductVersion_Product]
GO
/****** Object:  Trigger [dbo].[TR_Event_Audit_Product]    Script Date: 10/2/2022 12:42:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TR_Event_Audit_Product] 
   ON  [dbo].[Product] 
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[EventLog]
           ([ID]
           ,[EventDate]
           ,[Description])
     SELECT
           NEWID()
           ,GETDATE()
           ,'Action: ' + 
			CASE 
				WHEN ins.ID is not null AND del.ID is not null THEN 'U' 
				WHEN ins.ID is not null THEN 'I' 
				ELSE 'D' END + '; ProductID: ' +
			CASE 
				WHEN ins.ID is null THEN del.ID 
				ELSE ins.ID END
		FROM INSERTED ins
		full outer join deleted del on ins.ID = del.ID;
END;
GO
ALTER TABLE [dbo].[Product] ENABLE TRIGGER [TR_Event_Audit_Product]
GO
/****** Object:  Trigger [dbo].[TR_Event_Audit_ProductVersion]    Script Date: 10/2/2022 12:42:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_Event_Audit_ProductVersion] 
   ON  [dbo].[ProductVersion] 
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[EventLog]
           ([ID]
           ,[EventDate]
           ,[Description])
     SELECT
           NEWID()
           ,GETDATE()
           ,'Action: ' + 
			CASE 
				WHEN ins.ID is not null AND del.ID is not null THEN 'U' 
				WHEN ins.ID is not null THEN 'I' 
				ELSE 'D' END + '; ProductVersionID: ' +
			CASE 
				WHEN ins.ID is null THEN del.ID 
				ELSE ins.ID END
		FROM INSERTED ins
		full outer join deleted del on ins.ID = del.ID;
END;
GO
ALTER TABLE [dbo].[ProductVersion] ENABLE TRIGGER [TR_Event_Audit_ProductVersion]
GO
USE [master]
GO
ALTER DATABASE [TestDb] SET  READ_WRITE 
GO
