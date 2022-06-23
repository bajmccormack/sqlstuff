-- Check for uptime
DECLARE @crdate DATETIME, @hr VARCHAR(50), @min VARCHAR(5), @day VARCHAR(50)
SELECT @crdate=crdate FROM master.dbo.sysdatabases WHERE NAME='tempdb'
SELECT @hr=(DATEDIFF ( mi, @crdate,GETDATE()))/60
SELECT @day = CAST(@hr AS INT)/24
SELECT @hr = CAST(@hr AS INT)%24--CAST(@day AS INT)
IF ((DATEDIFF ( mi, @crdate,GETDATE()))/60)=0
SELECT @min=(DATEDIFF ( mi, @crdate,GETDATE()))
ELSE
SELECT @min=(DATEDIFF ( mi, @crdate,GETDATE()))-((DATEDIFF( mi, @crdate,GETDATE()))/60)*60
PRINT 'SQL Server "' + CONVERT(VARCHAR(20),SERVERPROPERTY('SERVERNAME'))+'" is Online for the past '+CASE WHEN CAST(@day AS INT) > 0 THEN @day + ' days, ' ELSE '' END+@hr+' hours & '+@min+' minutes' +  ' (since ' + CONVERT(VARCHAR(20), @crdate) + ')'
IF NOT EXISTS (SELECT 1 FROM master.dbo.sysprocesses WHERE program_name = N'SQLAgent - Generic Refresher')
BEGIN
PRINT 'SQL Server is running but SQL Server Agent <<NOT>> running'
END
ELSE BEGIN
PRINT 'SQL Server and SQL Server Agent both are running'
END
PRINT '"'+CONVERT(VARCHAR(20),SERVERPROPERTY('SERVERNAME'))+'" is running on node '+CONVERT(VARCHAR(20),SERVERPROPERTY('ComputerNamePhysicalNetBIOS'))


