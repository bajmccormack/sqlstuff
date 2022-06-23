-- Create table if not exists
IF NOT EXISTS ( SELECT 1 FROM _dba.sys.tables WHERE NAME = 'sp_whoisactive_log')
BEGIN
CREATE TABLE _dba.dbo.sp_whoisactive_log
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	[dd hh:mm:ss:mss] VARCHAR(15) NULL,
	session_id SMALLINT NOT NULL,
	sql_text XML NULL,
	login_name sysname NULL,
	wait_info NVARCHAR(4000) NULL,
	CPU VARCHAR(30) NULL,
	tempdb_allocations VARCHAR(30) NULL,
	tempdb_current VARCHAR(30) NULL,
	blocking_session_id SMALLINT NULL,
	blocked_session_count VARCHAR(30) NULL,
	reads VARCHAR(30) NULL,
	writes VARCHAR(30) NULL,
	physical_reads VARCHAR(30) NULL,
	query_plan XML NULL,
	locks XML NULL,
	used_memory VARCHAR(30) NULL,
	[status] VARCHAR(30) NULL,
	open_tran_count VARCHAR(30) NULL,
	percent_complete VARCHAR(30) NULL,
	[host_name] sysname NULL,
	[database_name] sysname NULL,
	[program_name] sysname NULL,
	start_time datetime NULL,
	login_time datetime NULL,
	request_id SMALLINT NULL,
	collection_time datetime NULL
)
CREATE INDEX idx_collection_time ON _dba.dbo.sp_whoisactive_log (collection_time)
END

/*	Load data into table. 
	If you want to change parameters, you will likely need to add columns to table
*/	EXEC sp_whoisactive @get_locks = 1, @find_block_leaders = 1, @get_plans = 1, @destination_table = 'sp_whoisactive_log'


-- Step 2
SELECT DATEADD(MONTH,-1,GETDATE())
DELETE dbo.sp_whoisactive_log
WHERE collection_time < DATEADD(MONTH,-1,GETDATE())

/* SELECT query
SELECT collection_time
       [dd hh:mm:ss:mss],
       session_id,
       sql_text,
       login_name,
       wait_info,
       CPU,
       tempdb_allocations,
       tempdb_current,
       blocking_session_id,
       blocked_session_count,
       reads,
       writes,
       physical_reads,
       query_plan,
       locks,
       used_memory,
       status,
       open_tran_count,
       percent_complete,
       host_name,
       database_name,
       program_name,
       start_time,
       login_time,
       request_id
FROM _dba.dbo.sp_whoisactive_log
WHERE collection time = (SELECT MAX(collection_time) FROM _dba.dbo.sp_whoisactive_log)
ORDER BY collection_time DESC, id ASC
*/