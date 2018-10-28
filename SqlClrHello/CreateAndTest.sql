-- One-time setup of the engine
USE [master];
sp_configure 'clr_enabled', 1
GO
RECONFIGURE
GO
ALTER DATABASE Northwnd
	SET TRUSTWORTHY ON
GO

-- Register the assembly and the methods

-- To get the hash, execute this in PowerShell:
-- (Get-FileHash -Path .\HelloClr.dll -Algorithm SHA512).Hash
EXEC sp_drop_trusted_assembly 0x5B8461407C3C68A92603F8C1121FCCDC90A46F53618B05A6959562308A8FC986D01D0D0F2A1360F125118764541B023C59583CAA610D428AAD296B37DEF1BEAA
EXEC sp_add_trusted_assembly 0x14214FA9EBA3070B6FE00B5A2A4F2CB1C21B05F83BEF3EEC56E5A7078EC19E6A3D3EFF6B52EE1C60658ED424222171E9DD5A6E94A8ED2B9EA56DF554C8F92578

DROP FUNCTION dbo.GetHello
DROP PROCEDURE dbo.GetProducts
DROP PROCEDURE dbo.GetRandom
DROP FUNCTION dbo.ReadFile
DROP AGGREGATE dbo.Concatenate
DROP ASSEMBLY UdfLib

CREATE ASSEMBLY UdfLib
	FROM 'C:\Projects\Experiments\SqlClrHello\HelloClr.dll'
	WITH PERMISSION_SET = EXTERNAL_ACCESS
GO

CREATE FUNCTION GetHello()
	RETURNS NVARCHAR(MAX)
	EXTERNAL NAME UdfLib.HelloClr.GetHello
GO

SELECT dbo.GetHello()
GO

CREATE PROCEDURE GetProducts
AS
	EXTERNAL NAME UdfLib.HelloClr.GetProducts
GO

EXEC dbo.GetProducts
GO

CREATE PROCEDURE dbo.GetRandom @count INT
AS
	EXTERNAL NAME UdfLib.HelloClr.GetRandom
GO

EXEC dbo.GetRandom 5
GO

CREATE FUNCTION dbo.ReadFile(@fileName NVARCHAR(128))
	RETURNS NVARCHAR(MAX)
	EXTERNAL NAME UdfLib.HelloClr.ReadFile
GO

SELECT dbo.ReadFile('C:\Projects\Experiments\SqlClrHello\CreateAndTest.sql')
GO

CREATE AGGREGATE dbo.Concatenate(@value NVARCHAR(MAX))
	RETURNS NVARCHAR(MAX)
	EXTERNAL NAME UdfLib.Concatenate
GO

SELECT dbo.Concatenate(ProductName) FROM Products WHERE CategoryID = 4
GO
