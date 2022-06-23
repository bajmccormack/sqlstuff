-- Status of VISIBLE_ONLINE means the CPU is use by SQL Server
SELECT scheduler_id, cpu_id, status, is_online FROM sys.dm_os_schedulers