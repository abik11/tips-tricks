USE [master];
GO

-- Make DB offline
ALTER DATABASE dbName SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
ALTER DATABASE dbName SET OFFLINE

-- Change db files names
ALTER DATABASE dbName MODIFY FILE (Name='logicalFileName', FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\dbName_new_name.mdf')
GO
ALTER DATABASE dbName MODIFY FILE (Name='logicalFileName_log', FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\dbName_new_name_log.ldf')
GO

-- Change file name on the disk now (before it would be impossible)

-- Make DB online
ALTER DATABASE dbName SET ONLINE
GO
ALTER DATABASE dbName SET MULTI_USER
GO

-- Might be useful:
-- 1. Check db files names:
USE [dbName];
GO
SELECT file_id, name AS [logical_file_name], physical_name
FROM sys.database_files
-- 2. Check db status (on/offline):
SELECT name AS [Database_Name], State_desc FROM sys.databases
