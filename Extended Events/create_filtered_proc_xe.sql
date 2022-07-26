
CREATE EVENT SESSION [usp_update check] ON SERVER 
ADD EVENT sqlserver.module_start(
ACTION(sqlserver.database_id,sqlserver.database_name,sqlserver.server_instance_name,sqlserver.session_id,sqlserver.session_nt_username,sqlserver.sql_text)
    WHERE ([object_name]=N'usp_update'))

ALTER EVENT SESSION [usp_update check] ON SERVER 
ADD EVENT sqlserver.module_end(
ACTION(sqlserver.database_id,sqlserver.database_name,sqlserver.server_instance_name,sqlserver.session_id,sqlserver.session_nt_username,sqlserver.sql_text)
    WHERE ([object_name]=N'usp_update'))