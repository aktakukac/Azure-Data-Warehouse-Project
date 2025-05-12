IF OBJECT_ID('dbo.fact_trip') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[fact_trip];
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

CREATE EXTERNAL TABLE dbo.FACT_trip
WITH (
    LOCATION     = 'fact_trip',
    DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT tr.trip_id,
    CONCAT(
        FORMAT(YEAR(tr.trip_start), '0000'),
        FORMAT(MONTH(tr.trip_start), '00'),
        FORMAT(DAY(tr.trip_start), '00')
    ) AS date_id,
    tr.rider_id,
    tr.start_station_id,
    tr.end_station_id,
    tr.trip_start,
    tr.trip_end,
    DATEDIFF(MINUTE, tr.trip_start, tr.trip_end) AS trip_duration,
    DATEDIFF(YEAR, CAST(rd.rider_birthday AS DATE), tr.trip_start) AS trip_rider_age,
    tr.trip_rideable_type
FROM dbo.staging_trip AS tr
LEFT JOIN dbo.staging_rider AS rd ON tr.rider_id = rd.rider_id;
GO

SELECT TOP 100 * FROM dbo.fact_trip