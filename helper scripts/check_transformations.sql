SELECT COUNT(*) AS rownum, 'FACT_payment' AS table_name
 FROM [dbo].[FACT_payment]
 UNION

SELECT COUNT(*) AS rownum, 'FACT_trip' AS table_name
 FROM [dbo].[FACT_trip]
 UNION

 SELECT COUNT(*) AS rownum, 'dim_date' AS table_name
 FROM [dbo].[dim_date]
 UNION

 SELECT COUNT(*) AS rownum, 'dim_rider' AS table_name
 FROM [dbo].[dim_rider]
UNION

 SELECT COUNT(*) AS rownum, 'dim_station' AS table_name
 FROM [dbo].[dim_station]