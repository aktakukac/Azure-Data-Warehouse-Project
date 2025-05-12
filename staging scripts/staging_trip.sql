IF OBJECT_ID('dbo.staging_trip') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[staging_trip];
END

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 STRING_DELIMITER = '"',
			 FIRST_ROW = 2,
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacityfs_udacityaccount_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [udacityfs_udacityaccount_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://udacityfs@udacityaccount.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.staging_trip (
	[trip_id] nvarchar(200),
	[trip_rideable_type] nvarchar(200),
	[trip_start] nvarchar(200),
	[trip_end] nvarchar(200),
	[start_station_id] nvarchar(200),
	[end_station_id] nvarchar(200),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'public.trip.txt',
	DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_trip
GO