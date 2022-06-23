-- BEFORE REPLAY
SELECT @@VERSION
/*
    Comment section
*/
 
-- Declare variables
DECLARE
    @sqlserver_start_time DATETIME,
    @current_time DATETIME,
    @mins INT,
    @hours INT;
 
-- Set variables
SET @sqlserver_start_time = (SELECT sqlserver_start_time FROM sys.dm_os_sys_info); -- Needed to work when collection in dm_os_wait_stats started
SET @current_time = (SELECT SYSDATETIME());
SET @mins = (SELECT DATEDIFF(MINUTE,@sqlserver_start_time,@current_time));
SET @hours = (SELECT @mins/60 AS Integer); 
 
-- Uncomment PRINT statements for more info
 PRINT @sqlserver_start_time
 PRINT @current_time
 PRINT @mins
 PRINT @hours
 
SELECT TOP 100 
    wait_type,
    wait_time_ms,
    waiting_tasks_count,  
    waiting_tasks_count/@hours as waiting_tasks_count_PerHour, 
    waiting_tasks_count/@mins as waiting_tasks_count_PerMin,
    wait_time_ms/waiting_tasks_count AS avg_wait_time_ms,
    'https://www.sqlskills.com/help/waits/'+wait_type as help_url -- SQLSkills resource on waits. If web page not complete, find another source.
-- INTO _dba.dbo.tmp_waits_20190131
FROM sys.dm_os_wait_stats
ORDER BY wait_time_ms DESC -- Overall time spent waiting by wait type. (Could change to waiting_tasks_count DESC)

-- Specific wait occurences
SELECT * FROM sys.dm_os_wait_stats
WHERE wait_type = 'preemptive_hadr_lease_mechanism'
-- 14,310,035,562

