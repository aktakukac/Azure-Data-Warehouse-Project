IF OBJECT_ID('dbo.dim_date') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_date];
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

CREATE EXTERNAL TABLE dbo.dim_date
WITH (
    LOCATION     = 'dim_date',
    DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT CONCAT(b.date_year, b.date_month, b.date_day) as date_id, 
	b.*
FROM (
	SELECT 
		a.date_date,
		FORMAT(DAY(a.date_date), '00') AS date_day,
		FORMAT(MONTH(a.date_date), '00') AS date_month,
		FORMAT(YEAR(a.date_date), '0000') AS date_year
	FROM (
		SELECT DISTINCT CAST(dt.trip_start AS DATE) AS date_date
		FROM dbo.staging_trip AS dt
	) AS a
	) AS b;
GO

SELECT TOP 100 * FROM dbo.dim_date