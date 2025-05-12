SELECT COUNT(*) AS rownum, 'staging_payment' AS table_name
 FROM [dbo].[staging_payment]
 UNION

SELECT COUNT(*) AS rownum, 'staging_rider' AS table_name
 FROM [dbo].[staging_rider]
 UNION

 SELECT COUNT(*) AS rownum, 'staging_station' AS table_name
 FROM [dbo].[staging_station]
 UNION

 SELECT COUNT(*) AS rownum, 'staging_trip' AS table_name
 FROM [dbo].[staging_trip]