USE sysadmin
-- Raise an error if you run the whole script in error
RAISERROR ('Dont run it all at once',20,-1) WITH LOG

-- Check connections
SELECT nt_user_name,COUNT(*) AS 'count' FROM sys.dm_exec_sessions GROUP BY nt_user_name

-- Check sp_whoisactive_log
SELECT collection_time AS [Time], * FROM _dba.dbo.sp_whoisactive_log WHERE collection_time = (SELECT MAX(collection_time) FROM _dba.dbo.sp_whoisactive_log)

-- Vanilla sp_whoisactive
EXEC sp_whoisactive


-- What are our most expensive queries overall
EXEC sp_BlitzCache 
	@expertmode = 1 , 
	@top = 10, 
	@sortorder = 'xpm', -- Possible @sortorder values are: "CPU", "Reads", "Writes", "Duration", "Executions", "Recent Compilations", "Memory Grant", "Unused Grant", "Spills", "Query Hash". Additionally, the word "Average" or "Avg" can be used to sort on averages rather than total. "Executions per minute" and "Executions / minute" can be used to sort by execution per minute. For the truly lazy, "xpm" can also be used. 
	@ExportToExcel = 1

-- What's in the error log
EXEC sys.sp_readerrorlog 0, 1, 'failed'

-- Are we experiencing deadlocks
EXEC sp_BlitzLock


-- Deadlocks in last hour
DECLARE	@StartDateBlitz datetime = (SELECT DATEADD(HH,-1,GETDATE())),@EndDateBlitz DATETIME = (SELECT GETDATE())
EXEC sp_BlitzLock @EndDate = @EndDateBlitz, @StartDate = @StartDateBlitz 
GO
-- Deadlocks in previous Hour
DECLARE	@StartDateBlitz datetime = (SELECT DATEADD(HH,-2,GETDATE())),@EndDateBlitz DATETIME = (SELECT DATEADD(HH,-1,GETDATE()))
EXEC sp_BlitzLock @EndDate = @EndDateBlitz, @StartDate = @StartDateBlitz -- Previous hour



-- More info
/* Potentially run sp_whoisative with some or all of these parameters
EXEC sp_Whoisactive
	@get_task_info = 2,
	@get_additional_info = 1,
	@find_block_leaders = 1,
	@get_plans = 1,
	@get_full_inner_text = 1,
	@get_outer_command = 1,
	@sort_order = '[blocked_session_count] DESC';
*/