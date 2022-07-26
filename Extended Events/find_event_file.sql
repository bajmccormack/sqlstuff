-- Find where you XE file is located

SELECT 
	s.name,
	CAST(st.target_data AS XML).value('(/EventFileTarget/File/@name)[1]','nvarchar(256)') AS target_data_file,
	CAST(st.target_data AS XML) AS target_data_xml
FROM sys.dm_xe_session_targets st
JOIN sys.dm_xe_sessions s
ON st.event_session_address = s.[address]
WHERE s.name = 'Custom XE Session Name' -- Optional if you know the name


-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-xe-session-targets-transact-sql?view=sql-server-2017




SELECT f.*
		--,CAST(f.event_data AS XML)  AS [Event-Data-Cast-To-XML]  -- Optional
	FROM
		sys.fn_xe_file_target_read_file(
			'P:\XE\PRD_DB_CalledStoredProcs_0_131987099400340000.xel',
			null, null, null)  AS f;