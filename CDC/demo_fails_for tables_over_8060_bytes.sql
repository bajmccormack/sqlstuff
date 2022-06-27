USE JohnTest
-- ALTER DATABASE [JohnTest] SET CHANGE_TRACKING = ON 
DROP TABLE John 
DROP TABLE John2
TRUNCATE TABLE sysadmin..cdc_tables;
GO

CREATE TABLE John
(
	johnid int identity (1,1) PRIMARY KEY,
	johnname CHAR(4000),
	johninfo CHAR(4000),
	supplementalinfo NVARCHAR(MAX)
)

CREATE TABLE John2
(
	johnid int identity (1,1) PRIMARY KEY,
	johnname NCHAR(255),
	johninfo NCHAR(1000),
	supplementalinfo NVARCHAR(1000)
)


USE SysAdmin
EXEC sp_insert_cdc_table @instance_name = N'UKGLALPJN1B6H2',@database_name = N'JohnTest', @schema_name = N'dbo', @table_name = N'John'
EXEC sp_insert_cdc_table @instance_name = N'UKGLALPJN1B6H2',@database_name = N'JohnTest', @schema_name = N'dbo', @table_name = N'John2'

SELECT * FROM sysadmin..cdc_tables;

SELECT * FROM Johntest.dbo.John UNION ALL 
SELECT * FROM Johntest.dbo.John2

SELECT * FROM Johntest.cdc.dbo_John_CT UNION ALL
SELECT * FROM Johntest.cdc.dbo_John2_CT

INSERT INTO Johntest.dbo.John (johnname,johninfo,supplementalinfo) VALUES ('John','DBA','abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789@?><,.[]{}#~)(*&^^%$гм')
INSERT INTO Johntest.dbo.John2 (johnname,johninfo,supplementalinfo) VALUES ('John','DBA','abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789@?><,.[]{}#~)(*&^^%$гм')

SELECT * FROM Johntest.dbo.John UNION ALL 
SELECT * FROM Johntest.dbo.John2

SELECT * FROM Johntest.cdc.dbo_John_CT UNION ALL 
SELECT * FROM Johntest.cdc.dbo_John2_CT

UPDATE Johntest.dbo.John SET johninfo = 'Glasgow DBA'
UPDATE Johntest.dbo.John2 SET johninfo = 'Glasgow DBA'

UPDATE Johntest.dbo.John SET johninfo = 'DBA'
UPDATE Johntest.dbo.John2 SET johninfo = 'DBA'


SELECT * FROM Johntest.dbo.John UNION ALL 
SELECT * FROM Johntest.dbo.John2

SELECT * FROM Johntest.cdc.dbo_John_CT UNION ALL 
SELECT * FROM Johntest.cdc.dbo_John2_CT

-- Check column width
USE JohnTest
declare @table nvarchar(128)
declare @idcol nvarchar(128)
declare @sql nvarchar(max)

--initialize those two values
set @table = 'John'
set @idcol = 'JohnID'

set @sql = 'select ' + @idcol +' , (0'

select @sql = @sql + ' + isnull(datalength(' + name + '), 1)' 
        from  sys.columns 
        where object_id = object_id(@table)
        and   is_computed = 0
set @sql = @sql + ') as rowsize from ' + @table + ' order by rowsize desc'

PRINT @sql
exec (@sql)