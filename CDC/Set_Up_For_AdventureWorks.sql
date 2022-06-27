-- Allow change tracking
USE [master]
GO
ALTER DATABASE [AdventureWorks2014] SET CHANGE_TRACKING = ON;
ALTER DATABASE [AdventureWorks2014] SET RECOVERY FULL;
GO


-- Change context
USE AdventureWorks2014

EXEC sys.sp_cdc_enable_db		-- Enable CDC for DB in context (Creates the change data capture objects that have database wide scope, including meta data tables and DDL triggers.)

-- Set up the required agent jobs
EXEC sys.sp_cdc_add_job 
	  @job_type = 'capture'  
     ,@start_job = 1			-- Flag indicating whether the job should be started immediately after it is added. start_job is bit with a default of 1.
     ,@maxtrans = 500			-- Maximum number of transactions to process in each scan cycle. max_trans is int with a default of 500. If specified, the value must be a positive integer. (Only valid for capture jobs)
     ,@maxscans = 10			-- Maximum number of scan cycles to execute in order to extract all rows from the log. max_scans is int with a default of 10. (Only valid for capture jobs)
	 ,@continuous = 1			-- Indicates whether the capture job is to run continuously (1), or run only once (0). Continuous is bit with a default of 1. (Only valid for capture jobs)
     ,@pollinginterval = 5		-- Number of seconds between log scan cycles. polling_interval is bigint with a default of 5. (Only valid for capture jobs AND when continuous is set to 1)

EXEC sys.sp_cdc_add_job 
	  @job_type = 'cleanup'  
     ,@start_job = 1			-- Flag indicating whether the job should be started immediately after it is added. start_job is bit with a default of 1.
     ,@retention = 4320			-- Number of minutes that change data rows are to be retained in change tables. Retention is bigint with a default of 4320 (72 hours). The maximum value is 52494800 (100 years). (Only valid for cleanup jobs)
	 ,@threshold = 5000			-- (Only valid for cleanup jobs)

-- Lets add our first table
EXEC sys.sp_cdc_enable_table  
    @source_schema = N'HumanResources'			-- Source Schema 
  , @source_name = N'Department'				-- Source Table
  , @role_name = N'cdc_admin'					-- Role to be used. If not exists, will be created as long as caller has privileges to create a role
  , @capture_instance = N'HR_Department'		-- If not specified, the name is derived from the source schema name plus the source table name in the format schemaname_sourcename. capture_instance cannot exceed 100 characters and must be unique within the database.
  , @supports_net_changes = 1					-- Bit with a default of 1 if the table has a primary key or unique index that has been identified by using the @index_name parameter. Otherwise, the parameter defaults to 0.
  , @index_name = N'PK_Department_DepartmentID'	-- I'm using PK here, but you could also use a unique index
  , @captured_column_list = NULL				-- nvarchar(max) and can be NULL. Identifies the source table columns that are to be included in the change table. If NULL, all columns are included in the change table.
  , @filegroup_name = N'PRIMARY';				-- If NULL, the default filegroup is used. MS recommend creating a separate filegroup for change data capture change tables.
-- @allow_partition_switch = 1					-- Always 1 for non partitioned tables. 1 is also recommended for partitioned tables.
  
  SELECT * FROM HumanResources.Department
  SELECT * FROM cdc.HR_Department_CT
  UPDATE HumanResources.Department SET Name = N'Sales Operations' WHERE Name = N'Sales'

  SELECT * FROM HumanResources.Department
  SELECT * FROM cdc.HR_Department_CT

  INSERT INTO HumanResources.Department (Name,GroupName, ModifiedDate)
  VALUES (N'Data Science',N'Executive General and Administration',GETDATE())
  SELECT * FROM HumanResources.Department
  SELECT * FROM cdc.HR_Department_CT

  -- Ensure you have backups running. For non prod, you can backup to NUL if you won't use them, but they are needed to keep a conrol over the transaction log.


  /*
  I'm thinking about
  */