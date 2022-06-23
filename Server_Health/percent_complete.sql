SELECT percent_complete pc,
       DATEDIFF(SECOND, start_time, GETDATE()) AS secs,
	   DATEDIFF(SECOND, start_time, GETDATE())/(percent_complete/100) -  DATEDIFF(SECOND, start_time, GETDATE())  AS secs_remaining,
       DATEADD(SECOND,DATEDIFF(SECOND, start_time, GETDATE())/(percent_complete/100) -  DATEDIFF(SECOND, start_time, GETDATE()),GETDATE())AS est_end_time,
       *
FROM sys.dm_exec_requests
WHERE percent_complete <> 0
ORDER BY pc DESC;