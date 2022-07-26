-- Adapted (by John Mccormack) from Aaron Bertrand's script on https://www.mssqltips.com/sqlservertip/3636/query-data-from-extended-events-in-sql-server/

;with cte as
(
	SELECT event_data = CONVERT(XML, event_data) 
	FROM sys.fn_xe_file_target_read_file(N'Specific sp calls*.xel', NULL, NULL, NULL)
)

SELECT 
  [timestamp] = event_data.value(N'(event/@timestamp)[1]', N'datetime'),
  [duration] = event_data.value(N'(event/data[@name="duration"]/value)[1]', N'INT'),
  [client_hostname] = event_data.value(N'(event/action[@name="client_hostname"]/value)[1]', N'nvarchar(255)'),
  [client_app_name] = event_data.value(N'(event/action[@name="client_app_name"]/value)[1]', N'nvarchar(255)'),
  [sql] = event_data.value(N'(event/action[@name="sql_text"]/value)[1]', N'nvarchar(max)'),
  spid  = event_data.value(N'(event/action[@name="session_id"]/value)[1]', N'int')
FROM cte
WHERE
   event_data.value(N'(event/action[@name="client_hostname"]/value)[1]', N'nvarchar(255)') <> N'DBAJUMPBOX1'
