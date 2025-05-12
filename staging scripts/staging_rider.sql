IF OBJECT_ID('dbo.staging_rider') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[staging_rider];
END

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 FIRST_ROW = 2,
			 STRING_DELIMITER = '"',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacityfs_udacityaccount_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [udacityfs_udacityaccount_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://udacityfs@udacityaccount.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.staging_rider (
	[rider_id] bigint,
	[rider_address] nvarchar(200),
	[rider_firstname] nvarchar(200),
	[rider_lastname] nvarchar(200),
	[rider_birthday] nvarchar(200),
	[rider_account_start] nvarchar(200),
	[rider_account_end] nvarchar(200),
	[rider_member] bit
	)
	WITH (
	LOCATION = 'public.rider.txt',
	DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_rider
GO